# Coding Tutorial 2: Building a Recursive Descent Parser

## Learning Objectives
- Understand how recursive descent parsing works step by step
- Write actual C++ code for parsing expressions with operator precedence
- Build Abstract Syntax Trees (AST) from grammar rules
- Handle left-associativity and operator precedence correctly
- Create a parser that integrates with the lexer

## Part 1: Understanding the Grammar and AST Design

### The Grammar We're Implementing

```
prog   : (expr? ";")*
expr   : term (("+" | "-") term)*     # Addition/subtraction (lower precedence)
term   : factor (("*" | "/") factor)* # Multiplication/division (higher precedence)  
factor : number | "(" expr ")"        # Numbers and parenthesized expressions
```

**Key Insight**: This grammar naturally encodes operator precedence!
- `*` and `/` bind tighter than `+` and `-`
- Parentheses override precedence

### AST Node Design

First, let's design our Abstract Syntax Tree nodes:

```cpp
#pragma once
#include <memory>
#include <vector>
#include "llvm/IR/Value.h"

// Forward declarations
class Program;
class Expr;
class BinaryExpr;
class NumberExpr;

// Visitor pattern for traversing AST (we'll cover this in detail later)
class Visitor {
public:
    virtual ~Visitor() {}
    virtual llvm::Value* VisitProgram(Program* p) = 0;
    virtual llvm::Value* VisitBinaryExpr(BinaryExpr* expr) = 0;
    virtual llvm::Value* VisitNumberExpr(NumberExpr* expr) = 0;
};

// Base class for all expressions
class Expr {
public:
    virtual ~Expr() {}
    virtual llvm::Value* Accept(Visitor* v) = 0;
};

// Operator types
enum class OpCode {
    Add,    // +
    Sub,    // -
    Mul,    // *
    Div     // /
};

// Binary expressions: left op right (e.g., "5 + 3")
class BinaryExpr : public Expr {
public:
    OpCode op;
    std::shared_ptr<Expr> left;
    std::shared_ptr<Expr> right;
    
    llvm::Value* Accept(Visitor* v) override {
        return v->VisitBinaryExpr(this);
    }
};

// Number literals: 42, 123, etc.
class NumberExpr : public Expr {
public:
    int value;
    
    NumberExpr(int val) : value(val) {}
    
    llvm::Value* Accept(Visitor* v) override {
        return v->VisitNumberExpr(this);
    }
};

// Program: collection of expressions
class Program {
public:
    std::vector<std::shared_ptr<Expr>> expressions;
};
```

## Part 2: Parser Class Design

```cpp
#pragma once
#include "lexer.h"
#include "ast.h"

class Parser {
public:
    // Constructor: initialize with lexer
    Parser(Lexer& lexer);
    
    // Main parsing entry point
    std::shared_ptr<Program> ParseProgram();

private:
    // Grammar rule methods (one method per grammar rule)
    std::shared_ptr<Expr> ParseExpr();     // expr rule
    std::shared_ptr<Expr> ParseTerm();     // term rule  
    std::shared_ptr<Expr> ParseFactor();   // factor rule
    
    // Token management utilities
    bool Expect(TokenType type);    // Check if current token is of given type
    bool Consume(TokenType type);   // Check and consume token if it matches
    void Advance();                 // Move to next token
    void ReportError(const std::string& message);  // Error reporting
    
private:
    Lexer& lexer;
    Token currentToken;    // Current token being examined
};
```

## Part 3: Implementing the Parser Step by Step

### Step 1: Constructor and Token Management

```cpp
#include "parser.h"

Parser::Parser(Lexer& lex) : lexer(lex) {
    // Get the first token to start parsing
    Advance();
}

void Parser::Advance() {
    lexer.NextToken(currentToken);
    // Debug output (remove in production)
    // currentToken.Dump();
}

bool Parser::Expect(TokenType type) {
    return currentToken.tokenType == type;
}

bool Parser::Consume(TokenType type) {
    if (currentToken.tokenType == type) {
        Advance();
        return true;
    }
    return false;
}

void Parser::ReportError(const std::string& message) {
    std::cerr << "Parse error at line " << currentToken.row 
              << ", col " << currentToken.col 
              << ": " << message << std::endl;
    // In a real compiler, you'd integrate with diagnostic system
}
```

### Step 2: ParseProgram (Top Level)

```cpp
std::shared_ptr<Program> Parser::ParseProgram() {
    auto program = std::make_shared<Program>();
    
    // Keep parsing until end of file
    while (!Expect(TokenType::eof)) {
        
        // Handle empty statements (just semicolons)
        if (Expect(TokenType::semi)) {
            Advance();  // Skip semicolon
            continue;
        }
        
        // Parse an expression
        auto expr = ParseExpr();
        if (expr) {
            program->expressions.push_back(expr);
        }
        
        // Expect semicolon after expression (optional for now)
        if (Expect(TokenType::semi)) {
            Advance();
        }
    }
    
    return program;
}
```

