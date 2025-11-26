// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase, gas-small-strings
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";
import "../src/core/CrossStore.sol";
import {MsgInitiateTxResponse} from "../src/proto/cross/core/initiator/Initiator.sol";
import {CoordinatorState} from "../src/proto/cross/core/atomic/simple/AtomicSimple.sol";

contract CrossStoreHarness is CrossStore {
    //--- Auth Storage Accessors ---
    function writeAuth(bytes32 txID, bool val) public {
        AuthStorage storage s = _getAuthStorage();
        s.authInitialized[txID] = val;
    }

    function readAuth(bytes32 txID) public view returns (bool) {
        AuthStorage storage s = _getAuthStorage();
        return s.authInitialized[txID];
    }

    //--- Tx Storage Accessors ---
    function writeTx(bytes32 txID, MsgInitiateTxResponse.InitiateTxStatus status) public {
        TxStorage storage s = _getTxStorage();
        s.txStatus[txID] = status;
    }

    function readTx(bytes32 txID) public view returns (MsgInitiateTxResponse.InitiateTxStatus) {
        TxStorage storage s = _getTxStorage();
        return s.txStatus[txID];
    }

    //--- Coord Storage Accessors ---
    function writeCoord(bytes32 txID, CoordinatorState.CoordinatorPhase phase) public {
        CoordStorage storage s = _getCoordStorage();
        s.states[txID].phase = phase;
    }

    function readCoord(bytes32 txID) public view returns (CoordinatorState.CoordinatorPhase) {
        CoordStorage storage s = _getCoordStorage();
        return s.states[txID].phase;
    }
}

contract CrossStoreTest is Test {
    CrossStoreHarness private harness;

    bytes32 private keyAuth = keccak256("key.auth");
    bytes32 private keyTx = keccak256("key.tx");
    bytes32 private keyCoord = keccak256("key.coord");

    function setUp() public {
        harness = new CrossStoreHarness();

        harness.writeAuth(keyAuth, true);
        harness.writeTx(keyTx, MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED);
        harness.writeCoord(keyCoord, CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE);
    }

    function test_getAuthStorage_IsIsolated() public view {
        assertTrue(harness.readAuth(keyAuth), "Auth write failed");
        assertFalse(harness.readAuth(keyTx), "Auth storage collision with Tx");
        assertFalse(harness.readAuth(keyCoord), "Auth storage collision with Coord");
    }

    function test_getTxStorage_IsIsolated() public view {
        assertEq(
            uint256(harness.readTx(keyTx)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED),
            "Tx write failed"
        );
        assertEq(
            uint256(harness.readTx(keyAuth)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_UNKNOWN),
            "Tx storage collision with Auth"
        );
        assertEq(
            uint256(harness.readTx(keyCoord)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_UNKNOWN),
            "Tx storage collision with Coord"
        );
    }

    function test_getCoordStorage_IsIsolated() public view {
        assertEq(
            uint256(harness.readCoord(keyCoord)),
            uint256(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE),
            "Coord write failed"
        );
        assertEq(
            uint256(harness.readCoord(keyAuth)),
            uint256(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_UNKNOWN),
            "Coord storage collision with Auth"
        );
        assertEq(
            uint256(harness.readCoord(keyTx)),
            uint256(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_UNKNOWN),
            "Coord storage collision with Tx"
        );
    }
}
