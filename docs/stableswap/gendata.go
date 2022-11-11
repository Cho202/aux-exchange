package stableswap

import (
	"fmt"
	"strings"
)

type poolCoinI struct {
	I       int
	Others  []int
	Befores []int
	Afters  []int
	NotLast bool
}
type PoolGen struct {
	// N is number of coins.
	N int
	// LastIndex is number of coins - 1
	LastIndex int
	Xis       []*poolCoinI

	AllPerms [][]*poolCoinI

	Precision     uint64
	NPrecision    int
	BalanceScaler uint64

	NameTake int

	Decimals []uint64

	CoinTypeList string

	MaxU64 uint64

	MaxDecimal uint64

	GenPermutation bool

	FeeDenominator  uint64
	MaxFeeNumerator uint64
	MinFeeNumerator uint64

	MaxAmp uint64

	WarningForManualEdit string

	UseQuoter bool
}

func NewPoolGen(n int) *PoolGen {
	if n <= 1 {
		panic(fmt.Errorf("too few coins: %d", n))
	}
	r := &PoolGen{
		N:          n,
		LastIndex:  n - 1,
		NPrecision: 8,
		MaxDecimal: 8,

		GenPermutation: false,

		FeeDenominator:  10_000_000_000, // 1e10
		MaxFeeNumerator: 30_000_000,     // 30bps
		MinFeeNumerator: 1_000_000,      // 1bps

		Precision: 1_000_000_000_000_000_000, // 1e18

		BalanceScaler: 1, // 1e10

		MaxU64: 18_446_744_073_709_551_615,

		MaxAmp: 2000,

		WarningForManualEdit: `/// Auto generated from github.com/aux-exchange/aux-exchange/docs/stableswap
/// don't modify by hand!`,
	}

	coinTypes := []string{}

	for i := 0; i < n; i++ {
		coinTypes = append(coinTypes, fmt.Sprintf("Coin%d", i))
		xi := &poolCoinI{
			I: i,
		}

		if i < n-1 {
			xi.NotLast = true
		}

		for j := 0; j < n; j++ {
			if j != i {
				xi.Others = append(xi.Others, j)
				if j < i {
					xi.Befores = append(xi.Befores, j)
				}
				if j > i {
					xi.Afters = append(xi.Afters, j)
				}
			}
		}
		r.Xis = append(r.Xis, xi)
	}

	r.AllPerms = getAllPerms(r.Xis)

	r.NameTake = 32 / n
	if 32%n == 0 && r.NameTake > 1 {
		r.NameTake = r.NameTake - 1
	}

	r.Decimals = []uint64{1}
	for i := 1; i <= 8; i++ {
		last := r.Decimals[i-1]
		r.Decimals = append(r.Decimals, last*10)
	}
	for i := 0; i < 4; i++ {
		r.Decimals[i], r.Decimals[8-i] = r.Decimals[8-i], r.Decimals[i]
	}

	r.Decimals = r.Decimals[:(r.MaxDecimal + 1)]

	r.CoinTypeList = strings.Join(coinTypes, ", ")

	return r
}
