// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "./CrossModule.sol";
import "./TxAtomicSimple.sol";
import "./SimpleContractRegistry.sol";
import "./IContractModule.sol";
import {IIBCHandler} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/25-handler/IIBCHandler.sol";

contract CrossSimpleModule is CrossModule {
    constructor(
        IIBCHandler ibcHandler_,
        address txAuthManager_,
        address txManager_,
        IContractModule module,
        bool debugMode
    ) CrossModule(ibcHandler_, txAuthManager_, txManager_, module) {
        if (debugMode) {
            _grantRole(IBC_ROLE, _msgSender());
        }
    }
}
