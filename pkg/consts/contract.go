package consts

import (
	"github.com/ethereum/go-ethereum/common"
)

const (
	IBCHostAddress           = "0xff77D90D6aA12db33d3Ba50A34fB25401f6e4c4F"
	IBCHandlerAddress        = "0x2F5703804E29F4252FA9405B8D357220d11b3bd9"
	CrossSimpleModuleAddress = "0xa7f733a4fEA1071f58114b203F57444969b86524"
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
