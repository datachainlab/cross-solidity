ABIGEN ?= abigen

.PHONY: test
test:
	go test -v ./pkg/...

.PHONY: protogen
protogen:
	./script/protogen.sh

.PHONY: abi
abi:
ifdef SOURCE
	$(eval TARGET := $(shell echo ${SOURCE} | tr A-Z a-z))
	@mkdir -p ./build/abi ./pkg/contract/$(TARGET)
	@forge build >/dev/null
	@test -f ./out/${SOURCE}.sol/${SOURCE}.json || (echo "ABI JSON not found: ./out/${SOURCE}.sol/${SOURCE}.json"; exit 1)
	@jq -c '.abi' ./out/${SOURCE}.sol/${SOURCE}.json > ./build/abi/${SOURCE}.abi
	@$(ABIGEN) --abi ./build/abi/${SOURCE}.abi --pkg $(TARGET) --out ./pkg/contract/$(TARGET)/$(TARGET).go
else
	@echo "'SOURCE={ContractName}' is required, e.g. make abi SOURCE=CrossSimpleModule"
	@exit 1
endif

.PHONY: slither
slither:
	slither .
