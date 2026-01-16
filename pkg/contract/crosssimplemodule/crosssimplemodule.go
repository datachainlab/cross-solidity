// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package crosssimplemodule

import (
	"errors"
	"math/big"
	"strings"

	ethereum "github.com/ethereum/go-ethereum"
	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/event"
)

// Reference imports to suppress errors if they are not otherwise used.
var (
	_ = errors.New
	_ = big.NewInt
	_ = strings.NewReader
	_ = ethereum.NotFound
	_ = bind.Bind
	_ = common.Big1
	_ = types.BloomLookup
	_ = event.NewSubscription
	_ = abi.ConvertType
)

// AccountData is an auto generated low-level Go binding around an user-defined struct.
type AccountData struct {
	Id       []byte
	AuthType AuthTypeData
}

// AuthTypeData is an auto generated low-level Go binding around an user-defined struct.
type AuthTypeData struct {
	Mode   uint8
	Option GoogleProtobufAnyData
}

// ChannelCounterpartyData is an auto generated low-level Go binding around an user-defined struct.
type ChannelCounterpartyData struct {
	PortId    string
	ChannelId string
}

// ChannelInfoData is an auto generated low-level Go binding around an user-defined struct.
type ChannelInfoData struct {
	Port    string
	Channel string
}

// ContractTransactionData is an auto generated low-level Go binding around an user-defined struct.
type ContractTransactionData struct {
	CrossChainChannel GoogleProtobufAnyData
	Signers           []AccountData
	CallInfo          []byte
	ReturnValue       ReturnValueData
	Links             []LinkData
}

// CoordinatorStateData is an auto generated low-level Go binding around an user-defined struct.
type CoordinatorStateData struct {
	CommitProtocol uint8
	Channels       []ChannelInfoData
	Phase          uint8
	Decision       uint8
	ConfirmedTxs   []uint32
	Acks           []uint32
}

// GoogleProtobufAnyData is an auto generated low-level Go binding around an user-defined struct.
type GoogleProtobufAnyData struct {
	TypeUrl string
	Value   []byte
}

// HeightData is an auto generated low-level Go binding around an user-defined struct.
type HeightData struct {
	RevisionNumber uint64
	RevisionHeight uint64
}

// IIBCModuleInitializerMsgOnChanOpenInit is an auto generated low-level Go binding around an user-defined struct.
type IIBCModuleInitializerMsgOnChanOpenInit struct {
	Order          uint8
	ConnectionHops []string
	PortId         string
	ChannelId      string
	Counterparty   ChannelCounterpartyData
	Version        string
}

// IIBCModuleInitializerMsgOnChanOpenTry is an auto generated low-level Go binding around an user-defined struct.
type IIBCModuleInitializerMsgOnChanOpenTry struct {
	Order               uint8
	ConnectionHops      []string
	PortId              string
	ChannelId           string
	Counterparty        ChannelCounterpartyData
	CounterpartyVersion string
}

// IIBCModuleMsgOnChanCloseConfirm is an auto generated low-level Go binding around an user-defined struct.
type IIBCModuleMsgOnChanCloseConfirm struct {
	PortId    string
	ChannelId string
}

// IIBCModuleMsgOnChanCloseInit is an auto generated low-level Go binding around an user-defined struct.
type IIBCModuleMsgOnChanCloseInit struct {
	PortId    string
	ChannelId string
}

// IIBCModuleMsgOnChanOpenAck is an auto generated low-level Go binding around an user-defined struct.
type IIBCModuleMsgOnChanOpenAck struct {
	PortId              string
	ChannelId           string
	CounterpartyVersion string
}

// IIBCModuleMsgOnChanOpenConfirm is an auto generated low-level Go binding around an user-defined struct.
type IIBCModuleMsgOnChanOpenConfirm struct {
	PortId    string
	ChannelId string
}

// IbcCoreClientV1HeightData is an auto generated low-level Go binding around an user-defined struct.
type IbcCoreClientV1HeightData struct {
	RevisionNumber uint64
	RevisionHeight uint64
}

// LinkData is an auto generated low-level Go binding around an user-defined struct.
type LinkData struct {
	SrcIndex uint32
}

// MsgExtSignTxData is an auto generated low-level Go binding around an user-defined struct.
type MsgExtSignTxData struct {
	TxID    []byte
	Signers []AccountData
}

// MsgExtSignTxResponseData is an auto generated low-level Go binding around an user-defined struct.
type MsgExtSignTxResponseData struct {
	X bool
}

// MsgInitiateTxData is an auto generated low-level Go binding around an user-defined struct.
type MsgInitiateTxData struct {
	ChainId              string
	Nonce                uint64
	CommitProtocol       uint8
	ContractTransactions []ContractTransactionData
	Signers              []AccountData
	TimeoutHeight        IbcCoreClientV1HeightData
	TimeoutTimestamp     uint64
}

// MsgInitiateTxResponseData is an auto generated low-level Go binding around an user-defined struct.
type MsgInitiateTxResponseData struct {
	TxID   []byte
	Status uint8
}

// MsgSignTxData is an auto generated low-level Go binding around an user-defined struct.
type MsgSignTxData struct {
	TxID             []byte
	Signers          [][]byte
	TimeoutHeight    IbcCoreClientV1HeightData
	TimeoutTimestamp uint64
}

// MsgSignTxResponseData is an auto generated low-level Go binding around an user-defined struct.
type MsgSignTxResponseData struct {
	TxAuthCompleted bool
	Log             string
}

// Packet is an auto generated low-level Go binding around an user-defined struct.
type Packet struct {
	Sequence           uint64
	SourcePort         string
	SourceChannel      string
	DestinationPort    string
	DestinationChannel string
	Data               []byte
	TimeoutHeight      HeightData
	TimeoutTimestamp   uint64
}

// QueryCoordinatorStateRequestData is an auto generated low-level Go binding around an user-defined struct.
type QueryCoordinatorStateRequestData struct {
	TxId []byte
}

// QueryCoordinatorStateResponseData is an auto generated low-level Go binding around an user-defined struct.
type QueryCoordinatorStateResponseData struct {
	CoodinatorState CoordinatorStateData
}

// QuerySelfXCCResponseData is an auto generated low-level Go binding around an user-defined struct.
type QuerySelfXCCResponseData struct {
	Xcc GoogleProtobufAnyData
}

// QueryTxAuthStateRequestData is an auto generated low-level Go binding around an user-defined struct.
type QueryTxAuthStateRequestData struct {
	TxID []byte
}

// QueryTxAuthStateResponseData is an auto generated low-level Go binding around an user-defined struct.
type QueryTxAuthStateResponseData struct {
	TxAuthState TxAuthStateData
}

// ReturnValueData is an auto generated low-level Go binding around an user-defined struct.
type ReturnValueData struct {
	Value []byte
}

// TxAuthStateData is an auto generated low-level Go binding around an user-defined struct.
type TxAuthStateData struct {
	RemainingSigners []AccountData
}

