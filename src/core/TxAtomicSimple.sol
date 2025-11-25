// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {GoogleProtobufAny as Any} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";
import {Packet, Channel} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IIBCChannel.sol";
import {Height} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/Client.sol";

import "./PacketHandler.sol";
import "./ContractRegistry.sol";
import "./IContractModule.sol";
import "./IBCKeeper.sol";
import {TxRunnerBase} from "./TxRunnerBase.sol";
import {CrossStore} from "./CrossStore.sol";
import {ICrossError} from "./ICrossError.sol";

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

// TxAtomicSimple implements PacketHandler and TxRunnerBase supporting the simple-commit protocol
abstract contract TxAtomicSimple is IBCKeeper, PacketHandler, TxRunnerBase, ContractRegistry, CrossStore, ICrossError {
    constructor(IIBCHandler handler_, IContractModule module) IBCKeeper(handler_) {
        registerModule(module);
    }

    uint8 private constant TX_INDEX_COORDINATOR = 0;
    uint8 private constant TX_INDEX_PARTICIPANT = 1;

    event OnContractCall(bytes indexed txID, uint8 indexed txIndex, bool indexed success, bytes ret);

    function _runTx(bytes32 txID, MsgInitiateTx.Data storage msg_) internal virtual override {
        if (msg_.commit_protocol == Tx.CommitProtocol.COMMIT_PROTOCOL_SIMPLE) {
            _runSimpleProtocol(txID, msg_);
        } else if (msg_.commit_protocol == Tx.CommitProtocol.COMMIT_PROTOCOL_TPC) {
            revert("TPC protocol not implemented");
        } else {
            revert("Unknown commit protocol");
        }
    }

    function _runSimpleProtocol(bytes32 txID, MsgInitiateTx.Data storage msg_) internal {
        CoordStorage storage coordStorage = _getCoordStorage();
        TxStorage storage txStorage = _getTxStorage();

        if (msg_.contract_transactions.length != 2) {
            revert ArrayLengthMismatch();
        }

        if (msg_.timeout_height.revision_height > 0 && block.number >= msg_.timeout_height.revision_height) {
            revert MessageTimeoutHeight(block.number, msg_.timeout_height.revision_height);
        }

        // slither-disable-next-line timestamp
        if (msg_.timeout_timestamp > 0 && block.timestamp >= msg_.timeout_timestamp) {
            revert MessageTimeoutTimestamp(block.timestamp, msg_.timeout_timestamp);
        }

        if (coordStorage.states[txID].exists) {
            revert TxIDAlreadyExists(txID);
        }

        // --- 2. Setup Transaction & XCC ---

        ContractTransaction.Data storage tx0 = msg_.contract_transactions[TX_INDEX_COORDINATOR];
        ContractTransaction.Data storage tx1 = msg_.contract_transactions[TX_INDEX_PARTICIPANT];

        // Simple protocol does not support links
        if (tx0.links.length > 0 || tx1.links.length > 0) {
            revert("simple protocol does not support links");
        }

        ChannelInfo.Data memory ch0 = abi.decode(tx0.cross_chain_channel.value, (ChannelInfo.Data));
        ChannelInfo.Data memory ch1 = abi.decode(tx1.cross_chain_channel.value, (ChannelInfo.Data));

        // Ensure tx0 points to self (empty port/channel)
        if (bytes(ch0.port).length != 0 || bytes(ch0.channel).length != 0) {
            revert("tx0 must be for self chain");
        }

        // --- 3. Local Prepare (Coordinator) ---

        // Dummy packet for getModule (local execution)
        Height.Data memory emptyHeight = Height.Data(0, 0);
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

        CoordinatorState.CoordinatorPhase phase = CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_UNKNOWN;
        CoordinatorState.CoordinatorDecision decision =
        CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_UNKNOWN;
        bool prepareOK = false;
        try module.onContractPrepare(
            CrossContext({txID: abi.encodePacked(txID), txIndex: TX_INDEX_COORDINATOR, signers: tx0.signers}),
            tx0.call_info
        ) returns (bytes memory callResult) {
            // Verify return value if set
            if (tx0.return_value.value.length > 0) {
                if (keccak256(tx0.return_value.value) != keccak256(callResult)) {
                    revert("unexpected return value");
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

        // --- 4. Send IBC Packet (only if prepareOK) ---

        if (prepareOK) {
            (Channel.Data memory channel, bool found) = getIBCHandler().getChannel(ch1.port, ch1.channel);
            if (!found) {
                revert("channel not found");
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
            Any.Data memory anyPayload = Any.Data({
                // solhint-disable-next-line gas-small-strings
                type_url: "/cross.core.atomic.simple.PacketDataCall",
                value: PacketDataCall.encode(callData)
            });

            // Wrap in PacketData
            Header.Data memory header = Header.Data({fields: new HeaderField.Data[](0)});
            PacketData.Data memory pd = PacketData.Data({header: header, payload: Any.encode(anyPayload)});

            bytes memory finalPacketData = PacketData.encode(pd);

            // slither-disable-next-line unused-return
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

        coordStorage.states[txID] = CoordEntry({exists: true, data: newState});

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
    function _handlePacket(Packet memory packet) internal virtual override returns (bytes memory acknowledgement) {
        IContractModule module = getModule(packet);

        PacketData.Data memory pd = PacketData.decode(packet.data);
        if (pd.payload.length == 0) revert PayloadDecodeFailed();

        Any.Data memory anyPayload = Any.decode(pd.payload);
        // TODO should be more gas efficient
        // solhint-disable-next-line gas-small-strings
        if (sha256(bytes(anyPayload.type_url)) != sha256(bytes("/cross.core.atomic.simple.PacketDataCall"))) {
            revert UnexpectedTypeURL();
        }
        PacketDataCall.Data memory pdc = PacketDataCall.decode(anyPayload.value);

        PacketAcknowledgementCall.Data memory ack =
            PacketAcknowledgementCall.Data({status: PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_UNKNOWN});
        try module.onContractCall(
            CrossContext(pdc.tx_id, TX_INDEX_PARTICIPANT, pdc.tx.signers), pdc.tx.call_info
        ) returns (bytes memory ret) {
            ack.status = PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK;
            // slither-disable-next-line reentrancy-events
            emit OnContractCall(pdc.tx_id, TX_INDEX_PARTICIPANT, true, ret);
        } catch (bytes memory) {
            ack.status = PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_FAILED;
            // slither-disable-next-line reentrancy-events
            emit OnContractCall(pdc.tx_id, TX_INDEX_PARTICIPANT, false, new bytes(0));
        }

        return packPacketAcknowledgementCall(ack);
    }

    /**
     * @dev Coordinator side: Handle ACK, update CoordinatorState, and execute Commit/Abort.
     */
    function _handleAcknowledgement(Packet memory packet, bytes memory acknowledgement) internal virtual override {
        // --- 1. Decode Acknowledgement ---

        Acknowledgement.Data memory ackOuter = Acknowledgement.decode(acknowledgement);
        // Simple protocol assumes is_success=true
        if (!ackOuter.is_success) {
            revert("ack is not success");
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

        bytes32 txID = _bytesToBytes32(pdc.tx_id);

        // --- 3. Process Acknowledgement & TryCommit ---

        _receiveCallAcknowledgement(txID, packet.sourcePort, packet.sourceChannel, ack);
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

    // --- ACK Processing & Local Commit Logic ---

    function _receiveCallAcknowledgement(
        bytes32 txID,
        string memory sourcePort,
        string memory sourceChannel,
        PacketAcknowledgementCall.Data memory ack
    ) internal {
        CoordStorage storage coordStorage = _getCoordStorage();
        TxStorage storage txStorage = _getTxStorage();

        // --- 1. Retrieve & Validate CoordinatorState ---

        CoordEntry storage entry = coordStorage.states[txID];
        if (!entry.exists) {
            revert("coordinator state not found");
        }

        CoordinatorState.Data storage cs = entry.data;

        if (cs.phase != CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE) {
            revert("coordinator phase must be PREPARE");
        }

        bool allPreparesAlreadyConfirmed =
            _containsUint32(cs.confirmed_txs, TX_INDEX_COORDINATOR)
            && _containsUint32(cs.confirmed_txs, TX_INDEX_PARTICIPANT);
        if (allPreparesAlreadyConfirmed) {
            revert("all transactions are already confirmed");
        }

        // --- 2. Validate Channel ---

        (Channel.Data memory channel, bool found) = getIBCHandler().getChannel(sourcePort, sourceChannel);
        if (!found) {
            revert("channel not found");
        }

        // Verify Participant channel matches
        require(cs.channels.length == 2, "channels length must be 2");
        ChannelInfo.Data memory expectedParticipantChannel = cs.channels[TX_INDEX_PARTICIPANT];

        if (
            keccak256(bytes(expectedParticipantChannel.port)) != keccak256(bytes(sourcePort))
                || keccak256(bytes(expectedParticipantChannel.channel)) != keccak256(bytes(sourceChannel))
        ) {
            revert("unexpected source channel for participant");
        }

        // Mark Participant prepare as confirmed
        if (!_containsUint32(cs.confirmed_txs, TX_INDEX_PARTICIPANT)) {
            cs.confirmed_txs.push(TX_INDEX_PARTICIPANT);
        }

        // --- 3. Determine Commit/Abort based on ACK ---

        bool isCommittable = false;

        if (ack.status == PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK) {
            cs.decision = CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_COMMIT;
            isCommittable = true;
        } else if (ack.status == PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_FAILED) {
            cs.decision = CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_ABORT;
            isCommittable = false;
        } else {
            revert("unexpected commit status");
        }

        cs.phase = CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_COMMIT;

        // Set ACK flags
        if (!_containsUint32(cs.acks, TX_INDEX_COORDINATOR)) {
            cs.acks.push(TX_INDEX_COORDINATOR);
        }
        if (!_containsUint32(cs.acks, TX_INDEX_PARTICIPANT)) {
            cs.acks.push(TX_INDEX_PARTICIPANT);
        }

        bool allPrepares =
            _containsUint32(cs.confirmed_txs, TX_INDEX_COORDINATOR)
            && _containsUint32(cs.confirmed_txs, TX_INDEX_PARTICIPANT);
        bool allCommits =
            _containsUint32(cs.acks, TX_INDEX_COORDINATOR) && _containsUint32(cs.acks, TX_INDEX_PARTICIPANT);
        if (!allPrepares || !allCommits) {
            revert("fatal: coordinator state inconsistent");
        }

        // --- 4. Execute Local Commit/Abort ---

        ContractTransactionState.Data storage txState = txStorage.states[txID][TX_INDEX_COORDINATOR];

        if (txState.status != ContractTransactionState.ContractTransactionStatus.CONTRACT_TRANSACTION_STATUS_PREPARE) {
            revert("coordinator tx status must be PREPARE");
        }

        // Dummy packet for getModule
        Height.Data memory emptyHeight = Height.Data(0, 0);
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

        MsgInitiateTx.Data storage msg_ = txStorage.txMsg[txID];
        ContractTransaction.Data storage coordTx = msg_.contract_transactions[TX_INDEX_COORDINATOR];

        CrossContext memory ctx =
            CrossContext({txID: abi.encodePacked(txID), txIndex: TX_INDEX_COORDINATOR, signers: coordTx.signers});

        if (isCommittable) {
            // Commit
            try module.onCommit(ctx) {
                txState.status = ContractTransactionState.ContractTransactionStatus.CONTRACT_TRANSACTION_STATUS_COMMIT;
            } catch {
                revert("contract commit failed");
            }
        } else {
            // Abort
            try module.onAbort(ctx) {
                txState.status = ContractTransactionState.ContractTransactionStatus.CONTRACT_TRANSACTION_STATUS_ABORT;
            } catch {
                revert("contract abort failed");
            }
        }
    }

    // --- Helpers ---

    function _containsUint32(uint32[] storage arr, uint32 value) internal view returns (bool) {
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] == value) return true;
        }
        return false;
    }

    function _bytesToBytes32(bytes memory b) internal pure returns (bytes32 out) {
        require(b.length == 32, "invalid txID length");
        assembly {
            out := mload(add(b, 32))
        }
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
