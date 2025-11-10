// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";
import "../src/core/CoreStore.sol";
import {MsgInitiateTx, MsgInitiateTxResponse} from "../src/proto/cross/core/initiator/Initiator.sol";
import {Account, AuthType} from "../src/proto/cross/core/auth/Auth.sol";
import {GoogleProtobufAny} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";
import {CoordinatorState} from "../src/proto/cross/core/atomic/simple/AtomicSimple.sol";
import {Tx} from "../src/proto/cross/core/tx/Tx.sol";
import {ChannelInfo} from "../src/proto/cross/core/xcc/XCC.sol";

contract CoreStoreHarness is CoreStore {
    function writeAuthRemaining(bytes32 txId, bytes32 key, bool val) public {
        AuthStorage storage s = _getAuthStorage();
        s.remaining[txId][key] = val;
    }

    function readAuthRemaining(bytes32 txId, bytes32 key) public view returns (bool) {
        AuthStorage storage s = _getAuthStorage();
        return s.remaining[txId][key];
    }

    function writeAuthRemainingCount(bytes32 txId, uint256 count) public {
        AuthStorage storage s = _getAuthStorage();
        s.remainingCount[txId] = count;
    }

    function readAuthRemainingCount(bytes32 txId) public view returns (uint256) {
        AuthStorage storage s = _getAuthStorage();
        return s.remainingCount[txId];
    }

    function writeAuthInitialized(bytes32 txId, bool val) public {
        AuthStorage storage s = _getAuthStorage();
        s.authInitialized[txId] = val;
    }

    function readAuthInitialized(bytes32 txId) public view returns (bool) {
        AuthStorage storage s = _getAuthStorage();
        return s.authInitialized[txId];
    }

    function pushAuthRequiredAccount(bytes32 txId, bytes memory accountId) public {
        AuthStorage storage s = _getAuthStorage();
        GoogleProtobufAny.Data memory emptyAny = GoogleProtobufAny.Data({type_url: "", value: ""});
        AuthType.Data memory localAuthType = AuthType.Data({mode: AuthType.AuthMode.AUTH_MODE_LOCAL, option: emptyAny});
        s.requiredAccounts[txId].push(Account.Data({id: accountId, auth_type: localAuthType}));
    }

    function readAuthRequiredAccount(bytes32 txId, uint256 idx) public view returns (Account.Data memory) {
        AuthStorage storage s = _getAuthStorage();
        return s.requiredAccounts[txId][idx];
    }

    function writeTxExists(bytes32 txId, bool val) public {
        TxStorage storage s = _getTxStorage();
        s.txExists[txId] = val;
    }

    function readTxExists(bytes32 txId) public view returns (bool) {
        TxStorage storage s = _getTxStorage();
        return s.txExists[txId];
    }

    function writeTxMsgNonce(bytes32 txId, uint64 nonce) public {
        TxStorage storage s = _getTxStorage();
        s.txMsg[txId].nonce = nonce;
    }

    function readTxMsgNonce(bytes32 txId) public view returns (uint64) {
        TxStorage storage s = _getTxStorage();
        return s.txMsg[txId].nonce;
    }

    function writeTxStatus(bytes32 txId, MsgInitiateTxResponse.InitiateTxStatus status) public {
        TxStorage storage s = _getTxStorage();
        s.txStatus[txId] = status;
    }

    function readTxStatus(bytes32 txId) public view returns (MsgInitiateTxResponse.InitiateTxStatus) {
        TxStorage storage s = _getTxStorage();
        return s.txStatus[txId];
    }

    function writeCoordExists(bytes32 txId, bool val) public {
        CoordStorage storage s = _getCoordStorage();
        s.states[txId].exists = val;
    }

    function readCoordExists(bytes32 txId) public view returns (bool) {
        CoordStorage storage s = _getCoordStorage();
        return s.states[txId].exists;
    }

    function writeCoordData(
        bytes32 txId,
        Tx.CommitProtocol protocol,
        CoordinatorState.CoordinatorPhase phase,
        CoordinatorState.CoordinatorDecision decision
    ) public {
        CoordStorage storage s = _getCoordStorage();
        s.states[txId].data.commit_protocol = protocol;
        s.states[txId].data.phase = phase;
        s.states[txId].data.decision = decision;
    }

    function pushCoordChannel(bytes32 txId, string memory port, string memory channel) public {
        CoordStorage storage s = _getCoordStorage();
        s.states[txId].data.channels.push(ChannelInfo.Data({port: port, channel: channel}));
    }

    function readCoordChannel(bytes32 txId, uint256 idx) public view returns (ChannelInfo.Data memory) {
        CoordStorage storage s = _getCoordStorage();
        return s.states[txId].data.channels[idx];
    }

    function pushCoordConfirmedTx(bytes32 txId, uint32 val) public {
        CoordStorage storage s = _getCoordStorage();
        s.states[txId].data.confirmed_txs.push(val);
    }

    function pushCoordAck(bytes32 txId, uint32 val) public {
        CoordStorage storage s = _getCoordStorage();
        s.states[txId].data.acks.push(val);
    }

    function readCoordData(bytes32 txId) public view returns (CoordinatorState.Data memory) {
        CoordStorage storage s = _getCoordStorage();
        return s.states[txId].data;
    }
}

