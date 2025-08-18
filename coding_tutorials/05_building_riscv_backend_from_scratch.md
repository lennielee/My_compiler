# Coding Tutorial 5: Building a RISC-V Backend from Scratch

## Learning Objectives
- Understand how LLVM backend architecture works in practice
- Write TableGen descriptions for a complete RISC-V32I instruction set
- Implement instruction selection with pattern matching
- Build calling conventions and register allocation
- Create a complete backend that generates assembly code
- Integrate the backend with LLVM's compilation pipeline

## Part 1: Understanding LLVM Backend Architecture

### What Does a Backend Do?

The backend transforms **platform-independent** LLVM IR into **platform-specific** machine code:

```
LLVM IR → Instruction Selection → Register Allocation → Assembly Generation → Machine Code
```

**Key Responsibilities:**
1. **Instruction Selection**: Map IR operations to target instructions
2. **Register Allocation**: Assign virtual registers to physical registers
3. **Calling Conventions**: Handle function calls and parameter passing
4. **Code Layout**: Organize instructions for optimal execution
5. **Assembly Emission**: Generate human-readable assembly code

### LLVM Backend Components

```
Target Description (TableGen)
├── Register Definitions
├── Instruction Definitions  
├── Calling Conventions
└── Instruction Formats

C++ Implementation
├── Instruction Selection (DAGToDAG)
├── Lowering (IR → SelectionDAG)
├── Target Machine Configuration
├── Assembly Printer
└── Frame Lowering (Stack management)
```

## Part 2: Setting Up the Target Infrastructure

### Target Directory Structure

```
backEnd/One/                          # Our RISC-V target
├── One.td                           # Main target definition
├── OneRegisterInfo.td/.cpp/.h       # Register descriptions
├── OneInstrInfo.td/.cpp/.h          # Instruction definitions
├── OneInstrFormats.td               # Instruction format classes
├── OneCallingConv.td/.cpp/.h        # Function call ABI
├── OneISelDAGToDAG.cpp             # Instruction selection
├── OneISelLowering.cpp/.h          # IR lowering to SelectionDAG
├── OneTargetMachine.cpp/.h         # Target configuration
├── OneAsmPrinter.cpp/.h            # Assembly generation
├── OneFrameLowering.cpp/.h         # Stack frame management
└── MCTargetDesc/                   # Machine code description
    ├── OneMCTargetDesc.cpp/.h      # Target registration
    ├── OneMCAsmInfo.cpp/.h         # Assembly syntax
    └── OneInstPrinter.cpp/.h       # Instruction printing
```

### Main Target Definition (One.td)

```tablegen
// One.td - Main target definition
include "llvm/Target/Target.td"

// Include all component definitions
include "OneRegisterInfo.td"
include "OneInstrInfo.td"
include "OneCallingConv.td"

// Define the processor model
def : ProcessorModel<"one", NoSchedModel, []>;

// Define instruction info
def OneInstrInfo : InstrInfo;

// Define the target
def One : Target {
    let InstructionSet = OneInstrInfo;
}
```

## Part 3: Register Definitions and Management

### RISC-V Register Architecture

RISC-V32I has 32 general-purpose registers:
- `x0` (zero): Always reads as 0, writes ignored
- `x1` (ra): Return address
- `x2` (sp): Stack pointer
- `x3` (gp): Global pointer
- `x4` (tp): Thread pointer
- `x5-x7` (t0-t2): Temporary registers
- `x8-x9` (s0-s1): Saved registers
- `x10-x17` (a0-a7): Argument/return registers
- `x18-x27` (s2-s11): Saved registers
- `x28-x31` (t3-t6): Temporary registers

### Register Definitions (OneRegisterInfo.td)

