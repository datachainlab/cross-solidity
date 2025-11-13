// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {IAuthenticator} from "./IAuthenticator.sol";
import {TxAuthManagerBase} from "./TxAuthManagerBase.sol";
import {TxManagerBase} from "./TxManagerBase.sol";

import {
    AuthType,
    MsgSignTx,
    MsgSignTxResponse,
    MsgExtSignTx,
    MsgExtSignTxResponse,
    QueryTxAuthStateRequest,
    QueryTxAuthStateResponse,
    Account
} from "../proto/cross/core/auth/Auth.sol";
import {GoogleProtobufAny} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";

abstract contract Authenticator is IAuthenticator, TxAuthManagerBase, TxManagerBase {
    function signTx(MsgSignTx.Data calldata msg_) external override returns (MsgSignTxResponse.Data memory) {
        Account.Data[] memory accounts = _buildLocalAccounts(msg_.signers);

        bytes32 txIdHash = sha256(msg_.txID);

        bool completed = sign(txIdHash, accounts);

        if (completed) {
            runTxIfCompleted(txIdHash);
        }

        emit TxSigned(msg.sender, txIdHash, AuthType.AuthMode.AUTH_MODE_LOCAL);

        return MsgSignTxResponse.Data({tx_auth_completed: completed, log: ""});
    }

    function extSignTx(
        MsgExtSignTx.Data calldata /*msg_*/
    )
        external
        override
        returns (MsgExtSignTxResponse.Data memory)
    {
        revert IAuthenticator.ExtSignTxNotImplemented();
    }

    function txAuthState(
        QueryTxAuthStateRequest.Data calldata /*req_*/
    )
        external
        view
        override
        returns (QueryTxAuthStateResponse.Data memory resp)
    {
        revert IAuthenticator.TxAuthStateNotImplemented();
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
