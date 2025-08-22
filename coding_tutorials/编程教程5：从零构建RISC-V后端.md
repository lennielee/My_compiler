# 编程教程5：从零构建RISC-V后端

## 学习目标

- 理解LLVM后端架构在实践中的工作原理
- 为完整的RISC-V32I指令集编写TableGen描述
- 实现带有模式匹配的指令选择
- 构建调用约定和寄存器分配
- 创建生成汇编代码的完整后端
- 将后端与LLVM编译管道集成

## 第1部分：理解LLVM后端架构

### 后端做什么？

后端将**平台无关的**LLVM IR转换为**平台特定的**机器代码：

```
LLVM IR → 指令选择 → 寄存器分配 → 汇编生成 → 机器代码
```

**主要职责：**

1. **指令选择**：将IR操作映射到目标指令
2. **寄存器分配**：将虚拟寄存器分配给物理寄存器
3. **调用约定**：处理函数调用和参数传递
4. **代码布局**：组织指令以获得最佳执行
5. **汇编发射**：生成人类可读的汇编代码

### LLVM后端组件

```
目标描述（TableGen）
├── 寄存器定义
├── 指令定义  
├── 调用约定
└── 指令格式

C++实现
├── 指令选择（DAGToDAG）
├── 降级（IR → SelectionDAG）
├── 目标机器配置
├── 汇编打印器
└── 栈帧降级（栈管理）
```

## 第2部分：设置目标基础设施

### 目标目录结构

```
backEnd/One/                          # 我们的RISC-V目标
├── One.td                           # 主目标定义
├── OneRegisterInfo.td/.cpp/.h       # 寄存器描述
├── OneInstrInfo.td/.cpp/.h          # 指令定义
├── OneInstrFormats.td               # 指令格式类
├── OneCallingConv.td/.cpp/.h        # 函数调用ABI
├── OneISelDAGToDAG.cpp             # 指令选择
├── OneISelLowering.cpp/.h          # IR降级到SelectionDAG
├── OneTargetMachine.cpp/.h         # 目标配置
├── OneAsmPrinter.cpp/.h            # 汇编生成
├── OneFrameLowering.cpp/.h         # 栈帧管理
└── MCTargetDesc/                   # 机器代码描述
    ├── OneMCTargetDesc.cpp/.h      # 目标注册
    ├── OneMCAsmInfo.cpp/.h         # 汇编语法
    └── OneInstPrinter.cpp/.h       # 指令打印
```

### 主目标定义（One.td）

```tablegen
// One.td - 主目标定义
include "llvm/Target/Target.td"

// 包含所有组件定义
include "OneRegisterInfo.td"
include "OneInstrInfo.td"
include "OneCallingConv.td"

// 定义处理器模型
def : ProcessorModel<"one", NoSchedModel, []>;

// 定义指令信息
def OneInstrInfo : InstrInfo;

// 定义目标
def One : Target {
    let InstructionSet = OneInstrInfo;
}
```

## 第3部分：寄存器定义和管理

### RISC-V寄存器架构

RISC-V32I有32个通用寄存器：

- `x0` (zero): 总是读作0，写入被忽略
- `x1` (ra): 返回地址
- `x2` (sp): 栈指针
- `x3` (gp): 全局指针
- `x4` (tp): 线程指针
- `x5-x7` (t0-t2): 临时寄存器
- `x8-x9` (s0-s1): 保存寄存器
- `x10-x17` (a0-a7): 参数/返回寄存器
- `x18-x27` (s2-s11): 保存寄存器
- `x28-x31` (t3-t6): 临时寄存器

### 寄存器定义（OneRegisterInfo.td）

```tablegen
// OneRegisterInfo.td - RISC-V寄存器定义

class OneReg<bits<5> Enc, string n> : Register<n> {
    let HWEncoding = Enc;    // 硬件编码（RISC-V为5位）
    let Namespace = "One";
}

// 用编码定义各个寄存器
def ZERO : OneReg<0,  "zero">, DwarfRegNum<[0]>;
def RA   : OneReg<1,  "ra">,   DwarfRegNum<[1]>;
def SP   : OneReg<2,  "sp">,   DwarfRegNum<[2]>;
def GP   : OneReg<3,  "gp">,   DwarfRegNum<[3]>;
def TP   : OneReg<4,  "tp">,   DwarfRegNum<[4]>;

// 临时寄存器
def T0   : OneReg<5,  "t0">,   DwarfRegNum<[5]>;
def T1   : OneReg<6,  "t1">,   DwarfRegNum<[6]>;
def T2   : OneReg<7,  "t2">,   DwarfRegNum<[7]>;

// 保存寄存器  
def S0   : OneReg<8,  "s0">,   DwarfRegNum<[8]>;
def S1   : OneReg<9,  "s1">,   DwarfRegNum<[9]>;

// 参数/返回寄存器
def A0   : OneReg<10, "a0">,   DwarfRegNum<[10]>;
def A1   : OneReg<11, "a1">,   DwarfRegNum<[11]>;
def A2   : OneReg<12, "a2">,   DwarfRegNum<[12]>;
def A3   : OneReg<13, "a3">,   DwarfRegNum<[13]>;
def A4   : OneReg<14, "a4">,   DwarfRegNum<[14]>;
def A5   : OneReg<15, "a5">,   DwarfRegNum<[15]>;
def A6   : OneReg<16, "a6">,   DwarfRegNum<[16]>;
def A7   : OneReg<17, "a7">,   DwarfRegNum<[17]>;

// 32位通用寄存器的寄存器类
def GPR : RegisterClass<"One", [i32], 32, (add
    // 顺序对寄存器分配偏好很重要
    ZERO, RA, SP,                    // 特殊寄存器
    A0, A1, A2, A3, A4, A5, A6, A7,  // 参数寄存器（调用者保存）
    T0, T1, T2,                      // 临时寄存器（调用者保存）
    S0, S1                           // 保存寄存器（被调用者保存）
)>;
```