```tablegen
// OneRegisterInfo.td - RISC-V register definitions

class OneReg<bits<5> Enc, string n> : Register<n> {
    let HWEncoding = Enc;    // Hardware encoding (5 bits for RISC-V)
    let Namespace = "One";
}

// Define individual registers with their encodings
def ZERO : OneReg<0,  "zero">, DwarfRegNum<[0]>;
def RA   : OneReg<1,  "ra">,   DwarfRegNum<[1]>;
def SP   : OneReg<2,  "sp">,   DwarfRegNum<[2]>;
def GP   : OneReg<3,  "gp">,   DwarfRegNum<[3]>;
def TP   : OneReg<4,  "tp">,   DwarfRegNum<[4]>;

// Temporary registers
def T0   : OneReg<5,  "t0">,   DwarfRegNum<[5]>;
def T1   : OneReg<6,  "t1">,   DwarfRegNum<[6]>;
def T2   : OneReg<7,  "t2">,   DwarfRegNum<[7]>;

// Saved registers  
def S0   : OneReg<8,  "s0">,   DwarfRegNum<[8]>;
def S1   : OneReg<9,  "s1">,   DwarfRegNum<[9]>;

// Argument/return registers
def A0   : OneReg<10, "a0">,   DwarfRegNum<[10]>;
def A1   : OneReg<11, "a1">,   DwarfRegNum<[11]>;
def A2   : OneReg<12, "a2">,   DwarfRegNum<[12]>;
def A3   : OneReg<13, "a3">,   DwarfRegNum<[13]>;
def A4   : OneReg<14, "a4">,   DwarfRegNum<[14]>;
def A5   : OneReg<15, "a5">,   DwarfRegNum<[15]>;
def A6   : OneReg<16, "a6">,   DwarfRegNum<[16]>;
def A7   : OneReg<17, "a7">,   DwarfRegNum<[17]>;

// Register class for 32-bit general-purpose registers
def GPR : RegisterClass<"One", [i32], 32, (add
    // Order matters for register allocation preference
    ZERO, RA, SP,                    // Special registers
    A0, A1, A2, A3, A4, A5, A6, A7,  // Argument registers (caller-saved)
    T0, T1, T2,                      // Temporary registers (caller-saved)
    S0, S1                           // Saved registers (callee-saved)
)>;
```

### Register Info Implementation (OneRegisterInfo.cpp)

```cpp
// OneRegisterInfo.cpp - Register information implementation
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
    // Define which registers must be preserved across function calls
    static const MCPhysReg CalleeSavedRegs[] = {
        One::RA,  // Return address
        One::S0,  // Saved register 0
        One::S1,  // Saved register 1
        0         // Terminator
    };
    return CalleeSavedRegs;
}

BitVector OneRegisterInfo::getReservedRegs(const MachineFunction &MF) const {
    BitVector Reserved(getNumRegs());
    
    // Mark special registers as reserved (not available for allocation)
    Reserved.set(One::ZERO);  // Always zero
    Reserved.set(One::RA);    // Return address
    Reserved.set(One::SP);    // Stack pointer
    Reserved.set(One::GP);    // Global pointer
    Reserved.set(One::TP);    // Thread pointer
    
    return Reserved;
}

void OneRegisterInfo::eliminateFrameIndex(MachineBasicBlock::iterator II,
                                         int SPAdj, unsigned FIOperandNum,
                                         RegScavenger *RS) const {
    // Convert frame index references to actual stack offsets
    MachineInstr &MI = *II;
    MachineFunction &MF = *MI.getParent()->getParent();
    MachineFrameInfo &MFI = MF.getFrameInfo();
    
    int FrameIndex = MI.getOperand(FIOperandNum).getIndex();
    int64_t Offset = MFI.getObjectOffset(FrameIndex);
    
    // Replace frame index with base register + offset
    MI.getOperand(FIOperandNum).ChangeToRegister(One::SP, false);
    MI.getOperand(FIOperandNum + 1).ChangeToImmediate(Offset);
}
```

## Part 4: Instruction Formats and Definitions

### RISC-V Instruction Formats

RISC-V has several instruction formats. Let's implement the main ones:

