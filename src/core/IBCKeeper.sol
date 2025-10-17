// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {IIBCHandler} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/25-handler/IIBCHandler.sol";

// IBCKeeper keeps the contracts of IBC
abstract contract IBCKeeper {
    IIBCHandler ibcHandler;

    constructor(IIBCHandler handler_) {
        ibcHandler = handler_;
    }

    function getIBCHandler() internal view returns (IIBCHandler) {
        return ibcHandler;
    }
}
