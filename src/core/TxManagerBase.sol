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

    function CreateTx(bytes32 txId, MsgInitiateTx.Data calldata src) internal virtual;
    function RunTxIfCompleted(bytes32 txId) internal virtual;
    function _hasTx(bytes32 txId) internal view virtual returns (bool);
    function _runTx(bytes32 txId, MsgInitiateTx.Data storage msg_) internal virtual;
    function InitCoordinatorState(bytes32 txId, AtomicTx.CommitProtocol cp, ChannelInfo.Data[] memory channels)
        internal
        virtual;
    function SetCoordinatorPhase(bytes32 txId, CoordinatorState.CoordinatorPhase phase) internal virtual;
    function SetCoordinatorDecision(bytes32 txId, CoordinatorState.CoordinatorDecision decision) internal virtual;
    function PushCoordinatorConfirmed(bytes32 txId, uint32 idx) internal virtual;
    function PushCoordinatorAck(bytes32 txId, uint32 idx) internal virtual;
    function _getCoordinatorState(bytes32 txId)
        internal
        view
        virtual
        returns (QueryCoordinatorStateResponse.Data memory out, bool exists);
}