```tablegen
// OneInstrFormats.td - Instruction format definitions

class OneInst<dag outs, dag ins, string asmstr, list<dag> pattern>
    : Instruction {
    field bits<32> Inst;      // 32-bit instruction encoding
    field bits<32> SoftFail = 0;
    
    let Size = 4;             // All instructions are 4 bytes
    let Namespace = "One";
    
    dag OutOperandList = outs;
    dag InOperandList = ins;
    let AsmString = asmstr;
    let Pattern = pattern;
}

// R-type: Register-register operations
// Format: funct7[31:25] rs2[24:20] rs1[19:15] funct3[14:12] rd[11:7] opcode[6:0]
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

// I-type: Immediate operations
// Format: imm[31:20] rs1[19:15] funct3[14:12] rd[11:7] opcode[6:0]
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

// S-type: Store operations
// Format: imm[31:25] rs2[24:20] rs1[19:15] funct3[14:12] imm[11:7] opcode[6:0]
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

// Convenience classes for specific instruction types
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

### Immediate Operand Definitions

```tablegen
// Define immediate operand types with range constraints
def simm12 : Operand<i32>, ImmLeaf<i32, [{ return isInt<12>(Imm); }]>;
def uimm20 : Operand<i32>, ImmLeaf<i32, [{ return isUInt<20>(Imm); }]>;

// Address operands for memory operations
def addr : ComplexPattern<iPTR, 2, "SelectAddr", [frameindex], []>;
```

### Core Instruction Definitions (OneInstrInfo.td)

```tablegen
// OneInstrInfo.td - Instruction definitions
include "OneInstrFormats.td"

//===----------------------------------------------------------------------===//
// Arithmetic Instructions
//===----------------------------------------------------------------------===//

// Register-register arithmetic
def ADD  : ArithR<0b0000000, 0b000, "add",  add>;
def SUB  : ArithR<0b0100000, 0b000, "sub",  sub>;
def MUL  : ArithR<0b0000001, 0b000, "mul",  mul>;
def DIV  : ArithR<0b0000001, 0b100, "div",  sdiv>;
def REM  : ArithR<0b0000001, 0b110, "rem",  srem>;

// Logical operations
def AND  : ArithR<0b0000000, 0b111, "and",  and>;
def OR   : ArithR<0b0000000, 0b110, "or",   or>;
def XOR  : ArithR<0b0000000, 0b100, "xor",  xor>;

// Shift operations
def SLL  : ArithR<0b0000000, 0b001, "sll",  shl>;
def SRL  : ArithR<0b0000000, 0b101, "srl",  srl>;
def SRA  : ArithR<0b0100000, 0b101, "sra",  sra>;

// Immediate arithmetic
def ADDI : ArithI<0b000, "addi", add>;
def ANDI : ArithI<0b111, "andi", and>;
def ORI  : ArithI<0b110, "ori",  or>;
def XORI : ArithI<0b100, "xori", xor>;

// Immediate shifts (special encoding)
def SLLI : IInst<0b001, 0b0010011,
               (outs GPR:$rd), (ins GPR:$rs1, uimm5:$shamt),
               "slli\t$rd, $rs1, $shamt",
               [(set GPR:$rd, (shl GPR:$rs1, uimm5:$shamt))]> {
    bits<5> shamt;
    let Inst{31-25} = 0b0000000;
    let Inst{24-20} = shamt;
}

//===----------------------------------------------------------------------===//
// Load/Store Instructions
//===----------------------------------------------------------------------===//

// Load instructions
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

// Store instructions
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
// Comparison Instructions
//===----------------------------------------------------------------------===//

def SLT  : ArithR<0b0000000, 0b010, "slt",  setlt>;
def SLTU : ArithR<0b0000000, 0b011, "sltu", setult>;

def SLTI  : ArithI<0b010, "slti",  setlt>;
def SLTIU : ArithI<0b011, "sltiu", setult>;

//===----------------------------------------------------------------------===//
// Branch Instructions
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
// Jump Instructions
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
// Pseudo Instructions
//===----------------------------------------------------------------------===//

