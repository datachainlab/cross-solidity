// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.6.8;
pragma experimental ABIEncoderV2;

import "./PacketHandler.sol";

interface IContractModule {
    function onContractCall(CommitMode commitMode, bytes calldata callInfo) external returns (bytes memory);
}
