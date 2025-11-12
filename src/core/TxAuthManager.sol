// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {TxAuthManagerBase} from "./TxAuthManagerBase.sol";
import {CrossStore} from "./CrossStore.sol";
import {Account, TxAuthState} from "../proto/cross/core/auth/Auth.sol";

abstract contract TxAuthManager is TxAuthManagerBase, CrossStore {
    function initAuthState(bytes32 txId, Account.Data[] memory signers) internal virtual override {
        CrossStore.AuthStorage storage s = _getAuthStorage();
        if (s.authInitialized[txId]) revert AuthStateAlreadyInitialized(txId);
        _setStateFromRemainingList(s, txId, signers);
        s.authInitialized[txId] = true;
    }

    function isCompletedAuth(bytes32 txId) internal view virtual override returns (bool) {
        CrossStore.AuthStorage storage s = _getAuthStorage();
        if (!s.authInitialized[txId]) revert IDNotFound(txId);
        return s.remainingCount[txId] == 0;
    }

    function sign(bytes32 txId, Account.Data[] memory signers) internal virtual override returns (bool) {
        CrossStore.AuthStorage storage s = _getAuthStorage();
        if (!s.authInitialized[txId]) revert IDNotFound(txId);
        if (s.remainingCount[txId] == 0) revert AuthAlreadyCompleted(txId);

        for (uint256 i = 0; i < signers.length; ++i) {
            bytes32 key = _accountKey(signers[i]);
            if (s.remaining[txId][key]) {
                s.remaining[txId][key] = false;
                --s.remainingCount[txId];
                if (s.remainingCount[txId] == 0) return true;
            }
        }
        return s.remainingCount[txId] == 0;
    }

    function getAuthState(bytes32 txId) internal view virtual override returns (TxAuthState.Data memory) {
        CrossStore.AuthStorage storage s = _getAuthStorage();
        if (!s.authInitialized[txId]) revert IDNotFound(txId);
        Account.Data[] memory remains = _getRemainingSigners(s, txId);
        return TxAuthState.Data({remaining_signers: remains});
    }

    function _getRemainingSigners(CrossStore.AuthStorage storage s, bytes32 txId)
        internal
        view
        returns (Account.Data[] memory out)
    {
        uint256 total = s.requiredAccounts[txId].length;
        uint256 need = s.remainingCount[txId];
        out = new Account.Data[](need);
        uint256 p = 0;
        for (uint256 i = 0; i < total; ++i) {
            Account.Data memory acc = s.requiredAccounts[txId][i];
            if (s.remaining[txId][_accountKey(acc)]) {
                out[p] = acc;
                ++p;
                if (p == need) break;
            }
        }
    }

    function _setStateFromRemainingList(CrossStore.AuthStorage storage s, bytes32 txId, Account.Data[] memory list)
        internal
    {
        for (uint256 i = 0; i < list.length; ++i) {
            bytes32 key = _accountKey(list[i]);
            if (!s.remaining[txId][key]) {
                s.remaining[txId][key] = true;
                ++s.remainingCount[txId];
                s.requiredAccounts[txId].push(list[i]);
            }
        }
    }

    function _accountKey(Account.Data memory a) internal pure returns (bytes32) {
        return keccak256(abi.encode(a.id, a.auth_type));
    }
}
