// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {Account} from "../proto/cross/core/auth/Auth.sol";

interface IAuthExtensionVerifier {
    function verify(bytes32 txIDHash, Account.Data calldata signer) external view returns (bool isValid);
}
