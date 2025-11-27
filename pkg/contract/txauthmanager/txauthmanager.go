// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package txauthmanager

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

// GoogleProtobufAnyData is an auto generated low-level Go binding around an user-defined struct.
type GoogleProtobufAnyData struct {
	TypeUrl string
	Value   []byte
}

// TxAuthStateData is an auto generated low-level Go binding around an user-defined struct.
type TxAuthStateData struct {
	RemainingSigners []AccountData
}

// TxauthmanagerMetaData contains all meta data concerning the Txauthmanager contract.
var TxauthmanagerMetaData = &bind.MetaData{
	ABI: "[{\"type\":\"constructor\",\"inputs\":[{\"name\":\"typeUrls\",\"type\":\"string[]\",\"internalType\":\"string[]\"},{\"name\":\"verifiers\",\"type\":\"address[]\",\"internalType\":\"contractIAuthExtensionVerifier[]\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"getAuthState\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"outputs\":[{\"name\":\"\",\"type\":\"tuple\",\"internalType\":\"structTxAuthState.Data\",\"components\":[{\"name\":\"remaining_signers\",\"type\":\"tuple[]\",\"internalType\":\"structAccount.Data[]\",\"components\":[{\"name\":\"id\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"auth_type\",\"type\":\"tuple\",\"internalType\":\"structAuthType.Data\",\"components\":[{\"name\":\"mode\",\"type\":\"uint8\",\"internalType\":\"enumAuthType.AuthMode\"},{\"name\":\"option\",\"type\":\"tuple\",\"internalType\":\"structGoogleProtobufAny.Data\",\"components\":[{\"name\":\"type_url\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]}]}]}]}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"initAuthState\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"signers\",\"type\":\"tuple[]\",\"internalType\":\"structAccount.Data[]\",\"components\":[{\"name\":\"id\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"auth_type\",\"type\":\"tuple\",\"internalType\":\"structAuthType.Data\",\"components\":[{\"name\":\"mode\",\"type\":\"uint8\",\"internalType\":\"enumAuthType.AuthMode\"},{\"name\":\"option\",\"type\":\"tuple\",\"internalType\":\"structGoogleProtobufAny.Data\",\"components\":[{\"name\":\"type_url\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]}]}]}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"isCompletedAuth\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"sign\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"signers\",\"type\":\"tuple[]\",\"internalType\":\"structAccount.Data[]\",\"components\":[{\"name\":\"id\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"auth_type\",\"type\":\"tuple\",\"internalType\":\"structAuthType.Data\",\"components\":[{\"name\":\"mode\",\"type\":\"uint8\",\"internalType\":\"enumAuthType.AuthMode\"},{\"name\":\"option\",\"type\":\"tuple\",\"internalType\":\"structGoogleProtobufAny.Data\",\"components\":[{\"name\":\"type_url\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]}]}]}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"verifySignatures\",\"inputs\":[{\"name\":\"txIDHash\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"signers\",\"type\":\"tuple[]\",\"internalType\":\"structAccount.Data[]\",\"components\":[{\"name\":\"id\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"auth_type\",\"type\":\"tuple\",\"internalType\":\"structAuthType.Data\",\"components\":[{\"name\":\"mode\",\"type\":\"uint8\",\"internalType\":\"enumAuthType.AuthMode\"},{\"name\":\"option\",\"type\":\"tuple\",\"internalType\":\"structGoogleProtobufAny.Data\",\"components\":[{\"name\":\"type_url\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]}]}]}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"error\",\"name\":\"AckIsNotSuccess\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"AllTransactionsConfirmed\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"ArrayLengthMismatch\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"AuthAlreadyCompleted\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"AuthModeMismatch\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"AuthStateAlreadyInitialized\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"ChannelNotFound\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"CoordinatorPhaseNotPrepare\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"CoordinatorStateInconsistent\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"CoordinatorStateNotFound\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"CoordinatorTxStatusNotPrepare\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"DelegateCallFailed\",\"inputs\":[{\"name\":\"target\",\"type\":\"address\",\"internalType\":\"address\"}]},{\"type\":\"error\",\"name\":\"EmptyTypeUrl\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"IDNotFound\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"InvalidSignersLength\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidTxIDLength\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"LinksNotSupported\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"MessageTimeoutHeight\",\"inputs\":[{\"name\":\"blockNumber\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"timeoutVersionHeight\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"type\":\"error\",\"name\":\"MessageTimeoutTimestamp\",\"inputs\":[{\"name\":\"blockTimestamp\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"timeoutTimestamp\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"type\":\"error\",\"name\":\"ModuleAlreadyInitialized\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"ModuleNotInitialized\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotImplemented\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"PayloadDecodeFailed\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"SignatureVerificationFailed\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"SignerCountMismatch\",\"inputs\":[{\"name\":\"signerCount\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"signatureCount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}]},{\"type\":\"error\",\"name\":\"SignerMustEqualSender\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"StaticCallFailed\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"TPCNotImplemented\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"TooManySigners\",\"inputs\":[{\"name\":\"got\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"maxAllowed\",\"type\":\"uint256\",\"internalType\":\"uint256\"}]},{\"type\":\"error\",\"name\":\"Tx0MustBeForSelfChain\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"TxAlreadyExists\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"TxAlreadyVerified\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"TxIDAlreadyExists\",\"inputs\":[{\"name\":\"txIDHash\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"UnauthorizedCaller\",\"inputs\":[{\"name\":\"caller\",\"type\":\"address\",\"internalType\":\"address\"}]},{\"type\":\"error\",\"name\":\"UnexpectedChainID\",\"inputs\":[{\"name\":\"expectedHash\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"gotHash\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"UnexpectedCommitStatus\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"UnexpectedReturnValue\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"UnexpectedSourceChannel\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"UnexpectedTypeURL\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"UnknownCommitProtocol\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"VerifierNotFound\",\"inputs\":[{\"name\":\"typeUrl\",\"type\":\"string\",\"internalType\":\"string\"}]},{\"type\":\"error\",\"name\":\"VerifierReturnedFalse\",\"inputs\":[{\"name\":\"txIDHash\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"typeUrl\",\"type\":\"string\",\"internalType\":\"string\"}]},{\"type\":\"error\",\"name\":\"ZeroAddressVerifier\",\"inputs\":[]}]",
}