### 寄存器信息实现（OneRegisterInfo.cpp）

```cpp
// OneRegisterInfo.cpp - 寄存器信息实现
#include "OneRegisterInfo.h"
#include "One.h"
#include "OneSubtarget.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/RegisterScavenging.h"

using namespace llvm;

#define GET_REGINFO_TARGET_DESC
#include "OneGenRegisterInfo.inc"

OneRegisterInfo::OneRegisterInfo() : OneGenRegisterInfo(One::RA) {}

const MCPhysReg *OneRegisterInfo::getCalleeSavedRegs(const MachineFunction *MF) const {
    // 定义在函数调用中必须保留的寄存器
    static const MCPhysReg CalleeSavedRegs[] = {
        One::RA,  // 返回地址
        One::S0,  // 保存寄存器0
        One::S1,  // 保存寄存器1
        0         // 终止符
    };
    return CalleeSavedRegs;
}

BitVector OneRegisterInfo::getReservedRegs(const MachineFunction &MF) const {
    BitVector Reserved(getNumRegs());
    
    // 标记特殊寄存器为保留（不可分配）
    Reserved.set(One::ZERO);  // 总是零
    Reserved.set(One::RA);    // 返回地址
    Reserved.set(One::SP);    // 栈指针
    Reserved.set(One::GP);    // 全局指针
    Reserved.set(One::TP);    // 线程指针
    
    return Reserved;
}

void OneRegisterInfo::eliminateFrameIndex(MachineBasicBlock::iterator II,
                                         int SPAdj, unsigned FIOperandNum,
                                         RegScavenger *RS) const {
    // 将栈帧索引引用转换为实际栈偏移
    MachineInstr &MI = *II;
    MachineFunction &MF = *MI.getParent()->getParent();
    MachineFrameInfo &MFI = MF.getFrameInfo();
    
    int FrameIndex = MI.getOperand(FIOperandNum).getIndex();
    int64_t Offset = MFI.getObjectOffset(FrameIndex);
    
    // 用基址寄存器+偏移替换栈帧索引
    MI.getOperand(FIOperandNum).ChangeToRegister(One::SP, false);
    MI.getOperand(FIOperandNum + 1).ChangeToImmediate(Offset);
}
```

## 第4部分：指令格式和定义

### RISC-V指令格式

RISC-V有几种指令格式。让我们实现主要的：

