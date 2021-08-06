
ABIGEN ?= abigen
SOLPB_EXTERNAL_RUNTIME_REPO ?= @hyperledger-labs/yui-ibc-solidity/contracts/core/types/

.PHONY: test
test:
	go test -v ./pkg/...

.PHONY: solpb
solpb:
	SOLPB_EXTERNAL_RUNTIME_REPO=$(SOLPB_EXTERNAL_RUNTIME_REPO) ./scripts/solpb.sh

.PHONY: abi
abi:
ifdef SOURCE
	$(eval TARGET := $(shell echo ${SOURCE} | tr A-Z a-z))
	@mkdir -p ./build/abi ./pkg/contract
	@mkdir -p ./pkg/contract/$(TARGET)
	@cat ./build/contracts/${SOURCE}.json | jq ".abi" > ./build/abi/${SOURCE}.abi
	$(ABIGEN) --abi ./build/abi/${SOURCE}.abi --pkg $(TARGET) --out ./pkg/contract/$(TARGET)/$(TARGET).go
else
	@echo "'SOURCE={SOURCE}' is required"
endif
