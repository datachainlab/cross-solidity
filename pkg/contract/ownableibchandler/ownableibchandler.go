// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package ownableibchandler

import (
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
	_ = big.NewInt
	_ = strings.NewReader
	_ = ethereum.NotFound
	_ = bind.Bind
	_ = common.Big1
	_ = types.BloomLookup
	_ = event.NewSubscription
)

// ChannelCounterpartyData is an auto generated low-level Go binding around an user-defined struct.
type ChannelCounterpartyData struct {
	PortId    string
	ChannelId string
}

// ChannelData is an auto generated low-level Go binding around an user-defined struct.
type ChannelData struct {
	State          uint8
	Ordering       uint8
	Counterparty   ChannelCounterpartyData
	ConnectionHops []string
	Version        string
}

// ConnectionEndData is an auto generated low-level Go binding around an user-defined struct.
type ConnectionEndData struct {
	ClientId     string
	Versions     []VersionData
	State        uint8
	Counterparty CounterpartyData
	DelayPeriod  uint64
}

// CounterpartyData is an auto generated low-level Go binding around an user-defined struct.
type CounterpartyData struct {
	ClientId     string
	ConnectionId string
	Prefix       MerklePrefixData
}

// HeightData is an auto generated low-level Go binding around an user-defined struct.
type HeightData struct {
	RevisionNumber uint64
	RevisionHeight uint64
}

// IBCMsgsMsgChannelCloseConfirm is an auto generated low-level Go binding around an user-defined struct.
type IBCMsgsMsgChannelCloseConfirm struct {
	PortId      string
	ChannelId   string
	ProofInit   []byte
	ProofHeight HeightData
}

// IBCMsgsMsgChannelCloseInit is an auto generated low-level Go binding around an user-defined struct.
type IBCMsgsMsgChannelCloseInit struct {
	PortId    string
	ChannelId string
}

// IBCMsgsMsgChannelOpenAck is an auto generated low-level Go binding around an user-defined struct.
type IBCMsgsMsgChannelOpenAck struct {
	PortId                string
	ChannelId             string
	CounterpartyVersion   string
	CounterpartyChannelId string
	ProofTry              []byte
	ProofHeight           HeightData
}

// IBCMsgsMsgChannelOpenConfirm is an auto generated low-level Go binding around an user-defined struct.
type IBCMsgsMsgChannelOpenConfirm struct {
	PortId      string
	ChannelId   string
	ProofAck    []byte
	ProofHeight HeightData
}

// IBCMsgsMsgChannelOpenInit is an auto generated low-level Go binding around an user-defined struct.
type IBCMsgsMsgChannelOpenInit struct {
	PortId  string
	Channel ChannelData
}

// IBCMsgsMsgChannelOpenTry is an auto generated low-level Go binding around an user-defined struct.
type IBCMsgsMsgChannelOpenTry struct {
	PortId              string
	PreviousChannelId   string
	Channel             ChannelData
	CounterpartyVersion string
	ProofInit           []byte
	ProofHeight         HeightData
}

// IBCMsgsMsgConnectionOpenAck is an auto generated low-level Go binding around an user-defined struct.
type IBCMsgsMsgConnectionOpenAck struct {
	ConnectionId             string
	ClientStateBytes         []byte
	Version                  VersionData
	CounterpartyConnectionID string
	ProofTry                 []byte
	ProofClient              []byte
	ProofConsensus           []byte
	ProofHeight              HeightData
	ConsensusHeight          HeightData
}

// IBCMsgsMsgConnectionOpenConfirm is an auto generated low-level Go binding around an user-defined struct.
type IBCMsgsMsgConnectionOpenConfirm struct {
	ConnectionId string
	ProofAck     []byte
	ProofHeight  HeightData
}

// IBCMsgsMsgConnectionOpenInit is an auto generated low-level Go binding around an user-defined struct.
type IBCMsgsMsgConnectionOpenInit struct {
	ClientId     string
	Counterparty CounterpartyData
	DelayPeriod  uint64
}

// IBCMsgsMsgConnectionOpenTry is an auto generated low-level Go binding around an user-defined struct.
type IBCMsgsMsgConnectionOpenTry struct {
	PreviousConnectionId string
	Counterparty         CounterpartyData
	DelayPeriod          uint64
	ClientId             string
	ClientStateBytes     []byte
	CounterpartyVersions []VersionData
	ProofInit            []byte
	ProofClient          []byte
	ProofConsensus       []byte
	ProofHeight          HeightData
	ConsensusHeight      HeightData
}

// IBCMsgsMsgCreateClient is an auto generated low-level Go binding around an user-defined struct.
type IBCMsgsMsgCreateClient struct {
	ClientType          string
	Height              HeightData
	ClientStateBytes    []byte
	ConsensusStateBytes []byte
}

// IBCMsgsMsgPacketAcknowledgement is an auto generated low-level Go binding around an user-defined struct.
type IBCMsgsMsgPacketAcknowledgement struct {
	Packet          PacketData
	Acknowledgement []byte
	Proof           []byte
	ProofHeight     HeightData
}

// IBCMsgsMsgPacketRecv is an auto generated low-level Go binding around an user-defined struct.
type IBCMsgsMsgPacketRecv struct {
	Packet      PacketData
	Proof       []byte
	ProofHeight HeightData
}

// IBCMsgsMsgUpdateClient is an auto generated low-level Go binding around an user-defined struct.
type IBCMsgsMsgUpdateClient struct {
	ClientId      string
	ClientMessage []byte
}

// MerklePrefixData is an auto generated low-level Go binding around an user-defined struct.
type MerklePrefixData struct {
	KeyPrefix []byte
}

// PacketData is an auto generated low-level Go binding around an user-defined struct.
type PacketData struct {
	Sequence           uint64
	SourcePort         string
	SourceChannel      string
	DestinationPort    string
	DestinationChannel string
	Data               []byte
	TimeoutHeight      HeightData
	TimeoutTimestamp   uint64
}

// VersionData is an auto generated low-level Go binding around an user-defined struct.
type VersionData struct {
	Identifier string
	Features   []string
}

