# Complete Coding Tutorials - From Theory to Implementation

## Overview

This comprehensive coding tutorial series teaches you how to **actually write** a complete C compiler from scratch. Unlike conceptual tutorials, these focus on **real implementation details**, showing you exactly how to write the code for each component.

## Learning Philosophy

✅ **Hands-on Implementation**: Every concept includes actual C++ code you can compile and run  
✅ **Step-by-step Construction**: Build components incrementally with working examples at each step  
✅ **Real-world Integration**: Components work together in a complete compilation pipeline  
✅ **Interface Understanding**: Learn how components communicate and call each other  
✅ **Error Handling**: Production-quality error handling and diagnostics  

## Tutorial Series Structure

### [Tutorial 1: Building a Lexer from Scratch](01_building_lexer_from_scratch.md)
**Duration**: 3-4 hours | **Difficulty**: Beginner | **Prerequisites**: Basic C++ knowledge

#### What You'll Learn
- **Design token representations** with all necessary information (type, value, location)
- **Implement character-by-character scanning** with proper state management
- **Handle multi-character operators** with lookahead techniques (`==`, `++`, `<<`, etc.)
- **Distinguish keywords from identifiers** using hash table lookups
- **Track source locations** for precise error reporting
- **Handle edge cases** like comments, strings, escape sequences, and EOF

#### Key Implementation Skills
```cpp
class Lexer {
    void NextToken(Token& tok);           // Main tokenization algorithm
    void SkipWhitespace();                // Whitespace and newline handling
    void LexNumber(Token& tok);           // Number recognition state machine
    void LexIdentifier(Token& tok);       // Identifier/keyword discrimination
    void LexOperator(Token& tok);         // Multi-character operator lookahead
    void LexString(Token& tok);           // String literal with escape sequences
};
```

#### Practical Outcomes
- Working lexer that handles the complete C token set
- Professional error recovery and source location tracking
- Clean interface for parser integration
- Comprehensive test suite with edge cases

---

### [Tutorial 2: Building a Recursive Descent Parser](02_building_recursive_descent_parser.md)
**Duration**: 4-5 hours | **Difficulty**: Intermediate | **Prerequisites**: Tutorial 1

#### What You'll Learn
- **Map grammar rules to parsing methods** (one rule = one method pattern)
- **Handle operator precedence** through grammar structure, not ad-hoc rules
- **Implement left associativity** with iterative loops building left-heavy trees
- **Parse parenthesized expressions** with recursive calls
- **Handle syntax errors gracefully** with recovery strategies
- **Build Abstract Syntax Trees** that accurately represent program structure

#### Key Implementation Skills
```cpp
class Parser {
    std::shared_ptr<Expr> ParseExpr();        // expr : term (("+" | "-") term)*
    std::shared_ptr<Expr> ParseTerm();        // term : factor (("*" | "/") factor)*
    std::shared_ptr<Expr> ParseFactor();      // factor : number | "(" expr ")"
    
    bool Expect(TokenType type);              // Token lookahead
    bool Consume(TokenType type);             // Token consumption with validation
    void ReportError(const std::string& msg); // Error reporting with recovery
};
```

#### Grammar → Code Mapping
**Grammar Rule**:
```
expr : term (("+" | "-") term)*
```

**Implementation**:
```cpp
std::shared_ptr<Expr> Parser::ParseExpr() {
    auto left = ParseTerm();                  // Parse first term
    while (Expect(TokenType::plus) || Expect(TokenType::minus)) {
        OpCode op = Expect(TokenType::plus) ? OpCode::Add : OpCode::Sub;
        Advance();
        auto right = ParseTerm();
        left = CreateBinaryExpr(op, left, right);  // Left-associative tree
    }
    return left;
}
```

#### Practical Outcomes
- Complete recursive descent parser for expressions
- Correct operator precedence through grammar design
- Error recovery that allows parsing to continue
- AST construction with proper tree structure

---

### [Tutorial 3: AST Visitor Pattern and Code Generation](03_ast_visitor_pattern_and_codegen.md)
**Duration**: 5-6 hours | **Difficulty**: Advanced | **Prerequisites**: Tutorials 1-2

#### What You'll Learn
- **Implement the Visitor design pattern** for clean AST traversal
- **Create multiple visitors** for different purposes (printing, code generation, analysis)
- **Set up LLVM IR generation infrastructure** with contexts, modules, and builders
- **Generate LLVM instructions** for arithmetic, comparisons, and function calls
- **Handle function declarations and calls** with proper ABI compliance
- **Create complete LLVM functions** with basic blocks and control flow

