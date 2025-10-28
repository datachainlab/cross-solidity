// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";

import "../src/core/CrossModule.sol";
import {
    IIBCModule,
    IIBCModuleInitializer
} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/26-router/IIBCModule.sol";
import {IIBCHandler} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/25-handler/IIBCHandler.sol";
import {Packet} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IIBCChannel.sol";

import {IAccessControl} from "@openzeppelin/contracts/access/IAccessControl.sol";

contract DummyHandler {}

contract TestableCrossModule is CrossModule {
    uint256 public recvCount;
    uint256 public ackCount;
    uint256 public timeoutCount;
    bytes public lastAckArg;

    constructor(IIBCHandler h) CrossModule(h) {}

    function handlePacket(
        Packet memory /*packet*/
    )
        internal
        virtual
        override
        returns (bytes memory)
    {
        ++recvCount;
        return bytes("ack-ok");
    }

    function handleAcknowledgement(
        Packet memory,
        /*packet*/
        bytes memory acknowledgement
    )
        internal
        virtual
        override
    {
        ++ackCount;
        lastAckArg = acknowledgement;
    }

    function handleTimeout(
        Packet calldata /*packet*/
    )
        internal
        virtual
        override
    {
        ++timeoutCount;
    }
}

contract CrossModuleTest is Test {
    DummyHandler private handler;
    TestableCrossModule private mod;
    Packet internal _emptyPacket;

    function setUp() public {
        handler = new DummyHandler();
        mod = new TestableCrossModule(IIBCHandler(address(handler)));
    }

    function test_Constructor_GrantsIbcRoleToHandler() public {
        assertTrue(mod.hasRole(mod.IBC_ROLE(), address(handler)));
    }

    function test_SupportsInterface_IIBC_IAccessControl_And_Unsupported() public view {
        assertTrue(mod.supportsInterface(type(IIBCModule).interfaceId));
        assertTrue(mod.supportsInterface(type(IIBCModuleInitializer).interfaceId));
        assertTrue(mod.supportsInterface(type(IAccessControl).interfaceId));
        assertFalse(mod.supportsInterface(0xDEADBEEF));
    }

    function test_onRecvPacket_Reverts_WithoutIbcRole() public {
        vm.expectRevert();
        mod.onRecvPacket(_emptyPacket, address(0));
    }

    function test_onRecvPacket_CallsHandlerAndReturnsAck_WhenCallerHasRole() public {
        vm.prank(address(handler));
        bytes memory ack = mod.onRecvPacket(_emptyPacket, address(0));
        assertEq(ack, bytes("ack-ok"));
        assertEq(mod.recvCount(), 1);
    }

    function test_onAcknowledgementPacket_Reverts_WithoutIbcRole() public {
        vm.expectRevert();
        mod.onAcknowledgementPacket(_emptyPacket, bytes("ack"), address(0));
    }

    function test_onAcknowledgementPacket_CallsHandler_WhenCallerHasRole() public {
        vm.prank(address(handler));
        mod.onAcknowledgementPacket(_emptyPacket, bytes("ack123"), address(0));
        assertEq(mod.ackCount(), 1);
        assertEq(mod.lastAckArg(), bytes("ack123"));
    }

    function test_onTimeoutPacket_Reverts_WithoutIbcRole() public {
        vm.expectRevert();
        mod.onTimeoutPacket(_emptyPacket, address(0));
    }

    function test_onTimeoutPacket_CallsHandler_WhenCallerHasRole() public {
        vm.prank(address(handler));
        mod.onTimeoutPacket(_emptyPacket, address(0));
        assertEq(mod.timeoutCount(), 1);
    }

    function test_onChanOpenInit_Reverts_WithoutIbcRole() public {
        IIBCModuleInitializer.MsgOnChanOpenInit memory m;
        m.version = "v1";
        vm.expectRevert();
        mod.onChanOpenInit(m);
    }

    function test_onChanOpenInit_ReturnsSelfAndVersion_WhenCallerHasRole() public {
        IIBCModuleInitializer.MsgOnChanOpenInit memory m;
        m.version = "v1";
        vm.prank(address(handler));
        (address moduleAddr, string memory version) = mod.onChanOpenInit(m);
        assertEq(moduleAddr, address(mod));
        assertEq(version, "v1");
    }

    function test_onChanOpenTry_Reverts_WithoutIbcRole() public {
        IIBCModuleInitializer.MsgOnChanOpenTry memory m;
        m.counterpartyVersion = "cp-v1";
        vm.expectRevert();
        mod.onChanOpenTry(m);
    }

    function test_onChanOpenTry_ReturnsSelfAndCounterpartyVersion_WhenCallerHasRole() public {
        IIBCModuleInitializer.MsgOnChanOpenTry memory m;
        m.counterpartyVersion = "cp-v1";
        vm.prank(address(handler));
        (address moduleAddr, string memory version) = mod.onChanOpenTry(m);
        assertEq(moduleAddr, address(mod));
        assertEq(version, "cp-v1");
    }

    function test_onChanOpenAck_Reverts_WithoutIbcRole() public {
        IIBCModule.MsgOnChanOpenAck memory m;
        vm.expectRevert();
        mod.onChanOpenAck(m);
    }

    function test_onChanOpenAck_Succeeds_WhenCallerHasRole() public {
        IIBCModule.MsgOnChanOpenAck memory m;
        vm.prank(address(handler));
        mod.onChanOpenAck(m); // no revert
    }

    function test_onChanOpenConfirm_Reverts_WithoutIbcRole() public {
        IIBCModule.MsgOnChanOpenConfirm memory m;
        vm.expectRevert();
        mod.onChanOpenConfirm(m);
    }

    function test_onChanOpenConfirm_Succeeds_WhenCallerHasRole() public {
        IIBCModule.MsgOnChanOpenConfirm memory m;
        vm.prank(address(handler));
        mod.onChanOpenConfirm(m); // no revert
    }

    function test_onChanCloseInit_Reverts_WithoutIbcRole() public {
        IIBCModule.MsgOnChanCloseInit memory m;
        vm.expectRevert();
        mod.onChanCloseInit(m);
    }

    function test_onChanCloseInit_Succeeds_WhenCallerHasRole() public {
        IIBCModule.MsgOnChanCloseInit memory m;
        vm.prank(address(handler));
        mod.onChanCloseInit(m); // no revert
    }

    function test_onChanCloseConfirm_Reverts_WithoutIbcRole() public {
        IIBCModule.MsgOnChanCloseConfirm memory m;
        vm.expectRevert();
        mod.onChanCloseConfirm(m);
    }

    function test_onChanCloseConfirm_Succeeds_WhenCallerHasRole() public {
        IIBCModule.MsgOnChanCloseConfirm memory m;
        vm.prank(address(handler));
        mod.onChanCloseConfirm(m); // no revert
    }
}
