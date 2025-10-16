// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;

import "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IBCChannel.sol";
import "./IContractModule.sol";

// ContractRegistry is a registry that manages a contract of Cross Framework
abstract contract ContractRegistry {
    // registerModule registers a given module to the registry
    function registerModule(IContractModule module) internal virtual;

    // getModule returns a module that matches a given packet
    function getModule(Packet.Data memory packet) internal virtual returns (IContractModule);
}