// CrosssimplemoduleMetaData contains all meta data concerning the Crosssimplemodule contract.
var CrosssimplemoduleMetaData = &bind.MetaData{
	ABI: "[{\"type\":\"constructor\",\"inputs\":[{\"name\":\"ibcHandler_\",\"type\":\"address\",\"internalType\":\"contractIIBCHandler\"},{\"name\":\"txAuthManager_\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"txManager_\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"module_\",\"type\":\"address\",\"internalType\":\"contractIContractModule\"},{\"name\":\"authTypeUrls_\",\"type\":\"string[]\",\"internalType\":\"string[]\"},{\"name\":\"authVerifiers_\",\"type\":\"address[]\",\"internalType\":\"contractIAuthExtensionVerifier[]\"},{\"name\":\"debugMode\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"CHAIN_ID_HASH\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"DEFAULT_ADMIN_ROLE\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"IBC_ROLE\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"TX_AUTH_MANAGER\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"TX_MANAGER\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"__getAuthState\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"outputs\":[{\"name\":\"\",\"type\":\"tuple\",\"internalType\":\"structTxAuthState.Data\",\"components\":[{\"name\":\"remaining_signers\",\"type\":\"tuple[]\",\"internalType\":\"structAccount.Data[]\",\"components\":[{\"name\":\"id\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"auth_type\",\"type\":\"tuple\",\"internalType\":\"structAuthType.Data\",\"components\":[{\"name\":\"mode\",\"type\":\"uint8\",\"internalType\":\"enumAuthType.AuthMode\"},{\"name\":\"option\",\"type\":\"tuple\",\"internalType\":\"structGoogleProtobufAny.Data\",\"components\":[{\"name\":\"type_url\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]}]}]}]}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"__getCoordinatorState\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"outputs\":[{\"name\":\"\",\"type\":\"tuple\",\"internalType\":\"structCoordinatorState.Data\",\"components\":[{\"name\":\"commit_protocol\",\"type\":\"uint8\",\"internalType\":\"enumTx.CommitProtocol\"},{\"name\":\"channels\",\"type\":\"tuple[]\",\"internalType\":\"structChannelInfo.Data[]\",\"components\":[{\"name\":\"port\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"channel\",\"type\":\"string\",\"internalType\":\"string\"}]},{\"name\":\"phase\",\"type\":\"uint8\",\"internalType\":\"enumCoordinatorState.CoordinatorPhase\"},{\"name\":\"decision\",\"type\":\"uint8\",\"internalType\":\"enumCoordinatorState.CoordinatorDecision\"},{\"name\":\"confirmed_txs\",\"type\":\"uint32[]\",\"internalType\":\"uint32[]\"},{\"name\":\"acks\",\"type\":\"uint32[]\",\"internalType\":\"uint32[]\"}]}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"__isCompletedAuth\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"__isTxRecorded\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"coordinatorState\",\"inputs\":[{\"name\":\"req\",\"type\":\"tuple\",\"internalType\":\"structQueryCoordinatorStateRequest.Data\",\"components\":[{\"name\":\"tx_id\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]}],\"outputs\":[{\"name\":\"\",\"type\":\"tuple\",\"internalType\":\"structQueryCoordinatorStateResponse.Data\",\"components\":[{\"name\":\"coodinator_state\",\"type\":\"tuple\",\"internalType\":\"structCoordinatorState.Data\",\"components\":[{\"name\":\"commit_protocol\",\"type\":\"uint8\",\"internalType\":\"enumTx.CommitProtocol\"},{\"name\":\"channels\",\"type\":\"tuple[]\",\"internalType\":\"structChannelInfo.Data[]\",\"components\":[{\"name\":\"port\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"channel\",\"type\":\"string\",\"internalType\":\"string\"}]},{\"name\":\"phase\",\"type\":\"uint8\",\"internalType\":\"enumCoordinatorState.CoordinatorPhase\"},{\"name\":\"decision\",\"type\":\"uint8\",\"internalType\":\"enumCoordinatorState.CoordinatorDecision\"},{\"name\":\"confirmed_txs\",\"type\":\"uint32[]\",\"internalType\":\"uint32[]\"},{\"name\":\"acks\",\"type\":\"uint32[]\",\"internalType\":\"uint32[]\"}]}]}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"executeTx\",\"inputs\":[{\"name\":\"msg_\",\"type\":\"tuple\",\"internalType\":\"structMsgInitiateTx.Data\",\"components\":[{\"name\":\"chain_id\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"nonce\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"commit_protocol\",\"type\":\"uint8\",\"internalType\":\"enumTx.CommitProtocol\"},{\"name\":\"contract_transactions\",\"type\":\"tuple[]\",\"internalType\":\"structContractTransaction.Data[]\",\"components\":[{\"name\":\"cross_chain_channel\",\"type\":\"tuple\",\"internalType\":\"structGoogleProtobufAny.Data\",\"components\":[{\"name\":\"type_url\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]},{\"name\":\"signers\",\"type\":\"tuple[]\",\"internalType\":\"structAccount.Data[]\",\"components\":[{\"name\":\"id\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"auth_type\",\"type\":\"tuple\",\"internalType\":\"structAuthType.Data\",\"components\":[{\"name\":\"mode\",\"type\":\"uint8\",\"internalType\":\"enumAuthType.AuthMode\"},{\"name\":\"option\",\"type\":\"tuple\",\"internalType\":\"structGoogleProtobufAny.Data\",\"components\":[{\"name\":\"type_url\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]}]}]},{\"name\":\"call_info\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"return_value\",\"type\":\"tuple\",\"internalType\":\"structReturnValue.Data\",\"components\":[{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]},{\"name\":\"links\",\"type\":\"tuple[]\",\"internalType\":\"structLink.Data[]\",\"components\":[{\"name\":\"src_index\",\"type\":\"uint32\",\"internalType\":\"uint32\"}]}]},{\"name\":\"signers\",\"type\":\"tuple[]\",\"internalType\":\"structAccount.Data[]\",\"components\":[{\"name\":\"id\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"auth_type\",\"type\":\"tuple\",\"internalType\":\"structAuthType.Data\",\"components\":[{\"name\":\"mode\",\"type\":\"uint8\",\"internalType\":\"enumAuthType.AuthMode\"},{\"name\":\"option\",\"type\":\"tuple\",\"internalType\":\"structGoogleProtobufAny.Data\",\"components\":[{\"name\":\"type_url\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]}]}]},{\"name\":\"timeout_height\",\"type\":\"tuple\",\"internalType\":\"structIbcCoreClientV1Height.Data\",\"components\":[{\"name\":\"revision_number\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"revision_height\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"timeout_timestamp\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"extSignTx\",\"inputs\":[{\"name\":\"msg_\",\"type\":\"tuple\",\"internalType\":\"structMsgExtSignTx.Data\",\"components\":[{\"name\":\"txID\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"signers\",\"type\":\"tuple[]\",\"internalType\":\"structAccount.Data[]\",\"components\":[{\"name\":\"id\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"auth_type\",\"type\":\"tuple\",\"internalType\":\"structAuthType.Data\",\"components\":[{\"name\":\"mode\",\"type\":\"uint8\",\"internalType\":\"enumAuthType.AuthMode\"},{\"name\":\"option\",\"type\":\"tuple\",\"internalType\":\"structGoogleProtobufAny.Data\",\"components\":[{\"name\":\"type_url\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]}]}]}]}],\"outputs\":[{\"name\":\"\",\"type\":\"tuple\",\"internalType\":\"structMsgExtSignTxResponse.Data\",\"components\":[{\"name\":\"x\",\"type\":\"bool\",\"internalType\":\"bool\"}]}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"getRoleAdmin\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"grantRole\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"hasRole\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"initiateTx\",\"inputs\":[{\"name\":\"msg_\",\"type\":\"tuple\",\"internalType\":\"structMsgInitiateTx.Data\",\"components\":[{\"name\":\"chain_id\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"nonce\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"commit_protocol\",\"type\":\"uint8\",\"internalType\":\"enumTx.CommitProtocol\"},{\"name\":\"contract_transactions\",\"type\":\"tuple[]\",\"internalType\":\"structContractTransaction.Data[]\",\"components\":[{\"name\":\"cross_chain_channel\",\"type\":\"tuple\",\"internalType\":\"structGoogleProtobufAny.Data\",\"components\":[{\"name\":\"type_url\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]},{\"name\":\"signers\",\"type\":\"tuple[]\",\"internalType\":\"structAccount.Data[]\",\"components\":[{\"name\":\"id\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"auth_type\",\"type\":\"tuple\",\"internalType\":\"structAuthType.Data\",\"components\":[{\"name\":\"mode\",\"type\":\"uint8\",\"internalType\":\"enumAuthType.AuthMode\"},{\"name\":\"option\",\"type\":\"tuple\",\"internalType\":\"structGoogleProtobufAny.Data\",\"components\":[{\"name\":\"type_url\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]}]}]},{\"name\":\"call_info\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"return_value\",\"type\":\"tuple\",\"internalType\":\"structReturnValue.Data\",\"components\":[{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]},{\"name\":\"links\",\"type\":\"tuple[]\",\"internalType\":\"structLink.Data[]\",\"components\":[{\"name\":\"src_index\",\"type\":\"uint32\",\"internalType\":\"uint32\"}]}]},{\"name\":\"signers\",\"type\":\"tuple[]\",\"internalType\":\"structAccount.Data[]\",\"components\":[{\"name\":\"id\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"auth_type\",\"type\":\"tuple\",\"internalType\":\"structAuthType.Data\",\"components\":[{\"name\":\"mode\",\"type\":\"uint8\",\"internalType\":\"enumAuthType.AuthMode\"},{\"name\":\"option\",\"type\":\"tuple\",\"internalType\":\"structGoogleProtobufAny.Data\",\"components\":[{\"name\":\"type_url\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]}]}]},{\"name\":\"timeout_height\",\"type\":\"tuple\",\"internalType\":\"structIbcCoreClientV1Height.Data\",\"components\":[{\"name\":\"revision_number\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"revision_height\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"timeout_timestamp\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]}],\"outputs\":[{\"name\":\"resp\",\"type\":\"tuple\",\"internalType\":\"structMsgInitiateTxResponse.Data\",\"components\":[{\"name\":\"txID\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"status\",\"type\":\"uint8\",\"internalType\":\"enumMsgInitiateTxResponse.InitiateTxStatus\"}]}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"onAcknowledgementPacket\",\"inputs\":[{\"name\":\"packet\",\"type\":\"tuple\",\"internalType\":\"structPacket\",\"components\":[{\"name\":\"sequence\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"sourcePort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"sourceChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationPort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"data\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"timeoutHeight\",\"type\":\"tuple\",\"internalType\":\"structHeight.Data\",\"components\":[{\"name\":\"revision_number\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"revision_height\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"timeoutTimestamp\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"acknowledgement\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"onChanCloseConfirm\",\"inputs\":[{\"name\":\"\",\"type\":\"tuple\",\"internalType\":\"structIIBCModule.MsgOnChanCloseConfirm\",\"components\":[{\"name\":\"portId\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"channelId\",\"type\":\"string\",\"internalType\":\"string\"}]}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"onChanCloseInit\",\"inputs\":[{\"name\":\"\",\"type\":\"tuple\",\"internalType\":\"structIIBCModule.MsgOnChanCloseInit\",\"components\":[{\"name\":\"portId\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"channelId\",\"type\":\"string\",\"internalType\":\"string\"}]}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"onChanOpenAck\",\"inputs\":[{\"name\":\"\",\"type\":\"tuple\",\"internalType\":\"structIIBCModule.MsgOnChanOpenAck\",\"components\":[{\"name\":\"portId\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"channelId\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"counterpartyVersion\",\"type\":\"string\",\"internalType\":\"string\"}]}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"onChanOpenConfirm\",\"inputs\":[{\"name\":\"\",\"type\":\"tuple\",\"internalType\":\"structIIBCModule.MsgOnChanOpenConfirm\",\"components\":[{\"name\":\"portId\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"channelId\",\"type\":\"string\",\"internalType\":\"string\"}]}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"onChanOpenInit\",\"inputs\":[{\"name\":\"msg_\",\"type\":\"tuple\",\"internalType\":\"structIIBCModuleInitializer.MsgOnChanOpenInit\",\"components\":[{\"name\":\"order\",\"type\":\"uint8\",\"internalType\":\"enumChannel.Order\"},{\"name\":\"connectionHops\",\"type\":\"string[]\",\"internalType\":\"string[]\"},{\"name\":\"portId\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"channelId\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"counterparty\",\"type\":\"tuple\",\"internalType\":\"structChannelCounterparty.Data\",\"components\":[{\"name\":\"port_id\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"channel_id\",\"type\":\"string\",\"internalType\":\"string\"}]},{\"name\":\"version\",\"type\":\"string\",\"internalType\":\"string\"}]}],\"outputs\":[{\"name\":\"moduleAddr\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"version\",\"type\":\"string\",\"internalType\":\"string\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"onChanOpenTry\",\"inputs\":[{\"name\":\"msg_\",\"type\":\"tuple\",\"internalType\":\"structIIBCModuleInitializer.MsgOnChanOpenTry\",\"components\":[{\"name\":\"order\",\"type\":\"uint8\",\"internalType\":\"enumChannel.Order\"},{\"name\":\"connectionHops\",\"type\":\"string[]\",\"internalType\":\"string[]\"},{\"name\":\"portId\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"channelId\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"counterparty\",\"type\":\"tuple\",\"internalType\":\"structChannelCounterparty.Data\",\"components\":[{\"name\":\"port_id\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"channel_id\",\"type\":\"string\",\"internalType\":\"string\"}]},{\"name\":\"counterpartyVersion\",\"type\":\"string\",\"internalType\":\"string\"}]}],\"outputs\":[{\"name\":\"moduleAddr\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"version\",\"type\":\"string\",\"internalType\":\"string\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"onRecvPacket\",\"inputs\":[{\"name\":\"packet\",\"type\":\"tuple\",\"internalType\":\"structPacket\",\"components\":[{\"name\":\"sequence\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"sourcePort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"sourceChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationPort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"data\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"timeoutHeight\",\"type\":\"tuple\",\"internalType\":\"structHeight.Data\",\"components\":[{\"name\":\"revision_number\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"revision_height\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"timeoutTimestamp\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"acknowledgement\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"onTimeoutPacket\",\"inputs\":[{\"name\":\"packet\",\"type\":\"tuple\",\"internalType\":\"structPacket\",\"components\":[{\"name\":\"sequence\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"sourcePort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"sourceChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationPort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"data\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"timeoutHeight\",\"type\":\"tuple\",\"internalType\":\"structHeight.Data\",\"components\":[{\"name\":\"revision_number\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"revision_height\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"timeoutTimestamp\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"renounceRole\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"callerConfirmation\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"revokeRole\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"selfXCC\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"tuple\",\"internalType\":\"structQuerySelfXCCResponse.Data\",\"components\":[{\"name\":\"xcc\",\"type\":\"tuple\",\"internalType\":\"structGoogleProtobufAny.Data\",\"components\":[{\"name\":\"type_url\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]}]}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"signTx\",\"inputs\":[{\"name\":\"msg_\",\"type\":\"tuple\",\"internalType\":\"structMsgSignTx.Data\",\"components\":[{\"name\":\"txID\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"signers\",\"type\":\"bytes[]\",\"internalType\":\"bytes[]\"},{\"name\":\"timeout_height\",\"type\":\"tuple\",\"internalType\":\"structIbcCoreClientV1Height.Data\",\"components\":[{\"name\":\"revision_number\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"revision_height\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"timeout_timestamp\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]}],\"outputs\":[{\"name\":\"\",\"type\":\"tuple\",\"internalType\":\"structMsgSignTxResponse.Data\",\"components\":[{\"name\":\"tx_auth_completed\",\"type\":\"bool\",\"internalType\":\"bool\"},{\"name\":\"log\",\"type\":\"string\",\"internalType\":\"string\"}]}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"supportsInterface\",\"inputs\":[{\"name\":\"interfaceID\",\"type\":\"bytes4\",\"internalType\":\"bytes4\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"txAuthState\",\"inputs\":[{\"name\":\"req_\",\"type\":\"tuple\",\"internalType\":\"structQueryTxAuthStateRequest.Data\",\"components\":[{\"name\":\"txID\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]}],\"outputs\":[{\"name\":\"resp\",\"type\":\"tuple\",\"internalType\":\"structQueryTxAuthStateResponse.Data\",\"components\":[{\"name\":\"tx_auth_state\",\"type\":\"tuple\",\"internalType\":\"structTxAuthState.Data\",\"components\":[{\"name\":\"remaining_signers\",\"type\":\"tuple[]\",\"internalType\":\"structAccount.Data[]\",\"components\":[{\"name\":\"id\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"auth_type\",\"type\":\"tuple\",\"internalType\":\"structAuthType.Data\",\"components\":[{\"name\":\"mode\",\"type\":\"uint8\",\"internalType\":\"enumAuthType.AuthMode\"},{\"name\":\"option\",\"type\":\"tuple\",\"internalType\":\"structGoogleProtobufAny.Data\",\"components\":[{\"name\":\"type_url\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]}]}]}]}]}],\"stateMutability\":\"nonpayable\"},{\"type\":\"event\",\"name\":\"OnAbort\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes\",\"indexed\":true,\"internalType\":\"bytes\"},{\"name\":\"txIndex\",\"type\":\"uint8\",\"indexed\":true,\"internalType\":\"uint8\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"OnCommit\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes\",\"indexed\":true,\"internalType\":\"bytes\"},{\"name\":\"txIndex\",\"type\":\"uint8\",\"indexed\":true,\"internalType\":\"uint8\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"OnContractCommitImmediately\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes\",\"indexed\":true,\"internalType\":\"bytes\"},{\"name\":\"txIndex\",\"type\":\"uint8\",\"indexed\":true,\"internalType\":\"uint8\"},{\"name\":\"success\",\"type\":\"bool\",\"indexed\":true,\"internalType\":\"bool\"},{\"name\":\"ret\",\"type\":\"bytes\",\"indexed\":false,\"internalType\":\"bytes\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"RoleAdminChanged\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"},{\"name\":\"previousAdminRole\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"},{\"name\":\"newAdminRole\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"RoleGranted\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"sender\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"RoleRevoked\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"sender\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"TxExecuted\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes\",\"indexed\":false,\"internalType\":\"bytes\"},{\"name\":\"proposer\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"TxInitiated\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes\",\"indexed\":false,\"internalType\":\"bytes\"},{\"name\":\"proposer\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"msgData\",\"type\":\"tuple\",\"indexed\":false,\"internalType\":\"structMsgInitiateTx.Data\",\"components\":[{\"name\":\"chain_id\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"nonce\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"commit_protocol\",\"type\":\"uint8\",\"internalType\":\"enumTx.CommitProtocol\"},{\"name\":\"contract_transactions\",\"type\":\"tuple[]\",\"internalType\":\"structContractTransaction.Data[]\",\"components\":[{\"name\":\"cross_chain_channel\",\"type\":\"tuple\",\"internalType\":\"structGoogleProtobufAny.Data\",\"components\":[{\"name\":\"type_url\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]},{\"name\":\"signers\",\"type\":\"tuple[]\",\"internalType\":\"structAccount.Data[]\",\"components\":[{\"name\":\"id\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"auth_type\",\"type\":\"tuple\",\"internalType\":\"structAuthType.Data\",\"components\":[{\"name\":\"mode\",\"type\":\"uint8\",\"internalType\":\"enumAuthType.AuthMode\"},{\"name\":\"option\",\"type\":\"tuple\",\"internalType\":\"structGoogleProtobufAny.Data\",\"components\":[{\"name\":\"type_url\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]}]}]},{\"name\":\"call_info\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"return_value\",\"type\":\"tuple\",\"internalType\":\"structReturnValue.Data\",\"components\":[{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]},{\"name\":\"links\",\"type\":\"tuple[]\",\"internalType\":\"structLink.Data[]\",\"components\":[{\"name\":\"src_index\",\"type\":\"uint32\",\"internalType\":\"uint32\"}]}]},{\"name\":\"signers\",\"type\":\"tuple[]\",\"internalType\":\"structAccount.Data[]\",\"components\":[{\"name\":\"id\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"auth_type\",\"type\":\"tuple\",\"internalType\":\"structAuthType.Data\",\"components\":[{\"name\":\"mode\",\"type\":\"uint8\",\"internalType\":\"enumAuthType.AuthMode\"},{\"name\":\"option\",\"type\":\"tuple\",\"internalType\":\"structGoogleProtobufAny.Data\",\"components\":[{\"name\":\"type_url\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]}]}]},{\"name\":\"timeout_height\",\"type\":\"tuple\",\"internalType\":\"structIbcCoreClientV1Height.Data\",\"components\":[{\"name\":\"revision_number\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"revision_height\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"timeout_timestamp\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"TxSigned\",\"inputs\":[{\"name\":\"signer\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"txID\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"},{\"name\":\"method\",\"type\":\"uint8\",\"indexed\":false,\"internalType\":\"enumAuthType.AuthMode\"}],\"anonymous\":false},{\"type\":\"error\",\"name\":\"AccessControlBadConfirmation\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"AccessControlUnauthorizedAccount\",\"inputs\":[{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"neededRole\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"AckIsNotSuccess\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"AllTransactionsConfirmed\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"ArrayLengthMismatch\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"AuthAlreadyCompleted\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"AuthModeMismatch\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"AuthNotCompleted\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"AuthStateAlreadyInitialized\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"ChannelNotFound\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"CoordinatorPhaseNotPrepare\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"CoordinatorStateInconsistent\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"CoordinatorStateNotFound\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"CoordinatorTxStatusNotPrepare\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"DelegateCallFailed\",\"inputs\":[{\"name\":\"target\",\"type\":\"address\",\"internalType\":\"address\"}]},{\"type\":\"error\",\"name\":\"EmptyTypeUrl\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"IDNotFound\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"InvalidSignersLength\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidTxIDLength\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"LinksNotSupported\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"MessageTimeoutHeight\",\"inputs\":[{\"name\":\"blockNumber\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"timeoutVersionHeight\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"type\":\"error\",\"name\":\"MessageTimeoutTimestamp\",\"inputs\":[{\"name\":\"blockTimestamp\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"timeoutTimestamp\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"type\":\"error\",\"name\":\"ModuleAlreadyInitialized\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"ModuleNotInitialized\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotImplemented\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"PayloadDecodeFailed\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"ReentrancyGuardReentrantCall\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"SignatureVerificationFailed\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"SignerCountMismatch\",\"inputs\":[{\"name\":\"signerCount\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"signatureCount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}]},{\"type\":\"error\",\"name\":\"SignerMustEqualSender\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"StaticCallFailed\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"TPCNotImplemented\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"TooManySigners\",\"inputs\":[{\"name\":\"got\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"maxAllowed\",\"type\":\"uint256\",\"internalType\":\"uint256\"}]},{\"type\":\"error\",\"name\":\"Tx0MustBeForSelfChain\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"TxAlreadyExists\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"TxAlreadyVerified\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"TxIDAlreadyExists\",\"inputs\":[{\"name\":\"txIDHash\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"TxIDNotFound\",\"inputs\":[{\"name\":\"txIDHash\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"UnauthorizedCaller\",\"inputs\":[{\"name\":\"caller\",\"type\":\"address\",\"internalType\":\"address\"}]},{\"type\":\"error\",\"name\":\"UnexpectedChainID\",\"inputs\":[{\"name\":\"expectedHash\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"gotHash\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"UnexpectedCommitStatus\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"UnexpectedReturnValue\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"UnexpectedSourceChannel\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"UnexpectedTypeURL\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"UnknownCommitProtocol\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"VerifierNotFound\",\"inputs\":[{\"name\":\"typeUrl\",\"type\":\"string\",\"internalType\":\"string\"}]},{\"type\":\"error\",\"name\":\"VerifierReturnedFalse\",\"inputs\":[{\"name\":\"txIDHash\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"typeUrl\",\"type\":\"string\",\"internalType\":\"string\"}]},{\"type\":\"error\",\"name\":\"ZeroAddressVerifier\",\"inputs\":[]}]",
}

