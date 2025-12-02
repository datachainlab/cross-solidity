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
import {CoordinatorState} from "../src/proto/cross/core/atomic/simple/AtomicSimple.sol";
import {GoogleProtobufAny} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/GoogleProtobufAny.sol";
import {Packet} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/04-channel/IIBCChannel.sol";
import {Height} from "@hyperledger-labs/yui-ibc-solidity/contracts/proto/Client.sol";

contract MockStore {
    struct AuthStorage {
        mapping(bytes32 => uint256) callCounts;
        mapping(bytes32 => bool) initialized;
    }

    struct TxStorage {
        mapping(bytes32 => MsgInitiateTxResponse.InitiateTxStatus) status;
        mapping(bytes32 => uint64) nonce;
        mapping(bytes32 => CoordinatorState.Data) coordStates;
        uint256 handlePacketCount;
        uint256 handleAckCount;
        uint256 handleTimeoutCount;
    }

    AuthStorage internal authStorage;
    TxStorage internal txStorage;
}

contract MockTxAuthManager is ITxAuthManager, MockStore {
    function initialize(string[] calldata, IAuthExtensionVerifier[] calldata) external override {
        // No-op
    }

    function initAuthState(bytes32 txID, AuthAccount.Data[] calldata) external override {
        ++authStorage.callCounts[txID];
        authStorage.initialized[txID] = true;
    }

    function sign(bytes32 txID, AuthAccount.Data[] calldata) external override returns (bool) {
        ++authStorage.callCounts[txID];
        return true;
    }

    function isCompletedAuth(
        bytes32 /*txID*/
    )
        external
        pure
        override
        returns (bool)
    {
        return true;
    }

    function getAuthState(
        bytes32 /*txID*/
    )
        external
        pure
        override
        returns (TxAuthState.Data memory)
    {
        AuthAccount.Data[] memory remaining = new AuthAccount.Data[](1);
        GoogleProtobufAny.Data memory emptyAny = GoogleProtobufAny.Data({type_url: "", value: ""});
        AuthType.Data memory localAuthType = AuthType.Data({mode: AuthType.AuthMode.AUTH_MODE_LOCAL, option: emptyAny});
        remaining[0] = AuthAccount.Data({id: bytes("signerA"), auth_type: localAuthType});

        return TxAuthState.Data({remaining_signers: remaining});
    }

    function verifySignatures(bytes32 txIDHash, AuthAccount.Data[] calldata) external override {
        ++authStorage.callCounts[txIDHash];
    }
}

