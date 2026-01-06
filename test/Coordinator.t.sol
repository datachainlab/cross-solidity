// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase, gas-small-strings
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";
import "../src/core/Coordinator.sol";
import "../src/core/TxManagerBase.sol";
import "../src/core/TxAuthManagerBase.sol";
import {ICrossError} from "../src/core/ICrossError.sol";
import {ICrossEvent} from "../src/core/ICrossEvent.sol";
import {
    QueryCoordinatorStateRequest,
    QueryCoordinatorStateResponse,
    CoordinatorState
} from "../src/proto/cross/core/atomic/simple/AtomicSimple.sol";
import {MsgInitiateTx, ContractTransaction} from "../src/proto/cross/core/initiator/Initiator.sol";
import {Tx} from "../src/proto/cross/core/tx/Tx.sol";
import {Account as AuthAccount} from "../src/proto/cross/core/auth/Auth.sol";
import {IbcCoreClientV1Height} from "../src/proto/ibc/core/client/v1/client.sol";

contract MockTxManager is TxManagerBase, ICrossError {
    mapping(bytes32 => CoordinatorState.Data) internal mockStates;
    mapping(bytes32 => bool) internal recordedTxs;
    mapping(bytes32 => bool) internal stateExists;
    uint256 public runCount;

    function setCoordinatorState(bytes32 txID, CoordinatorState.Data memory data) public {
        mockStates[txID] = data;
        stateExists[txID] = true;
    }

    function setTxRecorded(bytes32 txID, bool recorded) public {
        recordedTxs[txID] = recorded;
    }

    function _getCoordinatorState(bytes32 txID) internal view virtual override returns (CoordinatorState.Data memory) {
        if (!stateExists[txID]) {
            revert CoordinatorStateNotFound(txID);
        }
        return mockStates[txID];
    }

    function _createTx(bytes32, MsgInitiateTx.Data calldata) internal virtual override {}

    function _runTxIfCompleted(MsgInitiateTx.Data calldata) internal virtual override {
        ++runCount;
    }

    function _isTxRecorded(bytes32 txID) internal view virtual override returns (bool) {
        return recordedTxs[txID];
    }
}

contract MockTxAuthManager is TxAuthManagerBase {
    mapping(bytes32 => bool) internal completedAuths;

    function setCompletedAuth(bytes32 txID, bool completed) public {
        completedAuths[txID] = completed;
    }

    function _initAuthState(bytes32, Account.Data[] memory) internal virtual override {}

    function _sign(bytes32, Account.Data[] memory) internal virtual override returns (bool) {
        return true;
    }

    function _getAuthState(bytes32) internal view virtual override returns (TxAuthState.Data memory) {
        TxAuthState.Data memory state;
        return state;
    }
    function _verifySignatures(bytes32, Account.Data[] calldata) internal virtual override {}

    function _isCompletedAuth(bytes32 txID) internal view virtual override returns (bool) {
        return completedAuths[txID];
    }
}

contract CoordinatorHarness is Coordinator, MockTxManager, MockTxAuthManager {}

