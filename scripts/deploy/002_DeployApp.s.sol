// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

import "forge-std/src/Script.sol";
import "forge-std/src/console2.sol";

import {OwnableIBCHandler as IBCHandler} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/OwnableIBCHandler.sol";
import {IContractModule} from "contracts/core/IContractModule.sol";
import {CrossSimpleModule} from "contracts/core/CrossSimpleModule.sol";
import {MockClient} from "@hyperledger-labs/yui-ibc-solidity/contracts/clients/MockClient.sol";
import {MockCrossContract} from "contracts/example/MockCrossContract.sol";

contract DeployApp is Script {
    function run(address ibcHandlerAddr, bool debugMode) external {
        vm.startBroadcast();

        MockCrossContract mockApp = new MockCrossContract();
        console2.log("MockCrossContract:", address(mockApp));

        CrossSimpleModule csm = new CrossSimpleModule(
            IBCHandler(ibcHandlerAddr),
            IContractModule(address(mockApp)),
            debugMode
        );
        console2.log("CrossSimpleModule:", address(csm));

        MockClient mockClient = new MockClient(ibcHandlerAddr);
        console2.log("MockClient:", address(mockClient));

        vm.stopBroadcast();
    }
}
