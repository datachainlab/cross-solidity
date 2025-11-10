// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";
import "../src/core/TxManager.sol";
import "../src/core/TxRunner.sol";
import "../src/core/TxManagerBase.sol";
import {
    MsgInitiateTx,
    MsgInitiateTxResponse,
    ContractTransaction
} from "../src/proto/cross/core/initiator/Initiator.sol";
import {Account as AuthAccount} from "../src/proto/cross/core/auth/Auth.sol";
import {Tx} from "../src/proto/cross/core/tx/Tx.sol";
import {IbcCoreClientV1Height} from "../src/proto/ibc/core/client/v1/client.sol";

contract MockTxRunner is TxRunner {
    uint256 public runCount;
    bytes32 public lastRunTxId;

    function _runTx(bytes32 txId, MsgInitiateTx.Data storage) internal virtual override {
        runCount++;
        lastRunTxId = txId;
    }
}

contract TxManagerHarness is TxManager, MockTxRunner {
    function exposed_createTx(bytes32 txId, MsgInitiateTx.Data calldata src) public {
        createTx(txId, src);
    }

    function exposed_runTxIfCompleted(bytes32 txId) public {
        runTxIfCompleted(txId);
    }

    function exposed_isTxRecorded(bytes32 txId) public view returns (bool) {
        return isTxRecorded(txId);
    }

    function getTxStatus(bytes32 txId) public view returns (MsgInitiateTxResponse.InitiateTxStatus) {
        CoreStore.TxStorage storage t = _getTxStorage();
        return t.txStatus[txId];
    }
}

contract TxManagerTest is Test {
    TxManagerHarness private harness;
    bytes32 private txId = keccak256("test_tx_id");
    MsgInitiateTx.Data private txMsg;

    function setUp() public {
        harness = new TxManagerHarness();

        AuthAccount.Data[] memory signers;
        ContractTransaction.Data[] memory txs;

        txMsg = MsgInitiateTx.Data({
            chain_id: "test-chain",
            nonce: 1,
            commit_protocol: Tx.CommitProtocol.COMMIT_PROTOCOL_SIMPLE,
            timeout_height: IbcCoreClientV1Height.Data(0, 0),
            timeout_timestamp: 0,
            signers: signers,
            contract_transactions: txs
        });
    }

    function test_isTxRecorded_ReturnsTrueForKnownTx() public {
        harness.exposed_createTx(txId, txMsg);

        assertTrue(harness.exposed_isTxRecorded(txId), "Should return true for recorded tx");
    }

    function test_isTxRecorded_ReturnsFalseForUnknownTx() public view {
        assertFalse(harness.exposed_isTxRecorded(txId), "Should return false for unrecorded tx");
    }

    function test_createTx_SucceedsAndSetsPendingStatus() public {
        harness.exposed_createTx(txId, txMsg);

        assertTrue(harness.exposed_isTxRecorded(txId), "Tx should be recorded");
        assertEq(
            uint256(harness.getTxStatus(txId)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_PENDING),
            "Status should be PENDING"
        );
    }

    function test_createTx_RevertWhen_TxAlreadyExists() public {
        harness.exposed_createTx(txId, txMsg); // First time

        vm.expectRevert(abi.encodeWithSelector(TxManagerBase.TxAlreadyExists.selector, txId));
        harness.exposed_createTx(txId, txMsg); // Second time
    }

    function test_runTxIfCompleted_RunsTxAndSetsVerifiedStatus() public {
        harness.exposed_createTx(txId, txMsg);

        assertEq(
            uint256(harness.getTxStatus(txId)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_PENDING),
            "Status should be PENDING"
        );

        harness.exposed_runTxIfCompleted(txId);

        assertEq(harness.runCount(), 1, "MockTxRunner should be called once");
        assertEq(harness.lastRunTxId(), txId, "MockTxRunner should be called with correct txId");

        assertEq(
            uint256(harness.getTxStatus(txId)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED),
            "Status should be VERIFIED"
        );
    }

    function test_runTxIfCompleted_DoesNothingForUnknownTx() public {
        harness.exposed_runTxIfCompleted(txId);
        assertEq(harness.runCount(), 0, "MockTxRunner should not be called");
    }

    function test_runTxIfCompleted_DoesNothingIfAlreadyVerified() public {
        harness.exposed_createTx(txId, txMsg);

        harness.exposed_runTxIfCompleted(txId); // First run, runCount = 1
        assertEq(harness.runCount(), 1, "MockTxRunner should be called once");

        assertEq(
            uint256(harness.getTxStatus(txId)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED),
            "Status should be VERIFIED"
        );

        harness.exposed_runTxIfCompleted(txId); // Second run, should do nothing
        assertEq(harness.runCount(), 1, "MockTxRunner should not be called again");

        assertEq(
            uint256(harness.getTxStatus(txId)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED),
            "Status should be VERIFIED"
        );
    }
}