```tablegen
// OneInstrFormats.td - 指令格式定义

class OneInst<dag outs, dag ins, string asmstr, list<dag> pattern>
    : Instruction {
    field bits<32> Inst;      // 32位指令编码
    field bits<32> SoftFail = 0;
    
    let Size = 4;             // 所有指令都是4字节
    let Namespace = "One";
    
    dag OutOperandList = outs;
    dag InOperandList = ins;
    let AsmString = asmstr;
    let Pattern = pattern;
}

// R类型：寄存器-寄存器操作
// 格式：funct7[31:25] rs2[24:20] rs1[19:15] funct3[14:12] rd[11:7] opcode[6:0]
class RInst<bits<7> funct7, bits<3> funct3, bits<7> opcode, 
           dag outs, dag ins, string asmstr, list<dag> pattern>
    : OneInst<outs, ins, asmstr, pattern> {
    bits<5> rd;
    bits<5> rs1;
    bits<5> rs2;
    
    let Inst{31-25} = funct7;
    let Inst{24-20} = rs2;
    let Inst{19-15} = rs1;
    let Inst{14-12} = funct3;
    let Inst{11-7}  = rd;
    let Inst{6-0}   = opcode;
}

// I类型：立即数操作
// 格式：imm[31:20] rs1[19:15] funct3[14:12] rd[11:7] opcode[6:0]
class IInst<bits<3> funct3, bits<7> opcode,
           dag outs, dag ins, string asmstr, list<dag> pattern>
    : OneInst<outs, ins, asmstr, pattern> {
    bits<12> imm;
    bits<5> rs1;
    bits<5> rd;
    
    let Inst{31-20} = imm;
    let Inst{19-15} = rs1;
    let Inst{14-12} = funct3;
    let Inst{11-7}  = rd;
    let Inst{6-0}   = opcode;
}

// S类型：存储操作
// 格式：imm[31:25] rs2[24:20] rs1[19:15] funct3[14:12] imm[11:7] opcode[6:0]
class SInst<bits<3> funct3, bits<7> opcode,
           dag outs, dag ins, string asmstr, list<dag> pattern>
    : OneInst<outs, ins, asmstr, pattern> {
    bits<12> imm;
    bits<5> rs1;
    bits<5> rs2;
    
    let Inst{31-25} = imm{11-5};
    let Inst{24-20} = rs2;
    let Inst{19-15} = rs1;
    let Inst{14-12} = funct3;
    let Inst{11-7}  = imm{4-0};
    let Inst{6-0}   = opcode;
}

// 特定指令类型的便利类
class ArithR<bits<7> funct7, bits<3> funct3, string asmstr, SDNode OpNode>
    : RInst<funct7, funct3, 0b0110011,
           (outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2),
           !strconcat(asmstr, "\t$rd, $rs1, $rs2"),
           [(set GPR:$rd, (OpNode GPR:$rs1, GPR:$rs2))]>;

class ArithI<bits<3> funct3, string asmstr, SDNode OpNode>
    : IInst<funct3, 0b0010011,
           (outs GPR:$rd), (ins GPR:$rs1, simm12:$imm),
           !strconcat(asmstr, "\t$rd, $rs1, $imm"),
           [(set GPR:$rd, (OpNode GPR:$rs1, simm12:$imm))]>;
```

### 立即数操作数定义

```tablegen
// 定义带范围约束的立即数操作数类型
def simm12 : Operand<i32>, ImmLeaf<i32, [{ return isInt<12>(Imm); }]>;
def uimm20 : Operand<i32>, ImmLeaf<i32, [{ return isUInt<20>(Imm); }]>;

// 内存操作的地址操作数
def addr : ComplexPattern<iPTR, 2, "SelectAddr", [frameindex], []>;
```

### 核心指令定义（OneInstrInfo.td）

