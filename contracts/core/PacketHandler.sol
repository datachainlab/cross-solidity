// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.6.8;
pragma experimental ABIEncoderV2;

import "@hyperledger-labs/yui-ibc-solidity/contracts/core/types/Channel.sol";

abstract contract PacketHandler {
    function handlePacket(Packet.Data memory packet) virtual internal returns (bytes memory acknowledgement);
    function handleAcknowledgement(Packet.Data memory packet, bytes memory acknowledgement) virtual internal;
}

enum CommitMode {
    UNSPECIFIED_MODE
}
