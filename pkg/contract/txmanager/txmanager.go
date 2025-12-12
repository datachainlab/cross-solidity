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
	ABI: "[{\"type\":\"function\",\"name\":\"createTx\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"src\",\"type\":\"tuple\",\"internalType\":\"structMsgInitiateTx.Data\",\"components\":[{\"name\":\"chain_id\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"nonce\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"commit_protocol\",\"type\":\"uint8\",\"internalType\":\"enumTx.CommitProtocol\"},{\"name\":\"contract_transactions\",\"type\":\"tuple[]\",\"internalType\":\"structContractTransaction.Data[]\",\"components\":[{\"name\":\"cross_chain_channel\",\"type\":\"tuple\",\"internalType\":\"structGoogleProtobufAny.Data\",\"components\":[{\"name\":\"type_url\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]},{\"name\":\"signers\",\"type\":\"tuple[]\",\"internalType\":\"structAccount.Data[]\",\"components\":[{\"name\":\"id\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"auth_type\",\"type\":\"tuple\",\"internalType\":\"structAuthType.Data\",\"components\":[{\"name\":\"mode\",\"type\":\"uint8\",\"internalType\":\"enumAuthType.AuthMode\"},{\"name\":\"option\",\"type\":\"tuple\",\"internalType\":\"structGoogleProtobufAny.Data\",\"components\":[{\"name\":\"type_url\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]}]}]},{\"name\":\"call_info\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"return_value\",\"type\":\"tuple\",\"internalType\":\"structReturnValue.Data\",\"components\":[{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]},{\"name\":\"links\",\"type\":\"tuple[]\",\"internalType\":\"structLink.Data[]\",\"components\":[{\"name\":\"src_index\",\"type\":\"uint32\",\"internalType\":\"uint32\"}]}]},{\"name\":\"signers\",\"type\":\"tuple[]\",\"internalType\":\"structAccount.Data[]\",\"components\":[{\"name\":\"id\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"auth_type\",\"type\":\"tuple\",\"internalType\":\"structAuthType.Data\",\"components\":[{\"name\":\"mode\",\"type\":\"uint8\",\"internalType\":\"enumAuthType.AuthMode\"},{\"name\":\"option\",\"type\":\"tuple\",\"internalType\":\"structGoogleProtobufAny.Data\",\"components\":[{\"name\":\"type_url\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"value\",\"type\":\"bytes\",\"internalType\":\"bytes\"}]}]}]},{\"name\":\"timeout_height\",\"type\":\"tuple\",\"internalType\":\"structIbcCoreClientV1Height.Data\",\"components\":[{\"name\":\"revision_number\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"revision_height\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"timeout_timestamp\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"getCoordinatorState\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"outputs\":[{\"name\":\"\",\"type\":\"tuple\",\"internalType\":\"structCoordinatorState.Data\",\"components\":[{\"name\":\"commit_protocol\",\"type\":\"uint8\",\"internalType\":\"enumTx.CommitProtocol\"},{\"name\":\"channels\",\"type\":\"tuple[]\",\"internalType\":\"structChannelInfo.Data[]\",\"components\":[{\"name\":\"port\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"channel\",\"type\":\"string\",\"internalType\":\"string\"}]},{\"name\":\"phase\",\"type\":\"uint8\",\"internalType\":\"enumCoordinatorState.CoordinatorPhase\"},{\"name\":\"decision\",\"type\":\"uint8\",\"internalType\":\"enumCoordinatorState.CoordinatorDecision\"},{\"name\":\"confirmed_txs\",\"type\":\"uint32[]\",\"internalType\":\"uint32[]\"},{\"name\":\"acks\",\"type\":\"uint32[]\",\"internalType\":\"uint32[]\"}]}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"getPacketAcknowledgementCall\",\"inputs\":[{\"name\":\"status\",\"type\":\"uint8\",\"internalType\":\"enumPacketAcknowledgementCall.CommitStatus\"}],\"outputs\":[{\"name\":\"acknowledgement\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"stateMutability\":\"pure\"},{\"type\":\"function\",\"name\":\"handleAcknowledgement\",\"inputs\":[{\"name\":\"packet\",\"type\":\"tuple\",\"internalType\":\"structPacket\",\"components\":[{\"name\":\"sequence\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"sourcePort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"sourceChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationPort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"data\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"timeoutHeight\",\"type\":\"tuple\",\"internalType\":\"structHeight.Data\",\"components\":[{\"name\":\"revision_number\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"revision_height\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"timeoutTimestamp\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"acknowledgement\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"handlePacket\",\"inputs\":[{\"name\":\"packet\",\"type\":\"tuple\",\"internalType\":\"structPacket\",\"components\":[{\"name\":\"sequence\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"sourcePort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"sourceChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationPort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"data\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"timeoutHeight\",\"type\":\"tuple\",\"internalType\":\"structHeight.Data\",\"components\":[{\"name\":\"revision_number\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"revision_height\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"timeoutTimestamp\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]}],\"outputs\":[{\"name\":\"acknowledgement\",\"type\":\"bytes\",\"internalType\":\"bytes\"}],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"handleTimeout\",\"inputs\":[{\"name\":\"packet\",\"type\":\"tuple\",\"internalType\":\"structPacket\",\"components\":[{\"name\":\"sequence\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"sourcePort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"sourceChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationPort\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"destinationChannel\",\"type\":\"string\",\"internalType\":\"string\"},{\"name\":\"data\",\"type\":\"bytes\",\"internalType\":\"bytes\"},{\"name\":\"timeoutHeight\",\"type\":\"tuple\",\"internalType\":\"structHeight.Data\",\"components\":[{\"name\":\"revision_number\",\"type\":\"uint64\",\"internalType\":\"uint64\"},{\"name\":\"revision_height\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"name\":\"timeoutTimestamp\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"initialize\",\"inputs\":[{\"name\":\"handler_\",\"type\":\"address\",\"internalType\":\"contractIIBCHandler\"},{\"name\":\"module_\",\"type\":\"address\",\"internalType\":\"contractIContractModule\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"function\",\"name\":\"isTxRecorded\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"outputs\":[{\"name\":\"\",\"type\":\"bool\",\"internalType\":\"bool\"}],\"stateMutability\":\"view\"},{\"type\":\"function\",\"name\":\"runTxIfCompleted\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}],\"outputs\":[],\"stateMutability\":\"nonpayable\"},{\"type\":\"event\",\"name\":\"Initialized\",\"inputs\":[{\"name\":\"version\",\"type\":\"uint64\",\"indexed\":false,\"internalType\":\"uint64\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"OnAbort\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes\",\"indexed\":true,\"internalType\":\"bytes\"},{\"name\":\"txIndex\",\"type\":\"uint8\",\"indexed\":true,\"internalType\":\"uint8\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"OnCommit\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes\",\"indexed\":true,\"internalType\":\"bytes\"},{\"name\":\"txIndex\",\"type\":\"uint8\",\"indexed\":true,\"internalType\":\"uint8\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"OnContractCommitImmediately\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes\",\"indexed\":true,\"internalType\":\"bytes\"},{\"name\":\"txIndex\",\"type\":\"uint8\",\"indexed\":true,\"internalType\":\"uint8\"},{\"name\":\"success\",\"type\":\"bool\",\"indexed\":true,\"internalType\":\"bool\"},{\"name\":\"ret\",\"type\":\"bytes\",\"indexed\":false,\"internalType\":\"bytes\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"TxInitiated\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes\",\"indexed\":false,\"internalType\":\"bytes\"},{\"name\":\"proposer\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"}],\"anonymous\":false},{\"type\":\"event\",\"name\":\"TxSigned\",\"inputs\":[{\"name\":\"signer\",\"type\":\"address\",\"indexed\":true,\"internalType\":\"address\"},{\"name\":\"txID\",\"type\":\"bytes32\",\"indexed\":true,\"internalType\":\"bytes32\"},{\"name\":\"method\",\"type\":\"uint8\",\"indexed\":false,\"internalType\":\"enumAuthType.AuthMode\"}],\"anonymous\":false},{\"type\":\"error\",\"name\":\"AckIsNotSuccess\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"AllTransactionsConfirmed\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"ArrayLengthMismatch\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"AuthAlreadyCompleted\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"AuthModeMismatch\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"AuthStateAlreadyInitialized\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"ChannelNotFound\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"CoordinatorPhaseNotPrepare\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"CoordinatorStateInconsistent\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"CoordinatorStateNotFound\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"CoordinatorTxStatusNotPrepare\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"DelegateCallFailed\",\"inputs\":[{\"name\":\"target\",\"type\":\"address\",\"internalType\":\"address\"}]},{\"type\":\"error\",\"name\":\"EmptyTypeUrl\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"IDNotFound\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"InvalidInitialization\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidSignersLength\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"InvalidTxIDLength\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"LinksNotSupported\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"MessageTimeoutHeight\",\"inputs\":[{\"name\":\"blockNumber\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"timeoutVersionHeight\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"type\":\"error\",\"name\":\"MessageTimeoutTimestamp\",\"inputs\":[{\"name\":\"blockTimestamp\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"timeoutTimestamp\",\"type\":\"uint64\",\"internalType\":\"uint64\"}]},{\"type\":\"error\",\"name\":\"ModuleAlreadyInitialized\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"ModuleNotInitialized\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotImplemented\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"NotInitializing\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"PayloadDecodeFailed\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"ReentrancyGuardReentrantCall\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"SignatureVerificationFailed\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"SignerCountMismatch\",\"inputs\":[{\"name\":\"signerCount\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"signatureCount\",\"type\":\"uint256\",\"internalType\":\"uint256\"}]},{\"type\":\"error\",\"name\":\"SignerMustEqualSender\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"StaticCallFailed\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"TPCNotImplemented\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"TooManySigners\",\"inputs\":[{\"name\":\"got\",\"type\":\"uint256\",\"internalType\":\"uint256\"},{\"name\":\"maxAllowed\",\"type\":\"uint256\",\"internalType\":\"uint256\"}]},{\"type\":\"error\",\"name\":\"Tx0MustBeForSelfChain\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"TxAlreadyExists\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"TxAlreadyVerified\",\"inputs\":[{\"name\":\"txID\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"TxIDAlreadyExists\",\"inputs\":[{\"name\":\"txIDHash\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"UnauthorizedCaller\",\"inputs\":[{\"name\":\"caller\",\"type\":\"address\",\"internalType\":\"address\"}]},{\"type\":\"error\",\"name\":\"UnexpectedChainID\",\"inputs\":[{\"name\":\"expectedHash\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"gotHash\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"}]},{\"type\":\"error\",\"name\":\"UnexpectedCommitStatus\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"UnexpectedReturnValue\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"UnexpectedSourceChannel\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"UnexpectedTypeURL\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"UnknownCommitProtocol\",\"inputs\":[]},{\"type\":\"error\",\"name\":\"VerifierNotFound\",\"inputs\":[{\"name\":\"typeUrl\",\"type\":\"string\",\"internalType\":\"string\"}]},{\"type\":\"error\",\"name\":\"VerifierReturnedFalse\",\"inputs\":[{\"name\":\"txIDHash\",\"type\":\"bytes32\",\"internalType\":\"bytes32\"},{\"name\":\"typeUrl\",\"type\":\"string\",\"internalType\":\"string\"}]},{\"type\":\"error\",\"name\":\"ZeroAddressVerifier\",\"inputs\":[]}]",
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