```tablegen
// OneInstrInfo.td - 指令定义
include "OneInstrFormats.td"

//===----------------------------------------------------------------------===//
// 算术指令
//===----------------------------------------------------------------------===//

// 寄存器-寄存器算术
def ADD  : ArithR<0b0000000, 0b000, "add",  add>;
def SUB  : ArithR<0b0100000, 0b000, "sub",  sub>;
def MUL  : ArithR<0b0000001, 0b000, "mul",  mul>;
def DIV  : ArithR<0b0000001, 0b100, "div",  sdiv>;
def REM  : ArithR<0b0000001, 0b110, "rem",  srem>;

// 逻辑操作
def AND  : ArithR<0b0000000, 0b111, "and",  and>;
def OR   : ArithR<0b0000000, 0b110, "or",   or>;
def XOR  : ArithR<0b0000000, 0b100, "xor",  xor>;

// 移位操作
def SLL  : ArithR<0b0000000, 0b001, "sll",  shl>;
def SRL  : ArithR<0b0000000, 0b101, "srl",  srl>;
def SRA  : ArithR<0b0100000, 0b101, "sra",  sra>;

// 立即数算术
def ADDI : ArithI<0b000, "addi", add>;
def ANDI : ArithI<0b111, "andi", and>;
def ORI  : ArithI<0b110, "ori",  or>;
def XORI : ArithI<0b100, "xori", xor>;

// 立即数移位（特殊编码）
def SLLI : IInst<0b001, 0b0010011,
               (outs GPR:$rd), (ins GPR:$rs1, uimm5:$shamt),
               "slli\t$rd, $rs1, $shamt",
               [(set GPR:$rd, (shl GPR:$rs1, uimm5:$shamt))]> {
    bits<5> shamt;
    let Inst{31-25} = 0b0000000;
    let Inst{24-20} = shamt;
}

//===----------------------------------------------------------------------===//
// 加载/存储指令
//===----------------------------------------------------------------------===//

// 加载指令
def LW  : IInst<0b010, 0b0000011,
              (outs GPR:$rd), (ins addr:$addr),
              "lw\t$rd, $addr",
              [(set GPR:$rd, (load addr:$addr))]>;

def LH  : IInst<0b001, 0b0000011,
              (outs GPR:$rd), (ins addr:$addr),
              "lh\t$rd, $addr",
              [(set GPR:$rd, (sextloadi16 addr:$addr))]>;

def LB  : IInst<0b000, 0b0000011,
              (outs GPR:$rd), (ins addr:$addr),
              "lb\t$rd, $addr",
              [(set GPR:$rd, (sextloadi8 addr:$addr))]>;

// 存储指令
def SW  : SInst<0b010, 0b0100011,
              (outs), (ins GPR:$rs2, addr:$addr),
              "sw\t$rs2, $addr",
              [(store GPR:$rs2, addr:$addr)]>;

def SH  : SInst<0b001, 0b0100011,
              (outs), (ins GPR:$rs2, addr:$addr),
              "sh\t$rs2, $addr",
              [(truncstorei16 GPR:$rs2, addr:$addr)]>;

def SB  : SInst<0b000, 0b0100011,
              (outs), (ins GPR:$rs2, addr:$addr),
              "sb\t$rs2, $addr",
              [(truncstorei8 GPR:$rs2, addr:$addr)]>;

//===----------------------------------------------------------------------===//
// 比较指令
//===----------------------------------------------------------------------===//

def SLT  : ArithR<0b0000000, 0b010, "slt",  setlt>;
def SLTU : ArithR<0b0000000, 0b011, "sltu", setult>;

def SLTI  : ArithI<0b010, "slti",  setlt>;
def SLTIU : ArithI<0b011, "sltiu", setult>;

//===----------------------------------------------------------------------===//
// 分支指令
//===----------------------------------------------------------------------===//

class BranchInst<bits<3> funct3, string asmstr, PatFrag CondOp>
    : SInst<funct3, 0b1100011,
           (outs), (ins GPR:$rs1, GPR:$rs2, simm13_lsb0:$imm),
           !strconcat(asmstr, "\t$rs1, $rs2, $imm"),
           [(brcond (i32 (CondOp GPR:$rs1, GPR:$rs2)), bb:$imm)]>;

def BEQ  : BranchInst<0b000, "beq",  seteq>;
def BNE  : BranchInst<0b001, "bne",  setne>;
def BLT  : BranchInst<0b100, "blt",  setlt>;
def BGE  : BranchInst<0b101, "bge",  setge>;
def BLTU : BranchInst<0b110, "bltu", setult>;
def BGEU : BranchInst<0b111, "bgeu", setuge>;

//===----------------------------------------------------------------------===//
// 跳转指令
//===----------------------------------------------------------------------===//

def JAL : IInst<0b000, 0b1101111,
              (outs GPR:$rd), (ins simm21_lsb0:$imm),
              "jal\t$rd, $imm",
              []>;

def JALR : IInst<0b000, 0b1100111,
               (outs GPR:$rd), (ins GPR:$rs1, simm12:$imm),
               "jalr\t$rd, $rs1, $imm",
               []>;

//===----------------------------------------------------------------------===//
// 伪指令
//===----------------------------------------------------------------------===//

// 常见汇编别名和伪指令
def : InstAlias<"mv $rd, $rs", (ADDI GPR:$rd, GPR:$rs, 0)>;
def : InstAlias<"li $rd, $imm", (ADDI GPR:$rd, ZERO, simm12:$imm)>;
def : InstAlias<"nop", (ADDI ZERO, ZERO, 0)>;
def : InstAlias<"ret", (JALR ZERO, RA, 0)>;

// 加载常量的模式
def : Pat<(i32 simm12:$imm), (ADDI ZERO, simm12:$imm)>;

// 设置寄存器比较的模式
def : Pat<(seteq GPR:$rs1, GPR:$rs2), 
          (SLTIU (XOR GPR:$rs1, GPR:$rs2), 1)>;
def : Pat<(setne GPR:$rs1, GPR:$rs2), 
          (SLTU ZERO, (XOR GPR:$rs1, GPR:$rs2))>;
```

## 第5部分：调用约定

### 函数调用ABI实现

```tablegen
// OneCallingConv.td - 调用约定定义

// 返回值约定
def RetCC_One : CallingConv<[
    // i32返回值放入a0, a1
    CCIfType<[i32], CCAssignToReg<[A0, A1]>>,
    
    // 更大的返回值放入内存
    CCAssignToStack<4, 4>
]>;

// 参数传递约定
def CC_One : CallingConv<[
    // 前8个整数参数放入寄存器a0-a7
    CCIfType<[i32], CCAssignToReg<[A0, A1, A2, A3, A4, A5, A6, A7]>>,
    
    // 剩余参数放在栈上，4字节对齐
    CCAssignToStack<4, 4>
]>;

// 被调用者保存的寄存器（必须在调用中保留）
def CSR : CalleeSavedRegs<(add RA, S0, S1)>;
```

### 调用约定实现（OneCallingConv.cpp）

