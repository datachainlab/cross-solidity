// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase, var-name-mixedcase, gas-small-strings
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";
import "../src/core/Authenticator.sol";
import {TxManagerBase} from "../src/core/TxManagerBase.sol";
import {TxAuthManagerBase} from "../src/core/TxAuthManagerBase.sol";

import {MsgInitiateTx} from "../src/proto/cross/core/initiator/Initiator.sol";
import {IAuthenticator} from "../src/core/IAuthenticator.sol";
import {ICrossError} from "../src/core/ICrossError.sol";
import {
    Account as AuthAccount,
    AuthType,
    TxAuthState,
    MsgSignTx,
    MsgSignTxResponse,
    MsgExtSignTx,
    QueryTxAuthStateRequest,
    QueryTxAuthStateResponse,
    GoogleProtobufAny
} from "../src/proto/cross/core/auth/Auth.sol";
import {IbcCoreClientV1Height} from "../src/proto/ibc/core/client/v1/client.sol";

contract MockTxManager is TxManagerBase {
    bytes32 public lastRunTxID;
    uint256 public runTxCount;

    function _createTx(
        bytes32,
        /*txID*/
        MsgInitiateTx.Data calldata /*src*/
    )
        internal
        virtual
        override
    {}

    function _runTxIfCompleted(bytes32 txID) internal virtual override {
        lastRunTxID = txID;
        ++runTxCount;
    }

    function _isTxRecorded(
        bytes32 /*txID*/
    )
        internal
        view
        virtual
        override
        returns (bool)
    {
        return false;
    }
}

contract MockTxAuthManager is TxAuthManagerBase {
    mapping(bytes32 => bool) public completed;
    bool private _signReturns = false;
    bool private _verifyShouldRevert = false;
    TxAuthState.Data private _mockAuthState;

    error MockVerifyError();

    function _initAuthState(
        bytes32,
        /*txID*/
        Account.Data[] memory /*signers*/
    )
        internal
        virtual
        override
    {}

    function _isCompletedAuth(
        bytes32 /*txID*/
    )
        internal
        view
        virtual
        override
        returns (bool)
    {
        return false;
    }

    function _sign(
        bytes32 txID,
        Account.Data[] memory /*signers*/
    )
        internal
        virtual
        override
        returns (bool)
    {
        if (_signReturns) {
            completed[txID] = true;
        }
        return _signReturns;
    }

    function _getAuthState(bytes32) internal view virtual override returns (TxAuthState.Data memory) {
        return _mockAuthState;
    }

    function _verifySignatures(
        bytes32,
        /*txIDHash*/
        AuthAccount.Data[] calldata
        /*signers*/
    )
        internal
        virtual
        override
    {
        if (_verifyShouldRevert) {
            revert MockVerifyError();
        }
    }

    function setSignReturns(bool returnsValue) public {
        _signReturns = returnsValue;
    }

    function setVerifyShouldRevert(bool shouldRevert) public {
        _verifyShouldRevert = shouldRevert;
    }

    function setMockAuthState(TxAuthState.Data memory state) public {
        _mockAuthState = state;
    }
}

contract AuthenticatorHarness is Authenticator, MockTxAuthManager, MockTxManager {
    function exposed_accountKey(AuthAccount.Data memory a) public pure returns (bytes32) {
        return _accountKey(a);
    }

    function exposed_getRemainingSigners(bytes32 txID) public view returns (AuthAccount.Data[] memory out) {
        CrossStore.AuthStorage storage s = _getAuthStorage();
        return _getRemainingSigners(s, txID);
    }

    function exposed_buildLocalAccounts(bytes[] calldata signerIDs) public pure returns (AuthAccount.Data[] memory) {
        return _buildLocalAccounts(signerIDs);
    }

    function setupMockAuthStorage(bytes32 txID, AuthAccount.Data[] memory required, bool[] memory isRemaining) public {
        require(required.length == isRemaining.length, "Harness: length mismatch");

        CrossStore.AuthStorage storage s = _getAuthStorage();

        s.authInitialized[txID] = true;

        delete s.requiredAccounts[txID];
        s.remainingCount[txID] = 0;

        for (uint256 i = 0; i < required.length; ++i) {
            s.requiredAccounts[txID].push(required[i]);

            bytes32 key = _accountKey(required[i]);
            s.remaining[txID][key] = isRemaining[i];

            if (isRemaining[i]) {
                ++s.remainingCount[txID];
            }
        }
    }
}