// TxauthmanagerABI is the input ABI used to generate the binding from.
// Deprecated: Use TxauthmanagerMetaData.ABI instead.
var TxauthmanagerABI = TxauthmanagerMetaData.ABI

// Txauthmanager is an auto generated Go binding around an Ethereum contract.
type Txauthmanager struct {
	TxauthmanagerCaller     // Read-only binding to the contract
	TxauthmanagerTransactor // Write-only binding to the contract
	TxauthmanagerFilterer   // Log filterer for contract events
}

// TxauthmanagerCaller is an auto generated read-only Go binding around an Ethereum contract.
type TxauthmanagerCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// TxauthmanagerTransactor is an auto generated write-only Go binding around an Ethereum contract.
type TxauthmanagerTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// TxauthmanagerFilterer is an auto generated log filtering Go binding around an Ethereum contract events.
type TxauthmanagerFilterer struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// TxauthmanagerSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type TxauthmanagerSession struct {
	Contract     *Txauthmanager    // Generic contract binding to set the session for
	CallOpts     bind.CallOpts     // Call options to use throughout this session
	TransactOpts bind.TransactOpts // Transaction auth options to use throughout this session
}

// TxauthmanagerCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type TxauthmanagerCallerSession struct {
	Contract *TxauthmanagerCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts        // Call options to use throughout this session
}

// TxauthmanagerTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type TxauthmanagerTransactorSession struct {
	Contract     *TxauthmanagerTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts        // Transaction auth options to use throughout this session
}

// TxauthmanagerRaw is an auto generated low-level Go binding around an Ethereum contract.
type TxauthmanagerRaw struct {
	Contract *Txauthmanager // Generic contract binding to access the raw methods on
}

// TxauthmanagerCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type TxauthmanagerCallerRaw struct {
	Contract *TxauthmanagerCaller // Generic read-only contract binding to access the raw methods on
}

// TxauthmanagerTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type TxauthmanagerTransactorRaw struct {
	Contract *TxauthmanagerTransactor // Generic write-only contract binding to access the raw methods on
}

// NewTxauthmanager creates a new instance of Txauthmanager, bound to a specific deployed contract.
func NewTxauthmanager(address common.Address, backend bind.ContractBackend) (*Txauthmanager, error) {
	contract, err := bindTxauthmanager(address, backend, backend, backend)
	if err != nil {
		return nil, err
	}
	return &Txauthmanager{TxauthmanagerCaller: TxauthmanagerCaller{contract: contract}, TxauthmanagerTransactor: TxauthmanagerTransactor{contract: contract}, TxauthmanagerFilterer: TxauthmanagerFilterer{contract: contract}}, nil
}

// NewTxauthmanagerCaller creates a new read-only instance of Txauthmanager, bound to a specific deployed contract.
func NewTxauthmanagerCaller(address common.Address, caller bind.ContractCaller) (*TxauthmanagerCaller, error) {
	contract, err := bindTxauthmanager(address, caller, nil, nil)
	if err != nil {
		return nil, err
	}
	return &TxauthmanagerCaller{contract: contract}, nil
}