```cpp
// OneCallingConv.cpp - 调用约定实现
#include "OneCallingConv.h"
#include "One.h"

using namespace llvm;

// 包含自动生成的调用约定代码
#include "OneGenCallingConv.inc"

// 如需要，自定义调用约定逻辑
static bool CC_One_Custom(unsigned ValNo, MVT ValVT, MVT LocVT,
                         CCValAssign::LocInfo LocInfo,
                         ISD::ArgFlagsTy ArgFlags, CCState &State) {
    // 特殊情况的自定义逻辑
    // 目前使用标准生成逻辑
    return CC_One(ValNo, ValVT, LocVT, LocInfo, ArgFlags, State);
}
```

## 第6部分：指令选择实现

### IR降级（OneISelLowering.cpp）

```cpp
// OneISelLowering.cpp - 将LLVM IR转换为SelectionDAG
#include "OneISelLowering.h"
#include "One.h"
#include "OneSubtarget.h"
#include "llvm/CodeGen/CallingConvLower.h"
#include "llvm/CodeGen/MachineFrameInfo.h"

using namespace llvm;

OneTargetLowering::OneTargetLowering(const TargetMachine &TM,
                                     const OneSubtarget &STI)
    : TargetLowering(TM), Subtarget(STI) {
    
    // 为i32类型注册寄存器类
    addRegisterClass(MVT::i32, &One::GPRRegClass);
    
    // 设置操作动作 - 如何处理各种IR操作
    setOperationAction(ISD::GlobalAddress, MVT::i32, Custom);
    setOperationAction(ISD::ConstantPool, MVT::i32, Custom);
    setOperationAction(ISD::JumpTable, MVT::i32, Custom);
    
    // 将复杂操作扩展为更简单的操作
    setOperationAction(ISD::BR_CC, MVT::i32, Expand);
    setOperationAction(ISD::SELECT_CC, MVT::i32, Expand);
    setOperationAction(ISD::SETCC, MVT::i32, Expand);
    
    // 计算寄存器属性
    computeRegisterProperties(STI.getRegisterInfo());
}

SDValue OneTargetLowering::LowerOperation(SDValue Op, SelectionDAG &DAG) const {
    switch (Op.getOpcode()) {
    case ISD::GlobalAddress:
        return LowerGlobalAddress(Op, DAG);
    case ISD::ConstantPool:
        return LowerConstantPool(Op, DAG);
    default:
        llvm_unreachable("unimplemented operand");
    }
}

SDValue OneTargetLowering::LowerGlobalAddress(SDValue Op, SelectionDAG &DAG) const {
    SDLoc DL(Op);
    const GlobalValue *GV = cast<GlobalAddressSDNode>(Op)->getGlobal();
    int64_t Offset = cast<GlobalAddressSDNode>(Op)->getOffset();
    
    // 为简单起见，使用直接寻址
    // 在真实实现中，您会处理不同的寻址模式
    SDValue TargetAddr = DAG.getTargetGlobalAddress(GV, DL, MVT::i32, Offset);
    return DAG.getNode(OneISD::WRAPPER, DL, MVT::i32, TargetAddr);
}

SDValue OneTargetLowering::LowerCall(CallLoweringInfo &CLI,
                                     SmallVectorImpl<SDValue> &InVals) const {
    SelectionDAG &DAG = CLI.DAG;
    SDLoc &DL = CLI.DL;
    SmallVectorImpl<ISD::OutputArg> &Outs = CLI.Outs;
    SmallVectorImpl<SDValue> &OutVals = CLI.OutVals;
    SmallVectorImpl<ISD::InputArg> &Ins = CLI.Ins;
    SDValue Chain = CLI.Chain;
    SDValue Callee = CLI.Callee;
    CallingConv::ID CallConv = CLI.CallConv;
    bool IsVarArg = CLI.IsVarArg;
    
    MachineFunction &MF = DAG.getMachineFunction();
    
    // 分析调用操作数
    SmallVector<CCValAssign, 16> ArgLocs;
    CCState CCInfo(CallConv, IsVarArg, MF, ArgLocs, *DAG.getContext());
    CCInfo.AnalyzeCallOperands(Outs, CC_One);
    
    // 处理参数
    SmallVector<std::pair<unsigned, SDValue>> RegsToPass;
    SDValue StackPtr;
    
    for (unsigned i = 0, e = ArgLocs.size(); i != e; ++i) {
        CCValAssign &VA = ArgLocs[i];
        SDValue Arg = OutVals[i];
        
        if (VA.isRegLoc()) {
            // 参数放入寄存器
            RegsToPass.push_back(std::make_pair(VA.getLocReg(), Arg));
        } else {
            // 参数放在栈上
            assert(VA.isMemLoc());
            
            if (!StackPtr.getNode()) {
                StackPtr = DAG.getCopyFromReg(Chain, DL, One::SP, getPointerTy(DAG.getDataLayout()));
            }
            
            SDValue PtrOff = DAG.getIntPtrConstant(VA.getLocMemOffset(), DL);
            PtrOff = DAG.getNode(ISD::ADD, DL, getPointerTy(DAG.getDataLayout()), StackPtr, PtrOff);
            
            Chain = DAG.getStore(Chain, DL, Arg, PtrOff, MachinePointerInfo::getStack(MF, VA.getLocMemOffset()));
        }
    }
    
    // 构建调用指令
    SDValue InFlag;
    for (auto &Reg : RegsToPass) {
        Chain = DAG.getCopyToReg(Chain, DL, Reg.first, Reg.second, InFlag);
        InFlag = Chain.getValue(1);
    }
    
    // 创建调用节点
    std::vector<EVT> NodeTys;
    NodeTys.push_back(MVT::Other);  // Chain
    NodeTys.push_back(MVT::Glue);   // Flag
    
    if (InFlag.getNode()) {
        CallOperands.push_back(InFlag);
    }
    
    SDVTList NodeTys = DAG.getVTList(MVT::Other, MVT::Glue);
    Chain = DAG.getNode(OneISD::CALL, DL, NodeTys, CallOperands);
    InFlag = Chain.getValue(1);
    
    // 处理返回值
    SmallVector<CCValAssign, 16> RVLocs;
    CCState RVInfo(CallConv, IsVarArg, MF, RVLocs, *DAG.getContext());
    RVInfo.AnalyzeCallResult(Ins, RetCC_One);
    
    for (unsigned i = 0; i != RVLocs.size(); ++i) {
        Chain = DAG.getCopyFromReg(Chain, DL, RVLocs[i].getLocReg(), RVLocs[i].getValVT(), InFlag).getValue(1);
        InFlag = Chain.getValue(2);
        InVals.push_back(Chain.getValue(0));
    }
    
    return Chain;
}
```

