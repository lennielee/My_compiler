# Coding Tutorial 3: AST Visitor Pattern and Code Generation

## Learning Objectives
- Understand the Visitor design pattern and why it's essential for compilers
- Implement multiple visitors for different AST traversal purposes
- Write actual LLVM IR code generation step by step
- Build a complete code generator that produces executable LLVM IR
- Learn how to integrate multiple compilation phases

## Part 1: Understanding the Visitor Pattern

### Why Do We Need the Visitor Pattern?

When you have an AST, you need to **do different things** with it:
- **Print it** for debugging
- **Generate code** from it
- **Type check** it
- **Optimize** it
- **Analyze** it for errors

**Problem**: If we put all these operations directly in AST nodes, they become huge and mixed responsibilities.

**Solution**: The Visitor pattern separates **tree structure** from **operations on trees**.

### The Pattern Structure

```cpp
// ast.h - The AST nodes define structure
class Expr {
public:
    virtual ~Expr() {}
    virtual llvm::Value* Accept(Visitor* v) = 0;  // Accept any visitor
};

class BinaryExpr : public Expr {
public:
    OpCode op;
    std::shared_ptr<Expr> left;
    std::shared_ptr<Expr> right;
    
    // Dispatch to visitor's method for this specific node type
    llvm::Value* Accept(Visitor* v) override {
        return v->VisitBinaryExpr(this);
    }
};

class NumberExpr : public Expr {
public:
    int value;
    
    llvm::Value* Accept(Visitor* v) override {
        return v->VisitNumberExpr(this);
    }
};

// The visitor interface defines operations
class Visitor {
public:
    virtual ~Visitor() {}
    virtual llvm::Value* VisitProgram(Program* p) = 0;
    virtual llvm::Value* VisitBinaryExpr(BinaryExpr* expr) = 0;
    virtual llvm::Value* VisitNumberExpr(NumberExpr* expr) = 0;
};
```

### How the Double Dispatch Works

When you call `expr->Accept(visitor)`:

1. **First dispatch**: Based on the **actual type** of `expr` (dynamic dispatch)
2. **Second dispatch**: Inside `Accept()`, calls the **specific visitor method** (static dispatch)

```cpp
// This...
expr->Accept(codeGenVisitor);

// Becomes this...
if (expr is BinaryExpr) {
    return codeGenVisitor->VisitBinaryExpr((BinaryExpr*)expr);
} else if (expr is NumberExpr) {
    return codeGenVisitor->VisitNumberExpr((NumberExpr*)expr);
}
```

## Part 2: Implementing a Print Visitor (Debugging Tool)

Let's start with a simple visitor that prints the AST:

```cpp
// print_visitor.h
#pragma once
#include "ast.h"

class PrintVisitor : public Visitor {
public:
    PrintVisitor(int indentLevel = 0) : indent(indentLevel) {}
    
    llvm::Value* VisitProgram(Program* p) override;
    llvm::Value* VisitBinaryExpr(BinaryExpr* expr) override;
    llvm::Value* VisitNumberExpr(NumberExpr* expr) override;

private:
    void PrintIndent();
    int indent;
};
```

```cpp
// print_visitor.cc
#include "print_visitor.h"
#include "llvm/Support/raw_ostream.h"

void PrintVisitor::PrintIndent() {
    for (int i = 0; i < indent; i++) {
        llvm::outs() << "  ";
    }
}

llvm::Value* PrintVisitor::VisitProgram(Program* p) {
    llvm::outs() << "Program:\\n";
    for (auto& expr : p->expressions) {
        PrintIndent();
        llvm::outs() << "Expression:\\n";
        
        // Create a new visitor with increased indentation
        PrintVisitor childVisitor(indent + 1);
        expr->Accept(&childVisitor);
        llvm::outs() << "\\n";
    }
    return nullptr;
}

llvm::Value* PrintVisitor::VisitBinaryExpr(BinaryExpr* expr) {
    PrintIndent();
    llvm::outs() << "BinaryExpr (";
    
    // Print operator
    switch (expr->op) {
    case OpCode::Add: llvm::outs() << "+"; break;
    case OpCode::Sub: llvm::outs() << "-"; break;
    case OpCode::Mul: llvm::outs() << "*"; break;
    case OpCode::Div: llvm::outs() << "/"; break;
    }
    llvm::outs() << "):\\n";
    
    // Print left child
    PrintIndent();
    llvm::outs() << "  Left:\\n";
    PrintVisitor leftVisitor(indent + 2);
    expr->left->Accept(&leftVisitor);
    
    // Print right child
    PrintIndent();
    llvm::outs() << "  Right:\\n";
    PrintVisitor rightVisitor(indent + 2);
    expr->right->Accept(&rightVisitor);
    
    return nullptr;
}

llvm::Value* PrintVisitor::VisitNumberExpr(NumberExpr* expr) {
    PrintIndent();
    llvm::outs() << "Number: " << expr->value << "\\n";
    return nullptr;
}
```