contract CoordinatorTest is Test, ICrossError, ICrossEvent {
    CoordinatorHarness private harness;
    MsgInitiateTx.Data private dummyMsg;
    bytes32 private txID;

    function setUp() public {
        harness = new CoordinatorHarness();

        dummyMsg = MsgInitiateTx.Data({
            chain_id: "test-chain",
            nonce: 1,
            commit_protocol: Tx.CommitProtocol.COMMIT_PROTOCOL_SIMPLE,
            timeout_height: IbcCoreClientV1Height.Data(0, 0),
            timeout_timestamp: 0,
            signers: new AuthAccount.Data[](0),
            contract_transactions: new ContractTransaction.Data[](0)
        });

        txID = sha256(MsgInitiateTx.encode(dummyMsg));
    }

    function test_executeTx_Succeeds() public {
        harness.setTxRecorded(txID, true);
        harness.setCompletedAuth(txID, true);

        vm.expectEmit(address(harness));
        emit TxExecuted(abi.encodePacked(txID), address(this));

        harness.executeTx(dummyMsg);

        assertEq(harness.runCount(), 1, "runTxIfCompleted should be called");
    }

    function test_executeTx_RevertIf_TimeoutHeight() public {
        dummyMsg.timeout_height.revision_height = uint64(block.number);

        vm.expectRevert(
            abi.encodeWithSelector(MessageTimeoutHeight.selector, block.number, dummyMsg.timeout_height.revision_height)
        );
        harness.executeTx(dummyMsg);
    }

    function test_executeTx_RevertIf_TimeoutTimestamp() public {
        dummyMsg.timeout_timestamp = uint64(block.timestamp);

        vm.expectRevert(
            abi.encodeWithSelector(MessageTimeoutTimestamp.selector, block.timestamp, dummyMsg.timeout_timestamp)
        );
        harness.executeTx(dummyMsg);
    }

    function test_executeTx_RevertIf_TxNotRecorded() public {
        harness.setTxRecorded(txID, false);
        harness.setCompletedAuth(txID, true);

        vm.expectRevert(abi.encodeWithSelector(TxIDNotFound.selector, txID));
        harness.executeTx(dummyMsg);
    }

    function test_executeTx_RevertIf_AuthNotCompleted() public {
        harness.setTxRecorded(txID, true);
        harness.setCompletedAuth(txID, false);

        vm.expectRevert(abi.encodeWithSelector(AuthNotCompleted.selector, txID));
        harness.executeTx(dummyMsg);
    }

    function test_coordinatorState_ReturnsCorrectState() public {
        CoordinatorState.Data memory expectedState;
        expectedState.commit_protocol = Tx.CommitProtocol.COMMIT_PROTOCOL_SIMPLE;
        expectedState.phase = CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE;
        expectedState.decision = CoordinatorState.CoordinatorDecision.COORDINATOR_DECISION_COMMIT;

        harness.setCoordinatorState(txID, expectedState);

        QueryCoordinatorStateRequest.Data memory req;
        req.tx_id = abi.encodePacked(txID);

        QueryCoordinatorStateResponse.Data memory resp = harness.coordinatorState(req);

        assertEq(
            uint256(resp.coodinator_state.commit_protocol),
            uint256(expectedState.commit_protocol),
            "Commit protocol mismatch"
        );
        assertEq(uint256(resp.coodinator_state.phase), uint256(expectedState.phase), "Phase mismatch");
        assertEq(uint256(resp.coodinator_state.decision), uint256(expectedState.decision), "Decision mismatch");
    }

    function test_coordinatorState_RevertIf_TxIDLengthInvalid_TooShort() public {
        QueryCoordinatorStateRequest.Data memory req;
        req.tx_id = hex"1234";

        vm.expectRevert(InvalidTxIDLength.selector);
        harness.coordinatorState(req);
    }

    function test_coordinatorState_RevertIf_TxIDLengthInvalid_TooLong() public {
        QueryCoordinatorStateRequest.Data memory req;
        req.tx_id = new bytes(33);

        vm.expectRevert(InvalidTxIDLength.selector);
        harness.coordinatorState(req);
    }

    function test_coordinatorState_RevertIf_TxIDLengthInvalid_Empty() public {
        QueryCoordinatorStateRequest.Data memory req;
        req.tx_id = "";

        vm.expectRevert(InvalidTxIDLength.selector);
        harness.coordinatorState(req);
    }

    function test_coordinatorState_RevertIf_StateNotFound() public {
        QueryCoordinatorStateRequest.Data memory req;
        req.tx_id = abi.encodePacked(txID);

        vm.expectRevert(abi.encodeWithSelector(CoordinatorStateNotFound.selector, txID));
        harness.coordinatorState(req);
    }
}
