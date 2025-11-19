// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

interface ICrossError {
    error DelegateCallFailed(address target);
    error UnexpectedChainID(bytes32 expectedHash, bytes32 gotHash);
    error MessageTimeoutHeight(uint256 blockNumber, uint64 timeoutVersionHeight);
    error MessageTimeoutTimestamp(uint256 blockTimestamp, uint64 timeoutTimestamp);
    error TxIDAlreadyExists(bytes32 txIDHash);
    error AuthStateAlreadyInitialized(bytes32 txID);
    error IDNotFound(bytes32 txID);
    error InvalidSignersLength();
    error InvalidTxIDLength();
    error SignerMustEqualSender();
    error AuthAlreadyCompleted(bytes32 txID);
    error TxAlreadyExists(bytes32 txID);
    error TxAlreadyVerified(bytes32 txID);
    error CoordinatorStateNotFound(bytes32 txID);
    error TxRunNotImplemented();
    error ExtSignTxNotImplemented();
    error TxAuthStateNotImplemented();
    error ModuleAlreadyInitialized();
    error ModuleNotInitialized();
    error PayloadDecodeFailed();
    error UnexpectedTypeURL();
    error NotImplemented();
}
