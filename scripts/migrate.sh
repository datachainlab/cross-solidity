#!/usr/bin/env bash
set -euo pipefail

# --- Config ---
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPTS_DIR="$PROJECT_ROOT/scripts/migrate"
BROADCAST_DIR="$PROJECT_ROOT/broadcast"
YUI_BASE="$PROJECT_ROOT/node_modules/@hyperledger-labs/yui-ibc-solidity/contracts"
LIB_COMMITMENT_SPEC="$YUI_BASE/core/24-host/IBCCommitment.sol:IBCCommitment"
LIB_MSGS_SPEC="$YUI_BASE/core/25-handler/IBCMsgs.sol:IBCMsgs"

FORGE="npx -y -p @foundry-rs/forge forge"
CAST="npx -y -p @foundry-rs/forge cast"

: "${RPC_URL:=http://127.0.0.1:8545}"
: "${MNEMONIC:=math razor capable expose worth grape metal sunset metal sudden usage scheme}"
: "${PRIVATE_KEY:=$($CAST wallet private-key --mnemonic "$MNEMONIC" --mnemonic-index 0)}"

# --- Helpers ---
die() { echo "ERROR: $*" >&2; exit 1; }
need() { command -v "$1" >/dev/null 2>&1 || die "missing command: $1"; }

need jq
need curl

# --- Wait for node ---
until curl -s "$RPC_URL" -H 'Content-Type: application/json' \
  -d '{"jsonrpc":"2.0","id":1,"method":"eth_blockNumber","params":[]}' >/dev/null; do
  sleep 0.3
done

CHAIN_ID="$($CAST chain-id --rpc-url "$RPC_URL")"
echo "RPC_URL=$RPC_URL CHAIN_ID=$CHAIN_ID"

# --- Deploy libraries ---
echo "==> Deploy libraries"
LIB_COMMITMENT="$(
  $FORGE create "$LIB_COMMITMENT_SPEC" \
    --rpc-url "$RPC_URL" --private-key "$PRIVATE_KEY" --broadcast --json \
  | jq -r '.deployedTo'
)"
LIB_MSGS="$(
  $FORGE create "$LIB_MSGS_SPEC" \
    --rpc-url "$RPC_URL" --private-key "$PRIVATE_KEY" --broadcast --json \
  | jq -r '.deployedTo'
)"
[[ -n "${LIB_COMMITMENT:-}" && "$LIB_COMMITMENT" != "null" ]] || die "failed to deploy IBCCommitment"
[[ -n "${LIB_MSGS:-}" && "$LIB_MSGS" != "null" ]] || die "failed to deploy IBCMsgs"
echo "  IBCCommitment: $LIB_COMMITMENT"
echo "  IBCMsgs      : $LIB_MSGS"

# --- 001_DeployCore ---
echo "==> 001_DeployCore"
$FORGE script "$SCRIPTS_DIR/001_DeployCore.s.sol:DeployCore" \
  --rpc-url "$RPC_URL" --broadcast --private-key "$PRIVATE_KEY" \
  --libraries "$LIB_COMMITMENT_SPEC:$LIB_COMMITMENT" \
  --libraries "$LIB_MSGS_SPEC:$LIB_MSGS"

CORE_JSON="$BROADCAST_DIR/001_DeployCore.s.sol/$CHAIN_ID/run-latest.json"
[[ -f "$CORE_JSON" ]] || die "broadcast not found: $CORE_JSON"

IBC_HANDLER="$(jq -r '.transactions[] | select(.contractName=="OwnableIBCHandler") | .contractAddress' "$CORE_JSON" | tail -n1)"
[[ -n "$IBC_HANDLER" && "$IBC_HANDLER" != "null" ]] || die "failed to extract IBC_HANDLER"
echo "  IBC_HANDLER: $IBC_HANDLER"

# --- 002_DeployApp ---
echo "==> 002_DeployApp"
$FORGE script "$SCRIPTS_DIR/002_DeployApp.s.sol:DeployApp" \
  --rpc-url "$RPC_URL" --broadcast --private-key "$PRIVATE_KEY" \
  --sig "run(address,bool)" "$IBC_HANDLER" true

APP_JSON="$BROADCAST_DIR/002_DeployApp.s.sol/$CHAIN_ID/run-latest.json"
[[ -f "$APP_JSON" ]] || die "broadcast not found: $APP_JSON"

CROSS_SIMPLE_MODULE="$(jq -r '.transactions[] | select(.contractName=="CrossSimpleModule") | .contractAddress' "$APP_JSON" | tail -n1)"
MOCK_CLIENT="$(jq -r '.transactions[] | select(.contractName=="MockClient") | .contractAddress' "$APP_JSON" | tail -n1)"
[[ -n "$CROSS_SIMPLE_MODULE" && "$CROSS_SIMPLE_MODULE" != "null" ]] || die "failed to extract CrossSimpleModule"
[[ -n "$MOCK_CLIENT" && "$MOCK_CLIENT" != "null" ]] || die "failed to extract MockClient"
echo "  CROSS_SIMPLE_MODULE: $CROSS_SIMPLE_MODULE"
echo "  MOCK_CLIENT        : $MOCK_CLIENT"

PORT_CROSS="${PORT_CROSS:-cross}"
MOCK_CLIENT_TYPE="${MOCK_CLIENT_TYPE:-mock-client}"

# --- 003_Initialize ---
echo "==> 003_Initialize"
$FORGE script "$SCRIPTS_DIR/003_Initialize.s.sol:InitializeContracts" \
  --rpc-url "$RPC_URL" --broadcast --private-key "$PRIVATE_KEY" \
  --sig "run(address,address,address,string,string)" \
  "$IBC_HANDLER" "$CROSS_SIMPLE_MODULE" "$MOCK_CLIENT" "$PORT_CROSS" "$MOCK_CLIENT_TYPE"

echo "==> DONE 🎉"