### Testing the Print Visitor

```cpp
void TestPrintVisitor() {
    std::string input = "2 + 3 * 4;";
    Lexer lexer(llvm::StringRef(input));
    Parser parser(lexer);
    auto program = parser.ParseProgram();
    
    PrintVisitor printer;
    printer.VisitProgram(program.get());
}

// Output:
// Program:
//   Expression:
//     BinaryExpr (+):
//       Left:
//         Number: 2
//       Right:
//         BinaryExpr (*):
//           Left:
//             Number: 3
//           Right:
//             Number: 4
```

## Part 3: Building the Code Generation Visitor

Now for the real work - generating LLVM IR from the AST!

### LLVM IR Basics You Need to Know

**LLVM IR** is a low-level, typed, assembly-like language:
- **SSA Form**: Every value is assigned exactly once
- **Typed**: Every value has a specific type (`i32`, `i8*`, etc.)
- **Basic Blocks**: Code is organized into basic blocks with control flow
- **Instructions**: Load, store, arithmetic, calls, branches, etc.

### CodeGen Visitor Structure

```cpp
// codegen.h
#pragma once
#include "ast.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/BasicBlock.h"

class CodeGen : public Visitor {
public:
    CodeGen();
    
    // Main entry point
    void GenerateCode(std::shared_ptr<Program> program);
    
    // Print the generated IR
    void PrintIR();

private:
    llvm::Value* VisitProgram(Program* p) override;
    llvm::Value* VisitBinaryExpr(BinaryExpr* expr) override;
    llvm::Value* VisitNumberExpr(NumberExpr* expr) override;
    
    // Helper methods
    void CreateMainFunction();
    void CreatePrintfDeclaration();

private:
    llvm::LLVMContext context;
    llvm::IRBuilder<> builder;
    std::unique_ptr<llvm::Module> module;
    
    // Function declarations we'll need
    llvm::Function* mainFunc;
    llvm::Function* printfFunc;
};
```

### Step 1: Setting Up LLVM Infrastructure

```cpp
// codegen.cc
#include "codegen.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

CodeGen::CodeGen() : builder(context) {
    // Create a new module (compilation unit)
    module = std::make_unique<Module>("expr_compiler", context);
}

void CodeGen::CreatePrintfDeclaration() {
    // printf signature: int printf(const char* format, ...)
    
    // Get types
    Type* i32Type = builder.getInt32Ty();
    Type* i8PtrType = builder.getInt8PtrTy();
    
    // Create function type: int(char*, ...)  [variadic]
    FunctionType* printfType = FunctionType::get(
        i32Type,           // Return type
        {i8PtrType},       // Parameter types
        true               // Is variadic (accepts ... arguments)
    );
    
    // Create function declaration
    printfFunc = Function::Create(
        printfType,
        Function::ExternalLinkage,  // External linkage (defined elsewhere)
        "printf",
        module.get()
    );
}

void CodeGen::CreateMainFunction() {
    // main signature: int main()
    
    FunctionType* mainType = FunctionType::get(
        builder.getInt32Ty(),  // Return type: int
        {},                    // No parameters
        false                  // Not variadic
    );
    
    mainFunc = Function::Create(
        mainType,
        Function::ExternalLinkage,
        "main",
        module.get()
    );
    
    // Create the entry basic block
    BasicBlock* entryBB = BasicBlock::Create(context, "entry", mainFunc);
    builder.SetInsertPoint(entryBB);  // All subsequent instructions go here
}
```

### Step 2: The Main Generation Entry Point

