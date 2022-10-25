const HDWalletProvider = require("@truffle/hdwallet-provider");
const mnemonic =
  "math razor capable expose worth grape metal sunset metal sudden usage scheme";

module.exports = {
  networks: {
    development: {
      network_id: "*",
      provider: () =>
        new HDWalletProvider({
          mnemonic: {
            phrase: mnemonic,
          },
          providerOrUrl: "http://127.0.0.1:8545",
          addressIndex: 0,
          numberOfAddresses: 10,
        }),
    }
  },

  compilers: {
    solc: {
      version: "0.8.9",
      settings: {
        optimizer: {
          enabled: true,
          runs: 1000,
        },
      },
    },
  },
  plugins: ["truffle-contract-size"],
};
