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
import {ICrossError} from "../src/core/ICrossError.sol";
import {Account as AuthAccount, AuthType} from "../src/proto/cross/core/auth/Auth.sol";
import {Tx} from "../src/proto/cross/core/tx/Tx.sol";
import {IbcCoreClientV1Height} from "../src/proto/ibc/core/client/v1/client.sol";
import {CoordinatorState} from "../src/proto/cross/core/atomic/simple/AtomicSimple.sol";
import {GoogleProtobufAny} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";
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

    function getTxCoordSigners(bytes32 txID) public view returns (AuthAccount.Data[] memory) {
        CrossStore.TxStorage storage t = _getTxStorage();
        return t.txCoordSigners[txID];
    }

    function _runTx(bytes32 txID, MsgInitiateTx.Data calldata) internal virtual override {
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

    function setCoordinatorState(bytes32 txID, CoordinatorState.Data calldata data) public {
        _saveCoordinatorState(txID, data);
    }
}

contract TxManagerTest is Test, ICrossError {
    TxManagerHarness private harness;
    bytes32 private txID;
    MsgInitiateTx.Data private txMsg;

    DummyIBCHandler private dummyHandler;
    DummyContractModule private dummyModule;

    function _computeTxId(MsgInitiateTx.Data memory msg_) internal pure returns (bytes32) {
        msg_.signers = new AuthAccount.Data[](0);
        return sha256(MsgInitiateTx.encode(msg_));
    }

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

        txID = _computeTxId(txMsg);
    }

    // --- initialize ---

    function test_initialize_Succeeds() public {
        harness.initialize(IIBCHandler(address(dummyHandler)), IContractModule(address(dummyModule)));

        assertEq(harness.initCount(), 1, "initialize should be called once");
    }

    function test_initialize_RevertWhen_DoubleInit() public {
        harness.initialize(IIBCHandler(address(dummyHandler)), IContractModule(address(dummyModule)));

        vm.expectRevert(Initializable.InvalidInitialization.selector);
        harness.initialize(IIBCHandler(address(dummyHandler)), IContractModule(address(dummyModule)));
    }

    // --- handlePacket ---

    function test_handlePacket_CallsLogic() public {
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
        AuthAccount.Data[] memory txCoordSigners = harness.getTxCoordSigners(deepCopytxID);

        assertEq(txCoordSigners.length, 1, "Nested signers length mismatch");
        assertEq(txCoordSigners[0].id, signerA.id, "Nested signer id mismatch");
        assertEq(
            uint256(txCoordSigners[0].auth_type.mode), uint256(localAuthType.mode), "Nested signer auth_type mismatch"
        );
    }

    function test_createTx_RevertWhen_TxAlreadyExists() public {
        harness.createTx(txID, txMsg); // First time
        vm.expectRevert(abi.encodeWithSelector(TxAlreadyExists.selector, txID));
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
        harness.runTxIfCompleted(txID, txMsg);
        assertEq(harness.runCount(), 1, "MockTxRunner should be called once");
        assertEq(harness.lastRunTxID(), txID, "MockTxRunner should be called with correct txID");
        assertEq(
            uint256(harness.getTxStatus(txID)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED),
            "Status should be VERIFIED"
        );
    }

    function test_runTxIfCompleted_DoesNothingForUnknownTx() public {
        harness.runTxIfCompleted(txID, txMsg);
        assertEq(harness.runCount(), 0, "MockTxRunner should not be called");
        assertEq(
            uint256(harness.getTxStatus(txID)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_UNKNOWN),
            "Status should remain UNKNOWN"
        );
    }

    function test_runTxIfCompleted_DoesNothingIfAlreadyVerified() public {
        harness.createTx(txID, txMsg);
        harness.runTxIfCompleted(txID, txMsg); // First run
        assertEq(harness.runCount(), 1, "MockTxRunner should be called once");
        assertEq(
            uint256(harness.getTxStatus(txID)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED),
            "Status should be VERIFIED"
        );
        harness.runTxIfCompleted(txID, txMsg); // Second run
        assertEq(harness.runCount(), 1, "MockTxRunner should not be called again");
        assertEq(
            uint256(harness.getTxStatus(txID)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED),
            "Status should be VERIFIED"
        );
    }

    function test_getCoordinatorState_ReturnsCorrectState() public {
        CoordinatorState.Data memory expected;
        expected.commit_protocol = Tx.CommitProtocol.COMMIT_PROTOCOL_SIMPLE;
        expected.phase = CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE;

        harness.setCoordinatorState(txID, expected);

        CoordinatorState.Data memory actual = harness.getCoordinatorState(txID);

        assertEq(uint256(actual.commit_protocol), uint256(expected.commit_protocol), "Commit protocol mismatch");
        assertEq(uint256(actual.phase), uint256(expected.phase), "Phase mismatch");
    }

    function test_getCoordinatorState_RevertsIfNotFound() public {
        vm.expectRevert(abi.encodeWithSelector(CoordinatorStateNotFound.selector, txID));
        harness.getCoordinatorState(txID);
    }
}
