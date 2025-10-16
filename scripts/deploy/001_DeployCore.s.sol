// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

import "forge-std/src/Script.sol";
import "forge-std/src/console2.sol";

import {IBCClient}    from "@hyperledger-labs/yui-ibc-solidity/contracts/core/02-client/IBCClient.sol";
import {IBCConnection} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/03-connection/IBCConnection.sol";
import {IBCChannel}   from "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IBCChannel.sol";
import {OwnableIBCHandler as IBCHandler} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/OwnableIBCHandler.sol";

contract DeployCore is Script {
    function run() external {
        vm.startBroadcast();

        // --- Deploy dependent contracts ---
        IBCClient client = new IBCClient();
        console2.log("IBCClient:", address(client));

        IBCConnection connection = new IBCConnection();
        console2.log("IBCConnection:", address(connection));

        IBCChannel channel = new IBCChannel();
        console2.log("IBCChannel:", address(channel));

        IBCHandler handler = new IBCHandler(
            address(client),
            address(connection),
            address(channel),
            address(channel)
        );
        console2.log("IBCHandler (Ownable):", address(handler));

        vm.stopBroadcast();
    }
}
