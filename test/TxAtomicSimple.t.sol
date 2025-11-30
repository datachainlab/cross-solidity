// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase, gas-small-strings
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";

import "../src/core/TxAtomicSimple.sol";
import "../src/core/IContractModule.sol";
import "../src/core/ICrossError.sol";
import {Packet} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IIBCChannel.sol";
import {IIBCHandler} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/25-handler/IIBCHandler.sol";
import {Height} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/Client.sol";
import {Channel, ChannelCounterparty} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/Channel.sol";

import {
    PacketData,
    Header,
    HeaderField,
    Acknowledgement,
    PacketAcknowledgementCall,
    PacketDataCall,
    PacketDataCallResolvedContractTransaction,
    CoordinatorState,
    ContractTransactionState
} from "../src/proto/cross/core/atomic/simple/AtomicSimple.sol";
import {GoogleProtobufAny as Any} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";
import {Account as AuthAccount} from "../src/proto/cross/core/auth/Auth.sol";
import {MsgInitiateTx, ContractTransaction, ReturnValue, Link} from "../src/proto/cross/core/initiator/Initiator.sol";
import {Tx} from "../src/proto/cross/core/tx/Tx.sol";
import {ChannelInfo} from "../src/proto/cross/core/xcc/XCC.sol";
import {IbcCoreClientV1Height} from "../src/proto/ibc/core/client/v1/client.sol";

contract MockIBCHandler {
    bool public foundChannel = true;
    bytes32 public lastSentPacketHash;

    function setFoundChannel(bool b) external {
        foundChannel = b;
    }

    function sendPacket(string calldata, string calldata, Height.Data calldata, uint64, bytes calldata data)
        external
        returns (uint64)
    {
        lastSentPacketHash = keccak256(data);
        return 1;
    }

    function getChannel(string calldata, string calldata) external view returns (Channel.Data memory, bool) {
        return (
            Channel.Data(
                Channel.State.STATE_OPEN,
                Channel.Order.ORDER_UNORDERED,
                ChannelCounterparty.Data("", ""),
                new string[](0),
                "",
                0
            ),
            foundChannel
        );
    }
}

contract MockModule is IContractModule {
    bytes public retBytes;
    bool public prepareResult = true;
    bool public onCommitCalled;
    bool public onAbortCalled;
    bool public revertOnCommitImmediately;

    constructor(bytes memory r) {
        retBytes = r;
    }

    function setPrepareResult(bool b) external {
        prepareResult = b;
    }

    function setRevertOnCommitImmediately(bool b) external {
        revertOnCommitImmediately = b;
    }

    function onContractCommitImmediately(CrossContext calldata, bytes calldata)
        external
        view
        override
        returns (bytes memory)
    {
        if (revertOnCommitImmediately) {
            revert("MockModule: CommitImmediately failed");
        }
        return retBytes;
    }

    function onAbort(CrossContext calldata) external override {
        onAbortCalled = true;
    }

    function onCommit(CrossContext calldata) external override {
        onCommitCalled = true;
    }

    function onContractPrepare(CrossContext calldata, bytes calldata) external override returns (bytes memory) {
        if (!prepareResult) {
            revert("MockModule: Prepare failed");
        }
        return retBytes;
    }
}

