// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ContractModuleBase} from "../core/ContractModuleBase.sol";
import {CrossContext} from "../core/IContractModule.sol";

abstract contract ERC20TransferModule is ContractModuleBase {
    using SafeERC20 for IERC20;

    error ERC20TransferModuleInvalidCallInfo();
    error ERC20TransferModuleTxAlreadyPending();
    error ERC20TransferModuleUnauthorized();

    struct PendingTx {
        address from;
        address to;
        uint256 amount;
    }

    // txID => PendingTx
    mapping(bytes32 => PendingTx) public pendingTxs;

    address public immutable CROSS_MODULE;
    IERC20 public immutable TOKEN;

    modifier onlyCrossModule() {
        if (msg.sender != CROSS_MODULE) revert ERC20TransferModuleUnauthorized();
        _;
    }

    constructor(address _crossModule, address _token) {
        CROSS_MODULE = _crossModule;
        TOKEN = IERC20(_token);
    }

    function decodeCallInfo(bytes calldata callInfo)
        public
        pure
        virtual
        returns (address from, address to, uint256 amount)
    {
        if (callInfo.length != 96) revert ERC20TransferModuleInvalidCallInfo();
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

        // IMPORTANT: The implementing contract MUST ensure in `_authorize` that the `from` address corresponds to the authenticated signer.
        // slither-disable-next-line arbitrary-send-erc20
        TOKEN.safeTransferFrom(from, to, amount);

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

        if (pendingTxs[txID].from != address(0)) revert ERC20TransferModuleTxAlreadyPending();

        (address from, address to, uint256 amount) = decodeCallInfo(callInfo);

        pendingTxs[txID] = PendingTx({from: from, to: to, amount: amount});

        // IMPORTANT: The implementing contract MUST ensure in `_authorize` that the `from` address corresponds to the authenticated signer.
        // slither-disable-next-line arbitrary-send-erc20
        TOKEN.safeTransferFrom(from, address(this), amount);

        return "";
    }

    function onCommit(CrossContext calldata context) external virtual override onlyCrossModule {
        bytes32 txID = abi.decode(context.txID, (bytes32));
        PendingTx memory pending = pendingTxs[txID];

        if (pending.from != address(0)) {
            delete pendingTxs[txID];
            // Transfer locked tokens to the destination
            TOKEN.safeTransfer(pending.to, pending.amount);
        }
    }

    function onAbort(CrossContext calldata context) external virtual override onlyCrossModule {
        bytes32 txID = abi.decode(context.txID, (bytes32));
        PendingTx memory pending = pendingTxs[txID];

        if (pending.from != address(0)) {
            delete pendingTxs[txID];
            // Refund tokens to the sender
            TOKEN.safeTransfer(pending.from, pending.amount);
        }
    }
}
