// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";

import "../src/example/MockCrossContract.sol";
import "../src/core/IContractModule.sol";

import {Account as AuthAccount, AuthType} from "../src/proto/cross/core/auth/Auth.sol";
import {GoogleProtobufAny as Any} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";

contract MockCrossContractTest is Test {
    MockCrossContract private mock;

    function setUp() public {
        mock = new MockCrossContract();
    }

    function _mkSigner(bytes memory id, AuthType.AuthMode mode) internal pure returns (AuthAccount.Data memory s) {
        Any.Data memory emptyOpt = Any.Data({type_url: "", value: ""});
        AuthType.Data memory at = AuthType.Data({mode: mode, option: emptyOpt});
        s = AuthAccount.Data({id: id, auth_type: at});
    }

    function _mkContextSingle(bytes memory id, AuthType.AuthMode mode) internal pure returns (CrossContext memory ctx) {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](1);
        signers[0] = _mkSigner(id, mode);

        ctx = CrossContext({txId: hex"11", txIndex: 1, signers: signers});
    }

    function test_onContractCall_ReturnsExpectedBytes() public {
        CrossContext memory ctx = _mkContextSingle(bytes("tester"), AuthType.AuthMode.AUTH_MODE_CHANNEL);
        bytes memory callInfo = hex"01";

        bytes memory ret = mock.onContractCall(ctx, callInfo);

        assertEq(ret, bytes("mock call succeed"));
    }

    function test_onContractCall_RevertWhen_SignersLenIsZero() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](0);
        CrossContext memory ctx = CrossContext({txId: hex"22", txIndex: 1, signers: signers});

        vm.expectRevert(bytes("signers length must be 1"));
        mock.onContractCall(ctx, hex"01");
    }

    function test_onContractCall_RevertWhen_SignersLenIsTwo() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](2);
        signers[0] = _mkSigner(bytes("tester"), AuthType.AuthMode.AUTH_MODE_CHANNEL);
        signers[1] = _mkSigner(bytes("tester"), AuthType.AuthMode.AUTH_MODE_CHANNEL);

        CrossContext memory ctx = CrossContext({txId: hex"33", txIndex: 1, signers: signers});

        vm.expectRevert(bytes("signers length must be 1"));
        mock.onContractCall(ctx, hex"01");
    }

    function test_onContractCall_RevertWhen_AuthModeIsNotChannel() public {
        CrossContext memory ctx = _mkContextSingle(bytes("tester"), AuthType.AuthMode.AUTH_MODE_EXTENSION);

        vm.expectRevert(bytes("auth mode must be CHANNEL"));
        mock.onContractCall(ctx, hex"01");
    }

    function test_onContractCall_RevertWhen_UnexpectedAccountId() public {
        CrossContext memory ctx = _mkContextSingle(bytes("hacker"), AuthType.AuthMode.AUTH_MODE_CHANNEL);

        vm.expectRevert(bytes("unexpected account ID"));
        mock.onContractCall(ctx, hex"01");
    }

    function test_onContractCall_RevertWhen_CallInfoLenIsZero() public {
        CrossContext memory ctx = _mkContextSingle(bytes("tester"), AuthType.AuthMode.AUTH_MODE_CHANNEL);

        vm.expectRevert(bytes("the length of callInfo must be 1"));
        mock.onContractCall(ctx, bytes(""));
    }

    function test_onContractCall_RevertWhen_CallInfoLenIsTwo() public {
        CrossContext memory ctx = _mkContextSingle(bytes("tester"), AuthType.AuthMode.AUTH_MODE_CHANNEL);

        bytes memory callInfo = new bytes(2);
        callInfo[0] = 0x01;
        callInfo[1] = 0x02;

        vm.expectRevert(bytes("the length of callInfo must be 1"));
        mock.onContractCall(ctx, callInfo);
    }

    function test_onContractCall_RevertWhen_CallInfoIsNot0x01() public {
        CrossContext memory ctx = _mkContextSingle(bytes("tester"), AuthType.AuthMode.AUTH_MODE_CHANNEL);

        vm.expectRevert(bytes("callInfo must be 0x01"));
        mock.onContractCall(ctx, hex"02");
    }
}