```cpp
void CodeGen::GenerateCode(std::shared_ptr<Program> program) {
    // Set up the LLVM infrastructure
    CreatePrintfDeclaration();
    CreateMainFunction();
    
    // Visit the program and generate code
    VisitProgram(program.get());
    
    // Verify that the generated IR is correct
    verifyFunction(*mainFunc);
    verifyModule(*module);
}

llvm::Value* CodeGen::VisitProgram(Program* p) {
    // For each expression in the program:
    // 1. Generate code for the expression
    // 2. Print the result using printf
    
    for (auto& expr : p->expressions) {
        // Generate code for this expression
        Value* result = expr->Accept(this);
        
        if (result) {
            // Create a format string for printf
            Value* formatStr = builder.CreateGlobalStringPtr("Result: %d\\n");
            
            // Call printf(formatStr, result)
            builder.CreateCall(printfFunc, {formatStr, result});
        }
    }
    
    // Return 0 from main
    builder.CreateRet(builder.getInt32(0));
    
    return nullptr;
}
```

### Step 3: Generating Code for Numbers

```cpp
llvm::Value* CodeGen::VisitNumberExpr(NumberExpr* expr) {
    // Create a constant integer value
    return builder.getInt32(expr->value);
}
```

**That's it!** Numbers are just constants in LLVM IR.

### Step 4: Generating Code for Binary Expressions

```cpp
llvm::Value* CodeGen::VisitBinaryExpr(BinaryExpr* expr) {
    // Generate code for left and right operands
    Value* leftVal = expr->left->Accept(this);
    Value* rightVal = expr->right->Accept(this);
    
    // Make sure both operands were generated successfully
    if (!leftVal || !rightVal) {
        return nullptr;
    }
    
    // Generate the appropriate LLVM instruction based on operator
    switch (expr->op) {
    case OpCode::Add:
        // Create an 'add' instruction
        return builder.CreateAdd(leftVal, rightVal, "add_tmp");
        
    case OpCode::Sub:
        // Create a 'sub' instruction
        return builder.CreateSub(leftVal, rightVal, "sub_tmp");
        
    case OpCode::Mul:
        // Create a 'mul' instruction
        return builder.CreateMul(leftVal, rightVal, "mul_tmp");
        
    case OpCode::Div:
        // Create a signed division instruction
        return builder.CreateSDiv(leftVal, rightVal, "div_tmp");
        
    default:
        // Unknown operator
        return nullptr;
    }
}
```

**Key Insights:**
- Each LLVM instruction produces a **Value** that can be used by other instructions
- The temporary names (`"add_tmp"`) help make the IR readable
- `CreateAdd`, `CreateSub`, etc. create the actual LLVM instructions

### Step 5: Putting It All Together

```cpp
void CodeGen::PrintIR() {
    module->print(outs(), nullptr);
}

// Usage example:
int main() {
    std::string input = "2 + 3 * 4; 10 - 5;";
    
    // Parse the input
    Lexer lexer(llvm::StringRef(input));
    Parser parser(lexer);
    auto program = parser.ParseProgram();
    
    // Generate LLVM IR
    CodeGen codegen;
    codegen.GenerateCode(program);
    
    // Print the generated IR
    codegen.PrintIR();
    
    return 0;
}
```

## Part 4: Understanding the Generated LLVM IR

### Input Code:
```c
2 + 3 * 4;
```

### Generated LLVM IR:
```llvm
; ModuleID = 'expr_compiler'

@0 = private unnamed_addr constant [12 x i8] c"Result: %d\\0A\\00", align 1

declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %mul_tmp = mul i32 3, 4           ; 3 * 4 = 12
  %add_tmp = add i32 2, %mul_tmp    ; 2 + 12 = 14
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @0, i32 0, i32 0), i32 %add_tmp)
  ret i32 0
}
```

### Breaking Down the IR:

1. **Global String**: `@0 = private unnamed_addr constant [12 x i8] c"Result: %d\\0A\\00"`
   - This is the format string for printf

2. **Function Declaration**: `declare i32 @printf(i8*, ...)`
   - External function we can call

3. **Main Function**: `define i32 @main()`
   - Our generated main function

4. **Arithmetic Instructions**:
   - `%mul_tmp = mul i32 3, 4` - Multiply 3 and 4
   - `%add_tmp = add i32 2, %mul_tmp` - Add 2 to the result

5. **Function Call**: `call i32 @printf(...)`
   - Print the result

