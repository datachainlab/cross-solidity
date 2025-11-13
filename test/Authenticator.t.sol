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
    MsgExtSignTxResponse,
    QueryTxAuthStateRequest
} from "../src/proto/cross/core/auth/Auth.sol";
import {GoogleProtobufAny} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";
import {IbcCoreClientV1Height} from "../src/proto/ibc/core/client/v1/client.sol";

contract MockTxManager is TxManagerBase {
    bytes32 public lastRunTxID;
    uint256 public runTxCount;

    function createTx(
        bytes32,
        /*txID*/
        MsgInitiateTx.Data calldata /*src*/
    )
        internal
        virtual
        override
    {}

    function runTxIfCompleted(bytes32 txID) internal virtual override {
        lastRunTxID = txID;
        ++runTxCount;
    }

    function isTxRecorded(
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

    error MockVerifyError();

    function initAuthState(
        bytes32,
        /*txID*/
        AuthAccount.Data[] memory /*signers*/
    )
        internal
        virtual
        override
    {}

    function isCompletedAuth(
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

    function sign(
        bytes32 txID,
        AuthAccount.Data[] memory /*signers*/
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
    function getAuthState(bytes32) internal view virtual override returns (TxAuthState.Data memory) {}

    function _verifySignatures(
        bytes32,
        /*txIDHash*/
        AuthAccount.Data[] calldata,
        /*signers*/
        bytes[] calldata /*signatures*/
    )
        internal
        view
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

    event TxSigned(address indexed signer, bytes32 indexed txID, AuthType.AuthMode method);

    function setUp() public {
        harness = new AuthenticatorHarness();

        bytes[] memory signers = new bytes[](1);
        signers[0] = signerABytes;

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

        bytes[] memory extSignatures = new bytes[](1);
        extSignatures[0] = bytes("dummy-sig-A");

        extMsg = MsgExtSignTx.Data({txID: extTxID, signers: extSigners, signatures: extSignatures});
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
        emit TxSigned(address(this), txIDHash, AuthType.AuthMode.AUTH_MODE_LOCAL);

        MsgSignTxResponse.Data memory resp = harness.signTx(baseMsg);

        assertTrue(resp.tx_auth_completed, "response should indicate completed");
        assertEq(resp.log, "", "log should be empty");
        assertTrue(harness.completed(txIDHash), "Mock: auth should be completed");
        assertEq(harness.runTxCount(), 1, "Mock: runTxIfCompleted should be called once");
        assertEq(harness.lastRunTxID(), txIDHash, "Mock: runTxIfCompleted called with correct txID");
    }

    function test_extSignTx_SucceedsAsPending() public {
        harness.setSignReturns(false);

        vm.expectEmit(true, true, false, true, address(harness));
        emit TxSigned(address(this), extTxIDHash, AuthType.AuthMode.AUTH_MODE_EXTENSION);

        MsgExtSignTxResponse.Data memory resp = harness.extSignTx(extMsg);

        assertTrue(resp.x, "response.x should be true");
        assertFalse(harness.completed(extTxIDHash), "Mock: auth should not be completed");
        assertEq(harness.runTxCount(), 0, "Mock: runTxIfCompleted should not be called");
    }

    function test_extSignTx_SucceedsAsCompletedAndEmitsEvent() public {
        harness.setSignReturns(true);

        vm.expectEmit(true, true, false, true, address(harness));
        emit TxSigned(address(this), extTxIDHash, AuthType.AuthMode.AUTH_MODE_EXTENSION);

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

    function test_txAuthState_RevertsNotImplemented() public {
        QueryTxAuthStateRequest.Data memory req;
        req.txID = bytes("query-tx");

        vm.expectRevert(IAuthenticator.TxAuthStateNotImplemented.selector);
        harness.txAuthState(req);
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
