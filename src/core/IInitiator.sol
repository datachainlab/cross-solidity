// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {MsgInitiateTx, MsgInitiateTxResponse, QuerySelfXCCResponse} from "../proto/cross/core/initiator/Initiator.sol";

interface IInitiator {
    error UnexpectedChainId(bytes32 expectedHash, bytes32 gotHash);
    error MessageTimeoutHeight(uint256 blockNumber, uint64 timeoutVersionHeight);
    error MessageTimeoutTimestamp(uint256 blockTimestamp, uint64 timeoutTimestamp);
    error TxIDAlreadyExists(bytes32 txIdHash);
    error SelfXCCNotImplemented();

    event TxInitiated(bytes txId, address indexed proposer);

    function initiateTx(MsgInitiateTx.Data calldata msg_) external returns (MsgInitiateTxResponse.Data memory resp);

    function selfXCC() external view returns (QuerySelfXCCResponse.Data memory resp);
}
