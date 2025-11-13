// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {TxAuthManagerBase} from "./TxAuthManagerBase.sol";
import {CrossStore} from "./CrossStore.sol";
import {Account, TxAuthState, AuthType} from "../proto/cross/core/auth/Auth.sol";
import {IAuthExtensionVerifier} from "./IAuthExtensionVerifier.sol";

abstract contract TxAuthManager is TxAuthManagerBase, CrossStore {
    constructor(string[] memory typeUrls, IAuthExtensionVerifier[] memory verifiers) {
        require(typeUrls.length == verifiers.length, "TxAuthManager: array mismatch");

        CrossStore.AuthStorage storage s = _getAuthStorage();

        for (uint256 i = 0; i < typeUrls.length; i++) {
            string memory typeUrl = typeUrls[i];
            IAuthExtensionVerifier verifier = verifiers[i];

            require(bytes(typeUrl).length > 0, "TxAuthManager: empty typeUrl");
            require(address(verifier) != address(0), "TxAuthManager: zero address verifier");

            s.authVerifiers[typeUrl] = verifier;
            emit VerifierRegistered(typeUrl, address(verifier));
        }
    }

    function initAuthState(bytes32 txID, Account.Data[] memory signers) internal virtual override {
        CrossStore.AuthStorage storage s = _getAuthStorage();
        if (s.authInitialized[txID]) revert AuthStateAlreadyInitialized(txID);
        _setStateFromRemainingList(s, txID, signers);
        s.authInitialized[txID] = true;
    }

    function isCompletedAuth(bytes32 txID) internal view virtual override returns (bool) {
        CrossStore.AuthStorage storage s = _getAuthStorage();
        if (!s.authInitialized[txID]) revert IDNotFound(txID);
        return s.remainingCount[txID] == 0;
    }

    function sign(bytes32 txID, Account.Data[] memory signers) internal virtual override returns (bool) {
        CrossStore.AuthStorage storage s = _getAuthStorage();
        if (!s.authInitialized[txID]) revert IDNotFound(txID);
        if (s.remainingCount[txID] == 0) revert AuthAlreadyCompleted(txID);

        for (uint256 i = 0; i < signers.length; ++i) {
            bytes32 key = _accountKey(signers[i]);
            if (s.remaining[txID][key]) {
                s.remaining[txID][key] = false;
                --s.remainingCount[txID];
                if (s.remainingCount[txID] == 0) return true;
            }
        }
        return s.remainingCount[txID] == 0;
    }

    function getAuthState(bytes32 txID) internal view virtual override returns (TxAuthState.Data memory) {
        CrossStore.AuthStorage storage s = _getAuthStorage();
        if (!s.authInitialized[txID]) revert IDNotFound(txID);
        Account.Data[] memory remains = _getRemainingSigners(s, txID);
        return TxAuthState.Data({remaining_signers: remains});
    }

    function _getRemainingSigners(CrossStore.AuthStorage storage s, bytes32 txID)
        internal
        view
        returns (Account.Data[] memory out)
    {
        uint256 total = s.requiredAccounts[txID].length;
        uint256 need = s.remainingCount[txID];
        out = new Account.Data[](need);
        uint256 p = 0;
        for (uint256 i = 0; i < total; ++i) {
            Account.Data memory acc = s.requiredAccounts[txID][i];
            if (s.remaining[txID][_accountKey(acc)]) {
                out[p] = acc;
                ++p;
                if (p == need) break;
            }
        }
    }

    function _verifySignatures(bytes32 txIDHash, Account.Data[] calldata signers, bytes[] calldata signatures)
        internal
        view
        virtual
        override
    {
        if (signers.length != signatures.length) {
            revert SignerCountMismatch(signers.length, signatures.length);
        }

        CrossStore.AuthStorage storage s = _getAuthStorage();

        for (uint256 i = 0; i < signers.length; i++) {
            Account.Data calldata signer = signers[i];

            if (signer.auth_type.mode != AuthType.AuthMode.AUTH_MODE_EXTENSION) {
                revert AuthModeMismatch();
            }

            string calldata typeUrl = signer.auth_type.option.type_url;
            IAuthExtensionVerifier verifier = s.authVerifiers[typeUrl];
            if (address(verifier) == address(0)) {
                revert VerifierNotFound(typeUrl);
            }

            bytes calldata signature = signatures[i];
            if (!verifier.verify(txIDHash, signer, signature)) {
                revert SignatureVerificationFailed(txIDHash);
            }
        }
    }

    function _setStateFromRemainingList(CrossStore.AuthStorage storage s, bytes32 txID, Account.Data[] memory list)
        internal
    {
        for (uint256 i = 0; i < list.length; ++i) {
            bytes32 key = _accountKey(list[i]);
            if (!s.remaining[txID][key]) {
                s.remaining[txID][key] = true;
                ++s.remainingCount[txID];
                s.requiredAccounts[txID].push(list[i]);
            }
        }
    }

    function _accountKey(Account.Data memory a) internal pure returns (bytes32) {
        return keccak256(abi.encode(a.id, a.auth_type));
    }
}
