// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {TxManagerBase} from "./TxManagerBase.sol";
import {CoreStore} from "./CoreStore.sol";

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

abstract contract TxManager is TxManagerBase, CoreStore {
    function CreateTx(bytes32 txId, MsgInitiateTx.Data calldata src) internal virtual override {
        CoreStore.TxStorage storage T = _getTxStorage();
        if (T.txExists[txId]) revert TxAlreadyExists(txId);
        _deepStoreMsg(T, txId, src);
        T.txStatus[txId] = MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_PENDING;
        T.txExists[txId] = true;
    }

    function RunTxIfCompleted(bytes32 txId) internal virtual override {
        CoreStore.TxStorage storage T = _getTxStorage();
        if (!T.txExists[txId]) return;
        if (T.txStatus[txId] == MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED) return;
        _runTx(txId, T.txMsg[txId]);
        T.txStatus[txId] = MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED;
    }

    function _hasTx(bytes32 txId) internal view virtual override returns (bool) {
        CoreStore.TxStorage storage T = _getTxStorage();
        return T.txExists[txId];
    }

    function _runTx(bytes32, MsgInitiateTx.Data storage) internal virtual override {
        // no-op
    }

    function _deepStoreMsg(CoreStore.TxStorage storage T, bytes32 txId, MsgInitiateTx.Data calldata src) private {
        MsgInitiateTx.Data storage dst = T.txMsg[txId];
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
        CoreStore.CoordStorage storage C = _getCoordStorage();
        CoreStore.CoordEntry storage s = C.states[txId];

        s.exists = true;
        s.data.commit_protocol = cp;

        while (s.data.channels.length > 0) s.data.channels.pop();
        for (uint256 i = 0; i < channels.length; i++) {
            s.data.channels.push(channels[i]);
        }

        s.data.phase = CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE;
        s.data.decision = CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_UNKNOWN;

        while (s.data.confirmed_txs.length > 0) s.data.confirmed_txs.pop();
        while (s.data.acks.length > 0) s.data.acks.pop();
    }

    function SetCoordinatorPhase(bytes32 txId, CoordinatorState.CoordinatorPhase phase) internal virtual override {
        CoreStore.CoordEntry storage s = _getCoordStorage().states[txId];
        s.exists = true;
        s.data.phase = phase;
    }

    function SetCoordinatorDecision(bytes32 txId, CoordinatorState.CoordinatorDecision decision)
        internal
        virtual
        override
    {
        CoreStore.CoordEntry storage s = _getCoordStorage().states[txId];
        s.exists = true;
        s.data.decision = decision;
    }

    function PushCoordinatorConfirmed(bytes32 txId, uint32 idx) internal virtual override {
        CoreStore.CoordEntry storage s = _getCoordStorage().states[txId];
        s.exists = true;
        s.data.confirmed_txs.push(idx);
    }

    function PushCoordinatorAck(bytes32 txId, uint32 idx) internal virtual override {
        CoreStore.CoordEntry storage s = _getCoordStorage().states[txId];
        s.exists = true;
        s.data.acks.push(idx);
    }

    function _getCoordinatorState(bytes32 txId)
        internal
        view
        virtual
        override
        returns (QueryCoordinatorStateResponse.Data memory out, bool exists)
    {
        CoreStore.CoordEntry storage s = _getCoordStorage().states[txId];
        if (!s.exists) return (out, false);

        CoordinatorState.Data memory cs;
        cs.commit_protocol = s.data.commit_protocol;

        cs.channels = new ChannelInfo.Data[](s.data.channels.length);
        for (uint256 i = 0; i < s.data.channels.length; i++) {
            cs.channels[i] = s.data.channels[i];
        }

        cs.phase = s.data.phase;
        cs.decision = s.data.decision;

        cs.confirmed_txs = new uint32[](s.data.confirmed_txs.length);
        for (uint256 i = 0; i < s.data.confirmed_txs.length; i++) {
            cs.confirmed_txs[i] = s.data.confirmed_txs[i];
        }

        cs.acks = new uint32[](s.data.acks.length);
        for (uint256 i = 0; i < s.data.acks.length; i++) {
            cs.acks[i] = s.data.acks[i];
        }

        out.coodinator_state = cs;
        exists = true;
    }
}
