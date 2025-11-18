// SPDX-License-Identifier: Apache-2.0
// solhint-disable one-contract-per-file, func-name-mixedcase, gas-small-strings, no-inline-assembly
pragma solidity ^0.8.20;

import "forge-std/src/Test.sol";
import "../src/core/DelegatedLogicHandler.sol";
import {ITxAuthManager} from "../src/core/ITxAuthManager.sol";
import {ITxManager} from "../src/core/ITxManager.sol";
import {ICrossError} from "../src/core/ICrossError.sol";
import {
    MsgInitiateTx,
    MsgInitiateTxResponse,
    ContractTransaction
} from "../src/proto/cross/core/initiator/Initiator.sol";
import {Account as AuthAccount, AuthType, TxAuthState} from "../src/proto/cross/core/auth/Auth.sol";
import {Tx} from "../src/proto/cross/core/tx/Tx.sol";
import {IbcCoreClientV1Height} from "../src/proto/ibc/core/client/v1/client.sol";
import {GoogleProtobufAny} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";

contract MockStore {
    struct AuthStorage {
        mapping(bytes32 => uint256) callCounts;
        mapping(bytes32 => bool) initialized;
    }

    struct TxStorage {
        mapping(bytes32 => MsgInitiateTxResponse.InitiateTxStatus) status;
        mapping(bytes32 => uint64) nonce;
    }

    AuthStorage internal authStorage;
    TxStorage internal txStorage;
}

contract MockTxAuthManager is ITxAuthManager, MockStore {
    function initAuthState(bytes32 txID, AuthAccount.Data[] calldata) external override {
        ++authStorage.callCounts[txID];
        authStorage.initialized[txID] = true;
    }

    function sign(bytes32 txID, AuthAccount.Data[] calldata) external override returns (bool) {
        ++authStorage.callCounts[txID];
        return true;
    }

    function isCompletedAuth(bytes32 txID) external override returns (bool) {
        ++authStorage.callCounts[txID];
        return true;
    }

    function getAuthState(bytes32 txID) external override returns (TxAuthState.Data memory) {
        ++authStorage.callCounts[txID];

        AuthAccount.Data[] memory remaining = new AuthAccount.Data[](1);
        GoogleProtobufAny.Data memory emptyAny = GoogleProtobufAny.Data({type_url: "", value: ""});
        AuthType.Data memory localAuthType = AuthType.Data({mode: AuthType.AuthMode.AUTH_MODE_LOCAL, option: emptyAny});
        remaining[0] = AuthAccount.Data({id: bytes("signerA"), auth_type: localAuthType});

        return TxAuthState.Data({remaining_signers: remaining});
    }
}

contract MockTxManager is ITxManager, MockStore {
    function createTx(bytes32 txID, MsgInitiateTx.Data calldata src) external override {
        txStorage.status[txID] = MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_PENDING;
        txStorage.nonce[txID] = src.nonce;
    }

    function runTxIfCompleted(bytes32 txID) external override {
        txStorage.status[txID] = MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED;
        txStorage.nonce[txID] = 1;
    }

    function isTxRecorded(bytes32 txID) external override returns (bool) {
        txStorage.nonce[txID] = 1;
        return true;
    }
}

contract MockSuccessContract {
    function getBool() public pure returns (bool) {
        return true;
    }

    function getUint() public pure returns (uint256) {
        return 12345;
    }
}

contract MockRevertContract {
    function revertNow(string memory reason) public pure {
        revert(reason);
    }
}

contract MockRevertEmpty {
    function revertNow() public pure {
        assembly {
            revert(0, 0)
        }
    }
}

contract DelegatedLogicHandlerHarness is DelegatedLogicHandler, MockStore {
    constructor(address txAuthManager_, address txManager_) DelegatedLogicHandler(txAuthManager_, txManager_) {}

    function exposed_initAuthState(bytes32 txID, AuthAccount.Data[] memory signers) public {
        _initAuthState(txID, signers);
    }

    function exposed_sign(bytes32 txID, AuthAccount.Data[] memory signers) public returns (bool) {
        return _sign(txID, signers);
    }

    function exposed_isCompletedAuth(bytes32 txID) public returns (bool) {
        return _isCompletedAuth(txID);
    }

    function exposed_getAuthState(bytes32 txID) public returns (TxAuthState.Data memory) {
        return _getAuthState(txID);
    }

    function exposed_createTx(bytes32 txID, MsgInitiateTx.Data calldata src) public {
        _createTx(txID, src);
    }

    function exposed_runTxIfCompleted(bytes32 txID) public {
        _runTxIfCompleted(txID);
    }

    function exposed_isTxRecorded(bytes32 txID) public returns (bool) {
        return _isTxRecorded(txID);
    }

    function exposed_delegateWithData(address impl, bytes memory data) public returns (bytes memory) {
        return _delegateWithData(impl, data);
    }

    function readAuth_callCount(bytes32 txID) public view returns (uint256) {
        return authStorage.callCounts[txID];
    }

    function readAuth_initialized(bytes32 txID) public view returns (bool) {
        return authStorage.initialized[txID];
    }

    function readTx_status(bytes32 txID) public view returns (MsgInitiateTxResponse.InitiateTxStatus) {
        return txStorage.status[txID];
    }

    function readTx_nonce(bytes32 txID) public view returns (uint64) {
        return txStorage.nonce[txID];
    }
}

