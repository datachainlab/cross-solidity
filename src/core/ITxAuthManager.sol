// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {Account, TxAuthState} from "../proto/cross/core/auth/Auth.sol";

interface ITxAuthManager {
    function initAuthState(bytes32 txID, Account.Data[] memory signers) external;
    function isCompletedAuth(bytes32 txID) external view returns (bool);
    function sign(bytes32 txID, Account.Data[] memory signers) external returns (bool);
    function getAuthState(bytes32 txID) external view returns (TxAuthState.Data memory);
}
