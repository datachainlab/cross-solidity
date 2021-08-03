package testing

import (
	"context"
	"testing"

	"github.com/datachainlab/cross-solidity/pkg/consts"
	"github.com/datachainlab/cross-solidity/pkg/contract/crosssimplemodule"
	"github.com/stretchr/testify/suite"
)

const testMnemonicPhrase = "math razor capable expose worth grape metal sunset metal sudden usage scheme"

type CrossTestSuite struct {
	suite.Suite

	chain *Chain
}

func (suite *CrossTestSuite) SetupTest() {
	chain := NewChain(suite.T(), "http://127.0.0.1:8545", testMnemonicPhrase, consts.Contract)
	suite.chain = chain
}

func (suite *CrossTestSuite) TestRecvPacket() {
	ctx := context.Background()
	packetData := []byte{}

	suite.Require().NoError(suite.chain.TxSyncIfNoError(ctx)(
		suite.chain.CrossSimpleModule.OnRecvPacket(
			suite.chain.TxOpts(ctx, 0),
			crosssimplemodule.PacketData{
				Data: packetData,
			},
		),
	))
}

func TestChainTestSuite(t *testing.T) {
	suite.Run(t, new(CrossTestSuite))
}