// Common assembly aliases and pseudo instructions
def : InstAlias<"mv $rd, $rs", (ADDI GPR:$rd, GPR:$rs, 0)>;
def : InstAlias<"li $rd, $imm", (ADDI GPR:$rd, ZERO, simm12:$imm)>;
def : InstAlias<"nop", (ADDI ZERO, ZERO, 0)>;
def : InstAlias<"ret", (JALR ZERO, RA, 0)>;

// Pattern for loading constants
def : Pat<(i32 simm12:$imm), (ADDI ZERO, simm12:$imm)>;

// Patterns for comparisons that set a register
def : Pat<(seteq GPR:$rs1, GPR:$rs2), 
          (SLTIU (XOR GPR:$rs1, GPR:$rs2), 1)>;
def : Pat<(setne GPR:$rs1, GPR:$rs2), 
          (SLTU ZERO, (XOR GPR:$rs1, GPR:$rs2))>;
```

## Part 5: Calling Conventions

### Function Call ABI Implementation

```tablegen
// OneCallingConv.td - Calling convention definitions

// Return value convention
def RetCC_One : CallingConv<[
    // i32 return values go in a0, a1
    CCIfType<[i32], CCAssignToReg<[A0, A1]>>,
    
    // Larger return values go to memory
    CCAssignToStack<4, 4>
]>;

// Argument passing convention
def CC_One : CallingConv<[
    // First 8 integer arguments go in registers a0-a7
    CCIfType<[i32], CCAssignToReg<[A0, A1, A2, A3, A4, A5, A6, A7]>>,
    
    // Remaining arguments go on stack with 4-byte alignment
    CCAssignToStack<4, 4>
]>;

// Callee-saved registers (must be preserved across calls)
def CSR : CalleeSavedRegs<(add RA, S0, S1)>;
```

### Calling Convention Implementation (OneCallingConv.cpp)

```cpp
// OneCallingConv.cpp - Calling convention implementation
#include "OneCallingConv.h"
#include "One.h"

using namespace llvm;

// Include auto-generated calling convention code
#include "OneGenCallingConv.inc"

// Custom calling convention logic if needed
static bool CC_One_Custom(unsigned ValNo, MVT ValVT, MVT LocVT,
                         CCValAssign::LocInfo LocInfo,
                         ISD::ArgFlagsTy ArgFlags, CCState &State) {
    // Custom logic for special cases
    // For now, use the standard generated logic
    return CC_One(ValNo, ValVT, LocVT, LocInfo, ArgFlags, State);
}
```

## Part 6: Instruction Selection Implementation

### IR Lowering (OneISelLowering.cpp)

```cpp
// OneISelLowering.cpp - Convert LLVM IR to SelectionDAG
#include "OneISelLowering.h"
#include "One.h"
#include "OneSubtarget.h"
#include "llvm/CodeGen/CallingConvLower.h"
#include "llvm/CodeGen/MachineFrameInfo.h"

using namespace llvm;

