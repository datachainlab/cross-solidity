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
    ContractTransaction,
    Link
} from "../src/proto/cross/core/initiator/Initiator.sol";
import {Account as AuthAccount, AuthType} from "../src/proto/cross/core/auth/Auth.sol";
import {Tx} from "../src/proto/cross/core/tx/Tx.sol";
import {IbcCoreClientV1Height} from "../src/proto/ibc/core/client/v1/client.sol";
import {GoogleProtobufAny} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";

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

    function exposed_getTxMsg(bytes32 txId) public view returns (MsgInitiateTx.Data memory) {
        CoreStore.TxStorage storage t = _getTxStorage();
        return t.txMsg[txId];
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

    function test_createTx_SucceedsWithFullData() public {
        bytes32 deepCopyTxId = keccak256("deep_copy_tx");

        GoogleProtobufAny.Data memory emptyAny = GoogleProtobufAny.Data({type_url: "", value: ""});
        AuthType.Data memory localAuthType = AuthType.Data({mode: AuthType.AuthMode.AUTH_MODE_LOCAL, option: emptyAny});
        AuthAccount.Data memory signerA = AuthAccount.Data({id: bytes("signerA"), auth_type: localAuthType});

        AuthAccount.Data[] memory signers_mem = new AuthAccount.Data[](1);
        signers_mem[0] = signerA;

        ContractTransaction.Data[] memory txs_mem = new ContractTransaction.Data[](1);
        Link.Data[] memory links_mem = new Link.Data[](1);
        links_mem[0] = Link.Data({src_index: 123});

        txs_mem[0].signers = signers_mem;
        txs_mem[0].links = links_mem;
        txs_mem[0].call_info = hex"C0FFEE";

        MsgInitiateTx.Data memory nonEmptyTxMsg = MsgInitiateTx.Data({
            chain_id: "test-chain-deep",
            nonce: 2,
            commit_protocol: Tx.CommitProtocol.COMMIT_PROTOCOL_SIMPLE,
            timeout_height: IbcCoreClientV1Height.Data(0, 0),
            timeout_timestamp: 0,
            signers: signers_mem,
            contract_transactions: txs_mem
        });

        harness.exposed_createTx(deepCopyTxId, nonEmptyTxMsg);

        assertTrue(harness.exposed_isTxRecorded(deepCopyTxId), "Tx should be recorded");
        assertEq(
            uint256(harness.getTxStatus(deepCopyTxId)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_PENDING),
            "Status should be PENDING"
        );

        MsgInitiateTx.Data memory storedMsg = harness.exposed_getTxMsg(deepCopyTxId);
        assertEq(storedMsg.signers.length, 1, "Top signers length mismatch");
        assertEq(storedMsg.signers[0].id, signerA.id, "Top signer id mismatch");
        assertEq(storedMsg.contract_transactions.length, 1, "Txs length mismatch");
        assertEq(storedMsg.contract_transactions[0].call_info, hex"C0FFEE", "Tx call_info mismatch");
        assertEq(storedMsg.contract_transactions[0].signers.length, 1, "Nested signers length mismatch");
        assertEq(storedMsg.contract_transactions[0].links.length, 1, "Links length mismatch");
        assertEq(storedMsg.contract_transactions[0].links[0].src_index, 123, "Link src_index mismatch");
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
        harness.exposed_runTxIfCompleted(txId); // First run
        assertEq(harness.runCount(), 1, "MockTxRunner should be called once");
        assertEq(
            uint256(harness.getTxStatus(txId)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED),
            "Status should be VERIFIED"
        );
        harness.exposed_runTxIfCompleted(txId); // Second run
        assertEq(harness.runCount(), 1, "MockTxRunner should not be called again");
        assertEq(
            uint256(harness.getTxStatus(txId)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED),
            "Status should be VERIFIED"
        );
    }
}