6. **Return**: `ret i32 0`
   - Return 0 from main

## Part 5: Advanced Code Generation Features

### Handling More Expression Types

Let's extend our code generator to handle comparison operators:

```cpp
// Add to OpCode enum
enum class OpCode {
    Add, Sub, Mul, Div,
    Equal, NotEqual, Less, Greater  // New comparison operators
};

// Extend VisitBinaryExpr
llvm::Value* CodeGen::VisitBinaryExpr(BinaryExpr* expr) {
    Value* leftVal = expr->left->Accept(this);
    Value* rightVal = expr->right->Accept(this);
    
    if (!leftVal || !rightVal) return nullptr;
    
    switch (expr->op) {
    // Arithmetic operators
    case OpCode::Add:
        return builder.CreateAdd(leftVal, rightVal, "add_tmp");
    case OpCode::Sub:
        return builder.CreateSub(leftVal, rightVal, "sub_tmp");
    case OpCode::Mul:
        return builder.CreateMul(leftVal, rightVal, "mul_tmp");
    case OpCode::Div:
        return builder.CreateSDiv(leftVal, rightVal, "div_tmp");
        
    // Comparison operators (return i1, then extend to i32)
    case OpCode::Equal: {
        Value* cmp = builder.CreateICmpEQ(leftVal, rightVal, "eq_tmp");
        return builder.CreateZExt(cmp, builder.getInt32Ty(), "eq_ext");
    }
    case OpCode::NotEqual: {
        Value* cmp = builder.CreateICmpNE(leftVal, rightVal, "ne_tmp");
        return builder.CreateZExt(cmp, builder.getInt32Ty(), "ne_ext");
    }
    case OpCode::Less: {
        Value* cmp = builder.CreateICmpSLT(leftVal, rightVal, "lt_tmp");
        return builder.CreateZExt(cmp, builder.getInt32Ty(), "lt_ext");
    }
    case OpCode::Greater: {
        Value* cmp = builder.CreateICmpSGT(leftVal, rightVal, "gt_tmp");
        return builder.CreateZExt(cmp, builder.getInt32Ty(), "gt_ext");
    }
    
    default:
        return nullptr;
    }
}
```

**Why ZExt?** Comparison operations return `i1` (1-bit boolean), but we want `i32` for consistency.

### Error Handling in Code Generation

```cpp
llvm::Value* CodeGen::VisitBinaryExpr(BinaryExpr* expr) {
    Value* leftVal = expr->left->Accept(this);
    Value* rightVal = expr->right->Accept(this);
    
    // Check for generation errors
    if (!leftVal) {
        llvm::errs() << "Error: Failed to generate code for left operand\\n";
        return nullptr;
    }
    if (!rightVal) {
        llvm::errs() << "Error: Failed to generate code for right operand\\n";
        return nullptr;
    }
    
    // Check for type mismatches (more advanced)
    if (leftVal->getType() != rightVal->getType()) {
        llvm::errs() << "Error: Type mismatch in binary expression\\n";
        return nullptr;
    }
    
    // ... rest of the method
}
```

### Optimization Opportunity: Constant Folding

LLVM automatically performs many optimizations, but you can do some at the AST level:

```cpp
llvm::Value* CodeGen::VisitBinaryExpr(BinaryExpr* expr) {
    // Check if both operands are constants
    auto leftNum = dynamic_cast<NumberExpr*>(expr->left.get());
    auto rightNum = dynamic_cast<NumberExpr*>(expr->right.get());
    
    if (leftNum && rightNum) {
        // Both are constants - fold at compile time!
        int result;
        switch (expr->op) {
        case OpCode::Add: result = leftNum->value + rightNum->value; break;
        case OpCode::Sub: result = leftNum->value - rightNum->value; break;
        case OpCode::Mul: result = leftNum->value * rightNum->value; break;
        case OpCode::Div: 
            if (rightNum->value == 0) {
                llvm::errs() << "Error: Division by zero\\n";
                return nullptr;
            }
            result = leftNum->value / rightNum->value; 
            break;
        default:
            goto normal_generation;  // Fall back to normal generation
        }
        
        return builder.getInt32(result);
    }
    
normal_generation:
    // Normal code generation for non-constant expressions
    Value* leftVal = expr->left->Accept(this);
    Value* rightVal = expr->right->Accept(this);
    // ... rest as before
}
```

