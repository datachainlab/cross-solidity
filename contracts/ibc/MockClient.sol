// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.9;
pragma experimental ABIEncoderV2;

import {
    MockClient as IBCMockClient
} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/MockClient.sol";

contract MockClient is IBCMockClient {}
