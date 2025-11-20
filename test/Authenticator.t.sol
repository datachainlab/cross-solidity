// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase, var-name-mixedcase, gas-small-strings
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";
import "../src/core/Authenticator.sol";
import {TxManagerBase} from "../src/core/TxManagerBase.sol";
import {TxAuthManagerBase} from "../src/core/TxAuthManagerBase.sol";

import {MsgInitiateTx} from "../src/proto/cross/core/initiator/Initiator.sol";
import {IAuthenticator} from "../src/core/IAuthenticator.sol";
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
    function exposed_buildLocalAccounts(bytes[] calldata signerIDs) public pure returns (AuthAccount.Data[] memory) {
        return _buildLocalAccounts(signerIDs);
    }
}

contract AuthenticatorTest is Test {
    AuthenticatorHarness private harness;
    MsgSignTx.Data private baseMsg;
    bytes32 private txIDHash;
    MsgExtSignTx.Data private extMsg;
    bytes32 private extTxIDHash;
    bytes private signerABytes = bytes("signerA");
    bytes private signerBBytes = bytes("signerB");

    function setUp() public {
        harness = new AuthenticatorHarness();

        bytes memory expectedSignerId = abi.encodePacked(address(this));

        bytes[] memory signers = new bytes[](1);
        signers[0] = expectedSignerId;

        baseMsg = MsgSignTx.Data({
            txID: bytes("test-tx-id"),
            signers: signers,
            timeout_height: IbcCoreClientV1Height.Data(0, 0),
            timeout_timestamp: 0
        });

        txIDHash = sha256(baseMsg.txID);

        bytes memory extTxID = bytes("ext-test-tx-id");
        extTxIDHash = sha256(extTxID);

        AuthAccount.Data[] memory extSigners = new AuthAccount.Data[](1);
        extSigners[0] = AuthAccount.Data({
            id: signerABytes,
            auth_type: AuthType.Data({
                mode: AuthType.AuthMode.AUTH_MODE_EXTENSION,
                option: GoogleProtobufAny.Data({type_url: "/verifier/test", value: ""})
            })
        });

        extMsg = MsgExtSignTx.Data({txID: extTxID, signers: extSigners});
    }

    function test_signTx_SucceedsAsPending() public {
        harness.setSignReturns(false);

        MsgSignTxResponse.Data memory resp = harness.signTx(baseMsg);
        assertFalse(resp.tx_auth_completed, "response should indicate not completed");
        assertEq(resp.log, "", "log should be empty");
        assertFalse(harness.completed(txIDHash), "Mock: auth should not be completed");
        assertEq(harness.runTxCount(), 0, "Mock: runTxIfCompleted should not be called");
    }

    function test_signTx_SucceedsAsCompletedAndEmitsEvent() public {
        harness.setSignReturns(true);

        vm.expectEmit(true, true, false, true, address(harness));
        emit IAuthenticator.TxSigned(address(this), txIDHash, AuthType.AuthMode.AUTH_MODE_LOCAL);

        MsgSignTxResponse.Data memory resp = harness.signTx(baseMsg);

        assertTrue(resp.tx_auth_completed, "response should indicate completed");
        assertEq(resp.log, "", "log should be empty");
        assertTrue(harness.completed(txIDHash), "Mock: auth should be completed");
        assertEq(harness.runTxCount(), 1, "Mock: runTxIfCompleted should be called once");
        assertEq(harness.lastRunTxID(), txIDHash, "Mock: runTxIfCompleted called with correct txID");
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
        emit IAuthenticator.TxSigned(address(this), extTxIDHash, AuthType.AuthMode.AUTH_MODE_EXTENSION);

        MsgExtSignTxResponse.Data memory resp = harness.extSignTx(extMsg);

        assertTrue(resp.x, "response.x should be true");
        assertFalse(harness.completed(extTxIDHash), "Mock: auth should not be completed");
        assertEq(harness.runTxCount(), 0, "Mock: runTxIfCompleted should not be called");
    }

    function test_extSignTx_SucceedsAsCompletedAndEmitsEvent() public {
        harness.setSignReturns(true);

        vm.expectEmit(address(harness));
        emit IAuthenticator.TxSigned(address(this), extTxIDHash, AuthType.AuthMode.AUTH_MODE_EXTENSION);

        MsgExtSignTxResponse.Data memory resp = harness.extSignTx(extMsg);

        assertTrue(resp.x, "response.x should be true");
        assertTrue(harness.completed(extTxIDHash), "Mock: auth should be completed");
        assertEq(harness.runTxCount(), 1, "Mock: runTxIfCompleted should be called once");
        assertEq(harness.lastRunTxID(), extTxIDHash, "Mock: runTxIfCompleted called with correct txID");
    }

    function test_extSignTx_RevertsIfVerificationFails() public {
        harness.setVerifyShouldRevert(true);

        vm.expectRevert(MockTxAuthManager.MockVerifyError.selector);
        harness.extSignTx(extMsg);
    }

    function test_txAuthState_ReturnsState() public {
        bytes memory queryTxID = bytes("query-tx");

        AuthAccount.Data[] memory remainingSigners = new AuthAccount.Data[](1);
        remainingSigners[0] = AuthAccount.Data({
            id: signerBBytes,
            auth_type: AuthType.Data({
                mode: AuthType.AuthMode.AUTH_MODE_LOCAL, option: GoogleProtobufAny.Data({type_url: "", value: ""})
            })
        });
        TxAuthState.Data memory expectedState = TxAuthState.Data({remaining_signers: remainingSigners});

        harness.setMockAuthState(expectedState);

        QueryTxAuthStateRequest.Data memory req;
        req.txID = queryTxID;

        QueryTxAuthStateResponse.Data memory resp = harness.txAuthState(req);

        assertEq(resp.tx_auth_state.remaining_signers.length, 1, "Remaining signers length mismatch");
        assertEq(resp.tx_auth_state.remaining_signers[0].id, signerBBytes, "Remaining signer ID mismatch");
        assertEq(
            uint256(resp.tx_auth_state.remaining_signers[0].auth_type.mode),
            uint256(AuthType.AuthMode.AUTH_MODE_LOCAL),
            "Remaining signer auth mode mismatch"
        );
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
