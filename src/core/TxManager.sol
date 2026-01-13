// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {TxManagerBase} from "./TxManagerBase.sol";
import {CrossStore} from "./CrossStore.sol";
import {ITxManager} from "./ITxManager.sol";
import {IContractModule} from "./IContractModule.sol";
import {SimpleContractRegistry} from "./SimpleContractRegistry.sol";
import {TxAtomicSimple} from "./TxAtomicSimple.sol";

import {MsgInitiateTx, MsgInitiateTxResponse} from "../proto/cross/core/initiator/Initiator.sol";
import {Account} from "../proto/cross/core/auth/Auth.sol";
import {PacketAcknowledgementCall, CoordinatorState} from "../proto/cross/core/atomic/simple/AtomicSimple.sol";
import {Tx} from "../proto/cross/core/tx/Tx.sol";
import {ChannelInfo} from "../proto/cross/core/xcc/XCC.sol";

import {IIBCHandler} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/25-handler/IIBCHandler.sol";
import {Packet} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IIBCChannel.sol";

import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract TxManager is
    Initializable,
    ReentrancyGuard,
    TxManagerBase,
    ITxManager,
    TxAtomicSimple,
    SimpleContractRegistry
{
    function initialize(IIBCHandler handler_, IContractModule module_) public initializer {
        __initTxAtomicSimple(handler_, module_);
    }

    function createTx(bytes32 txID, MsgInitiateTx.Data calldata src) external override {
        _createTx(txID, src);
    }

    function runTxIfCompleted(bytes32 txID, MsgInitiateTx.Data calldata msg_) external override nonReentrant {
        _runTxIfCompleted(txID, msg_);
    }

    function isTxRecorded(bytes32 txID) external view override returns (bool) {
        return _isTxRecorded(txID);
    }

    function getCoordinatorState(bytes32 txID) external view returns (CoordinatorState.Data memory) {
        return _getCoordinatorState(txID);
    }

    function handlePacket(Packet calldata packet) external returns (bytes memory acknowledgement) {
        return _handlePacket(packet);
    }

    function handleAcknowledgement(Packet calldata packet, bytes calldata acknowledgement) external {
        _handleAcknowledgement(packet, acknowledgement);
    }

    function handleTimeout(Packet calldata packet) external {
        _handleTimeout(packet);
    }

    function _createTx(bytes32 txID, MsgInitiateTx.Data calldata src) internal virtual override {
        CrossStore.TxStorage storage t = _getTxStorage();
        if (t.txStatus[txID] != MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_UNKNOWN) {
            revert TxAlreadyExists(txID);
        }

        if (src.contract_transactions.length > 0) {
            _storeCoordSigners(t, txID, src.contract_transactions[0].signers);
        }

        t.txStatus[txID] = MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_PENDING;
    }

    function _runTxIfCompleted(bytes32 txID, MsgInitiateTx.Data calldata msg_) internal virtual override {
        CrossStore.TxStorage storage t = _getTxStorage();
        if (!_isTxRecorded(txID)) return;
        if (t.txStatus[txID] == MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED) return;
        t.txStatus[txID] = MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED;
        _runTx(txID, msg_);
    }

    function _isTxRecorded(bytes32 txID) internal view virtual override returns (bool) {
        CrossStore.TxStorage storage t = _getTxStorage();
        return t.txStatus[txID] != MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_UNKNOWN;
    }

    function _getCoordinatorState(bytes32 txID) internal view override returns (CoordinatorState.Data memory) {
        CrossStore.CoordStorage storage s = _getCoordStorage();
        CoordStateCompact storage compact = s.compactStates[txID];

        if (compact.commitProtocol == Tx.CommitProtocol.COMMIT_PROTOCOL_UNKNOWN) {
            revert CoordinatorStateNotFound(txID);
        }

        CoordinatorState.Data memory data;
        data.commit_protocol = compact.commitProtocol;
        data.phase = compact.phase;
        data.decision = compact.decision;

        data.channels = new ChannelInfo.Data[](2);
        data.channels[0] = ChannelInfo.Data({port: "", channel: ""});
        data.channels[1] = ChannelInfo.Data({port: compact.participantPort, channel: compact.participantChannel});

        data.confirmed_txs = _maskToUint32Array(compact.confirmedMask);
        data.acks = _maskToUint32Array(compact.ackMask);

        return data;
    }

    function _storeCoordSigners(CrossStore.TxStorage storage t, bytes32 txID, Account.Data[] calldata signers) private {
        Account.Data[] storage dst = t.txCoordSigners[txID];
        while (dst.length > 0) dst.pop();
        for (uint256 i = 0; i < signers.length; ++i) {
            dst.push(signers[i]);
        }
    }

    function _maskToUint32Array(uint8 mask) internal pure returns (uint32[] memory) {
        uint256 count = 0;
        if ((mask & 0x01) != 0) ++count;
        if ((mask & 0x02) != 0) ++count;

        uint32[] memory arr = new uint32[](count);
        uint256 idx = 0;
        if ((mask & 0x01) != 0) arr[idx] = 0;
        ++idx;
        if ((mask & 0x02) != 0) arr[idx] = 1;
        ++idx;

        return arr;
    }

    // ---- debug for serialization ----
    function getPacketAcknowledgementCall(PacketAcknowledgementCall.CommitStatus status)
        public
        pure
        returns (bytes memory acknowledgement)
    {
        PacketAcknowledgementCall.Data memory ack = PacketAcknowledgementCall.Data({status: status});
        return packPacketAcknowledgementCall(ack);
    }
}
