// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {MsgInitiateTx} from "../proto/cross/core/initiator/Initiator.sol";
import {CoordinatorState} from "../proto/cross/core/atomic/simple/AtomicSimple.sol";

abstract contract TxManagerBase {
    function _createTx(bytes32 txID, MsgInitiateTx.Data calldata src) internal virtual;
    function _runTxIfCompleted(bytes32 txID) internal virtual;
    function _isTxRecorded(bytes32 txID) internal view virtual returns (bool);
    function _getCoordinatorState(bytes32 txID) internal view virtual returns (CoordinatorState.Data memory);
}
