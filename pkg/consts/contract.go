package consts

import (
	"github.com/ethereum/go-ethereum/common"
)

const (
	IBCHostAddress = "0xBF346b5BC386c7C3378688286406B08E9327d312"
	IBCHandlerAddress = "0x4DB8e6C8BdE4c9AFCEDb590C5446c965c073BED8"
	CrossSimpleModuleAddress = "0x06e5dEB55CAffb1339fb447d860E305249EaD495"
)

type contractConfig struct{}

var Contract contractConfig

func (contractConfig) GetIBCHostAddress() common.Address {
	return common.HexToAddress(IBCHostAddress)
}

func (contractConfig) GetIBCHandlerAddress() common.Address {
	return common.HexToAddress(IBCHandlerAddress)
}

func (contractConfig) GetCrossSimpleModuleAddress() common.Address {
	return common.HexToAddress(CrossSimpleModuleAddress)
}
