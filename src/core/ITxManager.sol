// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {MsgInitiateTx} from "../proto/cross/core/initiator/Initiator.sol";
import {Packet} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IIBCChannel.sol";

interface ITxManager {
    function createTx(bytes32 txID, MsgInitiateTx.Data calldata src) external;
    function runTxIfCompleted(bytes32 txID) external;
    function isTxRecorded(bytes32 txID) external view returns (bool);
    function handlePacket(Packet memory packet) external returns (bytes memory acknowledgement);
    function handleAcknowledgement(Packet memory packet, bytes memory acknowledgement) external;
    function handleTimeout(Packet calldata packet) external;
}
