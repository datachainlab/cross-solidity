// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase, gas-small-strings
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";
import "../src/core/Initiator.sol";
import {TxManagerBase} from "../src/core/TxManagerBase.sol";
import {TxAuthManagerBase} from "../src/core/TxAuthManagerBase.sol";
import {ICrossEvent} from "../src/core/ICrossEvent.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

import {
    MsgInitiateTx,
    MsgInitiateTxResponse,
    ContractTransaction,
    QuerySelfXCCResponse
} from "../src/proto/cross/core/initiator/Initiator.sol";
import {Account as AuthAccount, AuthType, TxAuthState} from "../src/proto/cross/core/auth/Auth.sol";
import {GoogleProtobufAny} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";
import {Tx} from "../src/proto/cross/core/tx/Tx.sol";
import {IbcCoreClientV1Height} from "../src/proto/ibc/core/client/v1/client.sol";
import {ChannelInfo} from "../src/proto/cross/core/xcc/XCC.sol";
import {CoordinatorState} from "../src/proto/cross/core/atomic/simple/AtomicSimple.sol";

contract MockTxManager is TxManagerBase {
    mapping(bytes32 => bool) public txExists;
    bytes32 public lastCreatedtxID;
    bytes32 public lastRuntxID;
    uint256 public createTxCount;
    uint256 public runTxCount;

    function _createTx(bytes32 txID, MsgInitiateTx.Data calldata) internal virtual override {
        txExists[txID] = true;
        lastCreatedtxID = txID;
        ++createTxCount;
    }

    function _runTxIfCompleted(MsgInitiateTx.Data calldata msg_) internal virtual override {}

    function _isTxRecorded(bytes32 txID) internal view virtual override returns (bool) {
        return txExists[txID];
    }

    function _getCoordinatorState(
        bytes32 /*txID*/
    )
        internal
        view
        virtual
        override
        returns (CoordinatorState.Data memory)
    {
        CoordinatorState.Data memory dummy;
        return dummy;
    }

    function setTxExists(bytes32 txID, bool exists) public {
        txExists[txID] = exists;
    }
}

contract MockTxAuthManager is TxAuthManagerBase {
    mapping(bytes32 => bool) public completed;
    bytes32 public lastInittxID;
    bool private _signReturns = false;

    function _initAuthState(bytes32 txID, AuthAccount.Data[] memory) internal virtual override {
        lastInittxID = txID;
        completed[txID] = false;
    }

    function _isCompletedAuth(bytes32 txID) internal view virtual override returns (bool) {
        return completed[txID];
    }

    function _sign(bytes32 txID, AuthAccount.Data[] memory) internal virtual override returns (bool) {
        if (_signReturns) {
            completed[txID] = true;
        }
        return _signReturns;
    }

    function _getAuthState(bytes32) internal view virtual override returns (TxAuthState.Data memory) {
        revert("MockTxAuthManager._getAuthState not implemented");
    }

    function _verifySignatures(bytes32, AuthAccount.Data[] calldata) internal virtual override {
        revert("MockTxAuthManager._verifySignatures not implemented");
    }

    function setSignReturns(bool returnsValue) public {
        _signReturns = returnsValue;
    }
}

/**
 * @dev Initiatorとモックを組み合わせたテストハーネス
 */
contract InitiatorHarness is Initiator, MockTxAuthManager, MockTxManager {
    function exposed_getRequiredAccounts(MsgInitiateTx.Data calldata msg_)
        public
        pure
        returns (AuthAccount.Data[] memory out)
    {
        return _getRequiredAccounts(msg_);
    }
}