// GetCoordinatorState is a free data retrieval call binding the contract method 0xf8b89d89.
//
// Solidity: function getCoordinatorState(bytes32 txID) view returns((uint8,(string,string)[],uint8,uint8,uint32[],uint32[]))
func (_Txmanager *TxmanagerCaller) GetCoordinatorState(opts *bind.CallOpts, txID [32]byte) (CoordinatorStateData, error) {
	var out []interface{}
	err := _Txmanager.contract.Call(opts, &out, "getCoordinatorState", txID)

	if err != nil {
		return *new(CoordinatorStateData), err
	}

	out0 := *abi.ConvertType(out[0], new(CoordinatorStateData)).(*CoordinatorStateData)

	return out0, err

}

// GetCoordinatorState is a free data retrieval call binding the contract method 0xf8b89d89.
//
// Solidity: function getCoordinatorState(bytes32 txID) view returns((uint8,(string,string)[],uint8,uint8,uint32[],uint32[]))
func (_Txmanager *TxmanagerSession) GetCoordinatorState(txID [32]byte) (CoordinatorStateData, error) {
	return _Txmanager.Contract.GetCoordinatorState(&_Txmanager.CallOpts, txID)
}

// GetCoordinatorState is a free data retrieval call binding the contract method 0xf8b89d89.
//
// Solidity: function getCoordinatorState(bytes32 txID) view returns((uint8,(string,string)[],uint8,uint8,uint32[],uint32[]))
func (_Txmanager *TxmanagerCallerSession) GetCoordinatorState(txID [32]byte) (CoordinatorStateData, error) {
	return _Txmanager.Contract.GetCoordinatorState(&_Txmanager.CallOpts, txID)
}

