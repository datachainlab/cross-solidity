package consts

import (
	"github.com/ethereum/go-ethereum/common"
)

const (
	IBCHandlerAddress = "0xaa43d337145E8930d01cb4E60Abf6595C692921E"
	CrossSimpleModuleAddress = "0x87d7778dbc81251D5A0D78DFD8a0C359887E98C9"
	TxManagerAddress = "0xa7f733a4fEA1071f58114b203F57444969b86524"
)

type contractConfig struct{}

var Contract contractConfig

func (contractConfig) GetIBCHandlerAddress() common.Address {
	return common.HexToAddress(IBCHandlerAddress)
}

func (contractConfig) GetCrossSimpleModuleAddress() common.Address {
	return common.HexToAddress(CrossSimpleModuleAddress)
}

func (contractConfig) GetTxManagerAddress() common.Address {
	return common.HexToAddress(TxManagerAddress)
}
