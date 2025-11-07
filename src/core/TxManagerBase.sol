// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {MsgInitiateTx} from "../proto/cross/core/initiator/Initiator.sol";
import {
    Tx as AtomicTx,
    ChannelInfo,
    CoordinatorState,
    QueryCoordinatorStateResponse
} from "src/proto/cross/core/atomic/simple/AtomicSimple.sol";

abstract contract TxManagerBase {
    error TxAlreadyExists(bytes32 txId);
    error TxAlreadyVerified(bytes32 txId);
    error CoordinatorStateNotFound(bytes32 txId);

    function createTx(bytes32 txId, MsgInitiateTx.Data calldata src) internal virtual;
    function runTxIfCompleted(bytes32 txId) internal virtual;
    function hasTx(bytes32 txId) internal view virtual returns (bool);
    function _runTx(bytes32 txId, MsgInitiateTx.Data storage msg_) internal virtual;
    function initCoordinatorState(bytes32 txId, AtomicTx.CommitProtocol cp, ChannelInfo.Data[] memory channels)
        internal
        virtual;
    function setCoordinatorPhase(bytes32 txId, CoordinatorState.CoordinatorPhase phase) internal virtual;
    function setCoordinatorDecision(bytes32 txId, CoordinatorState.CoordinatorDecision decision) internal virtual;
    function pushCoordinatorConfirmed(bytes32 txId, uint32 idx) internal virtual;
    function pushCoordinatorAck(bytes32 txId, uint32 idx) internal virtual;
    function _getCoordinatorState(bytes32 txId)
        internal
        view
        virtual
        returns (QueryCoordinatorStateResponse.Data memory out, bool exists);
}
