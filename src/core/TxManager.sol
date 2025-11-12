// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {TxManagerBase} from "./TxManagerBase.sol";
import {TxRunnerBase} from "./TxRunnerBase.sol";
import {CrossStore} from "./CrossStore.sol";

import {MsgInitiateTx, MsgInitiateTxResponse, ContractTransaction} from "../proto/cross/core/initiator/Initiator.sol";
import {Account} from "../proto/cross/core/auth/Auth.sol";

abstract contract TxManager is TxManagerBase, TxRunnerBase, CrossStore {
    function createTx(bytes32 txId, MsgInitiateTx.Data calldata src) internal virtual override {
        CrossStore.TxStorage storage t = _getTxStorage();
        if (t.txExists[txId]) revert TxAlreadyExists(txId);
        _deepStoreMsg(t, txId, src);
        t.txStatus[txId] = MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_PENDING;
        t.txExists[txId] = true;
    }

    function runTxIfCompleted(bytes32 txId) internal virtual override {
        CrossStore.TxStorage storage t = _getTxStorage();
        if (!t.txExists[txId]) return;
        if (t.txStatus[txId] == MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED) return;
        _runTx(txId, t.txMsg[txId]);
        t.txStatus[txId] = MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED;
    }

    function isTxRecorded(bytes32 txId) internal view virtual override returns (bool) {
        CrossStore.TxStorage storage t = _getTxStorage();
        return t.txExists[txId];
    }

    function _deepStoreMsg(CrossStore.TxStorage storage t, bytes32 txId, MsgInitiateTx.Data calldata src) private {
        MsgInitiateTx.Data storage dst = t.txMsg[txId];
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
        for (uint256 i = 0; i < src.length; ++i) {
            dst.push(src[i]);
        }
    }

    function _copyContractTxs(ContractTransaction.Data[] calldata src, ContractTransaction.Data[] storage dst) private {
        while (dst.length > 0) dst.pop();
        for (uint256 i = 0; i < src.length; ++i) {
            dst.push();
            ContractTransaction.Data storage d = dst[i];
            ContractTransaction.Data calldata s = src[i];
            d.cross_chain_channel = s.cross_chain_channel;
            _copyAccounts(s.signers, d.signers);
            d.call_info = s.call_info;
            d.return_value = s.return_value;
            while (d.links.length > 0) d.links.pop();
            for (uint256 j = 0; j < s.links.length; ++j) {
                d.links.push(s.links[j]);
            }
        }
    }
}