// OwnableibchandlerABI is the input ABI used to generate the binding from.
const OwnableibchandlerABI = "[{\"inputs\":[{\"internalType\":\"address\",\"name\":\"ibcClient\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"ibcConnection\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"ibcChannel\",\"type\":\"address\"},{\"internalType\":\"address\",\"name\":\"ibcPacket\",\"type\":\"address\"}],\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[{\"components\":[{\"internalType\":\"uint64\",\"name\":\"sequence\",\"type\":\"uint64\"},{\"internalType\":\"string\",\"name\":\"source_port\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"source_channel\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"destination_port\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"destination_channel\",\"type\":\"string\"},{\"internalType\":\"bytes\",\"name\":\"data\",\"type\":\"bytes\"},{\"components\":[{\"internalType\":\"uint64\",\"name\":\"revision_number\",\"type\":\"uint64\"},{\"internalType\":\"uint64\",\"name\":\"revision_height\",\"type\":\"uint64\"}],\"internalType\":\"structHeight.Data\",\"name\":\"timeout_height\",\"type\":\"tuple\"},{\"internalType\":\"uint64\",\"name\":\"timeout_timestamp\",\"type\":\"uint64\"}],\"indexed\":false,\"internalType\":\"structPacket.Data\",\"name\":\"packet\",\"type\":\"tuple\"},{\"indexed\":false,\"internalType\":\"bytes\",\"name\":\"acknowledgement\",\"type\":\"bytes\"}],\"name\":\"AcknowledgePacket\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"name\":\"GeneratedChannelIdentifier\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"name\":\"GeneratedClientIdentifier\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"string\",\"name\":\"\",\"type\":\"string\"}],\"name\":\"GeneratedConnectionIdentifier\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"internalType\":\"address\",\"name\":\"previousOwner\",\"type\":\"address\"},{\"indexed\":true,\"internalType\":\"address\",\"name\":\"newOwner\",\"type\":\"address\"}],\"name\":\"OwnershipTransferred\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"components\":[{\"internalType\":\"uint64\",\"name\":\"sequence\",\"type\":\"uint64\"},{\"internalType\":\"string\",\"name\":\"source_port\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"source_channel\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"destination_port\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"destination_channel\",\"type\":\"string\"},{\"internalType\":\"bytes\",\"name\":\"data\",\"type\":\"bytes\"},{\"components\":[{\"internalType\":\"uint64\",\"name\":\"revision_number\",\"type\":\"uint64\"},{\"internalType\":\"uint64\",\"name\":\"revision_height\",\"type\":\"uint64\"}],\"internalType\":\"structHeight.Data\",\"name\":\"timeout_height\",\"type\":\"tuple\"},{\"internalType\":\"uint64\",\"name\":\"timeout_timestamp\",\"type\":\"uint64\"}],\"indexed\":false,\"internalType\":\"structPacket.Data\",\"name\":\"packet\",\"type\":\"tuple\"}],\"name\":\"RecvPacket\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"components\":[{\"internalType\":\"uint64\",\"name\":\"sequence\",\"type\":\"uint64\"},{\"internalType\":\"string\",\"name\":\"source_port\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"source_channel\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"destination_port\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"destination_channel\",\"type\":\"string\"},{\"internalType\":\"bytes\",\"name\":\"data\",\"type\":\"bytes\"},{\"components\":[{\"internalType\":\"uint64\",\"name\":\"revision_number\",\"type\":\"uint64\"},{\"internalType\":\"uint64\",\"name\":\"revision_height\",\"type\":\"uint64\"}],\"internalType\":\"structHeight.Data\",\"name\":\"timeout_height\",\"type\":\"tuple\"},{\"internalType\":\"uint64\",\"name\":\"timeout_timestamp\",\"type\":\"uint64\"}],\"indexed\":false,\"internalType\":\"structPacket.Data\",\"name\":\"packet\",\"type\":\"tuple\"}],\"name\":\"SendPacket\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"internalType\":\"string\",\"name\":\"destinationPortId\",\"type\":\"string\"},{\"indexed\":false,\"internalType\":\"string\",\"name\":\"destinationChannel\",\"type\":\"string\"},{\"indexed\":false,\"internalType\":\"uint64\",\"name\":\"sequence\",\"type\":\"uint64\"},{\"indexed\":false,\"internalType\":\"bytes\",\"name\":\"acknowledgement\",\"type\":\"bytes\"}],\"name\":\"WriteAcknowledgement\",\"type\":\"event\"},{\"inputs\":[{\"components\":[{\"components\":[{\"internalType\":\"uint64\",\"name\":\"sequence\",\"type\":\"uint64\"},{\"internalType\":\"string\",\"name\":\"source_port\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"source_channel\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"destination_port\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"destination_channel\",\"type\":\"string\"},{\"internalType\":\"bytes\",\"name\":\"data\",\"type\":\"bytes\"},{\"components\":[{\"internalType\":\"uint64\",\"name\":\"revision_number\",\"type\":\"uint64\"},{\"internalType\":\"uint64\",\"name\":\"revision_height\",\"type\":\"uint64\"}],\"internalType\":\"structHeight.Data\",\"name\":\"timeout_height\",\"type\":\"tuple\"},{\"internalType\":\"uint64\",\"name\":\"timeout_timestamp\",\"type\":\"uint64\"}],\"internalType\":\"structPacket.Data\",\"name\":\"packet\",\"type\":\"tuple\"},{\"internalType\":\"bytes\",\"name\":\"acknowledgement\",\"type\":\"bytes\"},{\"internalType\":\"bytes\",\"name\":\"proof\",\"type\":\"bytes\"},{\"components\":[{\"internalType\":\"uint64\",\"name\":\"revision_number\",\"type\":\"uint64\"},{\"internalType\":\"uint64\",\"name\":\"revision_height\",\"type\":\"uint64\"}],\"internalType\":\"structHeight.Data\",\"name\":\"proofHeight\",\"type\":\"tuple\"}],\"internalType\":\"structIBCMsgs.MsgPacketAcknowledgement\",\"name\":\"msg_\",\"type\":\"tuple\"}],\"name\":\"acknowledgePacket\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"string\",\"name\":\"portId\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"channelId\",\"type\":\"string\"}],\"name\":\"channelCapabilityPath\",\"outputs\":[{\"internalType\":\"bytes\",\"name\":\"\",\"type\":\"bytes\"}],\"stateMutability\":\"pure\",\"type\":\"function\",\"constant\":true},{\"inputs\":[{\"components\":[{\"internalType\":\"string\",\"name\":\"portId\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"channelId\",\"type\":\"string\"},{\"internalType\":\"bytes\",\"name\":\"proofInit\",\"type\":\"bytes\"},{\"components\":[{\"internalType\":\"uint64\",\"name\":\"revision_number\",\"type\":\"uint64\"},{\"internalType\":\"uint64\",\"name\":\"revision_height\",\"type\":\"uint64\"}],\"internalType\":\"structHeight.Data\",\"name\":\"proofHeight\",\"type\":\"tuple\"}],\"internalType\":\"structIBCMsgs.MsgChannelCloseConfirm\",\"name\":\"msg_\",\"type\":\"tuple\"}],\"name\":\"channelCloseConfirm\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"components\":[{\"internalType\":\"string\",\"name\":\"portId\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"channelId\",\"type\":\"string\"}],\"internalType\":\"structIBCMsgs.MsgChannelCloseInit\",\"name\":\"msg_\",\"type\":\"tuple\"}],\"name\":\"channelCloseInit\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"components\":[{\"internalType\":\"string\",\"name\":\"portId\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"channelId\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"counterpartyVersion\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"counterpartyChannelId\",\"type\":\"string\"},{\"internalType\":\"bytes\",\"name\":\"proofTry\",\"type\":\"bytes\"},{\"components\":[{\"internalType\":\"uint64\",\"name\":\"revision_number\",\"type\":\"uint64\"},{\"internalType\":\"uint64\",\"name\":\"revision_height\",\"type\":\"uint64\"}],\"internalType\":\"structHeight.Data\",\"name\":\"proofHeight\",\"type\":\"tuple\"}],\"internalType\":\"structIBCMsgs.MsgChannelOpenAck\",\"name\":\"msg_\",\"type\":\"tuple\"}],\"name\":\"channelOpenAck\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"components\":[{\"internalType\":\"string\",\"name\":\"portId\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"channelId\",\"type\":\"string\"},{\"internalType\":\"bytes\",\"name\":\"proofAck\",\"type\":\"bytes\"},{\"components\":[{\"internalType\":\"uint64\",\"name\":\"revision_number\",\"type\":\"uint64\"},{\"internalType\":\"uint64\",\"name\":\"revision_height\",\"type\":\"uint64\"}],\"internalType\":\"structHeight.Data\",\"name\":\"proofHeight\",\"type\":\"tuple\"}],\"internalType\":\"structIBCMsgs.MsgChannelOpenConfirm\",\"name\":\"msg_\",\"type\":\"tuple\"}],\"name\":\"channelOpenConfirm\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"components\":[{\"internalType\":\"string\",\"name\":\"portId\",\"type\":\"string\"},{\"components\":[{\"internalType\":\"enumChannel.State\",\"name\":\"state\",\"type\":\"uint8\"},{\"internalType\":\"enumChannel.Order\",\"name\":\"ordering\",\"type\":\"uint8\"},{\"components\":[{\"internalType\":\"string\",\"name\":\"port_id\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"channel_id\",\"type\":\"string\"}],\"internalType\":\"structChannelCounterparty.Data\",\"name\":\"counterparty\",\"type\":\"tuple\"},{\"internalType\":\"string[]\",\"name\":\"connection_hops\",\"type\":\"string[]\"},{\"internalType\":\"string\",\"name\":\"version\",\"type\":\"string\"}],\"internalType\":\"structChannel.Data\",\"name\":\"channel\",\"type\":\"tuple\"}],\"internalType\":\"structIBCMsgs.MsgChannelOpenInit\",\"name\":\"msg_\",\"type\":\"tuple\"}],\"name\":\"channelOpenInit\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"channelId\",\"type\":\"string\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"components\":[{\"internalType\":\"string\",\"name\":\"portId\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"previousChannelId\",\"type\":\"string\"},{\"components\":[{\"internalType\":\"enumChannel.State\",\"name\":\"state\",\"type\":\"uint8\"},{\"internalType\":\"enumChannel.Order\",\"name\":\"ordering\",\"type\":\"uint8\"},{\"components\":[{\"internalType\":\"string\",\"name\":\"port_id\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"channel_id\",\"type\":\"string\"}],\"internalType\":\"structChannelCounterparty.Data\",\"name\":\"counterparty\",\"type\":\"tuple\"},{\"internalType\":\"string[]\",\"name\":\"connection_hops\",\"type\":\"string[]\"},{\"internalType\":\"string\",\"name\":\"version\",\"type\":\"string\"}],\"internalType\":\"structChannel.Data\",\"name\":\"channel\",\"type\":\"tuple\"},{\"internalType\":\"string\",\"name\":\"counterpartyVersion\",\"type\":\"string\"},{\"internalType\":\"bytes\",\"name\":\"proofInit\",\"type\":\"bytes\"},{\"components\":[{\"internalType\":\"uint64\",\"name\":\"revision_number\",\"type\":\"uint64\"},{\"internalType\":\"uint64\",\"name\":\"revision_height\",\"type\":\"uint64\"}],\"internalType\":\"structHeight.Data\",\"name\":\"proofHeight\",\"type\":\"tuple\"}],\"internalType\":\"structIBCMsgs.MsgChannelOpenTry\",\"name\":\"msg_\",\"type\":\"tuple\"}],\"name\":\"channelOpenTry\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"channelId\",\"type\":\"string\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"components\":[{\"internalType\":\"string\",\"name\":\"connectionId\",\"type\":\"string\"},{\"internalType\":\"bytes\",\"name\":\"clientStateBytes\",\"type\":\"bytes\"},{\"components\":[{\"internalType\":\"string\",\"name\":\"identifier\",\"type\":\"string\"},{\"internalType\":\"string[]\",\"name\":\"features\",\"type\":\"string[]\"}],\"internalType\":\"structVersion.Data\",\"name\":\"version\",\"type\":\"tuple\"},{\"internalType\":\"string\",\"name\":\"counterpartyConnectionID\",\"type\":\"string\"},{\"internalType\":\"bytes\",\"name\":\"proofTry\",\"type\":\"bytes\"},{\"internalType\":\"bytes\",\"name\":\"proofClient\",\"type\":\"bytes\"},{\"internalType\":\"bytes\",\"name\":\"proofConsensus\",\"type\":\"bytes\"},{\"components\":[{\"internalType\":\"uint64\",\"name\":\"revision_number\",\"type\":\"uint64\"},{\"internalType\":\"uint64\",\"name\":\"revision_height\",\"type\":\"uint64\"}],\"internalType\":\"structHeight.Data\",\"name\":\"proofHeight\",\"type\":\"tuple\"},{\"components\":[{\"internalType\":\"uint64\",\"name\":\"revision_number\",\"type\":\"uint64\"},{\"internalType\":\"uint64\",\"name\":\"revision_height\",\"type\":\"uint64\"}],\"internalType\":\"structHeight.Data\",\"name\":\"consensusHeight\",\"type\":\"tuple\"}],\"internalType\":\"structIBCMsgs.MsgConnectionOpenAck\",\"name\":\"msg_\",\"type\":\"tuple\"}],\"name\":\"connectionOpenAck\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"components\":[{\"internalType\":\"string\",\"name\":\"connectionId\",\"type\":\"string\"},{\"internalType\":\"bytes\",\"name\":\"proofAck\",\"type\":\"bytes\"},{\"components\":[{\"internalType\":\"uint64\",\"name\":\"revision_number\",\"type\":\"uint64\"},{\"internalType\":\"uint64\",\"name\":\"revision_height\",\"type\":\"uint64\"}],\"internalType\":\"structHeight.Data\",\"name\":\"proofHeight\",\"type\":\"tuple\"}],\"internalType\":\"structIBCMsgs.MsgConnectionOpenConfirm\",\"name\":\"msg_\",\"type\":\"tuple\"}],\"name\":\"connectionOpenConfirm\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"components\":[{\"internalType\":\"string\",\"name\":\"clientId\",\"type\":\"string\"},{\"components\":[{\"internalType\":\"string\",\"name\":\"client_id\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"connection_id\",\"type\":\"string\"},{\"components\":[{\"internalType\":\"bytes\",\"name\":\"key_prefix\",\"type\":\"bytes\"}],\"internalType\":\"structMerklePrefix.Data\",\"name\":\"prefix\",\"type\":\"tuple\"}],\"internalType\":\"structCounterparty.Data\",\"name\":\"counterparty\",\"type\":\"tuple\"},{\"internalType\":\"uint64\",\"name\":\"delayPeriod\",\"type\":\"uint64\"}],\"internalType\":\"structIBCMsgs.MsgConnectionOpenInit\",\"name\":\"msg_\",\"type\":\"tuple\"}],\"name\":\"connectionOpenInit\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"connectionId\",\"type\":\"string\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"components\":[{\"internalType\":\"string\",\"name\":\"previousConnectionId\",\"type\":\"string\"},{\"components\":[{\"internalType\":\"string\",\"name\":\"client_id\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"connection_id\",\"type\":\"string\"},{\"components\":[{\"internalType\":\"bytes\",\"name\":\"key_prefix\",\"type\":\"bytes\"}],\"internalType\":\"structMerklePrefix.Data\",\"name\":\"prefix\",\"type\":\"tuple\"}],\"internalType\":\"structCounterparty.Data\",\"name\":\"counterparty\",\"type\":\"tuple\"},{\"internalType\":\"uint64\",\"name\":\"delayPeriod\",\"type\":\"uint64\"},{\"internalType\":\"string\",\"name\":\"clientId\",\"type\":\"string\"},{\"internalType\":\"bytes\",\"name\":\"clientStateBytes\",\"type\":\"bytes\"},{\"components\":[{\"internalType\":\"string\",\"name\":\"identifier\",\"type\":\"string\"},{\"internalType\":\"string[]\",\"name\":\"features\",\"type\":\"string[]\"}],\"internalType\":\"structVersion.Data[]\",\"name\":\"counterpartyVersions\",\"type\":\"tuple[]\"},{\"internalType\":\"bytes\",\"name\":\"proofInit\",\"type\":\"bytes\"},{\"internalType\":\"bytes\",\"name\":\"proofClient\",\"type\":\"bytes\"},{\"internalType\":\"bytes\",\"name\":\"proofConsensus\",\"type\":\"bytes\"},{\"components\":[{\"internalType\":\"uint64\",\"name\":\"revision_number\",\"type\":\"uint64\"},{\"internalType\":\"uint64\",\"name\":\"revision_height\",\"type\":\"uint64\"}],\"internalType\":\"structHeight.Data\",\"name\":\"proofHeight\",\"type\":\"tuple\"},{\"components\":[{\"internalType\":\"uint64\",\"name\":\"revision_number\",\"type\":\"uint64\"},{\"internalType\":\"uint64\",\"name\":\"revision_height\",\"type\":\"uint64\"}],\"internalType\":\"structHeight.Data\",\"name\":\"consensusHeight\",\"type\":\"tuple\"}],\"internalType\":\"structIBCMsgs.MsgConnectionOpenTry\",\"name\":\"msg_\",\"type\":\"tuple\"}],\"name\":\"connectionOpenTry\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"connectionId\",\"type\":\"string\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"components\":[{\"internalType\":\"string\",\"name\":\"clientType\",\"type\":\"string\"},{\"components\":[{\"internalType\":\"uint64\",\"name\":\"revision_number\",\"type\":\"uint64\"},{\"internalType\":\"uint64\",\"name\":\"revision_height\",\"type\":\"uint64\"}],\"internalType\":\"structHeight.Data\",\"name\":\"height\",\"type\":\"tuple\"},{\"internalType\":\"bytes\",\"name\":\"clientStateBytes\",\"type\":\"bytes\"},{\"internalType\":\"bytes\",\"name\":\"consensusStateBytes\",\"type\":\"bytes\"}],\"internalType\":\"structIBCMsgs.MsgCreateClient\",\"name\":\"msg_\",\"type\":\"tuple\"}],\"name\":\"createClient\",\"outputs\":[{\"internalType\":\"string\",\"name\":\"clientId\",\"type\":\"string\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"string\",\"name\":\"portId\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"channelId\",\"type\":\"string\"}],\"name\":\"getChannel\",\"outputs\":[{\"components\":[{\"internalType\":\"enumChannel.State\",\"name\":\"state\",\"type\":\"uint8\"},{\"internalType\":\"enumChannel.Order\",\"name\":\"ordering\",\"type\":\"uint8\"},{\"components\":[{\"internalType\":\"string\",\"name\":\"port_id\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"channel_id\",\"type\":\"string\"}],\"internalType\":\"structChannelCounterparty.Data\",\"name\":\"counterparty\",\"type\":\"tuple\"},{\"internalType\":\"string[]\",\"name\":\"connection_hops\",\"type\":\"string[]\"},{\"internalType\":\"string\",\"name\":\"version\",\"type\":\"string\"}],\"internalType\":\"structChannel.Data\",\"name\":\"\",\"type\":\"tuple\"},{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\",\"constant\":true},{\"inputs\":[{\"internalType\":\"string\",\"name\":\"clientId\",\"type\":\"string\"}],\"name\":\"getClientState\",\"outputs\":[{\"internalType\":\"bytes\",\"name\":\"\",\"type\":\"bytes\"},{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\",\"constant\":true},{\"inputs\":[{\"internalType\":\"string\",\"name\":\"connectionId\",\"type\":\"string\"}],\"name\":\"getConnection\",\"outputs\":[{\"components\":[{\"internalType\":\"string\",\"name\":\"client_id\",\"type\":\"string\"},{\"components\":[{\"internalType\":\"string\",\"name\":\"identifier\",\"type\":\"string\"},{\"internalType\":\"string[]\",\"name\":\"features\",\"type\":\"string[]\"}],\"internalType\":\"structVersion.Data[]\",\"name\":\"versions\",\"type\":\"tuple[]\"},{\"internalType\":\"enumConnectionEnd.State\",\"name\":\"state\",\"type\":\"uint8\"},{\"components\":[{\"internalType\":\"string\",\"name\":\"client_id\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"connection_id\",\"type\":\"string\"},{\"components\":[{\"internalType\":\"bytes\",\"name\":\"key_prefix\",\"type\":\"bytes\"}],\"internalType\":\"structMerklePrefix.Data\",\"name\":\"prefix\",\"type\":\"tuple\"}],\"internalType\":\"structCounterparty.Data\",\"name\":\"counterparty\",\"type\":\"tuple\"},{\"internalType\":\"uint64\",\"name\":\"delay_period\",\"type\":\"uint64\"}],\"internalType\":\"structConnectionEnd.Data\",\"name\":\"\",\"type\":\"tuple\"},{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\",\"constant\":true},{\"inputs\":[{\"internalType\":\"string\",\"name\":\"clientId\",\"type\":\"string\"},{\"components\":[{\"internalType\":\"uint64\",\"name\":\"revision_number\",\"type\":\"uint64\"},{\"internalType\":\"uint64\",\"name\":\"revision_height\",\"type\":\"uint64\"}],\"internalType\":\"structHeight.Data\",\"name\":\"height\",\"type\":\"tuple\"}],\"name\":\"getConsensusState\",\"outputs\":[{\"internalType\":\"bytes\",\"name\":\"consensusStateBytes\",\"type\":\"bytes\"},{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\",\"constant\":true},{\"inputs\":[],\"name\":\"getExpectedTimePerBlock\",\"outputs\":[{\"internalType\":\"uint64\",\"name\":\"\",\"type\":\"uint64\"}],\"stateMutability\":\"view\",\"type\":\"function\",\"constant\":true},{\"inputs\":[{\"internalType\":\"string\",\"name\":\"portId\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"channelId\",\"type\":\"string\"}],\"name\":\"getNextSequenceSend\",\"outputs\":[{\"internalType\":\"uint64\",\"name\":\"\",\"type\":\"uint64\"}],\"stateMutability\":\"view\",\"type\":\"function\",\"constant\":true},{\"inputs\":[{\"internalType\":\"string\",\"name\":\"portId\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"channelId\",\"type\":\"string\"},{\"internalType\":\"uint64\",\"name\":\"sequence\",\"type\":\"uint64\"}],\"name\":\"getPacketAcknowledgementCommitment\",\"outputs\":[{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"},{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\",\"constant\":true},{\"inputs\":[{\"internalType\":\"string\",\"name\":\"portId\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"channelId\",\"type\":\"string\"},{\"internalType\":\"uint64\",\"name\":\"sequence\",\"type\":\"uint64\"}],\"name\":\"getPacketCommitment\",\"outputs\":[{\"internalType\":\"bytes32\",\"name\":\"\",\"type\":\"bytes32\"},{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\",\"constant\":true},{\"inputs\":[{\"internalType\":\"string\",\"name\":\"portId\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"channelId\",\"type\":\"string\"},{\"internalType\":\"uint64\",\"name\":\"sequence\",\"type\":\"uint64\"}],\"name\":\"hasPacketReceipt\",\"outputs\":[{\"internalType\":\"bool\",\"name\":\"\",\"type\":\"bool\"}],\"stateMutability\":\"view\",\"type\":\"function\",\"constant\":true},{\"inputs\":[],\"name\":\"owner\",\"outputs\":[{\"internalType\":\"address\",\"name\":\"\",\"type\":\"address\"}],\"stateMutability\":\"view\",\"type\":\"function\",\"constant\":true},{\"inputs\":[{\"internalType\":\"string\",\"name\":\"portId\",\"type\":\"string\"}],\"name\":\"portCapabilityPath\",\"outputs\":[{\"internalType\":\"bytes\",\"name\":\"\",\"type\":\"bytes\"}],\"stateMutability\":\"pure\",\"type\":\"function\",\"constant\":true},{\"inputs\":[{\"components\":[{\"components\":[{\"internalType\":\"uint64\",\"name\":\"sequence\",\"type\":\"uint64\"},{\"internalType\":\"string\",\"name\":\"source_port\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"source_channel\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"destination_port\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"destination_channel\",\"type\":\"string\"},{\"internalType\":\"bytes\",\"name\":\"data\",\"type\":\"bytes\"},{\"components\":[{\"internalType\":\"uint64\",\"name\":\"revision_number\",\"type\":\"uint64\"},{\"internalType\":\"uint64\",\"name\":\"revision_height\",\"type\":\"uint64\"}],\"internalType\":\"structHeight.Data\",\"name\":\"timeout_height\",\"type\":\"tuple\"},{\"internalType\":\"uint64\",\"name\":\"timeout_timestamp\",\"type\":\"uint64\"}],\"internalType\":\"structPacket.Data\",\"name\":\"packet\",\"type\":\"tuple\"},{\"internalType\":\"bytes\",\"name\":\"proof\",\"type\":\"bytes\"},{\"components\":[{\"internalType\":\"uint64\",\"name\":\"revision_number\",\"type\":\"uint64\"},{\"internalType\":\"uint64\",\"name\":\"revision_height\",\"type\":\"uint64\"}],\"internalType\":\"structHeight.Data\",\"name\":\"proofHeight\",\"type\":\"tuple\"}],\"internalType\":\"structIBCMsgs.MsgPacketRecv\",\"name\":\"msg_\",\"type\":\"tuple\"}],\"name\":\"recvPacket\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[],\"name\":\"renounceOwnership\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"components\":[{\"internalType\":\"uint64\",\"name\":\"sequence\",\"type\":\"uint64\"},{\"internalType\":\"string\",\"name\":\"source_port\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"source_channel\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"destination_port\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"destination_channel\",\"type\":\"string\"},{\"internalType\":\"bytes\",\"name\":\"data\",\"type\":\"bytes\"},{\"components\":[{\"internalType\":\"uint64\",\"name\":\"revision_number\",\"type\":\"uint64\"},{\"internalType\":\"uint64\",\"name\":\"revision_height\",\"type\":\"uint64\"}],\"internalType\":\"structHeight.Data\",\"name\":\"timeout_height\",\"type\":\"tuple\"},{\"internalType\":\"uint64\",\"name\":\"timeout_timestamp\",\"type\":\"uint64\"}],\"internalType\":\"structPacket.Data\",\"name\":\"packet\",\"type\":\"tuple\"}],\"name\":\"sendPacket\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"address\",\"name\":\"newOwner\",\"type\":\"address\"}],\"name\":\"transferOwnership\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"components\":[{\"internalType\":\"string\",\"name\":\"clientId\",\"type\":\"string\"},{\"internalType\":\"bytes\",\"name\":\"clientMessage\",\"type\":\"bytes\"}],\"internalType\":\"structIBCMsgs.MsgUpdateClient\",\"name\":\"msg_\",\"type\":\"tuple\"}],\"name\":\"updateClient\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"string\",\"name\":\"destinationPortId\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"destinationChannel\",\"type\":\"string\"},{\"internalType\":\"uint64\",\"name\":\"sequence\",\"type\":\"uint64\"},{\"internalType\":\"bytes\",\"name\":\"acknowledgement\",\"type\":\"bytes\"}],\"name\":\"writeAcknowledgement\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"string\",\"name\":\"clientType\",\"type\":\"string\"},{\"internalType\":\"contractILightClient\",\"name\":\"client\",\"type\":\"address\"}],\"name\":\"registerClient\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"string\",\"name\":\"portId\",\"type\":\"string\"},{\"internalType\":\"address\",\"name\":\"moduleAddress\",\"type\":\"address\"}],\"name\":\"bindPort\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"uint64\",\"name\":\"expectedTimePerBlock_\",\"type\":\"uint64\"}],\"name\":\"setExpectedTimePerBlock\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]"

// Ownableibchandler is an auto generated Go binding around an Ethereum contract.
type Ownableibchandler struct {
	OwnableibchandlerCaller     // Read-only binding to the contract
	OwnableibchandlerTransactor // Write-only binding to the contract
	OwnableibchandlerFilterer   // Log filterer for contract events
}

// OwnableibchandlerCaller is an auto generated read-only Go binding around an Ethereum contract.
type OwnableibchandlerCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// OwnableibchandlerTransactor is an auto generated write-only Go binding around an Ethereum contract.
type OwnableibchandlerTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// OwnableibchandlerFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type OwnableibchandlerFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// OwnableibchandlerSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type OwnableibchandlerSession struct {
	Contract     *Ownableibchandler // Generic contract binding to set the session for
	CallOpts     bind.CallOpts      // Call options to use throughout this session
	TransactOpts bind.TransactOpts  // Transaction auth options to use throughout this session
}

// OwnableibchandlerCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type OwnableibchandlerCallerSession struct {
	Contract *OwnableibchandlerCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts            // Call options to use throughout this session
}

// OwnableibchandlerTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type OwnableibchandlerTransactorSession struct {
	Contract     *OwnableibchandlerTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts            // Transaction auth options to use throughout this session
}

// OwnableibchandlerRaw is an auto generated low-level Go binding around an Ethereum contract.
type OwnableibchandlerRaw struct {
	Contract *Ownableibchandler // Generic contract binding to access the raw methods on
}

// OwnableibchandlerCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type OwnableibchandlerCallerRaw struct {
	Contract *OwnableibchandlerCaller // Generic read-only contract binding to access the raw methods on
}

// OwnableibchandlerTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type OwnableibchandlerTransactorRaw struct {
	Contract *OwnableibchandlerTransactor // Generic write-only contract binding to access the raw methods on
}

// NewOwnableibchandler creates a new instance of Ownableibchandler, bound to a specific deployed contract.
func NewOwnableibchandler(address common.Address, backend bind.ContractBackend) (*Ownableibchandler, error) {
	contract, err := bindOwnableibchandler(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &Ownableibchandler{OwnableibchandlerCaller: OwnableibchandlerCaller{contract: contract}, OwnableibchandlerTransactor: OwnableibchandlerTransactor{contract: contract}, OwnableibchandlerFilterer: OwnableibchandlerFilterer{contract: contract}}, nil
}

// NewOwnableibchandlerCaller creates a new read-only instance of Ownableibchandler, bound to a specific deployed contract.
func NewOwnableibchandlerCaller(address common.Address, caller bind.ContractCaller) (*OwnableibchandlerCaller, error) {
	contract, err := bindOwnableibchandler(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &OwnableibchandlerCaller{contract: contract}, nil
}

// NewOwnableibchandlerTransactor creates a new write-only instance of Ownableibchandler, bound to a specific deployed contract.
func NewOwnableibchandlerTransactor(address common.Address, transactor bind.ContractTransactor) (*OwnableibchandlerTransactor, error) {
	contract, err := bindOwnableibchandler(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &OwnableibchandlerTransactor{contract: contract}, nil
}

// NewOwnableibchandlerFilterer creates a new log filterer instance of Ownableibchandler, bound to a specific deployed contract.
func NewOwnableibchandlerFilterer(address common.Address, filterer bind.ContractFilterer) (*OwnableibchandlerFilterer, error) {
	contract, err := bindOwnableibchandler(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &OwnableibchandlerFilterer{contract: contract}, nil
}

// bindOwnableibchandler binds a generic wrapper to an already deployed contract.
func bindOwnableibchandler(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(OwnableibchandlerABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Ownableibchandler *OwnableibchandlerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _Ownableibchandler.Contract.OwnableibchandlerCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Ownableibchandler *OwnableibchandlerRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.OwnableibchandlerTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Ownableibchandler *OwnableibchandlerRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.OwnableibchandlerTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Ownableibchandler *OwnableibchandlerCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _Ownableibchandler.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Ownableibchandler *OwnableibchandlerTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Ownableibchandler *OwnableibchandlerTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.contract.Transact(opts, method, params...)
}

// ChannelCapabilityPath is a free data retrieval call binding the contract method 0x3bc3339f.
//
// Solidity: function channelCapabilityPath(string portId, string channelId) pure returns(bytes)
func (_Ownableibchandler *OwnableibchandlerCaller) ChannelCapabilityPath(opts *bind.CallOpts, portId string, channelId string) ([]byte, error) {
	var out []interface{}
	err := _Ownableibchandler.contract.Call(opts, &out, "channelCapabilityPath", portId, channelId)

	if err != nil {
		return *new([]byte), err
	}

	out0 := *abi.ConvertType(out[0], new([]byte)).(*[]byte)

	return out0, err

}

// ChannelCapabilityPath is a free data retrieval call binding the contract method 0x3bc3339f.
//
// Solidity: function channelCapabilityPath(string portId, string channelId) pure returns(bytes)
func (_Ownableibchandler *OwnableibchandlerSession) ChannelCapabilityPath(portId string, channelId string) ([]byte, error) {
	return _Ownableibchandler.Contract.ChannelCapabilityPath(&_Ownableibchandler.CallOpts, portId, channelId)
}

// ChannelCapabilityPath is a free data retrieval call binding the contract method 0x3bc3339f.
//
// Solidity: function channelCapabilityPath(string portId, string channelId) pure returns(bytes)
func (_Ownableibchandler *OwnableibchandlerCallerSession) ChannelCapabilityPath(portId string, channelId string) ([]byte, error) {
	return _Ownableibchandler.Contract.ChannelCapabilityPath(&_Ownableibchandler.CallOpts, portId, channelId)
}

// GetChannel is a free data retrieval call binding the contract method 0x3000217a.
//
// Solidity: function getChannel(string portId, string channelId) view returns((uint8,uint8,(string,string),string[],string), bool)
func (_Ownableibchandler *OwnableibchandlerCaller) GetChannel(opts *bind.CallOpts, portId string, channelId string) (ChannelData, bool, error) {
	var out []interface{}
	err := _Ownableibchandler.contract.Call(opts, &out, "getChannel", portId, channelId)

	if err != nil {
		return *new(ChannelData), *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(ChannelData)).(*ChannelData)
	out1 := *abi.ConvertType(out[1], new(bool)).(*bool)

	return out0, out1, err

}

// GetChannel is a free data retrieval call binding the contract method 0x3000217a.
//
// Solidity: function getChannel(string portId, string channelId) view returns((uint8,uint8,(string,string),string[],string), bool)
func (_Ownableibchandler *OwnableibchandlerSession) GetChannel(portId string, channelId string) (ChannelData, bool, error) {
	return _Ownableibchandler.Contract.GetChannel(&_Ownableibchandler.CallOpts, portId, channelId)
}

// GetChannel is a free data retrieval call binding the contract method 0x3000217a.
//
// Solidity: function getChannel(string portId, string channelId) view returns((uint8,uint8,(string,string),string[],string), bool)
func (_Ownableibchandler *OwnableibchandlerCallerSession) GetChannel(portId string, channelId string) (ChannelData, bool, error) {
	return _Ownableibchandler.Contract.GetChannel(&_Ownableibchandler.CallOpts, portId, channelId)
}

// GetClientState is a free data retrieval call binding the contract method 0x76c81c42.
//
// Solidity: function getClientState(string clientId) view returns(bytes, bool)
func (_Ownableibchandler *OwnableibchandlerCaller) GetClientState(opts *bind.CallOpts, clientId string) ([]byte, bool, error) {
	var out []interface{}
	err := _Ownableibchandler.contract.Call(opts, &out, "getClientState", clientId)

	if err != nil {
		return *new([]byte), *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new([]byte)).(*[]byte)
	out1 := *abi.ConvertType(out[1], new(bool)).(*bool)

	return out0, out1, err

}

// GetClientState is a free data retrieval call binding the contract method 0x76c81c42.
//
// Solidity: function getClientState(string clientId) view returns(bytes, bool)
func (_Ownableibchandler *OwnableibchandlerSession) GetClientState(clientId string) ([]byte, bool, error) {
	return _Ownableibchandler.Contract.GetClientState(&_Ownableibchandler.CallOpts, clientId)
}

// GetClientState is a free data retrieval call binding the contract method 0x76c81c42.
//
// Solidity: function getClientState(string clientId) view returns(bytes, bool)
func (_Ownableibchandler *OwnableibchandlerCallerSession) GetClientState(clientId string) ([]byte, bool, error) {
	return _Ownableibchandler.Contract.GetClientState(&_Ownableibchandler.CallOpts, clientId)
}

// GetConnection is a free data retrieval call binding the contract method 0x27711a69.
//
// Solidity: function getConnection(string connectionId) view returns((string,(string,string[])[],uint8,(string,string,(bytes)),uint64), bool)
func (_Ownableibchandler *OwnableibchandlerCaller) GetConnection(opts *bind.CallOpts, connectionId string) (ConnectionEndData, bool, error) {
	var out []interface{}
	err := _Ownableibchandler.contract.Call(opts, &out, "getConnection", connectionId)

	if err != nil {
		return *new(ConnectionEndData), *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(ConnectionEndData)).(*ConnectionEndData)
	out1 := *abi.ConvertType(out[1], new(bool)).(*bool)

	return out0, out1, err

}

// GetConnection is a free data retrieval call binding the contract method 0x27711a69.
//
// Solidity: function getConnection(string connectionId) view returns((string,(string,string[])[],uint8,(string,string,(bytes)),uint64), bool)
func (_Ownableibchandler *OwnableibchandlerSession) GetConnection(connectionId string) (ConnectionEndData, bool, error) {
	return _Ownableibchandler.Contract.GetConnection(&_Ownableibchandler.CallOpts, connectionId)
}

// GetConnection is a free data retrieval call binding the contract method 0x27711a69.
//
// Solidity: function getConnection(string connectionId) view returns((string,(string,string[])[],uint8,(string,string,(bytes)),uint64), bool)
func (_Ownableibchandler *OwnableibchandlerCallerSession) GetConnection(connectionId string) (ConnectionEndData, bool, error) {
	return _Ownableibchandler.Contract.GetConnection(&_Ownableibchandler.CallOpts, connectionId)
}

// GetConsensusState is a free data retrieval call binding the contract method 0x6cf44bf4.
//
// Solidity: function getConsensusState(string clientId, (uint64,uint64) height) view returns(bytes consensusStateBytes, bool)
func (_Ownableibchandler *OwnableibchandlerCaller) GetConsensusState(opts *bind.CallOpts, clientId string, height HeightData) ([]byte, bool, error) {
	var out []interface{}
	err := _Ownableibchandler.contract.Call(opts, &out, "getConsensusState", clientId, height)

	if err != nil {
		return *new([]byte), *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new([]byte)).(*[]byte)
	out1 := *abi.ConvertType(out[1], new(bool)).(*bool)

	return out0, out1, err

}

// GetConsensusState is a free data retrieval call binding the contract method 0x6cf44bf4.
//
// Solidity: function getConsensusState(string clientId, (uint64,uint64) height) view returns(bytes consensusStateBytes, bool)
func (_Ownableibchandler *OwnableibchandlerSession) GetConsensusState(clientId string, height HeightData) ([]byte, bool, error) {
	return _Ownableibchandler.Contract.GetConsensusState(&_Ownableibchandler.CallOpts, clientId, height)
}

// GetConsensusState is a free data retrieval call binding the contract method 0x6cf44bf4.
//
// Solidity: function getConsensusState(string clientId, (uint64,uint64) height) view returns(bytes consensusStateBytes, bool)
func (_Ownableibchandler *OwnableibchandlerCallerSession) GetConsensusState(clientId string, height HeightData) ([]byte, bool, error) {
	return _Ownableibchandler.Contract.GetConsensusState(&_Ownableibchandler.CallOpts, clientId, height)
}

// GetExpectedTimePerBlock is a free data retrieval call binding the contract method 0xec75d829.
//
// Solidity: function getExpectedTimePerBlock() view returns(uint64)
func (_Ownableibchandler *OwnableibchandlerCaller) GetExpectedTimePerBlock(opts *bind.CallOpts) (uint64, error) {
	var out []interface{}
	err := _Ownableibchandler.contract.Call(opts, &out, "getExpectedTimePerBlock")

	if err != nil {
		return *new(uint64), err
	}

	out0 := *abi.ConvertType(out[0], new(uint64)).(*uint64)

	return out0, err

}

// GetExpectedTimePerBlock is a free data retrieval call binding the contract method 0xec75d829.
//
// Solidity: function getExpectedTimePerBlock() view returns(uint64)
func (_Ownableibchandler *OwnableibchandlerSession) GetExpectedTimePerBlock() (uint64, error) {
	return _Ownableibchandler.Contract.GetExpectedTimePerBlock(&_Ownableibchandler.CallOpts)
}

// GetExpectedTimePerBlock is a free data retrieval call binding the contract method 0xec75d829.
//
// Solidity: function getExpectedTimePerBlock() view returns(uint64)
func (_Ownableibchandler *OwnableibchandlerCallerSession) GetExpectedTimePerBlock() (uint64, error) {
	return _Ownableibchandler.Contract.GetExpectedTimePerBlock(&_Ownableibchandler.CallOpts)
}

// GetNextSequenceSend is a free data retrieval call binding the contract method 0x582418b6.
//
// Solidity: function getNextSequenceSend(string portId, string channelId) view returns(uint64)
func (_Ownableibchandler *OwnableibchandlerCaller) GetNextSequenceSend(opts *bind.CallOpts, portId string, channelId string) (uint64, error) {
	var out []interface{}
	err := _Ownableibchandler.contract.Call(opts, &out, "getNextSequenceSend", portId, channelId)

	if err != nil {
		return *new(uint64), err
	}

	out0 := *abi.ConvertType(out[0], new(uint64)).(*uint64)

	return out0, err

}

// GetNextSequenceSend is a free data retrieval call binding the contract method 0x582418b6.
//
// Solidity: function getNextSequenceSend(string portId, string channelId) view returns(uint64)
func (_Ownableibchandler *OwnableibchandlerSession) GetNextSequenceSend(portId string, channelId string) (uint64, error) {
	return _Ownableibchandler.Contract.GetNextSequenceSend(&_Ownableibchandler.CallOpts, portId, channelId)
}

// GetNextSequenceSend is a free data retrieval call binding the contract method 0x582418b6.
//
// Solidity: function getNextSequenceSend(string portId, string channelId) view returns(uint64)
func (_Ownableibchandler *OwnableibchandlerCallerSession) GetNextSequenceSend(portId string, channelId string) (uint64, error) {
	return _Ownableibchandler.Contract.GetNextSequenceSend(&_Ownableibchandler.CallOpts, portId, channelId)
}

// GetPacketAcknowledgementCommitment is a free data retrieval call binding the contract method 0x71f56c59.
//
// Solidity: function getPacketAcknowledgementCommitment(string portId, string channelId, uint64 sequence) view returns(bytes32, bool)
func (_Ownableibchandler *OwnableibchandlerCaller) GetPacketAcknowledgementCommitment(opts *bind.CallOpts, portId string, channelId string, sequence uint64) ([32]byte, bool, error) {
	var out []interface{}
	err := _Ownableibchandler.contract.Call(opts, &out, "getPacketAcknowledgementCommitment", portId, channelId, sequence)

	if err != nil {
		return *new([32]byte), *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)
	out1 := *abi.ConvertType(out[1], new(bool)).(*bool)

	return out0, out1, err

}

// GetPacketAcknowledgementCommitment is a free data retrieval call binding the contract method 0x71f56c59.
//
// Solidity: function getPacketAcknowledgementCommitment(string portId, string channelId, uint64 sequence) view returns(bytes32, bool)
func (_Ownableibchandler *OwnableibchandlerSession) GetPacketAcknowledgementCommitment(portId string, channelId string, sequence uint64) ([32]byte, bool, error) {
	return _Ownableibchandler.Contract.GetPacketAcknowledgementCommitment(&_Ownableibchandler.CallOpts, portId, channelId, sequence)
}

// GetPacketAcknowledgementCommitment is a free data retrieval call binding the contract method 0x71f56c59.
//
// Solidity: function getPacketAcknowledgementCommitment(string portId, string channelId, uint64 sequence) view returns(bytes32, bool)
func (_Ownableibchandler *OwnableibchandlerCallerSession) GetPacketAcknowledgementCommitment(portId string, channelId string, sequence uint64) ([32]byte, bool, error) {
	return _Ownableibchandler.Contract.GetPacketAcknowledgementCommitment(&_Ownableibchandler.CallOpts, portId, channelId, sequence)
}

// GetPacketCommitment is a free data retrieval call binding the contract method 0x61fc5e7b.
//
// Solidity: function getPacketCommitment(string portId, string channelId, uint64 sequence) view returns(bytes32, bool)
func (_Ownableibchandler *OwnableibchandlerCaller) GetPacketCommitment(opts *bind.CallOpts, portId string, channelId string, sequence uint64) ([32]byte, bool, error) {
	var out []interface{}
	err := _Ownableibchandler.contract.Call(opts, &out, "getPacketCommitment", portId, channelId, sequence)

	if err != nil {
		return *new([32]byte), *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new([32]byte)).(*[32]byte)
	out1 := *abi.ConvertType(out[1], new(bool)).(*bool)

	return out0, out1, err

}

// GetPacketCommitment is a free data retrieval call binding the contract method 0x61fc5e7b.
//
// Solidity: function getPacketCommitment(string portId, string channelId, uint64 sequence) view returns(bytes32, bool)
func (_Ownableibchandler *OwnableibchandlerSession) GetPacketCommitment(portId string, channelId string, sequence uint64) ([32]byte, bool, error) {
	return _Ownableibchandler.Contract.GetPacketCommitment(&_Ownableibchandler.CallOpts, portId, channelId, sequence)
}

// GetPacketCommitment is a free data retrieval call binding the contract method 0x61fc5e7b.
//
// Solidity: function getPacketCommitment(string portId, string channelId, uint64 sequence) view returns(bytes32, bool)
func (_Ownableibchandler *OwnableibchandlerCallerSession) GetPacketCommitment(portId string, channelId string, sequence uint64) ([32]byte, bool, error) {
	return _Ownableibchandler.Contract.GetPacketCommitment(&_Ownableibchandler.CallOpts, portId, channelId, sequence)
}

// HasPacketReceipt is a free data retrieval call binding the contract method 0x5a9afac3.
//
// Solidity: function hasPacketReceipt(string portId, string channelId, uint64 sequence) view returns(bool)
func (_Ownableibchandler *OwnableibchandlerCaller) HasPacketReceipt(opts *bind.CallOpts, portId string, channelId string, sequence uint64) (bool, error) {
	var out []interface{}
	err := _Ownableibchandler.contract.Call(opts, &out, "hasPacketReceipt", portId, channelId, sequence)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// HasPacketReceipt is a free data retrieval call binding the contract method 0x5a9afac3.
//
// Solidity: function hasPacketReceipt(string portId, string channelId, uint64 sequence) view returns(bool)
func (_Ownableibchandler *OwnableibchandlerSession) HasPacketReceipt(portId string, channelId string, sequence uint64) (bool, error) {
	return _Ownableibchandler.Contract.HasPacketReceipt(&_Ownableibchandler.CallOpts, portId, channelId, sequence)
}

// HasPacketReceipt is a free data retrieval call binding the contract method 0x5a9afac3.
//
// Solidity: function hasPacketReceipt(string portId, string channelId, uint64 sequence) view returns(bool)
func (_Ownableibchandler *OwnableibchandlerCallerSession) HasPacketReceipt(portId string, channelId string, sequence uint64) (bool, error) {
	return _Ownableibchandler.Contract.HasPacketReceipt(&_Ownableibchandler.CallOpts, portId, channelId, sequence)
}

// Owner is a free data retrieval call binding the contract method 0x8da5cb5b.
//
// Solidity: function owner() view returns(address)
func (_Ownableibchandler *OwnableibchandlerCaller) Owner(opts *bind.CallOpts) (common.Address, error) {
	var out []interface{}
	err := _Ownableibchandler.contract.Call(opts, &out, "owner")

	if err != nil {
		return *new(common.Address), err
	}

	out0 := *abi.ConvertType(out[0], new(common.Address)).(*common.Address)

	return out0, err

}

// Owner is a free data retrieval call binding the contract method 0x8da5cb5b.
//
// Solidity: function owner() view returns(address)
func (_Ownableibchandler *OwnableibchandlerSession) Owner() (common.Address, error) {
	return _Ownableibchandler.Contract.Owner(&_Ownableibchandler.CallOpts)
}

// Owner is a free data retrieval call binding the contract method 0x8da5cb5b.
//
// Solidity: function owner() view returns(address)
func (_Ownableibchandler *OwnableibchandlerCallerSession) Owner() (common.Address, error) {
	return _Ownableibchandler.Contract.Owner(&_Ownableibchandler.CallOpts)
}

// PortCapabilityPath is a free data retrieval call binding the contract method 0x2570dae0.
//
// Solidity: function portCapabilityPath(string portId) pure returns(bytes)
func (_Ownableibchandler *OwnableibchandlerCaller) PortCapabilityPath(opts *bind.CallOpts, portId string) ([]byte, error) {
	var out []interface{}
	err := _Ownableibchandler.contract.Call(opts, &out, "portCapabilityPath", portId)

	if err != nil {
		return *new([]byte), err
	}

	out0 := *abi.ConvertType(out[0], new([]byte)).(*[]byte)

	return out0, err

}

// PortCapabilityPath is a free data retrieval call binding the contract method 0x2570dae0.
//
// Solidity: function portCapabilityPath(string portId) pure returns(bytes)
func (_Ownableibchandler *OwnableibchandlerSession) PortCapabilityPath(portId string) ([]byte, error) {
	return _Ownableibchandler.Contract.PortCapabilityPath(&_Ownableibchandler.CallOpts, portId)
}

// PortCapabilityPath is a free data retrieval call binding the contract method 0x2570dae0.
//
// Solidity: function portCapabilityPath(string portId) pure returns(bytes)
func (_Ownableibchandler *OwnableibchandlerCallerSession) PortCapabilityPath(portId string) ([]byte, error) {
	return _Ownableibchandler.Contract.PortCapabilityPath(&_Ownableibchandler.CallOpts, portId)
}

// AcknowledgePacket is a paid mutator transaction binding the contract method 0x59f37976.
//
// Solidity: function acknowledgePacket(((uint64,string,string,string,string,bytes,(uint64,uint64),uint64),bytes,bytes,(uint64,uint64)) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerTransactor) AcknowledgePacket(opts *bind.TransactOpts, msg_ IBCMsgsMsgPacketAcknowledgement) (*types.Transaction, error) {
	return _Ownableibchandler.contract.Transact(opts, "acknowledgePacket", msg_)
}

// AcknowledgePacket is a paid mutator transaction binding the contract method 0x59f37976.
//
// Solidity: function acknowledgePacket(((uint64,string,string,string,string,bytes,(uint64,uint64),uint64),bytes,bytes,(uint64,uint64)) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerSession) AcknowledgePacket(msg_ IBCMsgsMsgPacketAcknowledgement) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.AcknowledgePacket(&_Ownableibchandler.TransactOpts, msg_)
}

// AcknowledgePacket is a paid mutator transaction binding the contract method 0x59f37976.
//
// Solidity: function acknowledgePacket(((uint64,string,string,string,string,bytes,(uint64,uint64),uint64),bytes,bytes,(uint64,uint64)) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerTransactorSession) AcknowledgePacket(msg_ IBCMsgsMsgPacketAcknowledgement) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.AcknowledgePacket(&_Ownableibchandler.TransactOpts, msg_)
}

// BindPort is a paid mutator transaction binding the contract method 0x117e886a.
//
// Solidity: function bindPort(string portId, address moduleAddress) returns()
func (_Ownableibchandler *OwnableibchandlerTransactor) BindPort(opts *bind.TransactOpts, portId string, moduleAddress common.Address) (*types.Transaction, error) {
	return _Ownableibchandler.contract.Transact(opts, "bindPort", portId, moduleAddress)
}

// BindPort is a paid mutator transaction binding the contract method 0x117e886a.
//
// Solidity: function bindPort(string portId, address moduleAddress) returns()
func (_Ownableibchandler *OwnableibchandlerSession) BindPort(portId string, moduleAddress common.Address) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.BindPort(&_Ownableibchandler.TransactOpts, portId, moduleAddress)
}

// BindPort is a paid mutator transaction binding the contract method 0x117e886a.
//
// Solidity: function bindPort(string portId, address moduleAddress) returns()
func (_Ownableibchandler *OwnableibchandlerTransactorSession) BindPort(portId string, moduleAddress common.Address) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.BindPort(&_Ownableibchandler.TransactOpts, portId, moduleAddress)
}

// ChannelCloseConfirm is a paid mutator transaction binding the contract method 0x25cbc3a6.
//
// Solidity: function channelCloseConfirm((string,string,bytes,(uint64,uint64)) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerTransactor) ChannelCloseConfirm(opts *bind.TransactOpts, msg_ IBCMsgsMsgChannelCloseConfirm) (*types.Transaction, error) {
	return _Ownableibchandler.contract.Transact(opts, "channelCloseConfirm", msg_)
}

