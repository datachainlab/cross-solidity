// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {MsgInitiateTx} from "../proto/cross/core/initiator/Initiator.sol";

abstract contract TxRunnerBase {
    function _runTx(bytes32 txId, MsgInitiateTx.Data storage msg_) internal virtual;
}
