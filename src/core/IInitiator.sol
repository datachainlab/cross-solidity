// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {MsgInitiateTx, MsgInitiateTxResponse, QuerySelfXCCResponse} from "../proto/cross/core/initiator/Initiator.sol";

interface IInitiator {
    event TxInitiated(bytes txId, address proposer);

    function initiateTx(MsgInitiateTx.Data calldata msg_) external returns (MsgInitiateTxResponse.Data memory resp);

    function selfXCC() external view returns (QuerySelfXCCResponse.Data memory resp);
}
