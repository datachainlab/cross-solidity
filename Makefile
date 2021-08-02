.PHONY: proto-gen
proto-gen:
	@echo "Generating Protobuf files"
	docker run -v $(CURDIR):/workspace --workdir /workspace tendermintdev/sdk-proto-gen sh ./scripts/protocgen.sh

.PHONY: solpb
solpb:
	SOLPB_EXTERNAL_RUNTIME_REPO=@hyperledger-labs/yui-ibc-solidity/contracts/core/types/ ./scripts/solpb.sh
