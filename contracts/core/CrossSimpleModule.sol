// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.6.8;
pragma experimental ABIEncoderV2;

import "./CrossModule.sol";
import "./TxAtomicSimple.sol";
import "./SimpleContractRegistry.sol";
import "./IBCKeeper.sol";

contract CrossSimpleModule is CrossModule, SimpleContractRegistry, TxAtomicSimple {

    constructor(IBCHost ibcHost_, IBCHandler ibcHandler_, IContractModule module, bool debugMode) CrossModule(ibcHost_, ibcHandler_) public {
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
