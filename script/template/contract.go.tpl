package consts

import (
	"github.com/ethereum/go-ethereum/common"
)

const (
	IBCHandlerAddress = "<%= IBCHandlerAddress; %>"
	CrossSimpleModuleAddress = "<%= CrossSimpleModuleAddress; %>"
	TxManagerAddress = "<%= TxManagerAddress; %>"
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
