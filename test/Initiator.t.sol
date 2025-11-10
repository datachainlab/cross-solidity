// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";
import "../src/core/Initiator.sol";
import "../src/core/TxAuthManager.sol";
import "../src/core/TxManager.sol";
import "../src/core/TxRunner.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

import {
    MsgInitiateTx,
    MsgInitiateTxResponse,
    ContractTransaction
} from "../src/proto/cross/core/initiator/Initiator.sol";
import {Account as AuthAccount, AuthType} from "../src/proto/cross/core/auth/Auth.sol";
import {GoogleProtobufAny} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";
import {Tx} from "../src/proto/cross/core/tx/Tx.sol";
import {IbcCoreClientV1Height} from "../src/proto/ibc/core/client/v1/client.sol";

contract MockTxRunner is TxRunner {
    uint256 public runCount;
    bytes32 public lastRunTxId;

    function _runTx(bytes32 txId, MsgInitiateTx.Data storage) internal virtual override {
        runCount++;
        lastRunTxId = txId;
    }
}

contract InitiatorHarness is Initiator, TxAuthManager, TxManager, MockTxRunner {
    function exposed_getRequiredAccounts(MsgInitiateTx.Data calldata msg_)
        public
        pure
        returns (AuthAccount.Data[] memory out)
    {
        return _getRequiredAccounts(msg_);
    }

    function exposed_isCompletedAuth(bytes32 txId) public view returns (bool) {
        return isCompletedAuth(txId);
    }

    function exposed_isTxRecorded(bytes32 txId) public view returns (bool) {
        return isTxRecorded(txId);
    }
}

contract InitiatorTest is Test {
    InitiatorHarness private harness;
    MsgInitiateTx.Data private baseMsg;
    AuthAccount.Data private signerA;
    AuthAccount.Data private signerB;
    AuthType.Data private localAuthType;
    string private chainIdStr;

    event TxInitiated(bytes txId, address indexed proposer);

    function setUp() public {
        harness = new InitiatorHarness();

        GoogleProtobufAny.Data memory emptyAny = GoogleProtobufAny.Data({type_url: "", value: ""});
        localAuthType = AuthType.Data({mode: AuthType.AuthMode.AUTH_MODE_LOCAL, option: emptyAny});

        signerA = AuthAccount.Data({id: bytes("signerA"), auth_type: localAuthType});
        signerB = AuthAccount.Data({id: bytes("signerB"), auth_type: localAuthType});

        chainIdStr = Strings.toString(block.chainid);

        AuthAccount.Data[] memory signers;

        ContractTransaction.Data[] memory txs = new ContractTransaction.Data[](1);
        txs[0].signers = new AuthAccount.Data[](1);
        txs[0].signers[0] = signerA;

        baseMsg = MsgInitiateTx.Data({
            chain_id: chainIdStr,
            nonce: 1,
            commit_protocol: Tx.CommitProtocol.COMMIT_PROTOCOL_SIMPLE,
            timeout_height: IbcCoreClientV1Height.Data(0, uint64(block.number + 100)),
            timeout_timestamp: uint64(block.timestamp + 100),
            signers: signers,
            contract_transactions: txs
        });
    }

    function test_constructor_SetsChainIdHash() public view {
        bytes32 expected = keccak256(bytes(chainIdStr));
        assertEq(harness.CHAIN_ID_HASH(), expected, "CHAIN_ID_HASH mismatch");
    }

    function test_selfXCC_RevertWhen_Always() public {
        vm.expectRevert(IInitiator.SelfXCCNotImplemented.selector);
        harness.selfXCC();
    }

    function test_initiateTx_SucceedsAsPendingWhenSignersNotMet() public {
        bytes32 txIdHash = sha256(MsgInitiateTx.encode(baseMsg));

        vm.expectEmit(true, false, false, true, address(harness));
        emit TxInitiated(abi.encodePacked(txIdHash), address(this));

        MsgInitiateTxResponse.Data memory resp = harness.initiateTx(baseMsg);

        assertEq(
            uint256(resp.status),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_PENDING),
            "Status should be PENDING"
        );
        assertTrue(harness.exposed_isTxRecorded(txIdHash), "Tx should be recorded");
        assertFalse(harness.exposed_isCompletedAuth(txIdHash), "Auth should not be completed");
        assertEq(harness.runCount(), 0, "MockTxRunner should not be called");
    }

    function test_initiateTx_SucceedsAsVerifiedWhenSignersMet() public {
        baseMsg.contract_transactions = new ContractTransaction.Data[](1);
        baseMsg.contract_transactions[0].signers = new AuthAccount.Data[](2);
        baseMsg.contract_transactions[0].signers[0] = signerA;
        baseMsg.contract_transactions[0].signers[1] = signerB;

        baseMsg.signers = new AuthAccount.Data[](2);
        baseMsg.signers[0] = signerA;
        baseMsg.signers[1] = signerB;

        bytes32 txIdHash = sha256(MsgInitiateTx.encode(baseMsg));

        vm.expectEmit(true, false, false, true, address(harness));
        emit TxInitiated(abi.encodePacked(txIdHash), address(this));

        MsgInitiateTxResponse.Data memory resp = harness.initiateTx(baseMsg);

        assertEq(
            uint256(resp.status),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED),
            "Status should be VERIFIED"
        );
        assertTrue(harness.exposed_isTxRecorded(txIdHash), "Tx should be recorded");
        assertTrue(harness.exposed_isCompletedAuth(txIdHash), "Auth should be completed");
        assertEq(harness.runCount(), 1, "MockTxRunner should be called");
        assertEq(harness.lastRunTxId(), txIdHash, "MockTxRunner called with correct txId");
    }

    function test_initiateTx_RevertWhen_ChainIdMismatch() public {
        baseMsg.chain_id = "wrong-chain";

        bytes32 expectedHash = keccak256(bytes(chainIdStr));
        bytes32 gotHash = keccak256(bytes("wrong-chain"));

        vm.expectRevert(abi.encodeWithSelector(IInitiator.UnexpectedChainId.selector, expectedHash, gotHash));
        harness.initiateTx(baseMsg);
    }

    function test_initiateTx_RevertWhen_TimeoutHeightExpired() public {
        baseMsg.timeout_height.version_height = uint64(block.number);

        vm.expectRevert(
            abi.encodeWithSelector(
                IInitiator.MessageTimeoutHeight.selector, block.number, baseMsg.timeout_height.version_height
            )
        );
        harness.initiateTx(baseMsg);
    }

    function test_initiateTx_RevertWhen_TimeoutTimestampExpired() public {
        baseMsg.timeout_timestamp = uint64(block.timestamp);

        vm.expectRevert(
            abi.encodeWithSelector(
                IInitiator.MessageTimeoutTimestamp.selector, block.timestamp, baseMsg.timeout_timestamp
            )
        );
        harness.initiateTx(baseMsg);
    }

    function test_initiateTx_RevertWhen_TxIdAlreadyExists() public {
        harness.initiateTx(baseMsg);
        bytes32 txIdHash = sha256(MsgInitiateTx.encode(baseMsg));

        vm.expectRevert(abi.encodeWithSelector(IInitiator.TxIDAlreadyExists.selector, txIdHash));
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
}
