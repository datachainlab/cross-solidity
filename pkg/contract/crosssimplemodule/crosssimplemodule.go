// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package crosssimplemodule

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

// HeightData is an auto generated low-level Go binding around an user-defined struct.
type HeightData struct {
	RevisionNumber uint64
	RevisionHeight uint64
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

// CrosssimplemoduleABI is the input ABI used to generate the binding from.
const CrosssimplemoduleABI = "[{\"inputs\":[{\"internalType\":\"contractIBCHost\",\"name\":\"host_\",\"type\":\"address\"},{\"internalType\":\"contractIBCHandler\",\"name\":\"ibcHandler_\",\"type\":\"address\"}],\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"inputs\":[{\"components\":[{\"internalType\":\"uint64\",\"name\":\"sequence\",\"type\":\"uint64\"},{\"internalType\":\"string\",\"name\":\"source_port\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"source_channel\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"destination_port\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"destination_channel\",\"type\":\"string\"},{\"internalType\":\"bytes\",\"name\":\"data\",\"type\":\"bytes\"},{\"components\":[{\"internalType\":\"uint64\",\"name\":\"revision_number\",\"type\":\"uint64\"},{\"internalType\":\"uint64\",\"name\":\"revision_height\",\"type\":\"uint64\"}],\"internalType\":\"structHeight.Data\",\"name\":\"timeout_height\",\"type\":\"tuple\"},{\"internalType\":\"uint64\",\"name\":\"timeout_timestamp\",\"type\":\"uint64\"}],\"internalType\":\"structPacket.Data\",\"name\":\"packet\",\"type\":\"tuple\"},{\"internalType\":\"bytes\",\"name\":\"acknowledgement\",\"type\":\"bytes\"}],\"name\":\"onAcknowledgementPacket\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"string\",\"name\":\"portId\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"channelId\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"counterpartyVersion\",\"type\":\"string\"}],\"name\":\"onChanOpenAck\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"string\",\"name\":\"portId\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"channelId\",\"type\":\"string\"}],\"name\":\"onChanOpenConfirm\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"enumChannel.Order\",\"name\":\"\",\"type\":\"uint8\"},{\"internalType\":\"string[]\",\"name\":\"connectionHops\",\"type\":\"string[]\"},{\"internalType\":\"string\",\"name\":\"portId\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"channelId\",\"type\":\"string\"},{\"components\":[{\"internalType\":\"string\",\"name\":\"port_id\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"channel_id\",\"type\":\"string\"}],\"internalType\":\"structChannelCounterparty.Data\",\"name\":\"counterparty\",\"type\":\"tuple\"},{\"internalType\":\"string\",\"name\":\"version\",\"type\":\"string\"}],\"name\":\"onChanOpenInit\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"internalType\":\"enumChannel.Order\",\"name\":\"\",\"type\":\"uint8\"},{\"internalType\":\"string[]\",\"name\":\"connectionHops\",\"type\":\"string[]\"},{\"internalType\":\"string\",\"name\":\"portId\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"channelId\",\"type\":\"string\"},{\"components\":[{\"internalType\":\"string\",\"name\":\"port_id\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"channel_id\",\"type\":\"string\"}],\"internalType\":\"structChannelCounterparty.Data\",\"name\":\"counterparty\",\"type\":\"tuple\"},{\"internalType\":\"string\",\"name\":\"version\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"counterpartyVersion\",\"type\":\"string\"}],\"name\":\"onChanOpenTry\",\"outputs\":[],\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"components\":[{\"internalType\":\"uint64\",\"name\":\"sequence\",\"type\":\"uint64\"},{\"internalType\":\"string\",\"name\":\"source_port\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"source_channel\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"destination_port\",\"type\":\"string\"},{\"internalType\":\"string\",\"name\":\"destination_channel\",\"type\":\"string\"},{\"internalType\":\"bytes\",\"name\":\"data\",\"type\":\"bytes\"},{\"components\":[{\"internalType\":\"uint64\",\"name\":\"revision_number\",\"type\":\"uint64\"},{\"internalType\":\"uint64\",\"name\":\"revision_height\",\"type\":\"uint64\"}],\"internalType\":\"structHeight.Data\",\"name\":\"timeout_height\",\"type\":\"tuple\"},{\"internalType\":\"uint64\",\"name\":\"timeout_timestamp\",\"type\":\"uint64\"}],\"internalType\":\"structPacket.Data\",\"name\":\"packet\",\"type\":\"tuple\"}],\"name\":\"onRecvPacket\",\"outputs\":[{\"internalType\":\"bytes\",\"name\":\"acknowledgement\",\"type\":\"bytes\"}],\"stateMutability\":\"nonpayable\",\"type\":\"function\"}]"

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
	parsed, err := abi.JSON(strings.NewReader(CrosssimplemoduleABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor, filterer), nil
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

// OnAcknowledgementPacket is a paid mutator transaction binding the contract method 0xda7b08a7.
//
// Solidity: function onAcknowledgementPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet, bytes acknowledgement) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactor) OnAcknowledgementPacket(opts *bind.TransactOpts, packet PacketData, acknowledgement []byte) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "onAcknowledgementPacket", packet, acknowledgement)
}

// OnAcknowledgementPacket is a paid mutator transaction binding the contract method 0xda7b08a7.
//
// Solidity: function onAcknowledgementPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet, bytes acknowledgement) returns()
func (_Crosssimplemodule *CrosssimplemoduleSession) OnAcknowledgementPacket(packet PacketData, acknowledgement []byte) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnAcknowledgementPacket(&_Crosssimplemodule.TransactOpts, packet, acknowledgement)
}

