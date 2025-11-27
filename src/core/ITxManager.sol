// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {IContractModule} from "./IContractModule.sol";
import {MsgInitiateTx} from "../proto/cross/core/initiator/Initiator.sol";
import {Packet} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IIBCChannel.sol";
import {IIBCHandler} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/25-handler/IIBCHandler.sol";

interface ITxManager {
    function initialize(IIBCHandler handler, IContractModule module) external;
    function createTx(bytes32 txID, MsgInitiateTx.Data calldata src) external;
    function runTxIfCompleted(bytes32 txID) external;
    function isTxRecorded(bytes32 txID) external view returns (bool);
    function handlePacket(Packet calldata packet) external returns (bytes memory acknowledgement);
    function handleAcknowledgement(Packet calldata packet, bytes calldata acknowledgement) external;
    function handleTimeout(Packet calldata packet) external;
}
