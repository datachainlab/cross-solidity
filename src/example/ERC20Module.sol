// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ContractModuleBase} from "../core/ContractModuleBase.sol";
import {CrossContext} from "../core/IContractModule.sol";

abstract contract ERC20Module is ERC20, ContractModuleBase {
    error ERC20ModuleInvalidCallInfo();
    error ERC20ModuleTransferFromFailed();
    error ERC20ModuleTxAlreadyPending();
    error ERC20ModuleUnauthorized();

    struct PendingTx {
        address from;
        address to;
        uint256 amount;
    }

    // txID => PendingTx
    mapping(bytes32 => PendingTx) public pendingTxs;
    address public immutable CROSS_MODULE;

    modifier onlyCrossModule() {
        if (msg.sender != CROSS_MODULE) revert ERC20ModuleUnauthorized();
        _;
    }

    constructor(address _crossModule) {
        CROSS_MODULE = _crossModule;
    }

    function decodeCallInfo(bytes calldata callInfo)
        public
        pure
        virtual
        returns (address from, address to, uint256 amount)
    {
        if (callInfo.length != 96) revert ERC20ModuleInvalidCallInfo();
        return abi.decode(callInfo, (address, address, uint256));
    }

    function _onContractCommitImmediately(
        CrossContext calldata,
        /*context*/
        bytes calldata callInfo
    )
        internal
        virtual
        override
        onlyCrossModule
        returns (bytes memory)
    {
        (address from, address to, uint256 amount) = decodeCallInfo(callInfo);

        // Directly transfer tokens from sender to recipient
        // NOTE: The sender must have approved the caller (e.g., CrossModule) to spend the tokens.
        bool success = transferFrom(from, to, amount);
        if (!success) revert ERC20ModuleTransferFromFailed();

        return "";
    }

    function _onContractPrepare(CrossContext calldata context, bytes calldata callInfo)
        internal
        virtual
        override
        onlyCrossModule
        returns (bytes memory)
    {
        bytes32 txID = abi.decode(context.txID, (bytes32));
        if (pendingTxs[txID].from != address(0)) revert ERC20ModuleTxAlreadyPending();

        (address from, address to, uint256 amount) = decodeCallInfo(callInfo);

        // Lock tokens by transferring from the sender to this contract
        // NOTE: The sender must have approved the caller (e.g., CrossModule) to spend the tokens.
        bool success = transferFrom(from, address(this), amount);
        if (!success) revert ERC20ModuleTransferFromFailed();

        pendingTxs[txID] = PendingTx({from: from, to: to, amount: amount});

        return "";
    }

    function onCommit(CrossContext calldata context) external virtual override onlyCrossModule {
        bytes32 txID = abi.decode(context.txID, (bytes32));
        PendingTx memory pending = pendingTxs[txID];

        if (pending.from != address(0)) {
            delete pendingTxs[txID];
            // Transfer locked tokens to the destination
            _transfer(address(this), pending.to, pending.amount);
        }
    }

    function onAbort(CrossContext calldata context) external virtual override onlyCrossModule {
        bytes32 txID = abi.decode(context.txID, (bytes32));
        PendingTx memory pending = pendingTxs[txID];

        if (pending.from != address(0)) {
            delete pendingTxs[txID];
            // Refund tokens to the sender
            _transfer(address(this), pending.from, pending.amount);
        }
    }
}