// ChannelCloseConfirm is a paid mutator transaction binding the contract method 0x25cbc3a6.
//
// Solidity: function channelCloseConfirm((string,string,bytes,(uint64,uint64)) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerSession) ChannelCloseConfirm(msg_ IBCMsgsMsgChannelCloseConfirm) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.ChannelCloseConfirm(&_Ownableibchandler.TransactOpts, msg_)
}

// ChannelCloseConfirm is a paid mutator transaction binding the contract method 0x25cbc3a6.
//
// Solidity: function channelCloseConfirm((string,string,bytes,(uint64,uint64)) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerTransactorSession) ChannelCloseConfirm(msg_ IBCMsgsMsgChannelCloseConfirm) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.ChannelCloseConfirm(&_Ownableibchandler.TransactOpts, msg_)
}

// ChannelCloseInit is a paid mutator transaction binding the contract method 0xa06cb3a2.
//
// Solidity: function channelCloseInit((string,string) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerTransactor) ChannelCloseInit(opts *bind.TransactOpts, msg_ IBCMsgsMsgChannelCloseInit) (*types.Transaction, error) {
	return _Ownableibchandler.contract.Transact(opts, "channelCloseInit", msg_)
}

// ChannelCloseInit is a paid mutator transaction binding the contract method 0xa06cb3a2.
//
// Solidity: function channelCloseInit((string,string) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerSession) ChannelCloseInit(msg_ IBCMsgsMsgChannelCloseInit) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.ChannelCloseInit(&_Ownableibchandler.TransactOpts, msg_)
}

