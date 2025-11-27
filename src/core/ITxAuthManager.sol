// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {Account, TxAuthState} from "../proto/cross/core/auth/Auth.sol";
import {IAuthExtensionVerifier} from "./IAuthExtensionVerifier.sol";

interface ITxAuthManager {
    function initialize(string[] calldata typeUrls, IAuthExtensionVerifier[] calldata verifiers) external;
    function initAuthState(bytes32 txID, Account.Data[] calldata signers) external;
    function isCompletedAuth(bytes32 txID) external view returns (bool);
    function sign(bytes32 txID, Account.Data[] calldata signers) external returns (bool);
    function getAuthState(bytes32 txID) external view returns (TxAuthState.Data memory);
    function verifySignatures(bytes32 txIDHash, Account.Data[] calldata signers) external;
}
