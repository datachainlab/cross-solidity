// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.6.8;
pragma experimental ABIEncoderV2;

import "@hyperledger-labs/yui-ibc-solidity/contracts/core/types/Channel.sol";
import "./IContractModule.sol";

abstract contract ContractRegistry {
    function registerModule(IContractModule module) virtual internal;
    function getModule(Packet.Data memory packet) virtual internal returns (IContractModule);
}
