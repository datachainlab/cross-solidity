// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {IAuthenticator} from "./IAuthenticator.sol";
import {TxAuthManagerBase} from "./TxAuthManagerBase.sol";
import {TxManagerBase} from "./TxManagerBase.sol";
import {ICrossError} from "./ICrossError.sol";

import {
    AuthType,
    MsgSignTx,
    MsgSignTxResponse,
    MsgExtSignTx,
    MsgExtSignTxResponse,
    QueryTxAuthStateRequest,
    QueryTxAuthStateResponse,
    Account,
    TxAuthState
} from "../proto/cross/core/auth/Auth.sol";
import {GoogleProtobufAny} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";

abstract contract Authenticator is IAuthenticator, TxAuthManagerBase, TxManagerBase, ICrossError {
    function signTx(MsgSignTx.Data calldata msg_) external override returns (MsgSignTxResponse.Data memory) {
        Account.Data[] memory accounts = _buildLocalAccounts(msg_.signers);

        bytes32 txIDHash = sha256(msg_.txID);

        bool completed = _sign(txIDHash, accounts);
        if (completed) {
            _runTxIfCompleted(txIDHash);
        }

        emit TxSigned(msg.sender, txIDHash, AuthType.AuthMode.AUTH_MODE_LOCAL);

        return MsgSignTxResponse.Data({tx_auth_completed: completed, log: ""});
    }

    function extSignTx(MsgExtSignTx.Data calldata msg_) external override returns (MsgExtSignTxResponse.Data memory) {
        bytes32 txIDHash = sha256(msg_.txID);

        _verifySignatures(txIDHash, msg_.signers);

        bool completed = _sign(txIDHash, msg_.signers);
        if (completed) {
            _runTxIfCompleted(txIDHash);
        }

        emit TxSigned(msg.sender, txIDHash, AuthType.AuthMode.AUTH_MODE_EXTENSION);

        return MsgExtSignTxResponse.Data({x: true});
    }

    function txAuthState(QueryTxAuthStateRequest.Data calldata req_)
        external
        override
        returns (QueryTxAuthStateResponse.Data memory resp)
    {
        bytes32 txIDHash = sha256(req_.txID);

        TxAuthState.Data memory state = _getAuthState(txIDHash);

        return QueryTxAuthStateResponse.Data({tx_auth_state: state});
    }

    function _buildLocalAccounts(bytes[] calldata signerIDs) internal pure returns (Account.Data[] memory) {
        AuthType.Data memory localAuthType = AuthType.Data({
            mode: AuthType.AuthMode.AUTH_MODE_LOCAL, option: GoogleProtobufAny.Data({type_url: "", value: ""})
        });

        Account.Data[] memory accounts = new Account.Data[](signerIDs.length);
        for (uint256 i = 0; i < signerIDs.length; ++i) {
            accounts[i] = Account.Data({id: signerIDs[i], auth_type: localAuthType});
        }
        return accounts;
    }
}
