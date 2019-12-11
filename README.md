# YaoAD

Automatic differentiable quantum circuit.

**NOTE** This repo is deprecated, the functionality is in YaoBlocks now. You should be able to use them simply by just `using Yao`

## Install
```julia
pkg> add git@github.com:QuantumBFS/YaoAD.git
```

## Run an example
```julia
julia examples/vqe.jl
```

## Table of Supported AD Blocks
### `mat` BP
* [x] `KronBlock`
* [x] `ChainBlock`
* [x] `RotationGate`
* [x] `TimeEvolution`
* [x] `ShiftGate`
* [x] `PutBlock`
* [x] `GeneralMatrixBlock`

### `apply!` BP

* [ ] `PutBlock{<:Any, <:Any, <:RotationGate}`
* [ ] `PutBlock{<:Any, <:Any, <:ConstantGate}`
* [ ] `ChainBlock`
* [x] `RotationGate`
* [ ] `ShiftGate`

* [x] `focus!`
* [x] `relax!`
