# Chapter 3, Lesson 6: Backend RISC-V Architecture - From LLVM IR to Machine Code

## Learning Objectives
- Understand the role and structure of a compiler backend
- Learn how LLVM's target description language (TableGen) works
- See how LLVM IR gets transformed into RISC-V assembly code
- Understand the complete compilation pipeline from C to executable

## Explanation

The backend is where the **magic of machine code generation** happens. While the frontend transforms C code into LLVM IR, the backend takes that IR and generates **actual machine instructions** that can run on real hardware. Our backend targets **RISC-V32I**, a clean, modern instruction set architecture perfect for learning.

## What is a Compiler Backend?

The backend is the **final stage** of compilation that transforms platform-independent intermediate representation into platform-specific machine code:

```
LLVM IR → Instruction Selection → Register Allocation → Assembly Generation → Machine Code
```

### Backend Responsibilities
1. **Instruction Selection**: Choose appropriate machine instructions for IR operations
2. **Register Allocation**: Assign virtual registers to physical CPU registers  
3. **Code Layout**: Organize instructions for optimal execution
4. **ABI Compliance**: Follow calling conventions and data layout rules
5. **Optimization**: Target-specific optimizations (instruction scheduling, etc.)

## Why RISC-V?

RISC-V is an excellent target for learning because:
- **Simple, regular instruction set**: Easy to understand patterns
- **Open standard**: No licensing restrictions, free to use and modify
- **Modern design**: Incorporates lessons from decades of processor design
- **Growing ecosystem**: Used in real products and research
- **Clean architecture**: 32-bit base instruction set (RV32I) is minimal yet complete

### RISC-V32I Overview
- **32-bit architecture**: 32-bit registers and address space
- **32 registers**: `x0-x31` with specific naming conventions
- **Fixed 32-bit instructions**: Simple decoding
- **Load-store architecture**: Only load/store access memory
- **Three instruction formats**: R-type, I-type, U-type (plus others)

## LLVM Backend Architecture

Our backend integrates with LLVM's sophisticated code generation framework:

```
LLVM IR
    ↓
Selection DAG (Directed Acyclic Graph)
    ↓
Instruction Selection (Pattern Matching)
    ↓
Register Allocation (Virtual → Physical)
    ↓
Assembly Emission (Text Generation)
    ↓
RISC-V Assembly
```

## Backend File Structure

The backend follows LLVM's standard target structure:

### Core Components
```
backEnd/One/
├── One.td                    # Main target definition
├── OneRegisterInfo.td/.cpp   # CPU register descriptions  
├── OneInstrInfo.td/.cpp      # Instruction definitions
├── OneInstrFormats.td        # Instruction format classes
├── OneCallingConv.td/.cpp    # Function call ABI
├── OneISelDAGToDAG.cpp       # Instruction selection
├── OneISelLowering.cpp       # Lowering LLVM IR to SelectionDAG
├── OneTargetMachine.cpp      # Target configuration
├── OneAsmPrinter.cpp         # Assembly text generation
├── OneFrameLowering.cpp      # Stack frame management
└── MCTargetDesc/             # Machine code description
    ├── OneMCAsmInfo.cpp      # Assembly syntax info
    ├── OneMCTargetDesc.cpp   # Target registration
    └── OneInstPrinter.cpp    # Instruction printing
```

### Integration Files
```
backEnd/
├── Triple.h                  # Target enumeration (LLVM modification)
└── Triple.cpp                # Target identification (LLVM modification)
```

## TableGen Target Description

LLVM uses **TableGen**, a domain-specific language, to describe targets declaratively.

### Main Target Definition (One.td)
```tablegen
include "llvm/Target/Target.td"

include "OneRegisterInfo.td"     // Register descriptions
include "OneInstrInfo.td"        // Instruction definitions  
include "OneCallingConv.td"      // Calling conventions

def : ProcessorModel<"one", NoSchedModel, []>;

def OneInstrInfo : InstrInfo;

def One : Target {
    let InstructionSet = OneInstrInfo;
}
```

