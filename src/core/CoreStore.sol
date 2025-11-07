// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {MsgInitiateTx, MsgInitiateTxResponse} from "../proto/cross/core/initiator/Initiator.sol";
import {Account} from "../proto/cross/core/auth/Auth.sol";
import {Tx as AtomicTx, ChannelInfo, CoordinatorState} from "src/proto/cross/core/atomic/simple/AtomicSimple.sol";

/// @notice CROSS core storage (ERC-7201 style; fixed slots computed offline)
abstract contract CoreStore {
    // ========= fixed storage locations (computed with ERC-7201 formula) =========
    // keccak256(abi.encode(uint256(keccak256("cross.core.auth"))  - 1)) & ~bytes32(uint256(0xff))
    bytes32 internal constant AUTH_STORAGE_LOCATION =
        hex"93e3b8eb4220ad7cd6d04c9032dc8d35824a37bf01220f3aeab27e9ece04f300";

    // keccak256(abi.encode(uint256(keccak256("cross.core.tx"))    - 1)) & ~bytes32(uint256(0xff))
    bytes32 internal constant TX_STORAGE_LOCATION =
        hex"2af14e14eac421b9203c410963a611c3e22a3e7dd2f462f3872422d801fd5a00";

    // keccak256(abi.encode(uint256(keccak256("cross.core.coord")) - 1)) & ~bytes32(uint256(0xff))
    bytes32 internal constant COORD_STORAGE_LOCATION =
        hex"ef61b39f0bec0016a7c6e65e3ee8d2ea1b2327afbd737de3be2c6827c42f9600";

    // ========= Auth =========
    struct AuthStorage {
        mapping(bytes32 => mapping(bytes32 => bool)) remaining; // txId => signerKey => need?
        mapping(bytes32 => uint256) remainingCount;
        mapping(bytes32 => bool) authInitialized;
        mapping(bytes32 => Account.Data[]) requiredAccounts;
    }

    // ========= Tx =========
    struct TxStorage {
        mapping(bytes32 => bool) txExists;
        mapping(bytes32 => MsgInitiateTx.Data) txMsg;
        mapping(bytes32 => MsgInitiateTxResponse.InitiateTxStatus) txStatus;
    }

    // ========= Coordinator =========
    struct CoordEntry {
        bool exists;
        CoordinatorState.Data data;
    }

    struct CoordStorage {
        mapping(bytes32 => CoordEntry) states;
    }

    // ========= Getters =========
    function _getAuthStorage() internal pure returns (AuthStorage storage $) {
        assembly { $.slot := AUTH_STORAGE_LOCATION }
    }

    function _getTxStorage() internal pure returns (TxStorage storage $) {
        assembly { $.slot := TX_STORAGE_LOCATION }
    }

    function _getCoordStorage() internal pure returns (CoordStorage storage $) {
        assembly { $.slot := COORD_STORAGE_LOCATION }
    }
}
