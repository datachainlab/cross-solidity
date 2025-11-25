// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

interface ICrossError {
    error DelegateCallFailed(address target);
    error StaticCallFailed();
    error UnauthorizedCaller(address caller);
    error UnexpectedChainID(bytes32 expectedHash, bytes32 gotHash);
    error MessageTimeoutHeight(uint256 blockNumber, uint64 timeoutVersionHeight);
    error MessageTimeoutTimestamp(uint256 blockTimestamp, uint64 timeoutTimestamp);
    error TxIDAlreadyExists(bytes32 txIDHash);
    error AuthStateAlreadyInitialized(bytes32 txID);
    error IDNotFound(bytes32 txID);
    error InvalidTxIDLength();
    error InvalidSignersLength();
    error SignerMustEqualSender();
    error AuthAlreadyCompleted(bytes32 txID);
    error TxAlreadyExists(bytes32 txID);
    error TxAlreadyVerified(bytes32 txID);
    error CoordinatorStateNotFound(bytes32 txID);
    error SignerCountMismatch(uint256 signerCount, uint256 signatureCount);
    error AuthModeMismatch();
    error VerifierNotFound(string typeUrl);
    error SignatureVerificationFailed(bytes32 txID);
    error ArrayLengthMismatch();
    error EmptyTypeUrl();
    error ZeroAddressVerifier();
    error VerifierReturnedFalse(bytes32 txIDHash, string typeUrl);
    error TooManySigners(uint256 got, uint256 maxAllowed);
    error TxRunNotImplemented();
    error ModuleAlreadyInitialized();
    error ModuleNotInitialized();
    error PayloadDecodeFailed();
    error UnexpectedTypeURL();
    error NotImplemented();
}
