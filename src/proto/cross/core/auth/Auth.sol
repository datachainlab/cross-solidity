// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;
import "@hyperledger-labs/yui-ibc-solidity/contracts/proto/ProtoBufRuntime.sol";
import "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";
import "../../../ibc/core/client/v1/client.sol";

library MsgSignTx {
    //struct definition
    struct Data {
        bytes txID;
        bytes[] signers;
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
        uint256[5] memory counters;
        uint256 fieldId;
        ProtoBufRuntime.WireType wireType;
        uint256 bytesRead;
        uint256 offset = p;
        uint256 pointer = p;
        while (pointer < offset + sz) {
            (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
            pointer += bytesRead;
            if (fieldId == 1) {
                pointer += _read_txID(pointer, bs, r);
            } else if (fieldId == 2) {
                pointer += _read_unpacked_repeated_signers(pointer, bs, nil(), counters);
            } else if (fieldId == 3) {
                pointer += _read_timeout_height(pointer, bs, r);
            } else if (fieldId == 4) {
                pointer += _read_timeout_timestamp(pointer, bs, r);
            } else {
                pointer += ProtoBufRuntime._skip_field_decode(wireType, pointer, bs);
            }
        }
        pointer = offset;
        if (counters[2] > 0) {
            require(r.signers.length == 0);
            r.signers = new bytes[](counters[2]);
        }

        while (pointer < offset + sz) {
            (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
            pointer += bytesRead;
            if (fieldId == 2) {
                pointer += _read_unpacked_repeated_signers(pointer, bs, r, counters);
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
    function _read_txID(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (bytes memory x, uint256 sz) = ProtoBufRuntime._decode_bytes(p, bs);
        r.txID = x;
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
    function _read_unpacked_repeated_signers(uint256 p, bytes memory bs, Data memory r, uint256[5] memory counters)
        internal
        pure
        returns (uint256)
    {
        /**
         * if `r` is NULL, then only counting the number of fields.
         */
        (bytes memory x, uint256 sz) = ProtoBufRuntime._decode_bytes(p, bs);
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
        if (r.txID.length != 0) {
            pointer += ProtoBufRuntime._encode_key(1, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
            pointer += ProtoBufRuntime._encode_bytes(r.txID, pointer, bs);
        }
        if (r.signers.length != 0) {
            for (i = 0; i < r.signers.length; i++) {
                pointer += ProtoBufRuntime._encode_key(2, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
                pointer += ProtoBufRuntime._encode_bytes(r.signers[i], pointer, bs);
            }
        }

        pointer += ProtoBufRuntime._encode_key(3, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
        pointer += IbcCoreClientV1Height._encode_nested(r.timeout_height, pointer, bs);

        if (r.timeout_timestamp != 0) {
            pointer += ProtoBufRuntime._encode_key(4, ProtoBufRuntime.WireType.Varint, pointer, bs);
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
        e += 1 + ProtoBufRuntime._sz_lendelim(r.txID.length);
        for (i = 0; i < r.signers.length; i++) {
            e += 1 + ProtoBufRuntime._sz_lendelim(r.signers[i].length);
        }
        e += 1 + ProtoBufRuntime._sz_lendelim(IbcCoreClientV1Height._estimate(r.timeout_height));
        e += 1 + ProtoBufRuntime._sz_uint64(r.timeout_timestamp);
        return e;
    }
    // empty checker

    function _empty(Data memory r) internal pure returns (bool) {
        if (r.txID.length != 0) {
            return false;
        }

        if (r.signers.length != 0) {
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
        output.txID = input.txID;
        output.signers = input.signers;
        IbcCoreClientV1Height.store(input.timeout_height, output.timeout_height);
        output.timeout_timestamp = input.timeout_timestamp;
    }

    //array helpers for Signers
    /**
     * @dev Add value to an array
     * @param self The in-memory struct
     * @param value The value to add
     */
    function addSigners(Data memory self, bytes memory value) internal pure {
        /**
         * First resize the array. Then add the new element to the end.
         */
        bytes[] memory tmp = new bytes[](self.signers.length + 1);
        for (uint256 i = 0; i < self.signers.length; i++) {
            tmp[i] = self.signers[i];
        }
        tmp[self.signers.length] = value;
        self.signers = tmp;
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
//library MsgSignTx

library MsgSignTxResponse {
    //struct definition
    struct Data {
        bool tx_auth_completed;
        string log;
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
                pointer += _read_tx_auth_completed(pointer, bs, r);
            } else if (fieldId == 2) {
                pointer += _read_log(pointer, bs, r);
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
    function _read_tx_auth_completed(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (bool x, uint256 sz) = ProtoBufRuntime._decode_bool(p, bs);
        r.tx_auth_completed = x;
        return sz;
    }

    /**
     * @dev The decoder for reading a field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @param r The in-memory struct
     * @return The number of bytes decoded
     */
    function _read_log(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (string memory x, uint256 sz) = ProtoBufRuntime._decode_string(p, bs);
        r.log = x;
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

        if (r.tx_auth_completed != false) {
            pointer += ProtoBufRuntime._encode_key(1, ProtoBufRuntime.WireType.Varint, pointer, bs);
            pointer += ProtoBufRuntime._encode_bool(r.tx_auth_completed, pointer, bs);
        }
        if (bytes(r.log).length != 0) {
            pointer += ProtoBufRuntime._encode_key(2, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
            pointer += ProtoBufRuntime._encode_string(r.log, pointer, bs);
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
        e += 1 + 1;
        e += 1 + ProtoBufRuntime._sz_lendelim(bytes(r.log).length);
        return e;
    }
    // empty checker

    function _empty(Data memory r) internal pure returns (bool) {
        if (r.tx_auth_completed != false) {
            return false;
        }

        if (bytes(r.log).length != 0) {
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
        output.tx_auth_completed = input.tx_auth_completed;
        output.log = input.log;
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
//library MsgSignTxResponse

library MsgIBCSignTx {
    //struct definition
    struct Data {
        GoogleProtobufAny.Data cross_chain_channel;
        bytes txID;
        bytes[] signers;
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
                pointer += _read_cross_chain_channel(pointer, bs, r);
            } else if (fieldId == 2) {
                pointer += _read_txID(pointer, bs, r);
            } else if (fieldId == 3) {
                pointer += _read_unpacked_repeated_signers(pointer, bs, nil(), counters);
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
            require(r.signers.length == 0);
            r.signers = new bytes[](counters[3]);
        }

        while (pointer < offset + sz) {
            (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
            pointer += bytesRead;
            if (fieldId == 3) {
                pointer += _read_unpacked_repeated_signers(pointer, bs, r, counters);
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
    function _read_txID(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (bytes memory x, uint256 sz) = ProtoBufRuntime._decode_bytes(p, bs);
        r.txID = x;
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
        (bytes memory x, uint256 sz) = ProtoBufRuntime._decode_bytes(p, bs);
        if (isNil(r)) {
            counters[3] += 1;
        } else {
            r.signers[r.signers.length - counters[3]] = x;
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

        pointer += ProtoBufRuntime._encode_key(1, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
        pointer += GoogleProtobufAny._encode_nested(r.cross_chain_channel, pointer, bs);

        if (r.txID.length != 0) {
            pointer += ProtoBufRuntime._encode_key(2, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
            pointer += ProtoBufRuntime._encode_bytes(r.txID, pointer, bs);
        }
        if (r.signers.length != 0) {
            for (i = 0; i < r.signers.length; i++) {
                pointer += ProtoBufRuntime._encode_key(3, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
                pointer += ProtoBufRuntime._encode_bytes(r.signers[i], pointer, bs);
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
        e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufAny._estimate(r.cross_chain_channel));
        e += 1 + ProtoBufRuntime._sz_lendelim(r.txID.length);
        for (i = 0; i < r.signers.length; i++) {
            e += 1 + ProtoBufRuntime._sz_lendelim(r.signers[i].length);
        }
        e += 1 + ProtoBufRuntime._sz_lendelim(IbcCoreClientV1Height._estimate(r.timeout_height));
        e += 1 + ProtoBufRuntime._sz_uint64(r.timeout_timestamp);
        return e;
    }
    // empty checker

    function _empty(Data memory r) internal pure returns (bool) {
        if (r.txID.length != 0) {
            return false;
        }

        if (r.signers.length != 0) {
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
        GoogleProtobufAny.store(input.cross_chain_channel, output.cross_chain_channel);
        output.txID = input.txID;
        output.signers = input.signers;
        IbcCoreClientV1Height.store(input.timeout_height, output.timeout_height);
        output.timeout_timestamp = input.timeout_timestamp;
    }

    //array helpers for Signers
    /**
     * @dev Add value to an array
     * @param self The in-memory struct
     * @param value The value to add
     */
    function addSigners(Data memory self, bytes memory value) internal pure {
        /**
         * First resize the array. Then add the new element to the end.
         */
        bytes[] memory tmp = new bytes[](self.signers.length + 1);
        for (uint256 i = 0; i < self.signers.length; i++) {
            tmp[i] = self.signers[i];
        }
        tmp[self.signers.length] = value;
        self.signers = tmp;
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
//library MsgIBCSignTx

library MsgIBCSignTxResponse {
    //struct definition
    struct Data {
        bool x;
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
        }
        return (r, sz);
    }

    // field readers

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
     * @return The number of bytes encoded in estimation
     */
    function _estimate(
        Data memory /* r */
    )
        internal
        pure
        returns (uint256)
    {
        uint256 e;
        return e;
    }
    // empty checker

    function _empty(Data memory r) internal pure returns (bool) {
        return true;
    }

    //store function
    /**
     * @dev Store in-memory struct to storage
     * @param input The in-memory struct
     * @param output The in-storage struct
     */
    function store(Data memory input, Data storage output) internal {}

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
//library MsgIBCSignTxResponse

library MsgExtSignTx {
    //struct definition
    struct Data {
        bytes txID;
        Account.Data[] signers;
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
                pointer += _read_txID(pointer, bs, r);
            } else if (fieldId == 2) {
                pointer += _read_unpacked_repeated_signers(pointer, bs, nil(), counters);
            } else {
                pointer += ProtoBufRuntime._skip_field_decode(wireType, pointer, bs);
            }
        }
        pointer = offset;
        if (counters[2] > 0) {
            require(r.signers.length == 0);
            r.signers = new Account.Data[](counters[2]);
        }

        while (pointer < offset + sz) {
            (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
            pointer += bytesRead;
            if (fieldId == 2) {
                pointer += _read_unpacked_repeated_signers(pointer, bs, r, counters);
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
    function _read_txID(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (bytes memory x, uint256 sz) = ProtoBufRuntime._decode_bytes(p, bs);
        r.txID = x;
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
    function _read_unpacked_repeated_signers(uint256 p, bytes memory bs, Data memory r, uint256[3] memory counters)
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

    // struct decoder
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
        if (r.txID.length != 0) {
            pointer += ProtoBufRuntime._encode_key(1, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
            pointer += ProtoBufRuntime._encode_bytes(r.txID, pointer, bs);
        }
        if (r.signers.length != 0) {
            for (i = 0; i < r.signers.length; i++) {
                pointer += ProtoBufRuntime._encode_key(2, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
                pointer += Account._encode_nested(r.signers[i], pointer, bs);
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
        e += 1 + ProtoBufRuntime._sz_lendelim(r.txID.length);
        for (i = 0; i < r.signers.length; i++) {
            e += 1 + ProtoBufRuntime._sz_lendelim(Account._estimate(r.signers[i]));
        }
        return e;
    }
    // empty checker

    function _empty(Data memory r) internal pure returns (bool) {
        if (r.txID.length != 0) {
            return false;
        }

        if (r.signers.length != 0) {
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
        output.txID = input.txID;

        for (uint256 i2 = 0; i2 < input.signers.length; i2++) {
            output.signers.push(input.signers[i2]);
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
//library MsgExtSignTx

library MsgExtSignTxResponse {
    //struct definition
    struct Data {
        bool x;
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
        }
        return (r, sz);
    }

    // field readers

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
     * @return The number of bytes encoded in estimation
     */
    function _estimate(
        Data memory /* r */
    )
        internal
        pure
        returns (uint256)
    {
        uint256 e;
        return e;
    }
    // empty checker

    function _empty(Data memory r) internal pure returns (bool) {
        return true;
    }

    //store function
    /**
     * @dev Store in-memory struct to storage
     * @param input The in-memory struct
     * @param output The in-storage struct
     */
    function store(Data memory input, Data storage output) internal {}

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
//library MsgExtSignTxResponse

library PacketDataIBCSignTx {
    //struct definition
    struct Data {
        bytes txID;
        bytes[] signers;
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
        uint256[5] memory counters;
        uint256 fieldId;
        ProtoBufRuntime.WireType wireType;
        uint256 bytesRead;
        uint256 offset = p;
        uint256 pointer = p;
        while (pointer < offset + sz) {
            (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
            pointer += bytesRead;
            if (fieldId == 1) {
                pointer += _read_txID(pointer, bs, r);
            } else if (fieldId == 2) {
                pointer += _read_unpacked_repeated_signers(pointer, bs, nil(), counters);
            } else if (fieldId == 3) {
                pointer += _read_timeout_height(pointer, bs, r);
            } else if (fieldId == 4) {
                pointer += _read_timeout_timestamp(pointer, bs, r);
            } else {
                pointer += ProtoBufRuntime._skip_field_decode(wireType, pointer, bs);
            }
        }
        pointer = offset;
        if (counters[2] > 0) {
            require(r.signers.length == 0);
            r.signers = new bytes[](counters[2]);
        }

        while (pointer < offset + sz) {
            (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
            pointer += bytesRead;
            if (fieldId == 2) {
                pointer += _read_unpacked_repeated_signers(pointer, bs, r, counters);
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
    function _read_txID(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (bytes memory x, uint256 sz) = ProtoBufRuntime._decode_bytes(p, bs);
        r.txID = x;
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
    function _read_unpacked_repeated_signers(uint256 p, bytes memory bs, Data memory r, uint256[5] memory counters)
        internal
        pure
        returns (uint256)
    {
        /**
         * if `r` is NULL, then only counting the number of fields.
         */
        (bytes memory x, uint256 sz) = ProtoBufRuntime._decode_bytes(p, bs);
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
        if (r.txID.length != 0) {
            pointer += ProtoBufRuntime._encode_key(1, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
            pointer += ProtoBufRuntime._encode_bytes(r.txID, pointer, bs);
        }
        if (r.signers.length != 0) {
            for (i = 0; i < r.signers.length; i++) {
                pointer += ProtoBufRuntime._encode_key(2, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
                pointer += ProtoBufRuntime._encode_bytes(r.signers[i], pointer, bs);
            }
        }

        pointer += ProtoBufRuntime._encode_key(3, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
        pointer += IbcCoreClientV1Height._encode_nested(r.timeout_height, pointer, bs);

        if (r.timeout_timestamp != 0) {
            pointer += ProtoBufRuntime._encode_key(4, ProtoBufRuntime.WireType.Varint, pointer, bs);
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
        e += 1 + ProtoBufRuntime._sz_lendelim(r.txID.length);
        for (i = 0; i < r.signers.length; i++) {
            e += 1 + ProtoBufRuntime._sz_lendelim(r.signers[i].length);
        }
        e += 1 + ProtoBufRuntime._sz_lendelim(IbcCoreClientV1Height._estimate(r.timeout_height));
        e += 1 + ProtoBufRuntime._sz_uint64(r.timeout_timestamp);
        return e;
    }
    // empty checker

    function _empty(Data memory r) internal pure returns (bool) {
        if (r.txID.length != 0) {
            return false;
        }

        if (r.signers.length != 0) {
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
        output.txID = input.txID;
        output.signers = input.signers;
        IbcCoreClientV1Height.store(input.timeout_height, output.timeout_height);
        output.timeout_timestamp = input.timeout_timestamp;
    }

    //array helpers for Signers
    /**
     * @dev Add value to an array
     * @param self The in-memory struct
     * @param value The value to add
     */
    function addSigners(Data memory self, bytes memory value) internal pure {
        /**
         * First resize the array. Then add the new element to the end.
         */
        bytes[] memory tmp = new bytes[](self.signers.length + 1);
        for (uint256 i = 0; i < self.signers.length; i++) {
            tmp[i] = self.signers[i];
        }
        tmp[self.signers.length] = value;
        self.signers = tmp;
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
//library PacketDataIBCSignTx

library PacketAcknowledgementIBCSignTx {
    //enum definition
    // Solidity enum definitions
    enum Status {
        STATUS_UNKNOWN,
        STATUS_OK,
        STATUS_FAILED
    }

    // Solidity enum encoder
    function encode_Status(Status x) internal pure returns (int32) {
        if (x == Status.STATUS_UNKNOWN) {
            return 0;
        }

        if (x == Status.STATUS_OK) {
            return 1;
        }

        if (x == Status.STATUS_FAILED) {
            return 2;
        }
        revert();
    }

    // Solidity enum decoder
    function decode_Status(int64 x) internal pure returns (Status) {
        if (x == 0) {
            return Status.STATUS_UNKNOWN;
        }

        if (x == 1) {
            return Status.STATUS_OK;
        }

        if (x == 2) {
            return Status.STATUS_FAILED;
        }
        revert();
    }

    /**
     * @dev The estimator for an packed enum array
     * @return The number of bytes encoded
     */
    function estimate_packed_repeated_Status(Status[] memory a) internal pure returns (uint256) {
        uint256 e = 0;
        for (uint256 i = 0; i < a.length; i++) {
            e += ProtoBufRuntime._sz_enum(encode_Status(a[i]));
        }
        return e;
    }

    //struct definition
    struct Data {
        PacketAcknowledgementIBCSignTx.Status status;
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
                pointer += _read_status(pointer, bs, r);
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
    function _read_status(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (int64 tmp, uint256 sz) = ProtoBufRuntime._decode_enum(p, bs);
        PacketAcknowledgementIBCSignTx.Status x = decode_Status(tmp);
        r.status = x;
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

        if (uint256(r.status) != 0) {
            pointer += ProtoBufRuntime._encode_key(1, ProtoBufRuntime.WireType.Varint, pointer, bs);
            int32 _enum_status = encode_Status(r.status);
            pointer += ProtoBufRuntime._encode_enum(_enum_status, pointer, bs);
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
        e += 1 + ProtoBufRuntime._sz_enum(encode_Status(r.status));
        return e;
    }
    // empty checker

    function _empty(Data memory r) internal pure returns (bool) {
        if (uint256(r.status) != 0) {
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
        output.status = input.status;
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
//library PacketAcknowledgementIBCSignTx

library QueryTxAuthStateRequest {
    //struct definition
    struct Data {
        bytes txID;
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
                pointer += _read_txID(pointer, bs, r);
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
    function _read_txID(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (bytes memory x, uint256 sz) = ProtoBufRuntime._decode_bytes(p, bs);
        r.txID = x;
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

        if (r.txID.length != 0) {
            pointer += ProtoBufRuntime._encode_key(1, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
            pointer += ProtoBufRuntime._encode_bytes(r.txID, pointer, bs);
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
        e += 1 + ProtoBufRuntime._sz_lendelim(r.txID.length);
        return e;
    }
    // empty checker

    function _empty(Data memory r) internal pure returns (bool) {
        if (r.txID.length != 0) {
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
        output.txID = input.txID;
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
//library QueryTxAuthStateRequest

library QueryTxAuthStateResponse {
    //struct definition
    struct Data {
        TxAuthState.Data tx_auth_state;
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
                pointer += _read_tx_auth_state(pointer, bs, r);
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
    function _read_tx_auth_state(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (TxAuthState.Data memory x, uint256 sz) = _decode_TxAuthState(p, bs);
        r.tx_auth_state = x;
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
    function _decode_TxAuthState(uint256 p, bytes memory bs) internal pure returns (TxAuthState.Data memory, uint256) {
        uint256 pointer = p;
        (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
        pointer += bytesRead;
        (TxAuthState.Data memory r,) = TxAuthState._decode(pointer, bs, sz);
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
        pointer += TxAuthState._encode_nested(r.tx_auth_state, pointer, bs);

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
        e += 1 + ProtoBufRuntime._sz_lendelim(TxAuthState._estimate(r.tx_auth_state));
        return e;
    }
    // empty checker

    function _empty(Data memory r) internal pure returns (bool) {
        return true;
    }

    //store function
    /**
     * @dev Store in-memory struct to storage
     * @param input The in-memory struct
     * @param output The in-storage struct
     */
    function store(Data memory input, Data storage output) internal {
        TxAuthState.store(input.tx_auth_state, output.tx_auth_state);
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
//library QueryTxAuthStateResponse

library Account {
    //struct definition
    struct Data {
        bytes id;
        AuthType.Data auth_type;
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
                pointer += _read_id(pointer, bs, r);
            } else if (fieldId == 2) {
                pointer += _read_auth_type(pointer, bs, r);
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
    function _read_auth_type(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (AuthType.Data memory x, uint256 sz) = _decode_AuthType(p, bs);
        r.auth_type = x;
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
    function _decode_AuthType(uint256 p, bytes memory bs) internal pure returns (AuthType.Data memory, uint256) {
        uint256 pointer = p;
        (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
        pointer += bytesRead;
        (AuthType.Data memory r,) = AuthType._decode(pointer, bs, sz);
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

        if (r.id.length != 0) {
            pointer += ProtoBufRuntime._encode_key(1, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
            pointer += ProtoBufRuntime._encode_bytes(r.id, pointer, bs);
        }

        pointer += ProtoBufRuntime._encode_key(2, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
        pointer += AuthType._encode_nested(r.auth_type, pointer, bs);

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
        e += 1 + ProtoBufRuntime._sz_lendelim(r.id.length);
        e += 1 + ProtoBufRuntime._sz_lendelim(AuthType._estimate(r.auth_type));
        return e;
    }
    // empty checker

    function _empty(Data memory r) internal pure returns (bool) {
        if (r.id.length != 0) {
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
        AuthType.store(input.auth_type, output.auth_type);
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
//library Account

library AuthType {
    //enum definition
    // Solidity enum definitions
    enum AuthMode {
        AUTH_MODE_UNSPECIFIED,
        AUTH_MODE_LOCAL,
        AUTH_MODE_CHANNEL,
        AUTH_MODE_EXTENSION
    }

    // Solidity enum encoder
    function encode_AuthMode(AuthMode x) internal pure returns (int32) {
        if (x == AuthMode.AUTH_MODE_UNSPECIFIED) {
            return 0;
        }

        if (x == AuthMode.AUTH_MODE_LOCAL) {
            return 1;
        }

        if (x == AuthMode.AUTH_MODE_CHANNEL) {
            return 2;
        }

        if (x == AuthMode.AUTH_MODE_EXTENSION) {
            return 3;
        }
        revert();
    }

    // Solidity enum decoder
    function decode_AuthMode(int64 x) internal pure returns (AuthMode) {
        if (x == 0) {
            return AuthMode.AUTH_MODE_UNSPECIFIED;
        }

        if (x == 1) {
            return AuthMode.AUTH_MODE_LOCAL;
        }

        if (x == 2) {
            return AuthMode.AUTH_MODE_CHANNEL;
        }

        if (x == 3) {
            return AuthMode.AUTH_MODE_EXTENSION;
        }
        revert();
    }

    /**
     * @dev The estimator for an packed enum array
     * @return The number of bytes encoded
     */
    function estimate_packed_repeated_AuthMode(AuthMode[] memory a) internal pure returns (uint256) {
        uint256 e = 0;
        for (uint256 i = 0; i < a.length; i++) {
            e += ProtoBufRuntime._sz_enum(encode_AuthMode(a[i]));
        }
        return e;
    }

    //struct definition
    struct Data {
        AuthType.AuthMode mode;
        GoogleProtobufAny.Data option;
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
                pointer += _read_mode(pointer, bs, r);
            } else if (fieldId == 2) {
                pointer += _read_option(pointer, bs, r);
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
    function _read_mode(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (int64 tmp, uint256 sz) = ProtoBufRuntime._decode_enum(p, bs);
        AuthType.AuthMode x = decode_AuthMode(tmp);
        r.mode = x;
        return sz;
    }

    /**
     * @dev The decoder for reading a field
     * @param p The offset of bytes array to start decode
     * @param bs The bytes array to be decoded
     * @param r The in-memory struct
     * @return The number of bytes decoded
     */
    function _read_option(uint256 p, bytes memory bs, Data memory r) internal pure returns (uint256) {
        (GoogleProtobufAny.Data memory x, uint256 sz) = _decode_GoogleProtobufAny(p, bs);
        r.option = x;
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

        if (uint256(r.mode) != 0) {
            pointer += ProtoBufRuntime._encode_key(1, ProtoBufRuntime.WireType.Varint, pointer, bs);
            int32 _enum_mode = encode_AuthMode(r.mode);
            pointer += ProtoBufRuntime._encode_enum(_enum_mode, pointer, bs);
        }

        pointer += ProtoBufRuntime._encode_key(2, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
        pointer += GoogleProtobufAny._encode_nested(r.option, pointer, bs);

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
        e += 1 + ProtoBufRuntime._sz_enum(encode_AuthMode(r.mode));
        e += 1 + ProtoBufRuntime._sz_lendelim(GoogleProtobufAny._estimate(r.option));
        return e;
    }
    // empty checker

    function _empty(Data memory r) internal pure returns (bool) {
        if (uint256(r.mode) != 0) {
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
        output.mode = input.mode;
        GoogleProtobufAny.store(input.option, output.option);
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
//library AuthType

library TxAuthState {
    //struct definition
    struct Data {
        Account.Data[] remaining_signers;
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
        uint256[2] memory counters;
        uint256 fieldId;
        ProtoBufRuntime.WireType wireType;
        uint256 bytesRead;
        uint256 offset = p;
        uint256 pointer = p;
        while (pointer < offset + sz) {
            (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
            pointer += bytesRead;
            if (fieldId == 1) {
                pointer += _read_unpacked_repeated_remaining_signers(pointer, bs, nil(), counters);
            } else {
                pointer += ProtoBufRuntime._skip_field_decode(wireType, pointer, bs);
            }
        }
        pointer = offset;
        if (counters[1] > 0) {
            require(r.remaining_signers.length == 0);
            r.remaining_signers = new Account.Data[](counters[1]);
        }

        while (pointer < offset + sz) {
            (fieldId, wireType, bytesRead) = ProtoBufRuntime._decode_key(pointer, bs);
            pointer += bytesRead;
            if (fieldId == 1) {
                pointer += _read_unpacked_repeated_remaining_signers(pointer, bs, r, counters);
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
     * @param counters The counters for repeated fields
     * @return The number of bytes decoded
     */
    function _read_unpacked_repeated_remaining_signers(
        uint256 p,
        bytes memory bs,
        Data memory r,
        uint256[2] memory counters
    ) internal pure returns (uint256) {
        /**
         * if `r` is NULL, then only counting the number of fields.
         */
        (Account.Data memory x, uint256 sz) = _decode_Account(p, bs);
        if (isNil(r)) {
            counters[1] += 1;
        } else {
            r.remaining_signers[r.remaining_signers.length - counters[1]] = x;
            counters[1] -= 1;
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
    function _decode_Account(uint256 p, bytes memory bs) internal pure returns (Account.Data memory, uint256) {
        uint256 pointer = p;
        (uint256 sz, uint256 bytesRead) = ProtoBufRuntime._decode_varint(pointer, bs);
        pointer += bytesRead;
        (Account.Data memory r,) = Account._decode(pointer, bs, sz);
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
        if (r.remaining_signers.length != 0) {
            for (i = 0; i < r.remaining_signers.length; i++) {
                pointer += ProtoBufRuntime._encode_key(1, ProtoBufRuntime.WireType.LengthDelim, pointer, bs);
                pointer += Account._encode_nested(r.remaining_signers[i], pointer, bs);
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
        for (i = 0; i < r.remaining_signers.length; i++) {
            e += 1 + ProtoBufRuntime._sz_lendelim(Account._estimate(r.remaining_signers[i]));
        }
        return e;
    }
    // empty checker

    function _empty(Data memory r) internal pure returns (bool) {
        if (r.remaining_signers.length != 0) {
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
        for (uint256 i1 = 0; i1 < input.remaining_signers.length; i1++) {
            output.remaining_signers.push(input.remaining_signers[i1]);
        }
    }

    //array helpers for RemainingSigners
    /**
     * @dev Add value to an array
     * @param self The in-memory struct
     * @param value The value to add
     */
    function addRemainingSigners(Data memory self, Account.Data memory value) internal pure {
        /**
         * First resize the array. Then add the new element to the end.
         */
        Account.Data[] memory tmp = new Account.Data[](self.remaining_signers.length + 1);
        for (uint256 i = 0; i < self.remaining_signers.length; i++) {
            tmp[i] = self.remaining_signers[i];
        }
        tmp[self.remaining_signers.length] = value;
        self.remaining_signers = tmp;
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
//library TxAuthState