// CrosssimplemoduleABI is the input ABI used to generate the binding from.
// Deprecated: Use CrosssimplemoduleMetaData.ABI instead.
var CrosssimplemoduleABI = CrosssimplemoduleMetaData.ABI

// Crosssimplemodule is an auto generated Go binding around an Ethereum contract.
type Crosssimplemodule struct {
	CrosssimplemoduleCaller     // Read-only binding to the contract
	CrosssimplemoduleTransactor // Write-only binding to the contract
	CrosssimplemoduleFilterer   // Log filterer for contract events
}

// CrosssimplemoduleCaller is an auto generated read-only Go binding around an Ethereum contract.
type CrosssimplemoduleCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// CrosssimplemoduleTransactor is an auto generated write-only Go binding around an Ethereum contract.
type CrosssimplemoduleTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// CrosssimplemoduleFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type CrosssimplemoduleFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// CrosssimplemoduleSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type CrosssimplemoduleSession struct {
	Contract     *Crosssimplemodule // Generic contract binding to set the session for
	CallOpts     bind.CallOpts      // Call options to use throughout this session
	TransactOpts bind.TransactOpts  // Transaction auth options to use throughout this session
}

// CrosssimplemoduleCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type CrosssimplemoduleCallerSession struct {
	Contract *CrosssimplemoduleCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts            // Call options to use throughout this session
}

// CrosssimplemoduleTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type CrosssimplemoduleTransactorSession struct {
	Contract     *CrosssimplemoduleTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts            // Transaction auth options to use throughout this session
}

// CrosssimplemoduleRaw is an auto generated low-level Go binding around an Ethereum contract.
type CrosssimplemoduleRaw struct {
	Contract *Crosssimplemodule // Generic contract binding to access the raw methods on
}

// CrosssimplemoduleCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type CrosssimplemoduleCallerRaw struct {
	Contract *CrosssimplemoduleCaller // Generic read-only contract binding to access the raw methods on
}

// CrosssimplemoduleTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type CrosssimplemoduleTransactorRaw struct {
	Contract *CrosssimplemoduleTransactor // Generic write-only contract binding to access the raw methods on
}

