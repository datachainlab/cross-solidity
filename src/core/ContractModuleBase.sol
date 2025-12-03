// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {IContractModule, CrossContext} from "./IContractModule.sol";

abstract contract ContractModuleBase is IContractModule {
    function onContractCommitImmediately(CrossContext calldata context, bytes calldata callInfo)
        external
        override
        returns (bytes memory)
    {
        _authorize(context, callInfo);
        return _onContractCommitImmediately(context, callInfo);
    }

    function onContractPrepare(CrossContext calldata context, bytes calldata callInfo)
        external
        override
        returns (bytes memory)
    {
        _authorize(context, callInfo);
        return _onContractPrepare(context, callInfo);
    }

    function _authorize(CrossContext calldata context, bytes calldata callInfo) internal virtual;

    function _onContractCommitImmediately(CrossContext calldata context, bytes calldata callInfo)
        internal
        virtual
        returns (bytes memory);

    function _onContractPrepare(CrossContext calldata context, bytes calldata callInfo)
        internal
        virtual
        returns (bytes memory);
}
