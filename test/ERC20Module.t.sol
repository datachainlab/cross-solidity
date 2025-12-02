// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase, gas-small-strings
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";
import {ERC20Module} from "../src/example/ERC20Module.sol";
import {CrossContext} from "../src/core/IContractModule.sol";
import {Account as AuthAccount, AuthType, GoogleProtobufAny} from "../src/proto/cross/core/auth/Auth.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";

contract ERC20ModuleHarness is ERC20Module {
    constructor() ERC20("Test Token", "TST") {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function _authorize(CrossContext calldata, bytes calldata) internal pure override {
        // allow all for testing
    }
}

contract ERC20ModuleTest is Test {
    ERC20ModuleHarness private harness;

    address private sender;
    address private receiver;
    bytes32 private constant TX_ID_RAW = keccak256("test_tx");
    bytes private txID;

    uint256 private constant AMOUNT = 100 ether;
    uint256 private constant INITIAL_BALANCE = 1000 ether;

    function setUp() public {
        harness = new ERC20ModuleHarness();
        sender = makeAddr("sender");
        receiver = makeAddr("receiver");
        txID = abi.encode(TX_ID_RAW);

        harness.mint(sender, INITIAL_BALANCE);
    }

    // --- Helper Functions ---

    function _createContext(address _signer) internal view returns (CrossContext memory) {
        AuthAccount.Data[] memory signers;

        if (_signer != address(0)) {
            signers = new AuthAccount.Data[](1);
            signers[0] = AuthAccount.Data({
                id: abi.encodePacked(_signer),
                auth_type: AuthType.Data({
                    mode: AuthType.AuthMode.AUTH_MODE_LOCAL, option: GoogleProtobufAny.Data({type_url: "", value: ""})
                })
            });
        } else {
            signers = new AuthAccount.Data[](0);
        }

        return CrossContext({txID: txID, txIndex: 0, signers: signers});
    }

    function _createCallInfo(address _to, uint256 _amount) internal pure returns (bytes memory) {
        return abi.encode(_to, _amount);
    }

    // --- Decode Tests ---

    function test_decodeCallInfo_Success() public view {
        bytes memory callInfo = _createCallInfo(receiver, AMOUNT);
        (address to, uint256 amount) = harness.decodeCallInfo(callInfo);

        assertEq(to, receiver);
        assertEq(amount, AMOUNT);
    }

    function test_decodeCallInfo_RevertWhen_InvalidLength() public {
        bytes memory invalidCallInfo = abi.encode(receiver);

        vm.expectRevert(ERC20Module.ERC20ModuleInvalidCallInfo.selector);
        harness.decodeCallInfo(invalidCallInfo);
    }

    // --- Immediate Commit Tests ---

    function test_onContractCommitImmediately_Success() public {
        CrossContext memory context = _createContext(sender);
        bytes memory callInfo = _createCallInfo(receiver, AMOUNT);

        uint256 senderPreBalance = harness.balanceOf(sender);
        uint256 receiverPreBalance = harness.balanceOf(receiver);

        vm.prank(sender);
        harness.approve(address(this), AMOUNT);

        harness.onContractCommitImmediately(context, callInfo);

        assertEq(harness.balanceOf(sender), senderPreBalance - AMOUNT);
        assertEq(harness.balanceOf(receiver), receiverPreBalance + AMOUNT);
        assertEq(harness.balanceOf(address(harness)), 0);
    }

    function test_onContractCommitImmediately_RevertWhen_InsufficientAllowance() public {
        CrossContext memory context = _createContext(sender);
        bytes memory callInfo = _createCallInfo(receiver, AMOUNT);

        // Do not approve, so allowance is zero
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Errors.ERC20InsufficientAllowance.selector,
                address(this), // spender
                0, // allowance
                AMOUNT // needed
            )
        );
        harness.onContractCommitImmediately(context, callInfo);
    }

    function test_onContractCommitImmediately_RevertWhen_NoSigner() public {
        CrossContext memory context = _createContext(address(0));
        bytes memory callInfo = _createCallInfo(receiver, AMOUNT);

        vm.expectRevert(ERC20Module.ERC20ModuleSignerRequired.selector);
        harness.onContractCommitImmediately(context, callInfo);
    }

    function test_onContractCommitImmediately_RevertWhen_InvalidSignerId() public {
        AuthAccount.Data[] memory signers = new AuthAccount.Data[](1);
        signers[0] = AuthAccount.Data({
            id: bytes("invalid_len"),
            auth_type: AuthType.Data({
                mode: AuthType.AuthMode.AUTH_MODE_LOCAL, option: GoogleProtobufAny.Data({type_url: "", value: ""})
            })
        });

        CrossContext memory context = CrossContext({txID: txID, txIndex: 0, signers: signers});
        bytes memory callInfo = _createCallInfo(receiver, AMOUNT);

        vm.expectRevert(ERC20Module.ERC20ModuleInvalidSignerId.selector);
        harness.onContractCommitImmediately(context, callInfo);
    }

    // --- Prepare Tests ---

    function test_onContractPrepare_Success() public {
        CrossContext memory context = _createContext(sender);
        bytes memory callInfo = _createCallInfo(receiver, AMOUNT);

        vm.prank(sender);
        harness.approve(address(this), AMOUNT);

        harness.onContractPrepare(context, callInfo);

        assertEq(harness.balanceOf(sender), INITIAL_BALANCE - AMOUNT, "Sender balance should decrease");
        assertEq(harness.balanceOf(address(harness)), AMOUNT, "Module should hold locked tokens");

        (address pendingSender, address pendingTo, uint256 pendingAmount) = harness.pendingTxs(TX_ID_RAW);
        assertEq(pendingSender, sender);
        assertEq(pendingTo, receiver);
        assertEq(pendingAmount, AMOUNT);
    }

    function test_onContractPrepare_RevertWhen_InsufficientAllowance() public {
        CrossContext memory context = _createContext(sender);
        bytes memory callInfo = _createCallInfo(receiver, AMOUNT);

        // Do not approve, so allowance is zero
        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Errors.ERC20InsufficientAllowance.selector,
                address(this), // spender
                0, // allowance
                AMOUNT // needed
            )
        );
        harness.onContractPrepare(context, callInfo);
    }

    function test_onContractPrepare_RevertWhen_InsufficientBalance() public {
        uint256 tooMuchAmount = INITIAL_BALANCE + 1;
        CrossContext memory context = _createContext(sender);
        bytes memory callInfo = _createCallInfo(receiver, tooMuchAmount);

        vm.prank(sender);
        harness.approve(address(this), tooMuchAmount);

        vm.expectRevert(
            abi.encodeWithSelector(
                IERC20Errors.ERC20InsufficientBalance.selector,
                sender, // sender
                INITIAL_BALANCE, // balance
                tooMuchAmount // needed
            )
        );
        harness.onContractPrepare(context, callInfo);
    }

    function test_onContractPrepare_RevertWhen_NoSigner() public {
        CrossContext memory context = _createContext(address(0));
        bytes memory callInfo = _createCallInfo(receiver, AMOUNT);

        vm.expectRevert(ERC20Module.ERC20ModuleSignerRequired.selector);
        harness.onContractPrepare(context, callInfo);
    }

    function test_onContractPrepare_RevertWhen_TxAlreadyPending() public {
        CrossContext memory context = _createContext(sender);
        bytes memory callInfo = _createCallInfo(receiver, AMOUNT);

        vm.prank(sender);
        harness.approve(address(this), AMOUNT * 2);

        harness.onContractPrepare(context, callInfo);

        (address pendingSender,,) = harness.pendingTxs(TX_ID_RAW);
        assertEq(pendingSender, sender);

        vm.expectRevert(ERC20Module.ERC20ModuleTxAlreadyPending.selector);
        harness.onContractPrepare(context, callInfo);
    }

    // --- Commit Tests ---

    function test_onCommit_Success() public {
        CrossContext memory context = _createContext(sender);
        bytes memory callInfo = _createCallInfo(receiver, AMOUNT);

        vm.prank(sender);
        harness.approve(address(this), AMOUNT);

        harness.onContractPrepare(context, callInfo);

        assertEq(harness.balanceOf(address(harness)), AMOUNT);

        harness.onCommit(context);

        assertEq(harness.balanceOf(address(harness)), 0, "Module should release tokens");
        assertEq(harness.balanceOf(receiver), AMOUNT, "Receiver should receive tokens");
        assertEq(harness.balanceOf(sender), INITIAL_BALANCE - AMOUNT, "Sender balance should decrease");

        (address pendingSender,,) = harness.pendingTxs(TX_ID_RAW);
        assertEq(pendingSender, address(0), "Pending state should be deleted");
    }

    function test_onCommit_DoNothingWhen_TxNotFound() public {
        bytes32 unknownTxIdRaw = keccak256("unknown");
        CrossContext memory context =
            CrossContext({txID: abi.encode(unknownTxIdRaw), txIndex: 0, signers: new AuthAccount.Data[](0)});

        harness.onCommit(context);

        assertEq(harness.balanceOf(address(harness)), 0);
        assertEq(harness.balanceOf(sender), INITIAL_BALANCE);
        assertEq(harness.balanceOf(receiver), 0);
    }

    // --- Abort Tests ---

    function test_onAbort_Success() public {
        CrossContext memory context = _createContext(sender);
        bytes memory callInfo = _createCallInfo(receiver, AMOUNT);

        vm.prank(sender);
        harness.approve(address(this), AMOUNT);

        harness.onContractPrepare(context, callInfo);

        uint256 senderBalanceAfterLock = harness.balanceOf(sender);

        assertEq(harness.balanceOf(address(harness)), AMOUNT);

        harness.onAbort(context);

        assertEq(harness.balanceOf(address(harness)), 0, "Module should release tokens");
        assertEq(harness.balanceOf(sender), senderBalanceAfterLock + AMOUNT, "Sender should be refunded");
        assertEq(harness.balanceOf(receiver), 0, "Receiver should not receive tokens");

        (address pendingSender,,) = harness.pendingTxs(TX_ID_RAW);
        assertEq(pendingSender, address(0), "Pending state should be deleted");
    }

    function test_onAbort_DoNothingWhen_TxNotFound() public {
        bytes32 unknownTxIdRaw = keccak256("unknown");
        CrossContext memory context =
            CrossContext({txID: abi.encode(unknownTxIdRaw), txIndex: 0, signers: new AuthAccount.Data[](0)});

        harness.onAbort(context);

        assertEq(harness.balanceOf(address(harness)), 0);
        assertEq(harness.balanceOf(sender), INITIAL_BALANCE);
        assertEq(harness.balanceOf(receiver), 0);
    }
}
