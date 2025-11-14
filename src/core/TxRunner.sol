pragma solidity ^0.8.20;

import {TxRunnerBase} from "./TxRunnerBase.sol";
import {ICrossError} from "./ICrossError.sol";
import {MsgInitiateTx} from "../proto/cross/core/initiator/Initiator.sol";

abstract contract TxRunner is TxRunnerBase, ICrossError {
    function _runTx(bytes32, MsgInitiateTx.Data storage) internal virtual override {
        // ToDo: implement transaction execution logic
        revert TxRunNotImplemented();
    }
}
