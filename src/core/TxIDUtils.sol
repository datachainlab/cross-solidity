// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {MsgInitiateTx} from "../proto/cross/core/initiator/Initiator.sol";

library TxIDUtils {
    function computeTxId(MsgInitiateTx.Data calldata msg_) internal pure returns (bytes32) {
        return sha256(MsgInitiateTx.encode(msg_));
    }
}