// ChannelCloseInit is a paid mutator transaction binding the contract method 0xa06cb3a2.
//
// Solidity: function channelCloseInit((string,string) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerTransactorSession) ChannelCloseInit(msg_ IBCMsgsMsgChannelCloseInit) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.ChannelCloseInit(&_Ownableibchandler.TransactOpts, msg_)
}

// ChannelOpenAck is a paid mutator transaction binding the contract method 0x256c4199.
//
// Solidity: function channelOpenAck((string,string,string,string,bytes,(uint64,uint64)) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerTransactor) ChannelOpenAck(opts *bind.TransactOpts, msg_ IBCMsgsMsgChannelOpenAck) (*types.Transaction, error) {
	return _Ownableibchandler.contract.Transact(opts, "channelOpenAck", msg_)
}

// ChannelOpenAck is a paid mutator transaction binding the contract method 0x256c4199.
//
// Solidity: function channelOpenAck((string,string,string,string,bytes,(uint64,uint64)) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerSession) ChannelOpenAck(msg_ IBCMsgsMsgChannelOpenAck) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.ChannelOpenAck(&_Ownableibchandler.TransactOpts, msg_)
}

// ChannelOpenAck is a paid mutator transaction binding the contract method 0x256c4199.
//
// Solidity: function channelOpenAck((string,string,string,string,bytes,(uint64,uint64)) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerTransactorSession) ChannelOpenAck(msg_ IBCMsgsMsgChannelOpenAck) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.ChannelOpenAck(&_Ownableibchandler.TransactOpts, msg_)
}

// ChannelOpenConfirm is a paid mutator transaction binding the contract method 0x5bd51b62.
//
// Solidity: function channelOpenConfirm((string,string,bytes,(uint64,uint64)) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerTransactor) ChannelOpenConfirm(opts *bind.TransactOpts, msg_ IBCMsgsMsgChannelOpenConfirm) (*types.Transaction, error) {
	return _Ownableibchandler.contract.Transact(opts, "channelOpenConfirm", msg_)
}

// ChannelOpenConfirm is a paid mutator transaction binding the contract method 0x5bd51b62.
//
// Solidity: function channelOpenConfirm((string,string,bytes,(uint64,uint64)) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerSession) ChannelOpenConfirm(msg_ IBCMsgsMsgChannelOpenConfirm) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.ChannelOpenConfirm(&_Ownableibchandler.TransactOpts, msg_)
}

// ChannelOpenConfirm is a paid mutator transaction binding the contract method 0x5bd51b62.
//
// Solidity: function channelOpenConfirm((string,string,bytes,(uint64,uint64)) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerTransactorSession) ChannelOpenConfirm(msg_ IBCMsgsMsgChannelOpenConfirm) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.ChannelOpenConfirm(&_Ownableibchandler.TransactOpts, msg_)
}

// ChannelOpenInit is a paid mutator transaction binding the contract method 0xdd3469fc.
//
// Solidity: function channelOpenInit((string,(uint8,uint8,(string,string),string[],string)) msg_) returns(string channelId)
func (_Ownableibchandler *OwnableibchandlerTransactor) ChannelOpenInit(opts *bind.TransactOpts, msg_ IBCMsgsMsgChannelOpenInit) (*types.Transaction, error) {
	return _Ownableibchandler.contract.Transact(opts, "channelOpenInit", msg_)
}

// ChannelOpenInit is a paid mutator transaction binding the contract method 0xdd3469fc.
//
// Solidity: function channelOpenInit((string,(uint8,uint8,(string,string),string[],string)) msg_) returns(string channelId)
func (_Ownableibchandler *OwnableibchandlerSession) ChannelOpenInit(msg_ IBCMsgsMsgChannelOpenInit) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.ChannelOpenInit(&_Ownableibchandler.TransactOpts, msg_)
}

// ChannelOpenInit is a paid mutator transaction binding the contract method 0xdd3469fc.
//
// Solidity: function channelOpenInit((string,(uint8,uint8,(string,string),string[],string)) msg_) returns(string channelId)
func (_Ownableibchandler *OwnableibchandlerTransactorSession) ChannelOpenInit(msg_ IBCMsgsMsgChannelOpenInit) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.ChannelOpenInit(&_Ownableibchandler.TransactOpts, msg_)
}

// ChannelOpenTry is a paid mutator transaction binding the contract method 0xec6260a9.
//
// Solidity: function channelOpenTry((string,string,(uint8,uint8,(string,string),string[],string),string,bytes,(uint64,uint64)) msg_) returns(string channelId)
func (_Ownableibchandler *OwnableibchandlerTransactor) ChannelOpenTry(opts *bind.TransactOpts, msg_ IBCMsgsMsgChannelOpenTry) (*types.Transaction, error) {
	return _Ownableibchandler.contract.Transact(opts, "channelOpenTry", msg_)
}

// ChannelOpenTry is a paid mutator transaction binding the contract method 0xec6260a9.
//
// Solidity: function channelOpenTry((string,string,(uint8,uint8,(string,string),string[],string),string,bytes,(uint64,uint64)) msg_) returns(string channelId)
func (_Ownableibchandler *OwnableibchandlerSession) ChannelOpenTry(msg_ IBCMsgsMsgChannelOpenTry) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.ChannelOpenTry(&_Ownableibchandler.TransactOpts, msg_)
}

// ChannelOpenTry is a paid mutator transaction binding the contract method 0xec6260a9.
//
// Solidity: function channelOpenTry((string,string,(uint8,uint8,(string,string),string[],string),string,bytes,(uint64,uint64)) msg_) returns(string channelId)
func (_Ownableibchandler *OwnableibchandlerTransactorSession) ChannelOpenTry(msg_ IBCMsgsMsgChannelOpenTry) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.ChannelOpenTry(&_Ownableibchandler.TransactOpts, msg_)
}

// ConnectionOpenAck is a paid mutator transaction binding the contract method 0xb531861f.
//
// Solidity: function connectionOpenAck((string,bytes,(string,string[]),string,bytes,bytes,bytes,(uint64,uint64),(uint64,uint64)) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerTransactor) ConnectionOpenAck(opts *bind.TransactOpts, msg_ IBCMsgsMsgConnectionOpenAck) (*types.Transaction, error) {
	return _Ownableibchandler.contract.Transact(opts, "connectionOpenAck", msg_)
}

// ConnectionOpenAck is a paid mutator transaction binding the contract method 0xb531861f.
//
// Solidity: function connectionOpenAck((string,bytes,(string,string[]),string,bytes,bytes,bytes,(uint64,uint64),(uint64,uint64)) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerSession) ConnectionOpenAck(msg_ IBCMsgsMsgConnectionOpenAck) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.ConnectionOpenAck(&_Ownableibchandler.TransactOpts, msg_)
}

// ConnectionOpenAck is a paid mutator transaction binding the contract method 0xb531861f.
//
// Solidity: function connectionOpenAck((string,bytes,(string,string[]),string,bytes,bytes,bytes,(uint64,uint64),(uint64,uint64)) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerTransactorSession) ConnectionOpenAck(msg_ IBCMsgsMsgConnectionOpenAck) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.ConnectionOpenAck(&_Ownableibchandler.TransactOpts, msg_)
}

