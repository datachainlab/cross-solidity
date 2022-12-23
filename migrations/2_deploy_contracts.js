const MockClient = artifacts.require("@hyperledger-labs/yui-ibc-solidity/MockClient");
const IBCClient = artifacts.require("@hyperledger-labs/yui-ibc-solidity/IBCClient");
const IBCConnection = artifacts.require("@hyperledger-labs/yui-ibc-solidity/IBCConnection");
const IBCChannel = artifacts.require("@hyperledger-labs/yui-ibc-solidity/IBCChannel");
const IBCHandler = artifacts.require("@hyperledger-labs/yui-ibc-solidity/OwnableIBCHandler");
const IBCMsgs = artifacts.require("@hyperledger-labs/yui-ibc-solidity/IBCMsgs");
const IBCCommitment = artifacts.require("@hyperledger-labs/yui-ibc-solidity/IBCCommitment");
const CrossSimpleModule = artifacts.require("CrossSimpleModule");
const MockCrossContract = artifacts.require("MockCrossContract");

const deployCore = async (deployer) => {
  await deployer.deploy(IBCCommitment);
  await deployer.link(IBCCommitment, [IBCClient, IBCConnection, IBCChannel, IBCHandler]);

  await deployer.deploy(IBCMsgs);
  await deployer.link(IBCMsgs, [
    IBCClient,
    IBCConnection,
    IBCChannel,
    IBCHandler
  ]);

  await deployer.deploy(IBCClient);
  await deployer.link(IBCClient, [IBCHandler, IBCConnection, IBCChannel, IBCCommitment]);

  await deployer.deploy(IBCConnection);
  await deployer.link(IBCConnection, [IBCHandler, IBCChannel, IBCCommitment]);

  await deployer.deploy(IBCChannel);
  await deployer.link(IBCChannel, [IBCHandler, IBCCommitment]);

  await deployer.deploy(IBCHandler, IBCClient.address, IBCConnection.address, IBCChannel.address, IBCChannel.address);

  await deployer.deploy(MockClient, IBCHandler.address);
};

const deployApp = async (deployer) => {
  console.log("deploying app contracts");

  await deployer.deploy(MockCrossContract);
  await deployer.deploy(CrossSimpleModule, IBCHandler.address, MockCrossContract.address, true);
};

module.exports = async function (deployer) {
  await deployCore(deployer);
  await deployApp(deployer);
};
