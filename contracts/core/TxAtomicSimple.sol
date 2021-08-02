// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.6.8;
pragma experimental ABIEncoderV2;

import "@hyperledger-labs/yui-ibc-solidity/contracts/core/IBCHandler.sol";
import "./PacketHandler.sol";
import "./ContractRegistry.sol";
import "./IContractModule.sol";
import "./IBCKeeper.sol";

abstract contract TxAtomicSimple is IBCKeeper, PacketHandler, ContractRegistry {

    function handlePacket(Packet.Data memory packet) virtual internal override returns (bytes memory acknowledgement) {
        IContractModule module = getModule(packet);

        // TODO implements
        return new bytes(0);
    }

    function handleAcknowledgement(Packet.Data memory packet, bytes memory acknowledgement) virtual internal override {
        // TODO implements
    }
}
