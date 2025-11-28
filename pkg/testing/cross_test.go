package testing

import (
	"context"
	"encoding/base64"
	"errors"
	"fmt"
	"math/big"
	"testing"
	"time"

	simpletypes "github.com/datachainlab/cross/x/core/atomic/protocol/simple/types"
	authtypes "github.com/datachainlab/cross/x/core/auth/types"
	"github.com/datachainlab/cross/x/core/tx/types"
	crosstypes "github.com/datachainlab/cross/x/core/types"
	xcctypes "github.com/datachainlab/cross/x/core/xcc/types"
	"github.com/datachainlab/cross/x/packets"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/common/hexutil"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/rpc"
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

func (suite *CrossTestSuite) TestPBSerialization() {
	ctx := context.Background()

	// check if the serialization of a successful ack is correct
	{
		ack, err := suite.chain.TxManager.GetPacketAcknowledgementCall(
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
		ack, err := suite.chain.TxManager.GetPacketAcknowledgementCall(
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

func (suite *CrossTestSuite) TestInitiateTx_ShouldFailBecauseChannelNotFound() {
	ctx := context.Background()
	opts := suite.chain.LegacyTxOpts(ctx, 0)
	opts.GasLimit = 0 // let the contract estimate gas

	decodeB64 := func(s string) []byte {
		b, err := base64.StdEncoding.DecodeString(s)
		suite.Require().NoError(err)
		return b
	}

	xcc1, err := xcctypes.PackCrossChainChannel(&xcctypes.ChannelInfo{
		Port:    "",
		Channel: "",
	})
	suite.Require().NoError(err)

	xcc2, err := xcctypes.PackCrossChainChannel(&xcctypes.ChannelInfo{
		Port:    "cross",
		Channel: "channel-0",
	})
	suite.Require().NoError(err)

	signer1 := crosssimplemodule.AccountData{
		Id: decodeB64("0/syrvWS1CkCswOi9XwXq+gd+dIByQLeH9t/qFrDXqE="),
		AuthType: crosssimplemodule.AuthTypeData{
			Mode: uint8(authtypes.AuthMode_AUTH_MODE_EXTENSION),
			Option: crosssimplemodule.GoogleProtobufAnyData{
				TypeUrl: "/erc20mgr.FabricAuthExtension",
				Value:   []byte{},
			},
		},
	}

	signer2 := crosssimplemodule.AccountData{
		Id: decodeB64("y+1kWxwaYlTxFJ31HTWRxrOAMAc="),
		AuthType: crosssimplemodule.AuthTypeData{
			Mode: uint8(authtypes.AuthMode_AUTH_MODE_EXTENSION),
			Option: crosssimplemodule.GoogleProtobufAnyData{
				TypeUrl: "/extension.types.BesuAuthExtension",
				Value:   []byte{},
			},
		},
	}

	ct1 := crosssimplemodule.ContractTransactionData{
		CrossChainChannel: crosssimplemodule.GoogleProtobufAnyData{
			TypeUrl: xcc1.TypeUrl,
			Value:   xcc1.Value,
		},
		Signers:  []crosssimplemodule.AccountData{signer1},
		CallInfo: decodeB64("eyJtZXRob2QiOiJ0cmFuc2ZlciIsImFyZ3MiOlsiNzkwOGE5ZGY5MzJkYmUwZjk5Nzg5NGE0MjMwOTdjYjViYTUxYWI0MDliZTAwZmM1YmZhODJkMjJmNDMyZjJiYiIsIjEwIl19"),
		Links:    []crosssimplemodule.LinkData{},
	}

	ct2 := crosssimplemodule.ContractTransactionData{
		CrossChainChannel: crosssimplemodule.GoogleProtobufAnyData{
			TypeUrl: xcc2.TypeUrl,
			Value:   xcc2.Value,
		},
		Signers:  []crosssimplemodule.AccountData{signer2},
		CallInfo: decodeB64("+DuU3VEJ0FrDV+RGmSpg5kdkBBoOhSmMdHJhbnNmZXJGcm9t2JQAcxVAzWBgmR1rnFfOKVmY2bwvq4IGug=="),
		Links:    []crosssimplemodule.LinkData{},
	}

	msg := crosssimplemodule.MsgInitiateTxData{
		ChainId:              fmt.Sprintf("%d", suite.chain.chainID),
		Nonce:                0,
		CommitProtocol:       1,
		ContractTransactions: []crosssimplemodule.ContractTransactionData{ct1, ct2},
		Signers:              []crosssimplemodule.AccountData{signer1, signer2},
		TimeoutHeight: crosssimplemodule.IbcCoreClientV1HeightData{
			RevisionNumber: 0,
			RevisionHeight: 0,
		},
		TimeoutTimestamp: 0,
	}

	err = suite.chain.TxSyncIfNoError(ctx)(
		suite.chain.CrossSimpleModule.InitiateTx(opts, msg),
	)

	suite.Require().Error(err, "transaction should have reverted with ChannelNotFound")
	suite.T().Logf("Received error: %s", err.Error())

	var dataErr rpc.DataError
	if !errors.As(err, &dataErr) {
		suite.Fail("Error is not of type rpc.DataError: " + err.Error())
		return
	}

	revertDataRaw := dataErr.ErrorData()
	revertDataHex, ok := revertDataRaw.(string)
	if !ok {
		suite.Fail("Error data is not a string")
		return
	}

	expectErrorName := "ChannelNotFound"
	errDef, ok := crossSimpleModuleABI.Errors[expectErrorName]
	suite.Require().True(ok, "Error definition not found in ABI: %s", expectErrorName)

	expectedSig := hexutil.Encode(errDef.ID[:4])

	if len(revertDataHex) < 10 {
		suite.Fail("Revert data is too short")
	}

	suite.Require().Equal(expectedSig, revertDataHex[:10], "Contract should revert with "+expectErrorName)
}

func TestChainTestSuite(t *testing.T) {
	suite.Run(t, new(CrossTestSuite))
}