contract AuthenticatorTest is Test, ICrossError {
    AuthenticatorHarness private harness;
    MsgSignTx.Data private baseMsg;
    bytes32 private txID;
    MsgExtSignTx.Data private extMsg;
    bytes32 private extTxID;

    bytes private signerABytes = bytes("signerA");
    bytes private signerBBytes = bytes("signerB");

    function setUp() public {
        harness = new AuthenticatorHarness();

        bytes memory expectedSignerId = abi.encodePacked(address(this));

        bytes[] memory signers = new bytes[](1);
        signers[0] = expectedSignerId;

        bytes32 rawTxID = bytes32("test-tx-id");
        txID = rawTxID;

        baseMsg = MsgSignTx.Data({
            txID: abi.encodePacked(rawTxID),
            signers: signers,
            timeout_height: IbcCoreClientV1Height.Data(0, 0),
            timeout_timestamp: 0
        });

        bytes32 rawExtTxID = bytes32("ext-test-tx-id");
        extTxID = rawExtTxID;

        AuthAccount.Data[] memory extSigners = new AuthAccount.Data[](1);
        extSigners[0] = AuthAccount.Data({
            id: signerABytes,
            auth_type: AuthType.Data({
                mode: AuthType.AuthMode.AUTH_MODE_EXTENSION,
                option: GoogleProtobufAny.Data({type_url: "/verifier/test", value: ""})
            })
        });

        extMsg = MsgExtSignTx.Data({txID: abi.encodePacked(rawExtTxID), signers: extSigners});
    }

    function test_signTx_SucceedsAsPending() public {
        harness.setSignReturns(false);

        MsgSignTxResponse.Data memory resp = harness.signTx(baseMsg);
        assertFalse(resp.tx_auth_completed, "response should indicate not completed");
        assertEq(resp.log, "", "log should be empty");
        assertFalse(harness.completed(txID), "Mock: auth should not be completed");
        assertEq(harness.runTxCount(), 0, "Mock: runTxIfCompleted should not be called");
    }

    function test_signTx_SucceedsAsCompletedAndEmitsEvent() public {
        harness.setSignReturns(true);

        vm.expectEmit(true, true, false, true, address(harness));
        emit IAuthenticator.TxSigned(address(this), txID, AuthType.AuthMode.AUTH_MODE_LOCAL);

        MsgSignTxResponse.Data memory resp = harness.signTx(baseMsg);

        assertTrue(resp.tx_auth_completed, "response should indicate completed");
        assertEq(resp.log, "", "log should be empty");
        assertTrue(harness.completed(txID), "Mock: auth should be completed");
        assertEq(harness.runTxCount(), 1, "Mock: runTxIfCompleted should be called once");
        assertEq(harness.lastRunTxID(), txID, "Mock: runTxIfCompleted called with correct txID");
    }

    function test_signTx_RevertsIf_TxIDLengthInvalid() public {
        baseMsg.txID = bytes("short-id");

        vm.expectRevert(InvalidTxIDLength.selector);
        harness.signTx(baseMsg);
    }

    function test_signTx_RevertsIf_SignersLengthZero() public {
        baseMsg.signers = new bytes[](0);

        vm.expectRevert(ICrossError.InvalidSignersLength.selector);
        harness.signTx(baseMsg);
    }

    function test_signTx_RevertsIf_SignersLengthMultiple() public {
        bytes[] memory signers = new bytes[](2);
        signers[0] = signerABytes;
        signers[1] = signerBBytes;
        baseMsg.signers = signers;

        vm.expectRevert(ICrossError.InvalidSignersLength.selector);
        harness.signTx(baseMsg);
    }

    function test_signTx_RevertsIf_SignerNotEqualSender() public {
        bytes[] memory signers = new bytes[](1);
        signers[0] = abi.encodePacked(address(0x12345));
        baseMsg.signers = signers;

        vm.expectRevert(ICrossError.SignerMustEqualSender.selector);
        harness.signTx(baseMsg);
    }

    function test_extSignTx_SucceedsAsPending() public {
        harness.setSignReturns(false);
        vm.expectEmit(address(harness));
        emit IAuthenticator.TxSigned(address(this), extTxID, AuthType.AuthMode.AUTH_MODE_EXTENSION);

        MsgExtSignTxResponse.Data memory resp = harness.extSignTx(extMsg);

        assertTrue(resp.x, "response.x should be true");
        assertFalse(harness.completed(extTxID), "Mock: auth should not be completed");
        assertEq(harness.runTxCount(), 0, "Mock: runTxIfCompleted should not be called");
    }

    function test_extSignTx_SucceedsAsCompletedAndEmitsEvent() public {
        harness.setSignReturns(true);

        vm.expectEmit(address(harness));
        emit IAuthenticator.TxSigned(address(this), extTxID, AuthType.AuthMode.AUTH_MODE_EXTENSION);

        MsgExtSignTxResponse.Data memory resp = harness.extSignTx(extMsg);

        assertTrue(resp.x, "response.x should be true");
        assertTrue(harness.completed(extTxID), "Mock: auth should be completed");
        assertEq(harness.runTxCount(), 1, "Mock: runTxIfCompleted should be called once");
        assertEq(harness.lastRunTxID(), extTxID, "Mock: runTxIfCompleted called with correct txID");
    }

    function test_extSignTx_RevertsIf_TxIDLengthInvalid() public {
        extMsg.txID = new bytes(33);

        vm.expectRevert(InvalidTxIDLength.selector);
        harness.extSignTx(extMsg);
    }

    function test_extSignTx_RevertsIfVerificationFails() public {
        harness.setVerifyShouldRevert(true);

        vm.expectRevert(MockTxAuthManager.MockVerifyError.selector);
        harness.extSignTx(extMsg);
    }

    function test_txAuthState_ReturnsState() public {
        bytes32 queryTxID = bytes32("query-tx");

        AuthAccount.Data memory signerB = AuthAccount.Data({
            id: signerBBytes,
            auth_type: AuthType.Data({
                mode: AuthType.AuthMode.AUTH_MODE_LOCAL, option: GoogleProtobufAny.Data({type_url: "", value: ""})
            })
        });

        AuthAccount.Data[] memory required = new AuthAccount.Data[](1);
        required[0] = signerB;

        bool[] memory isRemaining = new bool[](1);
        isRemaining[0] = true;

        harness.setupMockAuthStorage(queryTxID, required, isRemaining);

        QueryTxAuthStateRequest.Data memory req;
        req.txID = abi.encodePacked(queryTxID);

        QueryTxAuthStateResponse.Data memory resp = harness.txAuthState(req);

        assertEq(resp.tx_auth_state.remaining_signers.length, 1, "Remaining signers length mismatch");
        assertEq(resp.tx_auth_state.remaining_signers[0].id, signerBBytes, "Remaining signer ID mismatch");
        assertEq(
            uint256(resp.tx_auth_state.remaining_signers[0].auth_type.mode),
            uint256(AuthType.AuthMode.AUTH_MODE_LOCAL),
            "Remaining signer auth mode mismatch"
        );
    }

    function test_txAuthState_RevertsIf_TxIDLengthInvalid() public {
        QueryTxAuthStateRequest.Data memory req;
        req.txID = "";

        vm.expectRevert(InvalidTxIDLength.selector);
        harness.txAuthState(req);
    }

    function test_accountKey_GeneratesDistinctKeys() public {
        AuthAccount.Data memory acc1 = AuthAccount.Data({
            id: signerABytes,
            auth_type: AuthType.Data({mode: AuthType.AuthMode.AUTH_MODE_LOCAL, option: GoogleProtobufAny.Data("", "")})
        });
        AuthAccount.Data memory acc2 = AuthAccount.Data({
            id: signerBBytes,
            auth_type: AuthType.Data({mode: AuthType.AuthMode.AUTH_MODE_LOCAL, option: GoogleProtobufAny.Data("", "")})
        });
        AuthAccount.Data memory acc3 = AuthAccount.Data({
            id: signerABytes,
            auth_type: AuthType.Data({
                mode: AuthType.AuthMode.AUTH_MODE_EXTENSION, option: GoogleProtobufAny.Data("", "")
            })
        });

        bytes32 key1 = harness.exposed_accountKey(acc1);
        bytes32 key2 = harness.exposed_accountKey(acc2);
        bytes32 key3 = harness.exposed_accountKey(acc3);
        assertNotEq(key1, key2, "Keys should be different for different IDs");
        assertNotEq(key1, key3, "Keys should be different for different AuthTypes");
    }

    function test_getRemainingSigners_AllRemaining() public {
        bytes32 testTxID = bytes32(uint256(111));

        AuthAccount.Data[] memory signers = new AuthAccount.Data[](2);
        signers[0] = AuthAccount.Data(
            signerABytes, AuthType.Data(AuthType.AuthMode.AUTH_MODE_LOCAL, GoogleProtobufAny.Data("", ""))
        );
        signers[1] = AuthAccount.Data(
            signerBBytes, AuthType.Data(AuthType.AuthMode.AUTH_MODE_LOCAL, GoogleProtobufAny.Data("", ""))
        );

        bool[] memory isRemaining = new bool[](2);
        isRemaining[0] = true;
        isRemaining[1] = true;

        harness.setupMockAuthStorage(testTxID, signers, isRemaining);

        AuthAccount.Data[] memory result = harness.exposed_getRemainingSigners(testTxID);

        assertEq(result.length, 2, "Should return all signers");
        assertEq(result[0].id, signerABytes, "First signer mismatch");
        assertEq(result[1].id, signerBBytes, "Second signer mismatch");
    }

    function test_getRemainingSigners_PartialRemaining() public {
        bytes32 testTxID = bytes32(uint256(222));

        AuthAccount.Data[] memory signers = new AuthAccount.Data[](3);
        signers[0] = AuthAccount.Data(
            signerABytes, AuthType.Data(AuthType.AuthMode.AUTH_MODE_LOCAL, GoogleProtobufAny.Data("", ""))
        );
        signers[1] = AuthAccount.Data(
            signerBBytes, AuthType.Data(AuthType.AuthMode.AUTH_MODE_LOCAL, GoogleProtobufAny.Data("", ""))
        );
        signers[2] = AuthAccount.Data(
            bytes("signerC"), AuthType.Data(AuthType.AuthMode.AUTH_MODE_LOCAL, GoogleProtobufAny.Data("", ""))
        );

        bool[] memory isRemaining = new bool[](3);
        isRemaining[0] = true; // A
        isRemaining[1] = false; // B (Signed)
        isRemaining[2] = true; // C

        harness.setupMockAuthStorage(testTxID, signers, isRemaining);

        AuthAccount.Data[] memory result = harness.exposed_getRemainingSigners(testTxID);

        assertEq(result.length, 2, "Should return 2 remaining signers");
        assertEq(result[0].id, signerABytes, "First remaining should be A");
        assertEq(result[1].id, bytes("signerC"), "Second remaining should be C");
    }

    function test_getRemainingSigners_NoneRemaining() public {
        bytes32 testTxID = bytes32(uint256(333));

        AuthAccount.Data[] memory signers = new AuthAccount.Data[](1);
        signers[0] = AuthAccount.Data(
            signerABytes, AuthType.Data(AuthType.AuthMode.AUTH_MODE_LOCAL, GoogleProtobufAny.Data("", ""))
        );

        bool[] memory isRemaining = new bool[](1);
        isRemaining[0] = false;

        harness.setupMockAuthStorage(testTxID, signers, isRemaining);

        AuthAccount.Data[] memory result = harness.exposed_getRemainingSigners(testTxID);

        assertEq(result.length, 0, "Should return empty array when no signers remain");
    }

    function test_buildLocalAccounts_BuildsCorrectly() public {
        bytes[] memory signerIDs = new bytes[](2);
        signerIDs[0] = signerABytes;
        signerIDs[1] = signerBBytes;

        AuthAccount.Data[] memory accounts = harness.exposed_buildLocalAccounts(signerIDs);

        assertEq(accounts.length, 2, "Array length mismatch");

        assertEq(accounts[0].id, signerABytes, "Signer A ID mismatch");
        assertEq(
            uint256(accounts[0].auth_type.mode),
            uint256(AuthType.AuthMode.AUTH_MODE_LOCAL),
            "Signer A auth type mismatch"
        );
        assertEq(accounts[0].auth_type.option.type_url, "", "Signer A option type_url should be empty");
        assertEq(accounts[0].auth_type.option.value, "", "Signer A option value should be empty");

        assertEq(accounts[1].id, signerBBytes, "Signer B ID mismatch");
        assertEq(
            uint256(accounts[1].auth_type.mode),
            uint256(AuthType.AuthMode.AUTH_MODE_LOCAL),
            "Signer B auth type mismatch"
        );
        assertEq(accounts[1].auth_type.option.type_url, "", "Signer B option type_url should be empty");
        assertEq(accounts[1].auth_type.option.value, "", "Signer B option value should be empty");
    }
}
