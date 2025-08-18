# Complete Function Call Flow Diagram

## Overview

This diagram shows the complete compilation pipeline from C source code through all stages to executable RISC-V assembly, including all interface calls between components and data flow through the entire system.

## 1. Complete Compilation Pipeline Flow

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   C Source      │    │   Token Stream  │    │   Abstract      │    │   Annotated     │
│   Code          │───▶│   (Lexer        │───▶│   Syntax Tree   │───▶│   AST           │
│   "int a = b+c" │    │   Output)       │    │   (Parser Out)  │    │   (Sema Out)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │                       │
         ▼                       ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Lexer         │    │   Parser        │    │   Semantic      │    │   Code          │
│   NextToken()   │    │   ParseExpr()   │    │   Analyzer      │    │   Generator     │
│   LexNumber()   │    │   ParseStmt()   │    │   AnalyzeExpr() │    │   GenerateCode()│
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘
                                                                               │
                                                                               ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   RISC-V        │    │   Machine       │    │   Selection     │    │   LLVM IR       │
│   Assembly      │◀───│   Instructions  │◀───│   DAG           │◀───│   (Platform     │
│   (Final)       │    │   (Backend)     │    │   (ISel)        │    │   Independent)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘
         ▲                       ▲                       ▲                       │
         │                       │                       │                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Assembly      │    │   Instruction   │    │   IR Lowering   │    │   Backend       │
│   Printer       │    │   Selection     │    │   LowerCall()   │    │   Pipeline      │
│   emitInstruction()│    │   Select()      │    │   LowerReturn() │    │   (LLVM)        │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 2. Detailed Interface Call Flow

### 2.1 Frontend Processing Chain

```cpp
// Main compilation driver
int main(int argc, char* argv[]) {
    // 1. Source File Reading
    std::string source = ReadSourceFile(argv[1]);
    
    // 2. Lexical Analysis
    Lexer lexer(llvm::StringRef(source));
    
    // 3. Syntax Analysis  
    Parser parser(lexer);
    auto program = parser.ParseProgram();
    
    // 4. Semantic Analysis
    SemanticAnalyzer analyzer(diagEngine);
    analyzer.AnalyzeProgram(program);
    
    // 5. Code Generation
    CodeGen codegen;
    codegen.GenerateCode(program);
    
    // 6. Backend Compilation
    CompileToAssembly(program, targetMachine);
}
```