// NewCrosssimplemodule creates a new instance of Crosssimplemodule, bound to a specific deployed contract.
func NewCrosssimplemodule(address common.Address, backend bind.ContractBackend) (*Crosssimplemodule, error) {
	contract, err := bindCrosssimplemodule(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &Crosssimplemodule{CrosssimplemoduleCaller: CrosssimplemoduleCaller{contract: contract}, CrosssimplemoduleTransactor: CrosssimplemoduleTransactor{contract: contract}, CrosssimplemoduleFilterer: CrosssimplemoduleFilterer{contract: contract}}, nil
}

// NewCrosssimplemoduleCaller creates a new read-only instance of Crosssimplemodule, bound to a specific deployed contract.
func NewCrosssimplemoduleCaller(address common.Address, caller bind.ContractCaller) (*CrosssimplemoduleCaller, error) {
	contract, err := bindCrosssimplemodule(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &CrosssimplemoduleCaller{contract: contract}, nil
}

// NewCrosssimplemoduleTransactor creates a new write-only instance of Crosssimplemodule, bound to a specific deployed contract.
func NewCrosssimplemoduleTransactor(address common.Address, transactor bind.ContractTransactor) (*CrosssimplemoduleTransactor, error) {
	contract, err := bindCrosssimplemodule(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &CrosssimplemoduleTransactor{contract: contract}, nil
}

// NewCrosssimplemoduleFilterer creates a new log filterer instance of Crosssimplemodule, bound to a specific deployed contract.
func NewCrosssimplemoduleFilterer(address common.Address, filterer bind.ContractFilterer) (*CrosssimplemoduleFilterer, error) {
	contract, err := bindCrosssimplemodule(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &CrosssimplemoduleFilterer{contract: contract}, nil
}

// bindCrosssimplemodule binds a generic wrapper to an already deployed contract.
func bindCrosssimplemodule(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := CrosssimplemoduleMetaData.GetAbi()
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, *parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Crosssimplemodule *CrosssimplemoduleRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _Crosssimplemodule.Contract.CrosssimplemoduleCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Crosssimplemodule *CrosssimplemoduleRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.CrosssimplemoduleTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Crosssimplemodule *CrosssimplemoduleRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.CrosssimplemoduleTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Crosssimplemodule *CrosssimplemoduleCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _Crosssimplemodule.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Crosssimplemodule *CrosssimplemoduleTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Crosssimplemodule *CrosssimplemoduleTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.contract.Transact(opts, method, params...)
}

// CHAINIDHASH is a free data retrieval call binding the contract method 0x2aed401b.
//
// Solidity: function CHAIN_ID_HASH() view returns(bytes32)
func (_Crosssimplemodule *CrosssimplemoduleCaller) CHAINIDHASH(opts *bind.CallOpts) ([32]byte, error) {
	var out []interface{}
	err := _Crosssimplemodule.contract.Call(opts, &out, "CHAIN_ID_HASH")

	if err != nil {
		return *new([32]byte), err
	}

	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)

	return out0, err

}

// CHAINIDHASH is a free data retrieval call binding the contract method 0x2aed401b.
//
// Solidity: function CHAIN_ID_HASH() view returns(bytes32)
func (_Crosssimplemodule *CrosssimplemoduleSession) CHAINIDHASH() ([32]byte, error) {
	return _Crosssimplemodule.Contract.CHAINIDHASH(&_Crosssimplemodule.CallOpts)
}

// CHAINIDHASH is a free data retrieval call binding the contract method 0x2aed401b.
//
// Solidity: function CHAIN_ID_HASH() view returns(bytes32)
func (_Crosssimplemodule *CrosssimplemoduleCallerSession) CHAINIDHASH() ([32]byte, error) {
	return _Crosssimplemodule.Contract.CHAINIDHASH(&_Crosssimplemodule.CallOpts)
}

// DEFAULTADMINROLE is a free data retrieval call binding the contract method 0xa217fddf.
//
// Solidity: function DEFAULT_ADMIN_ROLE() view returns(bytes32)
func (_Crosssimplemodule *CrosssimplemoduleCaller) DEFAULTADMINROLE(opts *bind.CallOpts) ([32]byte, error) {
	var out []interface{}
	err := _Crosssimplemodule.contract.Call(opts, &out, "DEFAULT_ADMIN_ROLE")

	if err != nil {
		return *new([32]byte), err
	}

	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)

	return out0, err

}

// DEFAULTADMINROLE is a free data retrieval call binding the contract method 0xa217fddf.
//
// Solidity: function DEFAULT_ADMIN_ROLE() view returns(bytes32)
func (_Crosssimplemodule *CrosssimplemoduleSession) DEFAULTADMINROLE() ([32]byte, error) {
	return _Crosssimplemodule.Contract.DEFAULTADMINROLE(&_Crosssimplemodule.CallOpts)
}

// DEFAULTADMINROLE is a free data retrieval call binding the contract method 0xa217fddf.
//
// Solidity: function DEFAULT_ADMIN_ROLE() view returns(bytes32)
func (_Crosssimplemodule *CrosssimplemoduleCallerSession) DEFAULTADMINROLE() ([32]byte, error) {
	return _Crosssimplemodule.Contract.DEFAULTADMINROLE(&_Crosssimplemodule.CallOpts)
}

// IBCROLE is a free data retrieval call binding the contract method 0x280cdebe.
//
// Solidity: function IBC_ROLE() view returns(bytes32)
func (_Crosssimplemodule *CrosssimplemoduleCaller) IBCROLE(opts *bind.CallOpts) ([32]byte, error) {
	var out []interface{}
	err := _Crosssimplemodule.contract.Call(opts, &out, "IBC_ROLE")

	if err != nil {
		return *new([32]byte), err
	}

	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)

	return out0, err

}

// IBCROLE is a free data retrieval call binding the contract method 0x280cdebe.
//
// Solidity: function IBC_ROLE() view returns(bytes32)
func (_Crosssimplemodule *CrosssimplemoduleSession) IBCROLE() ([32]byte, error) {
	return _Crosssimplemodule.Contract.IBCROLE(&_Crosssimplemodule.CallOpts)
}

// IBCROLE is a free data retrieval call binding the contract method 0x280cdebe.
//
// Solidity: function IBC_ROLE() view returns(bytes32)
func (_Crosssimplemodule *CrosssimplemoduleCallerSession) IBCROLE() ([32]byte, error) {
	return _Crosssimplemodule.Contract.IBCROLE(&_Crosssimplemodule.CallOpts)
}

// TXAUTHMANAGER is a free data retrieval call binding the contract method 0xd9a4dcbe.
//
// Solidity: function TX_AUTH_MANAGER() view returns(address)
func (_Crosssimplemodule *CrosssimplemoduleCaller) TXAUTHMANAGER(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Crosssimplemodule.contract.Call(opts, &out, "TX_AUTH_MANAGER")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// TXAUTHMANAGER is a free data retrieval call binding the contract method 0xd9a4dcbe.
//
// Solidity: function TX_AUTH_MANAGER() view returns(address)
func (_Crosssimplemodule *CrosssimplemoduleSession) TXAUTHMANAGER() (common.Address, error) {
	return _Crosssimplemodule.Contract.TXAUTHMANAGER(&_Crosssimplemodule.CallOpts)
}

// TXAUTHMANAGER is a free data retrieval call binding the contract method 0xd9a4dcbe.
//
// Solidity: function TX_AUTH_MANAGER() view returns(address)
func (_Crosssimplemodule *CrosssimplemoduleCallerSession) TXAUTHMANAGER() (common.Address, error) {
	return _Crosssimplemodule.Contract.TXAUTHMANAGER(&_Crosssimplemodule.CallOpts)
}

// TXMANAGER is a free data retrieval call binding the contract method 0x49bfd237.
//
// Solidity: function TX_MANAGER() view returns(address)
func (_Crosssimplemodule *CrosssimplemoduleCaller) TXMANAGER(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Crosssimplemodule.contract.Call(opts, &out, "TX_MANAGER")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// TXMANAGER is a free data retrieval call binding the contract method 0x49bfd237.
//
// Solidity: function TX_MANAGER() view returns(address)
func (_Crosssimplemodule *CrosssimplemoduleSession) TXMANAGER() (common.Address, error) {
	return _Crosssimplemodule.Contract.TXMANAGER(&_Crosssimplemodule.CallOpts)
}

// TXMANAGER is a free data retrieval call binding the contract method 0x49bfd237.
//
// Solidity: function TX_MANAGER() view returns(address)
func (_Crosssimplemodule *CrosssimplemoduleCallerSession) TXMANAGER() (common.Address, error) {
	return _Crosssimplemodule.Contract.TXMANAGER(&_Crosssimplemodule.CallOpts)
}

// CoordinatorState is a free data retrieval call binding the contract method 0x9c1c9c9d.
//
// Solidity: function coordinatorState((bytes) req) view returns(((uint8,(string,string)[],uint8,uint8,uint32[],uint32[])))
func (_Crosssimplemodule *CrosssimplemoduleCaller) CoordinatorState(opts *bind.CallOpts, req QueryCoordinatorStateRequestData) (QueryCoordinatorStateResponseData, error) {
	var out []interface{}
	err := _Crosssimplemodule.contract.Call(opts, &out, "coordinatorState", req)

	if err != nil {
		return *new(QueryCoordinatorStateResponseData), err
	}

	out0 := *abi.ConvertType(out[0], new(QueryCoordinatorStateResponseData)).(*QueryCoordinatorStateResponseData)

	return out0, err

}

// CoordinatorState is a free data retrieval call binding the contract method 0x9c1c9c9d.
//
// Solidity: function coordinatorState((bytes) req) view returns(((uint8,(string,string)[],uint8,uint8,uint32[],uint32[])))
func (_Crosssimplemodule *CrosssimplemoduleSession) CoordinatorState(req QueryCoordinatorStateRequestData) (QueryCoordinatorStateResponseData, error) {
	return _Crosssimplemodule.Contract.CoordinatorState(&_Crosssimplemodule.CallOpts, req)
}

// CoordinatorState is a free data retrieval call binding the contract method 0x9c1c9c9d.
//
// Solidity: function coordinatorState((bytes) req) view returns(((uint8,(string,string)[],uint8,uint8,uint32[],uint32[])))
func (_Crosssimplemodule *CrosssimplemoduleCallerSession) CoordinatorState(req QueryCoordinatorStateRequestData) (QueryCoordinatorStateResponseData, error) {
	return _Crosssimplemodule.Contract.CoordinatorState(&_Crosssimplemodule.CallOpts, req)
}

// GetRoleAdmin is a free data retrieval call binding the contract method 0x248a9ca3.
//
// Solidity: function getRoleAdmin(bytes32 role) view returns(bytes32)
func (_Crosssimplemodule *CrosssimplemoduleCaller) GetRoleAdmin(opts *bind.CallOpts, role [32]byte) ([32]byte, error) {
	var out []interface{}
	err := _Crosssimplemodule.contract.Call(opts, &out, "getRoleAdmin", role)

	if err != nil {
		return *new([32]byte), err
	}

	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)

	return out0, err

}

// GetRoleAdmin is a free data retrieval call binding the contract method 0x248a9ca3.
//
// Solidity: function getRoleAdmin(bytes32 role) view returns(bytes32)
func (_Crosssimplemodule *CrosssimplemoduleSession) GetRoleAdmin(role [32]byte) ([32]byte, error) {
	return _Crosssimplemodule.Contract.GetRoleAdmin(&_Crosssimplemodule.CallOpts, role)
}

// GetRoleAdmin is a free data retrieval call binding the contract method 0x248a9ca3.
//
// Solidity: function getRoleAdmin(bytes32 role) view returns(bytes32)
func (_Crosssimplemodule *CrosssimplemoduleCallerSession) GetRoleAdmin(role [32]byte) ([32]byte, error) {
	return _Crosssimplemodule.Contract.GetRoleAdmin(&_Crosssimplemodule.CallOpts, role)
}

// HasRole is a free data retrieval call binding the contract method 0x91d14854.
//
// Solidity: function hasRole(bytes32 role, address account) view returns(bool)
func (_Crosssimplemodule *CrosssimplemoduleCaller) HasRole(opts *bind.CallOpts, role [32]byte, account common.Address) (bool, error) {
	var out []interface{}
	err := _Crosssimplemodule.contract.Call(opts, &out, "hasRole", role, account)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// HasRole is a free data retrieval call binding the contract method 0x91d14854.
//
// Solidity: function hasRole(bytes32 role, address account) view returns(bool)
func (_Crosssimplemodule *CrosssimplemoduleSession) HasRole(role [32]byte, account common.Address) (bool, error) {
	return _Crosssimplemodule.Contract.HasRole(&_Crosssimplemodule.CallOpts, role, account)
}

// HasRole is a free data retrieval call binding the contract method 0x91d14854.
//
// Solidity: function hasRole(bytes32 role, address account) view returns(bool)
func (_Crosssimplemodule *CrosssimplemoduleCallerSession) HasRole(role [32]byte, account common.Address) (bool, error) {
	return _Crosssimplemodule.Contract.HasRole(&_Crosssimplemodule.CallOpts, role, account)
}

// SelfXCC is a free data retrieval call binding the contract method 0xeb245d6c.
//
// Solidity: function selfXCC() view returns(((string,bytes)))
func (_Crosssimplemodule *CrosssimplemoduleCaller) SelfXCC(opts *bind.CallOpts) (QuerySelfXCCResponseData, error) {
	var out []interface{}
	err := _Crosssimplemodule.contract.Call(opts, &out, "selfXCC")

	if err != nil {
		return *new(QuerySelfXCCResponseData), err
	}

	out0 := *abi.ConvertType(out[0], new(QuerySelfXCCResponseData)).(*QuerySelfXCCResponseData)

	return out0, err

}

// SelfXCC is a free data retrieval call binding the contract method 0xeb245d6c.
//
// Solidity: function selfXCC() view returns(((string,bytes)))
func (_Crosssimplemodule *CrosssimplemoduleSession) SelfXCC() (QuerySelfXCCResponseData, error) {
	return _Crosssimplemodule.Contract.SelfXCC(&_Crosssimplemodule.CallOpts)
}

// SelfXCC is a free data retrieval call binding the contract method 0xeb245d6c.
//
// Solidity: function selfXCC() view returns(((string,bytes)))
func (_Crosssimplemodule *CrosssimplemoduleCallerSession) SelfXCC() (QuerySelfXCCResponseData, error) {
	return _Crosssimplemodule.Contract.SelfXCC(&_Crosssimplemodule.CallOpts)
}

// SupportsInterface is a free data retrieval call binding the contract method 0x01ffc9a7.
//
// Solidity: function supportsInterface(bytes4 interfaceID) view returns(bool)
func (_Crosssimplemodule *CrosssimplemoduleCaller) SupportsInterface(opts *bind.CallOpts, interfaceID [4]byte) (bool, error) {
	var out []interface{}
	err := _Crosssimplemodule.contract.Call(opts, &out, "supportsInterface", interfaceID)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// SupportsInterface is a free data retrieval call binding the contract method 0x01ffc9a7.
//
// Solidity: function supportsInterface(bytes4 interfaceID) view returns(bool)
func (_Crosssimplemodule *CrosssimplemoduleSession) SupportsInterface(interfaceID [4]byte) (bool, error) {
	return _Crosssimplemodule.Contract.SupportsInterface(&_Crosssimplemodule.CallOpts, interfaceID)
}

// SupportsInterface is a free data retrieval call binding the contract method 0x01ffc9a7.
//
// Solidity: function supportsInterface(bytes4 interfaceID) view returns(bool)
func (_Crosssimplemodule *CrosssimplemoduleCallerSession) SupportsInterface(interfaceID [4]byte) (bool, error) {
	return _Crosssimplemodule.Contract.SupportsInterface(&_Crosssimplemodule.CallOpts, interfaceID)
}

// GetAuthState is a paid mutator transaction binding the contract method 0x5b3af7a0.
//
// Solidity: function __getAuthState(bytes32 txID) returns(((bytes,(uint8,(string,bytes)))[]))
func (_Crosssimplemodule *CrosssimplemoduleTransactor) GetAuthState(opts *bind.TransactOpts, txID [32]byte) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "__getAuthState", txID)
}

// GetAuthState is a paid mutator transaction binding the contract method 0x5b3af7a0.
//
// Solidity: function __getAuthState(bytes32 txID) returns(((bytes,(uint8,(string,bytes)))[]))
func (_Crosssimplemodule *CrosssimplemoduleSession) GetAuthState(txID [32]byte) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.GetAuthState(&_Crosssimplemodule.TransactOpts, txID)
}

// GetAuthState is a paid mutator transaction binding the contract method 0x5b3af7a0.
//
// Solidity: function __getAuthState(bytes32 txID) returns(((bytes,(uint8,(string,bytes)))[]))
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) GetAuthState(txID [32]byte) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.GetAuthState(&_Crosssimplemodule.TransactOpts, txID)
}

// GetCoordinatorState is a paid mutator transaction binding the contract method 0x3a57f0d2.
//
// Solidity: function __getCoordinatorState(bytes32 txID) returns((uint8,(string,string)[],uint8,uint8,uint32[],uint32[]))
func (_Crosssimplemodule *CrosssimplemoduleTransactor) GetCoordinatorState(opts *bind.TransactOpts, txID [32]byte) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "__getCoordinatorState", txID)
}

// GetCoordinatorState is a paid mutator transaction binding the contract method 0x3a57f0d2.
//
// Solidity: function __getCoordinatorState(bytes32 txID) returns((uint8,(string,string)[],uint8,uint8,uint32[],uint32[]))
func (_Crosssimplemodule *CrosssimplemoduleSession) GetCoordinatorState(txID [32]byte) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.GetCoordinatorState(&_Crosssimplemodule.TransactOpts, txID)
}

// GetCoordinatorState is a paid mutator transaction binding the contract method 0x3a57f0d2.
//
// Solidity: function __getCoordinatorState(bytes32 txID) returns((uint8,(string,string)[],uint8,uint8,uint32[],uint32[]))
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) GetCoordinatorState(txID [32]byte) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.GetCoordinatorState(&_Crosssimplemodule.TransactOpts, txID)
}

// IsCompletedAuth is a paid mutator transaction binding the contract method 0x8081e423.
//
// Solidity: function __isCompletedAuth(bytes32 txID) returns(bool)
func (_Crosssimplemodule *CrosssimplemoduleTransactor) IsCompletedAuth(opts *bind.TransactOpts, txID [32]byte) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "__isCompletedAuth", txID)
}

// IsCompletedAuth is a paid mutator transaction binding the contract method 0x8081e423.
//
// Solidity: function __isCompletedAuth(bytes32 txID) returns(bool)
func (_Crosssimplemodule *CrosssimplemoduleSession) IsCompletedAuth(txID [32]byte) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.IsCompletedAuth(&_Crosssimplemodule.TransactOpts, txID)
}

// IsCompletedAuth is a paid mutator transaction binding the contract method 0x8081e423.
//
// Solidity: function __isCompletedAuth(bytes32 txID) returns(bool)
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) IsCompletedAuth(txID [32]byte) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.IsCompletedAuth(&_Crosssimplemodule.TransactOpts, txID)
}

// IsTxRecorded is a paid mutator transaction binding the contract method 0x7d9c639c.
//
// Solidity: function __isTxRecorded(bytes32 txID) returns(bool)
func (_Crosssimplemodule *CrosssimplemoduleTransactor) IsTxRecorded(opts *bind.TransactOpts, txID [32]byte) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "__isTxRecorded", txID)
}