// OnAcknowledgementPacket is a paid mutator transaction binding the contract method 0xda7b08a7.
//
// Solidity: function onAcknowledgementPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet, bytes acknowledgement) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) OnAcknowledgementPacket(packet PacketData, acknowledgement []byte) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnAcknowledgementPacket(&_Crosssimplemodule.TransactOpts, packet, acknowledgement)
}

// OnChanOpenAck is a paid mutator transaction binding the contract method 0x4942d1ac.
//
// Solidity: function onChanOpenAck(string portId, string channelId, string counterpartyVersion) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactor) OnChanOpenAck(opts *bind.TransactOpts, portId string, channelId string, counterpartyVersion string) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "onChanOpenAck", portId, channelId, counterpartyVersion)
}

// OnChanOpenAck is a paid mutator transaction binding the contract method 0x4942d1ac.
//
// Solidity: function onChanOpenAck(string portId, string channelId, string counterpartyVersion) returns()
func (_Crosssimplemodule *CrosssimplemoduleSession) OnChanOpenAck(portId string, channelId string, counterpartyVersion string) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnChanOpenAck(&_Crosssimplemodule.TransactOpts, portId, channelId, counterpartyVersion)
}

// OnChanOpenAck is a paid mutator transaction binding the contract method 0x4942d1ac.
//
// Solidity: function onChanOpenAck(string portId, string channelId, string counterpartyVersion) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) OnChanOpenAck(portId string, channelId string, counterpartyVersion string) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnChanOpenAck(&_Crosssimplemodule.TransactOpts, portId, channelId, counterpartyVersion)
}

// OnChanOpenConfirm is a paid mutator transaction binding the contract method 0xa113e411.
//
// Solidity: function onChanOpenConfirm(string portId, string channelId) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactor) OnChanOpenConfirm(opts *bind.TransactOpts, portId string, channelId string) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "onChanOpenConfirm", portId, channelId)
}

// OnChanOpenConfirm is a paid mutator transaction binding the contract method 0xa113e411.
//
// Solidity: function onChanOpenConfirm(string portId, string channelId) returns()
func (_Crosssimplemodule *CrosssimplemoduleSession) OnChanOpenConfirm(portId string, channelId string) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnChanOpenConfirm(&_Crosssimplemodule.TransactOpts, portId, channelId)
}

// OnChanOpenConfirm is a paid mutator transaction binding the contract method 0xa113e411.
//
// Solidity: function onChanOpenConfirm(string portId, string channelId) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) OnChanOpenConfirm(portId string, channelId string) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnChanOpenConfirm(&_Crosssimplemodule.TransactOpts, portId, channelId)
}

// OnChanOpenInit is a paid mutator transaction binding the contract method 0x44dd9638.
//
// Solidity: function onChanOpenInit(uint8 , string[] connectionHops, string portId, string channelId, (string,string) counterparty, string version) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactor) OnChanOpenInit(opts *bind.TransactOpts, arg0 uint8, connectionHops []string, portId string, channelId string, counterparty ChannelCounterpartyData, version string) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "onChanOpenInit", arg0, connectionHops, portId, channelId, counterparty, version)
}

