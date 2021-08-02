// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.6.8;
pragma experimental ABIEncoderV2;

import "./CrossModule.sol";
import "./TxAtomicSimple.sol";
import "./SimpleContractRegistry.sol";
import "./IBCKeeper.sol";

contract CrossSimpleModule is CrossModule, SimpleContractRegistry, TxAtomicSimple {
    constructor(IBCHost host_, IBCHandler ibcHandler_) IBCKeeper(host_, ibcHandler_) public {}
}
