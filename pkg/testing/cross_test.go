package testing

import (
	"context"
	"fmt"
	"testing"
	"time"

	simpletypes "github.com/datachainlab/cross/x/core/atomic/protocol/simple/types"
	authtypes "github.com/datachainlab/cross/x/core/auth/types"
	"github.com/datachainlab/cross/x/core/tx/types"
	crosstypes "github.com/datachainlab/cross/x/core/types"
	xcctypes "github.com/datachainlab/cross/x/core/xcc/types"
	"github.com/datachainlab/cross/x/packets"
	"github.com/ethereum/go-ethereum/common"
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
	var (
		mockSuccessCall = []byte{0x01}
		mockFailureCall = []byte{0xFF}
		successMsg      = []byte("mock call succeed")
		relayerAddr     = common.HexToAddress("wip")
	)

	ctx := context.Background()

	// check if the contract module call succeeds via OnRecvPacket
	{
		// 1. create a packet that is send by the coordinator
		txID := []byte(fmt.Sprintf("txid-%v", time.Now().UnixNano()))
		pd := suite.createPacket(txID, mockSuccessCall)
		packetData, err := proto.Marshal(&pd)
		suite.Require().NoError(err)

		// 2. call OnRecvPacket with the packet
		suite.Require().NoError(suite.chain.TxSyncIfNoError(ctx)(
			suite.chain.CrossSimpleModule.OnRecvPacket(
				suite.chain.TxOpts(ctx, 0),
				crosssimplemodule.PacketData{
					Data: packetData,
				},
				relayerAddr,
			),
		))

		// 3. check if a fired event matches expected one
		event, err := suite.chain.findEventOnContractCall(ctx, txID)
		suite.Require().NoError(err)
		suite.Require().True(event.Success)
		suite.Require().Equal(event.Ret, successMsg)
		suite.Require().Equal(event.TxId, txID)
		suite.Require().Equal(event.TxIndex, uint8(1))
	}

	// check if OnRecvPacket succeeds even if the contract module call fails
	{
		// 1. create a packet that is send by the coordinator
		txID := []byte(fmt.Sprintf("txid-%v", time.Now().UnixNano()))
		pd := suite.createPacket(txID, mockFailureCall)
		packetData, err := proto.Marshal(&pd)
		suite.Require().NoError(err)

		// 2. call OnRecvPacket with the packet
		suite.Require().NoError(suite.chain.TxSyncIfNoError(ctx)(
			suite.chain.CrossSimpleModule.OnRecvPacket(
				suite.chain.TxOpts(ctx, 0),
				crosssimplemodule.PacketData{
					Data: packetData,
				},
				relayerAddr,
			),
		))

		// 3. check if a fired event matches expected one
		event, err := suite.chain.findEventOnContractCall(ctx, txID)
		suite.Require().NoError(err)
		suite.Require().False(event.Success)
		suite.Require().Empty(event.Ret)
		suite.Require().Equal(event.TxId, txID)
		suite.Require().Equal(event.TxIndex, uint8(1))
	}
}

func (suite *CrossTestSuite) TestPBSerialization() {
	ctx := context.Background()

	// check if the serialization of a successful ack is correct
	{
		ack, err := suite.chain.CrossSimpleModule.GetPacketAcknowledgementCall(
			suite.chain.CallOpts(ctx, 0),
			uint8(simpletypes.COMMIT_STATUS_OK),
		)
		suite.Require().NoError(err)
		expectedAckData := packets.NewPacketAcknowledgementData(nil, simpletypes.NewPacketAcknowledgementCall(simpletypes.COMMIT_STATUS_OK))
		expectedAckDataBz, err := proto.Marshal(&expectedAckData)
		suite.Require().NoError(err)
		expectedAck := crosstypes.NewAcknowledgement(true, expectedAckDataBz)
		suite.Require().Equal(ack, expectedAck.Acknowledgement())
	}

	// check if the serialization of a failure ack is correct
	{
		ack, err := suite.chain.CrossSimpleModule.GetPacketAcknowledgementCall(
			suite.chain.CallOpts(ctx, 0),
			uint8(simpletypes.COMMIT_STATUS_FAILED),
		)
		suite.Require().NoError(err)
		expectedAckData := packets.NewPacketAcknowledgementData(nil, simpletypes.NewPacketAcknowledgementCall(simpletypes.COMMIT_STATUS_FAILED))
		expectedAckDataBz, err := proto.Marshal(&expectedAckData)
		suite.Require().NoError(err)
		expectedAck := crosstypes.NewAcknowledgement(true, expectedAckDataBz)
		suite.Require().Equal(ack, expectedAck.Acknowledgement())
	}
}

func (suite *CrossTestSuite) createPacket(txID []byte, callInfo []byte) packets.PacketData {
	xcc, err := xcctypes.PackCrossChainChannel(&xcctypes.ChannelInfo{})
	suite.Require().NoError(err)
	signers := []authtypes.Account{
		authtypes.NewAccount(authtypes.AccountID("tester"), authtypes.NewAuthTypeChannel(&xcctypes.ChannelInfo{})),
	}
	pdc := simpletypes.NewPacketDataCall(txID, types.NewResolvedContractTransaction(xcc, signers, callInfo, nil, nil))
	return packets.NewPacketData(nil, pdc)
}

func TestChainTestSuite(t *testing.T) {
	suite.Run(t, new(CrossTestSuite))
}
