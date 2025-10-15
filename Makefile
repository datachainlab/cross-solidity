ABIGEN ?= abigen

.PHONY: test
test:
	go test -v ./pkg/...

.PHONY: protogen
protogen:
	./scripts/protogen.sh

.PHONY: abi
abi:
ifdef SOURCE
	$(eval TARGET := $(shell echo ${SOURCE} | tr A-Z a-z))
	@mkdir -p ./build/abi ./pkg/contract/$(TARGET)
	# Foundry の成果物から ABI を抽出して保存
	@cat ./build/$(SOURCE).sol/$(SOURCE).json | jq '.abi' > ./build/abi/$(SOURCE).abi
	# Go バインディング生成
	$(ABIGEN) --abi ./build/abi/$(SOURCE).abi --pkg $(TARGET) --out ./pkg/contract/$(TARGET)/$(TARGET).go
else
	@echo "'SOURCE={ContractName}' is required, e.g. make abi SOURCE=CrossSimpleModule"
	@exit 1
endif
