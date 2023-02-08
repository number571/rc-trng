package main

import (
	"os"
	"runtime"
)

const (
	blockN  = 256
	moduleN = 256
)

func randUintN(r *uint8, i int) {
	*r = uint8(i % moduleN)
}

func runRandUintN() uint8 {
	x := uint8(0)
	for i := 0; i < blockN; i++ {
		go randUintN(&x, i)
	}
	return x
}

func randUintNs(n int) []uint8 {
	numCount := n * moduleN
	gamma := make([]uint8, n)

	slice := make([]uint8, numCount)
	for i := 0; i < numCount; i++ {
		slice[i] = runRandUintN()
	}

	for i := 0; i < numCount; i += moduleN {
		sum := 0
		for j := 0; j < moduleN; j++ {
			sum += int(slice[i+j])
		}
		gamma[i/moduleN] = uint8(sum % moduleN)
	}

	return gamma
}

func main() {
	runtime.GOMAXPROCS(12)

	const n = 4096
	gamma := randUintNs(n)

	os.Stdout.Write(gamma)
}