contract TxAtomicSimpleHarness is TxAtomicSimple {
    IContractModule internal _module;

    function initialize(IIBCHandler handler, IContractModule module) public initializer {
        __initTxAtomicSimple(handler, module);
    }

    function registerModule(IContractModule module) internal override {
        _module = module;
    }

    function setModule(IContractModule module) external {
        _module = module;
    }

    function getModule(Packet memory) internal override returns (IContractModule) {
        return _module;
    }

    function exposed_runTx(bytes32 txID, MsgInitiateTx.Data memory msg_) external {
        CrossStore.TxStorage storage t = _getTxStorage();
        t.txMsg[txID] = msg_;
        _runTx(txID, t.txMsg[txID]);
    }

    function exposed_handlePacket(Packet calldata p) external returns (bytes memory) {
        return _handlePacket(p);
    }

    function exposed_handleAcknowledgement(Packet calldata p, bytes calldata ack) external {
        _handleAcknowledgement(p, ack);
    }

    function exposed_handleTimeout(Packet calldata p) external {
        _handleTimeout(p);
    }

    function setCoordinatorState(bytes32 txID, CoordinatorState.Data memory state) external {
        _getCoordStorage().states[txID] = state;
    }

    function setContractTxState(bytes32 txID, uint8 index, ContractTransactionState.Data memory state) external {
        _getTxStorage().states[txID][index] = state;
    }

    function setTxMsg(bytes32 txID, MsgInitiateTx.Data memory msg_) external {
        _getTxStorage().txMsg[txID] = msg_;
    }

    function getCoordState(bytes32 txID) external view returns (CoordinatorState.Data memory) {
        return _getCoordStorage().states[txID];
    }

    function getContractTxState(bytes32 txID, uint8 index)
        external
        view
        returns (ContractTransactionState.Data memory)
    {
        return _getTxStorage().states[txID][index];
    }
}

