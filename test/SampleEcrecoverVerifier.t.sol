// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase, gas-small-strings
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";
import {Account as AuthAccount, AuthType} from "../src/proto/cross/core/auth/Auth.sol";
import {SampleEcrecoverVerifier} from "../src/example/SampleEcrecoverVerifier.sol";
import {GoogleProtobufAny} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract SampleEcrecoverVerifierTest is Test {
    SampleEcrecoverVerifier private verifier;

    bytes32 private txIdHash = keccak256("sample_tx_id_hash");
    bytes32 private wrongTxIdHash = keccak256("wrong_tx_id_hash");

    uint256 private signerPk = 0x123456;
    address private signerAddr;
    uint256 private wrongSignerPk = 0x789012;
    address private wrongSignerAddr;

    AuthAccount.Data private signerAuthAccount;
    AuthType.Data private dummyAuthType;

    function setUp() public {
        verifier = new SampleEcrecoverVerifier();

        signerAddr = vm.addr(signerPk);
        wrongSignerAddr = vm.addr(wrongSignerPk);

        GoogleProtobufAny.Data memory emptyAny = GoogleProtobufAny.Data({type_url: "", value: ""});
        dummyAuthType = AuthType.Data({mode: AuthType.AuthMode.AUTH_MODE_EXTENSION, option: emptyAny});

        signerAuthAccount = AuthAccount.Data({id: abi.encodePacked(signerAddr), auth_type: dummyAuthType});
    }

    function _signEthSignedHash(bytes32 hash, uint256 pk) internal pure returns (bytes memory) {
        bytes32 ethSignedHash = MessageHashUtils.toEthSignedMessageHash(hash);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(pk, ethSignedHash);
        return abi.encodePacked(r, s, v);
    }

    function test_verify_SucceedsWithValidSignature() public {
        bytes memory signature = _signEthSignedHash(txIdHash, signerPk);

        bool isValid = verifier.verify(txIdHash, signerAuthAccount, signature);
        assertTrue(isValid, "Verification should succeed with a valid signature");
    }

    function test_verify_FailsWithWrongSigner() public {
        bytes memory wrongSignature = _signEthSignedHash(txIdHash, wrongSignerPk);

        bool isValid = verifier.verify(txIdHash, signerAuthAccount, wrongSignature);
        assertFalse(isValid, "Verification should fail when signature is from a different key");
    }

    function test_verify_FailsWithInvalidSignerIdLength() public {
        AuthAccount.Data memory invalidSigner =
            AuthAccount.Data({id: bytes("not-20-bytes-long"), auth_type: dummyAuthType});

        bytes memory signature = _signEthSignedHash(txIdHash, signerPk);

        bool isValid = verifier.verify(txIdHash, invalidSigner, signature);
        assertFalse(isValid, "Verification should fail if signer.id length is not 20");
    }

    function test_verify_FailsWhenWrongHashSigned() public {
        bytes memory signatureOnWrongHash = _signEthSignedHash(wrongTxIdHash, signerPk);

        bool isValid = verifier.verify(txIdHash, signerAuthAccount, signatureOnWrongHash);
        assertFalse(isValid, "Verification should fail when signature is for a different hash");
    }

    function test_verify_FailsWhenRawHashSigned() public {
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(signerPk, txIdHash);
        bytes memory rawSignature = abi.encodePacked(r, s, v);

        bool isValid = verifier.verify(txIdHash, signerAuthAccount, rawSignature);
        assertFalse(isValid, "Verification should fail when signing raw hash instead of EIP-191 hash");
    }

    function test_verify_FailsWithMalformedSignature() public {
        bytes memory malformedSignature = bytes("not a valid signature");

        bool isValid = verifier.verify(txIdHash, signerAuthAccount, malformedSignature);
        assertFalse(isValid, "Verification should fail with a malformed signature");
    }

    function test_verify_RevertWith_SignatureWithInvalidV() public {
        bytes memory signature = _signEthSignedHash(txIdHash, signerPk);
        bytes memory invalidVSignature = new bytes(65);
        for (uint256 i = 0; i < 64; ++i) {
            invalidVSignature[i] = signature[i];
        }
        invalidVSignature[64] = bytes1(uint8(0)); // Set invalid v

        vm.expectRevert(ECDSA.ECDSAInvalidSignature.selector);
        verifier.verify(txIdHash, signerAuthAccount, invalidVSignature);
    }
}