contract MockTxManager is ITxManager, MockStore {
    function initialize(IIBCHandler, IContractModule) external override {
        // No-op
    }

    function createTx(bytes32 txID, MsgInitiateTx.Data calldata src) external override {
        txStorage.status[txID] = MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_PENDING;
        txStorage.nonce[txID] = src.nonce;
    }

    function runTxIfCompleted(bytes32 txID) external override {
        txStorage.status[txID] = MsgInitiateTxResponse.InitiateTxStatus.INITIATE_TX_STATUS_VERIFIED;
        txStorage.nonce[txID] = 1;
    }

    function isTxRecorded(
        bytes32 /*txID*/
    )
        external
        pure
        override
        returns (bool)
    {
        return true;
    }

    function getCoordinatorState(bytes32 txID) external view override returns (CoordinatorState.Data memory) {
        return txStorage.coordStates[txID];
    }

    function handlePacket(Packet calldata) external override returns (bytes memory) {
        ++txStorage.handlePacketCount;
        return hex"1234";
    }

    function handleAcknowledgement(Packet calldata, bytes calldata) external override {
        ++txStorage.handleAckCount;
    }

    function handleTimeout(Packet calldata) external override {
        ++txStorage.handleTimeoutCount;
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
    uint256 public internalState;

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

    function exposed_verifySignatures(bytes32 txIDHash, AuthAccount.Data[] calldata signers) public {
        _verifySignatures(txIDHash, signers);
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

    function exposed_getCoordinatorState(bytes32 txID) public returns (CoordinatorState.Data memory) {
        return _getCoordinatorState(txID);
    }

    function exposed_handlePacket(Packet calldata packet) public returns (bytes memory) {
        return _handlePacket(packet);
    }

    function exposed_handleAcknowledgement(Packet calldata packet, bytes calldata acknowledgement) public {
        _handleAcknowledgement(packet, acknowledgement);
    }

    function exposed_handleTimeout(Packet calldata packet) public {
        _handleTimeout(packet);
    }

    function exposed_delegateWithData(address impl, bytes memory data) public returns (bytes memory) {
        return _delegateWithData(impl, data);
    }

    function exposed_staticCallSelf(bytes memory callData) public view returns (bytes memory) {
        return _staticCallSelf(callData);
    }

    function echo(uint256 val) external pure returns (uint256) {
        return val;
    }

    function triggerRevert(string calldata reason) external pure {
        revert(reason);
    }

    function revertEmpty() external pure {
        assembly {
            revert(0, 0)
        }
    }

    function stateChange(uint256 val) external {
        internalState = val;
    }

    function setCoordState(bytes32 txID, CoordinatorState.Data calldata data) external {
        txStorage.coordStates[txID] = data;
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

    function readTx_handlePacketCount() public view returns (uint256) {
        return txStorage.handlePacketCount;
    }

    function readTx_handleAckCount() public view returns (uint256) {
        return txStorage.handleAckCount;
    }

    function readTx_handleTimeoutCount() public view returns (uint256) {
        return txStorage.handleTimeoutCount;
    }
}

contract DelegatedLogicHandlerTest is Test, ICrossError {
    MockTxAuthManager private mockAuth;
    MockTxManager private mockTx;
    DelegatedLogicHandlerHarness private harness;

    bytes32 private txID = keccak256("test_tx_id");
    AuthAccount.Data[] private signers;
    MsgInitiateTx.Data private txMsg;
    Packet private dummyPacket;

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

        dummyPacket = Packet({
            sequence: 1,
            sourcePort: "src",
            sourceChannel: "channel-0",
            destinationPort: "dst",
            destinationChannel: "channel-1",
            data: hex"00",
            timeoutHeight: Height.Data(0, 0),
            timeoutTimestamp: 0
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
        vm.expectCall(address(mockAuth), abi.encodeWithSelector(ITxAuthManager.isCompletedAuth.selector, txID));

        bool result = harness.exposed_isCompletedAuth(txID);

        assertTrue(result, "Return value mismatch");
    }

    function test_getAuthState_DelegatesToAuthManager() public {
        vm.expectCall(address(mockAuth), abi.encodeWithSelector(ITxAuthManager.getAuthState.selector, txID));

        TxAuthState.Data memory result = harness.exposed_getAuthState(txID);

        assertEq(result.remaining_signers.length, 1, "Return value (signers length) mismatch");
        assertEq(result.remaining_signers[0].id, signers[0].id, "Return value (signer id) mismatch");
    }

    function test_verifySignatures_DelegatesToAuthManager() public {
        harness.exposed_verifySignatures(txID, signers);

        assertEq(harness.readAuth_callCount(txID), 1, "AuthManager.verifySignatures should be called once");
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
        vm.expectCall(address(mockTx), abi.encodeWithSelector(ITxManager.isTxRecorded.selector, txID));

        bool result = harness.exposed_isTxRecorded(txID);

        assertTrue(result, "Return value mismatch");
    }

    function test_handlePacket_DelegatesToTxManager() public {
        bytes memory ack = harness.exposed_handlePacket(dummyPacket);

        assertEq(harness.readTx_handlePacketCount(), 1, "handlePacket call count mismatch");
        assertEq(ack, hex"1234", "Acknowledgement return value mismatch");
    }

    function test_handleAcknowledgement_DelegatesToTxManager() public {
        harness.exposed_handleAcknowledgement(dummyPacket, hex"beef");

        assertEq(harness.readTx_handleAckCount(), 1, "handleAcknowledgement call count mismatch");
    }

    function test_handleTimeout_DelegatesToTxManager() public {
        harness.exposed_handleTimeout(dummyPacket);

        assertEq(harness.readTx_handleTimeoutCount(), 1, "handleTimeout call count mismatch");
    }

    function test_getCoordinatorState_DelegatesToTxManager() public {
        CoordinatorState.Data memory expected;
        expected.commit_protocol = Tx.CommitProtocol.COMMIT_PROTOCOL_SIMPLE;
        expected.phase = CoordinatorState.CoordinatorPhase.COORDINATOR_PHASE_PREPARE;
        harness.setCoordState(txID, expected);

        vm.expectCall(address(mockTx), abi.encodeWithSelector(ITxManager.getCoordinatorState.selector, txID));
        CoordinatorState.Data memory actual = harness.exposed_getCoordinatorState(txID);

        assertEq(uint256(actual.commit_protocol), uint256(expected.commit_protocol), "Commit protocol mismatch");
        assertEq(uint256(actual.phase), uint256(expected.phase), "Phase mismatch");
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

        vm.expectRevert(abi.encodeWithSelector(DelegateCallFailed.selector, address(reverter)));
        harness.exposed_delegateWithData(address(reverter), data);
    }

    function test_staticCallSelf_Succeeds() public {
        uint256 input = 999;
        bytes memory callData = abi.encodeWithSelector(harness.echo.selector, input);

        bytes memory ret = harness.exposed_staticCallSelf(callData);
        uint256 decoded = abi.decode(ret, (uint256));

        assertEq(decoded, input, "staticCallSelf return value mismatch");
    }

    function test_staticCallSelf_RevertsIf_TargetReverts() public {
        string memory reason = "StaticCallError";
        bytes memory callData = abi.encodeWithSelector(harness.triggerRevert.selector, reason);

        vm.expectRevert(bytes(reason));
        harness.exposed_staticCallSelf(callData);
    }

    function test_staticCallSelf_RevertsIf_CallFailsEmpty() public {
        bytes memory callData = abi.encodeWithSelector(harness.revertEmpty.selector);

        vm.expectRevert(StaticCallFailed.selector);
        harness.exposed_staticCallSelf(callData);
    }

    function test_staticCallSelf_RevertsIf_OnStateChange() public {
        uint256 newVal = 777;
        bytes memory callData = abi.encodeWithSelector(harness.stateChange.selector, newVal);

        vm.expectRevert(StaticCallFailed.selector);
        harness.exposed_staticCallSelf(callData);
    }

    function test_isCompletedAuth_RevertIf_CalledExternally() public {
        // Test: __isCompletedAuth
        vm.expectRevert(abi.encodeWithSelector(UnauthorizedCaller.selector, address(this)));
        harness.__isCompletedAuth(txID);
    }

    function test_getAuthState_RevertIf_CalledExternally() public {
        // Test: __getAuthState
        vm.expectRevert(abi.encodeWithSelector(UnauthorizedCaller.selector, address(this)));
        harness.__getAuthState(txID);
    }

    function test_isTxRecorded_RevertIf_CalledExternally() public {
        // Test: __isTxRecorded
        vm.expectRevert(abi.encodeWithSelector(UnauthorizedCaller.selector, address(this)));
        harness.__isTxRecorded(txID);
    }

    function test_getCoordinatorState_RevertIf_CalledExternally() public {
        // Test: __getCoordinatorState
        vm.expectRevert(abi.encodeWithSelector(UnauthorizedCaller.selector, address(this)));
        harness.__getCoordinatorState(txID);
    }
}
