// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {
    MsgSignTx,
    MsgSignTxResponse,
    MsgExtSignTx,
    MsgExtSignTxResponse,
    QueryTxAuthStateRequest,
    QueryTxAuthStateResponse
} from "../proto/cross/core/auth/Auth.sol";

enum SignMethod {
    LOCAL,
    // IBC, // IBC signing is not supported
    EXTENSION
}

interface IAuthenticator {
    event TxSigned(address indexed signer, bytes32 indexed txId, SignMethod method);

    function signTx(MsgSignTx.Data calldata msg_) external returns (MsgSignTxResponse.Data memory);

    // IBC signing is not supported
    // function ibcSignTx(MsgIBCSignTx.Data calldata msg_)
    //     external
    //     returns (MsgIBCSignTxResponse.Data memory);

    function extSignTx(MsgExtSignTx.Data calldata msg_) external returns (MsgExtSignTxResponse.Data memory);

    function txAuthState(QueryTxAuthStateRequest.Data calldata req_)
        external
        view
        returns (QueryTxAuthStateResponse.Data memory);
}
