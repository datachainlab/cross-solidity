// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";
import {IERC165} from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import {
    IIBCModule,
    IIBCModuleInitializer
} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/26-router/IIBCModule.sol";
import {IIBCHandler} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/25-handler/IIBCHandler.sol";
import {Packet} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IIBCChannel.sol";

import "./PacketHandler.sol";
import "./IBCKeeper.sol";

abstract contract CrossModule is AccessControl, IIBCModule, IBCKeeper, PacketHandler {
    bytes32 public constant IBC_ROLE = keccak256("IBC_ROLE");

    constructor(IIBCHandler ibcHandler_) IBCKeeper(ibcHandler_) {
        _grantRole(IBC_ROLE, address(ibcHandler_));
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControl, IERC165) returns (bool) {
        return interfaceId == type(IIBCModule).interfaceId || interfaceId == type(IIBCModuleInitializer).interfaceId
            || super.supportsInterface(interfaceId);
    }

    // function initiateTx() external {}

    /// Module callbacks ///

    function onRecvPacket(Packet calldata packet, address relayer)
        public
        virtual
        override
        returns (bytes memory acknowledgement)
    {
        require(hasRole(IBC_ROLE, _msgSender()), "caller must have the IBC role");
        return handlePacket(packet);
    }

    function onAcknowledgementPacket(Packet calldata packet, bytes calldata acknowledgement, address relayer)
        public
        virtual
        override
    {
        require(hasRole(IBC_ROLE, _msgSender()), "caller must have the IBC role");
        handleAcknowledgement(packet, acknowledgement);
    }

    function onTimeoutPacket(Packet calldata packet, address relayer) public virtual override {
        require(hasRole(IBC_ROLE, _msgSender()), "caller must have the IBC role");
        handleTimeout(packet);
    }

    function onChanOpenInit(IIBCModuleInitializer.MsgOnChanOpenInit calldata msg_)
        external
        virtual
        override
        returns (address moduleAddr, string memory version);

    function onChanOpenTry(IIBCModuleInitializer.MsgOnChanOpenTry calldata msg_)
        external
        virtual
        override
        returns (address moduleAddr, string memory version);

    function onChanOpenAck(IIBCModule.MsgOnChanOpenAck calldata msg_) external virtual override;

    function onChanOpenConfirm(IIBCModule.MsgOnChanOpenConfirm calldata msg_) external virtual override;

    function onChanCloseInit(IIBCModule.MsgOnChanCloseInit calldata msg_) external virtual override;

    function onChanCloseConfirm(IIBCModule.MsgOnChanCloseConfirm calldata msg_) external virtual override;
}