### 2.2 Lexer → Parser Interface Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         Parser ↔ Lexer Interface                        │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Parser::ParseExpr() {                                                  │
│    ┌─────────────────┐                                                  │
│    │  currentToken   │──────────────┐                                   │
│    └─────────────────┘              │                                   │
│                                     │                                   │
│    while (...) {                    ▼                                   │
│      ┌─────────────────────────────────────────┐                       │
│      │  if (Expect(TokenType::plus)) {         │                       │
│      │    Advance(); // calls lexer            │                       │
│      │    auto right = ParseTerm();            │                       │
│      │    left = CreateBinaryExpr(op, l, r);   │                       │
│      │  }                                      │                       │
│      └─────────────────────────────────────────┘                       │
│    }                                                                    │
│  }                                                                      │
│                                                                         │
│  void Advance() {                                                       │
│    lexer.NextToken(currentToken); ──────────┐                          │
│  }                                          │                          │
│                                             ▼                          │
│                                    ┌─────────────────┐                  │
│                                    │ Lexer::NextToken│                  │
│                                    │ ├─ SkipWhitespace                  │
│                                    │ ├─ LexNumber                       │
│                                    │ ├─ LexIdentifier                   │
│                                    │ ├─ LexOperator                     │
│                                    │ └─ LexString                       │
│                                    └─────────────────┘                  │
│                                             │                          │
│                                             ▼                          │
│                                    ┌─────────────────┐                  │
│                                    │ Token returned  │                  │
│                                    │ {type, value,   │                  │
│                                    │  location}      │                  │
│                                    └─────────────────┘                  │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.3 Parser → Semantic Analyzer Interface Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    Parser ↔ Semantic Analyzer Interface                 │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Parser generates AST:                                                  │
│  ┌─────────────────┐                                                    │
│  │ BinaryExpr      │                                                    │
│  │ ├─ left: Expr   │                                                    │
│  │ ├─ op: Add      │                                                    │
│  │ └─ right: Expr  │                                                    │
│  └─────────────────┘                                                    │
│           │                                                             │
│           ▼                                                             │
│  SemanticAnalyzer::AnalyzeExpression(expr) {                           │
│    ┌─────────────────────────────────────────┐                         │
│    │  return expr->Accept(this);             │ ◀── Visitor Pattern     │
│    └─────────────────────────────────────────┘                         │
│  }                                                                      │
│           │                                                             │
│           ▼                                                             │
│  VisitBinaryExpr(BinaryExpr* expr) {                                   │
│    ┌─────────────────────────────────────────┐                         │
│    │  auto leftType = expr->left->Accept(this);                        │
│    │  auto rightType = expr->right->Accept(this);                      │
│    │                                         │                         │
│    │  if (!IsTypeCompatible(leftType, rightType)) {                    │
│    │    ReportError("Type mismatch");        │                         │
│    │  }                                      │                         │
│    │                                         │                         │
│    │  expr->SetType(DetermineResultType(leftType, rightType));         │
│    │  return expr->GetType();                │                         │
│    └─────────────────────────────────────────┘                         │
│  }                                                                      │
│           │                                                             │
│           ▼                                                             │
│  ┌─────────────────┐                                                    │
│  │ Annotated AST   │ ◀── AST nodes now have type information            │
│  │ with type info  │                                                    │
│  └─────────────────┘                                                    │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.4 Semantic Analyzer → Code Generator Interface Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│               Semantic Analyzer ↔ Code Generator Interface              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  CodeGen::GenerateCode(annotatedAST) {                                 │
│    ┌─────────────────────────────────────────┐                         │
│    │  InitializeLLVMContext();               │                         │
│    │  CreateMainFunction();                  │                         │
│    │  auto result = annotatedAST->Accept(this);                        │
│    └─────────────────────────────────────────┘                         │
│  }                                                                      │
│           │                                                             │
│           ▼                                                             │
│  VisitBinaryExpr(BinaryExpr* expr) {                                   │
│    ┌─────────────────────────────────────────┐                         │
│    │  // Use type information from semantic analysis                    │
│    │  auto type = expr->GetType(); ◀────────── From semantic analysis   │
│    │  auto llvmType = ConvertToLLVMType(type);                         │
│    │                                         │                         │
│    │  Value* left = expr->left->Accept(this);│                         │
│    │  Value* right = expr->right->Accept(this);                        │
│    │                                         │                         │
│    │  switch (expr->op) {                    │                         │
│    │  case OpCode::Add:                      │                         │
│    │    return builder.CreateAdd(left, right, "add_tmp");              │
│    │  case OpCode::Mul:                      │                         │
│    │    return builder.CreateMul(left, right, "mul_tmp");              │
│    │  }                                      │                         │
│    └─────────────────────────────────────────┘                         │
│  }                                                                      │
│           │                                                             │
│           ▼                                                             │
│  ┌─────────────────┐                                                    │
│  │ LLVM IR         │ ◀── Platform-independent intermediate code         │
│  │ %add_tmp = add  │                                                    │
│  │   i32 %0, %1    │                                                    │
│  └─────────────────┘                                                    │
└─────────────────────────────────────────────────────────────────────────┘
```

## 3. Backend Processing Chain

### 3.1 LLVM IR → SelectionDAG → Machine Instructions

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        Backend Processing Pipeline                      │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  LLVM IR:                                                              │
│  ┌─────────────────┐                                                    │
│  │ %result = add   │                                                    │
│  │   i32 %a, %b    │                                                    │
│  └─────────────────┘                                                    │
│           │                                                             │
│           ▼                                                             │
│  OneISelLowering::LowerOperation() {                                   │
│    ┌─────────────────────────────────────────┐                         │
│    │  // Convert LLVM IR nodes to SelectionDAG                         │
│    │  switch (Op.getOpcode()) {              │                         │
│    │  case ISD::ADD:                         │                         │
│    │    // Map to RISC-V ADD instruction     │                         │
│    │    return DAG.getNode(OneISD::ADD, ...);│                         │
│    │  case ISD::GlobalAddress:               │                         │
│    │    return LowerGlobalAddress(Op, DAG);  │                         │
│    │  }                                      │                         │
│    └─────────────────────────────────────────┘                         │
│  }                                                                      │
│           │                                                             │
│           ▼                                                             │
│  ┌─────────────────┐                                                    │
│  │ SelectionDAG    │ ◀── Intermediate representation for instruction    │
│  │ Nodes           │     selection                                      │
│  └─────────────────┘                                                    │
│           │                                                             │
│           ▼                                                             │
│  OneDAGToDAGISel::Select() {                                           │
│    ┌─────────────────────────────────────────┐                         │
│    │  // Try auto-generated patterns first   │                         │
│    │  if (SelectCode(Node)) return;          │                         │
│    │                                         │                         │
│    │  // Handle special cases manually       │                         │
│    │  switch (Node->getOpcode()) {           │                         │
│    │  case ISD::Constant:                    │                         │
│    │    // Convert to ADDI with zero register│                         │
│    │    SDNode *Result = CurDAG->getMachineNode(                       │
│    │        One::ADDI, DL, MVT::i32,         │                         │
│    │        CurDAG->getRegister(One::ZERO, MVT::i32),                  │
│    │        TargetImm);                      │                         │
│    │    ReplaceNode(Node, Result);           │                         │
│    │  }                                      │                         │
│    └─────────────────────────────────────────┘                         │
│  }                                                                      │
│           │                                                             │
│           ▼                                                             │
│  ┌─────────────────┐                                                    │
│  │ Machine         │ ◀── Target-specific machine instructions           │
│  │ Instructions    │                                                    │
│  │ ADDI %0, %zero, 5                                                   │
│  └─────────────────┘                                                    │
└─────────────────────────────────────────────────────────────────────────┘
```