### Step 3: ParseFactor (Leaves of the Parse Tree)

Start with the **bottom** of the grammar - the simplest elements:

```cpp
std::shared_ptr<Expr> Parser::ParseFactor() {
    // factor : number | "(" expr ")"
    
    if (Expect(TokenType::number)) {
        // It's a number literal
        int value = currentToken.value;
        Advance();  // Consume the number token
        
        return std::make_shared<NumberExpr>(value);
        
    } else if (Expect(TokenType::l_parent)) {
        // It's a parenthesized expression: "(" expr ")"
        Advance();  // Consume '('
        
        auto expr = ParseExpr();  // Recursively parse the inner expression
        
        if (!Consume(TokenType::r_parent)) {
            ReportError("Expected ')' after expression");
            return nullptr;
        }
        
        return expr;
        
    } else {
        ReportError("Expected number or '(' in expression");
        return nullptr;
    }
}
```

**How this works:**
- Numbers become `NumberExpr` nodes
- `(expr)` parses the inner expression and returns it (parentheses just group, don't create nodes)

### Step 4: ParseTerm (Multiplication and Division)

```cpp
std::shared_ptr<Expr> Parser::ParseTerm() {
    // term : factor (("*" | "/") factor)*
    
    // Parse the first factor
    auto left = ParseFactor();
    if (!left) return nullptr;
    
    // Handle any number of * or / operators (left associative)
    while (Expect(TokenType::star) || Expect(TokenType::slash)) {
        
        // Determine the operator
        OpCode op;
        if (Expect(TokenType::star)) {
            op = OpCode::Mul;
        } else {  // Must be slash
            op = OpCode::Div;
        }
        
        Advance();  // Consume the operator token
        
        // Parse the right operand
        auto right = ParseFactor();
        if (!right) return nullptr;
        
        // Create binary expression node
        auto binaryExpr = std::make_shared<BinaryExpr>();
        binaryExpr->op = op;
        binaryExpr->left = left;
        binaryExpr->right = right;
        
        // This becomes the new left operand for potential next operator
        left = binaryExpr;
    }
    
    return left;
}
```

**Left Associativity Example:**
Input: `2 * 3 * 4`

**Step by step:**
1. `left = ParseFactor()` → `NumberExpr(2)`
2. See `*`, create `BinaryExpr(2 * 3)`, `left = BinaryExpr(2 * 3)`
3. See `*`, create `BinaryExpr((2 * 3) * 4)`, `left = BinaryExpr((2 * 3) * 4)`

**Result AST:**
```
     *
   /   \
  *     4
 / \
2   3
```

This correctly represents left-associative evaluation: `(2 * 3) * 4`.

### Step 5: ParseExpr (Addition and Subtraction)

```cpp
std::shared_ptr<Expr> Parser::ParseExpr() {
    // expr : term (("+" | "-") term)*
    
    // Parse the first term
    auto left = ParseTerm();
    if (!left) return nullptr;
    
    // Handle any number of + or - operators (left associative)
    while (Expect(TokenType::plus) || Expect(TokenType::minus)) {
        
        // Determine the operator
        OpCode op;
        if (Expect(TokenType::plus)) {
            op = OpCode::Add;
        } else {  // Must be minus
            op = OpCode::Sub;
        }
        
        Advance();  // Consume the operator token
        
        // Parse the right operand
        auto right = ParseTerm();
        if (!right) return nullptr;
        
        // Create binary expression node
        auto binaryExpr = std::make_shared<BinaryExpr>();
        binaryExpr->op = op;
        binaryExpr->left = left;
        binaryExpr->right = right;
        
        // This becomes the new left operand for potential next operator
        left = binaryExpr;
    }
    
    return left;
}
```

## Part 4: Understanding Operator Precedence Through Grammar

Let's trace through parsing `2 + 3 * 4`:

### Call Stack Trace:

```cpp
ParseExpr()                    // Entry point
├── ParseTerm()                // Parse "2"
│   └── ParseFactor() → 2      // Returns NumberExpr(2)
├── See '+', consume it
├── ParseTerm()                // Parse "3 * 4"
│   ├── ParseFactor() → 3      // Returns NumberExpr(3)
│   ├── See '*', consume it
│   ├── ParseFactor() → 4      // Returns NumberExpr(4)
│   └── Return BinaryExpr(3 * 4)  // Multiplication happens first!
└── Return BinaryExpr(2 + (3 * 4))  // Addition at top level
```

**Result AST:**
```
     +
   /   \
  2     *
       / \
      3   4
```

**Why this works:**
- `ParseTerm()` handles `*` and `/` before returning to `ParseExpr()`
- This forces multiplication to bind tighter than addition
- The grammar structure **automatically** handles precedence!

## Part 5: Advanced Parsing Techniques

### Error Recovery

```cpp
std::shared_ptr<Expr> Parser::ParseFactor() {
    if (Expect(TokenType::number)) {
        int value = currentToken.value;
        Advance();
        return std::make_shared<NumberExpr>(value);
        
    } else if (Expect(TokenType::l_parent)) {
        Advance();
        auto expr = ParseExpr();
        
        if (!Consume(TokenType::r_parent)) {
            ReportError("Expected ')' after expression");
            
            // Error recovery: skip tokens until we find ')' or ';'
            while (!Expect(TokenType::eof) && 
                   !Expect(TokenType::r_parent) && 
                   !Expect(TokenType::semi)) {
                Advance();
            }
            
            if (Expect(TokenType::r_parent)) {
                Advance();  // Consume the ')'
            }
        }
        
        return expr;
        
    } else {
        ReportError("Expected number or '(' in expression");
        
        // Error recovery: create a dummy node to continue parsing
        return std::make_shared<NumberExpr>(0);  // Dummy value
    }
}
```

### Adding Unary Operators

Let's extend the grammar to handle unary minus:

```
factor : number | "(" expr ")" | "-" factor | "+" factor
```

```cpp
std::shared_ptr<Expr> Parser::ParseFactor() {
    if (Expect(TokenType::number)) {
        int value = currentToken.value;
        Advance();
        return std::make_shared<NumberExpr>(value);
        
    } else if (Expect(TokenType::l_parent)) {
        Advance();
        auto expr = ParseExpr();
        if (!Consume(TokenType::r_parent)) {
            ReportError("Expected ')' after expression");
        }
        return expr;
        
    } else if (Expect(TokenType::minus)) {
        // Unary minus: -factor
        Advance();  // Consume '-'
        auto operand = ParseFactor();  // Recursively parse the operand
        
        // Create unary expression node
        auto unaryExpr = std::make_shared<UnaryExpr>();
        unaryExpr->op = UnaryOpCode::Neg;
        unaryExpr->operand = operand;
        return unaryExpr;
        
    } else if (Expect(TokenType::plus)) {
        // Unary plus: +factor (just return the factor)
        Advance();  // Consume '+'
        return ParseFactor();
        
    } else {
        ReportError("Expected number, '(', '+', or '-' in expression");
        return std::make_shared<NumberExpr>(0);  // Error recovery
    }
}
```

### Adding More Operators with Precedence

Let's add comparison operators (`<`, `>`, `==`, `!=`):

```
expr       : comparison
comparison : term (("==" | "!=" | "<" | ">") term)*
term       : factor (("*" | "/") factor)*
factor     : number | "(" expr ")" | "-" factor | "+" factor
```

```cpp
std::shared_ptr<Expr> Parser::ParseExpr() {
    // Now just delegates to comparison
    return ParseComparison();
}

std::shared_ptr<Expr> Parser::ParseComparison() {
    auto left = ParseTerm();
    if (!left) return nullptr;
    
    while (Expect(TokenType::equal_equal) || Expect(TokenType::not_equal) ||
           Expect(TokenType::less) || Expect(TokenType::greater)) {
        
        OpCode op;
        if (Expect(TokenType::equal_equal)) {
            op = OpCode::Equal;
        } else if (Expect(TokenType::not_equal)) {
            op = OpCode::NotEqual;
        } else if (Expect(TokenType::less)) {
            op = OpCode::Less;
        } else {  // greater
            op = OpCode::Greater;
        }
        
        Advance();
        auto right = ParseTerm();
        if (!right) return nullptr;
        
        auto binaryExpr = std::make_shared<BinaryExpr>();
        binaryExpr->op = op;
        binaryExpr->left = left;
        binaryExpr->right = right;
        
        left = binaryExpr;
    }
    
    return left;
}
```

## Part 6: Testing Your Parser

### Simple Test Program

```cpp
#include "lexer.h"
#include "parser.h"
#include <iostream>

void TestParser() {
    std::string input = "2 + 3 * 4; (5 - 1) * 2; 42;";
    
    Lexer lexer(llvm::StringRef(input));
    Parser parser(lexer);
    
    auto program = parser.ParseProgram();
    
    std::cout << "Parsed " << program->expressions.size() << " expressions" << std::endl;
    
    // You can add AST printing here (we'll cover this in the next tutorial)
}

int main() {
    TestParser();
    return 0;
}
```

### Creating an AST Printer (Debug Tool)

```cpp
class ASTPrinter : public Visitor {
public:
    llvm::Value* VisitProgram(Program* p) override {
        std::cout << "Program with " << p->expressions.size() << " expressions:\\n";
        for (auto& expr : p->expressions) {
            expr->Accept(this);
            std::cout << "\\n";
        }
        return nullptr;
    }
    
    llvm::Value* VisitBinaryExpr(BinaryExpr* expr) override {
        std::cout << "(";
        expr->left->Accept(this);
        
        switch (expr->op) {
        case OpCode::Add: std::cout << " + "; break;
        case OpCode::Sub: std::cout << " - "; break;
        case OpCode::Mul: std::cout << " * "; break;
        case OpCode::Div: std::cout << " / "; break;
        }
        
        expr->right->Accept(this);
        std::cout << ")";
        return nullptr;
    }
    
    llvm::Value* VisitNumberExpr(NumberExpr* expr) override {
        std::cout << expr->value;
        return nullptr;
    }
};

// Usage:
void TestParserWithPrinting() {
    std::string input = "2 + 3 * 4;";
    Lexer lexer(llvm::StringRef(input));
    Parser parser(lexer);
    auto program = parser.ParseProgram();
    
    ASTPrinter printer;
    program->expressions[0]->Accept(&printer);
    // Output: (2 + (3 * 4))
}
```

## Part 7: Integration with Lexer

### Complete Integration Example

```cpp
// main.cc
#include "lexer.h"
#include "parser.h"
#include <fstream>
#include <sstream>

int main(int argc, char* argv[]) {
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " <source_file>" << std::endl;
        return 1;
    }
    
    // Read source file
    std::ifstream file(argv[1]);
    std::stringstream buffer;
    buffer << file.rdbuf();
    std::string source = buffer.str();
    
    // Lex and parse
    Lexer lexer(llvm::StringRef(source));
    Parser parser(lexer);
    
    auto program = parser.ParseProgram();
    
    if (program && !program->expressions.empty()) {
        std::cout << "Successfully parsed program with " 
                  << program->expressions.size() << " expressions" << std::endl;
                  
        // Print the AST
        ASTPrinter printer;
        for (auto& expr : program->expressions) {
            expr->Accept(&printer);
            std::cout << std::endl;
        }
    } else {
        std::cout << "Parse failed" << std::endl;
        return 1;
    }
    
    return 0;
}
```

## Part 8: Common Parsing Pitfalls and Solutions

### Problem 1: Left Recursion

**Don't do this:**
```
expr : expr "+" term | term
```

This causes infinite recursion! The parser calls `ParseExpr()` which immediately calls `ParseExpr()` again.

**Solution: Convert to right recursion with iteration:**
```
expr : term ("+" term)*
```

### Problem 2: Precedence Mistakes

**Wrong approach:**
```cpp
// This gives + higher precedence than *!
std::shared_ptr<Expr> Parser::ParseExpr() {
    auto left = ParseFactor();  // Skip term level!
    // ... handle + and -
}
```

**Correct approach:**
- Always call the **next higher precedence** level
- `ParseExpr()` calls `ParseTerm()` calls `ParseFactor()`

### Problem 3: Error Recovery

```cpp
// Bad: Parser stops on first error
if (!Consume(TokenType::semi)) {
    return nullptr;  // Gives up completely
}

// Better: Try to recover and continue
if (!Consume(TokenType::semi)) {
    ReportError("Expected ';'");
    // Skip to next statement
    while (!Expect(TokenType::eof) && !Expect(TokenType::semi)) {
        Advance();
    }
    if (Expect(TokenType::semi)) {
        Advance();
    }
}
```

## Summary: What You've Learned

You now know how to:

1. **Design AST nodes** that represent your language constructs
2. **Map grammar rules to parsing methods** (one rule = one method)
3. **Handle operator precedence** through grammar structure
4. **Implement left associativity** with iteration
5. **Parse parenthesized expressions** with recursion
6. **Handle errors gracefully** with recovery strategies
7. **Test your parser** with debug output

**Key Algorithms You Implemented:**
- **Recursive Descent**: Each grammar rule becomes a method
- **Precedence Climbing**: Grammar structure encodes operator precedence
- **Left Associativity**: Iterative loops that build left-associative trees
- **Error Recovery**: Strategies to continue parsing after errors

**Next Steps:**
- **AST Visitor Pattern**: Clean way to traverse and process ASTs
- **Semantic Analysis**: Type checking and symbol table management
- **Code Generation**: Converting ASTs to LLVM IR

You now have a complete, working parser that can handle complex expressions with proper precedence and associativity!