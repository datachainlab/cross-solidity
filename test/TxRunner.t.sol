// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";
import "../src/core/TxRunner.sol";
import {MsgInitiateTx} from "../src/proto/cross/core/initiator/Initiator.sol";

contract TxRunnerHarness is TxRunner {
    MsgInitiateTx.Data public storedTxMsg;

    function exposed_runTx(bytes32 txId) public {
        _runTx(txId, storedTxMsg);
    }
}

contract TxRunnerTest is Test {
    TxRunnerHarness private harness;
    bytes32 private txId = keccak256("test_tx_id");

    function setUp() public {
        harness = new TxRunnerHarness();
    }

    function test_runTx_DoesNotRevert() public {
        harness.exposed_runTx(txId);

        assertTrue(true, "_runTx should not revert");
    }
}
