// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {MsgInitiateTx} from "../proto/cross/core/initiator/Initiator.sol";
import {Account} from "../proto/cross/core/auth/Auth.sol";

library TxIDUtils {
    function computeTxId(MsgInitiateTx.Data calldata msg_) internal pure returns (bytes32) {
        return sha256(MsgInitiateTx.encode(_canonicalizeCalldata(msg_)));
    }

    function _canonicalizeCalldata(MsgInitiateTx.Data calldata msg_) private pure returns (MsgInitiateTx.Data memory) {
        return MsgInitiateTx.Data({
            chain_id: msg_.chain_id,
            nonce: msg_.nonce,
            commit_protocol: msg_.commit_protocol,
            contract_transactions: msg_.contract_transactions,
            // Top-level signers may embed extension signatures, so they are excluded from the txID preimage.
            signers: new Account.Data[](0),
            timeout_height: msg_.timeout_height,
            timeout_timestamp: msg_.timeout_timestamp
        });
    }
}
