// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {TxManagerBase} from "./TxManagerBase.sol";
import {CrossStore} from "./CrossStore.sol";
import {ITxManager} from "./ITxManager.sol";
import {IContractModule} from "./IContractModule.sol";
import {SimpleContractRegistry} from "./SimpleContractRegistry.sol";
import {TxAtomicSimple} from "./TxAtomicSimple.sol";

import {MsgInitiateTx, MsgInitiateTxResponse, ContractTransaction} from "../proto/cross/core/initiator/Initiator.sol";
import {Account} from "../proto/cross/core/auth/Auth.sol";

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

    function runTxIfCompleted(bytes32 txID) external override nonReentrant {
        _runTxIfCompleted(txID);
    }

    function isTxRecorded(bytes32 txID) external view override returns (bool) {
        return _isTxRecorded(txID);
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
        _deepStoreMsg(t, txID, src);
        t.txStatus[txID] = MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_PENDING;
    }

    function _runTxIfCompleted(bytes32 txID) internal virtual override {
        CrossStore.TxStorage storage t = _getTxStorage();
        if (!_isTxRecorded(txID)) return;
        if (t.txStatus[txID] == MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED) return;
        t.txStatus[txID] = MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED;
        _runTx(txID, t.txMsg[txID]);
    }

    function _isTxRecorded(bytes32 txID) internal view virtual override returns (bool) {
        CrossStore.TxStorage storage t = _getTxStorage();
        return t.txStatus[txID] != MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_UNKNOWN;
    }

    function _deepStoreMsg(CrossStore.TxStorage storage t, bytes32 txID, MsgInitiateTx.Data calldata src) private {
        MsgInitiateTx.Data storage dst = t.txMsg[txID];
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
