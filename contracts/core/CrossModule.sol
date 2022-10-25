// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
pragma experimental ABIEncoderV2;

import "@hyperledger-labs/yui-ibc-solidity/contracts/core/IBCModule.sol";
import "@hyperledger-labs/yui-ibc-solidity/contracts/core/IBCHost.sol";
import "@hyperledger-labs/yui-ibc-solidity/contracts/core/IBCHandler.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "./PacketHandler.sol";
import "./IBCKeeper.sol";

abstract contract CrossModule is Context, AccessControl, IModuleCallbacks, IBCKeeper, PacketHandler {

    bytes32 public constant IBC_ROLE = keccak256("IBC_ROLE");

    constructor(IBCHost ibcHost_, IBCHandler ibcHandler_) IBCKeeper(ibcHost_, ibcHandler_) {
        _setupRole(IBC_ROLE, address(ibcHandler_));
    }

    // function initiateTx() external {}

    /// Module callbacks ///

    function onRecvPacket(Packet.Data memory packet, address relayer) public virtual override returns (bytes memory acknowledgement) {
        require(hasRole(IBC_ROLE, _msgSender()), "caller must have the IBC role");
        return handlePacket(packet);
    }

    function onAcknowledgementPacket(Packet.Data memory packet, bytes memory acknowledgement, address relayer) public virtual override {
        require(hasRole(IBC_ROLE, _msgSender()), "caller must have the IBC role");
        return handleAcknowledgement(packet, acknowledgement);
    }

    function onChanOpenInit(Channel.Order, string[] calldata connectionHops, string calldata portId, string calldata channelId, ChannelCounterparty.Data calldata counterparty, string calldata version) external virtual override {}

    function onChanOpenTry(Channel.Order, string[] calldata connectionHops, string calldata portId, string calldata channelId, ChannelCounterparty.Data calldata counterparty, string calldata version, string calldata counterpartyVersion) external virtual override {}

    function onChanOpenAck(string calldata portId, string calldata channelId, string calldata counterpartyVersion) external virtual override {}

    function onChanOpenConfirm(string calldata portId, string calldata channelId) external virtual override {}

    function onChanCloseInit(string calldata portId, string calldata channelId) external virtual override {}

    function onChanCloseConfirm(string calldata portId, string calldata channelId) external virtual override {}
}
