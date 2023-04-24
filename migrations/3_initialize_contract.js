const IBCHandler = artifacts.require("@hyperledger-labs/yui-ibc-solidity/OwnableIBCHandler.sol");
const MockClient = artifacts.require("@hyperledger-labs/yui-ibc-solidity/MockClient");
const CrossSimpleModule = artifacts.require("CrossSimpleModule");

const PortCross = "cross"
const MockClientType = "mock-client"

module.exports = async function (deployer) {
  const ibcHandler = await IBCHandler.deployed();

  for(const promise of [
    () => ibcHandler.bindPort(PortCross, CrossSimpleModule.address),
    () => ibcHandler.registerClient(MockClientType, MockClient.address)
  ]) {
    const result = await promise();
    console.log(result);
    if(!result.receipt.status) {
      throw new Error(`transaction failed to execute. ${result.tx}`);
    }
  }
};
