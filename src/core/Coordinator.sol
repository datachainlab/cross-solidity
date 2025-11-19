// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {ICoordinator} from "./ICoordinator.sol";
import {TxManagerBase} from "./TxManagerBase.sol";
import {CrossStore} from "./CrossStore.sol";
import {ICrossError} from "./ICrossError.sol";

import {
    QueryCoordinatorStateRequest,
    QueryCoordinatorStateResponse,
    CoordinatorState
} from "src/proto/cross/core/atomic/simple/AtomicSimple.sol";

abstract contract Coordinator is ICoordinator, TxManagerBase, CrossStore, ICrossError {
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

        CrossStore.CoordEntry storage s = _getCoordStorage().states[txID];
        if (!s.exists) revert IDNotFound(txID);

        return QueryCoordinatorStateResponse.Data({coodinator_state: s.data});
    }
}
