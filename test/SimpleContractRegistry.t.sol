// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";

import "../src/core/SimpleContractRegistry.sol";
import "../src/core/IContractModule.sol";
import {Packet} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IIBCChannel.sol";

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

contract SimpleContractRegistryHarness is SimpleContractRegistry {
    function exposed_registerModule(IContractModule m) external {
        registerModule(m);
    }

    function exposed_getModule(Packet calldata p) external returns (IContractModule) {
        return getModule(p);
    }

    function workaround_moduleAddr() external view returns (address) {
        return address(contractModule);
    }
}

contract SimpleContractRegistryTest is Test {
    DummyModule private dummy;
    SimpleContractRegistryHarness private registry;

    Packet internal _emptyPacket;

    function setUp() public {
        dummy = new DummyModule();
        registry = new SimpleContractRegistryHarness();
    }

    function test_get_RevertWhen_NotInitialized() public {
        vm.expectRevert(SimpleContractRegistry.ModuleNotInitialized.selector);
        registry.exposed_getModule(_emptyPacket);
    }

    function test_register_ThenGetReturnsSameAddress() public {
        IContractModule m = IContractModule(address(dummy));

        registry.exposed_registerModule(m);

        IContractModule got = registry.exposed_getModule(_emptyPacket);
        assertEq(address(got), address(m));
        assertEq(registry.workaround_moduleAddr(), address(m));
    }

    function test_register_RevertOn_SecondInitialization() public {
        IContractModule m = IContractModule(address(dummy));

        registry.exposed_registerModule(m);

        vm.expectRevert(SimpleContractRegistry.ModuleAlreadyInitialized.selector);
        registry.exposed_registerModule(m);
    }

    function testFuzz_register_ThenGetReturnsSameAddress(address anyAddr) public {
        vm.assume(anyAddr != address(0));
        IContractModule m = IContractModule(anyAddr);

        registry.exposed_registerModule(m);

        IContractModule got = registry.exposed_getModule(_emptyPacket);
        assertEq(address(got), anyAddr);
    }
}
