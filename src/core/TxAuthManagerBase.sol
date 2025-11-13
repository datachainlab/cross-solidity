// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {Account, TxAuthState} from "../proto/cross/core/auth/Auth.sol";

abstract contract TxAuthManagerBase {
    error AuthStateAlreadyInitialized(bytes32 txID);
    error IDNotFound(bytes32 txID);
    error AuthAlreadyCompleted(bytes32 txID);

    function initAuthState(bytes32 txID, Account.Data[] memory signers) internal virtual;
    function isCompletedAuth(bytes32 txID) internal view virtual returns (bool);
    function sign(bytes32 txID, Account.Data[] memory signers) internal virtual returns (bool);
    function getAuthState(bytes32 txID) internal view virtual returns (TxAuthState.Data memory);
}
