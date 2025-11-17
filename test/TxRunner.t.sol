// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";
import "../src/core/TxRunner.sol";
import "../src/core/ICrossError.sol";
import {MsgInitiateTx} from "../src/proto/cross/core/initiator/Initiator.sol";

contract TxRunnerHarness is TxRunner {
    MsgInitiateTx.Data public storedTxMsg;

    function exposed_runTx(bytes32 txID) public {
        _runTx(txID, storedTxMsg);
    }
}

contract TxRunnerTest is Test {
    TxRunnerHarness private harness;
    bytes32 private txID = keccak256("test_tx_id");

    function setUp() public {
        harness = new TxRunnerHarness();
    }

    function test_runTx_RevertsNotImplemented() public {
        vm.expectRevert(ICrossError.TxRunNotImplemented.selector);
        harness.exposed_runTx(txID);
    }
}
