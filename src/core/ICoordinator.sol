// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {
    QueryCoordinatorStateRequest,
    QueryCoordinatorStateResponse
} from "../proto/cross/core/atomic/simple/AtomicSimple.sol";
import {MsgInitiateTx} from "../proto/cross/core/initiator/Initiator.sol";

interface ICoordinator {
    function executeTx(MsgInitiateTx.Data calldata msg_) external;

    function coordinatorState(QueryCoordinatorStateRequest.Data calldata req)
        external
        view
        returns (QueryCoordinatorStateResponse.Data memory);
}
