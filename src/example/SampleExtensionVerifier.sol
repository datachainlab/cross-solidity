// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {IAuthExtensionVerifier} from "../core/IAuthExtensionVerifier.sol";
import {AuthType, Account} from "../proto/cross/core/auth/Auth.sol";

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract SampleExtensionVerifier is IAuthExtensionVerifier {
    function verify(
        bytes32,
        /*txIDHash*/
        Account.Data calldata signer
    )
        external
        view
        override
        returns (bool isValid)
    {
        if (signer.auth_type.mode != AuthType.AuthMode.AUTH_MODE_EXTENSION) {
            return false;
        }

        (bytes memory signature, bytes32 signMSG) = abi.decode(signer.auth_type.option.value, (bytes, bytes32));

        if (signer.id.length != 20) {
            return false;
        }
        address expectedAddress = address(bytes20(signer.id));

        bytes32 messageHash = MessageHashUtils.toEthSignedMessageHash(signMSG);

        address recoveredAddress = ECDSA.recover(messageHash, signature);

        return recoveredAddress != address(0) && recoveredAddress == expectedAddress;
    }
}
