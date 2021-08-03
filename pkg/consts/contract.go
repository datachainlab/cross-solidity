package consts

import (
	"github.com/ethereum/go-ethereum/common"
)

const (
	IBCHostAddress = "0xff77D90D6aA12db33d3Ba50A34fB25401f6e4c4F"
	IBCHandlerAddress = "0x2F5703804E29F4252FA9405B8D357220d11b3bd9"
	CrossSimpleModuleAddress = "0xaE1C9125BbcF63bf51294C4D15CBD472782E330D"
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