This concise definition pulls together all target components.

## Register Definitions

### RISC-V Register Set (OneRegisterInfo.td)
```tablegen
class OneReg<string n> : Register<n> {
    let Namespace = "One";
}

// RISC-V32I Registers
def ZERO  : OneReg<"zero">, DwarfRegNum<[0]>;   // Always reads as 0
def RA    : OneReg<"ra">, DwarfRegNum<[1]>;     // Return address
def SP    : OneReg<"sp">, DwarfRegNum<[2]>;     // Stack pointer
def GP    : OneReg<"gp">, DwarfRegNum<[3]>;     // Global pointer
def TP    : OneReg<"tp">, DwarfRegNum<[4]>;     // Thread pointer

// Temporary registers
def T0    : OneReg<"t0">, DwarfRegNum<[5]>;
def T1    : OneReg<"t1">, DwarfRegNum<[6]>;
def T2    : OneReg<"t2">, DwarfRegNum<[7]>;

// Saved registers  
def S0    : OneReg<"s0">, DwarfRegNum<[8]>;
def S1    : OneReg<"s1">, DwarfRegNum<[9]>;

// Argument/return registers
def A0    : OneReg<"a0">, DwarfRegNum<[10]>;
def A1    : OneReg<"a1">, DwarfRegNum<[11]>;
def A2    : OneReg<"a2">, DwarfRegNum<[12]>;
def A3    : OneReg<"a3">, DwarfRegNum<[13]>;
def A4    : OneReg<"a4">, DwarfRegNum<[14]>;
def A5    : OneReg<"a5">, DwarfRegNum<[15]>;
def A6    : OneReg<"a6">, DwarfRegNum<[16]>;
def A7    : OneReg<"a7">, DwarfRegNum<[17]>;

// Register class for 32-bit integers
def GPR : RegisterClass<"One", [i32], 32, (add
    ZERO, RA, SP,
    A0, A1, A2, A3, A4, A5, A6, A7,
    T0, T1, T2,
    S0, S1
)>;
```

## Instruction Definitions

### Instruction Format Classes (OneInstrFormats.td)
```tablegen
class OneInst<dag outs, dag ins, string asmstr, list<dag> pattern> : Instruction {
    field bits<32> SoftFail = 0;
    let Size = 4;                    // 32-bit instructions
    let Namespace = "One";
    
    dag OutOperandList = outs;       // Output operands
    dag InOperandList = ins;         // Input operands  
    let AsmString = asmstr;          // Assembly syntax
    let Pattern = pattern;           // LLVM IR pattern to match
}

// R-type: Register-register operations
class R<dag outs, dag ins, string asmstr, list<dag> pattern>
    : OneInst<outs, ins, asmstr, pattern>;

// I-type: Immediate operations  
class I<dag outs, dag ins, string asmstr, list<dag> pattern>
    : OneInst<outs, ins, asmstr, pattern>;

// U-type: Upper immediate operations
class U<dag outs, dag ins, string asmstr, list<dag> pattern>
    : OneInst<outs, ins, asmstr, pattern>;
```

