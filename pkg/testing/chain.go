package testing

import (
	"testing"

	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/ethereum/go-ethereum/rpc"

	"github.com/datachainlab/cross-solidity/pkg/contract/crosssimplemodule"
	"github.com/datachainlab/cross-solidity/pkg/contract/ibchandler"
	"github.com/datachainlab/cross-solidity/pkg/contract/ibchost"
	"github.com/ethereum/go-ethereum/common"
)

type Chain struct {
	ETHClient *ethclient.Client

	// Core modules
	IBCHandler ibchandler.Ibchandler
	IBCHost    ibchost.Ibchost

	// App modules
	CrossSimpleModule crosssimplemodule.Crosssimplemodule
}

type ContractConfig interface {
	GetIBCHostAddress() common.Address
	GetIBCHandlerAddress() common.Address
	GetCrossSimpleModuleAddress() common.Address
}

func NewChain(t *testing.T, rpcAddr string, ccfg ContractConfig) *Chain {
	ethc, err := NewETHClient(rpcAddr)
	if err != nil {
		panic(err)
	}
	crossMod, err := crosssimplemodule.NewCrosssimplemodule(ccfg.GetCrossSimpleModuleAddress(), ethc)
	if err != nil {
		panic(err)
	}
	return &Chain{
		ETHClient:         ethc,
		CrossSimpleModule: *crossMod,
	}
}

func NewETHClient(rpcAddr string) (*ethclient.Client, error) {
	conn, err := rpc.DialHTTP(rpcAddr)
	if err != nil {
		return nil, err
	}
	return ethclient.NewClient(conn), nil
}
