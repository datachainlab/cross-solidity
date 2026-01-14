// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {IAuthenticator} from "./IAuthenticator.sol";
import {TxAuthManagerBase} from "./TxAuthManagerBase.sol";
import {TxManagerBase} from "./TxManagerBase.sol";
import {ICrossError} from "./ICrossError.sol";
import {ICrossEvent} from "./ICrossEvent.sol";

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

abstract contract Authenticator is IAuthenticator, TxAuthManagerBase, TxManagerBase, ICrossError, ICrossEvent {
    function signTx(MsgSignTx.Data calldata msg_) external override returns (MsgSignTxResponse.Data memory) {
        bytes32 txID = _decodeTxID(msg_.txID);

        if (msg_.signers.length != 1) {
            revert InvalidSignersLength();
        }

        bytes memory expectedSignerId = abi.encodePacked(msg.sender);
        if (keccak256(msg_.signers[0]) != keccak256(expectedSignerId)) {
            revert SignerMustEqualSender();
        }

        Account.Data[] memory accounts = _buildLocalAccounts(msg_.signers);

        bool completed = _sign(txID, accounts);
        if (completed) {
            emit TxAuthCompleted(txID);
        }

        emit TxSigned(msg.sender, txID, AuthType.AuthMode.AUTH_MODE_LOCAL);

        return MsgSignTxResponse.Data({tx_auth_completed: completed, log: ""});
    }

    function extSignTx(MsgExtSignTx.Data calldata msg_) external override returns (MsgExtSignTxResponse.Data memory) {
        bytes32 txID = _decodeTxID(msg_.txID);

        _verifySignatures(txID, msg_.signers);

        bool completed = _sign(txID, msg_.signers);
        if (completed) {
            emit TxAuthCompleted(txID);
        }

        emit TxSigned(msg.sender, txID, AuthType.AuthMode.AUTH_MODE_EXTENSION);

        return MsgExtSignTxResponse.Data({x: true});
    }

    function txAuthState(QueryTxAuthStateRequest.Data calldata req_)
        external
        override
        returns (QueryTxAuthStateResponse.Data memory resp)
    {
        bytes32 txID = _decodeTxID(req_.txID);

        TxAuthState.Data memory state = _getAuthState(txID);

        return QueryTxAuthStateResponse.Data({tx_auth_state: state});
    }

    function _decodeTxID(bytes calldata rawID) internal pure returns (bytes32) {
        if (rawID.length != 32) {
            revert InvalidTxIDLength();
        }
        return abi.decode(rawID, (bytes32));
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
