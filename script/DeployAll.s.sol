// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "forge-std/src/Script.sol";
import "forge-std/src/console2.sol";
import {Config} from "forge-std/src/Config.sol";

// === Core ===
import {IBCClient} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/02-client/IBCClient.sol";
import {
    IBCConnectionSelfStateNoValidation as IBCConnection
} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/03-connection/IBCConnectionSelfStateNoValidation.sol";
import {
    IBCChannelHandshake
} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IBCChannelHandshake.sol";
import {
    IBCChannelPacketSendRecv
} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IBCChannelPacketSendRecv.sol";
import {
    IBCChannelPacketTimeout
} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IBCChannelPacketTimeout.sol";
import {
    IBCChannelUpgradeInitTryAck,
    IBCChannelUpgradeConfirmOpenTimeoutCancel
} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IBCChannelUpgrade.sol";
import {
    OwnableIBCHandler as IBCHandler
} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/25-handler/OwnableIBCHandler.sol";

// === App ===
import {IContractModule} from "src/core/IContractModule.sol";
import {CrossSimpleModule} from "src/core/CrossSimpleModule.sol";
import {MockClient} from "@hyperledger-labs/yui-ibc-solidity/contracts/clients/mock/MockClient.sol";
import {MockCrossContract} from "src/example/MockCrossContract.sol";

contract DeployAll is Script, Config {
    // === Deployment artifacts (written back to deployments.toml) ===
    IBCHandler public ibcHandler;

    MockCrossContract public mockApp;
    CrossSimpleModule public crossSimpleModule;
    MockClient public mockClient;

    function run() external {
        // 1) Load config with write-back enabled (stores results after deployment)
        _loadConfig(
            "./deployments.toml",
            /*writeBack=*/
            true
        );

        uint256 chainId = block.chainid;
        console2.log("Deploying to chain:", chainId);

        // 2) Read configuration values (resolved for the current chain)
        //    - Required:
        //        string:  mnemonic
        //        uint:    mnemonic_index
        //        bool:    debug_mode
        //        string:  port_cross
        //        string:  mock_client_type
        string memory mnemonic = config.get("mnemonic").toString();
        uint256 mnemonicIndexU256 = config.get("mnemonic_index").toUint256();
        require(mnemonicIndexU256 <= type(uint32).max, "mnemonic_index too large");
        uint32 mnemonicIndex = uint32(mnemonicIndexU256);

        bool debugMode = config.get("debug_mode").toBool();
        string memory portCross = config.get("port_cross").toString();
        string memory mockClientType = config.get("mock_client_type").toString();

        console2.log("Config:");
        console2.log("  debug_mode      :", debugMode);
        console2.log("  port_cross      :", portCross);
        console2.log("  mock_client_type:", mockClientType);
        console2.log("  mnemonic_index  :", mnemonicIndex);

        // 3) Derive deployer private key from mnemonic + index (Foundry cheatcode)
        uint256 deployerPk = vm.deriveKey(mnemonic, mnemonicIndex);
        address deployer = vm.addr(deployerPk);
        console2.log("Deployer:", deployer);

        // 4) Deploy + Initialize (single broadcast session)
        vm.startBroadcast(deployerPk);

        // --- 01_DeployCore ---
        console2.log("==> 01_DeployCore");

        ibcHandler = new IBCHandler(
            new IBCClient(),
            new IBCConnection(),
            new IBCChannelHandshake(),
            new IBCChannelPacketSendRecv(),
            new IBCChannelPacketTimeout(),
            new IBCChannelUpgradeInitTryAck(),
            new IBCChannelUpgradeConfirmOpenTimeoutCancel()
        );
        console2.log("  IBCHandler (Ownable):", address(ibcHandler));

        // --- 02_DeployApp ---
        console2.log("==> 02_DeployApp");
        mockApp = new MockCrossContract();
        console2.log("  MockCrossContract:", address(mockApp));

        crossSimpleModule = new CrossSimpleModule(ibcHandler, IContractModule(address(mockApp)), debugMode);
        console2.log("  CrossSimpleModule:", address(crossSimpleModule));

        mockClient = new MockClient(address(ibcHandler));
        console2.log("  MockClient:", address(mockClient));

        // --- 03_Initialize ---
        console2.log("==> 03_Initialize");
        {
            (bool ok1,) = address(ibcHandler)
                .call(abi.encodeWithSignature("bindPort(string,address)", portCross, address(crossSimpleModule)));
            require(ok1, "bindPort failed");

            (bool ok2,) = address(ibcHandler)
                .call(abi.encodeWithSignature("registerClient(string,address)", mockClientType, address(mockClient)));
            require(ok2, "registerClient failed");
        }
        console2.log("  Initialized. port=%s, clientType=%s", portCross, mockClientType);

        vm.stopBroadcast();

        // 5) Write back: save addresses & metadata to deployments.toml
        //    (addresses go under <chain>.address.*, meta under <chain>.meta.*)
        config.set("ibc_handler", address(ibcHandler));
        config.set("mock_cross_contract", address(mockApp));
        config.set("cross_simple_module", address(crossSimpleModule));
        config.set("mock_client", address(mockClient));

        // Meta
        config.set("deployer", deployer);

        console2.log("\nDeployment complete! Addresses saved to deployments.toml");
    }
}