// ConnectionOpenConfirm is a paid mutator transaction binding the contract method 0x6a728f2c.
//
// Solidity: function connectionOpenConfirm((string,bytes,(uint64,uint64)) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerTransactor) ConnectionOpenConfirm(opts *bind.TransactOpts, msg_ IBCMsgsMsgConnectionOpenConfirm) (*types.Transaction, error) {
	return _Ownableibchandler.contract.Transact(opts, "connectionOpenConfirm", msg_)
}

// ConnectionOpenConfirm is a paid mutator transaction binding the contract method 0x6a728f2c.
//
// Solidity: function connectionOpenConfirm((string,bytes,(uint64,uint64)) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerSession) ConnectionOpenConfirm(msg_ IBCMsgsMsgConnectionOpenConfirm) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.ConnectionOpenConfirm(&_Ownableibchandler.TransactOpts, msg_)
}

// ConnectionOpenConfirm is a paid mutator transaction binding the contract method 0x6a728f2c.
//
// Solidity: function connectionOpenConfirm((string,bytes,(uint64,uint64)) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerTransactorSession) ConnectionOpenConfirm(msg_ IBCMsgsMsgConnectionOpenConfirm) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.ConnectionOpenConfirm(&_Ownableibchandler.TransactOpts, msg_)
}

// ConnectionOpenInit is a paid mutator transaction binding the contract method 0x01c6400f.
//
// Solidity: function connectionOpenInit((string,(string,string,(bytes)),uint64) msg_) returns(string connectionId)
func (_Ownableibchandler *OwnableibchandlerTransactor) ConnectionOpenInit(opts *bind.TransactOpts, msg_ IBCMsgsMsgConnectionOpenInit) (*types.Transaction, error) {
	return _Ownableibchandler.contract.Transact(opts, "connectionOpenInit", msg_)
}

// ConnectionOpenInit is a paid mutator transaction binding the contract method 0x01c6400f.
//
// Solidity: function connectionOpenInit((string,(string,string,(bytes)),uint64) msg_) returns(string connectionId)
func (_Ownableibchandler *OwnableibchandlerSession) ConnectionOpenInit(msg_ IBCMsgsMsgConnectionOpenInit) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.ConnectionOpenInit(&_Ownableibchandler.TransactOpts, msg_)
}

// ConnectionOpenInit is a paid mutator transaction binding the contract method 0x01c6400f.
//
// Solidity: function connectionOpenInit((string,(string,string,(bytes)),uint64) msg_) returns(string connectionId)
func (_Ownableibchandler *OwnableibchandlerTransactorSession) ConnectionOpenInit(msg_ IBCMsgsMsgConnectionOpenInit) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.ConnectionOpenInit(&_Ownableibchandler.TransactOpts, msg_)
}

// ConnectionOpenTry is a paid mutator transaction binding the contract method 0xde310341.
//
// Solidity: function connectionOpenTry((string,(string,string,(bytes)),uint64,string,bytes,(string,string[])[],bytes,bytes,bytes,(uint64,uint64),(uint64,uint64)) msg_) returns(string connectionId)
func (_Ownableibchandler *OwnableibchandlerTransactor) ConnectionOpenTry(opts *bind.TransactOpts, msg_ IBCMsgsMsgConnectionOpenTry) (*types.Transaction, error) {
	return _Ownableibchandler.contract.Transact(opts, "connectionOpenTry", msg_)
}

// ConnectionOpenTry is a paid mutator transaction binding the contract method 0xde310341.
//
// Solidity: function connectionOpenTry((string,(string,string,(bytes)),uint64,string,bytes,(string,string[])[],bytes,bytes,bytes,(uint64,uint64),(uint64,uint64)) msg_) returns(string connectionId)
func (_Ownableibchandler *OwnableibchandlerSession) ConnectionOpenTry(msg_ IBCMsgsMsgConnectionOpenTry) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.ConnectionOpenTry(&_Ownableibchandler.TransactOpts, msg_)
}

// ConnectionOpenTry is a paid mutator transaction binding the contract method 0xde310341.
//
// Solidity: function connectionOpenTry((string,(string,string,(bytes)),uint64,string,bytes,(string,string[])[],bytes,bytes,bytes,(uint64,uint64),(uint64,uint64)) msg_) returns(string connectionId)
func (_Ownableibchandler *OwnableibchandlerTransactorSession) ConnectionOpenTry(msg_ IBCMsgsMsgConnectionOpenTry) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.ConnectionOpenTry(&_Ownableibchandler.TransactOpts, msg_)
}

// CreateClient is a paid mutator transaction binding the contract method 0x0c8273ff.
//
// Solidity: function createClient((string,(uint64,uint64),bytes,bytes) msg_) returns(string clientId)
func (_Ownableibchandler *OwnableibchandlerTransactor) CreateClient(opts *bind.TransactOpts, msg_ IBCMsgsMsgCreateClient) (*types.Transaction, error) {
	return _Ownableibchandler.contract.Transact(opts, "createClient", msg_)
}

// CreateClient is a paid mutator transaction binding the contract method 0x0c8273ff.
//
// Solidity: function createClient((string,(uint64,uint64),bytes,bytes) msg_) returns(string clientId)
func (_Ownableibchandler *OwnableibchandlerSession) CreateClient(msg_ IBCMsgsMsgCreateClient) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.CreateClient(&_Ownableibchandler.TransactOpts, msg_)
}

// CreateClient is a paid mutator transaction binding the contract method 0x0c8273ff.
//
// Solidity: function createClient((string,(uint64,uint64),bytes,bytes) msg_) returns(string clientId)
func (_Ownableibchandler *OwnableibchandlerTransactorSession) CreateClient(msg_ IBCMsgsMsgCreateClient) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.CreateClient(&_Ownableibchandler.TransactOpts, msg_)
}

// RecvPacket is a paid mutator transaction binding the contract method 0x236ebd70.
//
// Solidity: function recvPacket(((uint64,string,string,string,string,bytes,(uint64,uint64),uint64),bytes,(uint64,uint64)) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerTransactor) RecvPacket(opts *bind.TransactOpts, msg_ IBCMsgsMsgPacketRecv) (*types.Transaction, error) {
	return _Ownableibchandler.contract.Transact(opts, "recvPacket", msg_)
}

// RecvPacket is a paid mutator transaction binding the contract method 0x236ebd70.
//
// Solidity: function recvPacket(((uint64,string,string,string,string,bytes,(uint64,uint64),uint64),bytes,(uint64,uint64)) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerSession) RecvPacket(msg_ IBCMsgsMsgPacketRecv) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.RecvPacket(&_Ownableibchandler.TransactOpts, msg_)
}

// RecvPacket is a paid mutator transaction binding the contract method 0x236ebd70.
//
// Solidity: function recvPacket(((uint64,string,string,string,string,bytes,(uint64,uint64),uint64),bytes,(uint64,uint64)) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerTransactorSession) RecvPacket(msg_ IBCMsgsMsgPacketRecv) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.RecvPacket(&_Ownableibchandler.TransactOpts, msg_)
}

// RegisterClient is a paid mutator transaction binding the contract method 0x18c19870.
//
// Solidity: function registerClient(string clientType, address client) returns()
func (_Ownableibchandler *OwnableibchandlerTransactor) RegisterClient(opts *bind.TransactOpts, clientType string, client common.Address) (*types.Transaction, error) {
	return _Ownableibchandler.contract.Transact(opts, "registerClient", clientType, client)
}

// RegisterClient is a paid mutator transaction binding the contract method 0x18c19870.
//
// Solidity: function registerClient(string clientType, address client) returns()
func (_Ownableibchandler *OwnableibchandlerSession) RegisterClient(clientType string, client common.Address) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.RegisterClient(&_Ownableibchandler.TransactOpts, clientType, client)
}

// RegisterClient is a paid mutator transaction binding the contract method 0x18c19870.
//
// Solidity: function registerClient(string clientType, address client) returns()
func (_Ownableibchandler *OwnableibchandlerTransactorSession) RegisterClient(clientType string, client common.Address) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.RegisterClient(&_Ownableibchandler.TransactOpts, clientType, client)
}

// RenounceOwnership is a paid mutator transaction binding the contract method 0x715018a6.
//
// Solidity: function renounceOwnership() returns()
func (_Ownableibchandler *OwnableibchandlerTransactor) RenounceOwnership(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Ownableibchandler.contract.Transact(opts, "renounceOwnership")
}

// RenounceOwnership is a paid mutator transaction binding the contract method 0x715018a6.
//
// Solidity: function renounceOwnership() returns()
func (_Ownableibchandler *OwnableibchandlerSession) RenounceOwnership() (*types.Transaction, error) {
	return _Ownableibchandler.Contract.RenounceOwnership(&_Ownableibchandler.TransactOpts)
}

// RenounceOwnership is a paid mutator transaction binding the contract method 0x715018a6.
//
// Solidity: function renounceOwnership() returns()
func (_Ownableibchandler *OwnableibchandlerTransactorSession) RenounceOwnership() (*types.Transaction, error) {
	return _Ownableibchandler.Contract.RenounceOwnership(&_Ownableibchandler.TransactOpts)
}

// SendPacket is a paid mutator transaction binding the contract method 0x40835e44.
//
// Solidity: function sendPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet) returns()
func (_Ownableibchandler *OwnableibchandlerTransactor) SendPacket(opts *bind.TransactOpts, packet PacketData) (*types.Transaction, error) {
	return _Ownableibchandler.contract.Transact(opts, "sendPacket", packet)
}

// SendPacket is a paid mutator transaction binding the contract method 0x40835e44.
//
// Solidity: function sendPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet) returns()
func (_Ownableibchandler *OwnableibchandlerSession) SendPacket(packet PacketData) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.SendPacket(&_Ownableibchandler.TransactOpts, packet)
}

// SendPacket is a paid mutator transaction binding the contract method 0x40835e44.
//
// Solidity: function sendPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet) returns()
func (_Ownableibchandler *OwnableibchandlerTransactorSession) SendPacket(packet PacketData) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.SendPacket(&_Ownableibchandler.TransactOpts, packet)
}

// SetExpectedTimePerBlock is a paid mutator transaction binding the contract method 0x27184c13.
//
// Solidity: function setExpectedTimePerBlock(uint64 expectedTimePerBlock_) returns()
func (_Ownableibchandler *OwnableibchandlerTransactor) SetExpectedTimePerBlock(opts *bind.TransactOpts, expectedTimePerBlock_ uint64) (*types.Transaction, error) {
	return _Ownableibchandler.contract.Transact(opts, "setExpectedTimePerBlock", expectedTimePerBlock_)
}

// SetExpectedTimePerBlock is a paid mutator transaction binding the contract method 0x27184c13.
//
// Solidity: function setExpectedTimePerBlock(uint64 expectedTimePerBlock_) returns()
func (_Ownableibchandler *OwnableibchandlerSession) SetExpectedTimePerBlock(expectedTimePerBlock_ uint64) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.SetExpectedTimePerBlock(&_Ownableibchandler.TransactOpts, expectedTimePerBlock_)
}

// SetExpectedTimePerBlock is a paid mutator transaction binding the contract method 0x27184c13.
//
// Solidity: function setExpectedTimePerBlock(uint64 expectedTimePerBlock_) returns()
func (_Ownableibchandler *OwnableibchandlerTransactorSession) SetExpectedTimePerBlock(expectedTimePerBlock_ uint64) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.SetExpectedTimePerBlock(&_Ownableibchandler.TransactOpts, expectedTimePerBlock_)
}

// TransferOwnership is a paid mutator transaction binding the contract method 0xf2fde38b.
//
// Solidity: function transferOwnership(address newOwner) returns()
func (_Ownableibchandler *OwnableibchandlerTransactor) TransferOwnership(opts *bind.TransactOpts, newOwner common.Address) (*types.Transaction, error) {
	return _Ownableibchandler.contract.Transact(opts, "transferOwnership", newOwner)
}

// TransferOwnership is a paid mutator transaction binding the contract method 0xf2fde38b.
//
// Solidity: function transferOwnership(address newOwner) returns()
func (_Ownableibchandler *OwnableibchandlerSession) TransferOwnership(newOwner common.Address) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.TransferOwnership(&_Ownableibchandler.TransactOpts, newOwner)
}

// TransferOwnership is a paid mutator transaction binding the contract method 0xf2fde38b.
//
// Solidity: function transferOwnership(address newOwner) returns()
func (_Ownableibchandler *OwnableibchandlerTransactorSession) TransferOwnership(newOwner common.Address) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.TransferOwnership(&_Ownableibchandler.TransactOpts, newOwner)
}

// UpdateClient is a paid mutator transaction binding the contract method 0xda6cea55.
//
// Solidity: function updateClient((string,bytes) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerTransactor) UpdateClient(opts *bind.TransactOpts, msg_ IBCMsgsMsgUpdateClient) (*types.Transaction, error) {
	return _Ownableibchandler.contract.Transact(opts, "updateClient", msg_)
}

// UpdateClient is a paid mutator transaction binding the contract method 0xda6cea55.
//
// Solidity: function updateClient((string,bytes) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerSession) UpdateClient(msg_ IBCMsgsMsgUpdateClient) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.UpdateClient(&_Ownableibchandler.TransactOpts, msg_)
}

// UpdateClient is a paid mutator transaction binding the contract method 0xda6cea55.
//
// Solidity: function updateClient((string,bytes) msg_) returns()
func (_Ownableibchandler *OwnableibchandlerTransactorSession) UpdateClient(msg_ IBCMsgsMsgUpdateClient) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.UpdateClient(&_Ownableibchandler.TransactOpts, msg_)
}

