// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";
import "../src/core/IBCKeeper.sol";

contract DummyHandler {}

contract IBCKeeperHarness is IBCKeeper {
    function exposed_initIBCKeeper(IIBCHandler handler) public initializer {
        __initIBCKeeper(handler);
    }

    function exposed_getIBCHandler() external view returns (address) {
        return address(getIBCHandler());
    }
}

contract IBCKeeperTest is Test {
    DummyHandler private dummy;
    IBCKeeperHarness private keeper;

    function setUp() public {
        dummy = new DummyHandler();
        keeper = new IBCKeeperHarness();
        keeper.exposed_initIBCKeeper(IIBCHandler(address(dummy)));
    }

    function test_getIBCHandler_ReturnsSameAddress() public view {
        address h = keeper.exposed_getIBCHandler();
        assertEq(h, address(dummy));
    }

    function test_exposed_initIBCKeeper_AllowsZeroAddress() public {
        IBCKeeperHarness k = new IBCKeeperHarness();
        k.exposed_initIBCKeeper(IIBCHandler(address(0)));
        assertEq(k.exposed_getIBCHandler(), address(0));
    }
}
