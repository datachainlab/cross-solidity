// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase, gas-small-strings
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";
import {GoogleProtobufAny} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";

import {SampleExtensionVerifier} from "../src/example/SampleExtensionVerifier.sol";
import {Account as AuthAccount, AuthType} from "../src/proto/cross/core/auth/Auth.sol";

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract SampleExtensionVerifierTest is Test {
    SampleExtensionVerifier private verifier;

    uint256 private signerPrivateKey = 0xBAD_5EED;
    address private signerAddress;

    bytes32 private txIDHash = keccak256("test_tx_id_hash");
    bytes32 private signMsg = keccak256("message_to_be_signed");
    bytes32 private ethSignedMsgHash;
    bytes private validSignature;

    AuthAccount.Data private baseAuthAccount;

    function setUp() public {
        verifier = new SampleExtensionVerifier();

        signerAddress = vm.addr(signerPrivateKey);

        ethSignedMsgHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", signMsg));

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signerPrivateKey, ethSignedMsgHash);
        validSignature = abi.encodePacked(r, s, v);

        GoogleProtobufAny.Data memory option = GoogleProtobufAny.Data({
            type_url: "SampleExtensionVerifier",
            value: abi.encode(validSignature, signMsg) // (bytes, bytes32)
        });

        AuthType.Data memory authType = AuthType.Data({mode: AuthType.AuthMode.AUTH_MODE_EXTENSION, option: option});

        baseAuthAccount = AuthAccount.Data({id: abi.encodePacked(signerAddress), auth_type: authType});
    }

    function test_verify_SucceedsWhenSignatureIsValid() public view {
        bool isValid = verifier.verify(txIDHash, baseAuthAccount);
        assertTrue(isValid, "Signature should be valid");
    }

    function test_verify_ReturnsFalseWhenAuthModeIsNotExtension() public view {
        AuthAccount.Data memory modifiedAuthAccount = baseAuthAccount;
        modifiedAuthAccount.auth_type.mode = AuthType.AuthMode.AUTH_MODE_LOCAL;

        bool isValid = verifier.verify(txIDHash, modifiedAuthAccount);
        assertFalse(isValid, "Should return false if mode is not EXTENSION");
    }

    function test_verify_ReturnsFalseWhenSignerIdMismatch() public view {
        AuthAccount.Data memory modifiedAuthAccount = baseAuthAccount;
        address otherAddress = address(0xDEADBEEF);
        modifiedAuthAccount.id = abi.encodePacked(otherAddress);

        bool isValid = verifier.verify(txIDHash, modifiedAuthAccount);
        assertFalse(isValid, "Should return false if signer.id does not match recovered address");
    }

    function test_verify_ReturnsFalseWhenSignerIdIsInvalidLength() public view {
        AuthAccount.Data memory modifiedAuthAccount = baseAuthAccount;
        modifiedAuthAccount.id = bytes("not-an-address");

        bool isValid = verifier.verify(txIDHash, modifiedAuthAccount);
        assertFalse(isValid, "Should return false if signer.id length is not 20");
    }

    function test_verify_ReturnsFalseWhenSignedMsgMismatch() public view {
        AuthAccount.Data memory modifiedAuthAccount = baseAuthAccount;
        bytes32 otherMsg = keccak256("other_message");

        modifiedAuthAccount.auth_type.option.value = abi.encode(validSignature, otherMsg);

        bool isValid = verifier.verify(txIDHash, modifiedAuthAccount);
        assertFalse(isValid, "Should return false if sign_msg does not match signature");
    }

    function test_verify_RevertsWhen_SignatureIsInvalidLength() public {
        AuthAccount.Data memory modifiedAccount = baseAuthAccount;
        bytes memory invalidSignature = hex"1234";
        modifiedAccount.auth_type.option.value = abi.encode(invalidSignature, signMsg);

        vm.expectRevert(abi.encodeWithSelector(ECDSA.ECDSAInvalidSignatureLength.selector, 2));
        verifier.verify(txIDHash, modifiedAccount);
    }

    function test_verify_RevertsWhen_SignatureIsIncorrect() public {
        AuthAccount.Data memory modifiedAccount = baseAuthAccount;

        bytes32 r = bytes32(validSignature);
        bytes32 sTampered = r;
        uint8 v = 28;

        bytes memory tamperedSignature = abi.encodePacked(r, sTampered, v);
        modifiedAccount.auth_type.option.value = abi.encode(tamperedSignature, signMsg);

        vm.expectRevert(abi.encodeWithSelector(ECDSA.ECDSAInvalidSignatureS.selector, sTampered));
        verifier.verify(txIDHash, modifiedAccount);
    }

    function test_verify_RevertsWhen_OptionDataIsMalformed() public {
        AuthAccount.Data memory modifiedAuthAccount = baseAuthAccount;

        modifiedAuthAccount.auth_type.option.value = bytes("this is not abi encoded");

        vm.expectRevert();
        verifier.verify(txIDHash, modifiedAuthAccount);
    }
}
