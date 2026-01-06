// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase, gas-small-strings
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";
import "../src/core/Coordinator.sol";
import "../src/core/TxManagerBase.sol";
import "../src/core/TxAuthManagerBase.sol";
import {ICrossError} from "../src/core/ICrossError.sol";
import {
    QueryCoordinatorStateRequest,
    QueryCoordinatorStateResponse,
    CoordinatorState
} from "../src/proto/cross/core/atomic/simple/AtomicSimple.sol";
import {MsgInitiateTx} from "../src/proto/cross/core/initiator/Initiator.sol";
import {Tx} from "../src/proto/cross/core/tx/Tx.sol";

contract MockTxManager is TxManagerBase, ICrossError {
    mapping(bytes32 => CoordinatorState.Data) internal mockStates;
    mapping(bytes32 => bool) internal exists;

    function setCoordinatorState(bytes32 txID, CoordinatorState.Data memory data) public {
        mockStates[txID] = data;
        exists[txID] = true;
    }

    function _getCoordinatorState(bytes32 txID) internal view virtual override returns (CoordinatorState.Data memory) {
        if (!exists[txID]) {
            revert CoordinatorStateNotFound(txID);
        }
        return mockStates[txID];
    }

    function _createTx(bytes32, MsgInitiateTx.Data calldata) internal virtual override {}
    function _runTxIfCompleted(MsgInitiateTx.Data calldata) internal virtual override {}

    function _isTxRecorded(bytes32) internal view virtual override returns (bool) {
        return false;
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

contract CoordinatorTest is Test, ICrossError {
    CoordinatorHarness private harness;
    bytes32 private txID = keccak256("test_tx_id");

    function setUp() public {
        harness = new CoordinatorHarness();
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
