// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
pragma experimental ABIEncoderV2;

import "@hyperledger-labs/yui-ibc-solidity/contracts/core/IBCHost.sol";
import "@hyperledger-labs/yui-ibc-solidity/contracts/core/IBCHandler.sol";

// IBCKeeper keeps the contracts of IBC
abstract contract IBCKeeper {
    IBCHandler ibcHandler;
    IBCHost ibcHost;

    constructor(IBCHost host_, IBCHandler handler_) {
        ibcHost = host_;
        ibcHandler = handler_;
    }

    function getIBCHandler() internal view returns (IBCHandler) {
        return ibcHandler;
    }

    function getIBCHost() internal view returns (IBCHost) {
        return ibcHost;
    }
}
