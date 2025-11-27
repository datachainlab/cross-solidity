package testing

import (
	"context"
	"fmt"
	"math/big"
	"testing"
	"time"

	simpletypes "github.com/datachainlab/cross/x/core/atomic/protocol/simple/types"
	authtypes "github.com/datachainlab/cross/x/core/auth/types"
	"github.com/datachainlab/cross/x/core/tx/types"
	xcctypes "github.com/datachainlab/cross/x/core/xcc/types"
	"github.com/datachainlab/cross/x/packets"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/crypto"
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
		relayerAddr     = common.BigToAddress(big.NewInt(1))
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
				suite.chain.LegacyTxOpts(ctx, 0),
				crosssimplemodule.Packet{
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
		suite.Require().Equal(event.TxID, crypto.Keccak256Hash(txID))
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
				suite.chain.LegacyTxOpts(ctx, 0),
				crosssimplemodule.Packet{
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
		suite.Require().Equal(event.TxID, crypto.Keccak256Hash(txID))
		suite.Require().Equal(event.TxIndex, uint8(1))
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

func (suite *CrossTestSuite) TestInitiateTx_ShouldFailBecauseTxRunNotImplemented() {
	ctx := context.Background()
	opts := suite.chain.LegacyTxOpts(ctx, 0)

	xcc, err := xcctypes.PackCrossChainChannel(&xcctypes.ChannelInfo{})
	suite.Require().NoError(err)

	authTypeBinding := crosssimplemodule.AuthTypeData{
		Mode: uint8(authtypes.AuthMode_AUTH_MODE_CHANNEL),
		Option: crosssimplemodule.GoogleProtobufAnyData{
			TypeUrl: xcc.TypeUrl,
			Value:   xcc.Value,
		},
	}
	signerBinding := crosssimplemodule.AccountData{
		Id:       opts.From.Bytes(),
		AuthType: authTypeBinding,
	}

	ctBinding := crosssimplemodule.ContractTransactionData{
		CrossChainChannel: crosssimplemodule.GoogleProtobufAnyData{
			TypeUrl: xcc.TypeUrl,
			Value:   xcc.Value,
		},
		Signers:  []crosssimplemodule.AccountData{signerBinding},
		CallInfo: []byte("dummy call info"),
	}

	msg := crosssimplemodule.MsgInitiateTxData{
		ChainId:              fmt.Sprintf("%d", suite.chain.chainID),
		Nonce:                0,
		CommitProtocol:       1,
		ContractTransactions: []crosssimplemodule.ContractTransactionData{ctBinding},
		Signers:              []crosssimplemodule.AccountData{signerBinding},
		TimeoutHeight:        crosssimplemodule.IbcCoreClientV1HeightData{},
		TimeoutTimestamp:     uint64(time.Now().Add(5 * time.Minute).Unix()),
	}

	err = suite.chain.TxSyncIfNoError(ctx)(
		suite.chain.CrossSimpleModule.InitiateTx(opts, msg),
	)

	suite.Require().Error(err, "transaction should have reverted, but it succeeded")
	suite.T().Logf("Received expected error from TxSync: %s", err.Error())

	suite.Require().Contains(err.Error(), "failed to call transaction", "Error message should indicate a failed receipt")
}

func TestChainTestSuite(t *testing.T) {
	suite.Run(t, new(CrossTestSuite))
}
