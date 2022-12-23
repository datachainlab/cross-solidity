// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
pragma experimental ABIEncoderV2;

import "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IBCChannel.sol";

// PacketHandler is a handler that handles a packet and acknowledgement
abstract contract PacketHandler {
    function handlePacket(Packet.Data memory packet) virtual internal returns (bytes memory acknowledgement);
    function handleAcknowledgement(Packet.Data memory packet, bytes memory acknowledgement) virtual internal;
}
