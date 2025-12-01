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

import {Initiator} from "./Initiator.sol";
import {Authenticator} from "./Authenticator.sol";
import {Coordinator} from "./Coordinator.sol";
import {DelegatedLogicHandler} from "./DelegatedLogicHandler.sol";
import {IContractModule} from "./IContractModule.sol";
import {IAuthExtensionVerifier} from "./IAuthExtensionVerifier.sol";

abstract contract CrossModule is
    AccessControl,
    IIBCModule,
    Initiator,
    Authenticator,
    Coordinator,
    DelegatedLogicHandler
{
    bytes32 public constant IBC_ROLE = keccak256("IBC_ROLE");

    constructor(
        IIBCHandler ibcHandler_,
        address txAuthManager_,
        address txManager_,
        IContractModule contractModule_,
        string[] memory authTypeUrls_,
        IAuthExtensionVerifier[] memory authVerifiers_
    ) Initiator() DelegatedLogicHandler(txAuthManager_, txManager_) {
        _initializeTxAuthManager(authTypeUrls_, authVerifiers_);
        _initializeTxManager(ibcHandler_, contractModule_);
        _grantRole(IBC_ROLE, address(ibcHandler_));
    }

    function supportsInterface(bytes4 interfaceID) public view virtual override(AccessControl, IERC165) returns (bool) {
        return interfaceID == type(IIBCModule).interfaceId || interfaceID == type(IIBCModuleInitializer).interfaceId
            || super.supportsInterface(interfaceID);
    }

    /// Module callbacks ///

    function onRecvPacket(
        Packet calldata packet,
        address /*relayer*/
    )
        public
        virtual
        override
        returns (bytes memory acknowledgement)
    {
        require(hasRole(IBC_ROLE, _msgSender()), "caller must have the IBC role");
        return _handlePacket(packet);
    }

    function onAcknowledgementPacket(
        Packet calldata packet,
        bytes calldata acknowledgement,
        address /*relayer*/
    )
        public
        virtual
        override
    {
        require(hasRole(IBC_ROLE, _msgSender()), "caller must have the IBC role");
        _handleAcknowledgement(packet, acknowledgement);
    }

    function onTimeoutPacket(
        Packet calldata packet,
        address /*relayer*/
    )
        public
        virtual
        override
    {
        require(hasRole(IBC_ROLE, _msgSender()), "caller must have the IBC role");
        _handleTimeout(packet);
    }

    function onChanOpenInit(IIBCModuleInitializer.MsgOnChanOpenInit calldata msg_)
        external
        virtual
        override
        returns (address moduleAddr, string memory version)
    {
        require(hasRole(IBC_ROLE, _msgSender()), "caller must have the IBC role");
        return (address(this), msg_.version);
    }

    function onChanOpenTry(IIBCModuleInitializer.MsgOnChanOpenTry calldata msg_)
        external
        virtual
        override
        returns (address moduleAddr, string memory version)
    {
        require(hasRole(IBC_ROLE, _msgSender()), "caller must have the IBC role");
        return (address(this), msg_.counterpartyVersion);
    }

    function onChanOpenAck(
        IIBCModule.MsgOnChanOpenAck calldata /*msg_*/
    )
        external
        virtual
        override
    {
        require(hasRole(IBC_ROLE, _msgSender()), "caller must have the IBC role");
    }

    function onChanOpenConfirm(
        IIBCModule.MsgOnChanOpenConfirm calldata /*msg_*/
    )
        external
        virtual
        override
    {
        require(hasRole(IBC_ROLE, _msgSender()), "caller must have the IBC role");
    }

    function onChanCloseInit(
        IIBCModule.MsgOnChanCloseInit calldata /*msg_*/
    )
        external
        virtual
        override
    {
        require(hasRole(IBC_ROLE, _msgSender()), "caller must have the IBC role");
    }

    function onChanCloseConfirm(
        IIBCModule.MsgOnChanCloseConfirm calldata /*msg_*/
    )
        external
        virtual
        override
    {
        require(hasRole(IBC_ROLE, _msgSender()), "caller must have the IBC role");
    }
}
