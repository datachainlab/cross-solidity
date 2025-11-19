// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {Packet} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IIBCChannel.sol";

// PacketHandler is a handler that handles a packet and acknowledgement
abstract contract PacketHandler {
    function _handlePacket(Packet memory packet) internal virtual returns (bytes memory acknowledgement);
    function _handleAcknowledgement(Packet memory packet, bytes memory acknowledgement) internal virtual;
    function _handleTimeout(Packet calldata packet) internal virtual;
}
