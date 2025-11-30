// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase, gas-small-strings, function-max-lines
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";
import "../src/core/TxManager.sol";
import "../src/core/TxManagerBase.sol";
import {
    MsgInitiateTx,
    MsgInitiateTxResponse,
    ContractTransaction,
    Link,
    ReturnValue
} from "../src/proto/cross/core/initiator/Initiator.sol";
import {Account as AuthAccount, AuthType} from "../src/proto/cross/core/auth/Auth.sol";
import {Tx} from "../src/proto/cross/core/tx/Tx.sol";
import {IbcCoreClientV1Height} from "../src/proto/ibc/core/client/v1/client.sol";
import {GoogleProtobufAny} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";
import {ICrossError} from "../src/core/ICrossError.sol";
import {Packet} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IIBCChannel.sol";
import {IIBCHandler} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/25-handler/IIBCHandler.sol";
import {IContractModule} from "../src/core/IContractModule.sol";
import {
    PacketAcknowledgementCall,
    PacketData,
    Acknowledgement
} from "../src/proto/cross/core/atomic/simple/AtomicSimple.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract DummyIBCHandler {}

contract DummyContractModule {}

contract TxManagerHarness is TxManager {
    uint256 public runCount;
    bytes32 public lastRunTxID;
    uint256 public initCount;
    uint256 public handlePacketCount;
    uint256 public handleAckCount;
    uint256 public handleTimeoutCount;

    constructor() TxManager() {}

    function getTxStatus(bytes32 txID) public view returns (MsgInitiateTxResponse.InitiateTxStatus) {
        CrossStore.TxStorage storage t = _getTxStorage();
        return t.txStatus[txID];
    }

    function getTxMsg(bytes32 txID) public view returns (MsgInitiateTx.Data memory) {
        CrossStore.TxStorage storage t = _getTxStorage();
        return t.txMsg[txID];
    }

    function _runTx(bytes32 txID, MsgInitiateTx.Data storage) internal virtual override {
        ++runCount;
        lastRunTxID = txID;
    }

    function __initTxAtomicSimple(IIBCHandler, IContractModule) internal override {
        ++initCount;
    }

    function _handlePacket(Packet calldata) internal override returns (bytes memory) {
        ++handlePacketCount;
        return hex"1234"; // Dummy ACK
    }

    function _handleAcknowledgement(Packet calldata, bytes calldata) internal override {
        ++handleAckCount;
    }

    function _handleTimeout(Packet calldata) internal override {
        ++handleTimeoutCount;
    }

    function exposed_getIBCHandler() public view returns (IIBCHandler) {
        return getIBCHandler();
    }

    function exposed_getModule() public returns (IContractModule) {
        Packet memory p;
        return getModule(p);
    }
}