// NewTxauthmanagerTransactor creates a new write-only instance of Txauthmanager, bound to a specific deployed contract.
func NewTxauthmanagerTransactor(address common.Address, transactor bind.ContractTransactor) (*TxauthmanagerTransactor, error) {
	contract, err := bindTxauthmanager(address, nil, transactor, nil)
	if err != nil {
		return nil, err
	}
	return &TxauthmanagerTransactor{contract: contract}, nil
}

// NewTxauthmanagerFilterer creates a new log filterer instance of Txauthmanager, bound to a specific deployed contract.
func NewTxauthmanagerFilterer(address common.Address, filterer bind.ContractFilterer) (*TxauthmanagerFilterer, error) {
	contract, err := bindTxauthmanager(address, nil, nil, filterer)
	if err != nil {
		return nil, err
	}
	return &TxauthmanagerFilterer{contract: contract}, nil
}

// bindTxauthmanager binds a generic wrapper to an already deployed contract.
func bindTxauthmanager(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor, filterer bind.ContractFilterer) (*bind.BoundContract, error) {
	parsed, err := TxauthmanagerMetaData.GetAbi()
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, *parsed, caller, transactor, filterer), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Txauthmanager *TxauthmanagerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _Txauthmanager.Contract.TxauthmanagerCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Txauthmanager *TxauthmanagerRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Txauthmanager.Contract.TxauthmanagerTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Txauthmanager *TxauthmanagerRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Txauthmanager.Contract.TxauthmanagerTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_Txauthmanager *TxauthmanagerCallerRaw) Call(opts *bind.CallOpts, result *[]interface{}, method string, params ...interface{}) error {
	return _Txauthmanager.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_Txauthmanager *TxauthmanagerTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _Txauthmanager.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_Txauthmanager *TxauthmanagerTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _Txauthmanager.Contract.contract.Transact(opts, method, params...)
}

// GetAuthState is a free data retrieval call binding the contract method 0x28ea75ff.
//
// Solidity: function getAuthState(bytes32 txID) view returns(((bytes,(uint8,(string,bytes)))[]))
func (_Txauthmanager *TxauthmanagerCaller) GetAuthState(opts *bind.CallOpts, txID [32]byte) (TxAuthStateData, error) {
	var out []interface{}
	err := _Txauthmanager.contract.Call(opts, &out, "getAuthState", txID)

	if err != nil {
		return *new(TxAuthStateData), err
	}

	out0 := *abi.ConvertType(out[0], new(TxAuthStateData)).(*TxAuthStateData)

	return out0, err

}

// GetAuthState is a free data retrieval call binding the contract method 0x28ea75ff.
//
// Solidity: function getAuthState(bytes32 txID) view returns(((bytes,(uint8,(string,bytes)))[]))
func (_Txauthmanager *TxauthmanagerSession) GetAuthState(txID [32]byte) (TxAuthStateData, error) {
	return _Txauthmanager.Contract.GetAuthState(&_Txauthmanager.CallOpts, txID)
}

// GetAuthState is a free data retrieval call binding the contract method 0x28ea75ff.
//
// Solidity: function getAuthState(bytes32 txID) view returns(((bytes,(uint8,(string,bytes)))[]))
func (_Txauthmanager *TxauthmanagerCallerSession) GetAuthState(txID [32]byte) (TxAuthStateData, error) {
	return _Txauthmanager.Contract.GetAuthState(&_Txauthmanager.CallOpts, txID)
}

// IsCompletedAuth is a free data retrieval call binding the contract method 0xdbb8633e.
//
// Solidity: function isCompletedAuth(bytes32 txID) view returns(bool)
func (_Txauthmanager *TxauthmanagerCaller) IsCompletedAuth(opts *bind.CallOpts, txID [32]byte) (bool, error) {
	var out []interface{}
	err := _Txauthmanager.contract.Call(opts, &out, "isCompletedAuth", txID)

	if err != nil {
		return *new(bool), err
	}

	out0 := *abi.ConvertType(out[0], new(bool)).(*bool)

	return out0, err

}

// IsCompletedAuth is a free data retrieval call binding the contract method 0xdbb8633e.
//
// Solidity: function isCompletedAuth(bytes32 txID) view returns(bool)
func (_Txauthmanager *TxauthmanagerSession) IsCompletedAuth(txID [32]byte) (bool, error) {
	return _Txauthmanager.Contract.IsCompletedAuth(&_Txauthmanager.CallOpts, txID)
}