contract DelegatedLogicHandlerTest is Test {
    MockTxAuthManager private mockAuth;
    MockTxManager private mockTx;
    DelegatedLogicHandlerHarness private harness;

    bytes32 private txID = keccak256("test_tx_id");
    AuthAccount.Data[] private signers;
    MsgInitiateTx.Data private txMsg;

    function setUp() public {
        mockAuth = new MockTxAuthManager();
        mockTx = new MockTxManager();
        harness = new DelegatedLogicHandlerHarness(address(mockAuth), address(mockTx));

        GoogleProtobufAny.Data memory emptyAny = GoogleProtobufAny.Data({type_url: "", value: ""});
        AuthType.Data memory localAuthType = AuthType.Data({mode: AuthType.AuthMode.AUTH_MODE_LOCAL, option: emptyAny});
        signers = new AuthAccount.Data[](1);
        signers[0] = AuthAccount.Data({id: bytes("signerA"), auth_type: localAuthType});

        txMsg = MsgInitiateTx.Data({
            chain_id: "test-chain",
            nonce: 123,
            commit_protocol: Tx.CommitProtocol.COMMIT_PROTOCOL_SIMPLE,
            timeout_height: IbcCoreClientV1Height.Data(0, 0),
            timeout_timestamp: 0,
            signers: signers,
            contract_transactions: new ContractTransaction.Data[](0)
        });
    }

    function test_initAuthState_DelegatesToAuthManager() public {
        harness.exposed_initAuthState(txID, signers);

        assertEq(harness.readAuth_callCount(txID), 1, "AuthManager.initAuthState should be called once");
        assertTrue(harness.readAuth_initialized(txID), "authInitialized mismatch");
    }

    function test_sign_DelegatesToAuthManager() public {
        bool result = harness.exposed_sign(txID, signers);

        assertTrue(result, "Return value mismatch");
        assertEq(harness.readAuth_callCount(txID), 1, "AuthManager.sign should be called once");
    }

    function test_isCompletedAuth_DelegatesToAuthManager() public {
        bool result = harness.exposed_isCompletedAuth(txID);

        assertTrue(result, "Return value mismatch");
        assertEq(harness.readAuth_callCount(txID), 1, "AuthManager.isCompletedAuth should be called once");
    }

    function test_getAuthState_DelegatesToAuthManager() public {
        TxAuthState.Data memory result = harness.exposed_getAuthState(txID);

        assertEq(harness.readAuth_callCount(txID), 1, "AuthManager.getAuthState should be called once");
        assertEq(result.remaining_signers.length, 1, "Return value (signers length) mismatch");
        assertEq(result.remaining_signers[0].id, signers[0].id, "Return value (signer id) mismatch");
    }

    function test_createTx_DelegatesToTxManager() public {
        harness.exposed_createTx(txID, txMsg);

        assertEq(
            uint256(harness.readTx_status(txID)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_PENDING),
            "Status should be PENDING"
        );
        assertEq(harness.readTx_nonce(txID), txMsg.nonce, "nonce mismatch");
    }

    function test_runTxIfCompleted_DelegatesToTxManager() public {
        harness.exposed_runTxIfCompleted(txID);

        assertEq(
            uint256(harness.readTx_status(txID)),
            uint256(MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED),
            "Status should be VERIFIED"
        );
        assertEq(harness.readTx_nonce(txID), 1, "runTxIfCompleted call count mismatch");
    }

    function test_isTxRecorded_DelegatesToTxManager() public {
        bool result = harness.exposed_isTxRecorded(txID);

        assertTrue(result, "Return value mismatch");
        assertEq(harness.readTx_nonce(txID), 1, "isTxRecorded call count mismatch");
    }

    function test_delegateWithData_SucceedsAndReturnsData() public {
        MockSuccessContract successMock = new MockSuccessContract();

        bytes memory dataBool = abi.encodeWithSelector(successMock.getBool.selector);
        bytes memory retBool = harness.exposed_delegateWithData(address(successMock), dataBool);

        assertEq(retBool, abi.encode(true), "Return data for bool mismatch");

        bytes memory dataUint = abi.encodeWithSelector(successMock.getUint.selector);
        bytes memory retUint = harness.exposed_delegateWithData(address(successMock), dataUint);

        assertEq(retUint, abi.encode(12345), "Return data for uint mismatch");
    }

    function test_delegateWithData_RevertWhen_TargetReverts() public {
        MockRevertContract reverter = new MockRevertContract();
        string memory reason = "TestRevert";
        bytes memory data = abi.encodeWithSelector(reverter.revertNow.selector, reason);

        vm.expectRevert(bytes(reason));
        harness.exposed_delegateWithData(address(reverter), data);
    }

    function test_delegateWithData_RevertIf_DelegateCallFails() public {
        MockRevertEmpty reverter = new MockRevertEmpty();
        bytes memory data = abi.encodeWithSelector(reverter.revertNow.selector);

        vm.expectRevert(abi.encodeWithSelector(ICrossError.DelegateCallFailed.selector, address(reverter)));
        harness.exposed_delegateWithData(address(reverter), data);
    }
}
