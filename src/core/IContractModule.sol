// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "../proto/cross/core/auth/Auth.sol";

// IContractModule defines the expected interface of a contract module on Cross Framework
interface IContractModule {
    // onContractCommitImmediately is a callback function that is called on the participant chain to execute the transaction logic immediately
    // This function is intended to be used only in the simple-commit protocol
    function onContractCommitImmediately(CrossContext calldata context, bytes calldata callInfo)
        external
        returns (bytes memory);

    // onContractPrepare is a callback function that is called at the prepare(2pc) phase
    function onContractPrepare(CrossContext calldata context, bytes calldata callInfo) external returns (bytes memory);

    // // onCommit is a callback function that is called at the commit(2pc) phase
    // It is expected that it commits the changes in the contract module
    // IMPORTANT: This function MUST NOT revert.
    function onCommit(CrossContext calldata context) external;

    // onAbort is a callback function that is called at the commit(2pc) phase
    // It is expected that it aborts the changes in the contract module
    // IMPORTANT: This function MUST NOT revert.
    function onAbort(CrossContext calldata context) external;
}

// CrossContext is a context in cross-chain transaction
struct CrossContext {
    bytes txID;
    uint8 txIndex;
    Account.Data[] signers;
}
