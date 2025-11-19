// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";

import "../src/core/CrossSimpleModule.sol";
import "../src/core/IContractModule.sol";
import "../src/core/TxAtomicSimple.sol";
import "../src/core/ICrossError.sol";
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

    function onAbort(CrossContext calldata context) external override {}
    function onCommit(CrossContext calldata context) external override {}

    function onContractPrepare(CrossContext calldata context, bytes calldata callInfo)
        external
        override
        returns (bytes memory)
    {
        return "";
    }
}

contract CrossSimpleModuleHarness is CrossSimpleModule {
    constructor(IIBCHandler h, address txAuthManager_, address txManager_, bool debugMode)
        CrossSimpleModule(h, txAuthManager_, txManager_, debugMode)
    {}

    function workaround_hasIbcRole(address a) external view returns (bool) {
        return hasRole(IBC_ROLE, a);
    }
}

contract CrossSimpleModuleTest is Test, ICrossError {
    DummyHandler private handler;
    DummyModule private moduleImpl;
    Packet internal _emptyPacket;

    function setUp() public {
        handler = new DummyHandler();
        moduleImpl = new DummyModule();
    }

    function test_constructor_GrantsIbcRoleWhenDebugModeTrue() public {
        CrossSimpleModuleHarness harness =
            new CrossSimpleModuleHarness(IIBCHandler(address(handler)), address(0), address(0), true);

        assertTrue(harness.workaround_hasIbcRole(address(this)), "role on debug");
    }

    function test_constructor_DoesNotGrantIbcRoleWhenDebugModeFalse() public {
        CrossSimpleModuleHarness harness =
            new CrossSimpleModuleHarness(IIBCHandler(address(handler)), address(0), address(0), false);

        assertFalse(harness.workaround_hasIbcRole(address(this)), "no role on debug");
    }
}
