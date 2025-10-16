#!/usr/bin/env bash
set -euo pipefail

# --- Config ---
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPTS_DIR="$PROJECT_ROOT/scripts/deploy"
BROADCAST_DIR="$PROJECT_ROOT/broadcast"

FORGE="npx -y -p @foundry-rs/forge@1.4.1 forge"
CAST="npx -y -p @foundry-rs/forge@1.4.1 cast"

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

# --- 01_DeployCore ---
echo "==> 01_DeployCore"
$FORGE script "$SCRIPTS_DIR/01_DeployCore.s.sol:DeployCore" \
  --rpc-url "$RPC_URL" --broadcast --private-key "$PRIVATE_KEY"

CORE_JSON="$BROADCAST_DIR/01_DeployCore.s.sol/$CHAIN_ID/run-latest.json"
[[ -f "$CORE_JSON" ]] || die "broadcast not found: $CORE_JSON"

IBC_HANDLER="$(jq -r '.transactions[] | select(.contractName=="OwnableIBCHandler") | .contractAddress' "$CORE_JSON" | tail -n1)"
[[ -n "$IBC_HANDLER" && "$IBC_HANDLER" != "null" ]] || die "failed to extract IBC_HANDLER"
echo "  IBC_HANDLER: $IBC_HANDLER"

# --- 02_DeployApp ---
echo "==> 02_DeployApp"
$FORGE script "$SCRIPTS_DIR/02_DeployApp.s.sol:DeployApp" \
  --rpc-url "$RPC_URL" --broadcast --private-key "$PRIVATE_KEY" \
  --sig "run(address,bool)" "$IBC_HANDLER" true

APP_JSON="$BROADCAST_DIR/02_DeployApp.s.sol/$CHAIN_ID/run-latest.json"
[[ -f "$APP_JSON" ]] || die "broadcast not found: $APP_JSON"

CROSS_SIMPLE_MODULE="$(jq -r '.transactions[] | select(.contractName=="CrossSimpleModule") | .contractAddress' "$APP_JSON" | tail -n1)"
MOCK_CLIENT="$(jq -r '.transactions[] | select(.contractName=="MockClient") | .contractAddress' "$APP_JSON" | tail -n1)"
[[ -n "$CROSS_SIMPLE_MODULE" && "$CROSS_SIMPLE_MODULE" != "null" ]] || die "failed to extract CrossSimpleModule"
[[ -n "$MOCK_CLIENT" && "$MOCK_CLIENT" != "null" ]] || die "failed to extract MockClient"
echo "  CROSS_SIMPLE_MODULE: $CROSS_SIMPLE_MODULE"
echo "  MOCK_CLIENT        : $MOCK_CLIENT"

PORT_CROSS="${PORT_CROSS:-cross}"
MOCK_CLIENT_TYPE="${MOCK_CLIENT_TYPE:-mock-client}"

# --- 03_Initialize ---
echo "==> 03_Initialize"
$FORGE script "$SCRIPTS_DIR/03_Initialize.s.sol:Initialize" \
  --rpc-url "$RPC_URL" --broadcast --private-key "$PRIVATE_KEY" \
  --sig "run(address,address,address,string,string)" \
  "$IBC_HANDLER" "$CROSS_SIMPLE_MODULE" "$MOCK_CLIENT" "$PORT_CROSS" "$MOCK_CLIENT_TYPE"

echo "==> DONE 🎉"
