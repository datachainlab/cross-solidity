// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase, gas-small-strings
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";
import "../src/core/TxAuthManager.sol";
import "../src/core/TxAuthManagerBase.sol";
import {Account as AuthAccount, TxAuthState, AuthType} from "../src/proto/cross/core/auth/Auth.sol";
import {GoogleProtobufAny} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";

contract TxAuthManagerHarness is TxAuthManager {
    function exposed_initAuthState(bytes32 txId, AuthAccount.Data[] memory signers) public {
        initAuthState(txId, signers);
    }

    function exposed_isCompletedAuth(bytes32 txId) public view returns (bool) {
        return isCompletedAuth(txId);
    }

    function exposed_sign(bytes32 txId, AuthAccount.Data[] memory signers) public returns (bool) {
        return sign(txId, signers);
    }

    function exposed_getAuthState(bytes32 txId) public view returns (TxAuthState.Data memory) {
        return getAuthState(txId);
    }

    function exposed_accountKey(AuthAccount.Data memory a) public pure returns (bytes32) {
        return _accountKey(a);
    }

    function exposed_getRemainingSigners(bytes32 txId) public view returns (AuthAccount.Data[] memory out) {
        CoreStore.AuthStorage storage s = _getAuthStorage();
        return _getRemainingSigners(s, txId);
    }

    function exposed_setStateFromRemainingList(bytes32 txId, AuthAccount.Data[] memory signers) public {
        CoreStore.AuthStorage storage s = _getAuthStorage();
        _setStateFromRemainingList(s, txId, signers);
    }
}

