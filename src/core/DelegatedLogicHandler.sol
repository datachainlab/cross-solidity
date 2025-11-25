// SPDX-License-Identifier: Apache-2.0
// solhint-disable avoid-low-level-calls,no-inline-assembly
pragma solidity ^0.8.20;

import {TxAuthManagerBase} from "./TxAuthManagerBase.sol";
import {TxManagerBase} from "./TxManagerBase.sol";
import {ITxAuthManager} from "./ITxAuthManager.sol";
import {ITxManager} from "./ITxManager.sol";
import {ICrossError} from "./ICrossError.sol";

import {MsgInitiateTx} from "../proto/cross/core/initiator/Initiator.sol";
import {Account, TxAuthState} from "../proto/cross/core/auth/Auth.sol";

abstract contract DelegatedLogicHandler is TxAuthManagerBase, TxManagerBase, ICrossError {
    address public immutable TX_AUTH_MANAGER;
    address public immutable TX_MANAGER;

    constructor(address txAuthManager_, address txManager_) {
        TX_AUTH_MANAGER = txAuthManager_;
        TX_MANAGER = txManager_;
    }

    function _initAuthState(bytes32 txID, Account.Data[] memory signers) internal virtual override {
        _delegateWithData(TX_AUTH_MANAGER, abi.encodeWithSelector(ITxAuthManager.initAuthState.selector, txID, signers));
    }

    function _sign(bytes32 txID, Account.Data[] memory signers) internal virtual override returns (bool) {
        bytes memory ret =
            _delegateWithData(TX_AUTH_MANAGER, abi.encodeWithSelector(ITxAuthManager.sign.selector, txID, signers));
        return abi.decode(ret, (bool));
    }

    function _isCompletedAuth(bytes32 txID) internal view virtual override returns (bool) {
        bytes memory ret = _staticCallSelf(abi.encodeWithSelector(this.__isCompletedAuth.selector, txID));
        return abi.decode(ret, (bool));
    }

    /**
     * @dev Internal function called via staticcall to read state via delegatecall.
     * * NOTE: Since this function is called via `address(this).staticcall`,
     * the `msg.sender` inside the delegated implementation (TxAuthManager)
     * will be THIS contract address, NOT the original caller.
     * Do not rely on `msg.sender` for access control in the implementation logic.
     */
    function __isCompletedAuth(bytes32 txID) external returns (bool) {
        if (msg.sender != address(this)) revert UnauthorizedCaller(msg.sender);
        bytes memory ret =
            _delegateWithData(TX_AUTH_MANAGER, abi.encodeWithSelector(ITxAuthManager.isCompletedAuth.selector, txID));
        return abi.decode(ret, (bool));
    }

    function _getAuthState(bytes32 txID) internal view virtual override returns (TxAuthState.Data memory) {
        bytes memory ret = _staticCallSelf(abi.encodeWithSelector(this.__getAuthState.selector, txID));
        return abi.decode(ret, (TxAuthState.Data));
    }

    /**
     * @dev Internal function called via staticcall to read state via delegatecall.
     * * NOTE: Since this function is called via `address(this).staticcall`,
     * the `msg.sender` inside the delegated implementation (TxAuthManager)
     * will be THIS contract address, NOT the original caller.
     * Do not rely on `msg.sender` for access control in the implementation logic.
     */
    function __getAuthState(bytes32 txID) external returns (TxAuthState.Data memory) {
        if (msg.sender != address(this)) revert UnauthorizedCaller(msg.sender);
        bytes memory ret =
            _delegateWithData(TX_AUTH_MANAGER, abi.encodeWithSelector(ITxAuthManager.getAuthState.selector, txID));
        return abi.decode(ret, (TxAuthState.Data));
    }

    function _verifySignatures(bytes32 txIDHash, Account.Data[] calldata signers) internal virtual override {
        _delegateWithData(
            TX_AUTH_MANAGER, abi.encodeWithSelector(ITxAuthManager.verifySignatures.selector, txIDHash, signers)
        );
    }

    function _createTx(bytes32 txID, MsgInitiateTx.Data calldata src) internal virtual override {
        _delegateWithData(TX_MANAGER, abi.encodeWithSelector(ITxManager.createTx.selector, txID, src));
    }

    function _runTxIfCompleted(bytes32 txID) internal virtual override {
        _delegateWithData(TX_MANAGER, abi.encodeWithSelector(ITxManager.runTxIfCompleted.selector, txID));
    }

    function _isTxRecorded(bytes32 txID) internal view virtual override returns (bool) {
        bytes memory ret = _staticCallSelf(abi.encodeWithSelector(this.__isTxRecorded.selector, txID));
        return abi.decode(ret, (bool));
    }

    /**
     * @dev Internal function called via staticcall to read state via delegatecall.
     * * NOTE: Since this function is called via `address(this).staticcall`,
     * the `msg.sender` inside the delegated implementation (TxManager)
     * will be THIS contract address, NOT the original caller.
     * Do not rely on `msg.sender` for access control in the implementation logic.
     */
    function __isTxRecorded(bytes32 txID) external returns (bool) {
        if (msg.sender != address(this)) revert UnauthorizedCaller(msg.sender);
        bytes memory ret = _delegateWithData(TX_MANAGER, abi.encodeWithSelector(ITxManager.isTxRecorded.selector, txID));
        return abi.decode(ret, (bool));
    }

    function _delegateWithData(address impl, bytes memory data) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = impl.delegatecall(data);
        if (!success) {
            if (returndata.length > 0) {
                // bubble up the revert reason from the callee
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                // no revert data from callee (e.g. out-of-gas in callee or explicit revert() without reason)
                revert DelegateCallFailed(impl);
            }
        }
        return returndata;
    }

    function _staticCallSelf(bytes memory callData) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = address(this).staticcall(callData);
        if (!success) {
            if (returndata.length > 0) {
                // bubble up the revert reason from the callee
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                // no revert data from callee (e.g. out-of-gas in callee or explicit revert() without reason)
                revert StaticCallFailed();
            }
        }
        return returndata;
    }
}
