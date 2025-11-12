// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;
import "@hyperledger-labs/yui-ibc-solidity/contracts/proto/ProtoBufRuntime.sol";
import "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";
import "../../../ibc/core/client/v1/client.sol";
import "../auth/Auth.sol";

library Tx {
    //enum definition
    // Solidity enum definitions
    enum CommitProtocol {
        COMMIT_PROTOCOL_UNKNOWN,
        COMMIT_PROTOCOL_SIMPLE,
        COMMIT_PROTOCOL_TPC
    }

    // Solidity enum encoder
    function encode_CommitProtocol(CommitProtocol x) internal pure returns (int32) {
        if (x == CommitProtocol.COMMIT_PROTOCOL_UNKNOWN) {
            return 0;
        }

        if (x == CommitProtocol.COMMIT_PROTOCOL_SIMPLE) {
            return 1;
        }

        if (x == CommitProtocol.COMMIT_PROTOCOL_TPC) {
            return 2;
        }
        revert();
    }

    // Solidity enum decoder
    function decode_CommitProtocol(int64 x) internal pure returns (CommitProtocol) {
        if (x == 0) {
            return CommitProtocol.COMMIT_PROTOCOL_UNKNOWN;
        }

        if (x == 1) {
            return CommitProtocol.COMMIT_PROTOCOL_SIMPLE;
        }

        if (x == 2) {
            return CommitProtocol.COMMIT_PROTOCOL_TPC;
        }
        revert();
    }

    /**
     * @dev The estimator for an packed enum array
     * @return The number of bytes encoded
     */
    function estimate_packed_repeated_CommitProtocol(CommitProtocol[] memory a) internal pure returns (uint256) {
        uint256 e = 0;
        for (uint256 i = 0; i < a.length; i++) {
            e += ProtoBufRuntime._sz_enum(encode_CommitProtocol(a[i]));
        }
        return e;
    }

    //struct definition
    struct Data {
        bytes id;
        Tx.CommitProtocol commit_protocol;
        ResolvedContractTransaction.Data[] contract_transactions;
        IbcCoreClientV1Height.Data timeout_height;
        uint64 timeout_timestamp;
    }

    // Decoder section

    /**
     * @dev The main decoder for memory
     * @param bs The bytes array to be decoded
     * @return The decoded struct
     */
    function decode(bytes memory bs) internal pure returns (Data memory) {
        (Data memory x,) = _decode(32, bs, bs.length);
        return x;
    }

    /**
     * @dev The main decoder for storage
     * @param self The in-storage struct
     * @param bs The bytes array to be decoded
     */
    function decode(Data storage self, bytes memory bs) internal {
        (Data memory x,) = _decode(32, bs, bs.length);
        store(x, self);
    }

    // inner decoder

    /**
     * @dev The decoder for internal usage
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @param sz The number of bytes expected
     * @return The decoded struct
     * @return The number of bytes decoded
     */
    function _decode(uint256 p, bytes memory bs, uint256 sz) internal pure returns (Data memory, uint256) {
        Data memory r;
        uint256[6] memory counters;
        uint256 fieldId;
        ProtoBufRuntime.WireType wireType;
        uint256 bytesRead;
        uint256 offset = p;
        uint256 pointer = p;
        while (pointer < offset + sz) {
            (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
            pointer += bytesRead;
            if (fieldId == 1) {
                pointer += _read_id(pointer, bs, r);
            } else if (fieldId == 2) {
                pointer += _read_commit_protocol(pointer, bs, r);
            } else if (fieldId == 3) {
                pointer += _read_unpacked_repeated_contract_transactions(pointer, bs, nil(), counters);
            } else if (fieldId == 4) {
                pointer += _read_timeout_height(pointer, bs, r);
            } else if (fieldId == 5) {
                pointer += _read_timeout_timestamp(pointer, bs, r);
            } else {
                pointer += ProtoBufRuntime._skip_field_decode(wireType, pointer, bs);
            }
        }
        pointer = offset;
        if (counters[3] > 0) {
            require(r.contract_transactions.length == 0);
            r.contract_transactions = new ResolvedContractTransaction.Data[](counters[3]);
        }

        while (pointer < offset + sz) {
            (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
            pointer += bytesRead;
            if (fieldId == 3) {
                pointer += _read_unpacked_repeated_contract_transactions(pointer, bs, r, counters);
            } else {
                pointer += ProtoBufRuntime._skip_field_decode(wireType, pointer, bs);
            }
        }
        return (r, sz);
    }

    // field readers

    /**
     * @dev The decoder for reading a field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @param r The in-memory struct
     * @return The number of bytes decoded
     */
    function _read_id(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (bytes memory x, uint256 sz) = ProtoBufRuntime._decode_bytes(p, bs);
        r.id = x;
        return sz;
    }

    /**
     * @dev The decoder for reading a field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @param r The in-memory struct
     * @return The number of bytes decoded
     */
    function _read_commit_protocol(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (int64 tmp, uint256 sz) = ProtoBufRuntime._decode_enum(p, bs);
        Tx.CommitProtocol x = decode_CommitProtocol(tmp);
        r.commit_protocol = x;
        return sz;
    }

    /**
     * @dev The decoder for reading a field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @param r The in-memory struct
     * @param counters The counters for repeated fields
     * @return The number of bytes decoded
     */
    function _read_unpacked_repeated_contract_transactions(
        uint256 p,
        bytes memory bs,
        Data memory r,
        uint256[6] memory counters
    ) internal pure returns (uint256) {
        /**
         * if `r` is NULL, then only counting the number of fields.
         */
        (ResolvedContractTransaction.Data memory x, uint256 sz) = _decode_ResolvedContractTransaction(p, bs);
        if (isNil(r)) {
            counters[3] += 1;
        } else {
            r.contract_transactions[r.contract_transactions.length - counters[3]] = x;
            counters[3] -= 1;
        }
        return sz;
    }

    /**
     * @dev The decoder for reading a field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @param r The in-memory struct
     * @return The number of bytes decoded
     */
    function _read_timeout_height(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (IbcCoreClientV1Height.Data memory x, uint256 sz) = _decode_IbcCoreClientV1Height(p, bs);
        r.timeout_height = x;
        return sz;
    }

    /**
     * @dev The decoder for reading a field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @param r The in-memory struct
     * @return The number of bytes decoded
     */
    function _read_timeout_timestamp(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (uint64 x, uint256 sz) = ProtoBufRuntime._decode_uint64(p, bs);
        r.timeout_timestamp = x;
        return sz;
    }

    // struct decoder
    /**
     * @dev The decoder for reading a inner struct field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @return The decoded inner-struct
     * @return The number of bytes used to decode
     */
    function _decode_ResolvedContractTransaction(uint256 p, bytes memory bs)
        internal
        pure
        returns (ResolvedContractTransaction.Data memory, uint256)
    {
        uint256 pointer = p;
        (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
        pointer += bytesRead;
        (ResolvedContractTransaction.Data memory r,) = ResolvedContractTransaction._decode(pointer, bs, sz);
        return (r, sz + bytesRead);
    }

    /**
     * @dev The decoder for reading a inner struct field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @return The decoded inner-struct
     * @return The number of bytes used to decode
     */
    function _decode_IbcCoreClientV1Height(uint256 p, bytes memory bs)
        internal
        pure
        returns (IbcCoreClientV1Height.Data memory, uint256)
    {
        uint256 pointer = p;
        (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
        pointer += bytesRead;
        (IbcCoreClientV1Height.Data memory r,) = IbcCoreClientV1Height._decode(pointer, bs, sz);
        return (r, sz + bytesRead);
    }

    // Encoder section

    /**
     * @dev The main encoder for memory
     * @param r The struct to be encoded
     * @return The encoded byte array
     */
    function encode(Data memory r) internal pure returns (bytes memory) {
        bytes memory bs = new bytes(_estimate(r));
        uint256 sz = _encode(r, 32, bs);
        assembly {
            mstore(bs, sz)
        }
        return bs;
    }

    // inner encoder

    /**
     * @dev The encoder for internal usage
     * @param r The struct to be encoded
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @return The number of bytes encoded
     */
    function _encode(Data memory r, uint256 p, bytes memory bs) internal pure returns (uint256) {
        uint256 offset = p;
        uint256 pointer = p;
        uint256 i;
        if (r.id.length != 0) {
            pointer += ProtoBufRuntime._encode_key(1, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
            pointer += ProtoBufRuntime._encode_bytes(r.id, pointer, bs);
        }
        if (uint256(r.commit_protocol) != 0) {
            pointer += ProtoBufRuntime._encode_key(2, ProtoBufRuntime.WireType.Varint, pointer, bs);
            int32 _enum_commit_protocol = encode_CommitProtocol(r.commit_protocol);
            pointer += ProtoBufRuntime._encode_enum(_enum_commit_protocol, pointer, bs);
        }
        if (r.contract_transactions.length != 0) {
            for (i = 0; i < r.contract_transactions.length; i++) {
                pointer += ProtoBufRuntime._encode_key(3, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
                pointer += ResolvedContractTransaction._encode_nested(r.contract_transactions[i], pointer, bs);
            }
        }

        pointer += ProtoBufRuntime._encode_key(4, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
        pointer += IbcCoreClientV1Height._encode_nested(r.timeout_height, pointer, bs);

        if (r.timeout_timestamp != 0) {
            pointer += ProtoBufRuntime._encode_key(5, ProtoBufRuntime.WireType.Varint, pointer, bs);
            pointer += ProtoBufRuntime._encode_uint64(r.timeout_timestamp, pointer, bs);
        }
        return pointer - offset;
    }

    // nested encoder

    /**
     * @dev The encoder for inner struct
     * @param r The struct to be encoded
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @return The number of bytes encoded
     */
    function _encode_nested(Data memory r, uint256 p, bytes memory bs) internal pure returns (uint256) {
        /**
         * First encoded `r` into a temporary array, and encode the actual size used.
         * Then copy the temporary array into `bs`.
         */
        uint256 offset = p;
        uint256 pointer = p;
        bytes memory tmp = new bytes(_estimate(r));
        uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
        uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
        uint256 size = _encode(r, 32, tmp);
        pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
        ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
        pointer += size;
        delete tmp;
        return pointer - offset;
    }

    // estimator

    /**
     * @dev The estimator for a struct
     * @param r The struct to be encoded
     * @return The number of bytes encoded in estimation
     */
    function _estimate(Data memory r) internal pure returns (uint256) {
        uint256 e;
        uint256 i;
        e += 1 + ProtoBufRuntime._sz_lendelim(r.id.length);
        e += 1 + ProtoBufRuntime._sz_enum(encode_CommitProtocol(r.commit_protocol));
        for (i = 0; i < r.contract_transactions.length; i++) {
            e += 1 + ProtoBufRuntime._sz_lendelim(ResolvedContractTransaction._estimate(r.contract_transactions[i]));
        }
        e += 1 + ProtoBufRuntime._sz_lendelim(IbcCoreClientV1Height._estimate(r.timeout_height));
        e += 1 + ProtoBufRuntime._sz_uint64(r.timeout_timestamp);
        return e;
    }
    // empty checker

    function _empty(Data memory r) internal pure returns (bool) {
        if (r.id.length != 0) {
            return false;
        }

        if (uint256(r.commit_protocol) != 0) {
            return false;
        }

        if (r.contract_transactions.length != 0) {
            return false;
        }

        if (r.timeout_timestamp != 0) {
            return false;
        }

        return true;
    }

    //store function
    /**
     * @dev Store in-memory struct to storage
     * @param input The in-memory struct
     * @param output The in-storage struct
     */
    function store(Data memory input, Data storage output) internal {
        output.id = input.id;
        output.commit_protocol = input.commit_protocol;

        for (uint256 i3 = 0; i3 < input.contract_transactions.length; i3++) {
            output.contract_transactions.push(input.contract_transactions[i3]);
        }

        IbcCoreClientV1Height.store(input.timeout_height, output.timeout_height);
        output.timeout_timestamp = input.timeout_timestamp;
    }

    //array helpers for ContractTransactions
    /**
     * @dev Add value to an array
     * @param self The in-memory struct
     * @param value The value to add
     */
    function addContractTransactions(Data memory self, ResolvedContractTransaction.Data memory value) internal pure {
        /**
         * First resize the array. Then add the new element to the end.
         */
        ResolvedContractTransaction.Data[] memory tmp =
            new ResolvedContractTransaction.Data[](self.contract_transactions.length + 1);
        for (uint256 i = 0; i < self.contract_transactions.length; i++) {
            tmp[i] = self.contract_transactions[i];
        }
        tmp[self.contract_transactions.length] = value;
        self.contract_transactions = tmp;
    }

    //utility functions
    /**
     * @dev Return an empty struct
     * @return r The empty struct
     */
    function nil() internal pure returns (Data memory r) {
        assembly {
            r := 0
        }
    }

    /**
     * @dev Test whether a struct is empty
     * @param x The struct to be tested
     * @return r True if it is empty
     */
    function isNil(Data memory x) internal pure returns (bool r) {
        assembly {
            r := iszero(x)
        }
    }
}
//library Tx

library ResolvedContractTransaction {
    //struct definition
    struct Data {
        GoogleProtobufAny.Data cross_chain_channel;
        Account.Data[] signers;
        bytes call_info;
        ReturnValue.Data return_value;
        GoogleProtobufAny.Data[] call_results;
    }

    // Decoder section

    /**
     * @dev The main decoder for memory
     * @param bs The bytes array to be decoded
     * @return The decoded struct
     */
    function decode(bytes memory bs) internal pure returns (Data memory) {
        (Data memory x,) = _decode(32, bs, bs.length);
        return x;
    }

    /**
     * @dev The main decoder for storage
     * @param self The in-storage struct
     * @param bs The bytes array to be decoded
     */
    function decode(Data storage self, bytes memory bs) internal {
        (Data memory x,) = _decode(32, bs, bs.length);
        store(x, self);
    }

    // inner decoder

    /**
     * @dev The decoder for internal usage
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @param sz The number of bytes expected
     * @return The decoded struct
     * @return The number of bytes decoded
     */
    function _decode(uint256 p, bytes memory bs, uint256 sz) internal pure returns (Data memory, uint256) {
        Data memory r;
        uint256[6] memory counters;
        uint256 fieldId;
        ProtoBufRuntime.WireType wireType;
        uint256 bytesRead;
        uint256 offset = p;
        uint256 pointer = p;
        while (pointer < offset + sz) {
            (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
            pointer += bytesRead;
            if (fieldId == 1) {
                pointer += _read_cross_chain_channel(pointer, bs, r);
            } else if (fieldId == 2) {
                pointer += _read_unpacked_repeated_signers(pointer, bs, nil(), counters);
            } else if (fieldId == 3) {
                pointer += _read_call_info(pointer, bs, r);
            } else if (fieldId == 4) {
                pointer += _read_return_value(pointer, bs, r);
            } else if (fieldId == 5) {
                pointer += _read_unpacked_repeated_call_results(pointer, bs, nil(), counters);
            } else {
                pointer += ProtoBufRuntime._skip_field_decode(wireType, pointer, bs);
            }
        }
        pointer = offset;
        if (counters[2] > 0) {
            require(r.signers.length == 0);
            r.signers = new Account.Data[](counters[2]);
        }
        if (counters[5] > 0) {
            require(r.call_results.length == 0);
            r.call_results = new GoogleProtobufAny.Data[](counters[5]);
        }

        while (pointer < offset + sz) {
            (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
            pointer += bytesRead;
            if (fieldId == 2) {
                pointer += _read_unpacked_repeated_signers(pointer, bs, r, counters);
            } else if (fieldId == 5) {
                pointer += _read_unpacked_repeated_call_results(pointer, bs, r, counters);
            } else {
                pointer += ProtoBufRuntime._skip_field_decode(wireType, pointer, bs);
            }
        }
        return (r, sz);
    }

    // field readers

    /**
     * @dev The decoder for reading a field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @param r The in-memory struct
     * @return The number of bytes decoded
     */
    function _read_cross_chain_channel(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (GoogleProtobufAny.Data memory x, uint256 sz) = _decode_GoogleProtobufAny(p, bs);
        r.cross_chain_channel = x;
        return sz;
    }

    /**
     * @dev The decoder for reading a field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @param r The in-memory struct
     * @param counters The counters for repeated fields
     * @return The number of bytes decoded
     */
    function _read_unpacked_repeated_signers(uint256 p, bytes memory bs, Data memory r, uint256[6] memory counters)
        internal
        pure
        returns (uint256)
    {
        /**
         * if `r` is NULL, then only counting the number of fields.
         */
        (Account.Data memory x, uint256 sz) = _decode_Account(p, bs);
        if (isNil(r)) {
            counters[2] += 1;
        } else {
            r.signers[r.signers.length - counters[2]] = x;
            counters[2] -= 1;
        }
        return sz;
    }

    /**
     * @dev The decoder for reading a field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @param r The in-memory struct
     * @return The number of bytes decoded
     */
    function _read_call_info(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (bytes memory x, uint256 sz) = ProtoBufRuntime._decode_bytes(p, bs);
        r.call_info = x;
        return sz;
    }

    /**
     * @dev The decoder for reading a field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @param r The in-memory struct
     * @return The number of bytes decoded
     */
    function _read_return_value(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (ReturnValue.Data memory x, uint256 sz) = _decode_ReturnValue(p, bs);
        r.return_value = x;
        return sz;
    }

    /**
     * @dev The decoder for reading a field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @param r The in-memory struct
     * @param counters The counters for repeated fields
     * @return The number of bytes decoded
     */
    function _read_unpacked_repeated_call_results(uint256 p, bytes memory bs, Data memory r, uint256[6] memory counters)
        internal
        pure
        returns (uint256)
    {
        /**
         * if `r` is NULL, then only counting the number of fields.
         */
        (GoogleProtobufAny.Data memory x, uint256 sz) = _decode_GoogleProtobufAny(p, bs);
        if (isNil(r)) {
            counters[5] += 1;
        } else {
            r.call_results[r.call_results.length - counters[5]] = x;
            counters[5] -= 1;
        }
        return sz;
    }

    // struct decoder
    /**
     * @dev The decoder for reading a inner struct field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @return The decoded inner-struct
     * @return The number of bytes used to decode
     */
    function _decode_GoogleProtobufAny(uint256 p, bytes memory bs)
        internal
        pure
        returns (GoogleProtobufAny.Data memory, uint256)
    {
        uint256 pointer = p;
        (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
        pointer += bytesRead;
        (GoogleProtobufAny.Data memory r,) = GoogleProtobufAny._decode(pointer, bs, sz);
        return (r, sz + bytesRead);
    }

    /**
     * @dev The decoder for reading a inner struct field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @return The decoded inner-struct
     * @return The number of bytes used to decode
     */
    function _decode_Account(uint256 p, bytes memory bs) internal pure returns (Account.Data memory, uint256) {
        uint256 pointer = p;
        (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
        pointer += bytesRead;
        (Account.Data memory r,) = Account._decode(pointer, bs, sz);
        return (r, sz + bytesRead);
    }

    /**
     * @dev The decoder for reading a inner struct field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @return The decoded inner-struct
     * @return The number of bytes used to decode
     */
    function _decode_ReturnValue(uint256 p, bytes memory bs) internal pure returns (ReturnValue.Data memory, uint256) {
        uint256 pointer = p;
        (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
        pointer += bytesRead;
        (ReturnValue.Data memory r,) = ReturnValue._decode(pointer, bs, sz);
        return (r, sz + bytesRead);
    }

    // Encoder section

    /**
     * @dev The main encoder for memory
     * @param r The struct to be encoded
     * @return The encoded byte array
     */
    function encode(Data memory r) internal pure returns (bytes memory) {
        bytes memory bs = new bytes(_estimate(r));
        uint256 sz = _encode(r, 32, bs);
        assembly {
            mstore(bs, sz)
        }
        return bs;
    }

    // inner encoder

    /**
     * @dev The encoder for internal usage
     * @param r The struct to be encoded
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @return The number of bytes encoded
     */
    function _encode(Data memory r, uint256 p, bytes memory bs) internal pure returns (uint256) {
        uint256 offset = p;
        uint256 pointer = p;
        uint256 i;

        pointer += ProtoBufRuntime._encode_key(1, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
        pointer += GoogleProtobufAny._encode_nested(r.cross_chain_channel, pointer, bs);

        if (r.signers.length != 0) {
            for (i = 0; i < r.signers.length; i++) {
                pointer += ProtoBufRuntime._encode_key(2, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
                pointer += Account._encode_nested(r.signers[i], pointer, bs);
            }
        }
        if (r.call_info.length != 0) {
            pointer += ProtoBufRuntime._encode_key(3, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
            pointer += ProtoBufRuntime._encode_bytes(r.call_info, pointer, bs);
        }

        pointer += ProtoBufRuntime._encode_key(4, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
        pointer += ReturnValue._encode_nested(r.return_value, pointer, bs);

        if (r.call_results.length != 0) {
            for (i = 0; i < r.call_results.length; i++) {
                pointer += ProtoBufRuntime._encode_key(5, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
                pointer += GoogleProtobufAny._encode_nested(r.call_results[i], pointer, bs);
            }
        }
        return pointer - offset;
    }

    // nested encoder

    /**
     * @dev The encoder for inner struct
     * @param r The struct to be encoded
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @return The number of bytes encoded
     */
    function _encode_nested(Data memory r, uint256 p, bytes memory bs) internal pure returns (uint256) {
        /**
         * First encoded `r` into a temporary array, and encode the actual size used.
         * Then copy the temporary array into `bs`.
         */
        uint256 offset = p;
        uint256 pointer = p;
        bytes memory tmp = new bytes(_estimate(r));
        uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
        uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
        uint256 size = _encode(r, 32, tmp);
        pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
        ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
        pointer += size;
        delete tmp;
        return pointer - offset;
    }

    // estimator

    /**
     * @dev The estimator for a struct
     * @param r The struct to be encoded
     * @return The number of bytes encoded in estimation
     */
    function _estimate(Data memory r) internal pure returns (uint256) {
        uint256 e;
        uint256 i;
        e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufAny._estimate(r.cross_chain_channel));
        for (i = 0; i < r.signers.length; i++) {
            e += 1 + ProtoBufRuntime._sz_lendelim(Account._estimate(r.signers[i]));
        }
        e += 1 + ProtoBufRuntime._sz_lendelim(r.call_info.length);
        e += 1 + ProtoBufRuntime._sz_lendelim(ReturnValue._estimate(r.return_value));
        for (i = 0; i < r.call_results.length; i++) {
            e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufAny._estimate(r.call_results[i]));
        }
        return e;
    }
    // empty checker

    function _empty(Data memory r) internal pure returns (bool) {
        if (r.signers.length != 0) {
            return false;
        }

        if (r.call_info.length != 0) {
            return false;
        }

        if (r.call_results.length != 0) {
            return false;
        }

        return true;
    }

    //store function
    /**
     * @dev Store in-memory struct to storage
     * @param input The in-memory struct
     * @param output The in-storage struct
     */
    function store(Data memory input, Data storage output) internal {
        GoogleProtobufAny.store(input.cross_chain_channel, output.cross_chain_channel);

        for (uint256 i2 = 0; i2 < input.signers.length; i2++) {
            output.signers.push(input.signers[i2]);
        }

        output.call_info = input.call_info;
        ReturnValue.store(input.return_value, output.return_value);

        for (uint256 i5 = 0; i5 < input.call_results.length; i5++) {
            output.call_results.push(input.call_results[i5]);
        }
    }

    //array helpers for Signers
    /**
     * @dev Add value to an array
     * @param self The in-memory struct
     * @param value The value to add
     */
    function addSigners(Data memory self, Account.Data memory value) internal pure {
        /**
         * First resize the array. Then add the new element to the end.
         */
        Account.Data[] memory tmp = new Account.Data[](self.signers.length + 1);
        for (uint256 i = 0; i < self.signers.length; i++) {
            tmp[i] = self.signers[i];
        }
        tmp[self.signers.length] = value;
        self.signers = tmp;
    }

    //array helpers for CallResults
    /**
     * @dev Add value to an array
     * @param self The in-memory struct
     * @param value The value to add
     */
    function addCallResults(Data memory self, GoogleProtobufAny.Data memory value) internal pure {
        /**
         * First resize the array. Then add the new element to the end.
         */
        GoogleProtobufAny.Data[] memory tmp = new GoogleProtobufAny.Data[](self.call_results.length + 1);
        for (uint256 i = 0; i < self.call_results.length; i++) {
            tmp[i] = self.call_results[i];
        }
        tmp[self.call_results.length] = value;
        self.call_results = tmp;
    }

    //utility functions
    /**
     * @dev Return an empty struct
     * @return r The empty struct
     */
    function nil() internal pure returns (Data memory r) {
        assembly {
            r := 0
        }
    }

    /**
     * @dev Test whether a struct is empty
     * @param x The struct to be tested
     * @return r True if it is empty
     */
    function isNil(Data memory x) internal pure returns (bool r) {
        assembly {
            r := iszero(x)
        }
    }
}
//library ResolvedContractTransaction

library ReturnValue {
    //struct definition
    struct Data {
        bytes value;
    }

    // Decoder section

    /**
     * @dev The main decoder for memory
     * @param bs The bytes array to be decoded
     * @return The decoded struct
     */
    function decode(bytes memory bs) internal pure returns (Data memory) {
        (Data memory x,) = _decode(32, bs, bs.length);
        return x;
    }

    /**
     * @dev The main decoder for storage
     * @param self The in-storage struct
     * @param bs The bytes array to be decoded
     */
    function decode(Data storage self, bytes memory bs) internal {
        (Data memory x,) = _decode(32, bs, bs.length);
        store(x, self);
    }

    // inner decoder

    /**
     * @dev The decoder for internal usage
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @param sz The number of bytes expected
     * @return The decoded struct
     * @return The number of bytes decoded
     */
    function _decode(uint256 p, bytes memory bs, uint256 sz) internal pure returns (Data memory, uint256) {
        Data memory r;
        uint256 fieldId;
        ProtoBufRuntime.WireType wireType;
        uint256 bytesRead;
        uint256 offset = p;
        uint256 pointer = p;
        while (pointer < offset + sz) {
            (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
            pointer += bytesRead;
            if (fieldId == 1) {
                pointer += _read_value(pointer, bs, r);
            } else {
                pointer += ProtoBufRuntime._skip_field_decode(wireType, pointer, bs);
            }
        }
        return (r, sz);
    }

    // field readers

    /**
     * @dev The decoder for reading a field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @param r The in-memory struct
     * @return The number of bytes decoded
     */
    function _read_value(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (bytes memory x, uint256 sz) = ProtoBufRuntime._decode_bytes(p, bs);
        r.value = x;
        return sz;
    }

    // Encoder section

    /**
     * @dev The main encoder for memory
     * @param r The struct to be encoded
     * @return The encoded byte array
     */
    function encode(Data memory r) internal pure returns (bytes memory) {
        bytes memory bs = new bytes(_estimate(r));
        uint256 sz = _encode(r, 32, bs);
        assembly {
            mstore(bs, sz)
        }
        return bs;
    }

    // inner encoder

    /**
     * @dev The encoder for internal usage
     * @param r The struct to be encoded
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @return The number of bytes encoded
     */
    function _encode(Data memory r, uint256 p, bytes memory bs) internal pure returns (uint256) {
        uint256 offset = p;
        uint256 pointer = p;

        if (r.value.length != 0) {
            pointer += ProtoBufRuntime._encode_key(1, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
            pointer += ProtoBufRuntime._encode_bytes(r.value, pointer, bs);
        }
        return pointer - offset;
    }

    // nested encoder

    /**
     * @dev The encoder for inner struct
     * @param r The struct to be encoded
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @return The number of bytes encoded
     */
    function _encode_nested(Data memory r, uint256 p, bytes memory bs) internal pure returns (uint256) {
        /**
         * First encoded `r` into a temporary array, and encode the actual size used.
         * Then copy the temporary array into `bs`.
         */
        uint256 offset = p;
        uint256 pointer = p;
        bytes memory tmp = new bytes(_estimate(r));
        uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
        uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
        uint256 size = _encode(r, 32, tmp);
        pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
        ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
        pointer += size;
        delete tmp;
        return pointer - offset;
    }

    // estimator

    /**
     * @dev The estimator for a struct
     * @param r The struct to be encoded
     * @return The number of bytes encoded in estimation
     */
    function _estimate(Data memory r) internal pure returns (uint256) {
        uint256 e;
        e += 1 + ProtoBufRuntime._sz_lendelim(r.value.length);
        return e;
    }
    // empty checker

    function _empty(Data memory r) internal pure returns (bool) {
        if (r.value.length != 0) {
            return false;
        }

        return true;
    }

    //store function
    /**
     * @dev Store in-memory struct to storage
     * @param input The in-memory struct
     * @param output The in-storage struct
     */
    function store(Data memory input, Data storage output) internal {
        output.value = input.value;
    }

    //utility functions
    /**
     * @dev Return an empty struct
     * @return r The empty struct
     */
    function nil() internal pure returns (Data memory r) {
        assembly {
            r := 0
        }
    }

    /**
     * @dev Test whether a struct is empty
     * @param x The struct to be tested
     * @return r True if it is empty
     */
    function isNil(Data memory x) internal pure returns (bool r) {
        assembly {
            r := iszero(x)
        }
    }
}
//library ReturnValue

library ConstantValueCallResult {
    //struct definition
    struct Data {
        GoogleProtobufAny.Data cross_chain_channel;
        bytes k;
        bytes v;
    }

    // Decoder section

    /**
     * @dev The main decoder for memory
     * @param bs The bytes array to be decoded
     * @return The decoded struct
     */
    function decode(bytes memory bs) internal pure returns (Data memory) {
        (Data memory x,) = _decode(32, bs, bs.length);
        return x;
    }

    /**
     * @dev The main decoder for storage
     * @param self The in-storage struct
     * @param bs The bytes array to be decoded
     */
    function decode(Data storage self, bytes memory bs) internal {
        (Data memory x,) = _decode(32, bs, bs.length);
        store(x, self);
    }

    // inner decoder

    /**
     * @dev The decoder for internal usage
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @param sz The number of bytes expected
     * @return The decoded struct
     * @return The number of bytes decoded
     */
    function _decode(uint256 p, bytes memory bs, uint256 sz) internal pure returns (Data memory, uint256) {
        Data memory r;
        uint256 fieldId;
        ProtoBufRuntime.WireType wireType;
        uint256 bytesRead;
        uint256 offset = p;
        uint256 pointer = p;
        while (pointer < offset + sz) {
            (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
            pointer += bytesRead;
            if (fieldId == 1) {
                pointer += _read_cross_chain_channel(pointer, bs, r);
            } else if (fieldId == 2) {
                pointer += _read_k(pointer, bs, r);
            } else if (fieldId == 3) {
                pointer += _read_v(pointer, bs, r);
            } else {
                pointer += ProtoBufRuntime._skip_field_decode(wireType, pointer, bs);
            }
        }
        return (r, sz);
    }

    // field readers

    /**
     * @dev The decoder for reading a field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @param r The in-memory struct
     * @return The number of bytes decoded
     */
    function _read_cross_chain_channel(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (GoogleProtobufAny.Data memory x, uint256 sz) = _decode_GoogleProtobufAny(p, bs);
        r.cross_chain_channel = x;
        return sz;
    }

    /**
     * @dev The decoder for reading a field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @param r The in-memory struct
     * @return The number of bytes decoded
     */
    function _read_k(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (bytes memory x, uint256 sz) = ProtoBufRuntime._decode_bytes(p, bs);
        r.k = x;
        return sz;
    }

    /**
     * @dev The decoder for reading a field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @param r The in-memory struct
     * @return The number of bytes decoded
     */
    function _read_v(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (bytes memory x, uint256 sz) = ProtoBufRuntime._decode_bytes(p, bs);
        r.v = x;
        return sz;
    }

    // struct decoder
    /**
     * @dev The decoder for reading a inner struct field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @return The decoded inner-struct
     * @return The number of bytes used to decode
     */
    function _decode_GoogleProtobufAny(uint256 p, bytes memory bs)
        internal
        pure
        returns (GoogleProtobufAny.Data memory, uint256)
    {
        uint256 pointer = p;
        (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
        pointer += bytesRead;
        (GoogleProtobufAny.Data memory r,) = GoogleProtobufAny._decode(pointer, bs, sz);
        return (r, sz + bytesRead);
    }

    // Encoder section

    /**
     * @dev The main encoder for memory
     * @param r The struct to be encoded
     * @return The encoded byte array
     */
    function encode(Data memory r) internal pure returns (bytes memory) {
        bytes memory bs = new bytes(_estimate(r));
        uint256 sz = _encode(r, 32, bs);
        assembly {
            mstore(bs, sz)
        }
        return bs;
    }

    // inner encoder

    /**
     * @dev The encoder for internal usage
     * @param r The struct to be encoded
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @return The number of bytes encoded
     */
    function _encode(Data memory r, uint256 p, bytes memory bs) internal pure returns (uint256) {
        uint256 offset = p;
        uint256 pointer = p;

        pointer += ProtoBufRuntime._encode_key(1, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
        pointer += GoogleProtobufAny._encode_nested(r.cross_chain_channel, pointer, bs);

        if (r.k.length != 0) {
            pointer += ProtoBufRuntime._encode_key(2, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
            pointer += ProtoBufRuntime._encode_bytes(r.k, pointer, bs);
        }
        if (r.v.length != 0) {
            pointer += ProtoBufRuntime._encode_key(3, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
            pointer += ProtoBufRuntime._encode_bytes(r.v, pointer, bs);
        }
        return pointer - offset;
    }

    // nested encoder

    /**
     * @dev The encoder for inner struct
     * @param r The struct to be encoded
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @return The number of bytes encoded
     */
    function _encode_nested(Data memory r, uint256 p, bytes memory bs) internal pure returns (uint256) {
        /**
         * First encoded `r` into a temporary array, and encode the actual size used.
         * Then copy the temporary array into `bs`.
         */
        uint256 offset = p;
        uint256 pointer = p;
        bytes memory tmp = new bytes(_estimate(r));
        uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
        uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
        uint256 size = _encode(r, 32, tmp);
        pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
        ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
        pointer += size;
        delete tmp;
        return pointer - offset;
    }

    // estimator

    /**
     * @dev The estimator for a struct
     * @param r The struct to be encoded
     * @return The number of bytes encoded in estimation
     */
    function _estimate(Data memory r) internal pure returns (uint256) {
        uint256 e;
        e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufAny._estimate(r.cross_chain_channel));
        e += 1 + ProtoBufRuntime._sz_lendelim(r.k.length);
        e += 1 + ProtoBufRuntime._sz_lendelim(r.v.length);
        return e;
    }
    // empty checker

    function _empty(Data memory r) internal pure returns (bool) {
        if (r.k.length != 0) {
            return false;
        }

        if (r.v.length != 0) {
            return false;
        }

        return true;
    }

    //store function
    /**
     * @dev Store in-memory struct to storage
     * @param input The in-memory struct
     * @param output The in-storage struct
     */
    function store(Data memory input, Data storage output) internal {
        GoogleProtobufAny.store(input.cross_chain_channel, output.cross_chain_channel);
        output.k = input.k;
        output.v = input.v;
    }

    //utility functions
    /**
     * @dev Return an empty struct
     * @return r The empty struct
     */
    function nil() internal pure returns (Data memory r) {
        assembly {
            r := 0
        }
    }

    /**
     * @dev Test whether a struct is empty
     * @param x The struct to be tested
     * @return r True if it is empty
     */
    function isNil(Data memory x) internal pure returns (bool r) {
        assembly {
            r := iszero(x)
        }
    }
}
//library ConstantValueCallResult

library ContractCallResult {
    //struct definition
    struct Data {
        bytes data;
        GoogleProtobufAny.Data[] events;
    }

    // Decoder section

    /**
     * @dev The main decoder for memory
     * @param bs The bytes array to be decoded
     * @return The decoded struct
     */
    function decode(bytes memory bs) internal pure returns (Data memory) {
        (Data memory x,) = _decode(32, bs, bs.length);
        return x;
    }

    /**
     * @dev The main decoder for storage
     * @param self The in-storage struct
     * @param bs The bytes array to be decoded
     */
    function decode(Data storage self, bytes memory bs) internal {
        (Data memory x,) = _decode(32, bs, bs.length);
        store(x, self);
    }

    // inner decoder

    /**
     * @dev The decoder for internal usage
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @param sz The number of bytes expected
     * @return The decoded struct
     * @return The number of bytes decoded
     */
    function _decode(uint256 p, bytes memory bs, uint256 sz) internal pure returns (Data memory, uint256) {
        Data memory r;
        uint256[3] memory counters;
        uint256 fieldId;
        ProtoBufRuntime.WireType wireType;
        uint256 bytesRead;
        uint256 offset = p;
        uint256 pointer = p;
        while (pointer < offset + sz) {
            (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
            pointer += bytesRead;
            if (fieldId == 1) {
                pointer += _read_data(pointer, bs, r);
            } else if (fieldId == 2) {
                pointer += _read_unpacked_repeated_events(pointer, bs, nil(), counters);
            } else {
                pointer += ProtoBufRuntime._skip_field_decode(wireType, pointer, bs);
            }
        }
        pointer = offset;
        if (counters[2] > 0) {
            require(r.events.length == 0);
            r.events = new GoogleProtobufAny.Data[](counters[2]);
        }

        while (pointer < offset + sz) {
            (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
            pointer += bytesRead;
            if (fieldId == 2) {
                pointer += _read_unpacked_repeated_events(pointer, bs, r, counters);
            } else {
                pointer += ProtoBufRuntime._skip_field_decode(wireType, pointer, bs);
            }
        }
        return (r, sz);
    }

    // field readers

    /**
     * @dev The decoder for reading a field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @param r The in-memory struct
     * @return The number of bytes decoded
     */
    function _read_data(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (bytes memory x, uint256 sz) = ProtoBufRuntime._decode_bytes(p, bs);
        r.data = x;
        return sz;
    }

    /**
     * @dev The decoder for reading a field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @param r The in-memory struct
     * @param counters The counters for repeated fields
     * @return The number of bytes decoded
     */
    function _read_unpacked_repeated_events(uint256 p, bytes memory bs, Data memory r, uint256[3] memory counters)
        internal
        pure
        returns (uint256)
    {
        /**
         * if `r` is NULL, then only counting the number of fields.
         */
        (GoogleProtobufAny.Data memory x, uint256 sz) = _decode_GoogleProtobufAny(p, bs);
        if (isNil(r)) {
            counters[2] += 1;
        } else {
            r.events[r.events.length - counters[2]] = x;
            counters[2] -= 1;
        }
        return sz;
    }

    // struct decoder
    /**
     * @dev The decoder for reading a inner struct field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @return The decoded inner-struct
     * @return The number of bytes used to decode
     */
    function _decode_GoogleProtobufAny(uint256 p, bytes memory bs)
        internal
        pure
        returns (GoogleProtobufAny.Data memory, uint256)
    {
        uint256 pointer = p;
        (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
        pointer += bytesRead;
        (GoogleProtobufAny.Data memory r,) = GoogleProtobufAny._decode(pointer, bs, sz);
        return (r, sz + bytesRead);
    }

    // Encoder section

    /**
     * @dev The main encoder for memory
     * @param r The struct to be encoded
     * @return The encoded byte array
     */
    function encode(Data memory r) internal pure returns (bytes memory) {
        bytes memory bs = new bytes(_estimate(r));
        uint256 sz = _encode(r, 32, bs);
        assembly {
            mstore(bs, sz)
        }
        return bs;
    }

    // inner encoder

    /**
     * @dev The encoder for internal usage
     * @param r The struct to be encoded
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @return The number of bytes encoded
     */
    function _encode(Data memory r, uint256 p, bytes memory bs) internal pure returns (uint256) {
        uint256 offset = p;
        uint256 pointer = p;
        uint256 i;
        if (r.data.length != 0) {
            pointer += ProtoBufRuntime._encode_key(1, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
            pointer += ProtoBufRuntime._encode_bytes(r.data, pointer, bs);
        }
        if (r.events.length != 0) {
            for (i = 0; i < r.events.length; i++) {
                pointer += ProtoBufRuntime._encode_key(2, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
                pointer += GoogleProtobufAny._encode_nested(r.events[i], pointer, bs);
            }
        }
        return pointer - offset;
    }

    // nested encoder

    /**
     * @dev The encoder for inner struct
     * @param r The struct to be encoded
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @return The number of bytes encoded
     */
    function _encode_nested(Data memory r, uint256 p, bytes memory bs) internal pure returns (uint256) {
        /**
         * First encoded `r` into a temporary array, and encode the actual size used.
         * Then copy the temporary array into `bs`.
         */
        uint256 offset = p;
        uint256 pointer = p;
        bytes memory tmp = new bytes(_estimate(r));
        uint256 tmpAddr = ProtoBufRuntime.getMemoryAddress(tmp);
        uint256 bsAddr = ProtoBufRuntime.getMemoryAddress(bs);
        uint256 size = _encode(r, 32, tmp);
        pointer += ProtoBufRuntime._encode_varint(size, pointer, bs);
        ProtoBufRuntime.copyBytes(tmpAddr + 32, bsAddr + pointer, size);
        pointer += size;
        delete tmp;
        return pointer - offset;
    }

    // estimator

    /**
     * @dev The estimator for a struct
     * @param r The struct to be encoded
     * @return The number of bytes encoded in estimation
     */
    function _estimate(Data memory r) internal pure returns (uint256) {
        uint256 e;
        uint256 i;
        e += 1 + ProtoBufRuntime._sz_lendelim(r.data.length);
        for (i = 0; i < r.events.length; i++) {
            e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufAny._estimate(r.events[i]));
        }
        return e;
    }
    // empty checker

    function _empty(Data memory r) internal pure returns (bool) {
        if (r.data.length != 0) {
            return false;
        }

        if (r.events.length != 0) {
            return false;
        }

        return true;
    }

    //store function
    /**
     * @dev Store in-memory struct to storage
     * @param input The in-memory struct
     * @param output The in-storage struct
     */
    function store(Data memory input, Data storage output) internal {
        output.data = input.data;

        for (uint256 i2 = 0; i2 < input.events.length; i2++) {
            output.events.push(input.events[i2]);
        }
    }

    //array helpers for Events
    /**
     * @dev Add value to an array
     * @param self The in-memory struct
     * @param value The value to add
     */
    function addEvents(Data memory self, GoogleProtobufAny.Data memory value) internal pure {
        /**
         * First resize the array. Then add the new element to the end.
         */
        GoogleProtobufAny.Data[] memory tmp = new GoogleProtobufAny.Data[](self.events.length + 1);
        for (uint256 i = 0; i < self.events.length; i++) {
            tmp[i] = self.events[i];
        }
        tmp[self.events.length] = value;
        self.events = tmp;
    }

    //utility functions
    /**
     * @dev Return an empty struct
     * @return r The empty struct
     */
    function nil() internal pure returns (Data memory r) {
        assembly {
            r := 0
        }
    }

    /**
     * @dev Test whether a struct is empty
     * @param x The struct to be tested
     * @return r True if it is empty
     */
    function isNil(Data memory x) internal pure returns (bool r) {
        assembly {
            r := iszero(x)
        }
    }
}
//library ContractCallResult
