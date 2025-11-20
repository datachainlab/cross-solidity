// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {IAuthenticator} from "./IAuthenticator.sol";
import {TxAuthManagerBase} from "./TxAuthManagerBase.sol";
import {TxManagerBase} from "./TxManagerBase.sol";
import {CrossStore} from "./CrossStore.sol";
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

abstract contract Authenticator is IAuthenticator, TxAuthManagerBase, TxManagerBase, CrossStore, ICrossError {
    function signTx(MsgSignTx.Data calldata msg_) external override returns (MsgSignTxResponse.Data memory) {
        if (msg_.txID.length != 32) {
            revert InvalidTxIDLength();
        }

        bytes32 txID = abi.decode(msg_.txID, (bytes32));

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
            _runTxIfCompleted(txID);
        }

        emit TxSigned(msg.sender, txID, AuthType.AuthMode.AUTH_MODE_LOCAL);

        return MsgSignTxResponse.Data({tx_auth_completed: completed, log: ""});
    }

    function extSignTx(MsgExtSignTx.Data calldata msg_) external override returns (MsgExtSignTxResponse.Data memory) {
        if (msg_.txID.length != 32) {
            revert InvalidTxIDLength();
        }

        bytes32 txID = abi.decode(msg_.txID, (bytes32));

        _verifySignatures(txID, msg_.signers);

        bool completed = _sign(txID, msg_.signers);
        if (completed) {
            _runTxIfCompleted(txID);
        }

        emit TxSigned(msg.sender, txID, AuthType.AuthMode.AUTH_MODE_EXTENSION);

        return MsgExtSignTxResponse.Data({x: true});
    }

    function txAuthState(QueryTxAuthStateRequest.Data calldata req_)
        external
        view
        override
        returns (QueryTxAuthStateResponse.Data memory resp)
    {
        if (req_.txID.length != 32) {
            revert InvalidTxIDLength();
        }

        bytes32 txID = abi.decode(req_.txID, (bytes32));

        CrossStore.AuthStorage storage s = _getAuthStorage();
        if (!s.authInitialized[txID]) revert IDNotFound(txID);

        Account.Data[] memory remains = _getRemainingSigners(s, txID);

        return QueryTxAuthStateResponse.Data({tx_auth_state: TxAuthState.Data({remaining_signers: remains})});
    }

    function _getRemainingSigners(CrossStore.AuthStorage storage s, bytes32 txID)
        internal
        view
        returns (Account.Data[] memory out)
    {
        uint256 total = s.requiredAccounts[txID].length;
        uint256 need = s.remainingCount[txID];
        out = new Account.Data[](need);
        uint256 p = 0;
        for (uint256 i = 0; i < total; ++i) {
            Account.Data memory acc = s.requiredAccounts[txID][i];
            if (s.remaining[txID][_accountKey(acc)]) {
                out[p] = acc;
                ++p;
                if (p == need) break;
            }
        }
    }

    function _accountKey(Account.Data memory a) internal pure returns (bytes32) {
        return keccak256(abi.encode(a.id, a.auth_type));
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
