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

    uint8 constant private txIndexParticipant = 1;

    function handlePacket(Packet.Data memory packet) virtual internal override returns (bytes memory acknowledgement) {
        IContractModule module = getModule(packet);

        PacketData.Data memory pd = PacketData.decode(packet.data);
        require(pd.payload.length != 0, "decoding error");
        Any.Data memory anyPayload = Any.decode(pd.payload);
        require(sha256(bytes(anyPayload.type_url)) == sha256(bytes("/cross.core.atomic.simple.PacketDataCall")), "got unexpected type_url");
        PacketDataCall.Data memory pdc = PacketDataCall.decode(anyPayload.value);

        PacketAcknowledgementCall.Data memory ack;
        try getModule(packet).onContractCall(CrossContext(pdc.tx_id, txIndexParticipant, pdc.tx.signers), pdc.tx.call_info) returns (bytes memory ret) {
            ack.status = PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK;
            // TODO emit an event that includes the return value
        } catch (bytes memory) {
            ack.status = PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_FAILED;
        }

        return packPacketAcknowledgementCall(ack);
    }

    function handleAcknowledgement(Packet.Data memory packet, bytes memory acknowledgement) virtual internal override {
        revert("not implemented error");
    }

    function packPacketAcknowledgementCall(PacketAcknowledgementCall.Data memory ack) internal pure returns (bytes memory) {
        HeaderField.Data[] memory fields;
        return PacketData.encode(
            PacketData.Data({
                header: Header.Data({
                    fields: fields
                }),
                payload: Any.encode(
                    Any.Data({
                        type_url: "/cross.core.atomic.simple.PacketAcknowledgementCall",
                        value: PacketAcknowledgementCall.encode(ack)
                    })
                )
            })
        );
    }
}