### Concrete Instructions (OneInstrInfo.td)
```tablegen
// Arithmetic instruction template
class ArithLogicR<string inst, SDNode node> : R<
    (outs GPR:$rd),                           // Output: destination register
    (ins GPR:$rs1, GPR:$rs2),                // Inputs: two source registers  
    !strconcat(inst, "\\t$rd, $rs1, $rs2"),  // Assembly: "add rd, rs1, rs2"
    [(set GPR:$rd, (node GPR:$rs1, GPR:$rs2))] // Pattern: rd = rs1 + rs2
>;

class ArithLogicI<string inst, SDNode node> : I<
    (outs GPR:$rd),                           // Output: destination register
    (ins GPR:$rs1, imm12:$imm12),            // Inputs: register + 12-bit immediate
    !strconcat(inst, "\\t$rd, $rs1, $imm12"), // Assembly: "addi rd, rs1, imm"  
    [(set GPR:$rd, (node GPR:$rs1, imm12:$imm12))] // Pattern: rd = rs1 + imm
>;

// Actual instruction definitions
def ADD  : ArithLogicR<"add", add>;          // add rd, rs1, rs2
def SUB  : ArithLogicR<"sub", sub>;          // sub rd, rs1, rs2
def MUL  : ArithLogicR<"mul", mul>;          // mul rd, rs1, rs2
def DIV  : ArithLogicR<"div", sdiv>;         // div rd, rs1, rs2

def ADDI : ArithLogicI<"addi", add>;         // addi rd, rs1, imm
def ANDI : ArithLogicI<"andi", and>;         // andi rd, rs1, imm
def ORI  : ArithLogicI<"ori", or>;           // ori rd, rs1, imm
def XORI : ArithLogicI<"xori", xor>;         // xori rd, rs1, imm

// Assembly aliases for convenience
def : InstAlias<"li $rd, $imm", (ADDI GPR:$rd, ZERO, imm12:$imm)>;  // li rd, imm
def : InstAlias<"mv $rd, $rs",  (ADDI GPR:$rd, GPR:$rs, 0)>;        // mv rd, rs
```

## Calling Conventions

### Function Call ABI (OneCallingConv.td)
```tablegen
// Return value convention
def RetCC_One : CallingConv<[
    CCIfType<[i32], CCAssignToReg<[A0, A1]>>    // Return values in a0, a1
]>;

// Parameter passing convention  
def CC_One : CallingConv<[
    CCIfType<[i32], CCAssignToReg<[A0, A1, A2, A3, A4, A5, A6, A7]>>, // First 8 args in registers
    CCAssignToStack<4, 4>                        // Remaining args on stack
]>;

// Callee-saved registers
def CSR : CalleeSavedRegs<(add RA, S0, S1)>;    // Must preserve across calls
```

This defines the **Application Binary Interface (ABI)**:
- **Arguments**: First 8 integer arguments in `a0-a7`, rest on stack
- **Return values**: Integer returns in `a0` (and `a1` for 64-bit)
- **Preserved registers**: `ra` (return address), `s0-s1` (saved registers)

## Instruction Selection Example

Let's trace how LLVM IR gets converted to RISC-V assembly:

### Input: LLVM IR
```llvm
define i32 @add_function(i32 %a, i32 %b) {
entry:
  %sum = add i32 %a, %b
  ret i32 %sum
}
```

### Step 1: Selection DAG Construction
LLVM builds a graph representing the computation:
```
      CopyFromReg(a0)    CopyFromReg(a1)
             \\               /
              \\             /
               \\           /
                \\         /
                 \\       /
                    ADD
                     |
                     |
                   CopyToReg(a0)
                     |
                     |
                    RET
```

### Step 2: Pattern Matching
The `add i32` operation matches our pattern:
```tablegen
def ADD : ArithLogicR<"add", add>;
// Pattern: [(set GPR:$rd, (add GPR:$rs1, GPR:$rs2))]
```

### Step 3: Register Allocation
- `%a` (parameter) → `a0` register
- `%b` (parameter) → `a1` register  
- `%sum` (result) → `a0` register (reused for return value)

### Step 4: Assembly Generation
```asm
add_function:
    add a0, a0, a1    # a0 = a0 + a1 (sum = a + b)
    ret               # return a0
```

## Integration with LLVM

To use this backend, it must be integrated into the LLVM source tree:

