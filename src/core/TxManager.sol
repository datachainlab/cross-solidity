// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {TxManagerBase} from "./TxManagerBase.sol";

import {
    MsgInitiateTx,
    MsgInitiateTxResponse,
    ContractTransaction,
    Link
} from "../proto/cross/core/initiator/Initiator.sol";
import {Account} from "../proto/cross/core/auth/Auth.sol";

import {
    QueryCoordinatorStateResponse,
    Tx as AtomicTx,
    ChannelInfo,
    CoordinatorState
} from "src/proto/cross/core/atomic/simple/AtomicSimple.sol";

abstract contract TxManager is TxManagerBase {
    struct _CoordStorage {
        bool exists;
        AtomicTx.CommitProtocol commit_protocol;
        ChannelInfo.Data[] channels;
        CoordinatorState.CoordinatorPhase phase;
        CoordinatorState.CoordinatorDecision decision;
        uint32[] confirmed_txs;
        uint32[] acks;
    }
    mapping(bytes32 => _CoordStorage) internal _coord;
    mapping(bytes32 => bool) internal _txExists;
    mapping(bytes32 => MsgInitiateTx.Data) internal _txMsg;
    mapping(bytes32 => MsgInitiateTxResponse.InitiateTxStatus) internal _txStatus;

    function CreateTx(bytes32 txId, MsgInitiateTx.Data calldata src) internal virtual override {
        if (_txExists[txId]) revert TxAlreadyExists(txId);
        _deepStoreMsg(txId, src);
        _txStatus[txId] = MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_PENDING;
        _txExists[txId] = true;
    }

    function RunTxIfCompleted(bytes32 txId) internal virtual override {
        if (!_txExists[txId]) return;
        if (_txStatus[txId] == MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED) return;
        _runTx(txId, _txMsg[txId]);
        _txStatus[txId] = MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED;
    }

    function _hasTx(bytes32 txId) internal view virtual override returns (bool) {
        return _txExists[txId];
    }

    function _runTx(bytes32, MsgInitiateTx.Data storage) internal virtual override {
        // no-op
    }

    function _deepStoreMsg(bytes32 txId, MsgInitiateTx.Data calldata src) private {
        MsgInitiateTx.Data storage dst = _txMsg[txId];
        dst.chain_id = src.chain_id;
        dst.nonce = src.nonce;
        dst.commit_protocol = src.commit_protocol;
        dst.timeout_height = src.timeout_height;
        dst.timeout_timestamp = src.timeout_timestamp;
        _copyAccounts(src.signers, dst.signers);
        _copyContractTxs(src.contract_transactions, dst.contract_transactions);
    }

    function _copyAccounts(Account.Data[] calldata src, Account.Data[] storage dst) private {
        while (dst.length > 0) dst.pop();
        for (uint256 i = 0; i < src.length; i++) {
            dst.push(src[i]);
        }
    }

    function _copyContractTxs(ContractTransaction.Data[] calldata src, ContractTransaction.Data[] storage dst) private {
        while (dst.length > 0) dst.pop();
        for (uint256 i = 0; i < src.length; i++) {
            dst.push();
            ContractTransaction.Data storage d = dst[i];
            ContractTransaction.Data calldata s = src[i];
            d.cross_chain_channel = s.cross_chain_channel;
            _copyAccounts(s.signers, d.signers);
            d.call_info = s.call_info;
            d.return_value = s.return_value;
            while (d.links.length > 0) d.links.pop();
            for (uint256 j = 0; j < s.links.length; j++) {
                d.links.push(s.links[j]);
            }
        }
    }

    function InitCoordinatorState(bytes32 txId, AtomicTx.CommitProtocol cp, ChannelInfo.Data[] memory channels)
        internal
        virtual
        override
    {
        _CoordStorage storage s = _coord[txId];
        s.exists = true;
        s.commit_protocol = cp;

        while (s.channels.length > 0) s.channels.pop();
        for (uint256 i = 0; i < channels.length; i++) {
            s.channels.push(channels[i]);
        }

        s.phase = CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE;
        s.decision = CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_UNKNOWN;

        while (s.confirmed_txs.length > 0) s.confirmed_txs.pop();
        while (s.acks.length > 0) s.acks.pop();
    }

    function SetCoordinatorPhase(bytes32 txId, CoordinatorState.CoordinatorPhase phase) internal virtual override {
        _CoordStorage storage s = _coord[txId];
        s.exists = true;
        s.phase = phase;
    }

    function SetCoordinatorDecision(bytes32 txId, CoordinatorState.CoordinatorDecision decision)
        internal
        virtual
        override
    {
        _CoordStorage storage s = _coord[txId];
        s.exists = true;
        s.decision = decision;
    }

    function PushCoordinatorConfirmed(bytes32 txId, uint32 idx) internal virtual override {
        _CoordStorage storage s = _coord[txId];
        s.exists = true;
        s.confirmed_txs.push(idx);
    }

    function PushCoordinatorAck(bytes32 txId, uint32 idx) internal virtual override {
        _CoordStorage storage s = _coord[txId];
        s.exists = true;
        s.acks.push(idx);
    }

    function _getCoordinatorState(bytes32 txId)
        internal
        view
        virtual
        override
        returns (QueryCoordinatorStateResponse.Data memory out, bool exists)
    {
        _CoordStorage storage s = _coord[txId];
        if (!s.exists) return (out, false);
        CoordinatorState.Data memory cs;
        cs.commit_protocol = s.commit_protocol;
        cs.channels = new ChannelInfo.Data[](s.channels.length);
        for (uint256 i = 0; i < s.channels.length; i++) {
            cs.channels[i] = s.channels[i];
        }
        cs.phase = s.phase;
        cs.decision = s.decision;
        cs.confirmed_txs = new uint32[](s.confirmed_txs.length);
        for (uint256 i = 0; i < s.confirmed_txs.length; i++) {
            cs.confirmed_txs[i] = s.confirmed_txs[i];
        }
        cs.acks = new uint32[](s.acks.length);
        for (uint256 i = 0; i < s.acks.length; i++) {
            cs.acks[i] = s.acks[i];
        }
        out.coodinator_state = cs;
        exists = true;
    }
}
