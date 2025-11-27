// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package txmanager

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

// ContractTransactionData is an auto generated low-level Go binding around an user-defined struct.
type ContractTransactionData struct {
	CrossChainChannel GoogleProtobufAnyData
	Signers           []AccountData
	CallInfo          []byte
	ReturnValue       ReturnValueData
	Links             []LinkData
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

// IbcCoreClientV1HeightData is an auto generated low-level Go binding around an user-defined struct.
type IbcCoreClientV1HeightData struct {
	RevisionNumber uint64
	RevisionHeight uint64
}

// LinkData is an auto generated low-level Go binding around an user-defined struct.
type LinkData struct {
	SrcIndex uint32
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

// ReturnValueData is an auto generated low-level Go binding around an user-defined struct.
type ReturnValueData struct {
	Value []byte
}

// TxmanagerMetaData contains all meta data concerning the Txmanager contract.
var TxmanagerMetaData = &bind.MetaData{
	ABI: "[{\"type\":\"constructor\",\"inputs\":[{\"name\":\"handler_\",\"type\":\"address\",\"internalType\":\"contractIIBCHandler\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"createTx\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"src\",\"type\":\"tuple\",\"internalType\":\"structMsgInitiateTx.Data\",\"components\":[{\"name\":\"chain_id\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"nonce\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"commit_protocol\",\"type\":\"uint8\",\"internalType\":\"enumTx.CommitProtocol\"},{\"name\":\"contract_transactions\",\"type\":\"tuple[]\",\"internalType\":\"structContractTransaction.Data[]\",\"components\":[{\"name\":\"cross_chain_channel\",\"type\":\"tuple\",\"internalType\":\"structGoogleProtobufAny.Data\",\"components\":[{\"name\":\"type_url\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]},{\"name\":\"signers\",\"type\":\"tuple[]\",\"internalType\":\"structAccount.Data[]\",\"components\":[{\"name\":\"id\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"auth_type\",\"type\":\"tuple\",\"internalType\":\"structAuthType.Data\",\"components\":[{\"name\":\"mode\",\"type\":\"uint8\",\"internalType\":\"enumAuthType.AuthMode\"},{\"name\":\"option\",\"type\":\"tuple\",\"internalType\":\"structGoogleProtobufAny.Data\",\"components\":[{\"name\":\"type_url\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]}]}]},{\"name\":\"call_info\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"return_value\",\"type\":\"tuple\",\"internalType\":\"structReturnValue.Data\",\"components\":[{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]},{\"name\":\"links\",\"type\":\"tuple[]\",\"internalType\":\"structLink.Data[]\",\"components\":[{\"name\":\"src_index\",\"type\":\"uint32\",\"internalType\":\"uint32\"}]}]},{\"name\":\"signers\",\"type\":\"tuple[]\",\"internalType\":\"structAccount.Data[]\",\"components\":[{\"name\":\"id\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"auth_type\",\"type\":\"tuple\",\"internalType\":\"structAuthType.Data\",\"components\":[{\"name\":\"mode\",\"type\":\"uint8\",\"internalType\":\"enumAuthType.AuthMode\"},{\"name\":\"option\",\"type\":\"tuple\",\"internalType\":\"structGoogleProtobufAny.Data\",\"components\":[{\"name\":\"type_url\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]}]}]},{\"name\":\"timeout_height\",\"type\":\"tuple\",\"internalType\":\"structIbcCoreClientV1Height.Data\",\"components\":[{\"name\":\"revision_number\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"revision_height\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"timeout_timestamp\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"handleAcknowledgement\",\"inputs\":[{\"name\":\"packet\",\"type\":\"tuple\",\"internalType\":\"structPacket\",\"components\":[{\"name\":\"sequence\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"sourcePort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"sourceChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationPort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"data\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"timeoutHeight\",\"type\":\"tuple\",\"internalType\":\"structHeight.Data\",\"components\":[{\"name\":\"revision_number\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"revision_height\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"timeoutTimestamp\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"acknowledgement\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"handlePacket\",\"inputs\":[{\"name\":\"packet\",\"type\":\"tuple\",\"internalType\":\"structPacket\",\"components\":[{\"name\":\"sequence\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"sourcePort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"sourceChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationPort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"data\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"timeoutHeight\",\"type\":\"tuple\",\"internalType\":\"structHeight.Data\",\"components\":[{\"name\":\"revision_number\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"revision_height\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"timeoutTimestamp\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]}],\"outputs\":[{\"name\":\"acknowledgement\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"handleTimeout\",\"inputs\":[{\"name\":\"packet\",\"type\":\"tuple\",\"internalType\":\"structPacket\",\"components\":[{\"name\":\"sequence\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"sourcePort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"sourceChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationPort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"data\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"timeoutHeight\",\"type\":\"tuple\",\"internalType\":\"structHeight.Data\",\"components\":[{\"name\":\"revision_number\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"revision_height\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"timeoutTimestamp\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"isTxRecorded\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"runTxIfCompleted\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"event\",\"name\":\"OnContractCall\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes\",\"indexed\":true,\"internalType\":\"bytes\"},{\"name\":\"txIndex\",\"type\":\"uint8\",\"indexed\":true,\"internalType\":\"uint8\"},{\"name\":\"success\",\"type\":\"bool\",\"indexed\":true,\"internalType\":\"bool\"},{\"name\":\"ret\",\"type\":\"bytes\",\"indexed\":false,\"internalType\":\"bytes\"}],\"anonymous\":false},{\"type\":\"error\",\"name\":\"AckIsNotSuccess\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"AllTransactionsConfirmed\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"ArrayLengthMismatch\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"AuthAlreadyCompleted\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"AuthModeMismatch\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"AuthStateAlreadyInitialized\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"ChannelNotFound\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"CoordinatorPhaseNotPrepare\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"CoordinatorStateInconsistent\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"CoordinatorStateNotFound\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"CoordinatorTxStatusNotPrepare\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"DelegateCallFailed\",\"inputs\":[{\"name\":\"target\",\"type\":\"address\",\"internalType\":\"address\"}]},{\"type\":\"error\",\"name\":\"EmptyTypeUrl\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"IDNotFound\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"InvalidSignersLength\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidTxIDLength\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"LinksNotSupported\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"MessageTimeoutHeight\",\"inputs\":[{\"name\":\"blockNumber\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"timeoutVersionHeight\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"type\":\"error\",\"name\":\"MessageTimeoutTimestamp\",\"inputs\":[{\"name\":\"blockTimestamp\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"timeoutTimestamp\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"type\":\"error\",\"name\":\"ModuleAlreadyInitialized\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"ModuleNotInitialized\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotImplemented\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"PayloadDecodeFailed\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"SignatureVerificationFailed\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"SignerCountMismatch\",\"inputs\":[{\"name\":\"signerCount\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"signatureCount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}]},{\"type\":\"error\",\"name\":\"SignerMustEqualSender\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"StaticCallFailed\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"TPCNotImplemented\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"TooManySigners\",\"inputs\":[{\"name\":\"got\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"maxAllowed\",\"type\":\"uint256\",\"internalType\":\"uint256\"}]},{\"type\":\"error\",\"name\":\"Tx0MustBeForSelfChain\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"TxAlreadyExists\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"TxAlreadyVerified\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"TxIDAlreadyExists\",\"inputs\":[{\"name\":\"txIDHash\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"UnauthorizedCaller\",\"inputs\":[{\"name\":\"caller\",\"type\":\"address\",\"internalType\":\"address\"}]},{\"type\":\"error\",\"name\":\"UnexpectedChainID\",\"inputs\":[{\"name\":\"expectedHash\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"gotHash\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"UnexpectedCommitStatus\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"UnexpectedReturnValue\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"UnexpectedSourceChannel\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"UnexpectedTypeURL\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"UnknownCommitProtocol\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"VerifierNotFound\",\"inputs\":[{\"name\":\"typeUrl\",\"type\":\"string\",\"internalType\":\"string\"}]},{\"type\":\"error\",\"name\":\"VerifierReturnedFalse\",\"inputs\":[{\"name\":\"txIDHash\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"typeUrl\",\"type\":\"string\",\"internalType\":\"string\"}]},{\"type\":\"error\",\"name\":\"ZeroAddressVerifier\",\"inputs\":[]}]",
}