### Integration Process
```bash
# 1. Copy backend to LLVM source tree
cp -r backEnd/One/ llvm-project/llvm/lib/Target/

# 2. Modify LLVM target enumeration
# Edit: llvm-project/llvm/include/llvm/TargetParser/Triple.h
# Add to enum: one,    // One architecture

# Edit: llvm-project/llvm/lib/TargetParser/Triple.cpp  
# Add One target recognition and string conversion

# 3. Register target in LLVM build system
# Edit: llvm-project/llvm/lib/Target/CMakeLists.txt
# Add: add_subdirectory(One)

# 4. Build LLVM with new target
cd llvm-project
mkdir build && cd build
cmake ../llvm \\
    -DLLVM_TARGETS_TO_BUILD="One;X86" \\
    -DCMAKE_BUILD_TYPE=Release \\
    -DLLVM_ENABLE_PROJECTS=clang
make -j8
```

### Version Information
- **Base LLVM Commit**: `ae4fc80574cfbbf2b2b53f2728cd785db76e9e69`
- **Target Architecture**: RISC-V32I (32-bit RISC-V Integer Base)
- **Integration Location**: `llvm-project/llvm/lib/Target/One/`

## Complete Compilation Pipeline

Here's the full pipeline from C source to executable:

```
C Source Code
    ↓ (Frontend - Our 15-stage compiler)
LLVM IR  
    ↓ (Backend - Our RISC-V target)
RISC-V Assembly
    ↓ (Assembler - RISC-V toolchain)
Object File (.o)
    ↓ (Linker - RISC-V toolchain)  
Executable (ELF binary)
    ↓ (Execution - RISC-V processor/emulator)
Running Program
```

### End-to-End Example

**C Source** (`program.c`):
```c
int main() {
    int a = 10;
    int b = 20;
    return a + b;
}
```

**Step 1: Frontend Compilation**
```bash
./frontend/15-more_type_and_constant_expr program.c > program.ll
```

**Generated LLVM IR** (`program.ll`):
```llvm
define i32 @main() {
entry:
  %a = alloca i32
  %b = alloca i32
  store i32 10, i32* %a
  store i32 20, i32* %b
  %1 = load i32, i32* %a
  %2 = load i32, i32* %b  
  %3 = add i32 %1, %2
  ret i32 %3
}
```

**Step 2: Backend Compilation**
```bash
llc -march=one program.ll -o program.s
```

**Generated RISC-V Assembly** (`program.s`):
```asm
main:
    addi sp, sp, -16      # Allocate stack frame
    li t0, 10             # Load immediate 10
    sw t0, 12(sp)         # Store a = 10
    li t1, 20             # Load immediate 20  
    sw t1, 8(sp)          # Store b = 20
    lw t0, 12(sp)         # Load a
    lw t1, 8(sp)          # Load b
    add a0, t0, t1        # a0 = a + b (return value)
    addi sp, sp, 16       # Deallocate stack frame
    ret                   # Return to caller
```

**Step 3: Assembly and Linking**
```bash
riscv32-unknown-elf-gcc program.s -o program
```

**Step 4: Execution**
```bash
# On RISC-V hardware or emulator
./program
echo $?                   # Should print 30
```

## Key Learning Points

1. **Declarative Description**: TableGen allows describing targets declaratively rather than imperatively
2. **Pattern Matching**: LLVM IR operations are matched to target instructions via patterns
3. **Separation of Concerns**: Register allocation, instruction selection, and assembly emission are separate phases
4. **ABI Compliance**: Calling conventions ensure interoperability with other tools
5. **Integration**: Backends integrate deeply with LLVM's infrastructure for optimization and code generation

## Next Steps

Now that you understand both the frontend and backend, you have a complete picture of compilation:
- **Frontend**: C source → LLVM IR (15 incremental stages)
- **Backend**: LLVM IR → RISC-V assembly (production-quality target)
- **Integration**: Complete toolchain from source to executable

This knowledge gives you the foundation to:
- Modify existing compiler stages
- Add new language features
- Target new architectures
- Optimize code generation
- Build domain-specific compilers

---
*Lesson 6 completed. You now understand the complete compilation pipeline from high-level C code to executable machine code!*