// IsCompletedAuth is a free data retrieval call binding the contract method 0xdbb8633e.
//
// Solidity: function isCompletedAuth(bytes32 txID) view returns(bool)
func (_Txauthmanager *TxauthmanagerCallerSession) IsCompletedAuth(txID [32]byte) (bool, error) {
	return _Txauthmanager.Contract.IsCompletedAuth(&_Txauthmanager.CallOpts, txID)
}

// InitAuthState is a paid mutator transaction binding the contract method 0x4f61fa8d.
//
// Solidity: function initAuthState(bytes32 txID, (bytes,(uint8,(string,bytes)))[] signers) returns()
func (_Txauthmanager *TxauthmanagerTransactor) InitAuthState(opts *bind.TransactOpts, txID [32]byte, signers []AccountData) (*types.Transaction, error) {
	return _Txauthmanager.contract.Transact(opts, "initAuthState", txID, signers)
}

// InitAuthState is a paid mutator transaction binding the contract method 0x4f61fa8d.
//
// Solidity: function initAuthState(bytes32 txID, (bytes,(uint8,(string,bytes)))[] signers) returns()
func (_Txauthmanager *TxauthmanagerSession) InitAuthState(txID [32]byte, signers []AccountData) (*types.Transaction, error) {
	return _Txauthmanager.Contract.InitAuthState(&_Txauthmanager.TransactOpts, txID, signers)
}

// InitAuthState is a paid mutator transaction binding the contract method 0x4f61fa8d.
//
// Solidity: function initAuthState(bytes32 txID, (bytes,(uint8,(string,bytes)))[] signers) returns()
func (_Txauthmanager *TxauthmanagerTransactorSession) InitAuthState(txID [32]byte, signers []AccountData) (*types.Transaction, error) {
	return _Txauthmanager.Contract.InitAuthState(&_Txauthmanager.TransactOpts, txID, signers)
}

// Sign is a paid mutator transaction binding the contract method 0xc4886a6d.
//
// Solidity: function sign(bytes32 txID, (bytes,(uint8,(string,bytes)))[] signers) returns(bool)
func (_Txauthmanager *TxauthmanagerTransactor) Sign(opts *bind.TransactOpts, txID [32]byte, signers []AccountData) (*types.Transaction, error) {
	return _Txauthmanager.contract.Transact(opts, "sign", txID, signers)
}

// Sign is a paid mutator transaction binding the contract method 0xc4886a6d.
//
// Solidity: function sign(bytes32 txID, (bytes,(uint8,(string,bytes)))[] signers) returns(bool)
func (_Txauthmanager *TxauthmanagerSession) Sign(txID [32]byte, signers []AccountData) (*types.Transaction, error) {
	return _Txauthmanager.Contract.Sign(&_Txauthmanager.TransactOpts, txID, signers)
}

// Sign is a paid mutator transaction binding the contract method 0xc4886a6d.
//
// Solidity: function sign(bytes32 txID, (bytes,(uint8,(string,bytes)))[] signers) returns(bool)
func (_Txauthmanager *TxauthmanagerTransactorSession) Sign(txID [32]byte, signers []AccountData) (*types.Transaction, error) {
	return _Txauthmanager.Contract.Sign(&_Txauthmanager.TransactOpts, txID, signers)
}

// VerifySignatures is a paid mutator transaction binding the contract method 0xf957441d.
//
// Solidity: function verifySignatures(bytes32 txIDHash, (bytes,(uint8,(string,bytes)))[] signers) returns()
func (_Txauthmanager *TxauthmanagerTransactor) VerifySignatures(opts *bind.TransactOpts, txIDHash [32]byte, signers []AccountData) (*types.Transaction, error) {
	return _Txauthmanager.contract.Transact(opts, "verifySignatures", txIDHash, signers)
}

// VerifySignatures is a paid mutator transaction binding the contract method 0xf957441d.
//
// Solidity: function verifySignatures(bytes32 txIDHash, (bytes,(uint8,(string,bytes)))[] signers) returns()
func (_Txauthmanager *TxauthmanagerSession) VerifySignatures(txIDHash [32]byte, signers []AccountData) (*types.Transaction, error) {
	return _Txauthmanager.Contract.VerifySignatures(&_Txauthmanager.TransactOpts, txIDHash, signers)
}

// VerifySignatures is a paid mutator transaction binding the contract method 0xf957441d.
//
// Solidity: function verifySignatures(bytes32 txIDHash, (bytes,(uint8,(string,bytes)))[] signers) returns()
func (_Txauthmanager *TxauthmanagerTransactorSession) VerifySignatures(txIDHash [32]byte, signers []AccountData) (*types.Transaction, error) {
	return _Txauthmanager.Contract.VerifySignatures(&_Txauthmanager.TransactOpts, txIDHash, signers)
}
