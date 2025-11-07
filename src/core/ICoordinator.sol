// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {
    QueryCoordinatorStateRequest,
    QueryCoordinatorStateResponse
} from "src/proto/cross/core/atomic/simple/AtomicSimple.sol";

interface ICoordinator {
    error CoordinatorStateNotFound(bytes32 txId);

    function coordinatorState(QueryCoordinatorStateRequest.Data calldata req)
        external
        view
        returns (QueryCoordinatorStateResponse.Data memory);
}
