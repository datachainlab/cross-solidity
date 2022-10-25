// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
pragma experimental ABIEncoderV2;

import "./PacketHandler.sol";
import "./types/Auth.sol";

// IContractModule defines the expected interface of a contract module on Cross Framework
interface IContractModule {
    // onContractCall is a callback function that is called at the commit(simple-commit) phase
    function onContractCall(CrossContext calldata context, bytes calldata callInfo) external returns (bytes memory);

    // // onContractPrepare is a callback function that is called at the prepare(2pc) phase
    // function onContractPrepare(CrossContext calldata context, bytes calldata callInfo) external returns (bytes memory);

    // // onCommit is a callback function that is called at the commit(2pc) phase
    // // It is expected that it commits the changes in the contract module
    // function onCommit(CrossContext calldata context) external;

    // // onAbort is a callback function that is called at the commit(2pc) phase
    // // It is expected that it aborts the changes in the contract module
    // function onAbort(CrossContext calldata context) external;
}

// CrossContext is a context in cross-chain transaction
struct CrossContext {
    bytes tx_id;
    uint8 tx_index;
    Account.Data[] signers;
}