contract TxAuthManagerTest is Test {
    TxAuthManagerHarness private harness;
    bytes32 private txId = keccak256("test_tx_id");
    AuthAccount.Data private signerA;
    AuthAccount.Data private signerB;
    AuthAccount.Data private signerC;
    AuthType.Data private localAuthType;
    AuthType.Data private channelAuthType;

    function setUp() public {
        harness = new TxAuthManagerHarness();

        GoogleProtobufAny.Data memory emptyAny = GoogleProtobufAny.Data({type_url: "", value: ""});
        localAuthType = AuthType.Data({mode: AuthType.AuthMode.AUTH_MODE_LOCAL, option: emptyAny});

        channelAuthType = AuthType.Data({mode: AuthType.AuthMode.AUTH_MODE_EXTENSION, option: emptyAny});

        signerA = AuthAccount.Data({id: bytes("signerA"), auth_type: localAuthType});
        signerB = AuthAccount.Data({id: bytes("signerB"), auth_type: localAuthType});
        signerC = AuthAccount.Data({id: bytes("signerC"), auth_type: localAuthType});
    }

    function test_initAuthState_Succeeds() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](2);
        signers[0] = signerA;
        signers[1] = signerB;

        harness.exposed_initAuthState(txId, signers);
    }

    function test_initAuthState_RevertWhen_AlreadyInitialized() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](1);
        signers[0] = signerA;

        harness.exposed_initAuthState(txId, signers); // First time

        vm.expectRevert(abi.encodeWithSelector(TxAuthManagerBase.AuthStateAlreadyInitialized.selector, txId));
        harness.exposed_initAuthState(txId, signers); // Second time
    }

    function test_initAuthState_HandlesDuplicateSigners() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](3);
        signers[0] = signerA;
        signers[1] = signerB;
        signers[2] = signerA; // Duplicate

        harness.exposed_initAuthState(txId, signers);

        TxAuthState.Data memory state = harness.exposed_getAuthState(txId);
        assertEq(state.remaining_signers.length, 2, "Duplicate signers should be counted once");
    }

    function test_isCompletedAuth_ReturnsTrueWhenCompleted() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](1);
        signers[0] = signerA;
        harness.exposed_initAuthState(txId, signers);

        harness.exposed_sign(txId, signers);

        assertTrue(harness.exposed_isCompletedAuth(txId), "Should return true when auth is completed");
    }

    function test_isCompletedAuth_ReturnsFalseWhenNotCompleted() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](2);
        signers[0] = signerA;
        signers[1] = signerB;
        harness.exposed_initAuthState(txId, signers);

        AuthAccount.Data[] memory partialSigners = new AuthAccount.Data[](1);
        partialSigners[0] = signerA;
        harness.exposed_sign(txId, partialSigners);

        assertFalse(harness.exposed_isCompletedAuth(txId), "Should return false when auth is not completed");
    }

    function test_isCompletedAuth_RevertWhen_NotInitialized() public {
        vm.expectRevert(abi.encodeWithSelector(TxAuthManagerBase.IDNotFound.selector, txId));
        harness.exposed_isCompletedAuth(txId);
    }

    function test_sign_PartialSignReturnsFalse() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](2);
        signers[0] = signerA;
        signers[1] = signerB;
        harness.exposed_initAuthState(txId, signers);

        AuthAccount.Data[] memory partialSigners = new AuthAccount.Data[](1);
        partialSigners[0] = signerA;

        assertFalse(harness.exposed_sign(txId, partialSigners), "Should not be completed");
    }

    function test_sign_FinalSignReturnsTrue() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](2);
        signers[0] = signerA;
        signers[1] = signerB;
        harness.exposed_initAuthState(txId, signers);

        AuthAccount.Data[] memory partialSigners = new AuthAccount.Data[](1);
        partialSigners[0] = signerA;
        assertFalse(harness.exposed_sign(txId, partialSigners), "Should not be completed"); // Sign A

        partialSigners[0] = signerB;

        assertTrue(harness.exposed_sign(txId, partialSigners), "Should be completed"); // Sign B
    }

    function test_sign_IgnoresUnknownSigners() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](1);
        signers[0] = signerA;
        harness.exposed_initAuthState(txId, signers);

        AuthAccount.Data[] memory unknownSigners = new AuthAccount.Data[](1);
        unknownSigners[0] = signerB; // Not required, but has same auth_type

        assertFalse(harness.exposed_sign(txId, unknownSigners), "Should not be completed");
    }

    function test_sign_RevertWhen_NotInitialized() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](1);
        signers[0] = signerA;

        vm.expectRevert(abi.encodeWithSelector(TxAuthManagerBase.IDNotFound.selector, txId));
        harness.exposed_sign(txId, signers);
    }

    function test_sign_RevertWhen_AuthAlreadyCompleted() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](1);
        signers[0] = signerA;
        harness.exposed_initAuthState(txId, signers);

        assertTrue(harness.exposed_sign(txId, signers), "Should be completed"); // First sign

        vm.expectRevert(abi.encodeWithSelector(TxAuthManagerBase.AuthAlreadyCompleted.selector, txId));
        harness.exposed_sign(txId, signers); // Sign again
    }

    function test_getAuthState_ReturnsCorrectRemainingSigners() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](3);
        signers[0] = signerA;
        signers[1] = signerB;
        signers[2] = signerC;
        harness.exposed_initAuthState(txId, signers);

        // Sign with B
        AuthAccount.Data[] memory partialSigners = new AuthAccount.Data[](1);
        partialSigners[0] = signerB;
        assertFalse(harness.exposed_sign(txId, partialSigners), "Should not be completed");

        TxAuthState.Data memory state = harness.exposed_getAuthState(txId);

        assertEq(state.remaining_signers.length, 2, "Should have 2 remaining signers");
        assertEq(state.remaining_signers[0].id, signerA.id, "Signer A should remain");
        assertEq(state.remaining_signers[1].id, signerC.id, "Signer C should remain");
    }

    function test_getAuthState_RevertWhen_NotInitialized() public {
        vm.expectRevert(abi.encodeWithSelector(TxAuthManagerBase.IDNotFound.selector, txId));
        harness.exposed_getAuthState(txId);
    }

    function test_accountKey_GeneratesUniqueKeys() public {
        bytes32 keyA = harness.exposed_accountKey(signerA);
        bytes32 keyB = harness.exposed_accountKey(signerB);
        assertNotEq(keyA, keyB, "Different IDs should produce different keys");

        AuthAccount.Data memory signerAAltAuth = AuthAccount.Data({id: signerA.id, auth_type: channelAuthType});
        bytes32 keyAAltAuth = harness.exposed_accountKey(signerAAltAuth);
        assertNotEq(keyA, keyAAltAuth, "Different auth_types should produce different keys");

        AuthAccount.Data memory signerACopy = AuthAccount.Data({id: bytes("signerA"), auth_type: localAuthType});
        bytes32 keyACopy = harness.exposed_accountKey(signerACopy);
        assertEq(keyA, keyACopy, "Identical accounts should produce the same key");
    }

    function test_setStateFromRemainingList_HandlesDuplicatesAndReturnsRemains() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](3);
        signers[0] = signerA;
        signers[1] = signerB;
        signers[2] = signerA; // Duplicate

        harness.exposed_setStateFromRemainingList(txId, signers);

        AuthAccount.Data[] memory remaining = harness.exposed_getRemainingSigners(txId);

        assertEq(remaining.length, 2, "getRemainingSigners should return 2 signers after deduplication");
        assertEq(remaining[0].id, signerA.id, "Signer A should be in remaining list");
        assertEq(remaining[1].id, signerB.id, "Signer B should be in remaining list");
    }

    function test_getRemainingSigners_ReturnsRemains() public {
        AuthAccount.Data[] memory allSigners = new AuthAccount.Data[](3);
        allSigners[0] = signerA;
        allSigners[1] = signerB;
        allSigners[2] = signerC;
        harness.exposed_initAuthState(txId, allSigners);

        AuthAccount.Data[] memory partialSigners = new AuthAccount.Data[](1);
        partialSigners[0] = signerB;
        assertFalse(harness.exposed_sign(txId, partialSigners), "Should not be completed"); // Sign B

        AuthAccount.Data[] memory remaining = harness.exposed_getRemainingSigners(txId);

        assertEq(remaining.length, 2, "getRemainingSigners should return 2 signers");
        assertEq(remaining[0].id, signerA.id, "Signer A should remain");
        assertEq(remaining[1].id, signerC.id, "Signer C should remain");

        partialSigners[0] = signerA;
        assertFalse(harness.exposed_sign(txId, partialSigners), "Should not be completed"); // Sign A

        remaining = harness.exposed_getRemainingSigners(txId);
        assertEq(remaining.length, 1, "getRemainingSigners should return 1 signer");
        assertEq(remaining[0].id, signerC.id, "Signer C should remain");

        partialSigners[0] = signerC;
        assertTrue(harness.exposed_sign(txId, partialSigners), "Should be completed"); // Sign C

        remaining = harness.exposed_getRemainingSigners(txId);
        assertEq(remaining.length, 0, "getRemainingSigners should return 0 signers");
    }
}