contract TxManagerTest is Test {
    TxManagerHarness private harness;
    bytes32 private txID = keccak256("test_tx_id");
    MsgInitiateTx.Data private txMsg;

    DummyIBCHandler private dummyHandler;
    DummyContractModule private dummyModule;

    function setUp() public {
        harness = new TxManagerHarness();
        dummyHandler = new DummyIBCHandler();
        dummyModule = new DummyContractModule();

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

    // --- initialize ---

    function test_initialize_SetsHandlerAndModule() public {
        harness.initialize(IIBCHandler(address(dummyHandler)), IContractModule(address(dummyModule)));

        assertEq(harness.initCount(), 1, "initialize should be called once");
    }

    function test_initialize_RevertWhen_DoubleInit() public {
        harness.initialize(IIBCHandler(address(dummyHandler)), IContractModule(address(dummyModule)));

        vm.expectRevert(Initializable.InvalidInitialization.selector);
        harness.initialize(IIBCHandler(address(dummyHandler)), IContractModule(address(dummyModule)));
    }

    // --- handlePacket ---

    function test_handlePacket_DelegatesToModule() public {
        harness.initialize(IIBCHandler(address(dummyHandler)), IContractModule(address(dummyModule)));

        Packet memory p;
        bytes memory ack = harness.handlePacket(p);

        assertEq(harness.handlePacketCount(), 1);
        assertEq(ack, hex"1234");
    }

    // --- handleAcknowledgement ---

    function test_handleAcknowledgement_CallsLogic() public {
        harness.initialize(IIBCHandler(address(dummyHandler)), IContractModule(address(dummyModule)));

        Packet memory p;
        bytes memory emptyAck;
        harness.handleAcknowledgement(p, emptyAck);

        assertEq(harness.handleAckCount(), 1);
    }

    // --- handleTimeout ---

    function test_handleTimeout_CallsLogic() public {
        harness.initialize(IIBCHandler(address(dummyHandler)), IContractModule(address(dummyModule)));

        Packet memory p;
        harness.handleTimeout(p);

        assertEq(harness.handleTimeoutCount(), 1);
    }

    // --- getPacketAcknowledgementCall ---

    function test_getPacketAcknowledgementCall_EncodesCorrectly() public {
        bytes memory ackBytes =
            harness.getPacketAcknowledgementCall(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK);

        Acknowledgement.Data memory ackData = Acknowledgement.decode(ackBytes);
        assertTrue(ackData.is_success);
        PacketData.Data memory pd = PacketData.decode(ackData.result);
        GoogleProtobufAny.Data memory any_ = GoogleProtobufAny.decode(pd.payload);
        PacketAcknowledgementCall.Data memory pac = PacketAcknowledgementCall.decode(any_.value);
        assertEq(uint256(pac.status), uint256(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK));

        ackBytes = harness.getPacketAcknowledgementCall(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_FAILED);
        ackData = Acknowledgement.decode(ackBytes);
        pd = PacketData.decode(ackData.result);
        any_ = GoogleProtobufAny.decode(pd.payload);
        pac = PacketAcknowledgementCall.decode(any_.value);
        assertEq(uint256(pac.status), uint256(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_FAILED));
    }

    // --- isTxRecorded ---

    function test_isTxRecorded_ReturnsTrueForKnownTx() public {
        harness.createTx(txID, txMsg);
        assertTrue(harness.isTxRecorded(txID), "Should return true for recorded tx");
    }

    function test_isTxRecorded_ReturnsFalseForUnknownTx() public {
        assertFalse(harness.isTxRecorded(txID), "Should return false for unrecorded tx");
    }

    function test_createTx_SucceedsWithNonEmptyData() public {
        bytes32 deepCopytxID = keccak256("deep_copy_tx");

        // --- 1. Setup mock data ---
        GoogleProtobufAny.Data memory emptyAny = GoogleProtobufAny.Data({type_url: "", value: ""});
        AuthType.Data memory localAuthType = AuthType.Data({mode: AuthType.AuthMode.AUTH_MODE_LOCAL, option: emptyAny});
        AuthAccount.Data memory signerA = AuthAccount.Data({id: bytes("signerA"), auth_type: localAuthType});

        // --- 2. Build a complex calldata message with nested arrays ---
        // 2a. Top-level signers
        AuthAccount.Data[] memory signersMem = new AuthAccount.Data[](1);
        signersMem[0] = signerA;

        // 2b. Nested contract transactions
        ContractTransaction.Data[] memory txsMem = new ContractTransaction.Data[](1);
        Link.Data[] memory linksMem = new Link.Data[](1);
        linksMem[0] = Link.Data({src_index: 123});

        txsMem[0].signers = signersMem; // Nested signers
        txsMem[0].links = linksMem; // Nested links
        txsMem[0].call_info = hex"C0FFEE";
        txsMem[0].cross_chain_channel = GoogleProtobufAny.Data({type_url: "xcc_type", value: hex"01"});
        txsMem[0].return_value = ReturnValue.Data({value: bytes("RETURNVAL")});

        // 2c. Main message
        MsgInitiateTx.Data memory nonEmptyTxMsg = MsgInitiateTx.Data({
            chain_id: "test-chain-deep",
            nonce: 99,
            commit_protocol: Tx.CommitProtocol.COMMIT_PROTOCOL_TPC,
            timeout_height: IbcCoreClientV1Height.Data(1, 101),
            timeout_timestamp: 202,
            signers: signersMem,
            contract_transactions: txsMem
        });

        // --- 3. Execute the function under test ---
        harness.createTx(deepCopytxID, nonEmptyTxMsg);

        // --- 4. Assert status (ensures coverage for non-empty paths) ---
        assertTrue(harness.isTxRecorded(deepCopytxID), "Tx should be recorded");
        assertEq(
            uint256(harness.getTxStatus(deepCopytxID)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_PENDING),
            "Status should be PENDING"
        );

        // --- 5. Verify deep copy by reading back from storage ---
        MsgInitiateTx.Data memory storedMsg = harness.getTxMsg(deepCopytxID);

        // 5a. Verify top-level simple fields
        assertEq(storedMsg.chain_id, "test-chain-deep", "chain_id mismatch");
        assertEq(storedMsg.nonce, 99, "nonce mismatch");
        assertEq(
            uint256(storedMsg.commit_protocol),
            uint256(Tx.CommitProtocol.COMMIT_PROTOCOL_TPC),
            "commit_protocol mismatch"
        );
        assertEq(storedMsg.timeout_height.revision_number, 1, "timeout_height.revision_number mismatch");
        assertEq(storedMsg.timeout_height.revision_height, 101, "timeout_height.revision_height mismatch");
        assertEq(storedMsg.timeout_timestamp, 202, "timeout_timestamp mismatch");

        // 5b. Verify top-level signers array
        assertEq(storedMsg.signers.length, 1, "Top signers length mismatch");
        assertEq(storedMsg.signers[0].id, signerA.id, "Top signer id mismatch");
        assertEq(
            uint256(storedMsg.signers[0].auth_type.mode), uint256(localAuthType.mode), "Top signer auth_type mismatch"
        );

        // 5c. Verify contract_transactions array (level 1 nesting)
        assertEq(storedMsg.contract_transactions.length, 1, "Txs length mismatch");
        ContractTransaction.Data memory storedTx = storedMsg.contract_transactions[0];
        assertEq(storedTx.cross_chain_channel.type_url, "xcc_type", "Tx xcc.type_url mismatch");
        assertEq(storedTx.cross_chain_channel.value, hex"01", "Tx xcc.value mismatch");
        assertEq(storedTx.call_info, hex"C0FFEE", "Tx call_info mismatch");
        assertEq(storedTx.return_value.value, bytes("RETURNVAL"), "Tx return_value mismatch");

        // 5d. Verify nested signers array (level 2 nesting)
        assertEq(storedTx.signers.length, 1, "Nested signers length mismatch");
        assertEq(storedTx.signers[0].id, signerA.id, "Nested signer id mismatch");
        assertEq(
            uint256(storedTx.signers[0].auth_type.mode), uint256(localAuthType.mode), "Nested signer auth_type mismatch"
        );

        // 5e. Verify nested links array (level 2 nesting)
        assertEq(storedTx.links.length, 1, "Links length mismatch");
        assertEq(storedTx.links[0].src_index, 123, "Link src_index mismatch");
    }

    function test_createTx_RevertWhen_TxAlreadyExists() public {
        harness.createTx(txID, txMsg); // First time
        vm.expectRevert(abi.encodeWithSelector(ICrossError.TxAlreadyExists.selector, txID));
        harness.createTx(txID, txMsg); // Second time
    }

    //--- runTxIfCompleted ---

    function test_runTxIfCompleted_RunsTxAndSetsVerifiedStatus() public {
        harness.createTx(txID, txMsg);
        assertEq(
            uint256(harness.getTxStatus(txID)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_PENDING),
            "Status should be PENDING"
        );
        harness.runTxIfCompleted(txID);
        assertEq(harness.runCount(), 1, "MockTxRunner should be called once");
        assertEq(harness.lastRunTxID(), txID, "MockTxRunner should be called with correct txID");
        assertEq(
            uint256(harness.getTxStatus(txID)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED),
            "Status should be VERIFIED"
        );
    }

    function test_runTxIfCompleted_DoesNothingForUnknownTx() public {
        harness.runTxIfCompleted(txID);
        assertEq(harness.runCount(), 0, "MockTxRunner should not be called");
        assertEq(
            uint256(harness.getTxStatus(txID)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_UNKNOWN),
            "Status should remain UNKNOWN"
        );
    }

    function test_runTxIfCompleted_DoesNothingIfAlreadyVerified() public {
        harness.createTx(txID, txMsg);
        harness.runTxIfCompleted(txID); // First run
        assertEq(harness.runCount(), 1, "MockTxRunner should be called once");
        assertEq(
            uint256(harness.getTxStatus(txID)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED),
            "Status should be VERIFIED"
        );
        harness.runTxIfCompleted(txID); // Second run
        assertEq(harness.runCount(), 1, "MockTxRunner should not be called again");
        assertEq(
            uint256(harness.getTxStatus(txID)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED),
            "Status should be VERIFIED"
        );
    }
}
