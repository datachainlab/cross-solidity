// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";

import "../src/core/CrossSimpleModule.sol";
import "../src/core/IContractModule.sol";
import "../src/core/TxAtomicSimple.sol";
import {IIBCHandler} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/25-handler/IIBCHandler.sol";
import {Packet} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IIBCChannel.sol";

contract DummyHandler {}

contract DummyModule is IContractModule {
    // do nothing implementation
    function onContractCall(
        CrossContext calldata,
        /*context*/
        bytes calldata /*callInfo*/
    )
        external
        pure
        returns (bytes memory)
    {
        return "";
    }
}

contract CrossSimpleModuleHarness is CrossSimpleModule {
    constructor(IIBCHandler h, IContractModule m, bool debugMode) CrossSimpleModule(h, m, debugMode) {}

    function exposed_getModule(Packet calldata p) external returns (IContractModule) {
        return getModule(p);
    }

    function exposed_registerModule(IContractModule m) external {
        registerModule(m);
    }

    function workaround_hasIbcRole(address a) external view returns (bool) {
        return hasRole(IBC_ROLE, a);
    }
}

contract CrossSimpleModuleTest is Test {
    DummyHandler private handler;
    DummyModule private moduleImpl;
    Packet internal _emptyPacket;

    function setUp() public {
        handler = new DummyHandler();
        moduleImpl = new DummyModule();
    }

    function test_Constructor_RegistersModule_And_GetReturnsSameAddress() public {
        CrossSimpleModuleHarness harness =
            new CrossSimpleModuleHarness(IIBCHandler(address(handler)), IContractModule(address(moduleImpl)), false);

        IContractModule got = harness.exposed_getModule(_emptyPacket);
        assertEq(address(got), address(moduleImpl), "must register");
    }

    function test_Constructor_GrantsIbcRole_WhenDebugModeTrue() public {
        CrossSimpleModuleHarness harness =
            new CrossSimpleModuleHarness(IIBCHandler(address(handler)), IContractModule(address(moduleImpl)), true);

        assertTrue(harness.workaround_hasIbcRole(address(this)), "role on debug");
    }

    function test_Constructor_DoesNotGrantIbcRole_WhenDebugModeFalse() public {
        CrossSimpleModuleHarness harness =
            new CrossSimpleModuleHarness(IIBCHandler(address(handler)), IContractModule(address(moduleImpl)), false);

        assertFalse(harness.workaround_hasIbcRole(address(this)), "no role on debug");
    }

    function test_Register_Reverts_OnSecondInitialization() public {
        CrossSimpleModuleHarness harness =
            new CrossSimpleModuleHarness(IIBCHandler(address(handler)), IContractModule(address(moduleImpl)), false);

        vm.expectRevert(SimpleContractRegistry.ModuleAlreadyInitialized.selector);
        harness.exposed_registerModule(IContractModule(address(moduleImpl)));
    }

    function test_GetPacketAcknowledgementCall_Smoke_DifferentStatusesProduceDifferentBytes() public {
        CrossSimpleModuleHarness harness =
            new CrossSimpleModuleHarness(IIBCHandler(address(handler)), IContractModule(address(moduleImpl)), false);

        bytes memory a = harness.getPacketAcknowledgementCall(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK);
        bytes memory b =
            harness.getPacketAcknowledgementCall(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_FAILED);

        assertGt(a.length, 0, "ack nonempty");
        assertGt(b.length, 0, "ack nonempty");
        assertFalse(keccak256(a) == keccak256(b), "diff enc");
    }
}
