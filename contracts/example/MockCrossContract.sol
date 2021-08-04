// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.6.8;
pragma experimental ABIEncoderV2;

import "../core/IContractModule.sol";

contract MockCrossContract is IContractModule {
    function onContractCall(CrossContext calldata context, bytes calldata callInfo) external override returns (bytes memory) {
        require(callInfo.length == 1, "the length of callInfo must be 1");
        if (callInfo[0] == 0x01) {
            return bytes("mock call succeed");
        } else {
            revert("callInfo must be 0x01");
        }
    }
}
