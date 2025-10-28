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

contract TestableSimpleContractRegistry is SimpleContractRegistry {
    function register(IContractModule m) external {
        registerModule(m);
    }

    function get(Packet calldata p) external returns (IContractModule) {
        return getModule(p);
    }

    function moduleAddr() external view returns (address) {
        return address(contractModule);
    }
}

contract SimpleContractRegistryTest is Test {
    DummyModule private dummy;
    TestableSimpleContractRegistry private registry;

    Packet internal _emptyPacket;

    function setUp() public {
        dummy = new DummyModule();
        registry = new TestableSimpleContractRegistry();
    }

    function test_Get_Reverts_WhenNotInitialized() public {
        vm.expectRevert(SimpleContractRegistry.ModuleNotInitialized.selector);
        registry.get(_emptyPacket);
    }

    function test_Register_Then_Get_ReturnsSameAddress() public {
        IContractModule m = IContractModule(address(dummy));

        registry.register(m);

        IContractModule got = registry.get(_emptyPacket);
        assertEq(address(got), address(m));
        assertEq(registry.moduleAddr(), address(m));
    }

    function test_Register_Reverts_OnSecondInitialization() public {
        IContractModule m = IContractModule(address(dummy));

        registry.register(m);

        vm.expectRevert(SimpleContractRegistry.ModuleAlreadyInitialized.selector);
        registry.register(m);
    }

    function testFuzz_Register_Then_Get_ReturnsSameAddress(address anyAddr) public {
        vm.assume(anyAddr != address(0));
        IContractModule m = IContractModule(anyAddr);

        registry.register(m);

        IContractModule got = registry.get(_emptyPacket);
        assertEq(address(got), anyAddr);
    }
}
