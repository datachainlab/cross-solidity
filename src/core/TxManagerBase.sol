// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {MsgInitiateTx} from "../proto/cross/core/initiator/Initiator.sol";

abstract contract TxManagerBase {
    error TxAlreadyExists(bytes32 txID);
    error TxAlreadyVerified(bytes32 txID);
    error CoordinatorStateNotFound(bytes32 txID);

    function createTx(bytes32 txID, MsgInitiateTx.Data calldata src) internal virtual;
    function runTxIfCompleted(bytes32 txID) internal virtual;
    function isTxRecorded(bytes32 txID) internal view virtual returns (bool);
}
