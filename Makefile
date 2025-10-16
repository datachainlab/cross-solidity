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
	@cat ./build/$(SOURCE).sol/$(SOURCE).json | jq '.abi' > ./build/abi/$(SOURCE).abi
	$(ABIGEN) --abi ./build/abi/$(SOURCE).abi --pkg $(TARGET) --out ./pkg/contract/$(TARGET)/$(TARGET).go
else
	@echo "'SOURCE={ContractName}' is required, e.g. make abi SOURCE=CrossSimpleModule"
	@exit 1
endif
