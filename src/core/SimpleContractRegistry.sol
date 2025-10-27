// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "./ContractRegistry.sol";
import "./IContractModule.sol";
import {Packet} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IIBCChannel.sol";

// SimpleContractRegistry is a simple registry that implements ContractRegistry
abstract contract SimpleContractRegistry is ContractRegistry {
    // it keeps only one module.
    IContractModule internal contractModule;

    error ModuleAlreadyInitialized();
    error ModuleNotInitialized();

    function registerModule(IContractModule module) internal virtual override {
        if (address(contractModule) != address(0)) revert ModuleAlreadyInitialized();
        contractModule = module;
    }

    function getModule(
        Packet memory /*packet*/
    )
        internal
        virtual
        override
        returns (IContractModule)
    {
        if (address(contractModule) == address(0)) revert ModuleNotInitialized();
        return contractModule;
    }
}
