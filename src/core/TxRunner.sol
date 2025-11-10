pragma solidity ^0.8.20;

import {TxRunnerBase} from "./TxRunnerBase.sol";
import {MsgInitiateTx} from "../proto/cross/core/initiator/Initiator.sol";
import {CoreStore} from "./CoreStore.sol";

abstract contract TxRunner is TxRunnerBase {
    function _runTx(bytes32, MsgInitiateTx.Data storage) internal virtual override {
        // ToDo: implement transaction execution logic
    }
}