// GetPacketAcknowledgementCall is a free data retrieval call binding the contract method 0x34a30a65.
//
// Solidity: function getPacketAcknowledgementCall(uint8 status) pure returns(bytes acknowledgement)
func (_Txmanager *TxmanagerCaller) GetPacketAcknowledgementCall(opts *bind.CallOpts, status uint8) ([]byte, error) {
	var out []interface{}
	err := _Txmanager.contract.Call(opts, &out, "getPacketAcknowledgementCall", status)

	if err != nil {
		return *new([]byte), err
	}

	out0 := *abi.ConvertType(out[0], new([]byte)).(*[]byte)

	return out0, err

}

// GetPacketAcknowledgementCall is a free data retrieval call binding the contract method 0x34a30a65.
//
// Solidity: function getPacketAcknowledgementCall(uint8 status) pure returns(bytes acknowledgement)
func (_Txmanager *TxmanagerSession) GetPacketAcknowledgementCall(status uint8) ([]byte, error) {
	return _Txmanager.Contract.GetPacketAcknowledgementCall(&_Txmanager.CallOpts, status)
}

// GetPacketAcknowledgementCall is a free data retrieval call binding the contract method 0x34a30a65.
//
// Solidity: function getPacketAcknowledgementCall(uint8 status) pure returns(bytes acknowledgement)
func (_Txmanager *TxmanagerCallerSession) GetPacketAcknowledgementCall(status uint8) ([]byte, error) {
	return _Txmanager.Contract.GetPacketAcknowledgementCall(&_Txmanager.CallOpts, status)
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

// Initialize is a paid mutator transaction binding the contract method 0x485cc955.
//
// Solidity: function initialize(address handler_, address module_) returns()
func (_Txmanager *TxmanagerTransactor) Initialize(opts *bind.TransactOpts, handler_ common.Address, module_ common.Address) (*types.Transaction, error) {
	return _Txmanager.contract.Transact(opts, "initialize", handler_, module_)
}

// Initialize is a paid mutator transaction binding the contract method 0x485cc955.
//
// Solidity: function initialize(address handler_, address module_) returns()
func (_Txmanager *TxmanagerSession) Initialize(handler_ common.Address, module_ common.Address) (*types.Transaction, error) {
	return _Txmanager.Contract.Initialize(&_Txmanager.TransactOpts, handler_, module_)
}

// Initialize is a paid mutator transaction binding the contract method 0x485cc955.
//
// Solidity: function initialize(address handler_, address module_) returns()
func (_Txmanager *TxmanagerTransactorSession) Initialize(handler_ common.Address, module_ common.Address) (*types.Transaction, error) {
	return _Txmanager.Contract.Initialize(&_Txmanager.TransactOpts, handler_, module_)
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

// TxmanagerInitializedIterator is returned from FilterInitialized and is used to iterate over the raw logs and unpacked data for Initialized events raised by the Txmanager contract.
type TxmanagerInitializedIterator struct {
	Event *TxmanagerInitialized // Event containing the contract specifics and raw log

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
func (it *TxmanagerInitializedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(TxmanagerInitialized)
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
		it.Event = new(TxmanagerInitialized)
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
func (it *TxmanagerInitializedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *TxmanagerInitializedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// TxmanagerInitialized represents a Initialized event raised by the Txmanager contract.
type TxmanagerInitialized struct {
	Version uint64
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterInitialized is a free log retrieval operation binding the contract event 0xc7f505b2f371ae2175ee4913f4499e1f2633a7b5936321eed1cdaeb6115181d2.
//
// Solidity: event Initialized(uint64 version)
func (_Txmanager *TxmanagerFilterer) FilterInitialized(opts *bind.FilterOpts) (*TxmanagerInitializedIterator, error) {

	logs, sub, err := _Txmanager.contract.FilterLogs(opts, "Initialized")
	if err != nil {
		return nil, err
	}
	return &TxmanagerInitializedIterator{contract: _Txmanager.contract, event: "Initialized", logs: logs, sub: sub}, nil
}

// WatchInitialized is a free log subscription operation binding the contract event 0xc7f505b2f371ae2175ee4913f4499e1f2633a7b5936321eed1cdaeb6115181d2.
//
// Solidity: event Initialized(uint64 version)
func (_Txmanager *TxmanagerFilterer) WatchInitialized(opts *bind.WatchOpts, sink chan<- *TxmanagerInitialized) (event.Subscription, error) {

	logs, sub, err := _Txmanager.contract.WatchLogs(opts, "Initialized")
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(TxmanagerInitialized)
				if err := _Txmanager.contract.UnpackLog(event, "Initialized", log); err != nil {
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

// ParseInitialized is a log parse operation binding the contract event 0xc7f505b2f371ae2175ee4913f4499e1f2633a7b5936321eed1cdaeb6115181d2.
//
// Solidity: event Initialized(uint64 version)
func (_Txmanager *TxmanagerFilterer) ParseInitialized(log types.Log) (*TxmanagerInitialized, error) {
	event := new(TxmanagerInitialized)
	if err := _Txmanager.contract.UnpackLog(event, "Initialized", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// TxmanagerOnAbortIterator is returned from FilterOnAbort and is used to iterate over the raw logs and unpacked data for OnAbort events raised by the Txmanager contract.
type TxmanagerOnAbortIterator struct {
	Event *TxmanagerOnAbort // Event containing the contract specifics and raw log

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
func (it *TxmanagerOnAbortIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(TxmanagerOnAbort)
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
		it.Event = new(TxmanagerOnAbort)
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
func (it *TxmanagerOnAbortIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *TxmanagerOnAbortIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// TxmanagerOnAbort represents a OnAbort event raised by the Txmanager contract.
type TxmanagerOnAbort struct {
	TxID    common.Hash
	TxIndex uint8
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterOnAbort is a free log retrieval operation binding the contract event 0x250bcd3f1f48512b15dbba0fb804f06878f25675cc2381898c392169d814a6f1.
//
// Solidity: event OnAbort(bytes indexed txID, uint8 indexed txIndex)
func (_Txmanager *TxmanagerFilterer) FilterOnAbort(opts *bind.FilterOpts, txID [][]byte, txIndex []uint8) (*TxmanagerOnAbortIterator, error) {

	var txIDRule []interface{}
	for _, txIDItem := range txID {
		txIDRule = append(txIDRule, txIDItem)
	}
	var txIndexRule []interface{}
	for _, txIndexItem := range txIndex {
		txIndexRule = append(txIndexRule, txIndexItem)
	}

	logs, sub, err := _Txmanager.contract.FilterLogs(opts, "OnAbort", txIDRule, txIndexRule)
	if err != nil {
		return nil, err
	}
	return &TxmanagerOnAbortIterator{contract: _Txmanager.contract, event: "OnAbort", logs: logs, sub: sub}, nil
}

// WatchOnAbort is a free log subscription operation binding the contract event 0x250bcd3f1f48512b15dbba0fb804f06878f25675cc2381898c392169d814a6f1.
//
// Solidity: event OnAbort(bytes indexed txID, uint8 indexed txIndex)
func (_Txmanager *TxmanagerFilterer) WatchOnAbort(opts *bind.WatchOpts, sink chan<- *TxmanagerOnAbort, txID [][]byte, txIndex []uint8) (event.Subscription, error) {

	var txIDRule []interface{}
	for _, txIDItem := range txID {
		txIDRule = append(txIDRule, txIDItem)
	}
	var txIndexRule []interface{}
	for _, txIndexItem := range txIndex {
		txIndexRule = append(txIndexRule, txIndexItem)
	}

	logs, sub, err := _Txmanager.contract.WatchLogs(opts, "OnAbort", txIDRule, txIndexRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(TxmanagerOnAbort)
				if err := _Txmanager.contract.UnpackLog(event, "OnAbort", log); err != nil {
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
func (_Txmanager *TxmanagerFilterer) ParseOnAbort(log types.Log) (*TxmanagerOnAbort, error) {
	event := new(TxmanagerOnAbort)
	if err := _Txmanager.contract.UnpackLog(event, "OnAbort", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// TxmanagerOnCommitIterator is returned from FilterOnCommit and is used to iterate over the raw logs and unpacked data for OnCommit events raised by the Txmanager contract.
type TxmanagerOnCommitIterator struct {
	Event *TxmanagerOnCommit // Event containing the contract specifics and raw log

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
func (it *TxmanagerOnCommitIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(TxmanagerOnCommit)
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
		it.Event = new(TxmanagerOnCommit)
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
func (it *TxmanagerOnCommitIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *TxmanagerOnCommitIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// TxmanagerOnCommit represents a OnCommit event raised by the Txmanager contract.
type TxmanagerOnCommit struct {
	TxID    common.Hash
	TxIndex uint8
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterOnCommit is a free log retrieval operation binding the contract event 0x7aaf0b63467fb40eac34c045248842f31e4e1edff7f0dd939f7ddeeddd83adc0.
//
// Solidity: event OnCommit(bytes indexed txID, uint8 indexed txIndex)
func (_Txmanager *TxmanagerFilterer) FilterOnCommit(opts *bind.FilterOpts, txID [][]byte, txIndex []uint8) (*TxmanagerOnCommitIterator, error) {

	var txIDRule []interface{}
	for _, txIDItem := range txID {
		txIDRule = append(txIDRule, txIDItem)
	}
	var txIndexRule []interface{}
	for _, txIndexItem := range txIndex {
		txIndexRule = append(txIndexRule, txIndexItem)
	}

	logs, sub, err := _Txmanager.contract.FilterLogs(opts, "OnCommit", txIDRule, txIndexRule)
	if err != nil {
		return nil, err
	}
	return &TxmanagerOnCommitIterator{contract: _Txmanager.contract, event: "OnCommit", logs: logs, sub: sub}, nil
}

// WatchOnCommit is a free log subscription operation binding the contract event 0x7aaf0b63467fb40eac34c045248842f31e4e1edff7f0dd939f7ddeeddd83adc0.
//
// Solidity: event OnCommit(bytes indexed txID, uint8 indexed txIndex)
func (_Txmanager *TxmanagerFilterer) WatchOnCommit(opts *bind.WatchOpts, sink chan<- *TxmanagerOnCommit, txID [][]byte, txIndex []uint8) (event.Subscription, error) {

	var txIDRule []interface{}
	for _, txIDItem := range txID {
		txIDRule = append(txIDRule, txIDItem)
	}
	var txIndexRule []interface{}
	for _, txIndexItem := range txIndex {
		txIndexRule = append(txIndexRule, txIndexItem)
	}

	logs, sub, err := _Txmanager.contract.WatchLogs(opts, "OnCommit", txIDRule, txIndexRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(TxmanagerOnCommit)
				if err := _Txmanager.contract.UnpackLog(event, "OnCommit", log); err != nil {
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
func (_Txmanager *TxmanagerFilterer) ParseOnCommit(log types.Log) (*TxmanagerOnCommit, error) {
	event := new(TxmanagerOnCommit)
	if err := _Txmanager.contract.UnpackLog(event, "OnCommit", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// TxmanagerOnContractCommitImmediatelyIterator is returned from FilterOnContractCommitImmediately and is used to iterate over the raw logs and unpacked data for OnContractCommitImmediately events raised by the Txmanager contract.
type TxmanagerOnContractCommitImmediatelyIterator struct {
	Event *TxmanagerOnContractCommitImmediately // Event containing the contract specifics and raw log

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
func (it *TxmanagerOnContractCommitImmediatelyIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(TxmanagerOnContractCommitImmediately)
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
		it.Event = new(TxmanagerOnContractCommitImmediately)
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
func (it *TxmanagerOnContractCommitImmediatelyIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *TxmanagerOnContractCommitImmediatelyIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// TxmanagerOnContractCommitImmediately represents a OnContractCommitImmediately event raised by the Txmanager contract.
type TxmanagerOnContractCommitImmediately struct {
	TxID    common.Hash
	TxIndex uint8
	Success bool
	Ret     []byte
	Raw     types.Log // Blockchain specific contextual infos
}

// FilterOnContractCommitImmediately is a free log retrieval operation binding the contract event 0x7da7723d423258c97d02fba73c0951597dc48566af572d5cb8e2698c22102e61.
//
// Solidity: event OnContractCommitImmediately(bytes indexed txID, uint8 indexed txIndex, bool indexed success, bytes ret)
func (_Txmanager *TxmanagerFilterer) FilterOnContractCommitImmediately(opts *bind.FilterOpts, txID [][]byte, txIndex []uint8, success []bool) (*TxmanagerOnContractCommitImmediatelyIterator, error) {

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

	logs, sub, err := _Txmanager.contract.FilterLogs(opts, "OnContractCommitImmediately", txIDRule, txIndexRule, successRule)
	if err != nil {
		return nil, err
	}
	return &TxmanagerOnContractCommitImmediatelyIterator{contract: _Txmanager.contract, event: "OnContractCommitImmediately", logs: logs, sub: sub}, nil
}

// WatchOnContractCommitImmediately is a free log subscription operation binding the contract event 0x7da7723d423258c97d02fba73c0951597dc48566af572d5cb8e2698c22102e61.
//
// Solidity: event OnContractCommitImmediately(bytes indexed txID, uint8 indexed txIndex, bool indexed success, bytes ret)
func (_Txmanager *TxmanagerFilterer) WatchOnContractCommitImmediately(opts *bind.WatchOpts, sink chan<- *TxmanagerOnContractCommitImmediately, txID [][]byte, txIndex []uint8, success []bool) (event.Subscription, error) {

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

	logs, sub, err := _Txmanager.contract.WatchLogs(opts, "OnContractCommitImmediately", txIDRule, txIndexRule, successRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(TxmanagerOnContractCommitImmediately)
				if err := _Txmanager.contract.UnpackLog(event, "OnContractCommitImmediately", log); err != nil {
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
func (_Txmanager *TxmanagerFilterer) ParseOnContractCommitImmediately(log types.Log) (*TxmanagerOnContractCommitImmediately, error) {
	event := new(TxmanagerOnContractCommitImmediately)
	if err := _Txmanager.contract.UnpackLog(event, "OnContractCommitImmediately", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// TxmanagerTxInitiatedIterator is returned from FilterTxInitiated and is used to iterate over the raw logs and unpacked data for TxInitiated events raised by the Txmanager contract.
type TxmanagerTxInitiatedIterator struct {
	Event *TxmanagerTxInitiated // Event containing the contract specifics and raw log

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
func (it *TxmanagerTxInitiatedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(TxmanagerTxInitiated)
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
		it.Event = new(TxmanagerTxInitiated)
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
func (it *TxmanagerTxInitiatedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *TxmanagerTxInitiatedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// TxmanagerTxInitiated represents a TxInitiated event raised by the Txmanager contract.
type TxmanagerTxInitiated struct {
	TxID     []byte
	Proposer common.Address
	Raw      types.Log // Blockchain specific contextual infos
}

// FilterTxInitiated is a free log retrieval operation binding the contract event 0x0bc2e2a7d294f6ab6e77997aaed7a9ef6e8265de18f7085a5453bf8638b8af0e.
//
// Solidity: event TxInitiated(bytes txID, address indexed proposer)
func (_Txmanager *TxmanagerFilterer) FilterTxInitiated(opts *bind.FilterOpts, proposer []common.Address) (*TxmanagerTxInitiatedIterator, error) {

	var proposerRule []interface{}
	for _, proposerItem := range proposer {
		proposerRule = append(proposerRule, proposerItem)
	}

	logs, sub, err := _Txmanager.contract.FilterLogs(opts, "TxInitiated", proposerRule)
	if err != nil {
		return nil, err
	}
	return &TxmanagerTxInitiatedIterator{contract: _Txmanager.contract, event: "TxInitiated", logs: logs, sub: sub}, nil
}

// WatchTxInitiated is a free log subscription operation binding the contract event 0x0bc2e2a7d294f6ab6e77997aaed7a9ef6e8265de18f7085a5453bf8638b8af0e.
//
// Solidity: event TxInitiated(bytes txID, address indexed proposer)
func (_Txmanager *TxmanagerFilterer) WatchTxInitiated(opts *bind.WatchOpts, sink chan<- *TxmanagerTxInitiated, proposer []common.Address) (event.Subscription, error) {

	var proposerRule []interface{}
	for _, proposerItem := range proposer {
		proposerRule = append(proposerRule, proposerItem)
	}

	logs, sub, err := _Txmanager.contract.WatchLogs(opts, "TxInitiated", proposerRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(TxmanagerTxInitiated)
				if err := _Txmanager.contract.UnpackLog(event, "TxInitiated", log); err != nil {
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

// ParseTxInitiated is a log parse operation binding the contract event 0x0bc2e2a7d294f6ab6e77997aaed7a9ef6e8265de18f7085a5453bf8638b8af0e.
//
// Solidity: event TxInitiated(bytes txID, address indexed proposer)
func (_Txmanager *TxmanagerFilterer) ParseTxInitiated(log types.Log) (*TxmanagerTxInitiated, error) {
	event := new(TxmanagerTxInitiated)
	if err := _Txmanager.contract.UnpackLog(event, "TxInitiated", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}

// TxmanagerTxSignedIterator is returned from FilterTxSigned and is used to iterate over the raw logs and unpacked data for TxSigned events raised by the Txmanager contract.
type TxmanagerTxSignedIterator struct {
	Event *TxmanagerTxSigned // Event containing the contract specifics and raw log

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
func (it *TxmanagerTxSignedIterator) Next() bool {
	// If the iterator failed, stop iterating
	if it.fail != nil {
		return false
	}
	// If the iterator completed, deliver directly whatever's available
	if it.done {
		select {
		case log := <-it.logs:
			it.Event = new(TxmanagerTxSigned)
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
		it.Event = new(TxmanagerTxSigned)
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
func (it *TxmanagerTxSignedIterator) Error() error {
	return it.fail
}

// Close terminates the iteration process, releasing any pending underlying
// resources.
func (it *TxmanagerTxSignedIterator) Close() error {
	it.sub.Unsubscribe()
	return nil
}

// TxmanagerTxSigned represents a TxSigned event raised by the Txmanager contract.
type TxmanagerTxSigned struct {
	Signer common.Address
	TxID   [32]byte
	Method uint8
	Raw    types.Log // Blockchain specific contextual infos
}

// FilterTxSigned is a free log retrieval operation binding the contract event 0x30c2a521823a6b9bc4f65ec80485542760a5639a135db9e69f36d257d9c3a716.
//
// Solidity: event TxSigned(address indexed signer, bytes32 indexed txID, uint8 method)
func (_Txmanager *TxmanagerFilterer) FilterTxSigned(opts *bind.FilterOpts, signer []common.Address, txID [][32]byte) (*TxmanagerTxSignedIterator, error) {

	var signerRule []interface{}
	for _, signerItem := range signer {
		signerRule = append(signerRule, signerItem)
	}
	var txIDRule []interface{}
	for _, txIDItem := range txID {
		txIDRule = append(txIDRule, txIDItem)
	}

	logs, sub, err := _Txmanager.contract.FilterLogs(opts, "TxSigned", signerRule, txIDRule)
	if err != nil {
		return nil, err
	}
	return &TxmanagerTxSignedIterator{contract: _Txmanager.contract, event: "TxSigned", logs: logs, sub: sub}, nil
}

// WatchTxSigned is a free log subscription operation binding the contract event 0x30c2a521823a6b9bc4f65ec80485542760a5639a135db9e69f36d257d9c3a716.
//
// Solidity: event TxSigned(address indexed signer, bytes32 indexed txID, uint8 method)
func (_Txmanager *TxmanagerFilterer) WatchTxSigned(opts *bind.WatchOpts, sink chan<- *TxmanagerTxSigned, signer []common.Address, txID [][32]byte) (event.Subscription, error) {

	var signerRule []interface{}
	for _, signerItem := range signer {
		signerRule = append(signerRule, signerItem)
	}
	var txIDRule []interface{}
	for _, txIDItem := range txID {
		txIDRule = append(txIDRule, txIDItem)
	}

	logs, sub, err := _Txmanager.contract.WatchLogs(opts, "TxSigned", signerRule, txIDRule)
	if err != nil {
		return nil, err
	}
	return event.NewSubscription(func(quit <-chan struct{}) error {
		defer sub.Unsubscribe()
		for {
			select {
			case log := <-logs:
				// New log arrived, parse the event and forward to the user
				event := new(TxmanagerTxSigned)
				if err := _Txmanager.contract.UnpackLog(event, "TxSigned", log); err != nil {
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
func (_Txmanager *TxmanagerFilterer) ParseTxSigned(log types.Log) (*TxmanagerTxSigned, error) {
	event := new(TxmanagerTxSigned)
	if err := _Txmanager.contract.UnpackLog(event, "TxSigned", log); err != nil {
		return nil, err
	}
	event.Raw = log
	return event, nil
}