// IsTxRecorded is a paid mutator transaction binding the contract method 0x7d9c639c.
//
// Solidity: function __isTxRecorded(bytes32 txID) returns(bool)
func (_Crosssimplemodule *CrosssimplemoduleSession) IsTxRecorded(txID [32]byte) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.IsTxRecorded(&_Crosssimplemodule.TransactOpts, txID)
}

// IsTxRecorded is a paid mutator transaction binding the contract method 0x7d9c639c.
//
// Solidity: function __isTxRecorded(bytes32 txID) returns(bool)
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) IsTxRecorded(txID [32]byte) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.IsTxRecorded(&_Crosssimplemodule.TransactOpts, txID)
}

// ExecuteTx is a paid mutator transaction binding the contract method 0x7bc6a510.
//
// Solidity: function executeTx((string,uint64,uint8,((string,bytes),(bytes,(uint8,(string,bytes)))[],bytes,(bytes),(uint32)[])[],(bytes,(uint8,(string,bytes)))[],(uint64,uint64),uint64) msg_) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactor) ExecuteTx(opts *bind.TransactOpts, msg_ MsgInitiateTxData) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "executeTx", msg_)
}

// ExecuteTx is a paid mutator transaction binding the contract method 0x7bc6a510.
//
// Solidity: function executeTx((string,uint64,uint8,((string,bytes),(bytes,(uint8,(string,bytes)))[],bytes,(bytes),(uint32)[])[],(bytes,(uint8,(string,bytes)))[],(uint64,uint64),uint64) msg_) returns()
func (_Crosssimplemodule *CrosssimplemoduleSession) ExecuteTx(msg_ MsgInitiateTxData) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.ExecuteTx(&_Crosssimplemodule.TransactOpts, msg_)
}

// ExecuteTx is a paid mutator transaction binding the contract method 0x7bc6a510.
//
// Solidity: function executeTx((string,uint64,uint8,((string,bytes),(bytes,(uint8,(string,bytes)))[],bytes,(bytes),(uint32)[])[],(bytes,(uint8,(string,bytes)))[],(uint64,uint64),uint64) msg_) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) ExecuteTx(msg_ MsgInitiateTxData) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.ExecuteTx(&_Crosssimplemodule.TransactOpts, msg_)
}

// ExtSignTx is a paid mutator transaction binding the contract method 0x2df86abc.
//
// Solidity: function extSignTx((bytes,(bytes,(uint8,(string,bytes)))[]) msg_) returns((bool))
func (_Crosssimplemodule *CrosssimplemoduleTransactor) ExtSignTx(opts *bind.TransactOpts, msg_ MsgExtSignTxData) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "extSignTx", msg_)
}

// ExtSignTx is a paid mutator transaction binding the contract method 0x2df86abc.
//
// Solidity: function extSignTx((bytes,(bytes,(uint8,(string,bytes)))[]) msg_) returns((bool))
func (_Crosssimplemodule *CrosssimplemoduleSession) ExtSignTx(msg_ MsgExtSignTxData) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.ExtSignTx(&_Crosssimplemodule.TransactOpts, msg_)
}

// ExtSignTx is a paid mutator transaction binding the contract method 0x2df86abc.
//
// Solidity: function extSignTx((bytes,(bytes,(uint8,(string,bytes)))[]) msg_) returns((bool))
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) ExtSignTx(msg_ MsgExtSignTxData) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.ExtSignTx(&_Crosssimplemodule.TransactOpts, msg_)
}

// GrantRole is a paid mutator transaction binding the contract method 0x2f2ff15d.
//
// Solidity: function grantRole(bytes32 role, address account) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactor) GrantRole(opts *bind.TransactOpts, role [32]byte, account common.Address) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "grantRole", role, account)
}

// GrantRole is a paid mutator transaction binding the contract method 0x2f2ff15d.
//
// Solidity: function grantRole(bytes32 role, address account) returns()
func (_Crosssimplemodule *CrosssimplemoduleSession) GrantRole(role [32]byte, account common.Address) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.GrantRole(&_Crosssimplemodule.TransactOpts, role, account)
}

// GrantRole is a paid mutator transaction binding the contract method 0x2f2ff15d.
//
// Solidity: function grantRole(bytes32 role, address account) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) GrantRole(role [32]byte, account common.Address) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.GrantRole(&_Crosssimplemodule.TransactOpts, role, account)
}

// InitiateTx is a paid mutator transaction binding the contract method 0x909445fc.
//
// Solidity: function initiateTx((string,uint64,uint8,((string,bytes),(bytes,(uint8,(string,bytes)))[],bytes,(bytes),(uint32)[])[],(bytes,(uint8,(string,bytes)))[],(uint64,uint64),uint64) msg_) returns((bytes,uint8) resp)
func (_Crosssimplemodule *CrosssimplemoduleTransactor) InitiateTx(opts *bind.TransactOpts, msg_ MsgInitiateTxData) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "initiateTx", msg_)
}

// InitiateTx is a paid mutator transaction binding the contract method 0x909445fc.
//
// Solidity: function initiateTx((string,uint64,uint8,((string,bytes),(bytes,(uint8,(string,bytes)))[],bytes,(bytes),(uint32)[])[],(bytes,(uint8,(string,bytes)))[],(uint64,uint64),uint64) msg_) returns((bytes,uint8) resp)
func (_Crosssimplemodule *CrosssimplemoduleSession) InitiateTx(msg_ MsgInitiateTxData) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.InitiateTx(&_Crosssimplemodule.TransactOpts, msg_)
}

// InitiateTx is a paid mutator transaction binding the contract method 0x909445fc.
//
// Solidity: function initiateTx((string,uint64,uint8,((string,bytes),(bytes,(uint8,(string,bytes)))[],bytes,(bytes),(uint32)[])[],(bytes,(uint8,(string,bytes)))[],(uint64,uint64),uint64) msg_) returns((bytes,uint8) resp)
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) InitiateTx(msg_ MsgInitiateTxData) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.InitiateTx(&_Crosssimplemodule.TransactOpts, msg_)
}

// OnAcknowledgementPacket is a paid mutator transaction binding the contract method 0xfb8b532e.
//
// Solidity: function onAcknowledgementPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet, bytes acknowledgement, address ) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactor) OnAcknowledgementPacket(opts *bind.TransactOpts, packet Packet, acknowledgement []byte, arg2 common.Address) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "onAcknowledgementPacket", packet, acknowledgement, arg2)
}

// OnAcknowledgementPacket is a paid mutator transaction binding the contract method 0xfb8b532e.
//
// Solidity: function onAcknowledgementPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet, bytes acknowledgement, address ) returns()
func (_Crosssimplemodule *CrosssimplemoduleSession) OnAcknowledgementPacket(packet Packet, acknowledgement []byte, arg2 common.Address) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnAcknowledgementPacket(&_Crosssimplemodule.TransactOpts, packet, acknowledgement, arg2)
}

// OnAcknowledgementPacket is a paid mutator transaction binding the contract method 0xfb8b532e.
//
// Solidity: function onAcknowledgementPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet, bytes acknowledgement, address ) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) OnAcknowledgementPacket(packet Packet, acknowledgement []byte, arg2 common.Address) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnAcknowledgementPacket(&_Crosssimplemodule.TransactOpts, packet, acknowledgement, arg2)
}

// OnChanCloseConfirm is a paid mutator transaction binding the contract method 0x38c858bc.
//
// Solidity: function onChanCloseConfirm((string,string) ) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactor) OnChanCloseConfirm(opts *bind.TransactOpts, arg0 IIBCModuleMsgOnChanCloseConfirm) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "onChanCloseConfirm", arg0)
}

// OnChanCloseConfirm is a paid mutator transaction binding the contract method 0x38c858bc.
//
// Solidity: function onChanCloseConfirm((string,string) ) returns()
func (_Crosssimplemodule *CrosssimplemoduleSession) OnChanCloseConfirm(arg0 IIBCModuleMsgOnChanCloseConfirm) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnChanCloseConfirm(&_Crosssimplemodule.TransactOpts, arg0)
}

// OnChanCloseConfirm is a paid mutator transaction binding the contract method 0x38c858bc.
//
// Solidity: function onChanCloseConfirm((string,string) ) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) OnChanCloseConfirm(arg0 IIBCModuleMsgOnChanCloseConfirm) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnChanCloseConfirm(&_Crosssimplemodule.TransactOpts, arg0)
}

// OnChanCloseInit is a paid mutator transaction binding the contract method 0x3c7df3fb.
//
// Solidity: function onChanCloseInit((string,string) ) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactor) OnChanCloseInit(opts *bind.TransactOpts, arg0 IIBCModuleMsgOnChanCloseInit) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "onChanCloseInit", arg0)
}

// OnChanCloseInit is a paid mutator transaction binding the contract method 0x3c7df3fb.
//
// Solidity: function onChanCloseInit((string,string) ) returns()
func (_Crosssimplemodule *CrosssimplemoduleSession) OnChanCloseInit(arg0 IIBCModuleMsgOnChanCloseInit) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnChanCloseInit(&_Crosssimplemodule.TransactOpts, arg0)
}

// OnChanCloseInit is a paid mutator transaction binding the contract method 0x3c7df3fb.
//
// Solidity: function onChanCloseInit((string,string) ) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) OnChanCloseInit(arg0 IIBCModuleMsgOnChanCloseInit) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnChanCloseInit(&_Crosssimplemodule.TransactOpts, arg0)
}

// OnChanOpenAck is a paid mutator transaction binding the contract method 0x12f6ff6f.
//
// Solidity: function onChanOpenAck((string,string,string) ) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactor) OnChanOpenAck(opts *bind.TransactOpts, arg0 IIBCModuleMsgOnChanOpenAck) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "onChanOpenAck", arg0)
}

// OnChanOpenAck is a paid mutator transaction binding the contract method 0x12f6ff6f.
//
// Solidity: function onChanOpenAck((string,string,string) ) returns()
func (_Crosssimplemodule *CrosssimplemoduleSession) OnChanOpenAck(arg0 IIBCModuleMsgOnChanOpenAck) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnChanOpenAck(&_Crosssimplemodule.TransactOpts, arg0)
}

// OnChanOpenAck is a paid mutator transaction binding the contract method 0x12f6ff6f.
//
// Solidity: function onChanOpenAck((string,string,string) ) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) OnChanOpenAck(arg0 IIBCModuleMsgOnChanOpenAck) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnChanOpenAck(&_Crosssimplemodule.TransactOpts, arg0)
}

// OnChanOpenConfirm is a paid mutator transaction binding the contract method 0x81b174dc.
//
// Solidity: function onChanOpenConfirm((string,string) ) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactor) OnChanOpenConfirm(opts *bind.TransactOpts, arg0 IIBCModuleMsgOnChanOpenConfirm) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "onChanOpenConfirm", arg0)
}

// OnChanOpenConfirm is a paid mutator transaction binding the contract method 0x81b174dc.
//
// Solidity: function onChanOpenConfirm((string,string) ) returns()
func (_Crosssimplemodule *CrosssimplemoduleSession) OnChanOpenConfirm(arg0 IIBCModuleMsgOnChanOpenConfirm) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnChanOpenConfirm(&_Crosssimplemodule.TransactOpts, arg0)
}

// OnChanOpenConfirm is a paid mutator transaction binding the contract method 0x81b174dc.
//
// Solidity: function onChanOpenConfirm((string,string) ) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) OnChanOpenConfirm(arg0 IIBCModuleMsgOnChanOpenConfirm) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnChanOpenConfirm(&_Crosssimplemodule.TransactOpts, arg0)
}

// OnChanOpenInit is a paid mutator transaction binding the contract method 0x0b7b4ccb.
//
// Solidity: function onChanOpenInit((uint8,string[],string,string,(string,string),string) msg_) returns(address moduleAddr, string version)
func (_Crosssimplemodule *CrosssimplemoduleTransactor) OnChanOpenInit(opts *bind.TransactOpts, msg_ IIBCModuleInitializerMsgOnChanOpenInit) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "onChanOpenInit", msg_)
}

// OnChanOpenInit is a paid mutator transaction binding the contract method 0x0b7b4ccb.
//
// Solidity: function onChanOpenInit((uint8,string[],string,string,(string,string),string) msg_) returns(address moduleAddr, string version)
func (_Crosssimplemodule *CrosssimplemoduleSession) OnChanOpenInit(msg_ IIBCModuleInitializerMsgOnChanOpenInit) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnChanOpenInit(&_Crosssimplemodule.TransactOpts, msg_)
}

// OnChanOpenInit is a paid mutator transaction binding the contract method 0x0b7b4ccb.
//
// Solidity: function onChanOpenInit((uint8,string[],string,string,(string,string),string) msg_) returns(address moduleAddr, string version)
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) OnChanOpenInit(msg_ IIBCModuleInitializerMsgOnChanOpenInit) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnChanOpenInit(&_Crosssimplemodule.TransactOpts, msg_)
}

// OnChanOpenTry is a paid mutator transaction binding the contract method 0xa7a61e66.
//
// Solidity: function onChanOpenTry((uint8,string[],string,string,(string,string),string) msg_) returns(address moduleAddr, string version)
func (_Crosssimplemodule *CrosssimplemoduleTransactor) OnChanOpenTry(opts *bind.TransactOpts, msg_ IIBCModuleInitializerMsgOnChanOpenTry) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "onChanOpenTry", msg_)
}

