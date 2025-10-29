// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";
import "../src/core/IBCKeeper.sol";

contract DummyHandler {}

contract IBCKeeperHarness is IBCKeeper {
    constructor(IIBCHandler h) IBCKeeper(h) {}

    function exposed_getIBCHandler() external view returns (address) {
        return address(getIBCHandler());
    }
}

contract IBCKeeperTest is Test {
    DummyHandler private dummy;
    IBCKeeperHarness private keeper;

    function setUp() public {
        dummy = new DummyHandler();
        keeper = new IBCKeeperHarness(IIBCHandler(address(dummy)));
    }

    function test_getIBCHandler_ReturnsSameAddress() public view {
        address h = keeper.exposed_getIBCHandler();
        assertEq(h, address(dummy));
    }

    function test_constructor_AllowsZeroAddress() public {
        IBCKeeperHarness k = new IBCKeeperHarness(IIBCHandler(address(0)));
        assertEq(k.exposed_getIBCHandler(), address(0));
    }
}
