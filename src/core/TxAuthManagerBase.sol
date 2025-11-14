// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {Account, TxAuthState} from "../proto/cross/core/auth/Auth.sol";

abstract contract TxAuthManagerBase {
    function _initAuthState(bytes32 txID, Account.Data[] memory signers) internal virtual;
    function _isCompletedAuth(bytes32 txID) internal virtual returns (bool);
    function _sign(bytes32 txID, Account.Data[] memory signers) internal virtual returns (bool);
    function _getAuthState(bytes32 txID) internal virtual returns (TxAuthState.Data memory);
}
