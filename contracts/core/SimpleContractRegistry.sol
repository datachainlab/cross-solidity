// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
pragma experimental ABIEncoderV2;

import "./ContractRegistry.sol";
import "./IContractModule.sol";
import "@hyperledger-labs/yui-ibc-solidity/contracts/core/types/Channel.sol";

// SimpleContractRegistry is a simple registry that implements ContractRegistry
abstract contract SimpleContractRegistry is ContractRegistry {

    // it keeps only one module.
    IContractModule contractModule;

    function registerModule(IContractModule module) virtual internal override {
        require(address(contractModule) == address(0), "contractModule is already initialized");
        contractModule = module;
    }

    function getModule(Packet.Data memory packet) virtual internal override returns (IContractModule) {
        require(address(contractModule) != address(0), "contractModule is not initialized yet");
        return contractModule;
    }
}