### 3.2 Function Call Processing Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         Function Call Processing                        │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  C Code: foo(a, b, c)                                                  │
│           │                                                             │
│           ▼                                                             │
│  LLVM IR: call i32 @foo(i32 %a, i32 %b, i32 %c)                       │
│           │                                                             │
│           ▼                                                             │
│  OneTargetLowering::LowerCall() {                                      │
│    ┌─────────────────────────────────────────┐                         │
│    │  // 1. Analyze arguments                │                         │
│    │  CCInfo.AnalyzeCallOperands(Outs, CC_One);                        │
│    │                                         │                         │
│    │  // 2. Process register arguments       │                         │
│    │  for (auto &VA : ArgLocs) {             │                         │
│    │    if (VA.isRegLoc()) {                 │                         │
│    │      RegsToPass.push_back(              │                         │
│    │        {VA.getLocReg(), OutVals[i]});   │                         │
│    │    } else {                             │                         │
│    │      // Store to stack                  │                         │
│    │      Chain = DAG.getStore(...);         │                         │
│    │    }                                    │                         │
│    │  }                                      │                         │
│    │                                         │                         │
│    │  // 3. Create call instruction          │                         │
│    │  Chain = DAG.getNode(OneISD::CALL, ...);│                         │
│    │                                         │                         │
│    │  // 4. Handle return values             │                         │
│    │  CCInfo.AnalyzeCallResult(Ins, RetCC_One);                        │
│    └─────────────────────────────────────────┘                         │
│  }                                                                      │
│           │                                                             │
│           ▼                                                             │
│  Generated RISC-V Assembly:                                            │
│  ┌─────────────────┐                                                    │
│  │ mv a0, s1       │ ◀── Move arguments to argument registers           │
│  │ mv a1, s2       │                                                    │
│  │ mv a2, s3       │                                                    │
│  │ jal ra, foo     │ ◀── Jump and link to function                      │
│  │ mv s0, a0       │ ◀── Save return value                              │
│  └─────────────────┘                                                    │
└─────────────────────────────────────────────────────────────────────────┘
```

## 4. Data Flow Through Components

### 4.1 Data Structures and Transformations

```
C Source Code:
┌─────────────────┐
│ int sum(int a,  │
│         int b)  │
│ {               │
│   return a + b; │
│ }               │
└─────────────────┘
         │
         ▼ Lexer::NextToken()
