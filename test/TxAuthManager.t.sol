// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase, gas-small-strings
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";
import "../src/core/TxAuthManager.sol";
import "../src/core/TxAuthManagerBase.sol";
import {IAuthExtensionVerifier} from "../src/core/IAuthExtensionVerifier.sol";
import {Account as AuthAccount, TxAuthState, AuthType} from "../src/proto/cross/core/auth/Auth.sol";
import {GoogleProtobufAny} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";

contract MockValidVerifier is IAuthExtensionVerifier {
    function verify(bytes32, AuthAccount.Data calldata, bytes calldata) external view override returns (bool) {
        return true;
    }
}

contract MockInvalidVerifier is IAuthExtensionVerifier {
    function verify(bytes32, AuthAccount.Data calldata, bytes calldata) external view override returns (bool) {
        return false;
    }
}

contract MockRevertingVerifier is IAuthExtensionVerifier {
    function verify(bytes32, AuthAccount.Data calldata, bytes calldata) external view override returns (bool) {
        revert("MockRevertingVerifier: Staticcall failed");
    }
}

contract TxAuthManagerHarness is TxAuthManager {
    constructor(string[] memory typeUrls, IAuthExtensionVerifier[] memory verifiers)
        TxAuthManager(typeUrls, verifiers)
    {}

    function exposed_initAuthState(bytes32 txID, AuthAccount.Data[] memory signers) public {
        initAuthState(txID, signers);
    }

    function exposed_isCompletedAuth(bytes32 txID) public view returns (bool) {
        return isCompletedAuth(txID);
    }

    function exposed_sign(bytes32 txID, AuthAccount.Data[] memory signers) public returns (bool) {
        return sign(txID, signers);
    }

    function exposed_getAuthState(bytes32 txID) public view returns (TxAuthState.Data memory) {
        return getAuthState(txID);
    }

    function exposed_accountKey(AuthAccount.Data memory a) public pure returns (bytes32) {
        return _accountKey(a);
    }

    function exposed_getRemainingSigners(bytes32 txID) public view returns (AuthAccount.Data[] memory out) {
        CrossStore.AuthStorage storage s = _getAuthStorage();
        return _getRemainingSigners(s, txID);
    }

    function exposed_verifySignatures(
        bytes32 txIDHash,
        AuthAccount.Data[] calldata signers,
        bytes[] calldata signatures
    ) public view {
        _verifySignatures(txIDHash, signers, signatures);
    }

    function exposed_setStateFromRemainingList(bytes32 txID, AuthAccount.Data[] memory signers) public {
        CrossStore.AuthStorage storage s = _getAuthStorage();
        _setStateFromRemainingList(s, txID, signers);
    }
}

