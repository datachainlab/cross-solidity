// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

import "forge-std/src/Script.sol";
import "forge-std/src/console2.sol";
import {OwnableIBCHandler as IBCHandler} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/OwnableIBCHandler.sol";

contract InitializeContracts is Script {
    function run(
        address ibcHandlerAddr,
        address crossSimpleModule,
        address mockClientAddr,
        string memory portCross,
        string memory mockClientType
    ) external {
        vm.startBroadcast();

        IBCHandler ibc = IBCHandler(ibcHandlerAddr);

        (bool ok1,) =
            address(ibc).call(abi.encodeWithSignature("bindPort(string,address)", portCross, crossSimpleModule));
        require(ok1, "bindPort failed");

        (bool ok2,) =
            address(ibc).call(abi.encodeWithSignature("registerClient(string,address)", mockClientType, mockClientAddr));
        require(ok2, "registerClient failed");

        vm.stopBroadcast();
        console2.log("Initialized. port=%s, clientType=%s", portCross, mockClientType);
    }
}
