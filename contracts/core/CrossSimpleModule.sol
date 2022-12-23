// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
pragma experimental ABIEncoderV2;

import "./CrossModule.sol";
import "./TxAtomicSimple.sol";
import "./SimpleContractRegistry.sol";
import "./IBCKeeper.sol";

contract CrossSimpleModule is CrossModule, SimpleContractRegistry, TxAtomicSimple {

    constructor(IBCHandler ibcHandler_, IContractModule module, bool debugMode) CrossModule(ibcHandler_) public {
        if (debugMode) {
            _setupRole(IBC_ROLE, _msgSender());
        }
        registerModule(module);
    }

    // debug for serialization

    function getPacketAcknowledgementCall(PacketAcknowledgementCall.CommitStatus status) public pure returns (bytes memory acknowledgement) {
        PacketAcknowledgementCall.Data memory ack;
        ack.status = status;
        return packPacketAcknowledgementCall(ack);
    }
}