// OnChanOpenInit is a paid mutator transaction binding the contract method 0x44dd9638.
//
// Solidity: function onChanOpenInit(uint8 , string[] connectionHops, string portId, string channelId, (string,string) counterparty, string version) returns()
func (_Crosssimplemodule *CrosssimplemoduleSession) OnChanOpenInit(arg0 uint8, connectionHops []string, portId string, channelId string, counterparty ChannelCounterpartyData, version string) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnChanOpenInit(&_Crosssimplemodule.TransactOpts, arg0, connectionHops, portId, channelId, counterparty, version)
}

// OnChanOpenInit is a paid mutator transaction binding the contract method 0x44dd9638.
//
// Solidity: function onChanOpenInit(uint8 , string[] connectionHops, string portId, string channelId, (string,string) counterparty, string version) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) OnChanOpenInit(arg0 uint8, connectionHops []string, portId string, channelId string, counterparty ChannelCounterpartyData, version string) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnChanOpenInit(&_Crosssimplemodule.TransactOpts, arg0, connectionHops, portId, channelId, counterparty, version)
}

// OnChanOpenTry is a paid mutator transaction binding the contract method 0x981389f2.
//
// Solidity: function onChanOpenTry(uint8 , string[] connectionHops, string portId, string channelId, (string,string) counterparty, string version, string counterpartyVersion) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactor) OnChanOpenTry(opts *bind.TransactOpts, arg0 uint8, connectionHops []string, portId string, channelId string, counterparty ChannelCounterpartyData, version string, counterpartyVersion string) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "onChanOpenTry", arg0, connectionHops, portId, channelId, counterparty, version, counterpartyVersion)
}

// OnChanOpenTry is a paid mutator transaction binding the contract method 0x981389f2.
//
// Solidity: function onChanOpenTry(uint8 , string[] connectionHops, string portId, string channelId, (string,string) counterparty, string version, string counterpartyVersion) returns()
func (_Crosssimplemodule *CrosssimplemoduleSession) OnChanOpenTry(arg0 uint8, connectionHops []string, portId string, channelId string, counterparty ChannelCounterpartyData, version string, counterpartyVersion string) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnChanOpenTry(&_Crosssimplemodule.TransactOpts, arg0, connectionHops, portId, channelId, counterparty, version, counterpartyVersion)
}

// OnChanOpenTry is a paid mutator transaction binding the contract method 0x981389f2.
//
// Solidity: function onChanOpenTry(uint8 , string[] connectionHops, string portId, string channelId, (string,string) counterparty, string version, string counterpartyVersion) returns()
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) OnChanOpenTry(arg0 uint8, connectionHops []string, portId string, channelId string, counterparty ChannelCounterpartyData, version string, counterpartyVersion string) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnChanOpenTry(&_Crosssimplemodule.TransactOpts, arg0, connectionHops, portId, channelId, counterparty, version, counterpartyVersion)
}

// OnRecvPacket is a paid mutator transaction binding the contract method 0x5550b656.
//
// Solidity: function onRecvPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet) returns(bytes acknowledgement)
func (_Crosssimplemodule *CrosssimplemoduleTransactor) OnRecvPacket(opts *bind.TransactOpts, packet PacketData) (*types.Transaction, error) {
	return _Crosssimplemodule.contract.Transact(opts, "onRecvPacket", packet)
}

// OnRecvPacket is a paid mutator transaction binding the contract method 0x5550b656.
//
// Solidity: function onRecvPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet) returns(bytes acknowledgement)
func (_Crosssimplemodule *CrosssimplemoduleSession) OnRecvPacket(packet PacketData) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnRecvPacket(&_Crosssimplemodule.TransactOpts, packet)
}

// OnRecvPacket is a paid mutator transaction binding the contract method 0x5550b656.
//
// Solidity: function onRecvPacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet) returns(bytes acknowledgement)
func (_Crosssimplemodule *CrosssimplemoduleTransactorSession) OnRecvPacket(packet PacketData) (*types.Transaction, error) {
	return _Crosssimplemodule.Contract.OnRecvPacket(&_Crosssimplemodule.TransactOpts, packet)
}