// OnChanOpenTry is a paid mutator transaction binding the contract method 0xa7a61e66.
//
// Solidity: function onChanOpenTry((uint8,string[],string,string,(string,string),string) msg_) returns(address moduleAddr, string version)
func (_Crosssimplemodule *CrosssimplemoduleSession) OnChanOpenTry(msg_ IIBCModuleInitializerMsgOnChanOpenTry) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnChanOpenTry(&_Crosssimplemodule.TransactOpts, msg_)
}

// OnChanOpenTry is a paid mutator transaction binding the contract method 0xa7a61e66.
//
// Solidity: function onChanOpenTry((uint8,string[],string,string,(string,string),string) msg_) returns(address moduleAddr, string version)
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) OnChanOpenTry(msg_ IIBCModuleInitializerMsgOnChanOpenTry) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnChanOpenTry(&_Crosssimplemodule.TransactOpts, msg_)
}

// OnRecvPacket is a paid mutator transaction binding the contract method 0x2301c6f5.
//
// Solidity: function onRecvPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet, address ) returns(bytes acknowledgement)
func (_Crosssimplemodule *CrosssimplemoduleTransactor) OnRecvPacket(opts *bind.TransactOpts, packet Packet, arg1 common.Address) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "onRecvPacket", packet, arg1)
}

// OnRecvPacket is a paid mutator transaction binding the contract method 0x2301c6f5.
//
// Solidity: function onRecvPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet, address ) returns(bytes acknowledgement)
func (_Crosssimplemodule *CrosssimplemoduleSession) OnRecvPacket(packet Packet, arg1 common.Address) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnRecvPacket(&_Crosssimplemodule.TransactOpts, packet, arg1)
}

// OnRecvPacket is a paid mutator transaction binding the contract method 0x2301c6f5.
//
// Solidity: function onRecvPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet, address ) returns(bytes acknowledgement)
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) OnRecvPacket(packet Packet, arg1 common.Address) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnRecvPacket(&_Crosssimplemodule.TransactOpts, packet, arg1)
}

// OnTimeoutPacket is a paid mutator transaction binding the contract method 0x52c7157d.
//
// Solidity: function onTimeoutPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet, address ) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactor) OnTimeoutPacket(opts *bind.TransactOpts, packet Packet, arg1 common.Address) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "onTimeoutPacket", packet, arg1)
}

// OnTimeoutPacket is a paid mutator transaction binding the contract method 0x52c7157d.
//
// Solidity: function onTimeoutPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet, address ) returns()
func (_Crosssimplemodule *CrosssimplemoduleSession) OnTimeoutPacket(packet Packet, arg1 common.Address) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnTimeoutPacket(&_Crosssimplemodule.TransactOpts, packet, arg1)
}

// OnTimeoutPacket is a paid mutator transaction binding the contract method 0x52c7157d.
//
// Solidity: function onTimeoutPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet, address ) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) OnTimeoutPacket(packet Packet, arg1 common.Address) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnTimeoutPacket(&_Crosssimplemodule.TransactOpts, packet, arg1)
}

// RenounceRole is a paid mutator transaction binding the contract method 0x36568abe.
//
// Solidity: function renounceRole(bytes32 role, address callerConfirmation) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactor) RenounceRole(opts *bind.TransactOpts, role [32]byte, callerConfirmation common.Address) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "renounceRole", role, callerConfirmation)
}

// RenounceRole is a paid mutator transaction binding the contract method 0x36568abe.
//
// Solidity: function renounceRole(bytes32 role, address callerConfirmation) returns()
func (_Crosssimplemodule *CrosssimplemoduleSession) RenounceRole(role [32]byte, callerConfirmation common.Address) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.RenounceRole(&_Crosssimplemodule.TransactOpts, role, callerConfirmation)
}

// RenounceRole is a paid mutator transaction binding the contract method 0x36568abe.
//
// Solidity: function renounceRole(bytes32 role, address callerConfirmation) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) RenounceRole(role [32]byte, callerConfirmation common.Address) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.RenounceRole(&_Crosssimplemodule.TransactOpts, role, callerConfirmation)
}

// RevokeRole is a paid mutator transaction binding the contract method 0xd547741f.
//
// Solidity: function revokeRole(bytes32 role, address account) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactor) RevokeRole(opts *bind.TransactOpts, role [32]byte, account common.Address) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "revokeRole", role, account)
}

// RevokeRole is a paid mutator transaction binding the contract method 0xd547741f.
//
// Solidity: function revokeRole(bytes32 role, address account) returns()
func (_Crosssimplemodule *CrosssimplemoduleSession) RevokeRole(role [32]byte, account common.Address) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.RevokeRole(&_Crosssimplemodule.TransactOpts, role, account)
}

// RevokeRole is a paid mutator transaction binding the contract method 0xd547741f.
//
// Solidity: function revokeRole(bytes32 role, address account) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) RevokeRole(role [32]byte, account common.Address) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.RevokeRole(&_Crosssimplemodule.TransactOpts, role, account)
}

// SignTx is a paid mutator transaction binding the contract method 0x4391870b.
//
// Solidity: function signTx((bytes,bytes[],(uint64,uint64),uint64) msg_) returns((bool,string))
func (_Crosssimplemodule *CrosssimplemoduleTransactor) SignTx(opts *bind.TransactOpts, msg_ MsgSignTxData) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "signTx", msg_)
}

// SignTx is a paid mutator transaction binding the contract method 0x4391870b.
//
// Solidity: function signTx((bytes,bytes[],(uint64,uint64),uint64) msg_) returns((bool,string))
func (_Crosssimplemodule *CrosssimplemoduleSession) SignTx(msg_ MsgSignTxData) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.SignTx(&_Crosssimplemodule.TransactOpts, msg_)
}

// SignTx is a paid mutator transaction binding the contract method 0x4391870b.
//
// Solidity: function signTx((bytes,bytes[],(uint64,uint64),uint64) msg_) returns((bool,string))
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) SignTx(msg_ MsgSignTxData) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.SignTx(&_Crosssimplemodule.TransactOpts, msg_)
}

// TxAuthState is a paid mutator transaction binding the contract method 0xa7edcfd6.
//
// Solidity: function txAuthState((bytes) req_) returns((((bytes,(uint8,(string,bytes)))[])) resp)
func (_Crosssimplemodule *CrosssimplemoduleTransactor) TxAuthState(opts *bind.TransactOpts, req_ QueryTxAuthStateRequestData) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "txAuthState", req_)
}

// TxAuthState is a paid mutator transaction binding the contract method 0xa7edcfd6.
//
// Solidity: function txAuthState((bytes) req_) returns((((bytes,(uint8,(string,bytes)))[])) resp)
func (_Crosssimplemodule *CrosssimplemoduleSession) TxAuthState(req_ QueryTxAuthStateRequestData) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.TxAuthState(&_Crosssimplemodule.TransactOpts, req_)
}

// TxAuthState is a paid mutator transaction binding the contract method 0xa7edcfd6.
//
// Solidity: function txAuthState((bytes) req_) returns((((bytes,(uint8,(string,bytes)))[])) resp)
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) TxAuthState(req_ QueryTxAuthStateRequestData) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.TxAuthState(&_Crosssimplemodule.TransactOpts, req_)
}

