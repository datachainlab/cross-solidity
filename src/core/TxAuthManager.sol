// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {TxAuthManagerBase} from "./TxAuthManagerBase.sol";
import {CrossStore} from "./CrossStore.sol";
import {Account, TxAuthState} from "../proto/cross/core/auth/Auth.sol";
import {ITxAuthManager} from "./ITxAuthManager.sol";
import {ICrossError} from "./ICrossError.sol";

contract TxAuthManager is TxAuthManagerBase, CrossStore, ITxAuthManager, ICrossError {
    function initAuthState(bytes32 txID, Account.Data[] calldata signers) external override {
        _initAuthState(txID, signers);
    }

    function isCompletedAuth(bytes32 txID) external override returns (bool) {
        return _isCompletedAuth(txID);
    }

    function sign(bytes32 txID, Account.Data[] calldata signers) external override returns (bool) {
        return _sign(txID, signers);
    }

    function getAuthState(bytes32 txID) external override returns (TxAuthState.Data memory) {
        return _getAuthState(txID);
    }

    function _initAuthState(bytes32 txID, Account.Data[] memory signers) internal virtual override {
        CrossStore.AuthStorage storage s = _getAuthStorage();
        if (s.authInitialized[txID]) revert AuthStateAlreadyInitialized(txID);
        _setStateFromRemainingList(s, txID, signers);
        s.authInitialized[txID] = true;
    }

    function _isCompletedAuth(bytes32 txID) internal virtual override returns (bool) {
        CrossStore.AuthStorage storage s = _getAuthStorage();
        if (!s.authInitialized[txID]) revert IDNotFound(txID);
        return s.remainingCount[txID] == 0;
    }

    function _sign(bytes32 txID, Account.Data[] memory signers) internal virtual override returns (bool) {
        CrossStore.AuthStorage storage s = _getAuthStorage();
        if (!s.authInitialized[txID]) revert IDNotFound(txID);
        if (s.remainingCount[txID] == 0) revert AuthAlreadyCompleted(txID);

        for (uint256 i = 0; i < signers.length; ++i) {
            bytes32 key = _accountKey(signers[i]);
            if (s.remaining[txID][key]) {
                s.remaining[txID][key] = false;
                --s.remainingCount[txID];
                if (s.remainingCount[txID] == 0) return true;
            }
        }
        return s.remainingCount[txID] == 0;
    }

    function _getAuthState(bytes32 txID) internal virtual override returns (TxAuthState.Data memory) {
        CrossStore.AuthStorage storage s = _getAuthStorage();
        if (!s.authInitialized[txID]) revert IDNotFound(txID);
        Account.Data[] memory remains = _getRemainingSigners(s, txID);
        return TxAuthState.Data({remaining_signers: remains});
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

    function _setStateFromRemainingList(CrossStore.AuthStorage storage s, bytes32 txID, Account.Data[] memory list)
        internal
    {
        for (uint256 i = 0; i < list.length; ++i) {
            bytes32 key = _accountKey(list[i]);
            if (!s.remaining[txID][key]) {
                s.remaining[txID][key] = true;
                ++s.remainingCount[txID];
                s.requiredAccounts[txID].push(list[i]);
            }
        }
    }

    function _accountKey(Account.Data memory a) internal pure returns (bytes32) {
        return keccak256(abi.encode(a.id, a.auth_type));
    }
}