#### Key Implementation Skills
```cpp
class Visitor {
    virtual llvm::Value* VisitBinaryExpr(BinaryExpr* expr) = 0;
    virtual llvm::Value* VisitNumberExpr(NumberExpr* expr) = 0;
    // ... other visit methods
};

class CodeGen : public Visitor {
    llvm::Value* VisitBinaryExpr(BinaryExpr* expr) override {
        Value* left = expr->left->Accept(this);   // Recursive generation
        Value* right = expr->right->Accept(this);
        
        switch (expr->op) {
        case OpCode::Add:
            return builder.CreateAdd(left, right, "add_tmp");
        case OpCode::Mul:
            return builder.CreateMul(left, right, "mul_tmp");
        // ...
        }
    }
};
```

#### LLVM Integration Deep Dive
```cpp
class CodeGen {
    llvm::LLVMContext context;                    // LLVM state container
    llvm::IRBuilder<> builder;                    // Instruction construction
    std::unique_ptr<llvm::Module> module;         // Compilation unit
    
    void CreateMainFunction();                    // Function setup
    void CreatePrintfDeclaration();              // External function declarations
    llvm::Value* GenerateExpression(Expr* expr); // Expression code generation
};
```

#### Practical Outcomes
- Multiple working visitors (print, code generation, analysis)
- Complete LLVM IR code generator
- Generated IR that can be executed with `lli` or compiled with `llc`
- Understanding of LLVM's type system and instruction model

---

### [Tutorial 4: Semantic Analysis and Type System](04_semantic_analysis_and_type_system.md)
**Duration**: 6-7 hours | **Difficulty**: Advanced | **Prerequisites**: Tutorials 1-3

#### What You'll Learn
- **Design a complete C type system** with primary types, pointers, arrays, and structures
- **Implement symbol tables** with proper scope management and conflict detection
- **Perform comprehensive type checking** with compatibility rules and implicit conversions
- **Handle variable declarations** with initialization type checking
- **Analyze expressions** with type inference and error reporting
- **Process control flow** with scope management for blocks and functions

#### Practical Outcomes
- Complete type system supporting all C types
- Symbol table with proper scoping rules
- Type checking with informative error messages
- Annotated AST ready for optimized code generation

---

### [Tutorial 5: Building a RISC-V Backend from Scratch](05_building_riscv_backend_from_scratch.md)
**Duration**: 8-10 hours | **Difficulty**: Expert | **Prerequisites**: Tutorials 1-4

#### What You'll Learn
- **Design a complete C type system** with primary types, pointers, arrays, and structures
- **Implement symbol tables** with proper scope management and conflict detection
- **Perform comprehensive type checking** with compatibility rules and implicit conversions
- **Handle variable declarations** with initialization type checking
- **Analyze expressions** with type inference and error reporting
- **Process control flow** with scope management for blocks and functions

#### Key Implementation Skills
```cpp
class ScopeManager {
    std::vector<std::shared_ptr<Environment>> scopes;
    
    void EnterScope();                           // Create new scope level
    void ExitScope();                            // Remove current scope
    std::shared_ptr<Symbol> FindSymbol(name);   // Multi-scope symbol lookup
    bool AddSymbol(name, type, kind);           // Symbol insertion with conflict checking
};

class SemanticAnalyzer {
    bool AnalyzeVariableDecl(VariableDecl* decl);
    bool AnalyzeBinaryExpr(BinaryExpr* expr);
    bool AnalyzeFunctionCall(FunctionCall* call);
    
    bool IsTypeCompatible(CType* from, CType* to);
    std::shared_ptr<AstNode> CreateImplicitCast(expr, targetType);
};
```

#### Type System Architecture
```cpp
class CType {
    enum Kind { TY_Void, TY_Char, TY_Int, TY_Pointer, TY_Array, TY_Struct };
    virtual bool IsCompatibleWith(std::shared_ptr<CType> other) = 0;
    virtual llvm::Type* Accept(TypeVisitor* visitor) = 0;
};

class CPointerType : public CType {
    std::shared_ptr<CType> pointeeType;
    // Pointer-specific operations
};

class CArrayType : public CType {
    std::shared_ptr<CType> elementType;
    int length;
    // Array-specific operations
};
```

#### Practical Outcomes
- Complete type system supporting all C types
- Symbol table with proper scoping rules
- Type checking with informative error messages
- Annotated AST ready for optimized code generation

#### What You'll Learn
- **Understand LLVM backend architecture** with instruction selection and register allocation
- **Write TableGen descriptions** for complete RISC-V32I instruction set definitions
- **Implement calling conventions** for function calls, parameter passing, and return values
- **Build instruction selection** with pattern matching and custom SelectionDAG lowering
- **Create assembly generation** with proper RISC-V assembly syntax and formatting
- **Integrate with LLVM** infrastructure for complete compilation pipeline

