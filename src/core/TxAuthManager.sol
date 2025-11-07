// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {TxAuthManagerBase} from "./TxAuthManagerBase.sol";
import {CoreStore} from "./CoreStore.sol";
import {Account, TxAuthState} from "../proto/cross/core/auth/Auth.sol";

abstract contract TxAuthManager is TxAuthManagerBase, CoreStore {
    function InitAuthState(bytes32 txId, Account.Data[] memory signers) internal virtual override {
        CoreStore.AuthStorage storage S = _getAuthStorage();
        if (S.authInitialized[txId]) revert AuthStateAlreadyInitialized(txId);
        _setStateFromRemainingList(S, txId, signers);
        S.authInitialized[txId] = true;
    }

    function IsCompletedAuth(bytes32 txId) internal view virtual override returns (bool) {
        CoreStore.AuthStorage storage S = _getAuthStorage();
        if (!S.authInitialized[txId]) revert IDNotFound(txId);
        return S.remainingCount[txId] == 0;
    }

    function Sign(bytes32 txId, Account.Data[] memory signers) internal virtual override returns (bool) {
        CoreStore.AuthStorage storage S = _getAuthStorage();
        if (!S.authInitialized[txId]) revert IDNotFound(txId);
        if (S.remainingCount[txId] == 0) revert AuthAlreadyCompleted(txId);

        for (uint256 i = 0; i < signers.length; i++) {
            bytes32 key = keccak256(signers[i].id);
            if (S.remaining[txId][key]) {
                S.remaining[txId][key] = false;
                S.remainingCount[txId] -= 1;
                if (S.remainingCount[txId] == 0) return true;
            }
        }
        return S.remainingCount[txId] == 0;
    }

    function GetAuthState(bytes32 txId) internal view virtual override returns (TxAuthState.Data memory) {
        CoreStore.AuthStorage storage S = _getAuthStorage();
        if (!S.authInitialized[txId]) revert IDNotFound(txId);
        Account.Data[] memory remains = _getRemainingSigners(S, txId);
        return TxAuthState.Data({remaining_signers: remains});
    }

    function _getRemainingSigners(CoreStore.AuthStorage storage S, bytes32 txId)
        internal
        view
        returns (Account.Data[] memory out)
    {
        uint256 total = S.requiredAccounts[txId].length;
        uint256 need = S.remainingCount[txId];
        out = new Account.Data[](need);
        uint256 p = 0;
        for (uint256 i = 0; i < total; i++) {
            Account.Data memory acc = S.requiredAccounts[txId][i];
            if (S.remaining[txId][keccak256(acc.id)]) {
                out[p++] = acc;
                if (p == need) break;
            }
        }
    }

    function _setStateFromRemainingList(CoreStore.AuthStorage storage S, bytes32 txId, Account.Data[] memory list)
        internal
    {
        for (uint256 i = 0; i < list.length; i++) {
            bytes32 key = keccak256(list[i].id);
            if (!S.remaining[txId][key]) {
                S.remaining[txId][key] = true;
                S.remainingCount[txId] += 1;
                S.requiredAccounts[txId].push(list[i]);
            }
        }
    }

    function _clearState(CoreStore.AuthStorage storage S, bytes32 txId) internal {
        uint256 total = S.requiredAccounts[txId].length;
        for (uint256 i = 0; i < total; i++) {
            bytes32 key = keccak256(S.requiredAccounts[txId][i].id);
            if (S.remaining[txId][key]) S.remaining[txId][key] = false;
        }
        delete S.remainingCount[txId];
        delete S.requiredAccounts[txId];
        delete S.authInitialized[txId];
    }
}
