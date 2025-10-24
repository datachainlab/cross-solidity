/* solhint-disable no-console */
/* solhint-disable gas-small-strings */
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

import {IIBCModuleInitializer} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/26-router/IIBCModule.sol";
import {ILightClient} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/02-client/ILightClient.sol";

contract DeployAll is Script, Config {
    // === Deployment artifacts (written back to deployments.toml) ===
    IBCHandler public ibcHandler;

    MockCrossContract public mockApp;
    CrossSimpleModule public crossSimpleModule;
    MockClient public mockClient;

    // ---------- helpers ----------
    function _deployCore() internal returns (IBCHandler) {
        console2.log("==> 01_DeployCore");
        IBCHandler handler = new IBCHandler(
            new IBCClient(),
            new IBCConnection(),
            new IBCChannelHandshake(),
            new IBCChannelPacketSendRecv(),
            new IBCChannelPacketTimeout(),
            new IBCChannelUpgradeInitTryAck(),
            new IBCChannelUpgradeConfirmOpenTimeoutCancel()
        );
        console2.log("  IBCHandler (Ownable):", address(handler));
        return handler;
    }

    function _deployApp(IBCHandler handler, bool debugMode)
        internal
        returns (MockCrossContract, CrossSimpleModule, MockClient)
    {
        console2.log("==> 02_DeployApp");
        MockCrossContract app = new MockCrossContract();
        console2.log("  MockCrossContract:", address(app));

        CrossSimpleModule module = new CrossSimpleModule(handler, IContractModule(address(app)), debugMode);
        console2.log("  CrossSimpleModule:", address(module));

        MockClient mclient = new MockClient(address(handler));
        console2.log("  MockClient:", address(mclient));

        return (app, module, mclient);
    }

    function _initialize(
        IBCHandler handler,
        CrossSimpleModule module,
        string memory portCross,
        string memory mockClientType,
        MockClient mclient
    ) internal {
        console2.log("==> 03_Initialize");
        handler.bindPort(portCross, IIBCModuleInitializer(module));
        handler.registerClient(mockClientType, ILightClient(mclient));
        console2.log("  Initialized. port=%s, clientType=%s", portCross, mockClientType);
    }

    // ---------- entry ----------
    function run() external {
        // 1) Load config with write-back enabled (stores results after deployment)
        _loadConfig("./deployments.toml", true);

        uint256 chainId = block.chainid;
        console2.log("Deploying to chain:", chainId);

        // 2) Read configuration values
        string memory mnemonic = config.get("mnemonic").toString();
        uint256 mnemonicIndexU256 = config.get("mnemonic_index").toUint256();
        // solhint-disable-next-line gas-strict-inequalities
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

        // 3) Derive deployer private key from mnemonic + index
        uint256 deployerPk = vm.deriveKey(mnemonic, mnemonicIndex);
        address deployer = vm.addr(deployerPk);
        console2.log("Deployer:", deployer);

        // 4) Deploy + Initialize (single broadcast session)
        vm.startBroadcast(deployerPk);

        ibcHandler = _deployCore();
        (mockApp, crossSimpleModule, mockClient) = _deployApp(ibcHandler, debugMode);
        _initialize(ibcHandler, crossSimpleModule, portCross, mockClientType, mockClient);

        vm.stopBroadcast();

        // 5) Write back: save addresses & metadata to deployments.toml
        config.set("ibc_handler", address(ibcHandler));
        config.set("mock_cross_contract", address(mockApp));
        config.set("cross_simple_module", address(crossSimpleModule));
        config.set("mock_client", address(mockClient));
        config.set("deployer", deployer);

        console2.log("\nDeployment complete! Addresses saved to deployments.toml");
    }
}
