package consts

import (
	"github.com/ethereum/go-ethereum/common"
)

const (
	IBCHandlerAddress = "0x9eBF3956EE45B2b9F1fC85FB8990ce6be52F47a6"
	CrossSimpleModuleAddress = "0x702E40245797c5a2108A566b3CE2Bf14Bc6aF841"
)

type contractConfig struct{}

var Contract contractConfig

func (contractConfig) GetIBCHandlerAddress() common.Address {
	return common.HexToAddress(IBCHandlerAddress)
}

func (contractConfig) GetCrossSimpleModuleAddress() common.Address {
	return common.HexToAddress(CrossSimpleModuleAddress)
}
