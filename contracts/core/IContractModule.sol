// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.6.8;
pragma experimental ABIEncoderV2;

import "./PacketHandler.sol";

struct CrossContext {
    CommitMode commitMode;
    bytes tx_id;
    uint8 tx_index;
    bytes[] signers;
}

interface IContractModule {
    function onContractCall(CrossContext calldata context, bytes calldata callInfo) external returns (bytes memory);
}
