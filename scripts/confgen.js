#!/usr/bin/env node
const fs = require("fs");
const ejs = require("ejs");
const path = require("path");
const util = require("util");

const renderFile = util.promisify(ejs.renderFile);

const {
  CONF_TPL,
  IBC_HANDLER,
  CROSS_SIMPLE_MODULE,
  CHAIN_ID = "5777",
  BROADCAST_DIR = "broadcast",
} = process.env;

if (!CONF_TPL) {
  console.error("You must set environment variable 'CONF_TPL'");
  process.exit(1);
}

function makePairs(arr) {
  const pairs = [];
  for (let i = 0; i < arr.length; i += 2) {
    if (arr[i + 1] === undefined) {
      console.error("invalid pair found in CONF_TPL");
      process.exit(1);
    }
    pairs.push([arr[i], arr[i + 1]]);
  }
  return pairs;
}

function latestJson(name) {
  const p = path.join(BROADCAST_DIR, `${name}/${CHAIN_ID}/run-latest.json`);
  if (!fs.existsSync(p)) {
    throw new Error(`broadcast not found: ${p}`);
  }
  return JSON.parse(fs.readFileSync(p, "utf8"));
}

function pickAddr(json, contractName) {
  const txs = json.transactions || [];
  const hit = txs.filter((t) => t.contractName === contractName && t.contractAddress).pop();
  return hit && hit.contractAddress;
}

(async () => {
  let ibc = IBC_HANDLER;
  let cross = CROSS_SIMPLE_MODULE;

  if (!ibc || !cross) {
    const core = latestJson("001_DeployCore.s.sol");
    const app = latestJson("002_DeployApp.s.sol");
    ibc = ibc || pickAddr(core, "OwnableIBCHandler");
    cross = cross || pickAddr(app, "CrossSimpleModule");
  }

  if (!ibc || !cross) {
    console.error("failed to resolve contract addresses (ENV or broadcast)");
    process.exit(1);
  }

  const targets = makePairs(CONF_TPL.split(":"));
  for (const [outPath, tplPath] of targets) {
    const str = await renderFile(tplPath, {
      IBCHandlerAddress: ibc,
      CrossSimpleModuleAddress: cross,
    });
    fs.writeFileSync(outPath, str);
    console.log("generated file", outPath);
  }
})().catch((e) => {
  console.error(e);
  process.exit(1);
});
