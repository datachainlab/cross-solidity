// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.6.8;
pragma experimental ABIEncoderV2;

import {
    MockClient as IBCMockClient
} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/MockClient.sol";

contract MockClient is IBCMockClient {}
