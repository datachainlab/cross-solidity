#!/bin/bash
set -ex

TRUFFLE="npx truffle"
SOLPB_EXTERNAL_RUNTIME_REPO="@hyperledger-labs/yui-ibc-solidity/contracts/core/types/"
# the contracts to generate ABI
CONTRACTS=(
    "OwnableIBCHandler"
    "CrossSimpleModule"
)

function before_common() {
    if [ -n "$NO_GEN_CODE" ]; then
        return
    fi
    export SOLPB_EXTERNAL_RUNTIME_REPO
    ./scripts/solpb.sh
}

function after_common() {
    if [ -n "$NO_GEN_CODE" ]; then
        return
    fi
    for contract in "${CONTRACTS[@]}" ; do
        make abi SOURCE=${contract}
    done
}

function chain() {
    if [ -z "$network" ]; then
        echo "variable network must be set"
        exit 1
    fi
    if [ -z "$CONF_TPL" ]; then
        echo "variable CONF_TPL must be set"
        exit 1
    fi

    pushd ./chains && docker-compose up -d ${network} && popd
    # XXX Wait for the first block to be created
    sleep 3
    ${TRUFFLE} migrate --reset --network=${network}
    ${TRUFFLE} exec ./scripts/confgen.js --network=${network}
}

function development {
    before_common

    network=development
    export CONF_TPL="./pkg/consts/contract.go:./scripts/template/contract.go.tpl"
    chain

    after_common
}

function down {
    pushd ./chains && docker-compose down && popd
}

subcommand="$1"
shift

case $subcommand in
    development)
        development
        ;;
    down)
        down
        ;;
    *)
        echo "unknown command '$subcommand'"
        ;;
esac
