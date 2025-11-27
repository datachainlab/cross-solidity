// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "./ContractRegistry.sol";
import "./IContractModule.sol";
import {CrossStore} from "./CrossStore.sol";
import {ICrossError} from "./ICrossError.sol";
import {Packet} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IIBCChannel.sol";

// SimpleContractRegistry is a simple registry that implements ContractRegistry
abstract contract SimpleContractRegistry is ContractRegistry, CrossStore, ICrossError {
    // it keeps only one module.
    IContractModule internal contractModule;

    function registerModule(IContractModule module) internal virtual override {
        CrossStore.TxStorage storage t = _getTxStorage();

        if (address(t.contractModule) != address(0)) revert ModuleAlreadyInitialized();
        t.contractModule = module;
    }

    function getModule(
        Packet memory /*packet*/
    )
        internal
        virtual
        override
        returns (IContractModule)
    {
        CrossStore.TxStorage storage t = _getTxStorage();

        if (address(t.contractModule) == address(0)) revert ModuleNotInitialized();
        return t.contractModule;
    }
}
