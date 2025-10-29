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

    function test_constructor_GrantsIbcRoleToHandler() public {
        assertTrue(mod.hasRole(mod.IBC_ROLE(), address(handler)));
    }

    function test_supportsInterface_ReturnsTrueForIIBCAndIAccessControlAndFalseForUnsupported() public view {
        assertTrue(mod.supportsInterface(type(IIBCModule).interfaceId));
        assertTrue(mod.supportsInterface(type(IIBCModuleInitializer).interfaceId));
        assertTrue(mod.supportsInterface(type(IAccessControl).interfaceId));
        assertFalse(mod.supportsInterface(0xDEADBEEF));
    }

    function test_onRecvPacket_CallsHandlerAndReturnsAckWhenCallerHasRole() public {
        vm.prank(address(handler));
        bytes memory ack = mod.onRecvPacket(_emptyPacket, address(0));
        assertEq(ack, bytes("ack-ok"));
        assertEq(mod.recvCount(), 1);
    }

    function test_onRecvPacket_RevertWhen_CallerLacksIbcRole() public {
        vm.expectRevert();
        mod.onRecvPacket(_emptyPacket, address(0));
    }

    function test_onAcknowledgementPacket_CallsHandlerWhenCallerHasRole() public {
        vm.prank(address(handler));
        mod.onAcknowledgementPacket(_emptyPacket, bytes("ack123"), address(0));
        assertEq(mod.ackCount(), 1);
        assertEq(mod.lastAckArg(), bytes("ack123"));
    }

    function test_onAcknowledgementPacket_RevertWhen_CallerLacksIbcRole() public {
        vm.expectRevert();
        mod.onAcknowledgementPacket(_emptyPacket, bytes("ack"), address(0));
    }

    function test_onTimeoutPacket_CallsHandlerWhenCallerHasRole() public {
        vm.prank(address(handler));
        mod.onTimeoutPacket(_emptyPacket, address(0));
        assertEq(mod.timeoutCount(), 1);
    }

    function test_onTimeoutPacket_RevertWhen_CallerLacksIbcRole() public {
        vm.expectRevert();
        mod.onTimeoutPacket(_emptyPacket, address(0));
    }

    function test_onChanOpenInit_ReturnsSelfAndVersionWhenCallerHasRole() public {
        IIBCModuleInitializer.MsgOnChanOpenInit memory m;
        m.version = "v1";
        vm.prank(address(handler));
        (address moduleAddr, string memory version) = mod.onChanOpenInit(m);
        assertEq(moduleAddr, address(mod));
        assertEq(version, "v1");
    }

    function test_onChanOpenInit_RevertWhen_CallerLacksIbcRole() public {
        IIBCModuleInitializer.MsgOnChanOpenInit memory m;
        m.version = "v1";
        vm.expectRevert();
        mod.onChanOpenInit(m);
    }

    function test_onChanOpenTry_ReturnsSelfAndCounterpartyVersionWhenCallerHasRole() public {
        IIBCModuleInitializer.MsgOnChanOpenTry memory m;
        m.counterpartyVersion = "cp-v1";
        vm.prank(address(handler));
        (address moduleAddr, string memory version) = mod.onChanOpenTry(m);
        assertEq(moduleAddr, address(mod));
        assertEq(version, "cp-v1");
    }

    function test_onChanOpenTry_RevertWhen_CallerLacksIbcRole() public {
        IIBCModuleInitializer.MsgOnChanOpenTry memory m;
        m.counterpartyVersion = "cp-v1";
        vm.expectRevert();
        mod.onChanOpenTry(m);
    }

    function test_onChanOpenAck_SucceedsWhenCallerHasRole() public {
        IIBCModule.MsgOnChanOpenAck memory m;
        vm.prank(address(handler));
        mod.onChanOpenAck(m); // no revert
    }

    function test_onChanOpenAck_RevertWhen_CallerLacksIbcRole() public {
        IIBCModule.MsgOnChanOpenAck memory m;
        vm.expectRevert();
        mod.onChanOpenAck(m);
    }

    function test_onChanOpenConfirm_SucceedsWhenCallerHasRole() public {
        IIBCModule.MsgOnChanOpenConfirm memory m;
        vm.prank(address(handler));
        mod.onChanOpenConfirm(m); // no revert
    }

    function test_onChanOpenConfirm_RevertWhen_CallerLacksIbcRole() public {
        IIBCModule.MsgOnChanOpenConfirm memory m;
        vm.expectRevert();
        mod.onChanOpenConfirm(m);
    }

    function test_onChanCloseInit_SucceedsWhenCallerHasRole() public {
        IIBCModule.MsgOnChanCloseInit memory m;
        vm.prank(address(handler));
        mod.onChanCloseInit(m); // no revert
    }

    function test_onChanCloseInit_RevertWhen_CallerLacksIbcRole() public {
        IIBCModule.MsgOnChanCloseInit memory m;
        vm.expectRevert();
        mod.onChanCloseInit(m);
    }

    function test_onChanCloseConfirm_SucceedsWhenCallerHasRole() public {
        IIBCModule.MsgOnChanCloseConfirm memory m;
        vm.prank(address(handler));
        mod.onChanCloseConfirm(m); // no revert
    }

    function test_onChanCloseConfirm_RevertWhen_CallerLacksIbcRole() public {
        IIBCModule.MsgOnChanCloseConfirm memory m;
        vm.expectRevert();
        mod.onChanCloseConfirm(m);
    }
}
