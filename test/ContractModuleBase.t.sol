// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase, gas-small-strings
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";
import "../src/core/ContractModuleBase.sol";
import {CrossContext} from "../src/core/IContractModule.sol";
import {Account as AuthAccount} from "../src/proto/cross/core/auth/Auth.sol";

contract ContractModuleBaseHarness is ContractModuleBase {
    bool public authorizeResult = true;
    bool public authorizeCalled = false;

    // Implement abstract functions
    function onCommit(CrossContext calldata) external override {}
    function onAbort(CrossContext calldata) external override {}

    function setAuthorizeResult(bool result) external {
        authorizeResult = result;
    }

    function _authorize(CrossContext calldata, bytes calldata) internal virtual override {
        authorizeCalled = true;
        if (!authorizeResult) {
            revert("Unauthorized");
        }
    }

    function _onContractCommitImmediately(CrossContext calldata, bytes calldata)
        internal
        virtual
        override
        returns (bytes memory)
    {
        return hex"AA";
    }

    function _onContractPrepare(CrossContext calldata, bytes calldata)
        internal
        virtual
        override
        returns (bytes memory)
    {
        return hex"BB";
    }
}

contract ContractModuleBaseTest is Test {
    ContractModuleBaseHarness private harness;
    CrossContext private context;

    function setUp() public {
        harness = new ContractModuleBaseHarness();

        // Setup dummy context
        AuthAccount.Data[] memory signers;
        context = CrossContext({txID: hex"00", txIndex: 0, signers: signers});
    }

    function test_onContractCommitImmediately_CallsAuthorizeAndImplementation() public {
        harness.setAuthorizeResult(true);

        bytes memory ret = harness.onContractCommitImmediately(context, "");

        assertTrue(harness.authorizeCalled(), "_authorize should be called");
        assertEq(ret, hex"AA", "Should return implementation result");
    }

    function test_onContractCommitImmediately_RevertsWhen_AuthorizeFails() public {
        harness.setAuthorizeResult(false);

        vm.expectRevert("Unauthorized");
        harness.onContractCommitImmediately(context, "");
    }

    function test_onContractPrepare_CallsAuthorizeAndImplementation() public {
        harness.setAuthorizeResult(true);

        bytes memory ret = harness.onContractPrepare(context, "");

        assertTrue(harness.authorizeCalled(), "_authorize should be called");
        assertEq(ret, hex"BB", "Should return implementation result");
    }

    function test_onContractPrepare_RevertsWhen_AuthorizeFails() public {
        harness.setAuthorizeResult(false);

        vm.expectRevert("Unauthorized");
        harness.onContractPrepare(context, "");
    }
}
