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

A developer who develops contract using Cross Framework need to implement IContractModule, which is defined in [IContractModule.sol](./contract/core/IContractModule.sol).

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

[Here](./migrations/2_deploy_contracts.js) is an example of deploying with the module `CrossSimpleModule` that implements the simple commit.
