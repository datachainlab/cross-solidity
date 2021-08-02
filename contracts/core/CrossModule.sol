// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.6.8;
pragma experimental ABIEncoderV2;

import "@hyperledger-labs/yui-ibc-solidity/contracts/core/IBCModule.sol";
import "@hyperledger-labs/yui-ibc-solidity/contracts/core/IBCHost.sol";
import "@hyperledger-labs/yui-ibc-solidity/contracts/core/IBCHandler.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "./PacketHandler.sol";
import "./IBCKeeper.sol";

abstract contract CrossModule is Context, IModuleCallbacks, IBCKeeper, PacketHandler {

    // function initiateTx() external {}

    /// Module callbacks ///

    function onRecvPacket(Packet.Data memory packet) public virtual override returns (bytes memory acknowledgement) {
        return handlePacket(packet);
    }

    function onAcknowledgementPacket(Packet.Data memory packet, bytes memory acknowledgement) public virtual override {
        return handleAcknowledgement(packet, acknowledgement);
    }

    function onChanOpenInit(Channel.Order, string[] calldata connectionHops, string calldata portId, string calldata channelId, ChannelCounterparty.Data calldata counterparty, string calldata version) external virtual override {}

    function onChanOpenTry(Channel.Order, string[] calldata connectionHops, string calldata portId, string calldata channelId, ChannelCounterparty.Data calldata counterparty, string calldata version, string calldata counterpartyVersion) external virtual override {}

    function onChanOpenAck(string calldata portId, string calldata channelId, string calldata counterpartyVersion) external virtual override {}

    function onChanOpenConfirm(string calldata portId, string calldata channelId) external virtual override {}
}
