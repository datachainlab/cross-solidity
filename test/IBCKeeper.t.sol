// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase
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
    DummyHandler private dummy;
    TestableIBCKeeper private keeper;

    function setUp() public {
        dummy = new DummyHandler();
        keeper = new TestableIBCKeeper(IIBCHandler(address(dummy)));
    }

    function test_GetIBCHandler_GetIBCHandlerReturnsSameAddress() public view {
        address h = keeper.handlerAddr();
        assertEq(h, address(dummy));
    }

    function test_Constructor_AllowsZeroAddress() public {
        TestableIBCKeeper k = new TestableIBCKeeper(IIBCHandler(address(0)));
        assertEq(k.handlerAddr(), address(0));
    }
}