#### Key Implementation Skills
```cpp
// TableGen instruction definitions
class ArithR<bits<7> funct7, bits<3> funct3, string asmstr, SDNode OpNode>
    : RInst<funct7, funct3, 0b0110011,
           (outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2),
           !strconcat(asmstr, "\t$rd, $rs1, $rs2"),
           [(set GPR:$rd, (OpNode GPR:$rs1, GPR:$rs2))]>;

// Instruction selection implementation
void OneDAGToDAGISel::Select(SDNode *Node) {
    if (SelectCode(Node)) return;  // Try auto-generated patterns
    
    // Handle special cases manually
    switch (Node->getOpcode()) {
    case ISD::Constant:
        // Convert constants to RISC-V immediate instructions
        // ...
    }
}

// Calling convention implementation  
def CC_One : CallingConv<[
    CCIfType<[i32], CCAssignToReg<[A0, A1, A2, A3, A4, A5, A6, A7]>>,
    CCAssignToStack<4, 4>
]>;
```

#### Practical Outcomes
- Complete RISC-V32I backend with full instruction set support
- Working calling conventions compatible with RISC-V ABI
- Assembly generation producing executable RISC-V code
- Integration with LLVM compilation pipeline

---

## Integration and Complete Pipeline

### Full Compiler Integration
```cpp
// Complete compilation pipeline
int main(int argc, char* argv[]) {
    // 1. Lexical Analysis
    std::string source = ReadSourceFile(argv[1]);
    Lexer lexer(llvm::StringRef(source));
    
    // 2. Syntax Analysis
    Parser parser(lexer);
    auto program = parser.ParseProgram();
    
    // 3. Semantic Analysis
    DiagEngine diagEngine;
    SemanticAnalyzer analyzer(diagEngine);
    if (!analyzer.AnalyzeProgram(program)) {
        diagEngine.PrintErrors();
        return 1;
    }
    
    // 4. Code Generation
    CodeGen codegen;
    codegen.GenerateCode(program);
    
    // 5. Backend Compilation (LLVM IR → RISC-V Assembly)
    std::string TargetTriple = "one-unknown-unknown";
    auto TM = CreateTargetMachine(TargetTriple);
    CompileToAssembly(program, TM.get());
    
    // 6. Output
    codegen.PrintIR();  // LLVM IR
    // Assembly file also generated
    return 0;
}
```

### Component Communication Patterns

**Lexer → Parser Interface**:
```cpp
class Parser {
    void Advance() { lexer.NextToken(currentToken); }
    bool Expect(TokenType type) { return currentToken.tokenType == type; }
    bool Consume(TokenType type) {
        if (Expect(type)) { Advance(); return true; }
        return false;
    }
};
```

**Parser → Semantic Analyzer Interface**:
```cpp
class SemanticAnalyzer {
    std::shared_ptr<AstNode> AnalyzeExpression(std::shared_ptr<AstNode> expr) {
        return expr->Accept(this);  // Visitor pattern dispatch
    }
};
```

**Semantic Analyzer → Code Generator Interface**:
```cpp
class CodeGen {
    llvm::Value* GenerateCode(std::shared_ptr<AstNode> node) {
        // Use annotated type information from semantic analysis
        auto type = node->GetType();
        auto llvmType = type->Accept(typeConverter);
        // Generate appropriate LLVM instructions
    }
};
```

## Skills Progression Matrix

| Tutorial | Lexical Analysis | Parsing | AST Design | Type Systems | Frontend Codegen | Backend Design | RISC-V Assembly |
|----------|------------------|---------|------------|--------------|------------------|----------------|-----------------|
| 1 | ✅ **Complete** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| 2 | ✅ **Complete** | ✅ **Complete** | 🟡 **Basic** | ❌ | ❌ | ❌ | ❌ |
| 3 | ✅ **Complete** | ✅ **Complete** | ✅ **Complete** | ❌ | 🟡 **Basic** | ❌ | ❌ |
| 4 | ✅ **Complete** | ✅ **Complete** | ✅ **Complete** | ✅ **Complete** | ✅ **Complete** | ❌ | ❌ |
| 5 | ✅ **Complete** | ✅ **Complete** | ✅ **Complete** | ✅ **Complete** | ✅ **Complete** | ✅ **Complete** | ✅ **Complete** |

**Legend**: ❌ Not covered, 🟡 Partially covered, ✅ Fully mastered

## Real-World Applications

### Code Quality You'll Achieve
- **Production-level error handling** with precise source locations and recovery
- **Modular architecture** with clean interfaces between components
- **Comprehensive testing** with unit tests and integration tests
- **Performance considerations** for large source files
- **Memory management** with smart pointers and RAII

### Industry-Standard Patterns
- **Visitor Pattern**: Clean separation of tree structure from operations
- **Factory Pattern**: Type creation and management
- **Strategy Pattern**: Different parsing strategies for different constructs
- **Observer Pattern**: Error reporting and diagnostics

