// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.6.8;
pragma experimental ABIEncoderV2;

import "@hyperledger-labs/yui-ibc-solidity/contracts/core/IBCHost.sol";
import "@hyperledger-labs/yui-ibc-solidity/contracts/core/IBCHandler.sol";

abstract contract IBCKeeper {
    IBCHandler ibcHandler;
    IBCHost ibcHost;

    constructor(IBCHost host_, IBCHandler handler_) public {
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
