// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.6.8;
pragma experimental ABIEncoderV2;

import "@hyperledger-labs/yui-ibc-solidity/contracts/core/IBCModule.sol";
import "@hyperledger-labs/yui-ibc-solidity/contracts/core/IBCHost.sol";
import "@hyperledger-labs/yui-ibc-solidity/contracts/core/IBCHandler.sol";
import "@openzeppelin/contracts/utils/Context.sol";

contract CrossModule is Context, IModuleCallbacks {

    IBCHandler ibcHandler;
    IBCHost ibcHost;
    mapping(string => address) channelEscrowAddresses;

    constructor(IBCHost host_, IBCHandler ibcHandler_) public {
        ibcHost = host_;
        ibcHandler = ibcHandler_;
    }

    /// Module callbacks ///

    function onRecvPacket(Packet.Data calldata packet) external virtual override returns (bytes memory acknowledgement) {
        // TODO implements
        bytes memory acknowledgement = new bytes(1);
        return acknowledgement;
    }

    function onAcknowledgementPacket(Packet.Data calldata packet, bytes calldata acknowledgement) external virtual override {
        // TODO implements
    }

    function onChanOpenInit(Channel.Order, string[] calldata connectionHops, string calldata portId, string calldata channelId, ChannelCounterparty.Data calldata counterparty, string calldata version) external virtual override {
        // TODO authenticate a capability
        channelEscrowAddresses[channelId] = address(this);
    }

    function onChanOpenTry(Channel.Order, string[] calldata connectionHops, string calldata portId, string calldata channelId, ChannelCounterparty.Data calldata counterparty, string calldata version, string calldata counterpartyVersion) external virtual override {
        // TODO authenticate a capability
        channelEscrowAddresses[channelId] = address(this);
    }

    function onChanOpenAck(string calldata portId, string calldata channelId, string calldata counterpartyVersion) external virtual override {}

    function onChanOpenConfirm(string calldata portId, string calldata channelId) external virtual override {}
}
