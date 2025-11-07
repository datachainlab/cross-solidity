// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {Account, TxAuthState} from "../proto/cross/core/auth/Auth.sol";

abstract contract TxAuthManagerBase {
    error AuthStateAlreadyInitialized(bytes32 txId);
    error IDNotFound(bytes32 txId);
    error AuthAlreadyCompleted(bytes32 txId);

    function InitAuthState(bytes32 txId, Account.Data[] memory signers) internal virtual;
    function IsCompletedAuth(bytes32 txId) internal view virtual returns (bool);
    function Sign(bytes32 txId, Account.Data[] memory signers) internal virtual returns (bool);
    function GetAuthState(bytes32 txId) internal view virtual returns (TxAuthState.Data memory);
}
