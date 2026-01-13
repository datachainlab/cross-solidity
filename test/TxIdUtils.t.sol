// SPDX-License-Identifier: Apache-2.0
// solhint-disable func-name-mixedcase, one-contract-per-file, gas-small-strings
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";
import "../src/core/TxIdUtils.sol";
import {MsgInitiateTx, ContractTransaction, Link, ReturnValue} from "../src/proto/cross/core/initiator/Initiator.sol";
import {GoogleProtobufAny as Any} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";
import {AuthType, Account as AuthAccount} from "../src/proto/cross/core/auth/Auth.sol";
import {IbcCoreClientV1Height} from "../src/proto/ibc/core/client/v1/client.sol";
import {Tx} from "../src/proto/cross/core/tx/Tx.sol";

contract TxIdUtilsHarness {
    using TxIdUtils for MsgInitiateTx.Data;

    function exposed_computeTxId(MsgInitiateTx.Data calldata msg_) external pure returns (bytes32) {
        return msg_.computeTxId();
    }
}

contract TxIdUtilsTest is Test {
    TxIdUtilsHarness private harness;

    function setUp() public {
        harness = new TxIdUtilsHarness();
    }

    function test_computeTxId_SucceedsWithTypicalMsg() public view {
        MsgInitiateTx.Data memory msg_ = _createBaseMsg();
        bytes32 id = harness.exposed_computeTxId(msg_);
        assertNotEq(id, bytes32(0), "Computed TxID should not be zero");
    }

    function test_computeTxId_SucceedsWithMinimalMsg() public view {
        MsgInitiateTx.Data memory msg_ = MsgInitiateTx.Data({
            chain_id: "",
            nonce: 0,
            commit_protocol: Tx.CommitProtocol.COMMIT_PROTOCOL_UNKNOWN,
            contract_transactions: new ContractTransaction.Data[](0),
            signers: new AuthAccount.Data[](0),
            timeout_height: IbcCoreClientV1Height.Data(0, 0),
            timeout_timestamp: 0
        });

        bytes32 id = harness.exposed_computeTxId(msg_);
        assertNotEq(id, bytes32(0), "Minimal message should still produce a valid hash");
    }

    function test_computeTxId_ReturnsConsistentId() public view {
        MsgInitiateTx.Data memory msg1 = _createBaseMsg();
        MsgInitiateTx.Data memory msg2 = _createBaseMsg();
        assertEq(harness.exposed_computeTxId(msg1), harness.exposed_computeTxId(msg2));
    }

    function test_computeTxId_ReturnsDifferentIdForDifferentNonce() public view {
        MsgInitiateTx.Data memory m1 = _createBaseMsg();
        MsgInitiateTx.Data memory m2 = _createBaseMsg();
        m2.nonce = m1.nonce + 1;
        assertNotEq(harness.exposed_computeTxId(m1), harness.exposed_computeTxId(m2));
    }

    function test_computeTxId_ReturnsDifferentIdForDifferentChainId() public view {
        MsgInitiateTx.Data memory m1 = _createBaseMsg();
        MsgInitiateTx.Data memory m2 = _createBaseMsg();
        m2.chain_id = "other-chain";
        assertNotEq(harness.exposed_computeTxId(m1), harness.exposed_computeTxId(m2));
    }

    function test_computeTxId_ReturnsDifferentIdForDifferentCommitProtocol() public view {
        MsgInitiateTx.Data memory m1 = _createBaseMsg();
        MsgInitiateTx.Data memory m2 = _createBaseMsg();
        m2.commit_protocol = Tx.CommitProtocol.COMMIT_PROTOCOL_TPC;
        assertNotEq(harness.exposed_computeTxId(m1), harness.exposed_computeTxId(m2));
    }

    function test_computeTxId_ReturnsDifferentIdForDifferentTimeoutHeight_RevisionNumber() public view {
        MsgInitiateTx.Data memory m1 = _createBaseMsg();
        MsgInitiateTx.Data memory m2 = _createBaseMsg();
        m2.timeout_height.revision_number = 1;
        assertNotEq(harness.exposed_computeTxId(m1), harness.exposed_computeTxId(m2));
    }

    function test_computeTxId_ReturnsDifferentIdForDifferentTimeoutHeight_RevisionHeight() public view {
        MsgInitiateTx.Data memory m1 = _createBaseMsg();
        MsgInitiateTx.Data memory m2 = _createBaseMsg();
        m2.timeout_height.revision_height = 100;
        assertNotEq(harness.exposed_computeTxId(m1), harness.exposed_computeTxId(m2));
    }

    function test_computeTxId_ReturnsDifferentIdForDifferentTimeoutTimestamp() public view {
        MsgInitiateTx.Data memory m1 = _createBaseMsg();
        MsgInitiateTx.Data memory m2 = _createBaseMsg();
        m2.timeout_timestamp = 123456789;
        assertNotEq(harness.exposed_computeTxId(m1), harness.exposed_computeTxId(m2));
    }

    function test_computeTxId_ReturnsDifferentIdForDifferentRootSigners() public view {
        MsgInitiateTx.Data memory m1 = _createBaseMsg();
        MsgInitiateTx.Data memory m2 = _createBaseMsg();
        m2.signers = new AuthAccount.Data[](1);
        m2.signers[0] = _createAccount("signer1");
        assertNotEq(harness.exposed_computeTxId(m1), harness.exposed_computeTxId(m2));
    }

    function test_computeTxId_ReturnsDifferentIdForDifferentLocalSigners() public view {
        MsgInitiateTx.Data memory m1 = _createBaseMsg();
        MsgInitiateTx.Data memory m2 = _createBaseMsg();
        m2.contract_transactions[0].signers = new AuthAccount.Data[](1);
        m2.contract_transactions[0].signers[0] = _createAccount("local-signer");
        assertNotEq(harness.exposed_computeTxId(m1), harness.exposed_computeTxId(m2));
    }

    function test_computeTxId_ReturnsDifferentIdForDifferentTxArrayLength() public view {
        MsgInitiateTx.Data memory m1 = _createBaseMsg();
        MsgInitiateTx.Data memory m2 = _createBaseMsg();

        m2.contract_transactions = new ContractTransaction.Data[](2);
        m2.contract_transactions[0] = m1.contract_transactions[0];
        m2.contract_transactions[1] = m1.contract_transactions[0];

        assertNotEq(harness.exposed_computeTxId(m1), harness.exposed_computeTxId(m2));
    }

    function test_computeTxId_ReturnsDifferentIdForDifferentCallInfo() public view {
        MsgInitiateTx.Data memory m1 = _createBaseMsg();
        MsgInitiateTx.Data memory m2 = _createBaseMsg();
        m2.contract_transactions[0].call_info = hex"deadbeef";
        assertNotEq(harness.exposed_computeTxId(m1), harness.exposed_computeTxId(m2));
    }

    function test_computeTxId_ReturnsDifferentIdForDifferentChannelAnyValue() public view {
        MsgInitiateTx.Data memory m1 = _createBaseMsg();
        MsgInitiateTx.Data memory m2 = _createBaseMsg();
        m2.contract_transactions[0].cross_chain_channel.value = hex"010203";
        assertNotEq(harness.exposed_computeTxId(m1), harness.exposed_computeTxId(m2));
    }

    function test_computeTxId_ReturnsDifferentIdForDifferentReturnValue() public view {
        MsgInitiateTx.Data memory m1 = _createBaseMsg();
        MsgInitiateTx.Data memory m2 = _createBaseMsg();
        m2.contract_transactions[0].return_value = ReturnValue.Data(hex"ffee");
        assertNotEq(harness.exposed_computeTxId(m1), harness.exposed_computeTxId(m2));
    }

    function test_computeTxId_ReturnsDifferentIdForDifferentLinks() public view {
        MsgInitiateTx.Data memory m1 = _createBaseMsg();
        MsgInitiateTx.Data memory m2 = _createBaseMsg();
        m2.contract_transactions[0].links = new Link.Data[](1);
        m2.contract_transactions[0].links[0] = Link.Data(0);
        assertNotEq(harness.exposed_computeTxId(m1), harness.exposed_computeTxId(m2));
    }

    function test_computeTxId_ReturnsDifferentIdForDifferentSignerAuthMode() public view {
        MsgInitiateTx.Data memory m1 = _createBaseMsg();
        m1.signers = new AuthAccount.Data[](1);
        m1.signers[0] = _createAccount("signer1");

        MsgInitiateTx.Data memory m2 = _createBaseMsg();
        m2.signers = new AuthAccount.Data[](1);
        m2.signers[0] = _createAccount("signer1");
        m2.signers[0].auth_type.mode = AuthType.AuthMode.AUTH_MODE_EXTENSION;

        assertNotEq(harness.exposed_computeTxId(m1), harness.exposed_computeTxId(m2));
    }

    function test_computeTxId_ReturnsDifferentIdForDifferentSignerAuthOptionTypeUrl() public view {
        MsgInitiateTx.Data memory m1 = _createBaseMsg();
        m1.signers = new AuthAccount.Data[](1);
        m1.signers[0] = _createAccount("signer1");

        MsgInitiateTx.Data memory m2 = _createBaseMsg();
        m2.signers = new AuthAccount.Data[](1);
        m2.signers[0] = _createAccount("signer1");
        m2.signers[0].auth_type.option.type_url = "/new.verifier.v1";

        assertNotEq(harness.exposed_computeTxId(m1), harness.exposed_computeTxId(m2));
    }

    function test_computeTxId_ReturnsDifferentIdForDifferentSignerAuthOptionValue() public view {
        MsgInitiateTx.Data memory m1 = _createBaseMsg();
        m1.signers = new AuthAccount.Data[](1);
        m1.signers[0] = _createAccount("signer1");

        MsgInitiateTx.Data memory m2 = _createBaseMsg();
        m2.signers = new AuthAccount.Data[](1);
        m2.signers[0] = _createAccount("signer1");
        m2.signers[0].auth_type.option.value = hex"123456";

        assertNotEq(harness.exposed_computeTxId(m1), harness.exposed_computeTxId(m2));
    }

    // --- Helpers ---

    function _createBaseMsg() internal pure returns (MsgInitiateTx.Data memory) {
        ContractTransaction.Data[] memory txs = new ContractTransaction.Data[](1);
        txs[0] = ContractTransaction.Data({
            cross_chain_channel: Any.Data("/type.url", hex"00"),
            signers: new AuthAccount.Data[](0),
            call_info: hex"abcd",
            return_value: ReturnValue.Data(""),
            links: new Link.Data[](0)
        });

        return MsgInitiateTx.Data({
            chain_id: "test-chain",
            nonce: 1,
            commit_protocol: Tx.CommitProtocol.COMMIT_PROTOCOL_SIMPLE,
            contract_transactions: txs,
            signers: new AuthAccount.Data[](0),
            timeout_height: IbcCoreClientV1Height.Data(0, 0),
            timeout_timestamp: 0
        });
    }

    function _createAccount(string memory id) internal pure returns (AuthAccount.Data memory) {
        return AuthAccount.Data({
            id: bytes(id),
            auth_type: AuthType.Data({
                mode: AuthType.AuthMode.AUTH_MODE_LOCAL, option: Any.Data({type_url: "", value: hex""})
            })
        });
    }
}