// WriteAcknowledgement is a paid mutator transaction binding the contract method 0xb56e79de.
//
// Solidity: function writeAcknowledgement(string destinationPortId, string destinationChannel, uint64 sequence, bytes acknowledgement) returns()
func (_Ownableibchandler *OwnableibchandlerTransactor) WriteAcknowledgement(opts *bind.TransactOpts, destinationPortId string, destinationChannel string, sequence uint64, acknowledgement []byte) (*types.Transaction, error) {
	return _Ownableibchandler.contract.Transact(opts, "writeAcknowledgement", destinationPortId, destinationChannel, sequence, acknowledgement)
}

// WriteAcknowledgement is a paid mutator transaction binding the contract method 0xb56e79de.
//
// Solidity: function writeAcknowledgement(string destinationPortId, string destinationChannel, uint64 sequence, bytes acknowledgement) returns()
func (_Ownableibchandler *OwnableibchandlerSession) WriteAcknowledgement(destinationPortId string, destinationChannel string, sequence uint64, acknowledgement []byte) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.WriteAcknowledgement(&_Ownableibchandler.TransactOpts, destinationPortId, destinationChannel, sequence, acknowledgement)
}

// WriteAcknowledgement is a paid mutator transaction binding the contract method 0xb56e79de.
//
// Solidity: function writeAcknowledgement(string destinationPortId, string destinationChannel, uint64 sequence, bytes acknowledgement) returns()
func (_Ownableibchandler *OwnableibchandlerTransactorSession) WriteAcknowledgement(destinationPortId string, destinationChannel string, sequence uint64, acknowledgement []byte) (*types.Transaction, error) {
	return _Ownableibchandler.Contract.WriteAcknowledgement(&_Ownableibchandler.TransactOpts, destinationPortId, destinationChannel, sequence, acknowledgement)
}

