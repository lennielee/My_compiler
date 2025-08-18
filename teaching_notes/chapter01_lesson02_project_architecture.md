# Chapter 1, Lesson 2: Project Architecture Overview

## Learning Objectives
- Understand the two-part architecture of our compiler project
- Learn how the 15 frontend stages provide incremental learning
- See the complete compilation pipeline from C to RISC-V assembly

## Explanation

Now that you understand what a compiler is, let's examine the architecture of **our specific compiler project**. This project is beautifully organized to show you the complete journey from C source code to RISC-V assembly.

### Two-Part Architecture

Our compiler project has two main components:

1. **Frontend (`frontEnd/`)** - Transforms C source code into LLVM IR
2. **Backend (`backEnd/`)** - Transforms LLVM IR into RISC-V machine code

```
C Source Code → Frontend → LLVM IR → Backend → RISC-V Assembly
```

### Frontend: Incremental Learning (15 Stages)

The frontend is brilliantly designed as **15 incremental stages**, each building upon the previous:

| Stage | Focus | What You Learn |
|-------|-------|----------------|
| 01 | LLVM Hello World | Basic LLVM IR generation |
| 02 | Expression Compiler | Simple arithmetic (2+3*4) |
| 03 | Variables | Variable declarations and scope |
| 04 | Error Handling | Diagnostics and unit testing |
| 05 | If Statements | Conditional control flow |
| 06 | For Loops | Iteration constructs |
| 07 | Logical/Bitwise | Complex expressions |
| 08 | Pointers | Memory addressing |
| 09 | Arrays | Aggregate data types |
| 10 | Structures | Custom data types |
| 11 | Functions | Procedure calls and global vars |
| 12 | Advanced Functions | Functions with arrays/structs |
| 13 | Variadic Functions | printf-style functions |
| 14 | Switch/While | More control structures |
| 15 | Complete Types | Full C type system |

This incremental approach lets you **learn one concept at a time** rather than being overwhelmed by a complete compiler all at once.

### Backend: Complete RISC-V Target

The backend implements a **complete RISC-V32I target** for LLVM, including:
- **Instruction Definitions** (`OneInstrInfo.td`)
- **Register Management** (`OneRegisterInfo.td`) 
- **Calling Conventions** (`OneCallingConv.td`)
- **Code Selection** (`OneISelDAGToDAG.cpp`)
- **Assembly Generation** (`OneAsmPrinter.cpp`)

## Example: Complete Compilation Pipeline

Let's trace a simple C program through our entire pipeline:

### Input: C Source Code
```c
int main(){
    int aa = 1, b = 1;
    aa = aa || b && aa || b || aa || b && aa ;
    aa = aa << 3;
    return aa+b;
}
```

### Stage 1: Frontend Processing
1. **Lexer**: Breaks into tokens (`int`, `main`, `(`, `)`, `{`, `aa`, `=`, `1`, etc.)
2. **Parser**: Builds Abstract Syntax Tree (AST)
3. **Semantic Analysis**: Type checking, scope resolution
4. **Code Generation**: Produces LLVM IR

### Stage 2: LLVM IR (Intermediate)
```llvm
define i32 @main() {
entry:
  %aa = alloca i32
  %b = alloca i32
  store i32 1, i32* %aa
  store i32 1, i32* %b
  ; ... logical operations and shifts
  ret i32 %result
}
```

### Stage 3: Backend Processing
1. **Instruction Selection**: LLVM IR → RISC-V instructions
2. **Register Allocation**: Assign physical registers
3. **Assembly Generation**: Final RISC-V assembly

### Stage 4: RISC-V Assembly Output
```asm
main:
    addi sp, sp, -16    # allocate stack space
    li t0, 1            # load immediate 1
    sw t0, 12(sp)       # store aa
    sw t0, 8(sp)        # store b
    ; ... logical and shift operations
    add a0, t1, t2      # return aa+b
    addi sp, sp, 16     # deallocate stack
    ret                 # return
```

## Key Architecture Benefits

1. **Modular Design**: Frontend and backend are separate, reusable components
2. **LLVM Integration**: Leverages industrial-strength compiler infrastructure
3. **Incremental Learning**: 15 stages let you master one concept at a time
4. **Real Target**: RISC-V backend produces actual executable code
5. **Complete Pipeline**: From source to assembly, nothing is hidden

## Version Information

- **Frontend**: Based on LLVM 17.0
- **Backend**: Based on LLVM commit `ae4fc80574cfbbf2b2b53f2728cd785db76e9e69`
- **Target**: RISC-V32I architecture
- **Integration**: Backend requires LLVM source tree integration

## Next Lesson Preview

In Lesson 3, we'll dive into the first 5 frontend stages and see how the compiler gradually builds complexity, starting with basic LLVM IR generation and progressing through expressions, variables, error handling, and conditional statements.

---
*Lesson 2 completed. The architecture overview provides the foundation for understanding how all pieces fit together!*