// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";

import "../src/core/TxAtomicSimple.sol";
import "../src/core/IContractModule.sol";
import "../src/core/IBCKeeper.sol";
import {IIBCHandler} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/25-handler/IIBCHandler.sol";
import {Packet} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IIBCChannel.sol";

import "../src/proto/cross/core/atomic/simple/AtomicSimple.sol";
import {GoogleProtobufAny as Any} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";
import {Account as AuthAccount} from "../src/proto/cross/core/auth/Auth.sol";

contract DummyHandler {}

contract SuccessModule is IContractModule {
    bytes public retBytes;

    constructor(bytes memory r) {
        retBytes = r;
    }

    function onContractCall(
        CrossContext calldata,
        /*context*/
        bytes calldata /*callInfo*/
    )
        external
        view
        returns (bytes memory)
    {
        return retBytes;
    }
}

contract RevertingModule is IContractModule {
    function onContractCall(
        CrossContext calldata,
        /*context*/
        bytes calldata /*callInfo*/
    )
        external
        pure
        returns (bytes memory)
    {
        revert("boom");
    }
}

contract TestableTxAtomicSimple is TxAtomicSimple {
    IContractModule internal _module;

    constructor(IIBCHandler h) IBCKeeper(h) {}

    function registerModule(IContractModule module) internal override {
        _module = module;
    }

    function getModule(
        Packet memory /*packet*/
    )
        internal
        override
        returns (IContractModule)
    {
        return _module;
    }

    function extHandlePacket(Packet calldata p) external returns (bytes memory ack) {
        return handlePacket(p);
    }

    function extHandleAcknowledgement(Packet calldata p, bytes calldata ackBytes) external {
        handleAcknowledgement(p, ackBytes);
    }

    function extHandleTimeout(Packet calldata p) external {
        handleTimeout(p);
    }

    function setModule(IContractModule m) external {
        _module = m;
    }
}

/// -------- Tests --------

contract TxAtomicSimpleTest is Test {
    DummyHandler private handler;
    TestableTxAtomicSimple private harness;

    event OnContractCall(bytes indexed txId, uint8 indexed txIndex, bool indexed success, bytes ret);

    function setUp() public {
        handler = new DummyHandler();
        harness = new TestableTxAtomicSimple(IIBCHandler(address(handler)));
    }

    /// ---- Helpers ----

    function _mkPacketWithCall(bytes memory txId, bytes memory callInfo) internal pure returns (Packet memory p) {
        Any.Data memory emptyAny = Any.Data({type_url: "", value: ""});
        ReturnValue.Data memory emptyRet = ReturnValue.Data({value: ""});

        AuthAccount.Data[] memory signers;
        Any.Data[] memory objects;

        PacketDataCallResolvedContractTransaction.Data memory txResolved =
            PacketDataCallResolvedContractTransaction.Data({
                cross_chain_channel: emptyAny,
                signers: signers,
                call_info: callInfo,
                return_value: emptyRet,
                objects: objects
            });

        PacketDataCall.Data memory callData = PacketDataCall.Data({tx_id: txId, tx: txResolved});

        bytes memory anyPayload = Any.encode(
            // solhint-disable-next-line gas-small-strings
            Any.Data({type_url: "/cross.core.atomic.simple.PacketDataCall", value: PacketDataCall.encode(callData)})
        );

        HeaderField.Data[] memory fields;
        bytes memory packetDataBytes =
            PacketData.encode(PacketData.Data({header: Header.Data({fields: fields}), payload: anyPayload}));

        p.data = packetDataBytes;
    }

    function _decodeAckStatus(bytes memory ack) internal pure returns (PacketAcknowledgementCall.CommitStatus) {
        Acknowledgement.Data memory ackData = Acknowledgement.decode(ack);
        PacketData.Data memory pd = PacketData.decode(ackData.result);
        Any.Data memory any_ = Any.decode(pd.payload);
        PacketAcknowledgementCall.Data memory pac = PacketAcknowledgementCall.decode(any_.value);
        return pac.status;
    }

    function test_handlePacket_Success_ReturnsOK_AndEmitsEvent() public {
        bytes memory ret = hex"010203";
        harness.setModule(new SuccessModule(ret));

        bytes memory txId = hex"deadbeef";
        bytes memory callInfo = hex"c0ffee";
        Packet memory packet = _mkPacketWithCall(txId, callInfo);

        // assert event emitted
        vm.expectEmit(true, true, true, true);
        emit OnContractCall(txId, 1, true, ret);

        bytes memory ack = harness.extHandlePacket(packet);

        assertEq(
            uint256(_decodeAckStatus(ack)),
            uint256(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_OK),
            "ACK should be OK"
        );
    }

    function test_handlePacket_RevertInModule_ReturnsFAILED_AndEmitsEvent() public {
        harness.setModule(new RevertingModule());

        bytes memory txId = hex"bead";
        bytes memory callInfo = hex"00";
        Packet memory packet = _mkPacketWithCall(txId, callInfo);

        // assert event emitted
        vm.expectEmit(true, true, true, true);
        emit OnContractCall(txId, 1, false, "");

        bytes memory ack = harness.extHandlePacket(packet);

        assertEq(
            uint256(_decodeAckStatus(ack)),
            uint256(PacketAcknowledgementCall.CommitStatus.COMMIT_STATUS_FAILED),
            "ACK should be FAILED"
        );
    }

    function test_handlePacket_Reverts_WhenPayloadEmpty() public {
        HeaderField.Data[] memory fields;
        bytes memory packetDataBytes =
            PacketData.encode(PacketData.Data({header: Header.Data({fields: fields}), payload: bytes("")}));
        Packet memory p;
        p.data = packetDataBytes;

        vm.expectRevert(TxAtomicSimple.PayloadDecodeFailed.selector);
        harness.extHandlePacket(p);
    }

    function test_handlePacket_Reverts_WhenTypeURLUnexpected() public {
        bytes memory bogus = Any.encode(Any.Data({type_url: "/not.expected", value: hex"01"}));
        HeaderField.Data[] memory fields;
        bytes memory packetDataBytes =
            PacketData.encode(PacketData.Data({header: Header.Data({fields: fields}), payload: bogus}));
        Packet memory p;
        p.data = packetDataBytes;

        vm.expectRevert(TxAtomicSimple.UnexpectedTypeURL.selector);
        harness.extHandlePacket(p);
    }

    function test_handleAcknowledgement_Reverts_NotImplemented() public {
        Packet memory p;
        vm.expectRevert(TxAtomicSimple.NotImplemented.selector);
        harness.extHandleAcknowledgement(p, hex"");
    }

    function test_handleTimeout_Reverts_NotImplemented() public {
        Packet memory p;
        vm.expectRevert(TxAtomicSimple.NotImplemented.selector);
        harness.extHandleTimeout(p);
    }
}
