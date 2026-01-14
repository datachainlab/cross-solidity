// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {ICoordinator} from "./ICoordinator.sol";
import {TxManagerBase} from "./TxManagerBase.sol";
import {TxAuthManagerBase} from "./TxAuthManagerBase.sol";
import {ICrossError} from "./ICrossError.sol";
import {ICrossEvent} from "./ICrossEvent.sol";
import {TxIDUtils} from "./TxIDUtils.sol";

import {
    QueryCoordinatorStateRequest,
    QueryCoordinatorStateResponse,
    CoordinatorState
} from "../proto/cross/core/atomic/simple/AtomicSimple.sol";
import {MsgInitiateTx} from "../proto/cross/core/initiator/Initiator.sol";

abstract contract Coordinator is ICoordinator, TxAuthManagerBase, TxManagerBase, ICrossError, ICrossEvent {
    using TxIDUtils for MsgInitiateTx.Data;

    function executeTx(MsgInitiateTx.Data calldata msg_) external override {
        uint64 rh = msg_.timeout_height.revision_height;
        if (rh != 0 && (block.number + 1 > uint256(rh))) {
            revert MessageTimeoutHeight(block.number, rh);
        }
        // slither-disable-next-line timestamp
        if (msg_.timeout_timestamp > 0 && (block.timestamp + 1 > msg_.timeout_timestamp)) {
            revert MessageTimeoutTimestamp(block.timestamp, msg_.timeout_timestamp);
        }

        bytes32 txID = msg_.computeTxId();

        if (!_isTxRecorded(txID)) revert TxIDNotFound(txID);

        if (!_isCompletedAuth(txID)) revert AuthNotCompleted(txID);
        _runTxIfCompleted(txID, msg_);

        emit TxExecuted(abi.encodePacked(txID), msg.sender);
    }

    function coordinatorState(QueryCoordinatorStateRequest.Data calldata req)
        external
        view
        override
        returns (QueryCoordinatorStateResponse.Data memory)
    {
        if (req.tx_id.length != 32) {
            revert InvalidTxIDLength();
        }
        bytes32 txID = abi.decode(req.tx_id, (bytes32));

        CoordinatorState.Data memory state = _getCoordinatorState(txID);

        return QueryCoordinatorStateResponse.Data({coodinator_state: state});
    }
}
