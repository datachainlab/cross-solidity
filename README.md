# cross-solidity

![Test](https://github.com/datachainlab/cross-solidity/workflows/Test/badge.svg)
[![GoDoc](https://godoc.org/github.com/datachainlab/cross-solidity?status.svg)](https://pkg.go.dev/github.com/datachainlab/cross-solidity?tab=doc)

This is a solidity implementation of [Cross Framework](https://github.com/datachainlab/cross).

Currently, it provides the following features:
- the registry feature that allows developers to register their contracts
- the coordinator feature of the simple commit protocol
- the participant features for the simple-commit and two-phase commit protocols
- it's implemented on top of [yui-ibc-solidity](https://github.com/hyperledger-labs/yui-ibc-solidity)

The coordinator feature of the two-phase commit will be provided in the future.

## Demo

For an ERC20 atomic swap demo, please refer to [ethereum-cross-demo](https://github.com/datachainlab/ethereum-cross-demo)

## Contract module development

// IContractModule defines the expected interface of a contract module on Cross Framework
```solidity
interface IContractModule {
    // onContractCommitImmediately is a callback function that is called on the participant chain to execute the transaction logic immediately
    // This function is intended to be used only in the simple-commit protocol
    function onContractCommitImmediately(CrossContext calldata context, bytes calldata callInfo)
        external
        returns (bytes memory);

    // onContractPrepare is a callback function that is called at the prepare(2pc) phase
    function onContractPrepare(CrossContext calldata context, bytes calldata callInfo) external returns (bytes memory);

    // onCommit is a callback function that is called at the commit(2pc) phase
    // It is expected that it commits the changes in the contract module
    // IMPORTANT: This function MUST NOT revert.
    function onCommit(CrossContext calldata context) external;

    // onAbort is a callback function that is called at the commit(2pc) phase
    // It is expected that it aborts the changes in the contract module
    // IMPORTANT: This function MUST NOT revert.
    function onAbort(CrossContext calldata context) external;
}
```

- For the current simple-commit coordinator flow, the coordinator-side participant uses `onContractPrepare` to execute and lock state changes, and later finalizes them with `onCommit` or `onAbort` based on the acknowledgement from the counterparty.

- The counterparty participant executes the incoming call and finalizes immediately via `onContractCommitImmediately`.

- IMPORTANT: `onCommit` and `onAbort` MUST NOT revert.

## How to deploy a contract module

[Here](./script/DeployAll.s.sol) is an example of deploying with the module `CrossSimpleModule` that implements the simple commit.

## For Developers

To generate encoders and decoders in solidity from proto files, you need to use the code generator [solidity-protobuf](https://github.com/datachainlab/solidity-protobuf).

Currently, [this version](https://github.com/datachainlab/solidity-protobuf/commit/3def6706178e5407497f3d01b8f0ceb17b32108d) is required.

Install Slither and use it for static analysis.

```
pip3 install slither-analyzer
make slither
```

Lint the source code using solhint

```
npm ci
npm run lint:sol
```
