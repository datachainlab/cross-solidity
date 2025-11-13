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
    QueryTxAuthStateRequest
} from "../src/proto/cross/core/auth/Auth.sol";
import {IbcCoreClientV1Height} from "../src/proto/ibc/core/client/v1/client.sol";

contract MockTxManager is TxManagerBase {
    bytes32 public lastRunTxId;
    uint256 public runTxCount;

    function createTx(
        bytes32,
        /*txId*/
        MsgInitiateTx.Data calldata /*src*/
    )
        internal
        virtual
        override
    {}

    function runTxIfCompleted(bytes32 txId) internal virtual override {
        lastRunTxId = txId;
        ++runTxCount;
    }

    function isTxRecorded(
        bytes32 /*txId*/
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

    function initAuthState(
        bytes32,
        /*txId*/
        Account.Data[] memory /*signers*/
    )
        internal
        virtual
        override
    {}

    function isCompletedAuth(
        bytes32 /*txId*/
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
        bytes32 txId,
        Account.Data[] memory /*signers*/
    )
        internal
        virtual
        override
        returns (bool)
    {
        if (_signReturns) {
            completed[txId] = true;
        }
        return _signReturns;
    }
    function getAuthState(bytes32) internal view virtual override returns (TxAuthState.Data memory) {}

    function setSignReturns(bool returnsValue) public {
        _signReturns = returnsValue;
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
    bytes32 private txIdHash;
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

        txIdHash = sha256(baseMsg.txID);
    }

    function test_signTx_SucceedsAsPending() public {
        harness.setSignReturns(false);

        MsgSignTxResponse.Data memory resp = harness.signTx(baseMsg);
        assertFalse(resp.tx_auth_completed, "response should indicate not completed");
        assertEq(resp.log, "", "log should be empty");
        assertFalse(harness.completed(txIdHash), "Mock: auth should not be completed");
        assertEq(harness.runTxCount(), 0, "Mock: runTxIfCompleted should not be called");
    }

    function test_signTx_SucceedsAsCompletedAndEmitsEvent() public {
        harness.setSignReturns(true);

        vm.expectEmit(true, true, false, true, address(harness));
        emit TxSigned(address(this), txIdHash, AuthType.AuthMode.AUTH_MODE_LOCAL);

        MsgSignTxResponse.Data memory resp = harness.signTx(baseMsg);

        assertTrue(resp.tx_auth_completed, "response should indicate completed");
        assertEq(resp.log, "", "log should be empty");
        assertTrue(harness.completed(txIdHash), "Mock: auth should be completed");
        assertEq(harness.runTxCount(), 1, "Mock: runTxIfCompleted should be called once");
        assertEq(harness.lastRunTxId(), txIdHash, "Mock: runTxIfCompleted called with correct txId");
    }

    function test_extSignTx_RevertsNotImplemented() public {
        MsgExtSignTx.Data memory msg_;
        msg_.txID = bytes("ext-tx");
        msg_.signers = new AuthAccount.Data[](0);

        vm.expectRevert(IAuthenticator.ExtSignTxNotImplemented.selector);
        harness.extSignTx(msg_);
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
