// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "./CrossModule.sol";
import "./TxAtomicSimple.sol";
import "./SimpleContractRegistry.sol";
import "./IContractModule.sol";
import {IIBCHandler} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/25-handler/IIBCHandler.sol";

contract CrossSimpleModule is CrossModule, SimpleContractRegistry, TxAtomicSimple {
    constructor(IIBCHandler ibcHandler_, IContractModule module, bool debugMode) CrossModule(ibcHandler_) {
        if (debugMode) {
            _grantRole(IBC_ROLE, _msgSender());
        }
        registerModule(module);
    }

    // ---- debug for serialization ----
    function getPacketAcknowledgementCall(PacketAcknowledgementCall.CommitStatus status)
        public
        pure
        returns (bytes memory acknowledgement)
    {
        PacketAcknowledgementCall.Data memory ack;
        ack.status = status;
        return packPacketAcknowledgementCall(ack);
    }
}
