module attributes {"triton_gpu.num-ctas" = 1 : i32, "triton_gpu.num-warps" = 2 : i32, triton_gpu.target = "cuda:75", "triton_gpu.threads-per-warp" = 32 : i32} {
  llvm.mlir.global external @global_smem() {addr_space = 3 : i32, alignment = 16 : i64} : !llvm.array<0 x i8>
  llvm.func @kernel(%arg0: !llvm.ptr<1> {tt.divisibility = 16 : i32}, %arg1: !llvm.ptr<1> {tt.divisibility = 16 : i32}, %arg2: !llvm.ptr<1> {tt.divisibility = 16 : i32}, %arg3: i32 {tt.divisibility = 16 : i32}) attributes {noinline = false, nvvm.kernel = 1 : ui1, nvvm.reqntid = array<i32: 64>} {
    %0 = llvm.mlir.undef : vector<1xf32>
    %1 = llvm.mlir.constant(true) : i1
    %2 = llvm.mlir.constant(8 : i32) : i32
    %3 = llvm.mlir.constant(4 : i32) : i32
    %4 = llvm.mlir.constant(2 : i32) : i32
    %5 = llvm.mlir.constant(1 : i32) : i32
    %6 = llvm.mlir.constant(0 : i32) : i32
    %7 = llvm.mlir.constant(32 : i32) : i32
    %8 = llvm.mlir.constant(0 : index) : i32
    %9 = llvm.mlir.constant(16 : i32) : i32
    %10 = llvm.inline_asm asm_dialect = att operand_attrs = [] "mov.u32 $0, %ctaid.x;", "=r"  : () -> i32
    %11 = llvm.mul %10, %9 : i32
    %12 = nvvm.read.ptx.sreg.tid.x : i32
    %13 = llvm.urem %12, %7  : i32
    %14 = llvm.and %13, %5  : i32
    %15 = llvm.icmp "eq" %14, %6 : i32
    %16 = llvm.select %15, %6, %5 : i1, i32
    %17 = llvm.xor %6, %16  : i32
    %18 = llvm.and %13, %4  : i32
    %19 = llvm.icmp "eq" %18, %6 : i32
    %20 = llvm.select %19, %6, %4 : i1, i32
    %21 = llvm.xor %17, %20  : i32
    %22 = llvm.and %13, %3  : i32
    %23 = llvm.icmp "eq" %22, %6 : i32
    %24 = llvm.select %23, %6, %3 : i1, i32
    %25 = llvm.xor %21, %24  : i32
    %26 = llvm.and %13, %2  : i32
    %27 = llvm.icmp "eq" %26, %6 : i32
    %28 = llvm.select %27, %6, %2 : i1, i32
    %29 = llvm.xor %25, %28  : i32
    %30 = llvm.xor %29, %6  : i32
    %31 = llvm.add %30, %8 : i32
    %32 = llvm.add %11, %31 : i32
    %33 = llvm.getelementptr %arg0[%32] : (!llvm.ptr<1>, i32) -> !llvm.ptr<1>, f32
    %34 = llvm.icmp "slt" %32, %arg3 : i32
    %35 = llvm.inline_asm has_side_effects asm_dialect = att operand_attrs = [] "mov.u32 $0, 0x0;\0A\09@$2 ld.global.b32 { $0 }, [ $1 + 0 ];", "=r,l,b" %33, %34 : (!llvm.ptr<1>, i1) -> i32
    %36 = llvm.bitcast %35 : i32 to vector<1xf32>
    %37 = llvm.extractelement %36[%8 : i32] : vector<1xf32>
    %38 = llvm.getelementptr %arg1[%32] : (!llvm.ptr<1>, i32) -> !llvm.ptr<1>, f32
    %39 = llvm.inline_asm has_side_effects asm_dialect = att operand_attrs = [] "mov.u32 $0, 0x0;\0A\09@$2 ld.global.b32 { $0 }, [ $1 + 0 ];", "=r,l,b" %38, %34 : (!llvm.ptr<1>, i1) -> i32
    %40 = llvm.bitcast %39 : i32 to vector<1xf32>
    %41 = llvm.extractelement %40[%8 : i32] : vector<1xf32>
    %42 = llvm.fadd %37, %41  : f32
    %43 = llvm.getelementptr %arg2[%32] : (!llvm.ptr<1>, i32) -> !llvm.ptr<1>, f32
    %44 = nvvm.read.ptx.sreg.tid.x : i32
    %45 = llvm.urem %44, %7  : i32
    %46 = llvm.udiv %44, %7  : i32
    %47 = llvm.urem %46, %4  : i32
    %48 = llvm.urem %45, %7  : i32
    %49 = llvm.mul %47, %7 : i32
    %50 = llvm.add %49, %48 : i32
    %51 = llvm.mul %50, %5 : i32
    %52 = llvm.icmp "slt" %51, %9 : i32
    %53 = llvm.and %1, %52  : i1
    %54 = llvm.insertelement %42, %0[%6 : i32] : vector<1xf32>
    %55 = llvm.bitcast %54 : vector<1xf32> to i32
    %56 = llvm.and %53, %34  : i1
    %57 = llvm.inline_asm has_side_effects asm_dialect = att operand_attrs = [] "@$2 st.global.b32 [ $1 + 0 ], { $0 };", "r,l,b" %55, %43, %56 : (i32, !llvm.ptr<1>, i1) -> !llvm.void
    llvm.return
  }
}

