// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {
    QueryCoordinatorStateRequest,
    QueryCoordinatorStateResponse
} from "../proto/cross/core/atomic/simple/AtomicSimple.sol";

interface ICoordinator {
    function coordinatorState(QueryCoordinatorStateRequest.Data calldata req)
        external
        view
        returns (QueryCoordinatorStateResponse.Data memory);
}
