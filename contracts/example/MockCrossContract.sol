// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
pragma experimental ABIEncoderV2;

import "../core/IContractModule.sol";
import "../core/types/Auth.sol";

contract MockCrossContract is IContractModule {
    function onContractCall(CrossContext calldata context, bytes calldata callInfo) external override returns (bytes memory) {
        require(context.signers.length == 1, "signers length must be 1");
        require(context.signers[0].auth_type.mode == AuthType.AuthMode.AUTH_MODE_CHANNEL, "auth mode must be CHANNEL");
        require(keccak256(context.signers[0].id) == keccak256(abi.encodePacked("tester")), "unexpected account ID");
        require(callInfo.length == 1, "the length of callInfo must be 1");
        if (callInfo[0] == 0x01) {
            return bytes("mock call succeed");
        } else {
            revert("callInfo must be 0x01");
        }
    }
}
