// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {MsgInitiateTx} from "../proto/cross/core/initiator/Initiator.sol";

abstract contract TxManagerBase {
    error TxAlreadyExists(bytes32 txId);
    error TxAlreadyVerified(bytes32 txId);
    error CoordinatorStateNotFound(bytes32 txId);

    function createTx(bytes32 txId, MsgInitiateTx.Data calldata src) internal virtual;
    function runTxIfCompleted(bytes32 txId) internal virtual;
    function isTxRecorded(bytes32 txId) internal view virtual returns (bool);
    function _runTx(bytes32 txId, MsgInitiateTx.Data storage msg_) internal virtual;
}
