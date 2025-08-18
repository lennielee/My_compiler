# Chapter 2, Lesson 3: Frontend Development Stages (1-5) - Building the Foundation

## Learning Objectives
- Understand the purpose of each of the first 5 frontend stages
- Learn the fundamental compiler components introduced in each stage
- See how complexity builds incrementally from basic LLVM IR to control flow

## Explanation

Now let's dive deep into the first 5 stages of frontend development. These stages lay the **foundation** for everything that follows. Each stage teaches you a fundamental compiler concept in isolation, making it easier to understand.

## Stage 1: LLVM Hello World (01-llvm-hellowold)

### Purpose
Learn how to generate basic LLVM IR programmatically.

### What You Learn
- **LLVM API basics**: `LLVMContext`, `Module`, `IRBuilder`
- **Function creation**: Defining functions in LLVM IR
- **Basic blocks**: Entry points for code
- **Constants and calls**: String constants and function calls

### Example Code Structure
```cpp
LLVMContext context;
Module m("helloworld", context);
IRBuilder<> irBuilder(context);

// Create puts function declaration
FunctionType *putsFuncType = FunctionType::get(
    irBuilder.getInt32Ty(), 
    {irBuilder.getInt8PtrTy()}, 
    false
);
Function *putsFunc = Function::Create(putsFuncType, 
    GlobalValue::LinkageTypes::ExternalLinkage, "puts", m);

// Create main function
FunctionType *mainFuncType = FunctionType::get(irBuilder.getInt32Ty(), false);
Function *mainFunc = Function::Create(mainFuncType, 
    GlobalValue::LinkageTypes::ExternalLinkage, "main", m);
```

### Key Concept
This stage is your introduction to LLVM's API. Instead of writing LLVM IR by hand, you learn to **construct it programmatically** using C++.

## Stage 2: Expression Compiler (02-expr-compiler)

### Purpose
Build your first real parser for mathematical expressions.

### Grammar (BNF)
```
prog   : (expr? ";")*
expr   : term (("+" | "-") term)*
term   : factor (("*" | "/") factor)*
factor : number | "(" expr ")"
number : ([0-9])+
```

### Core Components Introduced
1. **Lexer** (`lexer.cc/h`): Tokenization
2. **Parser** (`parser.cc/h`): Grammar-based parsing  
3. **AST** (`ast.h`): Abstract Syntax Tree representation
4. **Code Generation** (`codegen.cc/h`): LLVM IR emission
5. **Print Visitor** (`printVisitor.cc/h`): AST visualization

### Example Trace: `2+(4*2)/2+4;`

**Step 1: Lexer Tokenization**
```
Input:  "2+(4*2)/2+4;"
Tokens: [NUMBER:2] [PLUS] [LPAREN] [NUMBER:4] [STAR] [NUMBER:2] 
        [RPAREN] [SLASH] [NUMBER:2] [PLUS] [NUMBER:4] [SEMICOLON]
```

**Step 2: Parser (builds AST following grammar)**
```
expr
├── term: 2
├── PLUS
├── term: (4*2)/2
│   ├── factor: (4*2)
│   │   └── expr: 4*2
│   │       ├── term: 4
│   │       ├── STAR  
│   │       └── term: 2
│   ├── SLASH
│   └── factor: 2
├── PLUS
└── term: 4
```

**Step 3: Code Generation (produces LLVM IR)**
```llvm
define i32 @main() {
entry:
  %0 = call i32 (ptr, ...) @printf(ptr @0, i32 10)  ; 2+8/2+4 = 10
  ret i32 0
}
```

Notice: The expression was **evaluated at compile time** to the constant 10!

## Stage 3: Variables (03-variable)

### Purpose
Add variable declarations, assignments, and scope management.

### New Grammar Extensions
```
decl-stmt  : "int" identifier ("=" expr)? ";"
assign     : identifier "=" expr
```

### New Components Introduced
1. **Symbol Tables** (`scope.cc/h`): Tracking declared variables
2. **Type System** (`type.cc/h`): Basic int type handling  
3. **Semantic Analysis** (`sema.cc/h`): Variable usage validation
4. **Memory Management**: Stack allocation for variables

### Key Concepts
- **Variable declarations**: `int x = 5;`
- **Variable assignments**: `x = x + 1;`
- **Scope rules**: Variable visibility
- **Type checking**: Ensuring type consistency

## Stage 4: Error Handling & Unit Testing (04-errhandle_unittest)

### Purpose
Professional error reporting and testing infrastructure.

### New Components
1. **Diagnostic Engine** (`diag_engine.cc/h`): Professional error messages
2. **Diagnostic Definitions** (`diag.inc`): Error message templates
3. **Unit Testing Framework** (`unittest/`): Automated validation

### Example Error Messages
```
error: undeclared variable 'x'
  --> expr.txt:1:5
  |
1 | int y = x + 1;
  |         ^ undeclared variable
```

### Key Concepts
- **Error recovery**: Continue compilation after errors
- **Source location tracking**: Point to exact error locations
- **Professional diagnostics**: Clear, helpful error messages
- **Automated testing**: Unit tests for lexer, parser, etc.

## Stage 5: If Statements (05-if)

### Purpose
First control flow construct - conditional execution.

### New Grammar
```
if-stmt : "if" "(" expr ")" stmt ("else" stmt)?
```

### New Concepts Introduced
1. **Control Flow**: Branching execution paths
2. **Basic Blocks**: LLVM's execution units (then/else/merge blocks)
3. **Boolean Expressions**: Condition evaluation
4. **Conditional Branches**: `br i1 %cond, label %then, label %else`

### Example LLVM IR Structure
```llvm
entry:
  %cond = icmp ne i32 %x, 0
  br i1 %cond, label %then, label %else

then:
  ; then-block code
  br label %merge

else:
  ; else-block code  
  br label %merge

merge:
  ; continuation code
```

## Building and Testing the Stages

Each stage can be built and tested independently:

```bash
# Build any stage (example: stage 2)
cd frontEnd/02-expr-compiler
mkdir build && cd build
cmake ..
make

# Test the compiler
./02-expr-compiler ../test/expr.txt

# View generated LLVM IR
cat ../test/expr.ll
```

## Common File Structure

Each stage follows a consistent structure:
```
stage-N/
├── CMakeLists.txt     # Build configuration
├── main.cc           # Entry point
├── lexer.cc/h        # Tokenization
├── parser.cc/h       # Syntax analysis
├── ast.h             # AST definitions
├── codegen.cc/h      # LLVM IR generation
├── doc/              # Grammar documentation
│   └── bnf.txt       # BNF grammar
└── test/             # Test cases
    ├── input.txt     # Test input
    └── expected.ll   # Expected output
```

## Key Learning Progression

| Stage | Adds | Foundation For |
|-------|------|----------------|
| 1 | LLVM API basics | All IR generation |
| 2 | Lexer, Parser, AST | All language processing |
| 3 | Variables, Scope | Memory management |
| 4 | Error handling | Robust compilation |
| 5 | Control flow | All statement types |

## Next Lesson Preview

In Lesson 4, we'll explore stages 6-10, which add loops, complex expressions, pointers, arrays, and structures - taking us from basic control flow to sophisticated data manipulation.

---
*Lesson 3 completed. You now understand the fundamental building blocks that every compiler needs!*