### 指令选择（OneISelDAGToDAG.cpp）

```cpp
// OneISelDAGToDAG.cpp - 指令选择
#include "OneISelDAGToDAG.h"
#include "One.h"
#include "OneSubtarget.h"

using namespace llvm;

class OneDAGToDAGISel : public SelectionDAGISel {
public:
    explicit OneDAGToDAGISel(OneTargetMachine &TM, CodeGenOptLevel OL)
        : SelectionDAGISel(TM, OL), Subtarget(nullptr) {}
    
    bool runOnMachineFunction(MachineFunction &MF) override {
        Subtarget = &MF.getSubtarget<OneSubtarget>();
        return SelectionDAGISel::runOnMachineFunction(MF);
    }
    
    void Select(SDNode *N) override;
    bool SelectAddr(SDValue Addr, SDValue &Base, SDValue &Offset);
    
private:
    const OneSubtarget *Subtarget;
    
    // 包含自动生成的指令选择代码
    #include "OneGenDAGISel.inc"
};

void OneDAGToDAGISel::Select(SDNode *Node) {
    // 跳过已选择的节点
    if (Node->isMachineOpcode()) {
        Node->setNodeId(-1);
        return;
    }
    
    // 首先尝试使用自动生成的模式选择
    if (SelectCode(Node))
        return;
    
    // 手动处理特殊情况
    switch (Node->getOpcode()) {
    default:
        break;
    case ISD::Constant: {
        ConstantSDNode *CN = cast<ConstantSDNode>(Node);
        SDLoc DL(Node);
        int64_t Imm = CN->getSExtValue();
        
        // 如果立即数适合12位，使用ADDI和零寄存器
        if (isInt<12>(Imm)) {
            SDValue TargetImm = CurDAG->getTargetConstant(Imm, DL, MVT::i32);
            SDNode *Result = CurDAG->getMachineNode(One::ADDI, DL, MVT::i32, 
                                                   CurDAG->getRegister(One::ZERO, MVT::i32), 
                                                   TargetImm);
            ReplaceNode(Node, Result);
            return;
        }
        break;
    }
    case ISD::FrameIndex: {
        // 处理栈帧引用
        int FI = cast<FrameIndexSDNode>(Node)->getIndex();
        SDLoc DL(Node);
        SDValue TFI = CurDAG->getTargetFrameIndex(FI, MVT::i32);
        SDValue Zero = CurDAG->getRegister(One::ZERO, MVT::i32);
        SDNode *Result = CurDAG->getMachineNode(One::ADDI, DL, MVT::i32, Zero, TFI);
        ReplaceNode(Node, Result);
        return;
    }
    }
    
    // 回退到默认选择
    SelectCode(Node);
}

bool OneDAGToDAGISel::SelectAddr(SDValue Addr, SDValue &Base, SDValue &Offset) {
    // 尝试匹配基址+立即数偏移寻址
    if (CurDAG->isBaseWithConstantOffset(Addr)) {
        ConstantSDNode *CN = dyn_cast<ConstantSDNode>(Addr.getOperand(1));
        if (CN && isInt<12>(CN->getSExtValue())) {
            Base = Addr.getOperand(0);
            Offset = CurDAG->getTargetConstant(CN->getSExtValue(), SDLoc(Addr), MVT::i32);
            return true;
        }
    }
    
    // 回退：基址=地址，偏移=0
    Base = Addr;
    Offset = CurDAG->getTargetConstant(0, SDLoc(Addr), MVT::i32);
    return true;
}
```