contract InitiatorTest is Test, ICrossEvent {
    InitiatorHarness private harness;
    MsgInitiateTx.Data private baseMsg;
    AuthAccount.Data private signerA;
    AuthAccount.Data private signerB;
    AuthType.Data private localAuthType;
    string private chainIDStr;

    function setUp() public {
        harness = new InitiatorHarness();

        GoogleProtobufAny.Data memory emptyAny = GoogleProtobufAny.Data({type_url: "", value: ""});
        localAuthType = AuthType.Data({mode: AuthType.AuthMode.AUTH_MODE_LOCAL, option: emptyAny});

        signerA = AuthAccount.Data({id: bytes("signerA"), auth_type: localAuthType});
        signerB = AuthAccount.Data({id: bytes("signerB"), auth_type: localAuthType});

        chainIDStr = Strings.toString(block.chainid);

        AuthAccount.Data[] memory signers;

        ContractTransaction.Data[] memory txs = new ContractTransaction.Data[](1);
        txs[0].signers = new AuthAccount.Data[](1);
        txs[0].signers[0] = signerA;

        baseMsg = MsgInitiateTx.Data({
            chain_id: chainIDStr,
            nonce: 1,
            commit_protocol: Tx.CommitProtocol.COMMIT_PROTOCOL_SIMPLE,
            timeout_height: IbcCoreClientV1Height.Data(0, uint64(block.number + 100)),
            timeout_timestamp: uint64(block.timestamp + 100),
            signers: signers,
            contract_transactions: txs
        });
    }

    function test_constructor_SetsChainIDHash() public view {
        bytes32 expected = keccak256(bytes(chainIDStr));
        assertEq(harness.CHAIN_ID_HASH(), expected, "CHAIN_ID_HASH mismatch");
    }

    function test_selfXCC_ReturnsCorrectChannelInfo() public view {
        string memory expectedTypeURL = "/cross.core.xcc.ChannelInfo";
        bytes memory expectedValue = ChannelInfo.encode(ChannelInfo.Data({port: "", channel: ""}));

        QuerySelfXCCResponse.Data memory resp = harness.selfXCC();

        assertEq(resp.xcc.type_url, expectedTypeURL, "type_url mismatch");
        assertEq(resp.xcc.value, expectedValue, "value mismatch");
    }

    function test_initiateTx_SucceedsAsPendingWhenSignersNotMet() public {
        bytes32 txIDHash = sha256(MsgInitiateTx.encode(baseMsg));

        harness.setSignReturns(false);

        vm.expectEmit(true, false, false, true, address(harness));
        emit TxInitiated(abi.encodePacked(txIDHash), address(this), baseMsg);

        MsgInitiateTxResponse.Data memory resp = harness.initiateTx(baseMsg);

        assertEq(
            uint256(resp.status),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_PENDING),
            "Status should be PENDING"
        );
        assertTrue(harness.txExists(txIDHash), "Mock: tx should be recorded");
        assertFalse(harness.completed(txIDHash), "Mock: auth should not be completed");
        assertEq(harness.createTxCount(), 1, "Mock: _createTx should be called once");
        assertEq(harness.lastInittxID(), txIDHash, "Mock: _initAuthState should be called with txID");
        assertEq(harness.runTxCount(), 0, "Mock: _runTxIfCompleted should not be called");
    }

    function test_initiateTx_SucceedsAsVerifiedWhenSignersMet() public {
        bytes32 txIDHash = sha256(MsgInitiateTx.encode(baseMsg));

        harness.setSignReturns(true);

        vm.expectEmit(true, false, false, true, address(harness));
        emit TxInitiated(abi.encodePacked(txIDHash), address(this), baseMsg);

        MsgInitiateTxResponse.Data memory resp = harness.initiateTx(baseMsg);

        assertEq(
            uint256(resp.status),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED),
            "Status should be VERIFIED"
        );
        assertTrue(harness.txExists(txIDHash), "Mock: tx should be recorded");
        assertTrue(harness.completed(txIDHash), "Mock: auth should be completed");
        assertEq(harness.createTxCount(), 1, "Mock: _createTx should be called once");
        assertEq(harness.lastInittxID(), txIDHash, "Mock: _initAuthState should be called with txID");
    }

    function test_initiateTx_RevertWhen_ChainIDMismatch() public {
        baseMsg.chain_id = "wrong-chain";

        bytes32 expectedHash = keccak256(bytes(chainIDStr));
        bytes32 gotHash = keccak256(bytes("wrong-chain"));

        vm.expectRevert(abi.encodeWithSelector(ICrossError.UnexpectedChainID.selector, expectedHash, gotHash));
        harness.initiateTx(baseMsg);
    }

    function test_initiateTx_RevertWhen_TimeoutHeightExpired() public {
        baseMsg.timeout_height.revision_height = uint64(block.number);

        vm.expectRevert(
            abi.encodeWithSelector(
                ICrossError.MessageTimeoutHeight.selector, block.number, baseMsg.timeout_height.revision_height
            )
        );
        harness.initiateTx(baseMsg);
    }

    function test_initiateTx_RevertWhen_TimeoutTimestampExpired() public {
        baseMsg.timeout_timestamp = uint64(block.timestamp);

        vm.expectRevert(
            abi.encodeWithSelector(
                ICrossError.MessageTimeoutTimestamp.selector, block.timestamp, baseMsg.timeout_timestamp
            )
        );
        harness.initiateTx(baseMsg);
    }

    function test_initiateTx_RevertWhen_txIDAlreadyExists() public {
        bytes32 txIDHash = sha256(MsgInitiateTx.encode(baseMsg));

        harness.setTxExists(txIDHash, true);

        vm.expectRevert(abi.encodeWithSelector(ICrossError.TxIDAlreadyExists.selector, txIDHash));
        harness.initiateTx(baseMsg);
    }

    function test_getRequiredAccounts_AggregatesSigners() public {
        baseMsg.contract_transactions = new ContractTransaction.Data[](2);
        baseMsg.contract_transactions[0].signers = new AuthAccount.Data[](2);
        baseMsg.contract_transactions[0].signers[0] = signerA;
        baseMsg.contract_transactions[0].signers[1] = signerB;

        baseMsg.contract_transactions[1].signers = new AuthAccount.Data[](1);
        AuthAccount.Data memory signerC = AuthAccount.Data({id: bytes("signerC"), auth_type: localAuthType});
        baseMsg.contract_transactions[1].signers[0] = signerC;

        AuthAccount.Data[] memory required = harness.exposed_getRequiredAccounts(baseMsg);

        assertEq(required.length, 3, "Should aggregate 3 signers");
        assertEq(required[0].id, signerA.id, "Signer A missing");
        assertEq(required[1].id, signerB.id, "Signer B missing");
        assertEq(required[2].id, signerC.id, "Signer C missing");
    }

    function test_getRequiredAccounts_ReturnsEmptyArrayWhenNoTxs() public {
        baseMsg.contract_transactions = new ContractTransaction.Data[](0);

        AuthAccount.Data[] memory required = harness.exposed_getRequiredAccounts(baseMsg);

        assertEq(required.length, 0, "Should return empty array for zero transactions");
    }

    function test_getRequiredAccounts_ReturnsEmptyArrayWhenNoSigners() public {
        baseMsg.contract_transactions = new ContractTransaction.Data[](2);
        baseMsg.contract_transactions[0].signers = new AuthAccount.Data[](0);
        baseMsg.contract_transactions[1].signers = new AuthAccount.Data[](0);

        AuthAccount.Data[] memory required = harness.exposed_getRequiredAccounts(baseMsg);

        assertEq(required.length, 0, "Should return empty array for zero signers");
    }
}
