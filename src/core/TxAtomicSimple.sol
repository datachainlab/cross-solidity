// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {GoogleProtobufAny as Any} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";
import {Packet} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IIBCChannel.sol";

import "./PacketHandler.sol";
import "./ContractRegistry.sol";
import "./IContractModule.sol";
import "./IBCKeeper.sol";

import "../proto/cross/core/atomic/simple/AtomicSimple.sol";

// TxAtomicSimple implements PacketHandler that supports simple-commit protocol
abstract contract TxAtomicSimple is IBCKeeper, PacketHandler, ContractRegistry {
    // it's defined at simple-commit protocol
    uint8 private constant txIndexParticipant = 1;

    event OnContractCall(bytes tx_id, uint8 tx_index, bool success, bytes ret);

    function handlePacket(Packet memory packet) internal virtual override returns (bytes memory acknowledgement) {
        IContractModule module = getModule(packet);

        PacketData.Data memory pd = PacketData.decode(packet.data);
        require(pd.payload.length != 0, "decoding error");
        Any.Data memory anyPayload = Any.decode(pd.payload);
        // TODO should be more gas efficient
        require(
            sha256(bytes(anyPayload.type_url)) == sha256(bytes("/cross.core.atomic.simple.PacketDataCall")),
            "got unexpected type_url"
        );
        PacketDataCall.Data memory pdc = PacketDataCall.decode(anyPayload.value);

        PacketAcknowledgementCall.Data memory ack = PacketAcknowledgementCall.Data({
            status: PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_UNKNOWN
        });
        try module.onContractCall(
            CrossContext(pdc.tx_id, txIndexParticipant, pdc.tx.signers), pdc.tx.call_info
        ) returns (bytes memory ret) {
            ack.status = PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK;
            // slither-disable-next-line reentrancy-events
            emit OnContractCall(pdc.tx_id, txIndexParticipant, true, ret);
        } catch (bytes memory) {
            ack.status = PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_FAILED;
            // slither-disable-next-line reentrancy-events
            emit OnContractCall(pdc.tx_id, txIndexParticipant, false, new bytes(0));
        }

        return packPacketAcknowledgementCall(ack);
    }

    function handleAcknowledgement(
        Packet memory,
        /*packet*/
        bytes memory /*acknowledgement*/
    )
        internal
        virtual
        override
    {
        revert("not implemented error");
    }

    function handleTimeout(
        Packet calldata /*packet*/
    )
        internal
        virtual
        override
    {
        revert("not implemented error");
    }

    function packPacketAcknowledgementCall(PacketAcknowledgementCall.Data memory ack)
        internal
        pure
        returns (bytes memory)
    {
        HeaderField.Data[] memory fields = new HeaderField.Data[](0);
        return Acknowledgement.encode(
            Acknowledgement.Data({
                is_success: true,
                result: PacketData.encode(
                    PacketData.Data({
                        header: Header.Data({fields: fields}),
                        payload: Any.encode(
                            Any.Data({
                                type_url: "/cross.core.atomic.simple.PacketAcknowledgementCall",
                                value: PacketAcknowledgementCall.encode(ack)
                            })
                        )
                    })
                )
            })
        );
    }
}
