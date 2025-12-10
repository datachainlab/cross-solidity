// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ContractModuleBase} from "../core/ContractModuleBase.sol";
import {CrossContext} from "../core/IContractModule.sol";

abstract contract ERC20TransferModule is Initializable, ContractModuleBase, Ownable {
    using SafeERC20 for IERC20;

    error ERC20TransferModuleInvalidCallInfo();
    error ERC20TransferModuleTxAlreadyPending();
    error ERC20TransferModuleUnauthorized();
    error ERC20TransferModuleNotInitialized();
    error ERC20TransferModuleInvalidAddress();

    struct PendingTx {
        address from;
        address to;
        uint256 amount;
    }

    // txID => PendingTx
    mapping(bytes32 => PendingTx) public pendingTxs;

    address public crossModule;
    IERC20 public token;

    constructor() Ownable(msg.sender) {}

    modifier onlyCrossModule() {
        if (crossModule == address(0)) revert ERC20TransferModuleNotInitialized();
        if (msg.sender != crossModule) revert ERC20TransferModuleUnauthorized();
        _;
    }

    function initialize(address _crossModule, address _token) external initializer onlyOwner {
        if (_crossModule == address(0) || _token == address(0)) {
            revert ERC20TransferModuleInvalidAddress();
        }
        crossModule = _crossModule;
        token = IERC20(_token);
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
        token.safeTransferFrom(from, to, amount);

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
        token.safeTransferFrom(from, address(this), amount);

        return "";
    }

    function onCommit(CrossContext calldata context) external virtual override onlyCrossModule {
        bytes32 txID = abi.decode(context.txID, (bytes32));
        PendingTx memory pending = pendingTxs[txID];

        if (pending.from != address(0)) {
            delete pendingTxs[txID];
            // Transfer locked tokens to the destination
            token.safeTransfer(pending.to, pending.amount);
        }
    }

    function onAbort(CrossContext calldata context) external virtual override onlyCrossModule {
        bytes32 txID = abi.decode(context.txID, (bytes32));
        PendingTx memory pending = pendingTxs[txID];

        if (pending.from != address(0)) {
            delete pendingTxs[txID];
            // Refund tokens to the sender
            token.safeTransfer(pending.from, pending.amount);
        }
    }
}
