#!/bin/bash

set -e

../python/build/cmake.linux-x86_64-cpython-3.10/bin/triton-opt \
    --convert-triton-to-tritongpu='target=cuda:75 num-warps=2' \
    --convert-triton-gpu-to-llvm \
    --convert-math-to-llvm \
    --convert-nv-gpu-to-llvm \
    example.mlir \
    -o converted.mlir

mlir-translate-18 --mlir-to-llvmir converted.mlir -o converted.ll
llc-18 -march=nvptx64 -mcpu=sm_75 converted.ll