┌─────────────────┐
│ Token Stream:   │
│ INT, IDENTIFIER │
│ LPAREN, INT,    │
│ IDENTIFIER,     │
│ COMMA, ...      │
└─────────────────┘
         │
         ▼ Parser::ParseFunction()
┌─────────────────┐
│ AST:            │
│ FunctionDecl    │
│ ├─ name: "sum"  │
│ ├─ params: [a,b]│
│ └─ body: Block  │
│    └─ Return    │
│       └─ BinaryExpr│
│          ├─ left: a│
│          ├─ op: +  │
│          └─ right:b│
└─────────────────┘
         │
         ▼ SemanticAnalyzer::AnalyzeFunction()
┌─────────────────┐
│ Annotated AST:  │
│ FunctionDecl    │
│ ├─ type: i32(*)(i32,i32)
│ ├─ symbol: @sum │
│ └─ body: Block  │
│    └─ Return    │
│       └─ BinaryExpr│
│          ├─ type: i32│
│          ├─ left: a(i32)│
│          └─ right:b(i32)│
└─────────────────┘
         │
         ▼ CodeGen::VisitFunction()
┌─────────────────┐
│ LLVM IR:        │
│ define i32 @sum │
│   (i32 %a,      │
│    i32 %b) {    │
│   %add = add    │
│     i32 %a, %b  │
│   ret i32 %add  │
│ }               │
└─────────────────┘
         │
         ▼ Backend Pipeline
┌─────────────────┐
│ RISC-V Assembly:│
│ sum:            │
│   add a0, a0, a1│
│   ret           │
└─────────────────┘
```

### 4.2 Error Handling and Diagnostics Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         Error Handling Pipeline                         │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Each component reports errors to DiagEngine:                          │
│                                                                         │
│  Lexer Error:                                                          │
│  ┌─────────────────────────────────────────┐                          │
│  │ if (invalid_char) {                     │                          │
│  │   diagEngine.Report(                    │                          │
│  │     Diag::err_invalid_character,        │                          │
│  │     currentLocation, character);        │                          │
│  │ }                                       │                          │
│  └─────────────────────────────────────────┘                          │
│                                                                         │
│  Parser Error:                                                         │
│  ┌─────────────────────────────────────────┐                          │
│  │ if (!Expect(TokenType::semicolon)) {    │                          │
│  │   diagEngine.Report(                    │                          │
│  │     Diag::err_expected_semicolon,       │                          │
│  │     currentToken.location);             │                          │
│  │   return ErrorNode();                   │                          │
│  │ }                                       │                          │
│  └─────────────────────────────────────────┘                          │
│                                                                         │
│  Semantic Analysis Error:                                              │
│  ┌─────────────────────────────────────────┐                          │
│  │ if (!IsTypeCompatible(leftType, rightType)) {                      │
│  │   diagEngine.Report(                    │                          │
│  │     Diag::err_type_mismatch,            │                          │
│  │     expr->location,                     │                          │
│  │     leftType->toString(),               │                          │
│  │     rightType->toString());             │                          │
│  │ }                                       │                          │
│  └─────────────────────────────────────────┘                          │
│                                                                         │
│  DiagEngine collects and formats all errors:                          │
│  ┌─────────────────────────────────────────┐                          │
│  │ void DiagEngine::PrintErrors() {        │                          │
│  │   for (auto& diag : diagnostics) {      │                          │
│  │     PrintLocation(diag.location);       │                          │
│  │     PrintMessage(diag.message);         │                          │
│  │     PrintSourceLine(diag.location);     │                          │
│  │     PrintCaretLine(diag.location);      │                          │
│  │   }                                     │                          │
│  │ }                                       │                          │
│  └─────────────────────────────────────────┘                          │
└─────────────────────────────────────────────────────────────────────────┘
```

