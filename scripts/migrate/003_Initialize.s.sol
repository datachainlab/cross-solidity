// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

import "forge-std/Script.sol";
import "forge-std/console2.sol";

import {OwnableIBCHandler as IBCHandler} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/OwnableIBCHandler.sol";

contract InitializeContracts is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");

        address ibcHandlerAddr = vm.envAddress("IBC_HANDLER");
        address crossSimpleModule = vm.envAddress("CROSS_SIMPLE_MODULE");
        address mockClientAddr = vm.envAddress("MOCK_CLIENT");

        string memory portCross = vm.envOr("PORT_CROSS", string("cross"));
        string memory mockClientType = vm.envOr("MOCK_CLIENT_TYPE", string("mock-client"));

        vm.startBroadcast(pk);

        IBCHandler ibc = IBCHandler(ibcHandlerAddr);

        (bool ok1, ) = address(ibc).call(
            abi.encodeWithSignature("bindPort(string,address)", portCross, crossSimpleModule)
        );
        require(ok1, "bindPort failed");

        (bool ok2, ) = address(ibc).call(
            abi.encodeWithSignature("registerClient(string,address)", mockClientType, mockClientAddr)
        );
        require(ok2, "registerClient failed");

        vm.stopBroadcast();
        console2.log("Initialized. port=%s, clientType=%s", portCross, mockClientType);
    }
}
