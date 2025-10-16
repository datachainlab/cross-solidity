#!/usr/bin/env node
const fs = require("fs");
const ejs = require("ejs");
const path = require("path");
const util = require("util");

const renderFile = util.promisify(ejs.renderFile);

const {
  CONF_TPL,
  CHAIN_ID = "31337",
  DEPLOYMENTS_TOML = "deployments.toml",
} = process.env;

if (!CONF_TPL) {
  console.error("You must set environment variable 'CONF_TPL'");
  process.exit(1);
}

/** "a:b:c:d" -> [["a","b"],["c","d"]] */
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

// Minimal TOML parser for our specific use case
function parseTomlMinimal(src) {
  const lines = src.split(/\r?\n/);
  const root = {};
  let current = root;
  let sectionPath = [];

  const setPath = (obj, pathArr) => {
    let cur = obj;
    for (const key of pathArr) {
      if (!(key in cur)) cur[key] = {};
      cur = cur[key];
    }
    return cur;
  };

  for (const raw of lines) {
    const line = raw.trim();
    if (!line || line.startsWith("#")) continue;

    // [section] / [a.b]
    const mSec = line.match(/^\[([^\]]+)\]$/);
    if (mSec) {
      sectionPath = mSec[1].split(".").map(s => s.trim());
      current = setPath(root, sectionPath);
      continue;
    }

    // key = value
    const mKv = line.match(/^([A-Za-z0-9_\-\.]+)\s*=\s*(.+)$/);
    if (mKv) {
      const key = mKv[1].trim();
      let val = mKv[2].trim();

      if (!/^"/.test(val)) {
        const idx = val.indexOf(" #");
        if (idx >= 0) val = val.slice(0, idx).trim();
      }

      if (/^".*"$/.test(val)) {
        current[key] = val.slice(1, -1);
      } else if (/^(true|false)$/i.test(val)) {
        current[key] = /^true$/i.test(val);
      } else if (/^[0-9]+$/.test(val)) {
        current[key] = Number(val);
      } else {
        current[key] = val;
      }
    }
  }
  return root;
}

function loadAddressesFromToml(tomlPath, chainId) {
  if (!fs.existsSync(tomlPath)) {
    console.error(`deployments.toml not found: ${tomlPath}`);
    process.exit(1);
  }
  const txt = fs.readFileSync(tomlPath, "utf8");
  const t = parseTomlMinimal(txt);
  const addrSec = t?.[String(chainId)]?.address;
  if (!addrSec) {
    console.error(`address section not found in deployments.toml for chain ${chainId}`);
    process.exit(1);
  }
  const ibc = addrSec.ibc_handler;
  const cross = addrSec.cross_simple_module;

  if (!ibc || !cross) {
    console.error(`missing ibc_handler or cross_simple_module in [${chainId}.address]`);
    process.exit(1);
  }
  return { ibc, cross };
}

(async () => {
  const { ibc, cross } = loadAddressesFromToml(DEPLOYMENTS_TOML, CHAIN_ID);

  const targets = makePairs(CONF_TPL.split(":"));
  for (const [outPath, tplPath] of targets) {
    const str = await renderFile(tplPath, {
      IBCHandlerAddress: ibc,
      CrossSimpleModuleAddress: cross,
    });
    fs.mkdirSync(path.dirname(outPath), { recursive: true });
    fs.writeFileSync(outPath, str);
    console.log("generated file", outPath);
  }
})().catch((e) => {
  console.error(e);
  process.exit(1);
});