contract TxAtomicSimpleTest is Test, ICrossError {
    TxAtomicSimpleHarness private harness;
    MockIBCHandler private mockHandler;
    MockModule private mockModule;

    bytes32 private constant TX_ID = keccak256("test-tx");

    event OnContractCall(bytes indexed txId, uint8 indexed txIndex, bool indexed success, bytes ret);

    function setUp() public {
        mockHandler = new MockIBCHandler();
        mockModule = new MockModule(hex"01");
        harness = new TxAtomicSimpleHarness();
        harness.initialize(IIBCHandler(address(mockHandler)), IContractModule(address(mockModule)));
    }

    // --- Helpers ---

    function _createValidSimpleMsg() internal view returns (MsgInitiateTx.Data memory) {
        ContractTransaction.Data[] memory txs = new ContractTransaction.Data[](2);

        // Tx0: Local (Coordinator)
        txs[0] = ContractTransaction.Data({
            cross_chain_channel: Any.Data("", ChannelInfo.encode(ChannelInfo.Data("", ""))),
            signers: new AuthAccount.Data[](0),
            call_info: hex"",
            return_value: ReturnValue.Data(""),
            links: new Link.Data[](0)
        });

        // Tx1: Remote (Participant)
        txs[1] = ContractTransaction.Data({
            cross_chain_channel: Any.Data("", ChannelInfo.encode(ChannelInfo.Data("port-1", "channel-1"))),
            signers: new AuthAccount.Data[](0),
            call_info: hex"",
            return_value: ReturnValue.Data(""),
            links: new Link.Data[](0)
        });

        return MsgInitiateTx.Data({
            chain_id: "chain",
            nonce: 1,
            commit_protocol: Tx.CommitProtocol.COMMIT_PROTOCOL_SIMPLE,
            contract_transactions: txs,
            signers: new AuthAccount.Data[](0),
            timeout_height: IbcCoreClientV1Height.Data(0, 0),
            timeout_timestamp: 0
        });
    }

    function _createPacket(string memory srcPort, string memory srcChannel) internal view returns (Packet memory) {
        // Construct a valid PacketDataCall containing the TX_ID, even for simple Ack tests
        // This is necessary because _handleAcknowledgement extracts TX_ID from the original packet data.
        PacketDataCall.Data memory pdc = PacketDataCall.Data({
            tx_id: abi.encode(TX_ID),
            tx: PacketDataCallResolvedContractTransaction.Data(
                Any.Data("", ""), new AuthAccount.Data[](0), "", ReturnValue.Data(""), new Any.Data[](0)
            )
        });

        bytes memory payload =
            Any.encode(Any.Data("/cross.core.atomic.simple.PacketDataCall", PacketDataCall.encode(pdc)));
        bytes memory data = PacketData.encode(PacketData.Data(Header.Data(new HeaderField.Data[](0)), payload));

        return Packet({
            sequence: 1,
            sourcePort: srcPort,
            sourceChannel: srcChannel,
            destinationPort: "dst",
            destinationChannel: "dst",
            data: data,
            timeoutHeight: Height.Data(0, 0),
            timeoutTimestamp: 0
        });
    }

    function _createPacketWithCall(bytes32 txId, bytes memory callInfo) internal pure returns (Packet memory p) {
        Any.Data memory emptyAny = Any.Data({type_url: "", value: ""});
        ReturnValue.Data memory emptyRet = ReturnValue.Data({value: ""});

        AuthAccount.Data[] memory signers;
        Any.Data[] memory objects;

        PacketDataCallResolvedContractTransaction.Data memory txResolved =
            PacketDataCallResolvedContractTransaction.Data({
                cross_chain_channel: emptyAny,
                signers: signers,
                call_info: callInfo,
                return_value: emptyRet,
                objects: objects
            });

        PacketDataCall.Data memory callData = PacketDataCall.Data({tx_id: abi.encodePacked(txId), tx: txResolved});

        bytes memory anyPayload = Any.encode(
            // solhint-disable-next-line gas-small-strings
            Any.Data({type_url: "/cross.core.atomic.simple.PacketDataCall", value: PacketDataCall.encode(callData)})
        );

        HeaderField.Data[] memory fields;
        bytes memory packetDataBytes =
            PacketData.encode(PacketData.Data({header: Header.Data({fields: fields}), payload: anyPayload}));

        p.data = packetDataBytes;
    }

    function _createAck(PacketAcknowledgementCall.CommitStatus status) internal pure returns (bytes memory) {
        PacketAcknowledgementCall.Data memory pac = PacketAcknowledgementCall.Data(status);
        bytes memory payload = Any.encode(
            Any.Data("/cross.core.atomic.simple.PacketAcknowledgementCall", PacketAcknowledgementCall.encode(pac))
        );
        bytes memory res = PacketData.encode(PacketData.Data(Header.Data(new HeaderField.Data[](0)), payload));
        return Acknowledgement.encode(Acknowledgement.Data(true, res));
    }

    function _decodeAckStatus(bytes memory ack) internal pure returns (PacketAcknowledgementCall.CommitStatus) {
        Acknowledgement.Data memory ackData = Acknowledgement.decode(ack);
        PacketData.Data memory pd = PacketData.decode(ackData.result);
        Any.Data memory any_ = Any.decode(pd.payload);
        PacketAcknowledgementCall.Data memory pac = PacketAcknowledgementCall.decode(any_.value);
        return pac.status;
    }

    function _setupCoordStateForAck(CoordinatorState.CoordinatorPhase phase) internal {
        ChannelInfo.Data[] memory channels = new ChannelInfo.Data[](2);
        channels[0] = ChannelInfo.Data("", "");
        channels[1] = ChannelInfo.Data("port-1", "channel-1");

        // Initial setup assumes coordinator (index 0) is already confirmed (PREPARE phase complete)
        uint32[] memory confirmed = new uint32[](1);
        confirmed[0] = 0; // TX_INDEX_COORDINATOR

        CoordinatorState.Data memory cs = CoordinatorState.Data({
            commit_protocol: Tx.CommitProtocol.COMMIT_PROTOCOL_SIMPLE,
            channels: channels,
            phase: phase,
            decision: CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_UNKNOWN,
            confirmed_txs: confirmed,
            acks: new uint32[](0)
        });
        harness.setCoordinatorState(TX_ID, cs);

        // Also need transaction state for commit/abort execution
        ContractTransactionState.Data memory ts = ContractTransactionState.Data({
            status: ContractTransactionState.ContractTransactionStatus.CONTRACT_TRANSACTION_STATUS_PREPARE,
            prepare_result: ContractTransactionState.PrepareResult.PREPARE_RESULT_OK,
            coordinator_channel: channels[0]
        });
        harness.setContractTxState(TX_ID, 0, ts);

        // Also need TxMsg stored to retrieve signers etc for onCommit/onAbort
        harness.setTxMsg(TX_ID, _createValidSimpleMsg());
    }

    // --- handlePacket ---

    function test_handlePacket_ReturnsOkAndEmitsEventWhenModuleSucceeds() public {
        Packet memory packet = _createPacketWithCall(TX_ID, hex"c0ffee");

        vm.expectEmit(address(harness));
        emit OnContractCall(abi.encodePacked(TX_ID), 1, true, hex"01");

        bytes memory ack = harness.exposed_handlePacket(packet);

        assertEq(
            uint256(_decodeAckStatus(ack)),
            uint256(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK),
            "ACK should be OK"
        );
    }

    function test_handlePacket_ReturnsFailedAndEmitsEventWhenModuleReverts() public {
        mockModule.setRevertOnCommitImmediately(true);

        Packet memory packet = _createPacketWithCall(TX_ID, hex"00");

        vm.expectEmit(address(harness));
        emit OnContractCall(abi.encodePacked(TX_ID), 1, false, "");

        bytes memory ack = harness.exposed_handlePacket(packet);

        assertEq(
            uint256(_decodeAckStatus(ack)),
            uint256(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_FAILED),
            "ACK should be FAILED"
        );
    }

    function test_handlePacket_ReturnsFailedWhenPayloadEmpty() public {
        HeaderField.Data[] memory fields;
        bytes memory packetDataBytes =
            PacketData.encode(PacketData.Data({header: Header.Data({fields: fields}), payload: bytes("")}));
        Packet memory p;
        p.data = packetDataBytes;

        bytes memory ack = harness.exposed_handlePacket(p);

        assertEq(
            uint256(_decodeAckStatus(ack)),
            uint256(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_FAILED),
            "ACK should be FAILED when payload is empty"
        );
    }

    function test_handlePacket_ReturnsFailedWhenTypeURLUnexpected() public {
        bytes memory bogus = Any.encode(Any.Data({type_url: "/not.expected", value: hex"01"}));
        HeaderField.Data[] memory fields;
        bytes memory packetDataBytes =
            PacketData.encode(PacketData.Data({header: Header.Data({fields: fields}), payload: bogus}));
        Packet memory p;
        p.data = packetDataBytes;

        bytes memory ack = harness.exposed_handlePacket(p);

        assertEq(
            uint256(_decodeAckStatus(ack)),
            uint256(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_FAILED),
            "ACK should be FAILED when TypeURL is unexpected"
        );
    }

    // --- handleTimeout ---

    function test_handleTimeout_RevertOn_NotImplemented() public {
        Packet memory p;
        vm.expectRevert(NotImplemented.selector);
        harness.exposed_handleTimeout(p);
    }

    // --- _runTx (Simple Protocol) Tests ---

    function test_runTx_Simple_SucceedsAndSendsPacket() public {
        MsgInitiateTx.Data memory msg_ = _createValidSimpleMsg();

        harness.exposed_runTx(TX_ID, msg_);

        // Verify Coordinator State
        CoordinatorState.Data memory cs = harness.getCoordState(TX_ID);
        assertEq(uint256(cs.phase), uint256(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE));
        assertEq(uint256(cs.commit_protocol), uint256(Tx.CommitProtocol.COMMIT_PROTOCOL_SIMPLE));

        // Verify Packet Sent (MockHandler records hash)
        assertNotEq(mockHandler.lastSentPacketHash(), bytes32(0), "Packet should be sent");
    }

    function test_runTx_Simple_RevertWhen_SignerLenMismatch() public {
        MsgInitiateTx.Data memory msg_ = _createValidSimpleMsg();
        // Add 3rd transaction
        ContractTransaction.Data[] memory txs = new ContractTransaction.Data[](3);
        txs[0] = msg_.contract_transactions[0];
        txs[1] = msg_.contract_transactions[1];
        txs[2] = msg_.contract_transactions[1];
        msg_.contract_transactions = txs;

        vm.expectRevert(ArrayLengthMismatch.selector);
        harness.exposed_runTx(TX_ID, msg_);
    }

    function test_runTx_Simple_RevertWhen_Tx0NotLocal() public {
        MsgInitiateTx.Data memory msg_ = _createValidSimpleMsg();
        // Set port/channel for tx0 (should be empty for coordinator)
        msg_.contract_transactions[0].cross_chain_channel.value =
            ChannelInfo.encode(ChannelInfo.Data({port: "p", channel: "c"}));

        vm.expectRevert(Tx0MustBeForSelfChain.selector);
        harness.exposed_runTx(TX_ID, msg_);
    }

    function test_runTx_Simple_PrepareFailed() public {
        MsgInitiateTx.Data memory msg_ = _createValidSimpleMsg();
        mockModule.setPrepareResult(false);

        harness.exposed_runTx(TX_ID, msg_);

        CoordinatorState.Data memory cs = harness.getCoordState(TX_ID);
        // Should transition to COMMIT phase with ABORT decision immediately
        assertEq(uint256(cs.phase), uint256(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_COMMIT));
        assertEq(uint256(cs.decision), uint256(CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_ABORT));
    }

    function test_runTx_RevertWhen_TPCNotImplemented() public {
        MsgInitiateTx.Data memory msg_ = _createValidSimpleMsg();
        msg_.commit_protocol = Tx.CommitProtocol.COMMIT_PROTOCOL_TPC;

        vm.expectRevert(TPCNotImplemented.selector);
        harness.exposed_runTx(TX_ID, msg_);
    }

    function test_runTx_RevertWhen_UnknownCommitProtocol() public {
        MsgInitiateTx.Data memory msg_ = _createValidSimpleMsg();
        msg_.commit_protocol = Tx.CommitProtocol.COMMIT_PROTOCOL_UNKNOWN;

        vm.expectRevert(UnknownCommitProtocol.selector);
        harness.exposed_runTx(TX_ID, msg_);
    }

    function test_runTx_RevertWhen_TimeoutHeight() public {
        MsgInitiateTx.Data memory msg_ = _createValidSimpleMsg();
        msg_.timeout_height.revision_height = 100;

        vm.roll(101); // Block number > timeout

        vm.expectRevert(abi.encodeWithSelector(MessageTimeoutHeight.selector, 101, 100));
        harness.exposed_runTx(TX_ID, msg_);
    }

    function test_runTx_RevertWhen_TimeoutTimestamp() public {
        MsgInitiateTx.Data memory msg_ = _createValidSimpleMsg();
        msg_.timeout_timestamp = 1000;

        vm.warp(1001); // Timestamp > timeout

        vm.expectRevert(abi.encodeWithSelector(MessageTimeoutTimestamp.selector, 1001, 1000));
        harness.exposed_runTx(TX_ID, msg_);
    }

    function test_runTx_RevertWhen_TxIDAlreadyExists() public {
        // Setup state to simulate existing transaction
        _setupCoordStateForAck(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE);

        MsgInitiateTx.Data memory msg_ = _createValidSimpleMsg();

        vm.expectRevert(abi.encodeWithSelector(TxIDAlreadyExists.selector, TX_ID));
        harness.exposed_runTx(TX_ID, msg_);
    }

    function test_runTx_RevertWhen_LinksNotSupported() public {
        MsgInitiateTx.Data memory msg_ = _createValidSimpleMsg();

        // Add a link to the first transaction
        Link.Data[] memory links = new Link.Data[](1);
        links[0] = Link.Data({src_index: 1});
        msg_.contract_transactions[0].links = links;

        vm.expectRevert(LinksNotSupported.selector);
        harness.exposed_runTx(TX_ID, msg_);
    }

    function test_runTx_RevertWhen_ModuleNotInitialized() public {
        MsgInitiateTx.Data memory msg_ = _createValidSimpleMsg();

        // Unregister module
        harness.setModule(IContractModule(address(0)));

        vm.expectRevert(ModuleNotInitialized.selector);
        harness.exposed_runTx(TX_ID, msg_);
    }

    function test_runTx_RevertWhen_ChannelNotFound() public {
        MsgInitiateTx.Data memory msg_ = _createValidSimpleMsg();

        // Mock handler fails to find channel
        mockHandler.setFoundChannel(false);

        vm.expectRevert(ChannelNotFound.selector);
        harness.exposed_runTx(TX_ID, msg_);
    }

    function test_runTx_RevertWhen_UnexpectedReturnValue() public {
        MsgInitiateTx.Data memory msg_ = _createValidSimpleMsg();

        // MockModule returns hex"01" by default (set in setUp)
        // Set expectation to something else to trigger error
        msg_.contract_transactions[0].return_value = ReturnValue.Data(hex"02");

        vm.expectRevert(UnexpectedReturnValue.selector);
        harness.exposed_runTx(TX_ID, msg_);
    }

    // --- _handleAcknowledgement Tests ---

    function test_handleAck_Commit_Success() public {
        _setupCoordStateForAck(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE);

        Packet memory p = _createPacket("port-1", "channel-1");
        bytes memory ack = _createAck(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK);

        harness.exposed_handleAcknowledgement(p, ack);

        CoordinatorState.Data memory cs = harness.getCoordState(TX_ID);
        assertEq(uint256(cs.phase), uint256(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_COMMIT));
        assertEq(uint256(cs.decision), uint256(CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_COMMIT));

        assertTrue(mockModule.onCommitCalled(), "onCommit should be called");
        assertFalse(mockModule.onAbortCalled(), "onAbort should not be called");
    }

    function test_handleAck_Abort_Failure() public {
        _setupCoordStateForAck(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE);

        Packet memory p = _createPacket("port-1", "channel-1");
        bytes memory ack = _createAck(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_FAILED);

        harness.exposed_handleAcknowledgement(p, ack);

        CoordinatorState.Data memory cs = harness.getCoordState(TX_ID);
        assertEq(uint256(cs.phase), uint256(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_COMMIT));
        assertEq(uint256(cs.decision), uint256(CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_ABORT));

        assertTrue(mockModule.onAbortCalled(), "onAbort should be called");
        assertFalse(mockModule.onCommitCalled(), "onCommit should not be called");
    }

    function test_handleAck_RevertWhen_AckIsNotSuccess() public {
        _setupCoordStateForAck(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE);

        Packet memory p = _createPacket("port-1", "channel-1");

        // Create an Ack with is_success = false
        bytes memory res = hex"";
        bytes memory ack = Acknowledgement.encode(Acknowledgement.Data(false, res));

        vm.expectRevert(AckIsNotSuccess.selector);
        harness.exposed_handleAcknowledgement(p, ack);
    }

    function test_handleAck_RevertWhen_AckPayloadDecodeFailed() public {
        _setupCoordStateForAck(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE);

        Packet memory p = _createPacket("port-1", "channel-1");

        // PacketData with empty payload
        bytes memory emptyPayload =
            PacketData.encode(PacketData.Data(Header.Data(new HeaderField.Data[](0)), bytes("")));
        bytes memory ack = Acknowledgement.encode(Acknowledgement.Data(true, emptyPayload));

        vm.expectRevert(PayloadDecodeFailed.selector);
        harness.exposed_handleAcknowledgement(p, ack);
    }

    function test_handleAck_RevertWhen_AckTypeURLUnexpected() public {
        _setupCoordStateForAck(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE);

        Packet memory p = _createPacket("port-1", "channel-1");

        // Wrong type URL
        PacketAcknowledgementCall.Data memory pac =
            PacketAcknowledgementCall.Data(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK);
        bytes memory payload = Any.encode(Any.Data("/wrong.type.url", PacketAcknowledgementCall.encode(pac)));
        bytes memory res = PacketData.encode(PacketData.Data(Header.Data(new HeaderField.Data[](0)), payload));
        bytes memory ack = Acknowledgement.encode(Acknowledgement.Data(true, res));

        vm.expectRevert(UnexpectedTypeURL.selector);
        harness.exposed_handleAcknowledgement(p, ack);
    }

    function test_handleAck_RevertWhen_PacketPayloadDecodeFailed() public {
        _setupCoordStateForAck(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE);

        // Create packet with empty payload data
        Packet memory p = _createPacket("port-1", "channel-1");
        p.data = PacketData.encode(PacketData.Data(Header.Data(new HeaderField.Data[](0)), bytes("")));

        bytes memory ack = _createAck(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK);

        vm.expectRevert(PayloadDecodeFailed.selector);
        harness.exposed_handleAcknowledgement(p, ack);
    }

    function test_handleAck_RevertWhen_PacketTypeURLUnexpected() public {
        _setupCoordStateForAck(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE);

        // Packet with wrong type URL
        Packet memory p = _createPacket("port-1", "channel-1");

        PacketDataCall.Data memory pdc = PacketDataCall.Data({
            tx_id: abi.encode(TX_ID),
            tx: PacketDataCallResolvedContractTransaction.Data(
                Any.Data("", ""), new AuthAccount.Data[](0), "", ReturnValue.Data(""), new Any.Data[](0)
            )
        });

        bytes memory payload = Any.encode(Any.Data("/wrong.packet.type", PacketDataCall.encode(pdc)));
        bytes memory data = PacketData.encode(PacketData.Data(Header.Data(new HeaderField.Data[](0)), payload));
        p.data = data;

        bytes memory ack = _createAck(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK);

        vm.expectRevert(UnexpectedTypeURL.selector);
        harness.exposed_handleAcknowledgement(p, ack);
    }

    function test_handleAck_RevertWhen_InvalidTxIDLength() public {
        _setupCoordStateForAck(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE);

        // Packet with wrong TxID length (empty bytes instead of 32 bytes)
        Packet memory p = _createPacket("port-1", "channel-1");

        PacketDataCall.Data memory pdc = PacketDataCall.Data({
            tx_id: hex"", // Empty ID
            tx: PacketDataCallResolvedContractTransaction.Data(
                Any.Data("", ""), new AuthAccount.Data[](0), "", ReturnValue.Data(""), new Any.Data[](0)
            )
        });

        bytes memory payload =
            Any.encode(Any.Data("/cross.core.atomic.simple.PacketDataCall", PacketDataCall.encode(pdc)));
        bytes memory data = PacketData.encode(PacketData.Data(Header.Data(new HeaderField.Data[](0)), payload));
        p.data = data;

        bytes memory ack = _createAck(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK);

        vm.expectRevert(InvalidTxIDLength.selector);
        harness.exposed_handleAcknowledgement(p, ack);
    }

    function test_handleAck_RevertWhen_CoordinatorStateNotFound() public {
        _setupCoordStateForAck(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE);

        // Set protocol to unknown to simulate state not found
        CoordinatorState.Data memory cs = harness.getCoordState(TX_ID);
        cs.commit_protocol = Tx.CommitProtocol.COMMIT_PROTOCOL_UNKNOWN;
        harness.setCoordinatorState(TX_ID, cs);

        Packet memory p = _createPacket("port-1", "channel-1");
        bytes memory ack = _createAck(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK);

        vm.expectRevert(abi.encodeWithSelector(CoordinatorStateNotFound.selector, TX_ID));
        harness.exposed_handleAcknowledgement(p, ack);
    }

    function test_handleAck_RevertWhen_CoordinatorPhaseNotPrepare() public {
        _setupCoordStateForAck(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_COMMIT);

        Packet memory p = _createPacket("port-1", "channel-1");
        bytes memory ack = _createAck(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK);

        vm.expectRevert(CoordinatorPhaseNotPrepare.selector);
        harness.exposed_handleAcknowledgement(p, ack);
    }

    function test_handleAck_RevertWhen_AllTransactionsConfirmed() public {
        _setupCoordStateForAck(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE);

        // Mark both as confirmed
        CoordinatorState.Data memory cs = harness.getCoordState(TX_ID);
        uint32[] memory allConfirmed = new uint32[](2);
        allConfirmed[0] = 0; // Coordinator
        allConfirmed[1] = 1; // Participant
        cs.confirmed_txs = allConfirmed;
        harness.setCoordinatorState(TX_ID, cs);

        Packet memory p = _createPacket("port-1", "channel-1");
        bytes memory ack = _createAck(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK);

        vm.expectRevert(AllTransactionsConfirmed.selector);
        harness.exposed_handleAcknowledgement(p, ack);
    }

    function test_handleAck_RevertWhen_ChannelNotFound() public {
        _setupCoordStateForAck(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE);

        Packet memory p = _createPacket("port-1", "channel-1");
        bytes memory ack = _createAck(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK);

        // Mock Handler returns not found
        mockHandler.setFoundChannel(false);

        vm.expectRevert(ChannelNotFound.selector);
        harness.exposed_handleAcknowledgement(p, ack);
    }

    function test_handleAck_RevertWhen_ChannelMismatch() public {
        _setupCoordStateForAck(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE);

        Packet memory p = _createPacket("port-bad", "channel-bad"); // Wrong channel
        bytes memory ack = _createAck(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK);

        vm.expectRevert(UnexpectedSourceChannel.selector);
        harness.exposed_handleAcknowledgement(p, ack);
    }

    function test_handleAck_RevertWhen_UnexpectedCommitStatus() public {
        _setupCoordStateForAck(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE);

        Packet memory p = _createPacket("port-1", "channel-1");

        // Status UNKNOWN (0)
        bytes memory ack = _createAck(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_UNKNOWN);

        vm.expectRevert(UnexpectedCommitStatus.selector);
        harness.exposed_handleAcknowledgement(p, ack);
    }

    function test_handleAck_RevertWhen_CoordinatorStateInconsistent() public {
        _setupCoordStateForAck(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE);

        // Remove coordinator confirmation to trigger inconsistency
        // (logic expects that if we are here, we are adding participant confirmation, so we should have coordinator confirmed)
        CoordinatorState.Data memory cs = harness.getCoordState(TX_ID);
        cs.confirmed_txs = new uint32[](0); // Empty confirmation
        harness.setCoordinatorState(TX_ID, cs);

        Packet memory p = _createPacket("port-1", "channel-1");
        bytes memory ack = _createAck(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK);

        vm.expectRevert(CoordinatorStateInconsistent.selector);
        harness.exposed_handleAcknowledgement(p, ack);
    }

    function test_handleAck_RevertWhen_CoordinatorTxStatusNotPrepare() public {
        _setupCoordStateForAck(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE);

        // Set local tx state to something else (e.g. ABORT)
        ContractTransactionState.Data memory ts = harness.getContractTxState(TX_ID, 0);
        ts.status = ContractTransactionState.ContractTransactionStatus.CONTRACT_TRANSACTION_STATUS_ABORT;
        harness.setContractTxState(TX_ID, 0, ts);

        Packet memory p = _createPacket("port-1", "channel-1");
        bytes memory ack = _createAck(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK);

        vm.expectRevert(CoordinatorTxStatusNotPrepare.selector);
        harness.exposed_handleAcknowledgement(p, ack);
    }

    function test_handleAck_RevertWhen_ModuleNotInitialized() public {
        _setupCoordStateForAck(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE);

        Packet memory p = _createPacket("port-1", "channel-1");
        bytes memory ack = _createAck(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK);

        // Unregister module
        harness.setModule(IContractModule(address(0)));

        vm.expectRevert(ModuleNotInitialized.selector);
        harness.exposed_handleAcknowledgement(p, ack);
    }

    function test_handleAck_RevertWhen_StateNotFound() public {
        Packet memory p = _createPacket("port-1", "channel-1");
        bytes memory ack = _createAck(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK);

        vm.expectRevert(abi.encodeWithSelector(CoordinatorStateNotFound.selector, TX_ID));
        harness.exposed_handleAcknowledgement(p, ack);
    }
}
