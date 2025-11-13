// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {TxAuthManagerBase} from "./TxAuthManagerBase.sol";
import {TxManagerBase} from "./TxManagerBase.sol";
import {ITxAuthManager} from "./ITxAuthManager.sol";
import {ITxManager} from "./ITxManager.sol";

import {MsgInitiateTx} from "../proto/cross/core/initiator/Initiator.sol";
import {Account, TxAuthState} from "../proto/cross/core/auth/Auth.sol";

abstract contract DelegatedLogicHandler is TxAuthManagerBase, TxManagerBase {
    address public immutable TX_AUTH_MANAGER;
    address public immutable TX_MANAGER;

    error DelegateCallAuthFailed();
    error DelegateCallTxFailed();
    error StaticCallAuthFailed();
    error StaticCallTxFailed();

    constructor(address txAuthManager_, address txManager_) {
        TX_AUTH_MANAGER = txAuthManager_;
        TX_MANAGER = txManager_;
    }

    function _initAuthState(bytes32 txID, Account.Data[] memory signers) internal virtual override {
        (bool success,) =
            TX_AUTH_MANAGER.delegatecall(abi.encodeWithSelector(ITxAuthManager.initAuthState.selector, txID, signers));
        if (!success) revert DelegateCallAuthFailed();
    }

    function _sign(bytes32 txID, Account.Data[] memory signers) internal virtual override returns (bool) {
        (bool success, bytes memory ret) =
            TX_AUTH_MANAGER.delegatecall(abi.encodeWithSelector(ITxAuthManager.sign.selector, txID, signers));
        if (!success) revert DelegateCallAuthFailed();
        return abi.decode(ret, (bool));
    }

    function _isCompletedAuth(bytes32 txID) internal view virtual override returns (bool) {
        (bool success, bytes memory ret) =
            TX_AUTH_MANAGER.staticcall(abi.encodeWithSelector(ITxAuthManager.isCompletedAuth.selector, txID));
        if (!success) revert StaticCallAuthFailed();
        return abi.decode(ret, (bool));
    }

    function _getAuthState(bytes32 txID) internal view virtual override returns (TxAuthState.Data memory) {
        (bool success, bytes memory ret) =
            TX_AUTH_MANAGER.staticcall(abi.encodeWithSelector(ITxAuthManager.getAuthState.selector, txID));
        if (!success) revert StaticCallAuthFailed();
        return abi.decode(ret, (TxAuthState.Data));
    }

    function _createTx(bytes32 txID, MsgInitiateTx.Data calldata src) internal virtual override {
        (bool success,) = TX_MANAGER.delegatecall(abi.encodeWithSelector(ITxManager.createTx.selector, txID, src));
        if (!success) revert DelegateCallTxFailed();
    }

    function _runTxIfCompleted(bytes32 txID) internal virtual override {
        (bool success,) = TX_MANAGER.delegatecall(abi.encodeWithSelector(ITxManager.runTxIfCompleted.selector, txID));
        if (!success) revert DelegateCallTxFailed();
    }

    function _isTxRecorded(bytes32 txID) internal view virtual override returns (bool) {
        (bool success, bytes memory ret) =
            TX_MANAGER.staticcall(abi.encodeWithSelector(ITxManager.isTxRecorded.selector, txID));
        if (!success) revert StaticCallTxFailed();
        return abi.decode(ret, (bool));
    }
}