## 第7部分：汇编生成

### 汇编打印器实现（OneAsmPrinter.cpp）

```cpp
// OneAsmPrinter.cpp - 生成汇编输出
#include "OneAsmPrinter.h"
#include "One.h"
#include "OneInstrInfo.h"
#include "OneTargetMachine.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCStreamer.h"

using namespace llvm;

void OneAsmPrinter::emitInstruction(const MachineInstr *MI) {
    // 将MachineInstr转换为MCInst
    MCInst TmpInst;
    LowerOneInstToMCInst(MI, TmpInst);
    
    // 发射MCInst
    EmitToStreamer(*OutStreamer, TmpInst);
}

void OneAsmPrinter::LowerOneInstToMCInst(const MachineInstr *MI, MCInst &OutMI) {
    OutMI.setOpcode(MI->getOpcode());
    
    for (const MachineOperand &MO : MI->operands()) {
        MCOperand MCOp;
        
        switch (MO.getType()) {
        case MachineOperand::MO_Register:
            MCOp = MCOperand::createReg(MO.getReg());
            break;
        case MachineOperand::MO_Immediate:
            MCOp = MCOperand::createImm(MO.getImm());
            break;
        case MachineOperand::MO_GlobalAddress:
            MCOp = MCOperand::createExpr(MCSymbolRefExpr::create(
                getSymbol(MO.getGlobal()), OutContext));
            break;
        default:
            llvm_unreachable("unknown operand type");
        }
        
        OutMI.addOperand(MCOp);
    }
}

void OneAsmPrinter::printOperand(const MachineInstr *MI, int OpNum, raw_ostream &O) {
    const MachineOperand &MO = MI->getOperand(OpNum);
    
    switch (MO.getType()) {
    case MachineOperand::MO_Register:
        O << OneInstPrinter::getRegisterName(MO.getReg());
        break;
    case MachineOperand::MO_Immediate:
        O << MO.getImm();
        break;
    default:
        llvm_unreachable("not implemented");
    }
}
```

## 第8部分：目标机器配置

### 目标机器实现（OneTargetMachine.cpp）

```cpp
// OneTargetMachine.cpp - 目标机器设置
#include "OneTargetMachine.h"
#include "One.h"
#include "OneSubtarget.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/MC/TargetRegistry.h"

using namespace llvm;

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeOneTarget() {
    // 注册目标
    RegisterTargetMachine<OneTargetMachine> X(getTheOneTarget());
    
    // 注册pass
    auto *PR = PassRegistry::getPassRegistry();
    initializeOneDAGToDAGISelLegacyPass(*PR);
}

static StringRef computeDataLayout() {
    // 为我们的32位RISC-V目标定义数据布局
    return "e-m:e-p:32:32-i64:64-n32-S128";
    // e = 小端序
    // m:e = ELF名称修饰
    // p:32:32 = 指针是32位，32位对齐
    // i64:64 = 64位整数有64位对齐
    // n32 = 原生整数宽度是32位
    // S128 = 栈对齐是128位
}

OneTargetMachine::OneTargetMachine(const Target &T, const Triple &TT,
                                   StringRef CPU, StringRef FS,
                                   const TargetOptions &Options,
                                   std::optional<Reloc::Model> RM,
                                   std::optional<CodeModel::Model> CM,
                                   CodeGenOptLevel OL, bool JIT)
    : LLVMTargetMachine(T, computeDataLayout(), TT, CPU, FS, Options,
                        RM.value_or(Reloc::Static),
                        CM.value_or(CodeModel::Small), OL),
      TLOF(std::make_unique<TargetLoweringObjectFileELF>()),
      Subtarget(TT, CPU, FS, *this) {
    initAsmInfo();
}

TargetPassConfig *OneTargetMachine::createPassConfig(PassManagerBase &PM) {
    return new OnePassConfig(*this, PM);
}

namespace {
class OnePassConfig : public TargetPassConfig {
public:
    OnePassConfig(OneTargetMachine &TM, PassManagerBase &PM)
        : TargetPassConfig(TM, PM) {}
    
    OneTargetMachine &getOneTargetMachine() const {
        return getTM<OneTargetMachine>();
    }
    
    bool addInstSelector() override {
        addPass(createOneISelDag(getOneTargetMachine(), getOptLevel()));
        return false;
    }
};
}

FunctionPass *llvm::createOneISelDag(OneTargetMachine &TM, CodeGenOptLevel OptLevel) {
    return new OneDAGToDAGISelLegacy(TM, OptLevel);
}
```

