// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {IAuthExtensionVerifier} from "../core/IAuthExtensionVerifier.sol";
import {Account} from "../proto/cross/core/auth/Auth.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract SampleEcrecoverVerifier is IAuthExtensionVerifier {
    function verify(bytes32 txIdHash, Account.Data calldata signer, bytes calldata signature)
        external
        view
        override
        returns (bool isValid)
    {
        if (signer.id.length != 20) return false;
        if (signature.length != 65) return false;
        address signerAddress = address(bytes20(signer.id));
        bytes32 messageHash = MessageHashUtils.toEthSignedMessageHash(txIdHash);
        address recoveredAddress = ECDSA.recover(messageHash, signature);
        return recoveredAddress != address(0) && recoveredAddress == signerAddress;
    }
}
