// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

import "./ContractRegistry.sol";
import "./IContractModule.sol";
import "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IBCChannel.sol";

// SimpleContractRegistry is a simple registry that implements ContractRegistry
abstract contract SimpleContractRegistry is ContractRegistry {
    // it keeps only one module.
    IContractModule contractModule;

    function registerModule(IContractModule module) internal virtual override {
        require(address(contractModule) == address(0), "contractModule is already initialized");
        contractModule = module;
    }

    function getModule(Packet.Data memory packet) internal virtual override returns (IContractModule) {
        require(address(contractModule) != address(0), "contractModule is not initialized yet");
        return contractModule;
    }
}