## 第9部分：与LLVM集成

### 目标注册

```cpp
// TargetInfo/OneTargetInfo.cpp - 目标注册
#include "TargetInfo/OneTargetInfo.h"
#include "llvm/MC/TargetRegistry.h"

using namespace llvm;

Target &llvm::getTheOneTarget() {
    static Target TheOneTarget;
    return TheOneTarget;
}

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeOneTargetInfo() {
    RegisterTarget<Triple::one> X(getTheOneTarget(), "one", "One", "One");
}
```

### CMake集成

```cmake
# CMakeLists.txt for the One target
set(LLVM_TARGET_DEFINITIONS One.td)

tablegen(LLVM OneGenRegisterInfo.inc -gen-register-info)
tablegen(LLVM OneGenInstrInfo.inc -gen-instr-info)
tablegen(LLVM OneGenDAGISel.inc -gen-dag-isel)
tablegen(LLVM OneGenCallingConv.inc -gen-callingconv)
tablegen(LLVM OneGenSubtargetInfo.inc -gen-subtarget)

add_public_tablegen_target(OneCommonTableGen)

add_llvm_target(OneCodeGen
    OneAsmPrinter.cpp
    OneISelDAGToDAG.cpp
    OneISelLowering.cpp
    OneInstrInfo.cpp
    OneFrameLowering.cpp
    OneRegisterInfo.cpp
    OneSubtarget.cpp
    OneTargetMachine.cpp
    OneCallingConv.cpp
)

add_subdirectory(TargetInfo)
add_subdirectory(MCTargetDesc)
```

## 第10部分：测试和集成

### 测试后端

```cpp
// test_backend.cpp - 测试完整后端
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/CodeGen/CodeGenPassBuilder.h"

void TestBackend() {
    LLVMContext Context;
    Module M("test", Context);
    IRBuilder<> Builder(Context);
    
    // 创建简单函数：int add(int a, int b) { return a + b; }
    FunctionType *FT = FunctionType::get(Builder.getInt32Ty(), 
                                        {Builder.getInt32Ty(), Builder.getInt32Ty()}, 
                                        false);
    Function *F = Function::Create(FT, Function::ExternalLinkage, "add", M);
    
    BasicBlock *BB = BasicBlock::Create(Context, "entry", F);
    Builder.SetInsertPoint(BB);
    
    auto Args = F->arg_begin();
    Value *A = &*Args++;
    Value *B = &*Args;
    Value *Sum = Builder.CreateAdd(A, B, "sum");
    Builder.CreateRet(Sum);
    
    // 用我们的后端编译
    std::string TargetTriple = "one-unknown-unknown";
    std::string Error;
    const Target *TheTarget = TargetRegistry::lookupTarget(TargetTriple, Error);
    
    if (!TheTarget) {
        std::cerr << "Error: " << Error << std::endl;
        return;
    }
    
    TargetOptions Opt;
    auto RM = std::optional<Reloc::Model>();
    std::unique_ptr<TargetMachine> TM(TheTarget->createTargetMachine(
        TargetTriple, "generic", "", Opt, RM));
    
    // 生成汇编
    std::string AsmStr;
    raw_string_ostream OS(AsmStr);
    
    legacy::PassManager PM;
    if (TM->addPassesToEmitFile(PM, OS, nullptr, CGFT_AssemblyFile)) {
        std::cerr << "Target machine can't emit assembly" << std::endl;
        return;
    }
    
    PM.run(M);
    std::cout << "Generated Assembly:\n" << OS.str() << std::endl;
}
```

### 期望的汇编输出

```asm
add:
    add a0, a0, a1    # a0 = a0 + a1 (sum = a + b)
    ret               # return a0
```

## 总结：您学到了什么

现在您知道如何：

1. **使用TableGen DSL设计完整的目标描述**
2. **定义指令集**包括适当的编码和模式
3. **为函数调用和返回实现调用约定**
4. **用模式匹配和自定义逻辑构建指令选择**
5. **处理寄存器分配**包括寄存器类和约束
6. **生成汇编输出**包括适当的格式和语法
7. **与LLVM基础设施集成**以获得完整的后端支持

**您掌握的关键LLVM后端概念：**

- **TableGen**：声明式目标描述语言
- **SelectionDAG**：LLVM的指令选择表示
- **调用约定**：函数调用的ABI实现
- **寄存器类**：为分配对寄存器分组
- **指令模式**：将IR操作映射到机器指令
- **目标机器**：整体后端配置和pass管道

**下一步：**

- **优化**：添加目标特定的优化pass
- **调试**：实现DWARF调试信息生成
- **高级功能**：向量指令、浮点、自定义调用约定
- **性能**：指令调度、高级寄存器分配

您现在有了一个完整的、工作的RISC-V后端，可以从LLVM IR生成汇编代码！