// OwnableibchandlerAcknowledgePacketIterator is returned from FilterAcknowledgePacket and is used to iterate over the raw logs and unpacked data for AcknowledgePacket events raised by the Ownableibchandler contract.
type OwnableibchandlerAcknowledgePacketIterator struct {
	Event *OwnableibchandlerAcknowledgePacket // Event containing the contract specifics and raw log

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
func (it *OwnableibchandlerAcknowledgePacketIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(OwnableibchandlerAcknowledgePacket)
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
		it.Event = new(OwnableibchandlerAcknowledgePacket)
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
func (it *OwnableibchandlerAcknowledgePacketIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *OwnableibchandlerAcknowledgePacketIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// OwnableibchandlerAcknowledgePacket represents a AcknowledgePacket event raised by the Ownableibchandler contract.
type OwnableibchandlerAcknowledgePacket struct {
	Packet          PacketData
	Acknowledgement []byte
	Raw             types.Log // Blockchain specific contextual infos
}

// FilterAcknowledgePacket is a free log retrieval operation binding the contract event 0x47471450765e6e1b0b055ba2a1de04d4ce71f778c92b306e725083eb120dfd89.
//
// Solidity: event AcknowledgePacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet, bytes acknowledgement)
func (_Ownableibchandler *OwnableibchandlerFilterer) FilterAcknowledgePacket(opts *bind.FilterOpts) (*OwnableibchandlerAcknowledgePacketIterator, error) {

	logs, sub, err := _Ownableibchandler.contract.FilterLogs(opts, "AcknowledgePacket")
	if err != nil {
		return nil, err
	}
	return &OwnableibchandlerAcknowledgePacketIterator{contract: _Ownableibchandler.contract, event: "AcknowledgePacket", logs: logs, sub: sub}, nil
}

// WatchAcknowledgePacket is a free log subscription operation binding the contract event 0x47471450765e6e1b0b055ba2a1de04d4ce71f778c92b306e725083eb120dfd89.
//
// Solidity: event AcknowledgePacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet, bytes acknowledgement)
func (_Ownableibchandler *OwnableibchandlerFilterer) WatchAcknowledgePacket(opts *bind.WatchOpts, sink chan<- *OwnableibchandlerAcknowledgePacket) (event.Subscription, error) {

	logs, sub, err := _Ownableibchandler.contract.WatchLogs(opts, "AcknowledgePacket")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(OwnableibchandlerAcknowledgePacket)
				if err := _Ownableibchandler.contract.UnpackLog(event, "AcknowledgePacket", log); err != nil {
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

// ParseAcknowledgePacket is a log parse operation binding the contract event 0x47471450765e6e1b0b055ba2a1de04d4ce71f778c92b306e725083eb120dfd89.
//
// Solidity: event AcknowledgePacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet, bytes acknowledgement)
func (_Ownableibchandler *OwnableibchandlerFilterer) ParseAcknowledgePacket(log types.Log) (*OwnableibchandlerAcknowledgePacket, error) {
	event := new(OwnableibchandlerAcknowledgePacket)
	if err := _Ownableibchandler.contract.UnpackLog(event, "AcknowledgePacket", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// OwnableibchandlerGeneratedChannelIdentifierIterator is returned from FilterGeneratedChannelIdentifier and is used to iterate over the raw logs and unpacked data for GeneratedChannelIdentifier events raised by the Ownableibchandler contract.
type OwnableibchandlerGeneratedChannelIdentifierIterator struct {
	Event *OwnableibchandlerGeneratedChannelIdentifier // Event containing the contract specifics and raw log

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
func (it *OwnableibchandlerGeneratedChannelIdentifierIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(OwnableibchandlerGeneratedChannelIdentifier)
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
		it.Event = new(OwnableibchandlerGeneratedChannelIdentifier)
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
func (it *OwnableibchandlerGeneratedChannelIdentifierIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *OwnableibchandlerGeneratedChannelIdentifierIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// OwnableibchandlerGeneratedChannelIdentifier represents a GeneratedChannelIdentifier event raised by the Ownableibchandler contract.
type OwnableibchandlerGeneratedChannelIdentifier struct {
	Arg0 string
	Raw  types.Log // Blockchain specific contextual infos
}

// FilterGeneratedChannelIdentifier is a free log retrieval operation binding the contract event 0x01fb9b8778b6fb840b058bb971dea3ba81c167b010a0216afe600826884f9ba7.
//
// Solidity: event GeneratedChannelIdentifier(string arg0)
func (_Ownableibchandler *OwnableibchandlerFilterer) FilterGeneratedChannelIdentifier(opts *bind.FilterOpts) (*OwnableibchandlerGeneratedChannelIdentifierIterator, error) {

	logs, sub, err := _Ownableibchandler.contract.FilterLogs(opts, "GeneratedChannelIdentifier")
	if err != nil {
		return nil, err
	}
	return &OwnableibchandlerGeneratedChannelIdentifierIterator{contract: _Ownableibchandler.contract, event: "GeneratedChannelIdentifier", logs: logs, sub: sub}, nil
}

// WatchGeneratedChannelIdentifier is a free log subscription operation binding the contract event 0x01fb9b8778b6fb840b058bb971dea3ba81c167b010a0216afe600826884f9ba7.
//
// Solidity: event GeneratedChannelIdentifier(string arg0)
func (_Ownableibchandler *OwnableibchandlerFilterer) WatchGeneratedChannelIdentifier(opts *bind.WatchOpts, sink chan<- *OwnableibchandlerGeneratedChannelIdentifier) (event.Subscription, error) {

	logs, sub, err := _Ownableibchandler.contract.WatchLogs(opts, "GeneratedChannelIdentifier")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(OwnableibchandlerGeneratedChannelIdentifier)
				if err := _Ownableibchandler.contract.UnpackLog(event, "GeneratedChannelIdentifier", log); err != nil {
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

// ParseGeneratedChannelIdentifier is a log parse operation binding the contract event 0x01fb9b8778b6fb840b058bb971dea3ba81c167b010a0216afe600826884f9ba7.
//
// Solidity: event GeneratedChannelIdentifier(string arg0)
func (_Ownableibchandler *OwnableibchandlerFilterer) ParseGeneratedChannelIdentifier(log types.Log) (*OwnableibchandlerGeneratedChannelIdentifier, error) {
	event := new(OwnableibchandlerGeneratedChannelIdentifier)
	if err := _Ownableibchandler.contract.UnpackLog(event, "GeneratedChannelIdentifier", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// OwnableibchandlerGeneratedClientIdentifierIterator is returned from FilterGeneratedClientIdentifier and is used to iterate over the raw logs and unpacked data for GeneratedClientIdentifier events raised by the Ownableibchandler contract.
type OwnableibchandlerGeneratedClientIdentifierIterator struct {
	Event *OwnableibchandlerGeneratedClientIdentifier // Event containing the contract specifics and raw log

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
func (it *OwnableibchandlerGeneratedClientIdentifierIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(OwnableibchandlerGeneratedClientIdentifier)
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
		it.Event = new(OwnableibchandlerGeneratedClientIdentifier)
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
func (it *OwnableibchandlerGeneratedClientIdentifierIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *OwnableibchandlerGeneratedClientIdentifierIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// OwnableibchandlerGeneratedClientIdentifier represents a GeneratedClientIdentifier event raised by the Ownableibchandler contract.
type OwnableibchandlerGeneratedClientIdentifier struct {
	Arg0 string
	Raw  types.Log // Blockchain specific contextual infos
}

// FilterGeneratedClientIdentifier is a free log retrieval operation binding the contract event 0x601bfcc455d5d4d7738f8c6ac232e0d7cc9c31dab811f1d87c100af0b7fc3a20.
//
// Solidity: event GeneratedClientIdentifier(string arg0)
func (_Ownableibchandler *OwnableibchandlerFilterer) FilterGeneratedClientIdentifier(opts *bind.FilterOpts) (*OwnableibchandlerGeneratedClientIdentifierIterator, error) {

	logs, sub, err := _Ownableibchandler.contract.FilterLogs(opts, "GeneratedClientIdentifier")
	if err != nil {
		return nil, err
	}
	return &OwnableibchandlerGeneratedClientIdentifierIterator{contract: _Ownableibchandler.contract, event: "GeneratedClientIdentifier", logs: logs, sub: sub}, nil
}

// WatchGeneratedClientIdentifier is a free log subscription operation binding the contract event 0x601bfcc455d5d4d7738f8c6ac232e0d7cc9c31dab811f1d87c100af0b7fc3a20.
//
// Solidity: event GeneratedClientIdentifier(string arg0)
func (_Ownableibchandler *OwnableibchandlerFilterer) WatchGeneratedClientIdentifier(opts *bind.WatchOpts, sink chan<- *OwnableibchandlerGeneratedClientIdentifier) (event.Subscription, error) {

	logs, sub, err := _Ownableibchandler.contract.WatchLogs(opts, "GeneratedClientIdentifier")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(OwnableibchandlerGeneratedClientIdentifier)
				if err := _Ownableibchandler.contract.UnpackLog(event, "GeneratedClientIdentifier", log); err != nil {
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

// ParseGeneratedClientIdentifier is a log parse operation binding the contract event 0x601bfcc455d5d4d7738f8c6ac232e0d7cc9c31dab811f1d87c100af0b7fc3a20.
//
// Solidity: event GeneratedClientIdentifier(string arg0)
func (_Ownableibchandler *OwnableibchandlerFilterer) ParseGeneratedClientIdentifier(log types.Log) (*OwnableibchandlerGeneratedClientIdentifier, error) {
	event := new(OwnableibchandlerGeneratedClientIdentifier)
	if err := _Ownableibchandler.contract.UnpackLog(event, "GeneratedClientIdentifier", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// OwnableibchandlerGeneratedConnectionIdentifierIterator is returned from FilterGeneratedConnectionIdentifier and is used to iterate over the raw logs and unpacked data for GeneratedConnectionIdentifier events raised by the Ownableibchandler contract.
type OwnableibchandlerGeneratedConnectionIdentifierIterator struct {
	Event *OwnableibchandlerGeneratedConnectionIdentifier // Event containing the contract specifics and raw log

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
func (it *OwnableibchandlerGeneratedConnectionIdentifierIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(OwnableibchandlerGeneratedConnectionIdentifier)
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
		it.Event = new(OwnableibchandlerGeneratedConnectionIdentifier)
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
func (it *OwnableibchandlerGeneratedConnectionIdentifierIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *OwnableibchandlerGeneratedConnectionIdentifierIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// OwnableibchandlerGeneratedConnectionIdentifier represents a GeneratedConnectionIdentifier event raised by the Ownableibchandler contract.
type OwnableibchandlerGeneratedConnectionIdentifier struct {
	Arg0 string
	Raw  types.Log // Blockchain specific contextual infos
}

// FilterGeneratedConnectionIdentifier is a free log retrieval operation binding the contract event 0xbcf8ae1e9272e040280c9adfc8033bb831043a9959e37ef4af1f7e8ded16321b.
//
// Solidity: event GeneratedConnectionIdentifier(string arg0)
func (_Ownableibchandler *OwnableibchandlerFilterer) FilterGeneratedConnectionIdentifier(opts *bind.FilterOpts) (*OwnableibchandlerGeneratedConnectionIdentifierIterator, error) {

	logs, sub, err := _Ownableibchandler.contract.FilterLogs(opts, "GeneratedConnectionIdentifier")
	if err != nil {
		return nil, err
	}
	return &OwnableibchandlerGeneratedConnectionIdentifierIterator{contract: _Ownableibchandler.contract, event: "GeneratedConnectionIdentifier", logs: logs, sub: sub}, nil
}

// WatchGeneratedConnectionIdentifier is a free log subscription operation binding the contract event 0xbcf8ae1e9272e040280c9adfc8033bb831043a9959e37ef4af1f7e8ded16321b.
//
// Solidity: event GeneratedConnectionIdentifier(string arg0)
func (_Ownableibchandler *OwnableibchandlerFilterer) WatchGeneratedConnectionIdentifier(opts *bind.WatchOpts, sink chan<- *OwnableibchandlerGeneratedConnectionIdentifier) (event.Subscription, error) {

	logs, sub, err := _Ownableibchandler.contract.WatchLogs(opts, "GeneratedConnectionIdentifier")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(OwnableibchandlerGeneratedConnectionIdentifier)
				if err := _Ownableibchandler.contract.UnpackLog(event, "GeneratedConnectionIdentifier", log); err != nil {
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

// ParseGeneratedConnectionIdentifier is a log parse operation binding the contract event 0xbcf8ae1e9272e040280c9adfc8033bb831043a9959e37ef4af1f7e8ded16321b.
//
// Solidity: event GeneratedConnectionIdentifier(string arg0)
func (_Ownableibchandler *OwnableibchandlerFilterer) ParseGeneratedConnectionIdentifier(log types.Log) (*OwnableibchandlerGeneratedConnectionIdentifier, error) {
	event := new(OwnableibchandlerGeneratedConnectionIdentifier)
	if err := _Ownableibchandler.contract.UnpackLog(event, "GeneratedConnectionIdentifier", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// OwnableibchandlerOwnershipTransferredIterator is returned from FilterOwnershipTransferred and is used to iterate over the raw logs and unpacked data for OwnershipTransferred events raised by the Ownableibchandler contract.
type OwnableibchandlerOwnershipTransferredIterator struct {
	Event *OwnableibchandlerOwnershipTransferred // Event containing the contract specifics and raw log

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
func (it *OwnableibchandlerOwnershipTransferredIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(OwnableibchandlerOwnershipTransferred)
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
		it.Event = new(OwnableibchandlerOwnershipTransferred)
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
func (it *OwnableibchandlerOwnershipTransferredIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *OwnableibchandlerOwnershipTransferredIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// OwnableibchandlerOwnershipTransferred represents a OwnershipTransferred event raised by the Ownableibchandler contract.
type OwnableibchandlerOwnershipTransferred struct {
	PreviousOwner common.Address
	NewOwner      common.Address
	Raw           types.Log // Blockchain specific contextual infos
}

// FilterOwnershipTransferred is a free log retrieval operation binding the contract event 0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0.
//
// Solidity: event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)
func (_Ownableibchandler *OwnableibchandlerFilterer) FilterOwnershipTransferred(opts *bind.FilterOpts, previousOwner []common.Address, newOwner []common.Address) (*OwnableibchandlerOwnershipTransferredIterator, error) {

	var previousOwnerRule []interface{}
	for _, previousOwnerItem := range previousOwner {
		previousOwnerRule = append(previousOwnerRule, previousOwnerItem)
	}
	var newOwnerRule []interface{}
	for _, newOwnerItem := range newOwner {
		newOwnerRule = append(newOwnerRule, newOwnerItem)
	}

	logs, sub, err := _Ownableibchandler.contract.FilterLogs(opts, "OwnershipTransferred", previousOwnerRule, newOwnerRule)
	if err != nil {
		return nil, err
	}
	return &OwnableibchandlerOwnershipTransferredIterator{contract: _Ownableibchandler.contract, event: "OwnershipTransferred", logs: logs, sub: sub}, nil
}

// WatchOwnershipTransferred is a free log subscription operation binding the contract event 0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0.
//
// Solidity: event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)
func (_Ownableibchandler *OwnableibchandlerFilterer) WatchOwnershipTransferred(opts *bind.WatchOpts, sink chan<- *OwnableibchandlerOwnershipTransferred, previousOwner []common.Address, newOwner []common.Address) (event.Subscription, error) {

	var previousOwnerRule []interface{}
	for _, previousOwnerItem := range previousOwner {
		previousOwnerRule = append(previousOwnerRule, previousOwnerItem)
	}
	var newOwnerRule []interface{}
	for _, newOwnerItem := range newOwner {
		newOwnerRule = append(newOwnerRule, newOwnerItem)
	}

	logs, sub, err := _Ownableibchandler.contract.WatchLogs(opts, "OwnershipTransferred", previousOwnerRule, newOwnerRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(OwnableibchandlerOwnershipTransferred)
				if err := _Ownableibchandler.contract.UnpackLog(event, "OwnershipTransferred", log); err != nil {
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

// ParseOwnershipTransferred is a log parse operation binding the contract event 0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0.
//
// Solidity: event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)
func (_Ownableibchandler *OwnableibchandlerFilterer) ParseOwnershipTransferred(log types.Log) (*OwnableibchandlerOwnershipTransferred, error) {
	event := new(OwnableibchandlerOwnershipTransferred)
	if err := _Ownableibchandler.contract.UnpackLog(event, "OwnershipTransferred", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// OwnableibchandlerRecvPacketIterator is returned from FilterRecvPacket and is used to iterate over the raw logs and unpacked data for RecvPacket events raised by the Ownableibchandler contract.
type OwnableibchandlerRecvPacketIterator struct {
	Event *OwnableibchandlerRecvPacket // Event containing the contract specifics and raw log

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
func (it *OwnableibchandlerRecvPacketIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(OwnableibchandlerRecvPacket)
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
		it.Event = new(OwnableibchandlerRecvPacket)
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
func (it *OwnableibchandlerRecvPacketIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *OwnableibchandlerRecvPacketIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// OwnableibchandlerRecvPacket represents a RecvPacket event raised by the Ownableibchandler contract.
type OwnableibchandlerRecvPacket struct {
	Packet PacketData
	Raw    types.Log // Blockchain specific contextual infos
}

// FilterRecvPacket is a free log retrieval operation binding the contract event 0x346f4351ee865d86a679d00f3995f0520f803d3a227604af08430e26e9345a7a.
//
// Solidity: event RecvPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet)
func (_Ownableibchandler *OwnableibchandlerFilterer) FilterRecvPacket(opts *bind.FilterOpts) (*OwnableibchandlerRecvPacketIterator, error) {

	logs, sub, err := _Ownableibchandler.contract.FilterLogs(opts, "RecvPacket")
	if err != nil {
		return nil, err
	}
	return &OwnableibchandlerRecvPacketIterator{contract: _Ownableibchandler.contract, event: "RecvPacket", logs: logs, sub: sub}, nil
}

// WatchRecvPacket is a free log subscription operation binding the contract event 0x346f4351ee865d86a679d00f3995f0520f803d3a227604af08430e26e9345a7a.
//
// Solidity: event RecvPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet)
func (_Ownableibchandler *OwnableibchandlerFilterer) WatchRecvPacket(opts *bind.WatchOpts, sink chan<- *OwnableibchandlerRecvPacket) (event.Subscription, error) {

	logs, sub, err := _Ownableibchandler.contract.WatchLogs(opts, "RecvPacket")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(OwnableibchandlerRecvPacket)
				if err := _Ownableibchandler.contract.UnpackLog(event, "RecvPacket", log); err != nil {
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

// ParseRecvPacket is a log parse operation binding the contract event 0x346f4351ee865d86a679d00f3995f0520f803d3a227604af08430e26e9345a7a.
//
// Solidity: event RecvPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet)
func (_Ownableibchandler *OwnableibchandlerFilterer) ParseRecvPacket(log types.Log) (*OwnableibchandlerRecvPacket, error) {
	event := new(OwnableibchandlerRecvPacket)
	if err := _Ownableibchandler.contract.UnpackLog(event, "RecvPacket", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// OwnableibchandlerSendPacketIterator is returned from FilterSendPacket and is used to iterate over the raw logs and unpacked data for SendPacket events raised by the Ownableibchandler contract.
type OwnableibchandlerSendPacketIterator struct {
	Event *OwnableibchandlerSendPacket // Event containing the contract specifics and raw log

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
func (it *OwnableibchandlerSendPacketIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(OwnableibchandlerSendPacket)
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
		it.Event = new(OwnableibchandlerSendPacket)
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
func (it *OwnableibchandlerSendPacketIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *OwnableibchandlerSendPacketIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// OwnableibchandlerSendPacket represents a SendPacket event raised by the Ownableibchandler contract.
type OwnableibchandlerSendPacket struct {
	Packet PacketData
	Raw    types.Log // Blockchain specific contextual infos
}

// FilterSendPacket is a free log retrieval operation binding the contract event 0xe701f25bda8992b211749f81adb9a8ea6e8cf8a3c9f2e29ed496e6c5f059154c.
//
// Solidity: event SendPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet)
func (_Ownableibchandler *OwnableibchandlerFilterer) FilterSendPacket(opts *bind.FilterOpts) (*OwnableibchandlerSendPacketIterator, error) {

	logs, sub, err := _Ownableibchandler.contract.FilterLogs(opts, "SendPacket")
	if err != nil {
		return nil, err
	}
	return &OwnableibchandlerSendPacketIterator{contract: _Ownableibchandler.contract, event: "SendPacket", logs: logs, sub: sub}, nil
}

// WatchSendPacket is a free log subscription operation binding the contract event 0xe701f25bda8992b211749f81adb9a8ea6e8cf8a3c9f2e29ed496e6c5f059154c.
//
// Solidity: event SendPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet)
func (_Ownableibchandler *OwnableibchandlerFilterer) WatchSendPacket(opts *bind.WatchOpts, sink chan<- *OwnableibchandlerSendPacket) (event.Subscription, error) {

	logs, sub, err := _Ownableibchandler.contract.WatchLogs(opts, "SendPacket")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(OwnableibchandlerSendPacket)
				if err := _Ownableibchandler.contract.UnpackLog(event, "SendPacket", log); err != nil {
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

// ParseSendPacket is a log parse operation binding the contract event 0xe701f25bda8992b211749f81adb9a8ea6e8cf8a3c9f2e29ed496e6c5f059154c.
//
// Solidity: event SendPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet)
func (_Ownableibchandler *OwnableibchandlerFilterer) ParseSendPacket(log types.Log) (*OwnableibchandlerSendPacket, error) {
	event := new(OwnableibchandlerSendPacket)
	if err := _Ownableibchandler.contract.UnpackLog(event, "SendPacket", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// OwnableibchandlerWriteAcknowledgementIterator is returned from FilterWriteAcknowledgement and is used to iterate over the raw logs and unpacked data for WriteAcknowledgement events raised by the Ownableibchandler contract.
type OwnableibchandlerWriteAcknowledgementIterator struct {
	Event *OwnableibchandlerWriteAcknowledgement // Event containing the contract specifics and raw log

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
func (it *OwnableibchandlerWriteAcknowledgementIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(OwnableibchandlerWriteAcknowledgement)
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
		it.Event = new(OwnableibchandlerWriteAcknowledgement)
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
func (it *OwnableibchandlerWriteAcknowledgementIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *OwnableibchandlerWriteAcknowledgementIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// OwnableibchandlerWriteAcknowledgement represents a WriteAcknowledgement event raised by the Ownableibchandler contract.
type OwnableibchandlerWriteAcknowledgement struct {
	DestinationPortId  string
	DestinationChannel string
	Sequence           uint64
	Acknowledgement    []byte
	Raw                types.Log // Blockchain specific contextual infos
}

// FilterWriteAcknowledgement is a free log retrieval operation binding the contract event 0x39b14668930c816f244f4073c0fdf459d3dd73ae571b57b3efe8205919472d2a.
//
// Solidity: event WriteAcknowledgement(string destinationPortId, string destinationChannel, uint64 sequence, bytes acknowledgement)
func (_Ownableibchandler *OwnableibchandlerFilterer) FilterWriteAcknowledgement(opts *bind.FilterOpts) (*OwnableibchandlerWriteAcknowledgementIterator, error) {

	logs, sub, err := _Ownableibchandler.contract.FilterLogs(opts, "WriteAcknowledgement")
	if err != nil {
		return nil, err
	}
	return &OwnableibchandlerWriteAcknowledgementIterator{contract: _Ownableibchandler.contract, event: "WriteAcknowledgement", logs: logs, sub: sub}, nil
}

// WatchWriteAcknowledgement is a free log subscription operation binding the contract event 0x39b14668930c816f244f4073c0fdf459d3dd73ae571b57b3efe8205919472d2a.
//
// Solidity: event WriteAcknowledgement(string destinationPortId, string destinationChannel, uint64 sequence, bytes acknowledgement)
func (_Ownableibchandler *OwnableibchandlerFilterer) WatchWriteAcknowledgement(opts *bind.WatchOpts, sink chan<- *OwnableibchandlerWriteAcknowledgement) (event.Subscription, error) {

	logs, sub, err := _Ownableibchandler.contract.WatchLogs(opts, "WriteAcknowledgement")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(OwnableibchandlerWriteAcknowledgement)
				if err := _Ownableibchandler.contract.UnpackLog(event, "WriteAcknowledgement", log); err != nil {
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

// ParseWriteAcknowledgement is a log parse operation binding the contract event 0x39b14668930c816f244f4073c0fdf459d3dd73ae571b57b3efe8205919472d2a.
//
// Solidity: event WriteAcknowledgement(string destinationPortId, string destinationChannel, uint64 sequence, bytes acknowledgement)
func (_Ownableibchandler *OwnableibchandlerFilterer) ParseWriteAcknowledgement(log types.Log) (*OwnableibchandlerWriteAcknowledgement, error) {
	event := new(OwnableibchandlerWriteAcknowledgement)
	if err := _Ownableibchandler.contract.UnpackLog(event, "WriteAcknowledgement", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
