// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {TxAuthManagerBase} from "./TxAuthManagerBase.sol";
import {Account, TxAuthState} from "../proto/cross/core/auth/Auth.sol";

abstract contract TxAuthManager is TxAuthManagerBase {
    mapping(bytes32 => mapping(bytes32 => bool)) internal remaining;
    mapping(bytes32 => uint256) internal remainingCount;
    mapping(bytes32 => bool) internal authInitialized;
    mapping(bytes32 => Account.Data[]) internal requiredAccounts;

    function InitAuthState(bytes32 txId, Account.Data[] memory signers) internal virtual override {
        if (authInitialized[txId]) revert AuthStateAlreadyInitialized(txId);
        _setStateFromRemainingList(txId, signers);
        authInitialized[txId] = true;
    }

    function IsCompletedAuth(bytes32 txId) internal view virtual override returns (bool) {
        if (!authInitialized[txId]) revert IDNotFound(txId);
        return remainingCount[txId] == 0;
    }

    function Sign(bytes32 txId, Account.Data[] memory signers) internal virtual override returns (bool) {
        if (!authInitialized[txId]) revert IDNotFound(txId);
        if (remainingCount[txId] == 0) revert AuthAlreadyCompleted(txId);

        for (uint256 i = 0; i < signers.length; i++) {
            bytes32 key = keccak256(signers[i].id);
            if (remaining[txId][key]) {
                remaining[txId][key] = false;
                remainingCount[txId] -= 1;
                if (remainingCount[txId] == 0) return true;
            }
        }
        return remainingCount[txId] == 0;
    }

    function GetAuthState(bytes32 txId) internal view virtual override returns (TxAuthState.Data memory) {
        if (!authInitialized[txId]) revert IDNotFound(txId);
        Account.Data[] memory remains = _getRemainingSigners(txId);
        return TxAuthState.Data({remaining_signers: remains});
    }

    // helpers
    function _getRemainingSigners(bytes32 txId) internal view returns (Account.Data[] memory out) {
        uint256 total = requiredAccounts[txId].length;
        uint256 need = remainingCount[txId];
        out = new Account.Data[](need);
        uint256 p = 0;
        for (uint256 i = 0; i < total; i++) {
            Account.Data memory acc = requiredAccounts[txId][i];
            if (remaining[txId][keccak256(acc.id)]) {
                out[p++] = acc;
                if (p == need) break;
            }
        }
    }

    function _setStateFromRemainingList(bytes32 txId, Account.Data[] memory list) private {
        for (uint256 i = 0; i < list.length; i++) {
            bytes32 key = keccak256(list[i].id);
            if (!remaining[txId][key]) {
                remaining[txId][key] = true;
                remainingCount[txId] += 1;
                requiredAccounts[txId].push(list[i]);
            }
        }
    }

    function _clearState(bytes32 txId) private {
        uint256 total = requiredAccounts[txId].length;
        for (uint256 i = 0; i < total; i++) {
            bytes32 key = keccak256(requiredAccounts[txId][i].id);
            if (remaining[txId][key]) remaining[txId][key] = false;
        }
        delete remainingCount[txId];
        delete requiredAccounts[txId];
        delete authInitialized[txId];
    }
}