contract TxAuthManagerTest is Test {
    TxAuthManagerHarness private harness;
    bytes32 private txID = keccak256("test_tx_id");

    // Auth Types
    AuthType.Data private localAuthType;
    AuthType.Data private extAuthTypeValid;
    AuthType.Data private extAuthTypeInvalid;
    AuthType.Data private extAuthTypeReverting;
    AuthType.Data private extAuthTypeNotFound;

    // Signer Accounts
    AuthAccount.Data private signerA;
    AuthAccount.Data private signerB;
    AuthAccount.Data private signerC;
    AuthAccount.Data private extSignerAValid;
    AuthAccount.Data private extSignerBValid;
    AuthAccount.Data private extSignerInvalid;
    AuthAccount.Data private extSignerReverting;
    AuthAccount.Data private extSignerNotFound;

    // Verifier URLs
    string private constant URL_VALID = "/verifier/valid";
    string private constant URL_INVALID = "/verifier/invalid";
    string private constant URL_REVERTING = "/verifier/reverting";
    string private constant URL_NOT_FOUND = "/verifier/notfound";

    function setUp() public {
        // 1. Deploy Mock Verifiers
        MockValidVerifier validVerifier = new MockValidVerifier();
        MockInvalidVerifier invalidVerifier = new MockInvalidVerifier();
        MockRevertingVerifier revertingVerifier = new MockRevertingVerifier();

        // 2. Setup Verifier Arrays
        string[] memory typeUrls = new string[](3);
        typeUrls[0] = URL_VALID;
        typeUrls[1] = URL_INVALID;
        typeUrls[2] = URL_REVERTING;

        IAuthExtensionVerifier[] memory verifiers = new IAuthExtensionVerifier[](3);
        verifiers[0] = IAuthExtensionVerifier(validVerifier);
        verifiers[1] = IAuthExtensionVerifier(invalidVerifier);
        verifiers[2] = IAuthExtensionVerifier(revertingVerifier);

        // 3. Deploy Harness
        harness = new TxAuthManagerHarness(typeUrls, verifiers);

        // 4. Setup Auth Types
        GoogleProtobufAny.Data memory emptyAny = GoogleProtobufAny.Data({type_url: "", value: ""});
        localAuthType = AuthType.Data({mode: AuthType.AuthMode.AUTH_MODE_LOCAL, option: emptyAny});

        extAuthTypeValid = AuthType.Data({
            mode: AuthType.AuthMode.AUTH_MODE_EXTENSION,
            option: GoogleProtobufAny.Data({type_url: URL_VALID, value: ""})
        });
        extAuthTypeInvalid = AuthType.Data({
            mode: AuthType.AuthMode.AUTH_MODE_EXTENSION,
            option: GoogleProtobufAny.Data({type_url: URL_INVALID, value: ""})
        });
        extAuthTypeReverting = AuthType.Data({
            mode: AuthType.AuthMode.AUTH_MODE_EXTENSION,
            option: GoogleProtobufAny.Data({type_url: URL_REVERTING, value: ""})
        });
        extAuthTypeNotFound = AuthType.Data({
            mode: AuthType.AuthMode.AUTH_MODE_EXTENSION,
            option: GoogleProtobufAny.Data({type_url: URL_NOT_FOUND, value: ""})
        });

        // 5. Setup Signer Accounts
        signerA = AuthAccount.Data({id: bytes("signerA"), auth_type: localAuthType});
        signerB = AuthAccount.Data({id: bytes("signerB"), auth_type: localAuthType});
        signerC = AuthAccount.Data({id: bytes("signerC"), auth_type: localAuthType});

        extSignerAValid = AuthAccount.Data({id: bytes("extSignerA"), auth_type: extAuthTypeValid});
        extSignerBValid = AuthAccount.Data({id: bytes("extSignerB"), auth_type: extAuthTypeValid});
        extSignerInvalid = AuthAccount.Data({id: bytes("extSignerInvalid"), auth_type: extAuthTypeInvalid});
        extSignerReverting = AuthAccount.Data({id: bytes("extSignerReverting"), auth_type: extAuthTypeReverting});
        extSignerNotFound = AuthAccount.Data({id: bytes("extSignerNotFound"), auth_type: extAuthTypeNotFound});
    }

    function test_initAuthState_Succeeds() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](2);
        signers[0] = signerA;
        signers[1] = signerB;

        harness.exposed_initAuthState(txID, signers);
    }

    function test_initAuthState_RevertWhen_AlreadyInitialized() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](1);
        signers[0] = signerA;

        harness.exposed_initAuthState(txID, signers); // First time

        vm.expectRevert(abi.encodeWithSelector(TxAuthManagerBase.AuthStateAlreadyInitialized.selector, txID));
        harness.exposed_initAuthState(txID, signers); // Second time
    }

    function test_initAuthState_HandlesDuplicateSigners() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](3);
        signers[0] = signerA;
        signers[1] = signerB;
        signers[2] = signerA; // Duplicate

        harness.exposed_initAuthState(txID, signers);

        TxAuthState.Data memory state = harness.exposed_getAuthState(txID);
        assertEq(state.remaining_signers.length, 2, "Duplicate signers should be counted once");
    }

    function test_isCompletedAuth_ReturnsTrueWhenCompleted() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](1);
        signers[0] = signerA;
        harness.exposed_initAuthState(txID, signers);

        harness.exposed_sign(txID, signers);

        assertTrue(harness.exposed_isCompletedAuth(txID), "Should return true when auth is completed");
    }

    function test_isCompletedAuth_ReturnsFalseWhenNotCompleted() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](2);
        signers[0] = signerA;
        signers[1] = signerB;
        harness.exposed_initAuthState(txID, signers);

        AuthAccount.Data[] memory partialSigners = new AuthAccount.Data[](1);
        partialSigners[0] = signerA;
        harness.exposed_sign(txID, partialSigners);

        assertFalse(harness.exposed_isCompletedAuth(txID), "Should return false when auth is not completed");
    }

    function test_isCompletedAuth_RevertWhen_NotInitialized() public {
        vm.expectRevert(abi.encodeWithSelector(TxAuthManagerBase.IDNotFound.selector, txID));
        harness.exposed_isCompletedAuth(txID);
    }

    function test_sign_PartialSignReturnsFalse() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](2);
        signers[0] = signerA;
        signers[1] = signerB;
        harness.exposed_initAuthState(txID, signers);

        AuthAccount.Data[] memory partialSigners = new AuthAccount.Data[](1);
        partialSigners[0] = signerA;

        assertFalse(harness.exposed_sign(txID, partialSigners), "Should not be completed");
    }

    function test_sign_FinalSignReturnsTrue() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](2);
        signers[0] = signerA;
        signers[1] = signerB;
        harness.exposed_initAuthState(txID, signers);

        AuthAccount.Data[] memory partialSigners = new AuthAccount.Data[](1);
        partialSigners[0] = signerA;
        assertFalse(harness.exposed_sign(txID, partialSigners), "Should not be completed"); // Sign A

        partialSigners[0] = signerB;

        assertTrue(harness.exposed_sign(txID, partialSigners), "Should be completed"); // Sign B
    }

    function test_sign_IgnoresUnknownSigners() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](1);
        signers[0] = signerA;
        harness.exposed_initAuthState(txID, signers);

        AuthAccount.Data[] memory unknownSigners = new AuthAccount.Data[](1);
        unknownSigners[0] = signerB; // Not required, but has same auth_type

        assertFalse(harness.exposed_sign(txID, unknownSigners), "Should not be completed");
    }

    function test_sign_RevertWhen_NotInitialized() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](1);
        signers[0] = signerA;

        vm.expectRevert(abi.encodeWithSelector(TxAuthManagerBase.IDNotFound.selector, txID));
        harness.exposed_sign(txID, signers);
    }

    function test_sign_RevertWhen_AuthAlreadyCompleted() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](1);
        signers[0] = signerA;
        harness.exposed_initAuthState(txID, signers);

        assertTrue(harness.exposed_sign(txID, signers), "Should be completed"); // First sign

        vm.expectRevert(abi.encodeWithSelector(TxAuthManagerBase.AuthAlreadyCompleted.selector, txID));
        harness.exposed_sign(txID, signers); // Sign again
    }

    function test_getAuthState_ReturnsCorrectRemainingSigners() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](3);
        signers[0] = signerA;
        signers[1] = signerB;
        signers[2] = signerC;
        harness.exposed_initAuthState(txID, signers);

        // Sign with B
        AuthAccount.Data[] memory partialSigners = new AuthAccount.Data[](1);
        partialSigners[0] = signerB;
        assertFalse(harness.exposed_sign(txID, partialSigners), "Should not be completed");

        TxAuthState.Data memory state = harness.exposed_getAuthState(txID);

        assertEq(state.remaining_signers.length, 2, "Should have 2 remaining signers");
        assertEq(state.remaining_signers[0].id, signerA.id, "Signer A should remain");
        assertEq(state.remaining_signers[1].id, signerC.id, "Signer C should remain");
    }

    function test_getAuthState_RevertWhen_NotInitialized() public {
        vm.expectRevert(abi.encodeWithSelector(TxAuthManagerBase.IDNotFound.selector, txID));
        harness.exposed_getAuthState(txID);
    }

    function test_accountKey_GeneratesUniqueKeys() public {
        bytes32 keyA = harness.exposed_accountKey(signerA);
        bytes32 keyB = harness.exposed_accountKey(signerB);
        assertNotEq(keyA, keyB, "Different IDs should produce different keys");

        AuthAccount.Data memory signerAAltAuth = AuthAccount.Data({id: signerA.id, auth_type: extAuthTypeValid});
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

        harness.exposed_setStateFromRemainingList(txID, signers);

        AuthAccount.Data[] memory remaining = harness.exposed_getRemainingSigners(txID);

        assertEq(remaining.length, 2, "getRemainingSigners should return 2 signers after deduplication");
        assertEq(remaining[0].id, signerA.id, "Signer A should be in remaining list");
        assertEq(remaining[1].id, signerB.id, "Signer B should be in remaining list");
    }

    function test_getRemainingSigners_ReturnsRemains() public {
        AuthAccount.Data[] memory allSigners = new AuthAccount.Data[](3);
        allSigners[0] = signerA;
        allSigners[1] = signerB;
        allSigners[2] = signerC;
        harness.exposed_initAuthState(txID, allSigners);

        AuthAccount.Data[] memory partialSigners = new AuthAccount.Data[](1);
        partialSigners[0] = signerB;
        assertFalse(harness.exposed_sign(txID, partialSigners), "Should not be completed"); // Sign B

        AuthAccount.Data[] memory remaining = harness.exposed_getRemainingSigners(txID);

        assertEq(remaining.length, 2, "getRemainingSigners should return 2 signers");
        assertEq(remaining[0].id, signerA.id, "Signer A should remain");
        assertEq(remaining[1].id, signerC.id, "Signer C should remain");

        partialSigners[0] = signerA;
        assertFalse(harness.exposed_sign(txID, partialSigners), "Should not be completed"); // Sign A

        remaining = harness.exposed_getRemainingSigners(txID);
        assertEq(remaining.length, 1, "getRemainingSigners should return 1 signer");
        assertEq(remaining[0].id, signerC.id, "Signer C should remain");

        partialSigners[0] = signerC;
        assertTrue(harness.exposed_sign(txID, partialSigners), "Should be completed"); // Sign C

        remaining = harness.exposed_getRemainingSigners(txID);
        assertEq(remaining.length, 0, "getRemainingSigners should return 0 signers");
    }

    function test_verifySignatures_SucceedsSingleSigner() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](1);
        signers[0] = extSignerAValid;

        bytes[] memory signatures = new bytes[](1);
        signatures[0] = bytes("dummy_sig_A");

        harness.exposed_verifySignatures(txID, signers, signatures);
    }

    function test_verifySignatures_SucceedsMultipleSigners() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](2);
        signers[0] = extSignerAValid;
        signers[1] = extSignerBValid;

        bytes[] memory signatures = new bytes[](2);
        signatures[0] = bytes("dummy_sig_A");
        signatures[1] = bytes("dummy_sig_B");

        harness.exposed_verifySignatures(txID, signers, signatures);
    }

    function test_verifySignatures_RevertWhen_SignerSignatureMismatch() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](1);
        signers[0] = extSignerAValid;

        bytes[] memory signatures = new bytes[](0);

        vm.expectRevert(abi.encodeWithSelector(TxAuthManagerBase.SignerCountMismatch.selector, 1, 0));
        harness.exposed_verifySignatures(txID, signers, signatures);
    }

    function test_verifySignatures_RevertWhen_TooManySigners() public {
        uint256 count = 33;

        AuthAccount.Data[] memory signers = new AuthAccount.Data[](count);
        bytes[] memory signatures = new bytes[](count);

        for (uint256 i = 0; i < count; ++i) {
            signers[i] = extSignerAValid;
            signatures[i] = bytes("dummy_sig");
        }

        vm.expectRevert(abi.encodeWithSelector(TxAuthManagerBase.TooManySigners.selector, count, 32));
        harness.exposed_verifySignatures(txID, signers, signatures);
    }

    function test_verifySignatures_RevertWhen_AuthModeMismatch() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](1);
        signers[0] = signerA;

        bytes[] memory signatures = new bytes[](1);
        signatures[0] = bytes("dummy_sig");

        vm.expectRevert(TxAuthManagerBase.AuthModeMismatch.selector);
        harness.exposed_verifySignatures(txID, signers, signatures);
    }

    function test_verifySignatures_RevertWhen_VerifierNotFound() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](1);
        signers[0] = extSignerNotFound;

        bytes[] memory signatures = new bytes[](1);
        signatures[0] = bytes("dummy_sig");

        vm.expectRevert(abi.encodeWithSelector(TxAuthManagerBase.VerifierNotFound.selector, URL_NOT_FOUND));
        harness.exposed_verifySignatures(txID, signers, signatures);
    }

    function test_verifySignatures_RevertWhen_StaticCallFails() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](1);
        signers[0] = extSignerReverting;

        bytes[] memory signatures = new bytes[](1);
        signatures[0] = bytes("dummy_sig");

        vm.expectRevert(abi.encodeWithSelector(TxAuthManagerBase.VerifierStaticCallFailed.selector, URL_REVERTING));
        harness.exposed_verifySignatures(txID, signers, signatures);
    }

    function test_verifySignatures_RevertWhen_VerifierReturnsFalse() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](1);
        signers[0] = extSignerInvalid;

        bytes[] memory signatures = new bytes[](1);
        signatures[0] = bytes("dummy_sig");

        vm.expectRevert(abi.encodeWithSelector(TxAuthManagerBase.VerifierReturnedFalse.selector, txID, URL_INVALID));
        harness.exposed_verifySignatures(txID, signers, signatures);
    }
}
