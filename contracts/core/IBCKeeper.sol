// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
pragma experimental ABIEncoderV2;

import "@hyperledger-labs/yui-ibc-solidity/contracts/core/25-handler/IBCHandler.sol";

// IBCKeeper keeps the contracts of IBC
abstract contract IBCKeeper {
    IBCHandler ibcHandler;

    constructor(IBCHandler handler_) {
        ibcHandler = handler_;
    }

    function getIBCHandler() internal view returns (IBCHandler) {
        return ibcHandler;
    }
}