### Extensibility Design
The architecture you'll build supports easy extension:
- **New language features**: Add AST nodes, extend visitors
- **New target architectures**: Implement new code generators
- **New optimizations**: Add optimization passes
- **New analysis tools**: Create new visitors for static analysis

## Prerequisites and Environment

### Required Knowledge
- **C++ Fundamentals**: Classes, inheritance, templates, smart pointers
- **Basic Algorithms**: Tree traversal, hash tables, recursive algorithms
- **Design Patterns**: Understanding of visitor pattern helpful but not required

### Software Requirements
- **Compiler**: GCC 9+ or Clang 10+ with C++17 support
- **LLVM**: Version 10+ with development headers
- **Build System**: CMake 3.15+ 
- **Platform**: Linux (Ubuntu 20.04+) or macOS

### Hardware Requirements
- **Memory**: 4GB+ RAM for LLVM compilation
- **Storage**: 2GB+ free space for source and build artifacts
- **CPU**: Multi-core recommended for parallel builds

## Learning Path and Time Investment

### Recommended Schedule
- **Week 1**: Tutorial 1 (Lexer) - Focus on understanding character processing and state machines
- **Week 2**: Tutorial 2 (Parser) - Master recursive descent and AST construction  
- **Week 3**: Tutorial 3 (Code Generation) - Learn LLVM IR and visitor pattern
- **Week 4**: Tutorial 4 (Semantic Analysis) - Complete the type system and symbol tables

### Practice Projects
After completing the tutorials, extend the compiler:
1. **Add new operators**: Implement `&&`, `||`, `?:` operators
2. **Support more types**: Add `float`, `double`, `long` types
3. **Implement functions**: Add function parameters and return statements
4. **Add control flow**: Implement `if`, `while`, `for` statements

## Success Indicators

### Knowledge Mastery Checkpoints
- [ ] Can implement a complete lexer for any programming language
- [ ] Understands how grammar design affects implementation complexity
- [ ] Can explain the visitor pattern and implement new tree operations
- [ ] Knows how to design type systems with proper inheritance hierarchies
- [ ] Can generate LLVM IR for complex language constructs
- [ ] Understands the complete compilation pipeline from source to executable

### Practical Skills Assessment
- [ ] Your lexer handles all edge cases and provides good error messages
- [ ] Your parser correctly implements operator precedence and associativity
- [ ] Your code generator produces correct and efficient LLVM IR
- [ ] Your semantic analyzer catches type errors and scope violations
- [ ] Your complete compiler can handle substantial C programs

### Project Portfolio
By completion, you'll have built:
- **Production-quality lexer** with comprehensive token support
- **Robust recursive descent parser** with error recovery
- **Multi-purpose AST visitor system** for various tree operations
- **Complete type checker** with sophisticated error reporting
- **LLVM code generator** producing executable programs

## Getting Started

1. **Set up your environment** with LLVM development tools
2. **Start with Tutorial 1** - don't skip the foundational lexer implementation
3. **Code along actively** - type out the examples rather than just reading
4. **Test thoroughly** - run the provided test cases and create your own
5. **Experiment and extend** - try variations and improvements

**Ready to start building your compiler?** Begin with [Tutorial 1: Building a Lexer from Scratch](01_building_lexer_from_scratch.md)!

---

## Complete Tutorial Series

1. **[Building a Lexer from Scratch](01_building_lexer_from_scratch.md)** - Tokenization and character processing
2. **[Building a Recursive Descent Parser](02_building_recursive_descent_parser.md)** - Grammar implementation and AST construction  
3. **[AST Visitor Pattern and Code Generation](03_ast_visitor_pattern_and_codegen.md)** - LLVM IR generation
4. **[Semantic Analysis and Type System](04_semantic_analysis_and_type_system.md)** - Type checking and symbol tables
5. **[Building a RISC-V Backend from Scratch](05_building_riscv_backend_from_scratch.md)** - Complete backend implementation
6. **[Complete Function Call Flow Diagram](06_complete_function_call_flow_diagram.md)** - End-to-end compilation pipeline visualization

**Complete the entire series to build a working C compiler that generates RISC-V assembly!**

---

## Advanced Topics (Future Extensions)

### Optimization Passes
- **Constant Folding**: Evaluate constant expressions at compile time
- **Dead Code Elimination**: Remove unreachable code
- **Common Subexpression Elimination**: Avoid redundant computations

### Advanced Language Features
- **Preprocessor**: Macro expansion and conditional compilation
- **Templates/Generics**: Parameterized types and functions
- **Garbage Collection**: Automatic memory management
- **Closures**: First-class functions with captured environments

### Development Tools
- **Debugger Integration**: Generate DWARF debug information
- **IDE Support**: Language server protocol implementation
- **Static Analysis**: Bug detection and code quality tools
- **Profiling**: Performance analysis and optimization guidance

**Master the fundamentals first, then explore these advanced topics!**