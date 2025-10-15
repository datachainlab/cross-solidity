package consts

import (
	"github.com/ethereum/go-ethereum/common"
)

const (
	IBCHandlerAddress        = "0x727A5648832D2b317925CE043eA9b7fE04B4CD55"
	CrossSimpleModuleAddress = "0xAA43D337145E8930D01Cb4E60AbF6595C692921E"
)

type contractConfig struct{}

var Contract contractConfig

func (contractConfig) GetIBCHandlerAddress() common.Address {
	return common.HexToAddress(IBCHandlerAddress)
}

func (contractConfig) GetCrossSimpleModuleAddress() common.Address {
	return common.HexToAddress(CrossSimpleModuleAddress)
}
