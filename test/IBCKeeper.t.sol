// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";
import "../src/core/IBCKeeper.sol";

contract DummyHandler {}

contract TestableIBCKeeper is IBCKeeper {
    constructor(IIBCHandler h) IBCKeeper(h) {}

    function handlerAddr() external view returns (address) {
        return address(getIBCHandler());
    }
}

contract IBCKeeperTest is Test {
    DummyHandler dummy;
    TestableIBCKeeper keeper;

    function setUp() public {
        dummy = new DummyHandler();
        keeper = new TestableIBCKeeper(IIBCHandler(address(dummy)));
    }

    function test_GetIBCHandlerReturnsSameAddress() public view{
        address h = keeper.handlerAddr();
        assertEq(h, address(dummy));
    }

    function test_AllowsZeroAddress() public {
        TestableIBCKeeper k = new TestableIBCKeeper(IIBCHandler(address(0)));
        assertEq(k.handlerAddr(), address(0));
    }
}