// TxmanagerABI is the input ABI used to generate the binding from.
// Deprecated: Use TxmanagerMetaData.ABI instead.
var TxmanagerABI = TxmanagerMetaData.ABI

// Txmanager is an auto generated Go binding around an Ethereum contract.
type Txmanager struct {
	TxmanagerCaller     // Read-only binding to the contract
	TxmanagerTransactor // Write-only binding to the contract
	TxmanagerFilterer   // Log filterer for contract events
}

// TxmanagerCaller is an auto generated read-only Go binding around an Ethereum contract.
type TxmanagerCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// TxmanagerTransactor is an auto generated write-only Go binding around an Ethereum contract.
type TxmanagerTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// TxmanagerFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type TxmanagerFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// TxmanagerSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type TxmanagerSession struct {
	Contract     *Txmanager        // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// TxmanagerCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type TxmanagerCallerSession struct {
	Contract *TxmanagerCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts    // Call options to use throughout this session
}

// TxmanagerTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type TxmanagerTransactorSession struct {
	Contract     *TxmanagerTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts    // Transaction auth options to use throughout this session
}

// TxmanagerRaw is an auto generated low-level Go binding around an Ethereum contract.
type TxmanagerRaw struct {
	Contract *Txmanager // Generic contract binding to access the raw methods on
}

// TxmanagerCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type TxmanagerCallerRaw struct {
	Contract *TxmanagerCaller // Generic read-only contract binding to access the raw methods on
}

// TxmanagerTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type TxmanagerTransactorRaw struct {
	Contract *TxmanagerTransactor // Generic write-only contract binding to access the raw methods on
}

// NewTxmanager creates a new instance of Txmanager, bound to a specific deployed contract.
func NewTxmanager(address common.Address, backend bind.ContractBackend) (*Txmanager, error) {
	contract, err := bindTxmanager(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &Txmanager{TxmanagerCaller: TxmanagerCaller{contract: contract}, TxmanagerTransactor: TxmanagerTransactor{contract: contract}, TxmanagerFilterer: TxmanagerFilterer{contract: contract}}, nil
}

// NewTxmanagerCaller creates a new read-only instance of Txmanager, bound to a specific deployed contract.
func NewTxmanagerCaller(address common.Address, caller bind.ContractCaller) (*TxmanagerCaller, error) {
	contract, err := bindTxmanager(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &TxmanagerCaller{contract: contract}, nil
}

// NewTxmanagerTransactor creates a new write-only instance of Txmanager, bound to a specific deployed contract.
func NewTxmanagerTransactor(address common.Address, transactor bind.ContractTransactor) (*TxmanagerTransactor, error) {
	contract, err := bindTxmanager(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &TxmanagerTransactor{contract: contract}, nil
}

// NewTxmanagerFilterer creates a new log filterer instance of Txmanager, bound to a specific deployed contract.
func NewTxmanagerFilterer(address common.Address, filterer bind.ContractFilterer) (*TxmanagerFilterer, error) {
	contract, err := bindTxmanager(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &TxmanagerFilterer{contract: contract}, nil
}

// bindTxmanager binds a generic wrapper to an already deployed contract.
func bindTxmanager(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := TxmanagerMetaData.GetAbi()
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, *parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Txmanager *TxmanagerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _Txmanager.Contract.TxmanagerCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Txmanager *TxmanagerRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Txmanager.Contract.TxmanagerTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Txmanager *TxmanagerRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Txmanager.Contract.TxmanagerTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Txmanager *TxmanagerCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _Txmanager.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Txmanager *TxmanagerTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Txmanager.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Txmanager *TxmanagerTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Txmanager.Contract.contract.Transact(opts, method, params...)
}

// IsTxRecorded is a free data retrieval call binding the contract method 0x3ef6868c.
//
// Solidity: function isTxRecorded(bytes32 txID) view returns(bool)
func (_Txmanager *TxmanagerCaller) IsTxRecorded(opts *bind.CallOpts, txID [32]byte) (bool, error) {
	var out []interface{}
	err := _Txmanager.contract.Call(opts, &out, "isTxRecorded", txID)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// IsTxRecorded is a free data retrieval call binding the contract method 0x3ef6868c.
//
// Solidity: function isTxRecorded(bytes32 txID) view returns(bool)
func (_Txmanager *TxmanagerSession) IsTxRecorded(txID [32]byte) (bool, error) {
	return _Txmanager.Contract.IsTxRecorded(&_Txmanager.CallOpts, txID)
}

// IsTxRecorded is a free data retrieval call binding the contract method 0x3ef6868c.
//
// Solidity: function isTxRecorded(bytes32 txID) view returns(bool)
func (_Txmanager *TxmanagerCallerSession) IsTxRecorded(txID [32]byte) (bool, error) {
	return _Txmanager.Contract.IsTxRecorded(&_Txmanager.CallOpts, txID)
}

// CreateTx is a paid mutator transaction binding the contract method 0x354b898f.
//
// Solidity: function createTx(bytes32 txID, (string,uint64,uint8,((string,bytes),(bytes,(uint8,(string,bytes)))[],bytes,(bytes),(uint32)[])[],(bytes,(uint8,(string,bytes)))[],(uint64,uint64),uint64) src) returns()
func (_Txmanager *TxmanagerTransactor) CreateTx(opts *bind.TransactOpts, txID [32]byte, src MsgInitiateTxData) (*types.Transaction, error) {
	return _Txmanager.contract.Transact(opts, "createTx", txID, src)
}

// CreateTx is a paid mutator transaction binding the contract method 0x354b898f.
//
// Solidity: function createTx(bytes32 txID, (string,uint64,uint8,((string,bytes),(bytes,(uint8,(string,bytes)))[],bytes,(bytes),(uint32)[])[],(bytes,(uint8,(string,bytes)))[],(uint64,uint64),uint64) src) returns()
func (_Txmanager *TxmanagerSession) CreateTx(txID [32]byte, src MsgInitiateTxData) (*types.Transaction, error) {
	return _Txmanager.Contract.CreateTx(&_Txmanager.TransactOpts, txID, src)
}

// CreateTx is a paid mutator transaction binding the contract method 0x354b898f.
//
// Solidity: function createTx(bytes32 txID, (string,uint64,uint8,((string,bytes),(bytes,(uint8,(string,bytes)))[],bytes,(bytes),(uint32)[])[],(bytes,(uint8,(string,bytes)))[],(uint64,uint64),uint64) src) returns()
func (_Txmanager *TxmanagerTransactorSession) CreateTx(txID [32]byte, src MsgInitiateTxData) (*types.Transaction, error) {
	return _Txmanager.Contract.CreateTx(&_Txmanager.TransactOpts, txID, src)
}

// HandleAcknowledgement is a paid mutator transaction binding the contract method 0x5c935c3e.
//
// Solidity: function handleAcknowledgement((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet, bytes acknowledgement) returns()
func (_Txmanager *TxmanagerTransactor) HandleAcknowledgement(opts *bind.TransactOpts, packet Packet, acknowledgement []byte) (*types.Transaction, error) {
	return _Txmanager.contract.Transact(opts, "handleAcknowledgement", packet, acknowledgement)
}

// HandleAcknowledgement is a paid mutator transaction binding the contract method 0x5c935c3e.
//
// Solidity: function handleAcknowledgement((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet, bytes acknowledgement) returns()
func (_Txmanager *TxmanagerSession) HandleAcknowledgement(packet Packet, acknowledgement []byte) (*types.Transaction, error) {
	return _Txmanager.Contract.HandleAcknowledgement(&_Txmanager.TransactOpts, packet, acknowledgement)
}

// HandleAcknowledgement is a paid mutator transaction binding the contract method 0x5c935c3e.
//
// Solidity: function handleAcknowledgement((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet, bytes acknowledgement) returns()
func (_Txmanager *TxmanagerTransactorSession) HandleAcknowledgement(packet Packet, acknowledgement []byte) (*types.Transaction, error) {
	return _Txmanager.Contract.HandleAcknowledgement(&_Txmanager.TransactOpts, packet, acknowledgement)
}

// HandlePacket is a paid mutator transaction binding the contract method 0xd4c1f976.
//
// Solidity: function handlePacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet) returns(bytes acknowledgement)
func (_Txmanager *TxmanagerTransactor) HandlePacket(opts *bind.TransactOpts, packet Packet) (*types.Transaction, error) {
	return _Txmanager.contract.Transact(opts, "handlePacket", packet)
}

// HandlePacket is a paid mutator transaction binding the contract method 0xd4c1f976.
//
// Solidity: function handlePacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet) returns(bytes acknowledgement)
func (_Txmanager *TxmanagerSession) HandlePacket(packet Packet) (*types.Transaction, error) {
	return _Txmanager.Contract.HandlePacket(&_Txmanager.TransactOpts, packet)
}

// HandlePacket is a paid mutator transaction binding the contract method 0xd4c1f976.
//
// Solidity: function handlePacket((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet) returns(bytes acknowledgement)
func (_Txmanager *TxmanagerTransactorSession) HandlePacket(packet Packet) (*types.Transaction, error) {
	return _Txmanager.Contract.HandlePacket(&_Txmanager.TransactOpts, packet)
}

// HandleTimeout is a paid mutator transaction binding the contract method 0x07ce99d7.
//
// Solidity: function handleTimeout((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet) returns()
func (_Txmanager *TxmanagerTransactor) HandleTimeout(opts *bind.TransactOpts, packet Packet) (*types.Transaction, error) {
	return _Txmanager.contract.Transact(opts, "handleTimeout", packet)
}

// HandleTimeout is a paid mutator transaction binding the contract method 0x07ce99d7.
//
// Solidity: function handleTimeout((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet) returns()
func (_Txmanager *TxmanagerSession) HandleTimeout(packet Packet) (*types.Transaction, error) {
	return _Txmanager.Contract.HandleTimeout(&_Txmanager.TransactOpts, packet)
}

// HandleTimeout is a paid mutator transaction binding the contract method 0x07ce99d7.
//
// Solidity: function handleTimeout((uint64,string,string,string,string,bytes,(uint64,uint64),uint64) packet) returns()
func (_Txmanager *TxmanagerTransactorSession) HandleTimeout(packet Packet) (*types.Transaction, error) {
	return _Txmanager.Contract.HandleTimeout(&_Txmanager.TransactOpts, packet)
}

// RunTxIfCompleted is a paid mutator transaction binding the contract method 0xc79e0291.
//
// Solidity: function runTxIfCompleted(bytes32 txID) returns()
func (_Txmanager *TxmanagerTransactor) RunTxIfCompleted(opts *bind.TransactOpts, txID [32]byte) (*types.Transaction, error) {
	return _Txmanager.contract.Transact(opts, "runTxIfCompleted", txID)
}

// RunTxIfCompleted is a paid mutator transaction binding the contract method 0xc79e0291.
//
// Solidity: function runTxIfCompleted(bytes32 txID) returns()
func (_Txmanager *TxmanagerSession) RunTxIfCompleted(txID [32]byte) (*types.Transaction, error) {
	return _Txmanager.Contract.RunTxIfCompleted(&_Txmanager.TransactOpts, txID)
}

// RunTxIfCompleted is a paid mutator transaction binding the contract method 0xc79e0291.
//
// Solidity: function runTxIfCompleted(bytes32 txID) returns()
func (_Txmanager *TxmanagerTransactorSession) RunTxIfCompleted(txID [32]byte) (*types.Transaction, error) {
	return _Txmanager.Contract.RunTxIfCompleted(&_Txmanager.TransactOpts, txID)
}

// TxmanagerOnContractCallIterator is returned from FilterOnContractCall and is used to iterate over the raw logs and unpacked data for OnContractCall events raised by the Txmanager contract.
type TxmanagerOnContractCallIterator struct {
	Event *TxmanagerOnContractCall // Event containing the contract specifics and raw log

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
func (it *TxmanagerOnContractCallIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(TxmanagerOnContractCall)
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
		it.Event = new(TxmanagerOnContractCall)
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
func (it *TxmanagerOnContractCallIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *TxmanagerOnContractCallIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// TxmanagerOnContractCall represents a OnContractCall event raised by the Txmanager contract.
type TxmanagerOnContractCall struct {
	TxID    common.Hash
	TxIndex uint8
	Success bool
	Ret     []byte
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterOnContractCall is a free log retrieval operation binding the contract event 0x3cf6800c9da1119c1bcca8a173f94e0cd281ab3fae5f1e09ebbb95a64092584f.
//
// Solidity: event OnContractCall(bytes indexed txID, uint8 indexed txIndex, bool indexed success, bytes ret)
func (_Txmanager *TxmanagerFilterer) FilterOnContractCall(opts *bind.FilterOpts, txID [][]byte, txIndex []uint8, success []bool) (*TxmanagerOnContractCallIterator, error) {

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

	logs, sub, err := _Txmanager.contract.FilterLogs(opts, "OnContractCall", txIDRule, txIndexRule, successRule)
	if err != nil {
		return nil, err
	}
	return &TxmanagerOnContractCallIterator{contract: _Txmanager.contract, event: "OnContractCall", logs: logs, sub: sub}, nil
}

// WatchOnContractCall is a free log subscription operation binding the contract event 0x3cf6800c9da1119c1bcca8a173f94e0cd281ab3fae5f1e09ebbb95a64092584f.
//
// Solidity: event OnContractCall(bytes indexed txID, uint8 indexed txIndex, bool indexed success, bytes ret)
func (_Txmanager *TxmanagerFilterer) WatchOnContractCall(opts *bind.WatchOpts, sink chan<- *TxmanagerOnContractCall, txID [][]byte, txIndex []uint8, success []bool) (event.Subscription, error) {

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

	logs, sub, err := _Txmanager.contract.WatchLogs(opts, "OnContractCall", txIDRule, txIndexRule, successRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(TxmanagerOnContractCall)
				if err := _Txmanager.contract.UnpackLog(event, "OnContractCall", log); err != nil {
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
// Solidity: event OnContractCall(bytes indexed txID, uint8 indexed txIndex, bool indexed success, bytes ret)
func (_Txmanager *TxmanagerFilterer) ParseOnContractCall(log types.Log) (*TxmanagerOnContractCall, error) {
	event := new(TxmanagerOnContractCall)
	if err := _Txmanager.contract.UnpackLog(event, "OnContractCall", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
