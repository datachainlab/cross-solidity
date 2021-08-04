package testing

import (
	"context"
	"fmt"
	"testing"
	"time"

	simpletypes "github.com/datachainlab/cross/x/core/atomic/protocol/simple/types"
	"github.com/datachainlab/cross/x/core/tx/types"
	xcctypes "github.com/datachainlab/cross/x/core/xcc/types"
	"github.com/datachainlab/cross/x/packets"
	"github.com/gogo/protobuf/proto"
	"github.com/stretchr/testify/suite"

	"github.com/datachainlab/cross-solidity/pkg/consts"
	"github.com/datachainlab/cross-solidity/pkg/contract/crosssimplemodule"
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

	// check if the calling of OnRecvPacket succeeds
	// 1. create a packet that is send by the coordinator
	// 2. call OnRecvPacket with the packet

	txID := []byte(fmt.Sprintf("txid-%v", time.Now().UnixNano()))
	pd := suite.createPacket(txID, []byte{})
	packetData, err := proto.Marshal(&pd)
	suite.Require().NoError(err)

	suite.Require().NoError(suite.chain.TxSyncIfNoError(ctx)(
		suite.chain.CrossSimpleModule.OnRecvPacket(
			suite.chain.TxOpts(ctx, 0),
			crosssimplemodule.PacketData{
				Data: packetData,
			},
		),
	))

	// check if a fired event is expected

	event, err := suite.chain.findEventOnContractCall(ctx, txID)
	suite.Require().NoError(err)
	suite.Require().True(event.Success)
	suite.Require().Equal(event.Ret, []byte("mock call succeed"))
	suite.Require().Equal(event.TxId, txID)
	suite.Require().Equal(event.TxIndex, uint8(1))
}

func (suite *CrossTestSuite) TestSerialization() {
	ctx := context.Background()

	// check if the serialization of ack is expected

	ack, err := suite.chain.CrossSimpleModule.PacketAcknowledgementCallOK(
		suite.chain.CallOpts(ctx, 0),
	)
	suite.Require().NoError(err)

	expectedAck := packets.NewPacketAcknowledgementData(nil, simpletypes.NewPacketAcknowledgementCall(simpletypes.COMMIT_STATUS_OK))
	bz, err := proto.Marshal(&expectedAck)
	suite.Require().NoError(err)
	suite.Require().Equal(ack, bz)
}

func (suite *CrossTestSuite) createPacket(txID []byte, callInfo []byte) packets.PacketData {
	xcc, err := xcctypes.PackCrossChainChannel(&xcctypes.ChannelInfo{})
	suite.Require().NoError(err)
	pdc := simpletypes.NewPacketDataCall(txID, types.NewResolvedContractTransaction(xcc, nil, callInfo, nil, nil))
	return packets.NewPacketData(nil, pdc)
}

func TestChainTestSuite(t *testing.T) {
	suite.Run(t, new(CrossTestSuite))
}
