package testing

import (
	"bytes"
	"context"
	"crypto/ecdsa"
	"errors"
	"fmt"
	"math/big"
	"strings"
	"testing"
	"time"

	"github.com/avast/retry-go"
	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	gethtypes "github.com/ethereum/go-ethereum/core/types"
	gethcrypto "github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/ethereum/go-ethereum/rpc"

	"github.com/datachainlab/cross-solidity/pkg/contract/crosssimplemodule"
	"github.com/datachainlab/cross-solidity/pkg/contract/ownableibchandler"
	"github.com/datachainlab/cross-solidity/pkg/wallet"
)

var (
	abiEventOnContractCall abi.Event
)

func init() {
	var ok bool
	parsedCrossModuleABI, err := abi.JSON(strings.NewReader(crosssimplemodule.CrosssimplemoduleABI))
	if err != nil {
		panic(err)
	}
	abiEventOnContractCall, ok = parsedCrossModuleABI.Events["OnContractCall"]
	if !ok {
		panic("OnContractCall not found")
	}
}

type Chain struct {
	chainID        int64
	mnemonicPhrase string
	keys           map[uint32]*ecdsa.PrivateKey

	ETHClient      *ethclient.Client
	ContractConfig ContractConfig

	// Core modules
	IBCHandler ownableibchandler.Ownableibchandler

	// App modules
	CrossSimpleModule crosssimplemodule.Crosssimplemodule
}

func (chain *Chain) TxSync(ctx context.Context, tx *gethtypes.Transaction) error {
	var receipt *gethtypes.Receipt
	err := retry.Do(
		func() error {
			rc, err := chain.ETHClient.TransactionReceipt(ctx, tx.Hash())
			if err != nil {
				return err
			}
			receipt = rc
			return nil
		},
		// TODO make these configurable
		retry.Delay(1*time.Second),
		retry.Attempts(10),
	)
	if err != nil {
		return err
	}
	if receipt.Status == gethtypes.ReceiptStatusSuccessful {
		return nil
	} else {
		return fmt.Errorf("failed to call transaction: err='%v' rc='%v'", err, receipt)
	}
}

func (chain *Chain) TxSyncIfNoError(ctx context.Context) func(tx *gethtypes.Transaction, err error) error {
	return func(tx *gethtypes.Transaction, err error) error {
		if err != nil {
			return err
		}
		return chain.TxSync(ctx, tx)
	}
}

func (chain *Chain) findEventOnContractCall(ctx context.Context, txID []byte) (*crosssimplemodule.CrosssimplemoduleOnContractCall, error) {
	filter, err := crosssimplemodule.NewCrosssimplemoduleFilterer(
		chain.ContractConfig.GetCrossSimpleModuleAddress(), chain.ETHClient,
	)
	if err != nil {
		return nil, err
	}
	iter, err := filter.FilterOnContractCall(&bind.FilterOpts{Context: ctx})
	if err != nil {
		return nil, err
	}
	defer iter.Close()
	for iter.Next() {
		if bytes.Equal(txID, iter.Event.TxId) {
			return iter.Event, nil
		}
	}
	return nil, fmt.Errorf("event not found: txID=%v", string(txID))
}

func (chain *Chain) TxOpts(ctx context.Context, index uint32) *bind.TransactOpts {
	return makeGenTxOpts(big.NewInt(chain.chainID), chain.prvKey(index))(ctx)
}

func (chain *Chain) CallOpts(ctx context.Context, index uint32) *bind.CallOpts {
	opts := chain.TxOpts(ctx, index)
	return &bind.CallOpts{
		From:    opts.From,
		Context: opts.Context,
	}
}

func (chain *Chain) prvKey(index uint32) *ecdsa.PrivateKey {
	key, ok := chain.keys[index]
	if ok {
		return key
	}
	key, err := wallet.GetPrvKeyFromMnemonicAndHDWPath(chain.mnemonicPhrase, fmt.Sprintf("m/44'/60'/0'/0/%v", index))
	if err != nil {
		panic(err)
	}
	chain.keys[index] = key
	return key
}

type GenTxOpts func(ctx context.Context) *bind.TransactOpts

func makeGenTxOpts(chainID *big.Int, prv *ecdsa.PrivateKey) GenTxOpts {
	signer := gethtypes.NewEIP155Signer(chainID)
	addr := gethcrypto.PubkeyToAddress(prv.PublicKey)
	return func(ctx context.Context) *bind.TransactOpts {
		return &bind.TransactOpts{
			From:     addr,
			GasLimit: 6382056,
			Signer: func(address common.Address, tx *gethtypes.Transaction) (*gethtypes.Transaction, error) {
				if address != addr {
					return nil, errors.New("not authorized to sign this account")
				}
				signature, err := gethcrypto.Sign(signer.Hash(tx).Bytes(), prv)
				if err != nil {
					return nil, err
				}
				return tx.WithSignature(signer, signature)
			},
		}
	}
}

type ContractConfig interface {
	GetIBCHandlerAddress() common.Address
	GetCrossSimpleModuleAddress() common.Address
}

func NewChain(t *testing.T, rpcAddr string, mnemonicPhrase string, ccfg ContractConfig) *Chain {
	ethc, err := NewETHClient(rpcAddr)
	if err != nil {
		panic(err)
	}
	crossMod, err := crosssimplemodule.NewCrosssimplemodule(ccfg.GetCrossSimpleModuleAddress(), ethc)
	if err != nil {
		panic(err)
	}
	return &Chain{
		ETHClient:         ethc,
		CrossSimpleModule: *crossMod,
		ContractConfig:    ccfg,

		chainID:        1337,
		mnemonicPhrase: mnemonicPhrase,
		keys:           make(map[uint32]*ecdsa.PrivateKey),
	}
}

func NewETHClient(rpcAddr string) (*ethclient.Client, error) {
	conn, err := rpc.DialHTTP(rpcAddr)
	if err != nil {
		return nil, err
	}
	return ethclient.NewClient(conn), nil
}
