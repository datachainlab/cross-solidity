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

// CrosssimplemoduleMetaData contains all meta data concerning the Crosssimplemodule contract.
var CrosssimplemoduleMetaData = &bind.MetaData{
	ABI: "[{\"type\":\"constructor\",\"inputs\":[{\"name\":\"ibcHandler_\",\"type\":\"address\",\"internalType\":\"contractIIBCHandler\"},{\"name\":\"module\",\"type\":\"address\",\"internalType\":\"contractIContractModule\"},{\"name\":\"debugMode\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"DEFAULT_ADMIN_ROLE\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"IBC_ROLE\",\"inputs\":[],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getPacketAcknowledgementCall\",\"inputs\":[{\"name\":\"status\",\"type\":\"uint8\",\"internalType\":\"enumPacketAcknowledgementCall.CommitStatus\"}],\"outputs\":[{\"name\":\"acknowledgement\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"stateMutability\":\"pure\"},{\"type\":\"function\",\"name\":\"getRoleAdmin\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"grantRole\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"hasRole\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"onAcknowledgementPacket\",\"inputs\":[{\"name\":\"packet\",\"type\":\"tuple\",\"internalType\":\"structPacket\",\"components\":[{\"name\":\"sequence\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"sourcePort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"sourceChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationPort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"data\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"timeoutHeight\",\"type\":\"tuple\",\"internalType\":\"structHeight.Data\",\"components\":[{\"name\":\"revision_number\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"revision_height\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"timeoutTimestamp\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"acknowledgement\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"onChanCloseConfirm\",\"inputs\":[{\"name\":\"\",\"type\":\"tuple\",\"internalType\":\"structIIBCModule.MsgOnChanCloseConfirm\",\"components\":[{\"name\":\"portId\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"channelId\",\"type\":\"string\",\"internalType\":\"string\"}]}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"onChanCloseInit\",\"inputs\":[{\"name\":\"\",\"type\":\"tuple\",\"internalType\":\"structIIBCModule.MsgOnChanCloseInit\",\"components\":[{\"name\":\"portId\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"channelId\",\"type\":\"string\",\"internalType\":\"string\"}]}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"onChanOpenAck\",\"inputs\":[{\"name\":\"\",\"type\":\"tuple\",\"internalType\":\"structIIBCModule.MsgOnChanOpenAck\",\"components\":[{\"name\":\"portId\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"channelId\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"counterpartyVersion\",\"type\":\"string\",\"internalType\":\"string\"}]}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"onChanOpenConfirm\",\"inputs\":[{\"name\":\"\",\"type\":\"tuple\",\"internalType\":\"structIIBCModule.MsgOnChanOpenConfirm\",\"components\":[{\"name\":\"portId\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"channelId\",\"type\":\"string\",\"internalType\":\"string\"}]}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"onChanOpenInit\",\"inputs\":[{\"name\":\"msg_\",\"type\":\"tuple\",\"internalType\":\"structIIBCModuleInitializer.MsgOnChanOpenInit\",\"components\":[{\"name\":\"order\",\"type\":\"uint8\",\"internalType\":\"enumChannel.Order\"},{\"name\":\"connectionHops\",\"type\":\"string[]\",\"internalType\":\"string[]\"},{\"name\":\"portId\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"channelId\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"counterparty\",\"type\":\"tuple\",\"internalType\":\"structChannelCounterparty.Data\",\"components\":[{\"name\":\"port_id\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"channel_id\",\"type\":\"string\",\"internalType\":\"string\"}]},{\"name\":\"version\",\"type\":\"string\",\"internalType\":\"string\"}]}],\"outputs\":[{\"name\":\"moduleAddr\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"version\",\"type\":\"string\",\"internalType\":\"string\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"onChanOpenTry\",\"inputs\":[{\"name\":\"msg_\",\"type\":\"tuple\",\"internalType\":\"structIIBCModuleInitializer.MsgOnChanOpenTry\",\"components\":[{\"name\":\"order\",\"type\":\"uint8\",\"internalType\":\"enumChannel.Order\"},{\"name\":\"connectionHops\",\"type\":\"string[]\",\"internalType\":\"string[]\"},{\"name\":\"portId\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"channelId\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"counterparty\",\"type\":\"tuple\",\"internalType\":\"structChannelCounterparty.Data\",\"components\":[{\"name\":\"port_id\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"channel_id\",\"type\":\"string\",\"internalType\":\"string\"}]},{\"name\":\"counterpartyVersion\",\"type\":\"string\",\"internalType\":\"string\"}]}],\"outputs\":[{\"name\":\"moduleAddr\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"version\",\"type\":\"string\",\"internalType\":\"string\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"onRecvPacket\",\"inputs\":[{\"name\":\"packet\",\"type\":\"tuple\",\"internalType\":\"structPacket\",\"components\":[{\"name\":\"sequence\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"sourcePort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"sourceChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationPort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"data\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"timeoutHeight\",\"type\":\"tuple\",\"internalType\":\"structHeight.Data\",\"components\":[{\"name\":\"revision_number\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"revision_height\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"timeoutTimestamp\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[{\"name\":\"acknowledgement\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"onTimeoutPacket\",\"inputs\":[{\"name\":\"packet\",\"type\":\"tuple\",\"internalType\":\"structPacket\",\"components\":[{\"name\":\"sequence\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"sourcePort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"sourceChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationPort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"data\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"timeoutHeight\",\"type\":\"tuple\",\"internalType\":\"structHeight.Data\",\"components\":[{\"name\":\"revision_number\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"revision_height\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"timeoutTimestamp\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"renounceRole\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"callerConfirmation\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"revokeRole\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"supportsInterface\",\"inputs\":[{\"name\":\"interfaceId\",\"type\":\"bytes4\",\"internalType\":\"bytes4\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"view\"},{\"type\":\"event\",\"name\":\"OnContractCall\",\"inputs\":[{\"name\":\"txId\",\"type\":\"bytes\",\"indexed\":true,\"internalType\":\"bytes\"},{\"name\":\"txIndex\",\"type\":\"uint8\",\"indexed\":true,\"internalType\":\"uint8\"},{\"name\":\"success\",\"type\":\"bool\",\"indexed\":true,\"internalType\":\"bool\"},{\"name\":\"ret\",\"type\":\"bytes\",\"indexed\":false,\"internalType\":\"bytes\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"RoleAdminChanged\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"},{\"name\":\"previousAdminRole\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"},{\"name\":\"newAdminRole\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"RoleGranted\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"sender\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"RoleRevoked\",\"inputs\":[{\"name\":\"role\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"},{\"name\":\"account\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"sender\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"error\",\"name\":\"AccessControlBadConfirmation\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"AccessControlUnauthorizedAccount\",\"inputs\":[{\"name\":\"account\",\"type\":\"address\",\"internalType\":\"address\"},{\"name\":\"neededRole\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"ModuleAlreadyInitialized\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"ModuleNotInitialized\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotImplemented\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"PayloadDecodeFailed\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"UnexpectedTypeURL\",\"inputs\":[]}]",
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

// GetPacketAcknowledgementCall is a free data retrieval call binding the contract method 0x34a30a65.
//
// Solidity: function getPacketAcknowledgementCall(uint8 status) pure returns(bytes acknowledgement)
func (_Crosssimplemodule *CrosssimplemoduleCaller) GetPacketAcknowledgementCall(opts *bind.CallOpts, status uint8) ([]byte, error) {
	var out []interface{}
	err := _Crosssimplemodule.contract.Call(opts, &out, "getPacketAcknowledgementCall", status)

	if err != nil {
		return *new([]byte), err
	}

	out0 := *abi.ConvertType(out[0], new([]byte)).(*[]byte)

	return out0, err

}

// GetPacketAcknowledgementCall is a free data retrieval call binding the contract method 0x34a30a65.
//
// Solidity: function getPacketAcknowledgementCall(uint8 status) pure returns(bytes acknowledgement)
func (_Crosssimplemodule *CrosssimplemoduleSession) GetPacketAcknowledgementCall(status uint8) ([]byte, error) {
	return _Crosssimplemodule.Contract.GetPacketAcknowledgementCall(&_Crosssimplemodule.CallOpts, status)
}

// GetPacketAcknowledgementCall is a free data retrieval call binding the contract method 0x34a30a65.
//
// Solidity: function getPacketAcknowledgementCall(uint8 status) pure returns(bytes acknowledgement)
func (_Crosssimplemodule *CrosssimplemoduleCallerSession) GetPacketAcknowledgementCall(status uint8) ([]byte, error) {
	return _Crosssimplemodule.Contract.GetPacketAcknowledgementCall(&_Crosssimplemodule.CallOpts, status)
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

// SupportsInterface is a free data retrieval call binding the contract method 0x01ffc9a7.
//
// Solidity: function supportsInterface(bytes4 interfaceId) view returns(bool)
func (_Crosssimplemodule *CrosssimplemoduleCaller) SupportsInterface(opts *bind.CallOpts, interfaceId [4]byte) (bool, error) {
	var out []interface{}
	err := _Crosssimplemodule.contract.Call(opts, &out, "supportsInterface", interfaceId)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// SupportsInterface is a free data retrieval call binding the contract method 0x01ffc9a7.
//
// Solidity: function supportsInterface(bytes4 interfaceId) view returns(bool)
func (_Crosssimplemodule *CrosssimplemoduleSession) SupportsInterface(interfaceId [4]byte) (bool, error) {
	return _Crosssimplemodule.Contract.SupportsInterface(&_Crosssimplemodule.CallOpts, interfaceId)
}

// SupportsInterface is a free data retrieval call binding the contract method 0x01ffc9a7.
//
// Solidity: function supportsInterface(bytes4 interfaceId) view returns(bool)
func (_Crosssimplemodule *CrosssimplemoduleCallerSession) SupportsInterface(interfaceId [4]byte) (bool, error) {
	return _Crosssimplemodule.Contract.SupportsInterface(&_Crosssimplemodule.CallOpts, interfaceId)
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

// CrosssimplemoduleOnContractCallIterator is returned from FilterOnContractCall and is used to iterate over the raw logs and unpacked data for OnContractCall events raised by the Crosssimplemodule contract.
type CrosssimplemoduleOnContractCallIterator struct {
	Event *CrosssimplemoduleOnContractCall // Event containing the contract specifics and raw log

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
func (it *CrosssimplemoduleOnContractCallIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(CrosssimplemoduleOnContractCall)
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
		it.Event = new(CrosssimplemoduleOnContractCall)
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
func (it *CrosssimplemoduleOnContractCallIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *CrosssimplemoduleOnContractCallIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// CrosssimplemoduleOnContractCall represents a OnContractCall event raised by the Crosssimplemodule contract.
type CrosssimplemoduleOnContractCall struct {
	TxId    common.Hash
	TxIndex uint8
	Success bool
	Ret     []byte
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterOnContractCall is a free log retrieval operation binding the contract event 0x3cf6800c9da1119c1bcca8a173f94e0cd281ab3fae5f1e09ebbb95a64092584f.
//
// Solidity: event OnContractCall(bytes indexed txId, uint8 indexed txIndex, bool indexed success, bytes ret)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) FilterOnContractCall(opts *bind.FilterOpts, txId [][]byte, txIndex []uint8, success []bool) (*CrosssimplemoduleOnContractCallIterator, error) {

	var txIdRule []interface{}
	for _, txIdItem := range txId {
		txIdRule = append(txIdRule, txIdItem)
	}
	var txIndexRule []interface{}
	for _, txIndexItem := range txIndex {
		txIndexRule = append(txIndexRule, txIndexItem)
	}
	var successRule []interface{}
	for _, successItem := range success {
		successRule = append(successRule, successItem)
	}

	logs, sub, err := _Crosssimplemodule.contract.FilterLogs(opts, "OnContractCall", txIdRule, txIndexRule, successRule)
	if err != nil {
		return nil, err
	}
	return &CrosssimplemoduleOnContractCallIterator{contract: _Crosssimplemodule.contract, event: "OnContractCall", logs: logs, sub: sub}, nil
}

// WatchOnContractCall is a free log subscription operation binding the contract event 0x3cf6800c9da1119c1bcca8a173f94e0cd281ab3fae5f1e09ebbb95a64092584f.
//
// Solidity: event OnContractCall(bytes indexed txId, uint8 indexed txIndex, bool indexed success, bytes ret)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) WatchOnContractCall(opts *bind.WatchOpts, sink chan<- *CrosssimplemoduleOnContractCall, txId [][]byte, txIndex []uint8, success []bool) (event.Subscription, error) {

	var txIdRule []interface{}
	for _, txIdItem := range txId {
		txIdRule = append(txIdRule, txIdItem)
	}
	var txIndexRule []interface{}
	for _, txIndexItem := range txIndex {
		txIndexRule = append(txIndexRule, txIndexItem)
	}
	var successRule []interface{}
	for _, successItem := range success {
		successRule = append(successRule, successItem)
	}

	logs, sub, err := _Crosssimplemodule.contract.WatchLogs(opts, "OnContractCall", txIdRule, txIndexRule, successRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(CrosssimplemoduleOnContractCall)
				if err := _Crosssimplemodule.contract.UnpackLog(event, "OnContractCall", log); err != nil {
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

// ParseOnContractCall is a log parse operation binding the contract event 0x3cf6800c9da1119c1bcca8a173f94e0cd281ab3fae5f1e09ebbb95a64092584f.
//
// Solidity: event OnContractCall(bytes indexed txId, uint8 indexed txIndex, bool indexed success, bytes ret)
func (_Crosssimplemodule *CrosssimplemoduleFilterer) ParseOnContractCall(log types.Log) (*CrosssimplemoduleOnContractCall, error) {
	event := new(CrosssimplemoduleOnContractCall)
	if err := _Crosssimplemodule.contract.UnpackLog(event, "OnContractCall", log); err != nil {
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
