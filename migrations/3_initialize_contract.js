const IBCHost = artifacts.require("IBCHost");
const IBCHandler = artifacts.require("IBCHandler");
const MockClient = artifacts.require("MockClient");
const CrossSimpleModule = artifacts.require("CrossSimpleModule");

const PortCross = "cross"
const MockClientType = "mock-client"

module.exports = async function (deployer) {
  const ibcHost = await IBCHost.deployed();
  const ibcHandler = await IBCHandler.deployed();

  for(const promise of [
    () => ibcHost.setIBCModule(IBCHandler.address),
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
