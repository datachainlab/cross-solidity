// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {GoogleProtobufAny as Any} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";
import {Packet} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IIBCChannel.sol";

import "./PacketHandler.sol";
import "./ContractRegistry.sol";
import "./IContractModule.sol";
import "./IBCKeeper.sol";

import "../proto/cross/core/atomic/simple/AtomicSimple.sol";

/**
 * @title TxAtomicSimple
 * @notice simple-commit プロトコル対応の PacketHandler 実装
 */
abstract contract TxAtomicSimple is IBCKeeper, PacketHandler, ContractRegistry {
    // simple-commit プロトコル上の participant index
    uint8 private constant txIndexParticipant = 1;

    event OnContractCall(bytes tx_id, uint8 tx_index, bool success, bytes ret);
    event OnTimeoutPacket(bytes tx_id, uint8 tx_index, uint64 sequence);

    /// @inheritdoc PacketHandler
    function handlePacket(Packet memory packet)
        internal
        virtual
        override
        returns (bytes memory acknowledgement)
    {
        // ルーティング先モジュール解決（1回だけ）
        IContractModule module = getModule(packet);

        // PacketData のデコード
        PacketData.Data memory pd = PacketData.decode(packet.data);
        require(pd.payload.length != 0, "decoding error");

        Any.Data memory anyPayload = Any.decode(pd.payload);
        // type_url チェック（/cross.core.atomic.simple.PacketDataCall）
        require(
            sha256(bytes(anyPayload.type_url)) == sha256(bytes("/cross.core.atomic.simple.PacketDataCall")),
            "got unexpected type_url"
        );

        // 具体 payload へデコード
        PacketDataCall.Data memory pdc = PacketDataCall.decode(anyPayload.value);

        // コール実行 & ACK 生成
        PacketAcknowledgementCall.Data memory ack;
        try module.onContractCall(
            CrossContext(pdc.tx_id, txIndexParticipant, pdc.tx.signers),
            pdc.tx.call_info
        ) returns (bytes memory ret) {
            ack.status = PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK;
            emit OnContractCall(pdc.tx_id, txIndexParticipant, true, ret);
        } catch (bytes memory) {
            ack.status = PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_FAILED;
            emit OnContractCall(pdc.tx_id, txIndexParticipant, false, new bytes(0));
        }

        return packPacketAcknowledgementCall(ack);
    }

    /// @inheritdoc PacketHandler
    function handleAcknowledgement(Packet memory /*packet*/, bytes memory /*acknowledgement*/)
        internal
        virtual
        override
    {
        revert("not implemented error");
    }

    function handleTimeout(Packet calldata packet) internal virtual override {
        emit OnTimeoutPacket("", txIndexParticipant, packet.sequence);
    }

    // ---- ACK エンコード補助 ----
    function packPacketAcknowledgementCall(PacketAcknowledgementCall.Data memory ack)
        internal
        pure
        returns (bytes memory)
    {
        HeaderField.Data[] memory fields;
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
