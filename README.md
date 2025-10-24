# cross-solidity

![Test](https://github.com/datachainlab/cross-solidity/workflows/Test/badge.svg)
[![GoDoc](https://godoc.org/github.com/datachainlab/cross-solidity?status.svg)](https://pkg.go.dev/github.com/datachainlab/cross-solidity?tab=doc)

This is a solidity implementation of [Cross Framework](https://github.com/datachainlab/cross).

Currently, it provides the following features:
- the registry feature that allows developers to register their contracts
- the participant feature of the simple commit protocol
- it's implemented on top of [yui-ibc-solidity](https://github.com/hyperledger-labs/yui-ibc-solidity)

A coordinator feature of the simple commit and two-phase commit will be provided in the future.

## Contract module development

A developer who develops contract using Cross Framework need to implement IContractModule, which is defined in [IContractModule.sol](./src/core/IContractModule.sol).

```
// IContractModule defines the expected interface of a contract module on Cross Framework
interface IContractModule {
    // onContractCall is a callback function that is called at the commit(simple-commit) phase
    function onContractCall(CrossContext calldata context, bytes calldata callInfo) external returns (bytes memory);
}
```

- Currently, only one function `onContractCall` is defined, which implements the process of a transaction called via the cross-chain transaction.

- The return value of `onContractCall` is emitted as an Event `OnContractCall` with the transaction info.

- If it gets an unexpected call, the developer need to perform `revert` in the contract. This will request the coordinator to abort the transaction.

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
