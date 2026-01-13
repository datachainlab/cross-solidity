// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {IAuthExtensionVerifier} from "./IAuthExtensionVerifier.sol";
import {IContractModule} from "./IContractModule.sol";
import {MsgInitiateTxResponse, Tx} from "../proto/cross/core/initiator/Initiator.sol";
import {Account} from "../proto/cross/core/auth/Auth.sol";
import {CoordinatorState, ContractTransactionState} from "../proto/cross/core/atomic/simple/AtomicSimple.sol";
import {ChannelInfo} from "../proto/cross/core/xcc/XCC.sol";
import {IIBCHandler} from "@hyperledger-labs/yui-ibc-solidity/contracts/core/25-handler/IIBCHandler.sol";

abstract contract CrossStore {
    // keccak256(abi.encode(uint256(keccak256("cross.core.auth")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 internal constant AUTH_STORAGE_LOCATION =
        hex"93e3b8eb4220ad7cd6d04c9032dc8d35824a37bf01220f3aeab27e9ece04f300";

    // keccak256(abi.encode(uint256(keccak256("cross.core.tx")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 internal constant TX_STORAGE_LOCATION =
        hex"2af14e14eac421b9203c410963a611c3e22a3e7dd2f462f3872422d801fd5a00";

    // keccak256(abi.encode(uint256(keccak256("cross.core.coord")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 internal constant COORD_STORAGE_LOCATION =
        hex"ef61b39f0bec0016a7c6e65e3ee8d2ea1b2327afbd737de3be2c6827c42f9600";

    struct AuthStorage {
        mapping(string => IAuthExtensionVerifier) authVerifiers;
        mapping(bytes32 => mapping(bytes32 => bool)) remaining;
        mapping(bytes32 => uint256) remainingCount;
        mapping(bytes32 => bool) authInitialized;
        mapping(bytes32 => Account.Data[]) requiredAccounts;
    }

    struct TxStorage {
        mapping(bytes32 => Account.Data[]) txCoordSigners;
        mapping(bytes32 => MsgInitiateTxResponse.InitiateTxStatus) txStatus;
        mapping(bytes32 => mapping(uint256 => ContractTransactionState.Data)) states;
        IContractModule contractModule;
        IIBCHandler ibcHandler;
    }

    struct CoordStorage {
        mapping(bytes32 => CoordStateCompact) compactStates;
    }

    struct CoordStateCompact {
        Tx.CommitProtocol commitProtocol;
        CoordinatorState.CoordinatorPhase phase;
        CoordinatorState.CoordinatorDecision decision;

        string participantPort;
        string participantChannel;

        uint8 confirmedMask; // bit0=coord, bit1=participant
        uint8 ackMask; // bit0=coord, bit1=participant
    }

    function _getAuthStorage() internal pure returns (AuthStorage storage $) {
        // solhint-disable-next-line no-inline-assembly
        assembly { $.slot := AUTH_STORAGE_LOCATION }
    }

    function _getTxStorage() internal pure returns (TxStorage storage $) {
        // solhint-disable-next-line no-inline-assembly
        assembly { $.slot := TX_STORAGE_LOCATION }
    }

    function _getCoordStorage() internal pure returns (CoordStorage storage $) {
        // solhint-disable-next-line no-inline-assembly
        assembly { $.slot := COORD_STORAGE_LOCATION }
    }

    function _loadCoordinatorState(bytes32 txID) internal view returns (CoordinatorState.Data memory) {
        CoordStorage storage $ = _getCoordStorage();
        CoordStateCompact storage compact = $.compactStates[txID];

        CoordinatorState.Data memory data;
        data.commit_protocol = compact.commitProtocol;
        data.phase = compact.phase;
        data.decision = compact.decision;

        data.channels = new ChannelInfo.Data[](2);
        data.channels[0] = ChannelInfo.Data("", ""); // Local
        data.channels[1] = ChannelInfo.Data(compact.participantPort, compact.participantChannel);

        data.confirmed_txs = _maskToUint32Array(compact.confirmedMask);
        data.acks = _maskToUint32Array(compact.ackMask);

        return data;
    }

    function _saveCoordinatorState(bytes32 txID, CoordinatorState.Data memory data) internal {
        CoordStorage storage $ = _getCoordStorage();
        CoordStateCompact storage compact = $.compactStates[txID];

        compact.commitProtocol = data.commit_protocol;
        compact.phase = data.phase;
        compact.decision = data.decision;

        if (data.channels.length > 1) {
            compact.participantPort = data.channels[1].port;
            compact.participantChannel = data.channels[1].channel;
        }

        compact.confirmedMask = _uint32ArrayToMask(data.confirmed_txs);
        compact.ackMask = _uint32ArrayToMask(data.acks);
    }

    function _confirmParticipant(bytes32 txID) internal {
        _getCoordStorage().compactStates[txID].confirmedMask |= 0x02;
    }

    function _completeSimpleProtocol(
        bytes32 txID,
        CoordinatorState.CoordinatorPhase phase,
        CoordinatorState.CoordinatorDecision decision
    ) internal {
        CoordStateCompact storage compact = _getCoordStorage().compactStates[txID];
        compact.phase = phase;
        compact.decision = decision;
        compact.ackMask |= 0x03;
    }

    function _maskToUint32Array(uint8 mask) internal pure returns (uint32[] memory) {
        uint256 count = 0;
        if ((mask & 0x01) != 0) ++count;
        if ((mask & 0x02) != 0) ++count;

        uint32[] memory arr = new uint32[](count);
        uint256 idx = 0;
        if ((mask & 0x01) != 0) arr[idx] = 0;
        ++idx;
        if ((mask & 0x02) != 0) arr[idx] = 1;
        ++idx;
        return arr;
    }

    function _uint32ArrayToMask(uint32[] memory arr) internal pure returns (uint8 mask) {
        for (uint256 i = 0; i < arr.length;) {
            if (arr[i] == 0) mask |= 0x01;
            else if (arr[i] == 1) mask |= 0x02;
            unchecked {
                ++i;
            }
        }
    }
}
