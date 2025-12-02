// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {AuthType} from "../proto/cross/core/auth/Auth.sol";

interface ICrossEvent {
    event OnContractCommitImmediately(bytes indexed txID, uint8 indexed txIndex, bool indexed success, bytes ret);
    event OnCommit(bytes indexed txID, uint8 indexed txIndex);
    event OnAbort(bytes indexed txID, uint8 indexed txIndex);
    event TxSigned(address indexed signer, bytes32 indexed txID, AuthType.AuthMode method);
    event TxInitiated(bytes txID, address indexed proposer);
}
