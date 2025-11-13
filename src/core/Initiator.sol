// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {IInitiator} from "./IInitiator.sol";
import {TxAuthManagerBase} from "./TxAuthManagerBase.sol";
import {TxManagerBase} from "./TxManagerBase.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

import {MsgInitiateTx, MsgInitiateTxResponse, QuerySelfXCCResponse} from "../proto/cross/core/initiator/Initiator.sol";
import {Account} from "../proto/cross/core/auth/Auth.sol";

abstract contract Initiator is IInitiator, TxAuthManagerBase, TxManagerBase {
    bytes32 public immutable CHAIN_ID_HASH;

    constructor() {
        CHAIN_ID_HASH = keccak256(bytes(Strings.toString(block.chainid)));
    }

    function initiateTx(MsgInitiateTx.Data calldata msg_)
        external
        override
        returns (MsgInitiateTxResponse.Data memory resp)
    {
        // chain_id check
        bytes32 got = keccak256(bytes(msg_.chain_id));
        if (got != CHAIN_ID_HASH) revert IInitiator.UnexpectedChainID(CHAIN_ID_HASH, got);

        // timeouts
        uint64 rh = msg_.timeout_height.revision_height;
        if (rh != 0 && (block.number + 1 > uint256(rh))) {
            revert IInitiator.MessageTimeoutHeight(block.number, rh);
        }
        // slither-disable-next-line timestamp
        if (msg_.timeout_timestamp > 0 && (block.timestamp + 1 > msg_.timeout_timestamp)) {
            revert IInitiator.MessageTimeoutTimestamp(block.timestamp, msg_.timeout_timestamp);
        }

        // generate txID
        bytes32 txIDHash = sha256(MsgInitiateTx.encode(msg_));
        bytes memory txID = abi.encodePacked(txIDHash);
        if (_isTxRecorded(txIDHash)) revert IInitiator.TxIDAlreadyExists(txIDHash);

        // persist as PENDING
        _createTx(txIDHash, msg_);

        // auth init & sign
        Account.Data[] memory required = _getRequiredAccounts(msg_);
        _initAuthState(txIDHash, required);
        bool completed = _sign(txIDHash, msg_.signers);

        emit TxInitiated(txID, msg.sender);

        if (completed) {
            _runTxIfCompleted(txIDHash);
            return MsgInitiateTxResponse.Data({
                txID: txID, status: MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED
            });
        }
        return MsgInitiateTxResponse.Data({
            txID: txID, status: MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_PENDING
        });
    }

    function selfXCC() external view virtual override returns (QuerySelfXCCResponse.Data memory) {
        revert IInitiator.SelfXCCNotImplemented();
    }

    function _getRequiredAccounts(MsgInitiateTx.Data calldata msg_) internal pure returns (Account.Data[] memory out) {
        uint256 upper = 0;
        for (uint256 i = 0; i < msg_.contract_transactions.length; ++i) {
            upper += msg_.contract_transactions[i].signers.length;
        }
        out = new Account.Data[](upper);
        uint256 n = 0;

        for (uint256 i = 0; i < msg_.contract_transactions.length; ++i) {
            Account.Data[] memory rs = msg_.contract_transactions[i].signers;
            for (uint256 j = 0; j < rs.length; ++j) {
                out[n] = rs[j];
                ++n;
            }
        }
        return out;
    }
}