## Part 6: Testing and Debugging

### Complete Test Program

```cpp
// test_codegen.cc
#include "lexer.h"
#include "parser.h"
#include "codegen.h"
#include <iostream>

void TestCodeGeneration(const std::string& input) {
    std::cout << "\\n=== Testing: " << input << " ===\\n";
    
    // Parse
    Lexer lexer(llvm::StringRef(input));
    Parser parser(lexer);
    auto program = parser.ParseProgram();
    
    if (!program || program->expressions.empty()) {
        std::cout << "Parse failed!\\n";
        return;
    }
    
    // Generate code
    CodeGen codegen;
    codegen.GenerateCode(program);
    
    // Print the IR
    std::cout << "Generated LLVM IR:\\n";
    codegen.PrintIR();
}

int main() {
    // Test various expressions
    TestCodeGeneration("42;");
    TestCodeGeneration("2 + 3;");
    TestCodeGeneration("2 + 3 * 4;");
    TestCodeGeneration("(2 + 3) * 4;");
    TestCodeGeneration("10 / 2 - 1;");
    
    return 0;
}
```

### Compilation and Execution

```bash
# Compile your compiler
g++ -std=c++17 \\
    test_codegen.cc lexer.cc parser.cc codegen.cc \\
    `llvm-config --cxxflags --ldflags --libs core` \\
    -o expr_compiler

# Run it
./expr_compiler

# To execute the generated IR:
./expr_compiler > output.ll
lli output.ll  # LLVM interpreter
# Or:
llc output.ll -o output.s  # Compile to assembly
gcc output.s -o output     # Link to executable
./output                   # Run the executable
```

## Part 7: Integration with the Complete Compiler Pipeline

### Full Pipeline Integration

```cpp
// compiler_main.cc
#include "lexer.h"
#include "parser.h"
#include "codegen.h"
#include "print_visitor.h"
#include <fstream>
#include <sstream>

int main(int argc, char* argv[]) {
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " <source_file>\\n";
        return 1;
    }
    
    // Read source file
    std::ifstream file(argv[1]);
    if (!file) {
        std::cerr << "Error: Cannot open file " << argv[1] << "\\n";
        return 1;
    }
    
    std::stringstream buffer;
    buffer << file.rdbuf();
    std::string source = buffer.str();
    
    // Lexical analysis
    std::cout << "=== Lexical Analysis ===\\n";
    Lexer lexer(llvm::StringRef(source));
    
    // Syntax analysis
    std::cout << "=== Syntax Analysis ===\\n";
    Parser parser(lexer);
    auto program = parser.ParseProgram();
    
    if (!program) {
        std::cerr << "Parse failed\\n";
        return 1;
    }
    
    // AST Visualization
    std::cout << "=== Abstract Syntax Tree ===\\n";
    PrintVisitor printer;
    printer.VisitProgram(program.get());
    
    // Code Generation
    std::cout << "=== Code Generation ===\\n";
    CodeGen codegen;
    codegen.GenerateCode(program);
    codegen.PrintIR();
    
    return 0;
}
```

## Summary: What You've Learned

You now know how to:

1. **Design and implement the Visitor pattern** for clean AST traversal
2. **Create multiple visitors** for different purposes (printing, code generation)
3. **Set up LLVM IR generation infrastructure** with contexts, modules, and builders
4. **Generate LLVM instructions** for arithmetic and comparison operations
5. **Handle function declarations and calls** (printf example)
6. **Create complete LLVM functions** with basic blocks and control flow
7. **Integrate code generation** with the lexer and parser

**Key LLVM Concepts You Mastered:**
- **LLVMContext**: The container for all LLVM state
- **Module**: A compilation unit containing functions and global variables
- **IRBuilder**: The tool for creating LLVM instructions
- **Value**: The base class for all computed values in LLVM
- **Function**: LLVM representation of functions
- **BasicBlock**: Units of control flow within functions

**Next Steps:**
- **Variables and Memory**: Stack allocation, load/store instructions
- **Control Flow**: If statements, loops with branches and PHI nodes
- **Functions**: Parameter passing, return values, calling conventions
- **Type System**: Multiple types, type checking, type conversions

You now have a working code generator that can turn ASTs into executable LLVM IR!