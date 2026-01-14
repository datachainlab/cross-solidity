// SPDX-License-Identifier: Apache-2.0
// solhint-disable function-max-lines
pragma solidity ^0.8.20;

import {GoogleProtobufAny as Any} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";
import {Packet} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IIBCChannel.sol";
import {Height} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/Client.sol";

import "./PacketHandler.sol";
import "./ContractRegistry.sol";
import "./IContractModule.sol";
import "./IBCKeeper.sol";
import {TxRunnerBase} from "./TxRunnerBase.sol";
import {ICrossError} from "./ICrossError.sol";
import {ICrossEvent} from "./ICrossEvent.sol";

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
} from "../proto/cross/core/atomic/simple/AtomicSimple.sol";

import {MsgInitiateTx, Tx, ContractTransaction} from "../proto/cross/core/initiator/Initiator.sol";
import {ChannelInfo} from "../proto/cross/core/xcc/XCC.sol";

import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";

// TxAtomicSimple implements PacketHandler and TxRunnerBase supporting the simple-commit protocol
abstract contract TxAtomicSimple is
    Initializable,
    IBCKeeper,
    PacketHandler,
    TxRunnerBase,
    ContractRegistry,
    ICrossError,
    ICrossEvent
{
    function __initTxAtomicSimple(IIBCHandler handler_, IContractModule module) internal virtual onlyInitializing {
        __initIBCKeeper(handler_);
        registerModule(module);
    }

    uint8 private constant TX_INDEX_COORDINATOR = 0;
    uint8 private constant TX_INDEX_PARTICIPANT = 1;

    function _runTx(bytes32 txID, MsgInitiateTx.Data calldata msg_) internal virtual override {
        if (msg_.commit_protocol == Tx.CommitProtocol.COMMIT_PROTOCOL_SIMPLE) {
            _runSimpleProtocol(txID, msg_);
        } else if (msg_.commit_protocol == Tx.CommitProtocol.COMMIT_PROTOCOL_TPC) {
            revert TPCNotImplemented();
        } else {
            revert UnknownCommitProtocol();
        }
    }

    function _runSimpleProtocol(bytes32 txID, MsgInitiateTx.Data calldata msg_) internal {
        TxStorage storage txStorage = _getTxStorage();

        if (msg_.contract_transactions.length != 2) {
            revert ArrayLengthMismatch();
        }

        if (msg_.timeout_height.revision_height > 0 && block.number > msg_.timeout_height.revision_height - 1) {
            revert MessageTimeoutHeight(block.number, msg_.timeout_height.revision_height);
        }

        // slither-disable-next-line timestamp
        if (msg_.timeout_timestamp > 0 && block.timestamp > msg_.timeout_timestamp - 1) {
            revert MessageTimeoutTimestamp(block.timestamp, msg_.timeout_timestamp);
        }

        if (_loadCoordinatorState(txID).commit_protocol != Tx.CommitProtocol.COMMIT_PROTOCOL_UNKNOWN) {
            revert TxIDAlreadyExists(txID);
        }

        // --- 2. Setup Transaction & XCC ---

        ContractTransaction.Data calldata tx0 = msg_.contract_transactions[TX_INDEX_COORDINATOR];
        ContractTransaction.Data calldata tx1 = msg_.contract_transactions[TX_INDEX_PARTICIPANT];

        // Simple protocol does not support links
        if (tx0.links.length > 0 || tx1.links.length > 0) {
            revert LinksNotSupported();
        }

        ChannelInfo.Data memory ch0 = ChannelInfo.decode(tx0.cross_chain_channel.value);
        ChannelInfo.Data memory ch1 = ChannelInfo.decode(tx1.cross_chain_channel.value);

        // Ensure tx0 points to self (empty port/channel)
        if (bytes(ch0.port).length != 0 || bytes(ch0.channel).length != 0) {
            revert Tx0MustBeForSelfChain();
        }

        // --- 3. Local Prepare (Coordinator) ---

        CoordinatorState.CoordinatorPhase phase = CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_UNKNOWN;
        CoordinatorState.CoordinatorDecision decision =
        CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_UNKNOWN;
        bool prepareOK = false;

        // Use a block scope to avoid "Stack Too Deep" error by limiting the lifetime of temporary variables
        {
            // Dummy packet for getModule (local execution)
            Height.Data memory emptyHeight = Height.Data(0, 0);
            // TODO: SimpleContractRegistry is designed to have only a single ContractModule,
            // but it is not correct to force that assumption on the caller as well.
            // We should generate a proper Packet instead of dummyPacket to support multiple modules.
            Packet memory dummyPacket = Packet({
                sequence: 0,
                sourcePort: "",
                sourceChannel: "",
                destinationPort: "",
                destinationChannel: "",
                data: bytes(""),
                timeoutHeight: emptyHeight,
                timeoutTimestamp: 0
            });

            IContractModule module = getModule(dummyPacket);
            if (address(module) == address(0)) {
                revert ModuleNotInitialized();
            }

            // slither-disable-next-line reentrancy-no-eth
            try module.onContractPrepare(
                CrossContext({txID: abi.encodePacked(txID), txIndex: TX_INDEX_COORDINATOR, signers: tx0.signers}),
                tx0.call_info
            ) returns (bytes memory callResult) {
                if (tx0.return_value.value.length > 0) {
                    if (keccak256(tx0.return_value.value) != keccak256(callResult)) {
                        revert UnexpectedReturnValue();
                    }
                }
                prepareOK = true;
                phase = CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE;
                decision = CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_UNKNOWN;
            } catch {
                prepareOK = false;
                phase = CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_COMMIT;
                decision = CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_ABORT;
            }
        }

        // --- 4. Send IBC Packet (only if prepareOK) ---

        if (prepareOK) {
            // slither-disable-next-line unused-return
            (, bool found) = getIBCHandler().getChannel(ch1.port, ch1.channel);
            if (!found) {
                revert ChannelNotFound();
            }

            // Construct PacketDataCall
            PacketDataCall.Data memory callData = PacketDataCall.Data({
                tx_id: abi.encodePacked(txID),
                tx: PacketDataCallResolvedContractTransaction.Data({
                    cross_chain_channel: tx1.cross_chain_channel,
                    signers: tx1.signers,
                    call_info: tx1.call_info,
                    return_value: tx1.return_value,
                    objects: new GoogleProtobufAny.Data[](0)
                })
            });

            // Wrap in Any
            // solhint-disable-next-line gas-small-strings
            Any.Data memory anyPayload = Any.Data({
                type_url: "/cross.core.atomic.simple.PacketDataCall", value: PacketDataCall.encode(callData)
            });

            // Wrap in PacketData
            Header.Data memory header = Header.Data({fields: new HeaderField.Data[](0)});
            PacketData.Data memory pd = PacketData.Data({header: header, payload: Any.encode(anyPayload)});

            bytes memory finalPacketData = PacketData.encode(pd);

            // slither-disable-next-line unused-return reentrancy-no-eth
            getIBCHandler()
                .sendPacket(
                    ch1.port,
                    ch1.channel,
                    // Simple protocol does not support packet timeouts
                    Height.Data(0, type(uint64).max),
                    0,
                    finalPacketData
                );
        }

        // --- 5. Save CoordinatorState ---

        ChannelInfo.Data[] memory channels = new ChannelInfo.Data[](2);
        channels[0] = ch0;
        channels[1] = ch1;

        uint32[] memory confirmedTxs = new uint32[](1);
        confirmedTxs[0] = TX_INDEX_COORDINATOR;

        uint32[] memory acks;
        if (!prepareOK) {
            acks = new uint32[](2);
            acks[0] = TX_INDEX_COORDINATOR;
            acks[1] = TX_INDEX_PARTICIPANT;
        } else {
            acks = new uint32[](0);
        }

        CoordinatorState.Data memory newState = CoordinatorState.Data({
            commit_protocol: Tx.CommitProtocol.COMMIT_PROTOCOL_SIMPLE,
            channels: channels,
            phase: phase,
            decision: decision,
            confirmed_txs: confirmedTxs,
            acks: acks
        });

        _saveCoordinatorState(txID, newState);

        // --- 6. Save ContractTransactionState ---

        ContractTransactionState.ContractTransactionStatus status;
        ContractTransactionState.PrepareResult prepareStatus;

        if (prepareOK) {
            status = ContractTransactionState.ContractTransactionStatus.CONTRACT_TRANSACTION_STATUS_PREPARE;
            prepareStatus = ContractTransactionState.PrepareResult.PREPARE_RESULT_OK;
        } else {
            status = ContractTransactionState.ContractTransactionStatus.CONTRACT_TRANSACTION_STATUS_ABORT;
            prepareStatus = ContractTransactionState.PrepareResult.PREPARE_RESULT_FAILED;
        }

        txStorage.states[txID][TX_INDEX_COORDINATOR] =
            ContractTransactionState.Data({status: status, prepare_result: prepareStatus, coordinator_channel: ch0});
    }

    /**
     * @dev Participant side: Receive PacketDataCall, execute onContractCall, and return ACK.
     */
    function _handlePacket(Packet calldata packet) internal virtual override returns (bytes memory acknowledgement) {
        PacketAcknowledgementCall.Data memory ack =
            PacketAcknowledgementCall.Data({status: PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_FAILED});

        IContractModule module = getModule(packet);

        PacketData.Data memory pd = PacketData.decode(packet.data);
        if (pd.payload.length == 0) return packPacketAcknowledgementCall(ack);

        Any.Data memory anyPayload = Any.decode(pd.payload);
        // TODO should be more gas efficient
        // solhint-disable-next-line gas-small-strings
        if (sha256(bytes(anyPayload.type_url)) != sha256(bytes("/cross.core.atomic.simple.PacketDataCall"))) {
            return packPacketAcknowledgementCall(ack);
        }
        PacketDataCall.Data memory pdc = PacketDataCall.decode(anyPayload.value);

        try module.onContractCommitImmediately(
            CrossContext(pdc.tx_id, TX_INDEX_PARTICIPANT, pdc.tx.signers), pdc.tx.call_info
        ) returns (bytes memory ret) {
            ack.status = PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK;
            // slither-disable-next-line reentrancy-events
            emit OnContractCommitImmediately(pdc.tx_id, TX_INDEX_PARTICIPANT, true, ret);
        } catch (bytes memory) {
            ack.status = PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_FAILED;
            // slither-disable-next-line reentrancy-events
            emit OnContractCommitImmediately(pdc.tx_id, TX_INDEX_PARTICIPANT, false, new bytes(0));
        }

        return packPacketAcknowledgementCall(ack);
    }

    /**
     * @dev Coordinator side: Handle ACK, update CoordinatorState, and execute Commit/Abort.
     */
    function _handleAcknowledgement(Packet calldata packet, bytes calldata acknowledgement) internal virtual override {
        // --- 1. Decode Acknowledgement ---

        Acknowledgement.Data memory ackOuter = Acknowledgement.decode(acknowledgement);
        // Simple protocol assumes is_success=true
        if (!ackOuter.is_success) {
            revert AckIsNotSuccess();
        }

        PacketData.Data memory ackPd = PacketData.decode(ackOuter.result);
        if (ackPd.payload.length == 0) revert PayloadDecodeFailed();

        Any.Data memory ackAny = Any.decode(ackPd.payload);
        // solhint-disable-next-line gas-small-strings
        if (sha256(bytes(ackAny.type_url)) != sha256(bytes("/cross.core.atomic.simple.PacketAcknowledgementCall"))) {
            revert UnexpectedTypeURL();
        }

        PacketAcknowledgementCall.Data memory ack = PacketAcknowledgementCall.decode(ackAny.value);

        // --- 2. Recover txID from original Packet ---

        PacketData.Data memory callPd = PacketData.decode(packet.data);
        if (callPd.payload.length == 0) revert PayloadDecodeFailed();

        Any.Data memory callAny = Any.decode(callPd.payload);
        // solhint-disable-next-line gas-small-strings
        if (sha256(bytes(callAny.type_url)) != sha256(bytes("/cross.core.atomic.simple.PacketDataCall"))) {
            revert UnexpectedTypeURL();
        }
        PacketDataCall.Data memory pdc = PacketDataCall.decode(callAny.value);

        if (pdc.tx_id.length != 32) {
            revert InvalidTxIDLength();
        }
        bytes32 txID = abi.decode(pdc.tx_id, (bytes32));

        // --- 3. Retrieve & Validate CoordinatorState ---

        TxStorage storage txStorage = _getTxStorage();

        CoordinatorState.Data memory cs = _loadCoordinatorState(txID);
        if (cs.commit_protocol == Tx.CommitProtocol.COMMIT_PROTOCOL_UNKNOWN) {
            revert CoordinatorStateNotFound(txID);
        }

        if (cs.phase != CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE) {
            revert CoordinatorPhaseNotPrepare();
        }

        bool allPreparesAlreadyConfirmed =
            _containsUint32(cs.confirmed_txs, TX_INDEX_COORDINATOR)
            && _containsUint32(cs.confirmed_txs, TX_INDEX_PARTICIPANT);
        if (allPreparesAlreadyConfirmed) {
            revert AllTransactionsConfirmed();
        }

        // --- 4. Validate Channel ---
        // slither-disable-next-line unused-return
        (, bool found) = getIBCHandler().getChannel(packet.sourcePort, packet.sourceChannel);
        if (!found) {
            revert ChannelNotFound();
        }

        // Verify Participant channel matches
        require(cs.channels.length == 2, "channels length must be 2");
        ChannelInfo.Data memory expectedParticipantChannel = cs.channels[TX_INDEX_PARTICIPANT];

        if (
            keccak256(bytes(expectedParticipantChannel.port)) != keccak256(bytes(packet.sourcePort))
                || keccak256(bytes(expectedParticipantChannel.channel)) != keccak256(bytes(packet.sourceChannel))
        ) {
            revert UnexpectedSourceChannel();
        }

        // Mark Participant prepare as confirmed
        if (!_containsUint32(cs.confirmed_txs, TX_INDEX_PARTICIPANT)) {
            _confirmParticipant(txID);
        }

        // --- 5. Determine Commit/Abort based on ACK ---

        bool isCommittable = false;

        if (ack.status == PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK) {
            cs.decision = CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_COMMIT;
            isCommittable = true;
        } else if (ack.status == PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_FAILED) {
            cs.decision = CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_ABORT;
            isCommittable = false;
        } else {
            revert UnexpectedCommitStatus();
        }

        cs.phase = CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_COMMIT;

        // Set ACK flags
        CoordinatorState.CoordinatorDecision decision;
        if (ack.status == PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK) {
            decision = CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_COMMIT;
        } else {
            decision = CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_ABORT;
        }

        _completeSimpleProtocol(txID, CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_COMMIT, decision);

        cs = _loadCoordinatorState(txID);

        bool allPrepares =
            _containsUint32(cs.confirmed_txs, TX_INDEX_COORDINATOR)
            && _containsUint32(cs.confirmed_txs, TX_INDEX_PARTICIPANT);
        bool allCommits =
            _containsUint32(cs.acks, TX_INDEX_COORDINATOR) && _containsUint32(cs.acks, TX_INDEX_PARTICIPANT);
        if (!allPrepares || !allCommits) {
            revert CoordinatorStateInconsistent();
        }

        // --- 6. Execute Local Commit/Abort ---

        ContractTransactionState.Data storage txState = txStorage.states[txID][TX_INDEX_COORDINATOR];

        if (txState.status != ContractTransactionState.ContractTransactionStatus.CONTRACT_TRANSACTION_STATUS_PREPARE) {
            revert CoordinatorTxStatusNotPrepare();
        }

        // Dummy packet for getModule
        Height.Data memory emptyHeight = Height.Data(0, 0);
        // TODO: SimpleContractRegistry is designed to have only a single ContractModule,
        // but it is not correct to force that assumption on the caller as well.
        // We should generate a proper Packet instead of dummyPacket to support multiple modules.
        Packet memory dummyPacket = Packet({
            sequence: 0,
            sourcePort: "",
            sourceChannel: "",
            destinationPort: "",
            destinationChannel: "",
            data: bytes(""),
            timeoutHeight: emptyHeight,
            timeoutTimestamp: 0
        });

        IContractModule module = getModule(dummyPacket);
        if (address(module) == address(0)) {
            revert ModuleNotInitialized();
        }

        Account.Data[] storage txCoordSigners = txStorage.txCoordSigners[txID];

        CrossContext memory ctx =
            CrossContext({txID: abi.encodePacked(txID), txIndex: TX_INDEX_COORDINATOR, signers: txCoordSigners});

        if (isCommittable) {
            // Commit
            module.onCommit(ctx);
            txState.status = ContractTransactionState.ContractTransactionStatus.CONTRACT_TRANSACTION_STATUS_COMMIT;
            // slither-disable-next-line reentrancy-events
            emit OnCommit(abi.encodePacked(txID), TX_INDEX_COORDINATOR);
        } else {
            // Abort
            module.onAbort(ctx);
            txState.status = ContractTransactionState.ContractTransactionStatus.CONTRACT_TRANSACTION_STATUS_ABORT;
            // slither-disable-next-line reentrancy-events
            emit OnAbort(abi.encodePacked(txID), TX_INDEX_COORDINATOR);
        }
        // gas optimization: clean up txCoordSigners storage
        delete txStorage.txCoordSigners[txID];
    }

    function _handleTimeout(
        Packet calldata /*packet*/
    )
        internal
        virtual
        override
    {
        revert NotImplemented();
    }

    // --- Helpers ---

    function _containsUint32(uint32[] memory arr, uint32 value) internal view returns (bool) {
        for (uint256 i = 0; i < arr.length; ++i) {
            if (arr[i] == value) return true;
        }
        return false;
    }

    function packPacketAcknowledgementCall(PacketAcknowledgementCall.Data memory ack)
        internal
        pure
        returns (bytes memory)
    {
        HeaderField.Data[] memory fields = new HeaderField.Data[](0);
        return Acknowledgement.encode(
            Acknowledgement.Data({
                is_success: true,
                result: PacketData.encode(
                    PacketData.Data({
                        header: Header.Data({fields: fields}),
                        payload: Any.encode(
                            // solhint-disable-next-line gas-small-strings
                            Any.Data({
                                type_url: "/cross.core.atomic.simple.PacketAcknowledgementCall",
                                value: PacketAcknowledgementCall.encode(ack)
                            })
                        )
                    })
                )
            })
        );
    }
}
