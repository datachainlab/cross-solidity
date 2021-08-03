// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.6.8;
pragma experimental ABIEncoderV2;

import "@hyperledger-labs/yui-ibc-solidity/contracts/core/IBCHandler.sol";
import {
    GoogleProtobufAny as Any
} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/types/GoogleProtobufAny.sol";
import "./PacketHandler.sol";
import "./ContractRegistry.sol";
import "./IContractModule.sol";
import "./IBCKeeper.sol";
import "./types/AtomicSimple.sol";

abstract contract TxAtomicSimple is IBCKeeper, PacketHandler, ContractRegistry {

    function handlePacket(Packet.Data memory packet) virtual internal override returns (bytes memory acknowledgement) {
        IContractModule module = getModule(packet);

        PacketData.Data memory pd = PacketData.decode(packet.data);
        Any.Data memory anyPayload = Any.decode(pd.payload);
        // TODO asserts the typeUrl
        // assert(anyPayload.type_url == "");
        PacketDataCall.Data memory pdc = PacketDataCall.decode(anyPayload.value);

        // TODO returns a correct acknowledgement
        try getModule(packet).onContractCall(CommitMode.UNSPECIFIED_MODE, pdc.tx.call_info) returns (bytes memory ret) {
            return new bytes(0);
        } catch (bytes memory) {
            return new bytes(0);
        }
    }

    function handleAcknowledgement(Packet.Data memory packet, bytes memory acknowledgement) virtual internal override {
        // TODO implements
    }
}
