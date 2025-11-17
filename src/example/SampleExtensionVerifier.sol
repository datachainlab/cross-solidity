// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {IAuthExtensionVerifier} from "../core/IAuthExtensionVerifier.sol";
import {AuthType, Account} from "../proto/cross/core/auth/Auth.sol";

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract SampleExtensionVerifier is IAuthExtensionVerifier {
    /**
     * Expected inputs:
     *
     * @param txIDHash (1st argument, ignored in this implementation)
     *  - Hash that uniquely identifies the transaction being verified.
     *  - Not used in this sample implementation, but expected to be passed so
     *    the caller can associate verification with a specific transaction.
     *
     * @param signer (2nd argument: Account.Data)
     *  - signer.id:
     *      - 20-byte value representing the signer’s Ethereum address.
     *      - Must satisfy: signer.id.length == 20.
     *      - The expected address is reconstructed as: address(bytes20(signer.id)).
     *
     *  - signer.auth_type.mode:
     *      - Must be AuthType.AuthMode.AUTH_MODE_EXTENSION.
     *      - Any other mode is treated as invalid and verification will fail.
     *
     *  - signer.auth_type.option.value:
     *      - ABI-encoded as: abi.encode(signature, signMSG).
     *        * signature:
     *            - ECDSA signature over signMSG, in standard Ethereum format
     *              (65 bytes: r(32) | s(32) | v(1)).
     *        * signMSG:
     *            - 32-byte message hash that was signed.
     *            - On-chain, this contract applies:
     *                MessageHashUtils.toEthSignedMessageHash(signMSG)
     *              and expects `signature` to be a valid Ethereum signed message
     *              for that value.
     *
     * Return value:
     *  - true:
     *      - When the recovered address from the signature is non-zero and
     *        exactly matches address(bytes20(signer.id)).
     *  - false:
     *      - When:
     *          * auth_type.mode is not AUTH_MODE_EXTENSION, or
     *          * signer.id length is not 20 bytes, or
     *          * signature recovery fails, or
     *          * the recovered address does not match the expected address.
     */
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