## 5. Performance and Memory Management

### 5.1 Memory Management Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         Memory Management Strategy                      │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  AST Node Creation:                                                    │
│  ┌─────────────────────────────────────────┐                          │
│  │ std::shared_ptr<Expr> Parser::ParseExpr() {                        │
│  │   auto left = ParseTerm();              │                          │
│  │   auto right = ParseTerm();             │                          │
│  │   return std::make_shared<BinaryExpr>(  │                          │
│  │     op, left, right);                   │ ◀── Shared ownership     │
│  │ }                                       │                          │
│  └─────────────────────────────────────────┘                          │
│                                                                         │
│  Symbol Table Management:                                              │
│  ┌─────────────────────────────────────────┐                          │
│  │ class Environment {                     │                          │
│  │   llvm::StringMap<                      │                          │
│  │     std::shared_ptr<Symbol>> symbols;   │ ◀── Automatic cleanup    │
│  │ };                                      │                          │
│  │                                         │                          │
│  │ void ScopeManager::ExitScope() {        │                          │
│  │   scopes.pop_back(); // Automatic       │                          │
│  │   // destruction of Environment         │                          │
│  │ }                                       │                          │
│  └─────────────────────────────────────────┘                          │
│                                                                         │
│  LLVM Memory Management:                                               │
│  ┌─────────────────────────────────────────┐                          │
│  │ class CodeGen {                         │                          │
│  │   llvm::LLVMContext context;            │ ◀── RAII cleanup         │
│  │   std::unique_ptr<llvm::Module> module; │                          │
│  │   llvm::IRBuilder<> builder;            │                          │
│  │ };                                      │                          │
│  │                                         │                          │
│  │ // LLVM handles instruction memory       │                          │
│  │ // automatically within context         │                          │
│  └─────────────────────────────────────────┘                          │
└─────────────────────────────────────────────────────────────────────────┘
```

## 6. Integration Points Summary

### 6.1 Key Interface Methods

| Component | Interface Method | Input | Output | Purpose |
|-----------|------------------|--------|---------|---------|
| **Lexer** | `NextToken(Token& tok)` | Character stream | Token | Tokenization |
| **Parser** | `ParseExpr()` | Token stream | AST Node | Syntax analysis |
| **Parser** | `Expect(TokenType)` | Token type | Boolean | Token matching |
| **Semantic** | `AnalyzeExpr(Expr*)` | AST Node | Type info | Type checking |
| **Semantic** | `FindSymbol(name)` | Symbol name | Symbol | Symbol lookup |
| **CodeGen** | `VisitExpr(Expr*)` | AST Node | LLVM Value | IR generation |
| **CodeGen** | `CreateFunction()` | Function AST | LLVM Function | Function creation |
| **Backend** | `LowerOperation()` | LLVM IR | SelectionDAG | IR lowering |
| **Backend** | `Select(SDNode*)` | SelectionDAG | Machine instr | Instruction selection |
| **Backend** | `emitInstruction()` | Machine instr | Assembly | Assembly generation |

### 6.2 Data Flow Summary

```
Source Code (text)
     ↓ (character by character)
Token Stream (Token objects)
     ↓ (recursive descent parsing)
Abstract Syntax Tree (AST nodes with shared_ptr)
     ↓ (visitor pattern traversal)
Annotated AST (AST + type information)
     ↓ (visitor pattern code generation)
LLVM IR (platform-independent instructions)
     ↓ (instruction selection + lowering)
SelectionDAG (target-specific representation)
     ↓ (pattern matching + custom selection)
Machine Instructions (target machine code)
     ↓ (assembly printer)
RISC-V Assembly (human-readable text)
     ↓ (assembler + linker)
Executable Binary (machine code)
```

This complete function call flow diagram shows how each component interfaces with the others, the data transformations at each stage, and the specific methods used for communication between components. The entire pipeline is designed for modularity, allowing each component to be tested and modified independently while maintaining clean interfaces.