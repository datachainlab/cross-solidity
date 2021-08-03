package testing

import (
	"testing"

	"github.com/stretchr/testify/suite"
)

const mnemonicPhrase = "math razor capable expose worth grape metal sunset metal sudden usage scheme"

type CrossTestSuite struct {
	suite.Suite

	chain *Chain
}

func TestChainTestSuite(t *testing.T) {
	suite.Run(t, new(CrossTestSuite))
}
