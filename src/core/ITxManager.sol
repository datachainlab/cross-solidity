// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {MsgInitiateTx} from "../proto/cross/core/initiator/Initiator.sol";

interface ITxManager {
    function createTx(bytes32 txID, MsgInitiateTx.Data calldata src) external;
    function runTxIfCompleted(bytes32 txID) external;
    function isTxRecorded(bytes32 txID) external returns (bool);
}