contract CoreStoreTest is Test {
    CoreStoreHarness private harness;
    bytes32 private keyA = keccak256("keyA");
    bytes32 private keyB = keccak256("keyB");

    function setUp() public {
        harness = new CoreStoreHarness();
    }

    function test_CoreStore() public {
        bytes32 remKeyA = keccak256("remA");
        bytes32 remKeyB = keccak256("remB");

        // write auth storage
        harness.writeAuthRemaining(keyA, remKeyA, true);
        harness.writeAuthRemaining(keyB, remKeyB, false);
        harness.writeAuthRemainingCount(keyA, 111);
        harness.writeAuthRemainingCount(keyB, 222);
        harness.writeAuthInitialized(keyA, true);
        harness.writeAuthInitialized(keyB, false);
        harness.pushAuthRequiredAccount(keyA, bytes("accA"));
        harness.pushAuthRequiredAccount(keyB, bytes("accB"));

        // write tx storage
        harness.writeTxExists(keyA, true);
        harness.writeTxExists(keyB, false);
        harness.writeTxMsgNonce(keyA, 333);
        harness.writeTxMsgNonce(keyB, 444);
        harness.writeTxStatus(keyA, MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED);
        harness.writeTxStatus(keyB, MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_PENDING);

        // write coord storage
        harness.writeCoordExists(keyA, true);
        harness.writeCoordExists(keyB, false);
        harness.writeCoordData(
            keyA,
            Tx.CommitProtocol.COMMIT_PROTOCOL_SIMPLE,
            CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE,
            CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_COMMIT
        );
        harness.writeCoordData(
            keyB,
            Tx.CommitProtocol.COMMIT_PROTOCOL_TPC,
            CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_COMMIT,
            CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_ABORT
        );
        harness.pushCoordChannel(keyA, "portA", "channelA");
        harness.pushCoordChannel(keyB, "portB", "channelB");
        harness.pushCoordConfirmedTx(keyA, 1);
        harness.pushCoordConfirmedTx(keyB, 2);
        harness.pushCoordAck(keyA, 101);
        harness.pushCoordAck(keyB, 202);

        // assert auth storage
        assertTrue(harness.readAuthRemaining(keyA, remKeyA), "Auth.remaining[A] failed");
        assertFalse(harness.readAuthRemaining(keyB, remKeyB), "Auth.remaining[B] failed");
        assertEq(harness.readAuthRemainingCount(keyA), 111, "Auth.remainingCount[A] failed");
        assertEq(harness.readAuthRemainingCount(keyB), 222, "Auth.remainingCount[B] failed");
        assertTrue(harness.readAuthInitialized(keyA), "Auth.authInitialized[A] failed");
        assertFalse(harness.readAuthInitialized(keyB), "Auth.authInitialized[B] failed");
        assertEq(harness.readAuthRequiredAccount(keyA, 0).id, bytes("accA"), "Auth.requiredAccounts[A] data failed");
        assertEq(harness.readAuthRequiredAccount(keyB, 0).id, bytes("accB"), "Auth.requiredAccounts[B] data failed");

        // assert tx storage
        assertTrue(harness.readTxExists(keyA), "Tx.txExists[A] failed");
        assertFalse(harness.readTxExists(keyB), "Tx.txExists[B] failed");
        assertEq(harness.readTxMsgNonce(keyA), 333, "Tx.txMsg.nonce[A] failed");
        assertEq(harness.readTxMsgNonce(keyB), 444, "Tx.txMsg.nonce[B] failed");
        assertEq(
            uint256(harness.readTxStatus(keyA)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED),
            "Tx.txStatus[A] failed"
        );
        assertEq(
            uint256(harness.readTxStatus(keyB)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_PENDING),
            "Tx.txStatus[B] failed"
        );

        // assert coord storage
        assertTrue(harness.readCoordExists(keyA), "Coord.exists[A] failed");
        assertFalse(harness.readCoordExists(keyB), "Coord.exists[B] failed");

        CoordinatorState.Data memory coordA = harness.readCoordData(keyA);
        CoordinatorState.Data memory coordB = harness.readCoordData(keyB);

        assertEq(
            uint256(coordA.commit_protocol),
            uint256(Tx.CommitProtocol.COMMIT_PROTOCOL_SIMPLE),
            "Coord.protocol[A] failed"
        );
        assertEq(
            uint256(coordB.commit_protocol), uint256(Tx.CommitProtocol.COMMIT_PROTOCOL_TPC), "Coord.protocol[B] failed"
        );
        assertEq(
            uint256(coordA.phase),
            uint256(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE),
            "Coord.phase[A] failed"
        );
        assertEq(
            uint256(coordB.phase),
            uint256(CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_COMMIT),
            "Coord.phase[B] failed"
        );
        assertEq(
            uint256(coordA.decision),
            uint256(CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_COMMIT),
            "Coord.decision[A] failed"
        );
        assertEq(
            uint256(coordB.decision),
            uint256(CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_ABORT),
            "Coord.decision[B] failed"
        );

        ChannelInfo.Data memory chanA = harness.readCoordChannel(keyA, 0);
        ChannelInfo.Data memory chanB = harness.readCoordChannel(keyB, 0);
        assertEq(keccak256(bytes(chanA.port)), keccak256(bytes("portA")), "Coord.channel.port[A] failed");
        assertEq(keccak256(bytes(chanA.channel)), keccak256(bytes("channelA")), "Coord.channel.channel[A] failed");
        assertEq(keccak256(bytes(chanB.port)), keccak256(bytes("portB")), "Coord.channel.port[B] failed");
        assertEq(keccak256(bytes(chanB.channel)), keccak256(bytes("channelB")), "Coord.channel.channel[B] failed");

        assertEq(coordA.confirmed_txs[0], 1, "Coord.confirmed_txs[A] failed");
        assertEq(coordB.confirmed_txs[0], 2, "Coord.confirmed_txs[B] failed");
        assertEq(coordA.acks[0], 101, "Coord.acks[A] failed");
        assertEq(coordB.acks[0], 202, "Coord.acks[B] failed");

        assertEq(harness.readAuthRemainingCount(keyA), 111, "Auth[A] was overwritten");
        assertTrue(harness.readTxExists(keyA), "Tx[A] was overwritten");
        assertTrue(harness.readCoordExists(keyA), "Coord[A] was overwritten");
    }
}
