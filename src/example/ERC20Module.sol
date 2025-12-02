// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ContractModuleBase} from "../core/ContractModuleBase.sol";
import {CrossContext} from "../core/IContractModule.sol";

abstract contract ERC20Module is ERC20, ContractModuleBase {
    error ERC20ModuleInvalidCallInfo();
    error ERC20ModuleSignerRequired();
    error ERC20ModuleInvalidSignerId();
    error ERC20ModuleTransferFromFailed();
    error ERC20ModuleTxAlreadyPending();

    struct PendingTx {
        address sender;
        address to;
        uint256 amount;
    }

    // txID => PendingTx
    mapping(bytes32 => PendingTx) public pendingTxs;

    function decodeCallInfo(bytes calldata callInfo) public pure virtual returns (address to, uint256 amount) {
        if (callInfo.length != 64) revert ERC20ModuleInvalidCallInfo();
        return abi.decode(callInfo, (address, uint256));
    }

    function _onContractCommitImmediately(CrossContext calldata context, bytes calldata callInfo)
        internal
        virtual
        override
        returns (bytes memory)
    {
        (address to, uint256 amount) = decodeCallInfo(callInfo);

        if (context.signers.length == 0) revert ERC20ModuleSignerRequired();

        bytes memory signerId = context.signers[0].id;
        if (signerId.length != 20) revert ERC20ModuleInvalidSignerId();
        address sender = address(bytes20(signerId));

        // Directly transfer tokens from sender to recipient
        // NOTE: The sender must have approved the caller (e.g., CrossModule) to spend the tokens.
        bool success = transferFrom(sender, to, amount);
        if (!success) revert ERC20ModuleTransferFromFailed();

        return "";
    }

    function _onContractPrepare(CrossContext calldata context, bytes calldata callInfo)
        internal
        virtual
        override
        returns (bytes memory)
    {
        bytes32 txID = abi.decode(context.txID, (bytes32));
        if (pendingTxs[txID].sender != address(0)) revert ERC20ModuleTxAlreadyPending();

        (address to, uint256 amount) = decodeCallInfo(callInfo);

        if (context.signers.length == 0) revert ERC20ModuleSignerRequired();

        bytes memory signerId = context.signers[0].id;

        if (signerId.length != 20) revert ERC20ModuleInvalidSignerId();

        address sender = address(bytes20(signerId));

        // Lock tokens by transferring from the sender to this contract
        // NOTE: The sender must have approved the caller (e.g., CrossModule) to spend the tokens.
        bool success = transferFrom(sender, address(this), amount);
        if (!success) revert ERC20ModuleTransferFromFailed();

        pendingTxs[txID] = PendingTx({sender: sender, to: to, amount: amount});

        return "";
    }

    function onCommit(CrossContext calldata context) external virtual override {
        bytes32 txID = abi.decode(context.txID, (bytes32));
        PendingTx memory pending = pendingTxs[txID];

        if (pending.sender != address(0)) {
            delete pendingTxs[txID];
            // Transfer locked tokens to the destination
            _transfer(address(this), pending.to, pending.amount);
        }
    }

    function onAbort(CrossContext calldata context) external virtual override {
        bytes32 txID = abi.decode(context.txID, (bytes32));
        PendingTx memory pending = pendingTxs[txID];

        if (pending.sender != address(0)) {
            delete pendingTxs[txID];
            // Refund tokens to the sender
            _transfer(address(this), pending.sender, pending.amount);
        }
    }
}