// CrosssimplemoduleOnAbortIterator is returned from FilterOnAbort and is used to iterate over the raw logs and unpacked data for OnAbort events raised by the Crosssimplemodule contract.
type CrosssimplemoduleOnAbortIterator struct {
	Event *CrosssimplemoduleOnAbort // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *CrosssimplemoduleOnAbortIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(CrosssimplemoduleOnAbort)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(CrosssimplemoduleOnAbort)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *CrosssimplemoduleOnAbortIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *CrosssimplemoduleOnAbortIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// CrosssimplemoduleOnAbort represents a OnAbort event raised by the Crosssimplemodule contract.
type CrosssimplemoduleOnAbort struct {
	TxID    common.Hash
	TxIndex uint8
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterOnAbort is a free log retrieval operation binding the contract event 0x250bcd3f1f48512b15dbba0fb804f06878f25675cc2381898c392169d814a6f1.
//
// Solidity: event OnAbort(bytes indexed txID, uint8 indexed txIndex)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) FilterOnAbort(opts *bind.FilterOpts, txID [][]byte, txIndex []uint8) (*CrosssimplemoduleOnAbortIterator, error) {

	var txIDRule []interface{}
	for _, txIDItem := range txID {
		txIDRule = append(txIDRule, txIDItem)
	}
	var txIndexRule []interface{}
	for _, txIndexItem := range txIndex {
		txIndexRule = append(txIndexRule, txIndexItem)
	}

	logs, sub, err := _Crosssimplemodule.contract.FilterLogs(opts, "OnAbort", txIDRule, txIndexRule)
	if err != nil {
		return nil, err
	}
	return &CrosssimplemoduleOnAbortIterator{contract: _Crosssimplemodule.contract, event: "OnAbort", logs: logs, sub: sub}, nil
}

// WatchOnAbort is a free log subscription operation binding the contract event 0x250bcd3f1f48512b15dbba0fb804f06878f25675cc2381898c392169d814a6f1.
//
// Solidity: event OnAbort(bytes indexed txID, uint8 indexed txIndex)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) WatchOnAbort(opts *bind.WatchOpts, sink chan<- *CrosssimplemoduleOnAbort, txID [][]byte, txIndex []uint8) (event.Subscription, error) {

	var txIDRule []interface{}
	for _, txIDItem := range txID {
		txIDRule = append(txIDRule, txIDItem)
	}
	var txIndexRule []interface{}
	for _, txIndexItem := range txIndex {
		txIndexRule = append(txIndexRule, txIndexItem)
	}

	logs, sub, err := _Crosssimplemodule.contract.WatchLogs(opts, "OnAbort", txIDRule, txIndexRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(CrosssimplemoduleOnAbort)
				if err := _Crosssimplemodule.contract.UnpackLog(event, "OnAbort", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseOnAbort is a log parse operation binding the contract event 0x250bcd3f1f48512b15dbba0fb804f06878f25675cc2381898c392169d814a6f1.
//
// Solidity: event OnAbort(bytes indexed txID, uint8 indexed txIndex)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) ParseOnAbort(log types.Log) (*CrosssimplemoduleOnAbort, error) {
	event := new(CrosssimplemoduleOnAbort)
	if err := _Crosssimplemodule.contract.UnpackLog(event, "OnAbort", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// CrosssimplemoduleOnCommitIterator is returned from FilterOnCommit and is used to iterate over the raw logs and unpacked data for OnCommit events raised by the Crosssimplemodule contract.
type CrosssimplemoduleOnCommitIterator struct {
	Event *CrosssimplemoduleOnCommit // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *CrosssimplemoduleOnCommitIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(CrosssimplemoduleOnCommit)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(CrosssimplemoduleOnCommit)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *CrosssimplemoduleOnCommitIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *CrosssimplemoduleOnCommitIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// CrosssimplemoduleOnCommit represents a OnCommit event raised by the Crosssimplemodule contract.
type CrosssimplemoduleOnCommit struct {
	TxID    common.Hash
	TxIndex uint8
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterOnCommit is a free log retrieval operation binding the contract event 0x7aaf0b63467fb40eac34c045248842f31e4e1edff7f0dd939f7ddeeddd83adc0.
//
// Solidity: event OnCommit(bytes indexed txID, uint8 indexed txIndex)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) FilterOnCommit(opts *bind.FilterOpts, txID [][]byte, txIndex []uint8) (*CrosssimplemoduleOnCommitIterator, error) {

	var txIDRule []interface{}
	for _, txIDItem := range txID {
		txIDRule = append(txIDRule, txIDItem)
	}
	var txIndexRule []interface{}
	for _, txIndexItem := range txIndex {
		txIndexRule = append(txIndexRule, txIndexItem)
	}

	logs, sub, err := _Crosssimplemodule.contract.FilterLogs(opts, "OnCommit", txIDRule, txIndexRule)
	if err != nil {
		return nil, err
	}
	return &CrosssimplemoduleOnCommitIterator{contract: _Crosssimplemodule.contract, event: "OnCommit", logs: logs, sub: sub}, nil
}

// WatchOnCommit is a free log subscription operation binding the contract event 0x7aaf0b63467fb40eac34c045248842f31e4e1edff7f0dd939f7ddeeddd83adc0.
//
// Solidity: event OnCommit(bytes indexed txID, uint8 indexed txIndex)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) WatchOnCommit(opts *bind.WatchOpts, sink chan<- *CrosssimplemoduleOnCommit, txID [][]byte, txIndex []uint8) (event.Subscription, error) {

	var txIDRule []interface{}
	for _, txIDItem := range txID {
		txIDRule = append(txIDRule, txIDItem)
	}
	var txIndexRule []interface{}
	for _, txIndexItem := range txIndex {
		txIndexRule = append(txIndexRule, txIndexItem)
	}

	logs, sub, err := _Crosssimplemodule.contract.WatchLogs(opts, "OnCommit", txIDRule, txIndexRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(CrosssimplemoduleOnCommit)
				if err := _Crosssimplemodule.contract.UnpackLog(event, "OnCommit", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseOnCommit is a log parse operation binding the contract event 0x7aaf0b63467fb40eac34c045248842f31e4e1edff7f0dd939f7ddeeddd83adc0.
//
// Solidity: event OnCommit(bytes indexed txID, uint8 indexed txIndex)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) ParseOnCommit(log types.Log) (*CrosssimplemoduleOnCommit, error) {
	event := new(CrosssimplemoduleOnCommit)
	if err := _Crosssimplemodule.contract.UnpackLog(event, "OnCommit", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// CrosssimplemoduleOnContractCommitImmediatelyIterator is returned from FilterOnContractCommitImmediately and is used to iterate over the raw logs and unpacked data for OnContractCommitImmediately events raised by the Crosssimplemodule contract.
type CrosssimplemoduleOnContractCommitImmediatelyIterator struct {
	Event *CrosssimplemoduleOnContractCommitImmediately // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *CrosssimplemoduleOnContractCommitImmediatelyIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(CrosssimplemoduleOnContractCommitImmediately)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(CrosssimplemoduleOnContractCommitImmediately)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *CrosssimplemoduleOnContractCommitImmediatelyIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *CrosssimplemoduleOnContractCommitImmediatelyIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// CrosssimplemoduleOnContractCommitImmediately represents a OnContractCommitImmediately event raised by the Crosssimplemodule contract.
type CrosssimplemoduleOnContractCommitImmediately struct {
	TxID    common.Hash
	TxIndex uint8
	Success bool
	Ret     []byte
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterOnContractCommitImmediately is a free log retrieval operation binding the contract event 0x7da7723d423258c97d02fba73c0951597dc48566af572d5cb8e2698c22102e61.
//
// Solidity: event OnContractCommitImmediately(bytes indexed txID, uint8 indexed txIndex, bool indexed success, bytes ret)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) FilterOnContractCommitImmediately(opts *bind.FilterOpts, txID [][]byte, txIndex []uint8, success []bool) (*CrosssimplemoduleOnContractCommitImmediatelyIterator, error) {

	var txIDRule []interface{}
	for _, txIDItem := range txID {
		txIDRule = append(txIDRule, txIDItem)
	}
	var txIndexRule []interface{}
	for _, txIndexItem := range txIndex {
		txIndexRule = append(txIndexRule, txIndexItem)
	}
	var successRule []interface{}
	for _, successItem := range success {
		successRule = append(successRule, successItem)
	}

	logs, sub, err := _Crosssimplemodule.contract.FilterLogs(opts, "OnContractCommitImmediately", txIDRule, txIndexRule, successRule)
	if err != nil {
		return nil, err
	}
	return &CrosssimplemoduleOnContractCommitImmediatelyIterator{contract: _Crosssimplemodule.contract, event: "OnContractCommitImmediately", logs: logs, sub: sub}, nil
}

// WatchOnContractCommitImmediately is a free log subscription operation binding the contract event 0x7da7723d423258c97d02fba73c0951597dc48566af572d5cb8e2698c22102e61.
//
// Solidity: event OnContractCommitImmediately(bytes indexed txID, uint8 indexed txIndex, bool indexed success, bytes ret)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) WatchOnContractCommitImmediately(opts *bind.WatchOpts, sink chan<- *CrosssimplemoduleOnContractCommitImmediately, txID [][]byte, txIndex []uint8, success []bool) (event.Subscription, error) {

	var txIDRule []interface{}
	for _, txIDItem := range txID {
		txIDRule = append(txIDRule, txIDItem)
	}
	var txIndexRule []interface{}
	for _, txIndexItem := range txIndex {
		txIndexRule = append(txIndexRule, txIndexItem)
	}
	var successRule []interface{}
	for _, successItem := range success {
		successRule = append(successRule, successItem)
	}

	logs, sub, err := _Crosssimplemodule.contract.WatchLogs(opts, "OnContractCommitImmediately", txIDRule, txIndexRule, successRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(CrosssimplemoduleOnContractCommitImmediately)
				if err := _Crosssimplemodule.contract.UnpackLog(event, "OnContractCommitImmediately", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseOnContractCommitImmediately is a log parse operation binding the contract event 0x7da7723d423258c97d02fba73c0951597dc48566af572d5cb8e2698c22102e61.
//
// Solidity: event OnContractCommitImmediately(bytes indexed txID, uint8 indexed txIndex, bool indexed success, bytes ret)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) ParseOnContractCommitImmediately(log types.Log) (*CrosssimplemoduleOnContractCommitImmediately, error) {
	event := new(CrosssimplemoduleOnContractCommitImmediately)
	if err := _Crosssimplemodule.contract.UnpackLog(event, "OnContractCommitImmediately", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// CrosssimplemoduleRoleAdminChangedIterator is returned from FilterRoleAdminChanged and is used to iterate over the raw logs and unpacked data for RoleAdminChanged events raised by the Crosssimplemodule contract.
type CrosssimplemoduleRoleAdminChangedIterator struct {
	Event *CrosssimplemoduleRoleAdminChanged // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *CrosssimplemoduleRoleAdminChangedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(CrosssimplemoduleRoleAdminChanged)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(CrosssimplemoduleRoleAdminChanged)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *CrosssimplemoduleRoleAdminChangedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *CrosssimplemoduleRoleAdminChangedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// CrosssimplemoduleRoleAdminChanged represents a RoleAdminChanged event raised by the Crosssimplemodule contract.
type CrosssimplemoduleRoleAdminChanged struct {
	Role              [32]byte
	PreviousAdminRole [32]byte
	NewAdminRole      [32]byte
	Raw               types.Log // Blockchain specific contextual infos
}

// FilterRoleAdminChanged is a free log retrieval operation binding the contract event 0xbd79b86ffe0ab8e8776151514217cd7cacd52c909f66475c3af44e129f0b00ff.
//
// Solidity: event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) FilterRoleAdminChanged(opts *bind.FilterOpts, role [][32]byte, previousAdminRole [][32]byte, newAdminRole [][32]byte) (*CrosssimplemoduleRoleAdminChangedIterator, error) {

	var roleRule []interface{}
	for _, roleItem := range role {
		roleRule = append(roleRule, roleItem)
	}
	var previousAdminRoleRule []interface{}
	for _, previousAdminRoleItem := range previousAdminRole {
		previousAdminRoleRule = append(previousAdminRoleRule, previousAdminRoleItem)
	}
	var newAdminRoleRule []interface{}
	for _, newAdminRoleItem := range newAdminRole {
		newAdminRoleRule = append(newAdminRoleRule, newAdminRoleItem)
	}

	logs, sub, err := _Crosssimplemodule.contract.FilterLogs(opts, "RoleAdminChanged", roleRule, previousAdminRoleRule, newAdminRoleRule)
	if err != nil {
		return nil, err
	}
	return &CrosssimplemoduleRoleAdminChangedIterator{contract: _Crosssimplemodule.contract, event: "RoleAdminChanged", logs: logs, sub: sub}, nil
}

// WatchRoleAdminChanged is a free log subscription operation binding the contract event 0xbd79b86ffe0ab8e8776151514217cd7cacd52c909f66475c3af44e129f0b00ff.
//
// Solidity: event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) WatchRoleAdminChanged(opts *bind.WatchOpts, sink chan<- *CrosssimplemoduleRoleAdminChanged, role [][32]byte, previousAdminRole [][32]byte, newAdminRole [][32]byte) (event.Subscription, error) {

	var roleRule []interface{}
	for _, roleItem := range role {
		roleRule = append(roleRule, roleItem)
	}
	var previousAdminRoleRule []interface{}
	for _, previousAdminRoleItem := range previousAdminRole {
		previousAdminRoleRule = append(previousAdminRoleRule, previousAdminRoleItem)
	}
	var newAdminRoleRule []interface{}
	for _, newAdminRoleItem := range newAdminRole {
		newAdminRoleRule = append(newAdminRoleRule, newAdminRoleItem)
	}

	logs, sub, err := _Crosssimplemodule.contract.WatchLogs(opts, "RoleAdminChanged", roleRule, previousAdminRoleRule, newAdminRoleRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(CrosssimplemoduleRoleAdminChanged)
				if err := _Crosssimplemodule.contract.UnpackLog(event, "RoleAdminChanged", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseRoleAdminChanged is a log parse operation binding the contract event 0xbd79b86ffe0ab8e8776151514217cd7cacd52c909f66475c3af44e129f0b00ff.
//
// Solidity: event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) ParseRoleAdminChanged(log types.Log) (*CrosssimplemoduleRoleAdminChanged, error) {
	event := new(CrosssimplemoduleRoleAdminChanged)
	if err := _Crosssimplemodule.contract.UnpackLog(event, "RoleAdminChanged", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// CrosssimplemoduleRoleGrantedIterator is returned from FilterRoleGranted and is used to iterate over the raw logs and unpacked data for RoleGranted events raised by the Crosssimplemodule contract.
type CrosssimplemoduleRoleGrantedIterator struct {
	Event *CrosssimplemoduleRoleGranted // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *CrosssimplemoduleRoleGrantedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(CrosssimplemoduleRoleGranted)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(CrosssimplemoduleRoleGranted)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *CrosssimplemoduleRoleGrantedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *CrosssimplemoduleRoleGrantedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// CrosssimplemoduleRoleGranted represents a RoleGranted event raised by the Crosssimplemodule contract.
type CrosssimplemoduleRoleGranted struct {
	Role    [32]byte
	Account common.Address
	Sender  common.Address
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterRoleGranted is a free log retrieval operation binding the contract event 0x2f8788117e7eff1d82e926ec794901d17c78024a50270940304540a733656f0d.
//
// Solidity: event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) FilterRoleGranted(opts *bind.FilterOpts, role [][32]byte, account []common.Address, sender []common.Address) (*CrosssimplemoduleRoleGrantedIterator, error) {

	var roleRule []interface{}
	for _, roleItem := range role {
		roleRule = append(roleRule, roleItem)
	}
	var accountRule []interface{}
	for _, accountItem := range account {
		accountRule = append(accountRule, accountItem)
	}
	var senderRule []interface{}
	for _, senderItem := range sender {
		senderRule = append(senderRule, senderItem)
	}

	logs, sub, err := _Crosssimplemodule.contract.FilterLogs(opts, "RoleGranted", roleRule, accountRule, senderRule)
	if err != nil {
		return nil, err
	}
	return &CrosssimplemoduleRoleGrantedIterator{contract: _Crosssimplemodule.contract, event: "RoleGranted", logs: logs, sub: sub}, nil
}

// WatchRoleGranted is a free log subscription operation binding the contract event 0x2f8788117e7eff1d82e926ec794901d17c78024a50270940304540a733656f0d.
//
// Solidity: event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) WatchRoleGranted(opts *bind.WatchOpts, sink chan<- *CrosssimplemoduleRoleGranted, role [][32]byte, account []common.Address, sender []common.Address) (event.Subscription, error) {

	var roleRule []interface{}
	for _, roleItem := range role {
		roleRule = append(roleRule, roleItem)
	}
	var accountRule []interface{}
	for _, accountItem := range account {
		accountRule = append(accountRule, accountItem)
	}
	var senderRule []interface{}
	for _, senderItem := range sender {
		senderRule = append(senderRule, senderItem)
	}

	logs, sub, err := _Crosssimplemodule.contract.WatchLogs(opts, "RoleGranted", roleRule, accountRule, senderRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(CrosssimplemoduleRoleGranted)
				if err := _Crosssimplemodule.contract.UnpackLog(event, "RoleGranted", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseRoleGranted is a log parse operation binding the contract event 0x2f8788117e7eff1d82e926ec794901d17c78024a50270940304540a733656f0d.
//
// Solidity: event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) ParseRoleGranted(log types.Log) (*CrosssimplemoduleRoleGranted, error) {
	event := new(CrosssimplemoduleRoleGranted)
	if err := _Crosssimplemodule.contract.UnpackLog(event, "RoleGranted", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// CrosssimplemoduleRoleRevokedIterator is returned from FilterRoleRevoked and is used to iterate over the raw logs and unpacked data for RoleRevoked events raised by the Crosssimplemodule contract.
type CrosssimplemoduleRoleRevokedIterator struct {
	Event *CrosssimplemoduleRoleRevoked // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *CrosssimplemoduleRoleRevokedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(CrosssimplemoduleRoleRevoked)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(CrosssimplemoduleRoleRevoked)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *CrosssimplemoduleRoleRevokedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *CrosssimplemoduleRoleRevokedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// CrosssimplemoduleRoleRevoked represents a RoleRevoked event raised by the Crosssimplemodule contract.
type CrosssimplemoduleRoleRevoked struct {
	Role    [32]byte
	Account common.Address
	Sender  common.Address
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterRoleRevoked is a free log retrieval operation binding the contract event 0xf6391f5c32d9c69d2a47ea670b442974b53935d1edc7fd64eb21e047a839171b.
//
// Solidity: event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) FilterRoleRevoked(opts *bind.FilterOpts, role [][32]byte, account []common.Address, sender []common.Address) (*CrosssimplemoduleRoleRevokedIterator, error) {

	var roleRule []interface{}
	for _, roleItem := range role {
		roleRule = append(roleRule, roleItem)
	}
	var accountRule []interface{}
	for _, accountItem := range account {
		accountRule = append(accountRule, accountItem)
	}
	var senderRule []interface{}
	for _, senderItem := range sender {
		senderRule = append(senderRule, senderItem)
	}

	logs, sub, err := _Crosssimplemodule.contract.FilterLogs(opts, "RoleRevoked", roleRule, accountRule, senderRule)
	if err != nil {
		return nil, err
	}
	return &CrosssimplemoduleRoleRevokedIterator{contract: _Crosssimplemodule.contract, event: "RoleRevoked", logs: logs, sub: sub}, nil
}

// WatchRoleRevoked is a free log subscription operation binding the contract event 0xf6391f5c32d9c69d2a47ea670b442974b53935d1edc7fd64eb21e047a839171b.
//
// Solidity: event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) WatchRoleRevoked(opts *bind.WatchOpts, sink chan<- *CrosssimplemoduleRoleRevoked, role [][32]byte, account []common.Address, sender []common.Address) (event.Subscription, error) {

	var roleRule []interface{}
	for _, roleItem := range role {
		roleRule = append(roleRule, roleItem)
	}
	var accountRule []interface{}
	for _, accountItem := range account {
		accountRule = append(accountRule, accountItem)
	}
	var senderRule []interface{}
	for _, senderItem := range sender {
		senderRule = append(senderRule, senderItem)
	}

	logs, sub, err := _Crosssimplemodule.contract.WatchLogs(opts, "RoleRevoked", roleRule, accountRule, senderRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(CrosssimplemoduleRoleRevoked)
				if err := _Crosssimplemodule.contract.UnpackLog(event, "RoleRevoked", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseRoleRevoked is a log parse operation binding the contract event 0xf6391f5c32d9c69d2a47ea670b442974b53935d1edc7fd64eb21e047a839171b.
//
// Solidity: event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) ParseRoleRevoked(log types.Log) (*CrosssimplemoduleRoleRevoked, error) {
	event := new(CrosssimplemoduleRoleRevoked)
	if err := _Crosssimplemodule.contract.UnpackLog(event, "RoleRevoked", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// CrosssimplemoduleTxExecutedIterator is returned from FilterTxExecuted and is used to iterate over the raw logs and unpacked data for TxExecuted events raised by the Crosssimplemodule contract.
type CrosssimplemoduleTxExecutedIterator struct {
	Event *CrosssimplemoduleTxExecuted // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *CrosssimplemoduleTxExecutedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(CrosssimplemoduleTxExecuted)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(CrosssimplemoduleTxExecuted)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *CrosssimplemoduleTxExecutedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *CrosssimplemoduleTxExecutedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// CrosssimplemoduleTxExecuted represents a TxExecuted event raised by the Crosssimplemodule contract.
type CrosssimplemoduleTxExecuted struct {
	TxID     []byte
	Proposer common.Address
	Raw      types.Log // Blockchain specific contextual infos
}

// FilterTxExecuted is a free log retrieval operation binding the contract event 0xdf7ae1f6bc0bafd42f6b0ffe61265f1f2b82ec85389dbacc0664f47af522db18.
//
// Solidity: event TxExecuted(bytes txID, address indexed proposer)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) FilterTxExecuted(opts *bind.FilterOpts, proposer []common.Address) (*CrosssimplemoduleTxExecutedIterator, error) {

	var proposerRule []interface{}
	for _, proposerItem := range proposer {
		proposerRule = append(proposerRule, proposerItem)
	}

	logs, sub, err := _Crosssimplemodule.contract.FilterLogs(opts, "TxExecuted", proposerRule)
	if err != nil {
		return nil, err
	}
	return &CrosssimplemoduleTxExecutedIterator{contract: _Crosssimplemodule.contract, event: "TxExecuted", logs: logs, sub: sub}, nil
}

// WatchTxExecuted is a free log subscription operation binding the contract event 0xdf7ae1f6bc0bafd42f6b0ffe61265f1f2b82ec85389dbacc0664f47af522db18.
//
// Solidity: event TxExecuted(bytes txID, address indexed proposer)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) WatchTxExecuted(opts *bind.WatchOpts, sink chan<- *CrosssimplemoduleTxExecuted, proposer []common.Address) (event.Subscription, error) {

	var proposerRule []interface{}
	for _, proposerItem := range proposer {
		proposerRule = append(proposerRule, proposerItem)
	}

	logs, sub, err := _Crosssimplemodule.contract.WatchLogs(opts, "TxExecuted", proposerRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(CrosssimplemoduleTxExecuted)
				if err := _Crosssimplemodule.contract.UnpackLog(event, "TxExecuted", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseTxExecuted is a log parse operation binding the contract event 0xdf7ae1f6bc0bafd42f6b0ffe61265f1f2b82ec85389dbacc0664f47af522db18.
//
// Solidity: event TxExecuted(bytes txID, address indexed proposer)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) ParseTxExecuted(log types.Log) (*CrosssimplemoduleTxExecuted, error) {
	event := new(CrosssimplemoduleTxExecuted)
	if err := _Crosssimplemodule.contract.UnpackLog(event, "TxExecuted", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// CrosssimplemoduleTxInitiatedIterator is returned from FilterTxInitiated and is used to iterate over the raw logs and unpacked data for TxInitiated events raised by the Crosssimplemodule contract.
type CrosssimplemoduleTxInitiatedIterator struct {
	Event *CrosssimplemoduleTxInitiated // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *CrosssimplemoduleTxInitiatedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(CrosssimplemoduleTxInitiated)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(CrosssimplemoduleTxInitiated)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *CrosssimplemoduleTxInitiatedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *CrosssimplemoduleTxInitiatedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// CrosssimplemoduleTxInitiated represents a TxInitiated event raised by the Crosssimplemodule contract.
type CrosssimplemoduleTxInitiated struct {
	TxID     []byte
	Proposer common.Address
	MsgData  MsgInitiateTxData
	Raw      types.Log // Blockchain specific contextual infos
}

// FilterTxInitiated is a free log retrieval operation binding the contract event 0x82b61ce957ceac1596e6ab9a00110d416225ef3b28693a337d32eede878df6cf.
//
// Solidity: event TxInitiated(bytes txID, address indexed proposer, (string,uint64,uint8,((string,bytes),(bytes,(uint8,(string,bytes)))[],bytes,(bytes),(uint32)[])[],(bytes,(uint8,(string,bytes)))[],(uint64,uint64),uint64) msgData)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) FilterTxInitiated(opts *bind.FilterOpts, proposer []common.Address) (*CrosssimplemoduleTxInitiatedIterator, error) {

	var proposerRule []interface{}
	for _, proposerItem := range proposer {
		proposerRule = append(proposerRule, proposerItem)
	}

	logs, sub, err := _Crosssimplemodule.contract.FilterLogs(opts, "TxInitiated", proposerRule)
	if err != nil {
		return nil, err
	}
	return &CrosssimplemoduleTxInitiatedIterator{contract: _Crosssimplemodule.contract, event: "TxInitiated", logs: logs, sub: sub}, nil
}

// WatchTxInitiated is a free log subscription operation binding the contract event 0x82b61ce957ceac1596e6ab9a00110d416225ef3b28693a337d32eede878df6cf.
//
// Solidity: event TxInitiated(bytes txID, address indexed proposer, (string,uint64,uint8,((string,bytes),(bytes,(uint8,(string,bytes)))[],bytes,(bytes),(uint32)[])[],(bytes,(uint8,(string,bytes)))[],(uint64,uint64),uint64) msgData)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) WatchTxInitiated(opts *bind.WatchOpts, sink chan<- *CrosssimplemoduleTxInitiated, proposer []common.Address) (event.Subscription, error) {

	var proposerRule []interface{}
	for _, proposerItem := range proposer {
		proposerRule = append(proposerRule, proposerItem)
	}

	logs, sub, err := _Crosssimplemodule.contract.WatchLogs(opts, "TxInitiated", proposerRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(CrosssimplemoduleTxInitiated)
				if err := _Crosssimplemodule.contract.UnpackLog(event, "TxInitiated", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseTxInitiated is a log parse operation binding the contract event 0x82b61ce957ceac1596e6ab9a00110d416225ef3b28693a337d32eede878df6cf.
//
// Solidity: event TxInitiated(bytes txID, address indexed proposer, (string,uint64,uint8,((string,bytes),(bytes,(uint8,(string,bytes)))[],bytes,(bytes),(uint32)[])[],(bytes,(uint8,(string,bytes)))[],(uint64,uint64),uint64) msgData)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) ParseTxInitiated(log types.Log) (*CrosssimplemoduleTxInitiated, error) {
	event := new(CrosssimplemoduleTxInitiated)
	if err := _Crosssimplemodule.contract.UnpackLog(event, "TxInitiated", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// CrosssimplemoduleTxSignedIterator is returned from FilterTxSigned and is used to iterate over the raw logs and unpacked data for TxSigned events raised by the Crosssimplemodule contract.
type CrosssimplemoduleTxSignedIterator struct {
	Event *CrosssimplemoduleTxSigned // Event containing the contract specifics and raw log

	contract *bind.BoundContract // Generic contract to use for unpacking event data
	event    string              // Event name to use for unpacking event data

	logs chan types.Log        // Log channel receiving the found contract events
	sub  ethereum.Subscription // Subscription for errors, completion and termination
	done bool                  // Whether the subscription completed delivering logs
	fail error                 // Occurred error to stop iteration
}

// Next advances the iterator to the subsequent event, returning whether there
// are any more events found. In case of a retrieval or parsing error, false is
// returned and Error() can be queried for the exact failure.
func (it *CrosssimplemoduleTxSignedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(CrosssimplemoduleTxSigned)
			if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
				it.fail = err
				return false
			}
			it.Event.Raw = log
			return true

		default:
			return false
		}
	}
	// Iterator still in progress, wait for either a data or an error event
	select {
	case log := <-it.logs:
		it.Event = new(CrosssimplemoduleTxSigned)
		if err := it.contract.UnpackLog(it.Event, it.event, log); err != nil {
			it.fail = err
			return false
		}
		it.Event.Raw = log
		return true

	case err := <-it.sub.Err():
		it.done = true
		it.fail = err
		return it.Next()
	}
}

// Error returns any retrieval or parsing error occurred during filtering.
func (it *CrosssimplemoduleTxSignedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *CrosssimplemoduleTxSignedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// CrosssimplemoduleTxSigned represents a TxSigned event raised by the Crosssimplemodule contract.
type CrosssimplemoduleTxSigned struct {
	Signer common.Address
	TxID   [32]byte
	Method uint8
	Raw    types.Log // Blockchain specific contextual infos
}

// FilterTxSigned is a free log retrieval operation binding the contract event 0x30c2a521823a6b9bc4f65ec80485542760a5639a135db9e69f36d257d9c3a716.
//
// Solidity: event TxSigned(address indexed signer, bytes32 indexed txID, uint8 method)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) FilterTxSigned(opts *bind.FilterOpts, signer []common.Address, txID [][32]byte) (*CrosssimplemoduleTxSignedIterator, error) {

	var signerRule []interface{}
	for _, signerItem := range signer {
		signerRule = append(signerRule, signerItem)
	}
	var txIDRule []interface{}
	for _, txIDItem := range txID {
		txIDRule = append(txIDRule, txIDItem)
	}

	logs, sub, err := _Crosssimplemodule.contract.FilterLogs(opts, "TxSigned", signerRule, txIDRule)
	if err != nil {
		return nil, err
	}
	return &CrosssimplemoduleTxSignedIterator{contract: _Crosssimplemodule.contract, event: "TxSigned", logs: logs, sub: sub}, nil
}

// WatchTxSigned is a free log subscription operation binding the contract event 0x30c2a521823a6b9bc4f65ec80485542760a5639a135db9e69f36d257d9c3a716.
//
// Solidity: event TxSigned(address indexed signer, bytes32 indexed txID, uint8 method)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) WatchTxSigned(opts *bind.WatchOpts, sink chan<- *CrosssimplemoduleTxSigned, signer []common.Address, txID [][32]byte) (event.Subscription, error) {

	var signerRule []interface{}
	for _, signerItem := range signer {
		signerRule = append(signerRule, signerItem)
	}
	var txIDRule []interface{}
	for _, txIDItem := range txID {
		txIDRule = append(txIDRule, txIDItem)
	}

	logs, sub, err := _Crosssimplemodule.contract.WatchLogs(opts, "TxSigned", signerRule, txIDRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(CrosssimplemoduleTxSigned)
				if err := _Crosssimplemodule.contract.UnpackLog(event, "TxSigned", log); err != nil {
					return err
				}
				event.Raw = log

				select {
				case sink <- event:
				case err := <-sub.Err():
					return err
				case <-quit:
					return nil
				}
			case err := <-sub.Err():
				return err
			case <-quit:
				return nil
			}
		}
	}), nil
}

// ParseTxSigned is a log parse operation binding the contract event 0x30c2a521823a6b9bc4f65ec80485542760a5639a135db9e69f36d257d9c3a716.
//
// Solidity: event TxSigned(address indexed signer, bytes32 indexed txID, uint8 method)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) ParseTxSigned(log types.Log) (*CrosssimplemoduleTxSigned, error) {
	event := new(CrosssimplemoduleTxSigned)
	if err := _Crosssimplemodule.contract.UnpackLog(event, "TxSigned", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