OneTargetLowering::OneTargetLowering(const TargetMachine &TM,
                                     const OneSubtarget &STI)
    : TargetLowering(TM), Subtarget(STI) {
    
    // Register the register class for i32 type
    addRegisterClass(MVT::i32, &One::GPRRegClass);
    
    // Set operation actions - how to handle various IR operations
    setOperationAction(ISD::GlobalAddress, MVT::i32, Custom);
    setOperationAction(ISD::ConstantPool, MVT::i32, Custom);
    setOperationAction(ISD::JumpTable, MVT::i32, Custom);
    
    // Expand complex operations to simpler ones
    setOperationAction(ISD::BR_CC, MVT::i32, Expand);
    setOperationAction(ISD::SELECT_CC, MVT::i32, Expand);
    setOperationAction(ISD::SETCC, MVT::i32, Expand);
    
    // Compute register properties
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
    
    // For simplicity, use direct addressing
    // In a real implementation, you'd handle different addressing modes
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
    
    // Analyze call operands
    SmallVector<CCValAssign, 16> ArgLocs;
    CCState CCInfo(CallConv, IsVarArg, MF, ArgLocs, *DAG.getContext());
    CCInfo.AnalyzeCallOperands(Outs, CC_One);
    
    // Process arguments
    SmallVector<std::pair<unsigned, SDValue>> RegsToPass;
    SDValue StackPtr;
    
    for (unsigned i = 0, e = ArgLocs.size(); i != e; ++i) {
        CCValAssign &VA = ArgLocs[i];
        SDValue Arg = OutVals[i];
        
        if (VA.isRegLoc()) {
            // Argument goes in register
            RegsToPass.push_back(std::make_pair(VA.getLocReg(), Arg));
        } else {
            // Argument goes on stack
            assert(VA.isMemLoc());
            
            if (!StackPtr.getNode()) {
                StackPtr = DAG.getCopyFromReg(Chain, DL, One::SP, getPointerTy(DAG.getDataLayout()));
            }
            
            SDValue PtrOff = DAG.getIntPtrConstant(VA.getLocMemOffset(), DL);
            PtrOff = DAG.getNode(ISD::ADD, DL, getPointerTy(DAG.getDataLayout()), StackPtr, PtrOff);
            
            Chain = DAG.getStore(Chain, DL, Arg, PtrOff, MachinePointerInfo::getStack(MF, VA.getLocMemOffset()));
        }
    }
    
    // Build the call instruction
    SDValue InFlag;
    for (auto &Reg : RegsToPass) {
        Chain = DAG.getCopyToReg(Chain, DL, Reg.first, Reg.second, InFlag);
        InFlag = Chain.getValue(1);
    }
    
    // Create the call node
    std::vector<EVT> NodeTys;
    NodeTys.push_back(MVT::Other);  // Chain
    NodeTys.push_back(MVT::Glue);   // Flag
    
    if (InFlag.getNode()) {
        CallOperands.push_back(InFlag);
    }
    
    SDVTList NodeTys = DAG.getVTList(MVT::Other, MVT::Glue);
    Chain = DAG.getNode(OneISD::CALL, DL, NodeTys, CallOperands);
    InFlag = Chain.getValue(1);
    
    // Handle return values
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

### Instruction Selection (OneISelDAGToDAG.cpp)

```cpp
// OneISelDAGToDAG.cpp - Instruction selection
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
    
    // Include auto-generated instruction selection code
    #include "OneGenDAGISel.inc"
};

void OneDAGToDAGISel::Select(SDNode *Node) {
    // Skip nodes that are already selected
    if (Node->isMachineOpcode()) {
        Node->setNodeId(-1);
        return;
    }
    
    // Try to select using auto-generated patterns first
    if (SelectCode(Node))
        return;
    
    // Handle special cases manually
    switch (Node->getOpcode()) {
    default:
        break;
    case ISD::Constant: {
        ConstantSDNode *CN = cast<ConstantSDNode>(Node);
        SDLoc DL(Node);
        int64_t Imm = CN->getSExtValue();
        
        // If immediate fits in 12 bits, use ADDI with zero register
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
        // Handle stack frame references
        int FI = cast<FrameIndexSDNode>(Node)->getIndex();
        SDLoc DL(Node);
        SDValue TFI = CurDAG->getTargetFrameIndex(FI, MVT::i32);
        SDValue Zero = CurDAG->getRegister(One::ZERO, MVT::i32);
        SDNode *Result = CurDAG->getMachineNode(One::ADDI, DL, MVT::i32, Zero, TFI);
        ReplaceNode(Node, Result);
        return;
    }
    }
    
    // Fallback to default selection
    SelectCode(Node);
}

bool OneDAGToDAGISel::SelectAddr(SDValue Addr, SDValue &Base, SDValue &Offset) {
    // Try to match base + immediate offset addressing
    if (CurDAG->isBaseWithConstantOffset(Addr)) {
        ConstantSDNode *CN = dyn_cast<ConstantSDNode>(Addr.getOperand(1));
        if (CN && isInt<12>(CN->getSExtValue())) {
            Base = Addr.getOperand(0);
            Offset = CurDAG->getTargetConstant(CN->getSExtValue(), SDLoc(Addr), MVT::i32);
            return true;
        }
    }
    
    // Fallback: base = address, offset = 0
    Base = Addr;
    Offset = CurDAG->getTargetConstant(0, SDLoc(Addr), MVT::i32);
    return true;
}
```

## Part 7: Assembly Generation

### Assembly Printer Implementation (OneAsmPrinter.cpp)

```cpp
// OneAsmPrinter.cpp - Generate assembly output
#include "OneAsmPrinter.h"
#include "One.h"
#include "OneInstrInfo.h"
#include "OneTargetMachine.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCStreamer.h"

using namespace llvm;

void OneAsmPrinter::emitInstruction(const MachineInstr *MI) {
    // Convert MachineInstr to MCInst
    MCInst TmpInst;
    LowerOneInstToMCInst(MI, TmpInst);
    
    // Emit the MCInst
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

## Part 8: Target Machine Configuration

### Target Machine Implementation (OneTargetMachine.cpp)

```cpp
// OneTargetMachine.cpp - Target machine setup
#include "OneTargetMachine.h"
#include "One.h"
#include "OneSubtarget.h"
#include "llvm/CodeGen/TargetPassConfig.h"
#include "llvm/MC/TargetRegistry.h"

using namespace llvm;

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeOneTarget() {
    // Register the target
    RegisterTargetMachine<OneTargetMachine> X(getTheOneTarget());
    
    // Register passes
    auto *PR = PassRegistry::getPassRegistry();
    initializeOneDAGToDAGISelLegacyPass(*PR);
}

static StringRef computeDataLayout() {
    // Define the data layout for our 32-bit RISC-V target
    return "e-m:e-p:32:32-i64:64-n32-S128";
    // e = little endian
    // m:e = ELF mangling
    // p:32:32 = pointers are 32 bits with 32-bit alignment
    // i64:64 = 64-bit integers have 64-bit alignment
    // n32 = native integer width is 32 bits
    // S128 = stack alignment is 128 bits
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

## Part 9: Integration with LLVM

### Target Registration

```cpp
// TargetInfo/OneTargetInfo.cpp - Target registration
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

### CMake Integration

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

## Part 10: Testing and Integration

### Testing the Backend

```cpp
// test_backend.cpp - Test the complete backend
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/CodeGen/CodeGenPassBuilder.h"

void TestBackend() {
    LLVMContext Context;
    Module M("test", Context);
    IRBuilder<> Builder(Context);
    
    // Create a simple function: int add(int a, int b) { return a + b; }
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
    
    // Compile with our backend
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
    
    // Generate assembly
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

### Expected Assembly Output

```asm
add:
    add a0, a0, a1    # a0 = a0 + a1 (sum = a + b)
    ret               # return a0
```

## Summary: What You've Learned

You now know how to:

1. **Design complete target descriptions** using TableGen DSL
2. **Define instruction sets** with proper encodings and patterns
3. **Implement calling conventions** for function calls and returns
4. **Build instruction selection** with pattern matching and custom logic
5. **Handle register allocation** with register classes and constraints
6. **Generate assembly output** with proper formatting and syntax
7. **Integrate with LLVM** infrastructure for complete backend support

**Key LLVM Backend Concepts You Mastered:**
- **TableGen**: Declarative target description language
- **SelectionDAG**: LLVM's instruction selection representation
- **Calling Conventions**: ABI implementation for function calls
- **Register Classes**: Grouping registers for allocation
- **Instruction Patterns**: Mapping IR operations to machine instructions
- **Target Machine**: Overall backend configuration and pass pipeline

**Next Steps:**
- **Optimization**: Add target-specific optimization passes
- **Debugging**: Implement DWARF debug information generation
- **Advanced Features**: Vector instructions, floating-point, custom calling conventions
- **Performance**: Instruction scheduling, advanced register allocation

You now have a complete, working RISC-V backend that can generate assembly code from LLVM IR!