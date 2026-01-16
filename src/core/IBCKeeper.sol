// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {IIBCHandler} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/25-handler/IIBCHandler.sol";
import {CrossStore} from "./CrossStore.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";

// IBCKeeper keeps the contracts of IBC
abstract contract IBCKeeper is Initializable, CrossStore {
    function __initIBCKeeper(IIBCHandler handler_) internal onlyInitializing {
        _getTxStorage().ibcHandler = handler_;
    }

    function getIBCHandler() internal view returns (IIBCHandler) {
        return _getTxStorage().ibcHandler;
    }
}
