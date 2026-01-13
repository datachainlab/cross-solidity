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
        s.compactStates[txID].phase = phase;
    }

    function readCoord(bytes32 txID) public view returns (CoordinatorState.CoordinatorPhase) {
        CoordStorage storage s = _getCoordStorage();
        return s.compactStates[txID].phase;
    }

    //--- Coord Storage Logic Exposers ---
    function exposed_loadCoordinatorState(bytes32 txID) public view returns (CoordinatorState.Data memory) {
        return _loadCoordinatorState(txID);
    }

    function exposed_saveCoordinatorState(bytes32 txID, CoordinatorState.Data memory data) public {
        _saveCoordinatorState(txID, data);
    }

    function exposed_confirmParticipant(bytes32 txID) public {
        _confirmParticipant(txID);
    }

    function exposed_completeSimpleProtocol(
        bytes32 txID,
        CoordinatorState.CoordinatorPhase phase,
        CoordinatorState.CoordinatorDecision decision
    ) public {
        _completeSimpleProtocol(txID, phase, decision);
    }

    function exposed_maskToUint32Array(uint8 mask) public pure returns (uint32[] memory) {
        return _maskToUint32Array(mask);
    }

    function exposed_uint32ArrayToMask(uint32[] memory arr) public pure returns (uint8 mask) {
        return _uint32ArrayToMask(arr);
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

    function test_maskToUint32Array_Empty() public view {
        uint32[] memory res = harness.exposed_maskToUint32Array(0x00);
        assertEq(res.length, 0, "Should return empty array for mask 0x00");
    }

    function test_maskToUint32Array_CoordinatorOnly() public view {
        uint32[] memory res = harness.exposed_maskToUint32Array(0x01);
        assertEq(res.length, 1, "Array length mismatch");
        assertEq(res[0], 0, "Index 0 should be TX_INDEX_COORDINATOR (0)");
    }

    function test_maskToUint32Array_ParticipantOnly() public view {
        uint32[] memory res = harness.exposed_maskToUint32Array(0x02);
        assertEq(res.length, 1, "Array length mismatch");
        assertEq(res[0], 1, "Index 0 should be TX_INDEX_PARTICIPANT (1)");
    }

    function test_maskToUint32Array_Both() public view {
        uint32[] memory res = harness.exposed_maskToUint32Array(0x03);
        assertEq(res.length, 2, "Array length mismatch");
        assertEq(res[0], 0, "First element mismatch");
        assertEq(res[1], 1, "Second element mismatch");
    }

    function test_uint32ArrayToMask_Empty() public view {
        uint32[] memory arr = new uint32[](0);
        assertEq(harness.exposed_uint32ArrayToMask(arr), 0x00, "Empty array should yield mask 0x00");
    }

    function test_uint32ArrayToMask_CoordinatorOnly() public view {
        uint32[] memory arr = new uint32[](1);
        arr[0] = 0;
        assertEq(harness.exposed_uint32ArrayToMask(arr), 0x01, "Mask mismatch for Coordinator");
    }

    function test_uint32ArrayToMask_ParticipantOnly() public view {
        uint32[] memory arr = new uint32[](1);
        arr[0] = 1;
        assertEq(harness.exposed_uint32ArrayToMask(arr), 0x02, "Mask mismatch for Participant");
    }

    function test_uint32ArrayToMask_Both() public view {
        uint32[] memory arr = new uint32[](2);
        arr[0] = 0;
        arr[1] = 1;
        assertEq(harness.exposed_uint32ArrayToMask(arr), 0x03, "Mask mismatch for Both");
    }

    function test_uint32ArrayToMask_BothReversedOrder() public view {
        uint32[] memory arr = new uint32[](2);
        arr[0] = 1;
        arr[1] = 0;
        assertEq(harness.exposed_uint32ArrayToMask(arr), 0x03, "Mask should be 0x03 regardless of order");
    }

    function test_SaveAndLoad_CoordinatorState() public {
        bytes32 txId = keccak256("tx.save.load");

        CoordinatorState.Data memory original;
        original.commit_protocol = Tx.CommitProtocol.COMMIT_PROTOCOL_SIMPLE;
        original.phase = CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE;
        original.decision = CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_UNKNOWN;

        original.channels = new ChannelInfo.Data[](2);
        original.channels[0] = ChannelInfo.Data("", "");
        original.channels[1] = ChannelInfo.Data("port-1", "channel-1");

        original.confirmed_txs = new uint32[](1);
        original.confirmed_txs[0] = 0;

        harness.exposed_saveCoordinatorState(txId, original);

        CoordinatorState.Data memory loaded = harness.exposed_loadCoordinatorState(txId);
        assertEq(uint256(loaded.commit_protocol), uint256(original.commit_protocol));
        assertEq(loaded.channels[1].port, "port-1");
        assertEq(loaded.confirmed_txs.length, 1);
        assertEq(loaded.confirmed_txs[0], 0);
    }

    function test_SaveLoad_DataLossChannel0() public {
        bytes32 txId = keccak256("tx.dataloss.ch0");
        CoordinatorState.Data memory data = _createEmptyData();

        data.channels = new ChannelInfo.Data[](2);
        data.channels[0] = ChannelInfo.Data("should-be-lost", "lost-channel");
        data.channels[1] = ChannelInfo.Data("port-1", "channel-1");

        harness.exposed_saveCoordinatorState(txId, data);

        CoordinatorState.Data memory loaded = harness.exposed_loadCoordinatorState(txId);

        assertEq(loaded.channels[0].port, "", "Channel0 port should be lost");
        assertEq(loaded.channels[0].channel, "", "Channel0 channel should be lost");
        assertEq(loaded.channels[1].port, "port-1");
    }

    function test_SaveLoad_DataLossExtraChannels() public {
        bytes32 txId = keccak256("tx.dataloss.extra_ch");
        CoordinatorState.Data memory data = _createEmptyData();

        data.channels = new ChannelInfo.Data[](3);
        data.channels[0] = ChannelInfo.Data("", "");
        data.channels[1] = ChannelInfo.Data("port-1", "channel-1");
        data.channels[2] = ChannelInfo.Data("port-2", "channel-2");

        harness.exposed_saveCoordinatorState(txId, data);

        CoordinatorState.Data memory loaded = harness.exposed_loadCoordinatorState(txId);

        assertEq(loaded.channels.length, 2, "Extra channels should be truncated to 2");
    }

    function test_SaveLoad_DataLossUnsupportedIndices() public {
        bytes32 txId = keccak256("tx.dataloss.indices");
        CoordinatorState.Data memory data = _createEmptyData();

        data.confirmed_txs = new uint32[](3);
        data.confirmed_txs[0] = 0;
        data.confirmed_txs[1] = 1;
        data.confirmed_txs[2] = 2;

        harness.exposed_saveCoordinatorState(txId, data);

        CoordinatorState.Data memory loaded = harness.exposed_loadCoordinatorState(txId);

        assertEq(loaded.confirmed_txs.length, 2, "Index 2 should be lost");
        assertEq(loaded.confirmed_txs[0], 0);
        assertEq(loaded.confirmed_txs[1], 1);
    }

    function _createEmptyData() internal pure returns (CoordinatorState.Data memory) {
        return CoordinatorState.Data({
            commit_protocol: Tx.CommitProtocol.COMMIT_PROTOCOL_SIMPLE,
            phase: CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE,
            decision: CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_UNKNOWN,
            channels: new ChannelInfo.Data[](0),
            confirmed_txs: new uint32[](0),
            acks: new uint32[](0)
        });
    }

    function test_confirmParticipant_UpdatesMask() public {
        bytes32 txId = keccak256("tx.confirm");

        test_SaveAndLoad_CoordinatorState();
        txId = keccak256("tx.save.load");

        harness.exposed_confirmParticipant(txId);

        CoordinatorState.Data memory loaded = harness.exposed_loadCoordinatorState(txId);
        assertEq(loaded.confirmed_txs.length, 2, "Should have 2 confirmed txs");
        assertEq(loaded.confirmed_txs[1], 1, "Participant should be confirmed");
    }

    function test_completeSimpleProtocol_SetsCorrectValues() public {
        bytes32 txId = keccak256("tx.complete");

        harness.exposed_completeSimpleProtocol(
            txId,
            CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_COMMIT,
            CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_COMMIT
        );

        CoordinatorState.Data memory loaded = harness.exposed_loadCoordinatorState(txId);
        assertEq(uint256(loaded.phase), uint256(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_COMMIT));
        assertEq(uint256(loaded.decision), uint256(CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_COMMIT));
        assertEq(loaded.acks.length, 2, "Both Coord and Participant should be in ACKs");
    }
}
