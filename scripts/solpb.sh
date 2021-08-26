#!/usr/bin/env bash
set -e

if [ -z "$SOLPB_DIR" ]; then
    echo "variable SOLPB_DIR must be set"
    exit 1
fi

for file in $(find ./proto -name '*.proto')
do
  echo "Generating "$file
  protoc -I$(pwd)/proto -I "third_party/proto" -I${SOLPB_DIR}/protobuf-solidity/src/protoc/include --plugin=protoc-gen-sol=${SOLPB_DIR}/protobuf-solidity/src/protoc/plugin/gen_sol.py --"sol_out=gen_runtime=ProtoBufRuntime.sol&solc_version=0.6.8:$(pwd)/contracts/core/types/" $(pwd)/$file
done

# TODO The following codes should be supported in solidity-protobuf

if [ -z "$SOLPB_EXTERNAL_RUNTIME_REPO" ]; then
    echo "variable SOLPB_EXTERNAL_RUNTIME_REPO must be set"
    exit 1
fi

echo ""
echo "Use the runtime packages in yui-ibc-solidity"
echo "package: $SOLPB_EXTERNAL_RUNTIME_REPO"

find ./contracts/core/types -type f \
-name '*.sol' \
-a ! -name 'ProtoBufRuntime.sol' \
-a ! -name 'GoogleProtobufAny.sol' \
-print0 | xargs -0 sed -i -E "s#(^import +\")(\.\/)(ProtoBufRuntime|GoogleProtobufAny|gogoproto.+\";)#\1$SOLPB_EXTERNAL_RUNTIME_REPO\3#"

rm -f contracts/core/types/GoogleProtobufAny.sol contracts/core/types/ProtoBufRuntime.sol

# XXX replace the proto import path with contract path
find ./contracts/core/types -type f \
-name '*.sol' \
-print0 | xargs -0 sed -i -E "s#(^import +\"\./)(.+/)(.+\";)#\1\3#"
