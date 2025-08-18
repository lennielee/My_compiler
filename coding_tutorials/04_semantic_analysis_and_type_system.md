# Coding Tutorial 4: Semantic Analysis and Type System

## Learning Objectives
- Understand what semantic analysis does and why it's crucial
- Build a complete symbol table system for scope management
- Implement type checking and type compatibility rules
- Handle variables, functions, and user-defined types
- Create diagnostic messages for semantic errors
- Write the code that bridges parsing and code generation

## Part 1: Understanding Semantic Analysis

### What is Semantic Analysis?

**Syntax Analysis** (Parser) asks: "Is this grammatically correct?"
**Semantic Analysis** asks: "Does this make sense?"

Consider this code:
```c
int x = "hello";  // Syntactically correct, semantically wrong!
int y = x + z;    // What if z is undeclared?
```

**Semantic Analysis catches:**
- **Undeclared variables**: Using variables that weren't declared
- **Type mismatches**: Assigning string to int, calling int as function
- **Scope violations**: Accessing variables outside their scope
- **Function call errors**: Wrong number/types of arguments
- **Redeclaration errors**: Declaring the same variable twice

### The Semantic Analysis Pipeline

```
Parser Output (AST) 
        ↓
Symbol Table Construction
        ↓
Type Checking  
        ↓
Scope Resolution
        ↓
Annotated AST → Code Generation
```

## Part 2: Building the Type System

### Designing C Types

C has a rich type system. Let's implement it step by step:

```cpp
// type.h
#pragma once
#include <memory>
#include <vector>
#include <string>
#include "llvm/IR/Type.h"

// Forward declarations
class CPrimaryType;
class CPointerType;
class CArrayType;
class CStructType;
class CFunctionType;

// Visitor pattern for type operations
class TypeVisitor {
public:
    virtual ~TypeVisitor() {}
    virtual llvm::Type* VisitPrimaryType(CPrimaryType* ty) = 0;
    virtual llvm::Type* VisitPointerType(CPointerType* ty) = 0;
    virtual llvm::Type* VisitArrayType(CArrayType* ty) = 0;
    virtual llvm::Type* VisitStructType(CStructType* ty) = 0;
    virtual llvm::Type* VisitFunctionType(CFunctionType* ty) = 0;
};

// Base class for all types
class CType {
public:
    enum Kind {
        TY_Void,
        TY_Char,
        TY_Int,
        TY_Pointer,
        TY_Array,
        TY_Struct,
        TY_Function
    };

protected:
    Kind kind;
    int size;        // Size in bytes
    int alignment;   // Alignment requirement

public:
    CType(Kind k, int s, int align = 4) : kind(k), size(s), alignment(align) {}
    virtual ~CType() {}
    
    Kind GetKind() const { return kind; }
    int GetSize() const { return size; }
    int GetAlignment() const { return alignment; }
    
    // Type checking methods
    virtual bool IsInteger() const { return false; }
    virtual bool IsPointer() const { return false; }
    virtual bool IsArray() const { return false; }
    virtual bool IsStruct() const { return false; }
    virtual bool IsFunction() const { return false; }
    
    // Type compatibility
    virtual bool IsCompatibleWith(std::shared_ptr<CType> other) const = 0;
    
    // LLVM type generation
    virtual llvm::Type* Accept(TypeVisitor* visitor) = 0;
    
    // Debug output
    virtual std::string ToString() const = 0;
};
```

### Implementing Primary Types

```cpp
// Primary types: void, char, int, etc.
class CPrimaryType : public CType {
public:
    CPrimaryType(Kind k, int s) : CType(k, s) {}
    
    bool IsInteger() const override {
        return kind == TY_Char || kind == TY_Int;
    }
    
    bool IsCompatibleWith(std::shared_ptr<CType> other) const override {
        // Same primary type
        if (auto otherPrimary = std::dynamic_pointer_cast<CPrimaryType>(other)) {
            return kind == otherPrimary->kind;
        }
        return false;
    }
    
    llvm::Type* Accept(TypeVisitor* visitor) override {
        return visitor->VisitPrimaryType(this);
    }
    
    std::string ToString() const override {
        switch (kind) {
        case TY_Void: return "void";
        case TY_Char: return "char";
        case TY_Int: return "int";
        default: return "unknown";
        }
    }
};

// Factory functions for common types
class TypeFactory {
public:
    static std::shared_ptr<CType> GetVoidType() {
        static auto voidType = std::make_shared<CPrimaryType>(CType::TY_Void, 0);
        return voidType;
    }
    
    static std::shared_ptr<CType> GetCharType() {
        static auto charType = std::make_shared<CPrimaryType>(CType::TY_Char, 1);
        return charType;
    }
    
    static std::shared_ptr<CType> GetIntType() {
        static auto intType = std::make_shared<CPrimaryType>(CType::TY_Int, 4);
        return intType;
    }
};
```

### Implementing Pointer Types

```cpp
class CPointerType : public CType {
private:
    std::shared_ptr<CType> pointeeType;

public:
    CPointerType(std::shared_ptr<CType> pointee) 
        : CType(TY_Pointer, 8), pointeeType(pointee) {}  // 8 bytes on 64-bit
    
    bool IsPointer() const override { return true; }
    
    std::shared_ptr<CType> GetPointeeType() const { return pointeeType; }
    
    bool IsCompatibleWith(std::shared_ptr<CType> other) const override {
        if (auto otherPtr = std::dynamic_pointer_cast<CPointerType>(other)) {
            // Pointer types are compatible if pointee types are compatible
            return pointeeType->IsCompatibleWith(otherPtr->pointeeType);
        }
        return false;
    }
    
    llvm::Type* Accept(TypeVisitor* visitor) override {
        return visitor->VisitPointerType(this);
    }
    
    std::string ToString() const override {
        return pointeeType->ToString() + "*";
    }
};
```

### Implementing Array Types

```cpp
class CArrayType : public CType {
private:
    std::shared_ptr<CType> elementType;
    int length;  // -1 for unsized arrays

public:
    CArrayType(std::shared_ptr<CType> elemType, int len)
        : CType(TY_Array, elemType->GetSize() * len), elementType(elemType), length(len) {}
    
    bool IsArray() const override { return true; }
    
    std::shared_ptr<CType> GetElementType() const { return elementType; }
    int GetLength() const { return length; }
    
    bool IsCompatibleWith(std::shared_ptr<CType> other) const override {
        if (auto otherArray = std::dynamic_pointer_cast<CArrayType>(other)) {
            return elementType->IsCompatibleWith(otherArray->elementType) &&
                   (length == otherArray->length || length == -1 || otherArray->length == -1);
        }
        return false;
    }
    
    llvm::Type* Accept(TypeVisitor* visitor) override {
        return visitor->VisitArrayType(this);
    }
    
    std::string ToString() const override {
        if (length == -1) {
            return elementType->ToString() + "[]";
        } else {
            return elementType->ToString() + "[" + std::to_string(length) + "]";
        }
    }
};
```

## Part 3: Symbol Table and Scope Management

### Symbol Representation

```cpp
// scope.h
#pragma once
#include "type.h"
#include "llvm/ADT/StringMap.h"
#include <memory>
#include <vector>

enum class SymbolKind {
    Variable,    // Variables and function parameters
    Function,    // Function declarations
    Typedef,     // Type aliases
    StructTag    // Struct/union tags
};

class Symbol {
private:
    SymbolKind kind;
    std::shared_ptr<CType> type;
    std::string name;
    bool isGlobal;
    
public:
    Symbol(SymbolKind k, std::shared_ptr<CType> ty, const std::string& n, bool global = false)
        : kind(k), type(ty), name(n), isGlobal(global) {}
    
    SymbolKind GetKind() const { return kind; }
    std::shared_ptr<CType> GetType() const { return type; }
    const std::string& GetName() const { return name; }
    bool IsGlobal() const { return isGlobal; }
};
```

### Environment (Single Scope Level)

```cpp
class Environment {
private:
    // Separate namespaces for different symbol kinds
    llvm::StringMap<std::shared_ptr<Symbol>> variables;    // Variables, functions
    llvm::StringMap<std::shared_ptr<Symbol>> tags;         // struct/union tags
    llvm::StringMap<std::shared_ptr<Symbol>> typedefs;     // Type aliases

public:
    // Variable operations
    void AddVariable(const std::string& name, std::shared_ptr<CType> type, bool isGlobal = false) {
        variables[name] = std::make_shared<Symbol>(SymbolKind::Variable, type, name, isGlobal);
    }
    
    void AddFunction(const std::string& name, std::shared_ptr<CType> type) {
        variables[name] = std::make_shared<Symbol>(SymbolKind::Function, type, name, true);
    }
    
    std::shared_ptr<Symbol> FindVariable(const std::string& name) {
        auto it = variables.find(name);
        return (it != variables.end()) ? it->second : nullptr;
    }
    
    // Tag operations (struct/union)
    void AddTag(const std::string& name, std::shared_ptr<CType> type) {
        tags[name] = std::make_shared<Symbol>(SymbolKind::StructTag, type, name);
    }
    
    std::shared_ptr<Symbol> FindTag(const std::string& name) {
        auto it = tags.find(name);
        return (it != tags.end()) ? it->second : nullptr;
    }
    
    // Typedef operations
    void AddTypedef(const std::string& name, std::shared_ptr<CType> type) {
        typedefs[name] = std::make_shared<Symbol>(SymbolKind::Typedef, type, name);
    }
    
    std::shared_ptr<Symbol> FindTypedef(const std::string& name) {
        auto it = typedefs.find(name);
        return (it != typedefs.end()) ? it->second : nullptr;
    }
    
    // Check if name conflicts in current scope
    bool HasConflict(const std::string& name, SymbolKind kind) {
        switch (kind) {
        case SymbolKind::Variable:
        case SymbolKind::Function:
            return variables.find(name) != variables.end();
        case SymbolKind::StructTag:
            return tags.find(name) != tags.end();
        case SymbolKind::Typedef:
            return typedefs.find(name) != typedefs.end();
        }
        return false;
    }
};
```

### Scope Stack

```cpp
class ScopeManager {
private:
    std::vector<std::shared_ptr<Environment>> scopes;

public:
    ScopeManager() {
        // Create global scope
        EnterScope();
    }
    
    void EnterScope() {
        scopes.push_back(std::make_shared<Environment>());
    }
    
    void ExitScope() {
        if (scopes.size() > 1) {  // Never remove global scope
            scopes.pop_back();
        }
    }
    
    // Find symbol in current scope only
    std::shared_ptr<Symbol> FindInCurrentScope(const std::string& name, SymbolKind kind) {
        if (scopes.empty()) return nullptr;
        
        auto& currentEnv = scopes.back();
        switch (kind) {
        case SymbolKind::Variable:
        case SymbolKind::Function:
            return currentEnv->FindVariable(name);
        case SymbolKind::StructTag:
            return currentEnv->FindTag(name);
        case SymbolKind::Typedef:
            return currentEnv->FindTypedef(name);
        }
        return nullptr;
    }
    
    // Find symbol in any scope (search from innermost to outermost)
    std::shared_ptr<Symbol> FindSymbol(const std::string& name, SymbolKind kind) {
        // Search from innermost to outermost scope
        for (auto it = scopes.rbegin(); it != scopes.rend(); ++it) {
            std::shared_ptr<Symbol> symbol = nullptr;
            
            switch (kind) {
            case SymbolKind::Variable:
            case SymbolKind::Function:
                symbol = (*it)->FindVariable(name);
                break;
            case SymbolKind::StructTag:
                symbol = (*it)->FindTag(name);
                break;
            case SymbolKind::Typedef:
                symbol = (*it)->FindTypedef(name);
                break;
            }
            
            if (symbol) return symbol;
        }
        return nullptr;
    }
    
    // Add symbol to current scope
    bool AddSymbol(const std::string& name, std::shared_ptr<CType> type, SymbolKind kind, bool isGlobal = false) {
        if (scopes.empty()) return false;
        
        auto& currentEnv = scopes.back();
        
        // Check for conflicts in current scope
        if (currentEnv->HasConflict(name, kind)) {
            return false;  // Symbol already exists
        }
        
        switch (kind) {
        case SymbolKind::Variable:
            currentEnv->AddVariable(name, type, isGlobal);
            break;
        case SymbolKind::Function:
            currentEnv->AddFunction(name, type);
            break;
        case SymbolKind::StructTag:
            currentEnv->AddTag(name, type);
            break;
        case SymbolKind::Typedef:
            currentEnv->AddTypedef(name, type);
            break;
        }
        return true;
    }
    
    bool IsGlobalScope() const {
        return scopes.size() == 1;
    }
};
```

## Part 4: Implementing the Semantic Analyzer

### Semantic Analyzer Class

```cpp
// sema.h
#pragma once
#include "scope.h"
#include "ast.h"
#include "diag_engine.h"

class SemanticAnalyzer {
private:
    ScopeManager scopeManager;
    DiagEngine& diagEngine;

public:
    SemanticAnalyzer(DiagEngine& diag) : diagEngine(diag) {}
    
    // Main entry points
    bool AnalyzeProgram(std::shared_ptr<Program> program);
    
    // Declaration analysis
    std::shared_ptr<AstNode> AnalyzeVariableDecl(VariableDecl* decl);
    std::shared_ptr<AstNode> AnalyzeFunctionDecl(FunctionDecl* decl);
    
    // Expression analysis
    std::shared_ptr<AstNode> AnalyzeExpression(std::shared_ptr<AstNode> expr);
    std::shared_ptr<AstNode> AnalyzeBinaryExpr(BinaryExpr* expr);
    std::shared_ptr<AstNode> AnalyzeVariableAccess(VariableAccess* expr);
    std::shared_ptr<AstNode> AnalyzeFunctionCall(FunctionCall* expr);
    
    // Statement analysis
    std::shared_ptr<AstNode> AnalyzeStatement(std::shared_ptr<AstNode> stmt);
    std::shared_ptr<AstNode> AnalyzeIfStatement(IfStmt* stmt);
    std::shared_ptr<AstNode> AnalyzeBlockStatement(BlockStmt* stmt);
    
    // Type checking utilities
    bool IsTypeCompatible(std::shared_ptr<CType> from, std::shared_ptr<CType> to);
    std::shared_ptr<CType> GetCommonType(std::shared_ptr<CType> type1, std::shared_ptr<CType> type2);
    std::shared_ptr<AstNode> CreateImplicitCast(std::shared_ptr<AstNode> expr, std::shared_ptr<CType> targetType);
};
```

### Variable Declaration Analysis

```cpp
std::shared_ptr<AstNode> SemanticAnalyzer::AnalyzeVariableDecl(VariableDecl* decl) {
    // Check if variable name conflicts in current scope
    auto existing = scopeManager.FindInCurrentScope(decl->GetName(), SymbolKind::Variable);
    if (existing) {
        diagEngine.Report(decl->GetToken(), DiagKind::ERR_Redefinition,
                         "Variable '" + decl->GetName() + "' already declared in this scope");
        return nullptr;
    }
    
    // Add to symbol table
    bool isGlobal = scopeManager.IsGlobalScope();
    if (!scopeManager.AddSymbol(decl->GetName(), decl->GetType(), SymbolKind::Variable, isGlobal)) {
        diagEngine.Report(decl->GetToken(), DiagKind::ERR_Internal,
                         "Failed to add variable to symbol table");
        return nullptr;
    }
    
    // Analyze initializer if present
    if (decl->GetInitializer()) {
        auto initExpr = AnalyzeExpression(decl->GetInitializer());
        if (!initExpr) return nullptr;
        
        // Check type compatibility
        if (!IsTypeCompatible(initExpr->GetType(), decl->GetType())) {
            diagEngine.Report(decl->GetToken(), DiagKind::ERR_TypeMismatch,
                             "Cannot initialize variable of type '" + decl->GetType()->ToString() +
                             "' with expression of type '" + initExpr->GetType()->ToString() + "'");
            return nullptr;
        }
        
        // Create implicit cast if needed
        if (!decl->GetType()->IsCompatibleWith(initExpr->GetType())) {
            initExpr = CreateImplicitCast(initExpr, decl->GetType());
        }
        
        decl->SetInitializer(initExpr);
    }
    
    return std::shared_ptr<AstNode>(decl);
}
```

### Variable Access Analysis

```cpp
std::shared_ptr<AstNode> SemanticAnalyzer::AnalyzeVariableAccess(VariableAccess* expr) {
    // Look up variable in symbol table
    auto symbol = scopeManager.FindSymbol(expr->GetName(), SymbolKind::Variable);
    if (!symbol) {
        diagEngine.Report(expr->GetToken(), DiagKind::ERR_UndeclaredVariable,
                         "Use of undeclared variable '" + expr->GetName() + "'");
        return nullptr;
    }
    
    // Set the type from symbol table
    expr->SetType(symbol->GetType());
    expr->SetSymbol(symbol);
    
    return std::shared_ptr<AstNode>(expr);
}
```

### Binary Expression Analysis

```cpp
std::shared_ptr<AstNode> SemanticAnalyzer::AnalyzeBinaryExpr(BinaryExpr* expr) {
    // Analyze left and right operands
    auto left = AnalyzeExpression(expr->GetLeft());
    auto right = AnalyzeExpression(expr->GetRight());
    
    if (!left || !right) return nullptr;
    
    expr->SetLeft(left);
    expr->SetRight(right);
    
    auto leftType = left->GetType();
    auto rightType = right->GetType();
    
    switch (expr->GetOperator()) {
    case BinaryOp::Add:
    case BinaryOp::Sub:
    case BinaryOp::Mul:
    case BinaryOp::Div: {
        // Arithmetic operators require numeric types
        if (!leftType->IsInteger() || !rightType->IsInteger()) {
            diagEngine.Report(expr->GetToken(), DiagKind::ERR_InvalidOperands,
                             "Arithmetic operators require integer operands");
            return nullptr;
        }
        
        // Result type is the common type of operands
        auto resultType = GetCommonType(leftType, rightType);
        
        // Insert implicit casts if needed
        if (!leftType->IsCompatibleWith(resultType)) {
            expr->SetLeft(CreateImplicitCast(left, resultType));
        }
        if (!rightType->IsCompatibleWith(resultType)) {
            expr->SetRight(CreateImplicitCast(right, resultType));
        }
        
        expr->SetType(resultType);
        break;
    }
    
    case BinaryOp::Equal:
    case BinaryOp::NotEqual:
    case BinaryOp::Less:
    case BinaryOp::Greater: {
        // Comparison operators
        if (!IsTypeCompatible(leftType, rightType)) {
            diagEngine.Report(expr->GetToken(), DiagKind::ERR_TypeMismatch,
                             "Cannot compare expressions of types '" + leftType->ToString() +
                             "' and '" + rightType->ToString() + "'");
            return nullptr;
        }
        
        // Comparison always returns int (0 or 1)
        expr->SetType(TypeFactory::GetIntType());
        break;
    }
    
    case BinaryOp::Assign: {
        // Assignment: left operand must be lvalue
        if (!expr->GetLeft()->IsLValue()) {
            diagEngine.Report(expr->GetToken(), DiagKind::ERR_NotLValue,
                             "Left operand of assignment must be an lvalue");
            return nullptr;
        }
        
        // Check type compatibility
        if (!IsTypeCompatible(rightType, leftType)) {
            diagEngine.Report(expr->GetToken(), DiagKind::ERR_TypeMismatch,
                             "Cannot assign expression of type '" + rightType->ToString() +
                             "' to variable of type '" + leftType->ToString() + "'");
            return nullptr;
        }
        
        // Insert implicit cast if needed
        if (!rightType->IsCompatibleWith(leftType)) {
            expr->SetRight(CreateImplicitCast(right, leftType));
        }
        
        expr->SetType(leftType);
        break;
    }
    
    default:
        diagEngine.Report(expr->GetToken(), DiagKind::ERR_Internal,
                         "Unknown binary operator");
        return nullptr;
    }
    
    return std::shared_ptr<AstNode>(expr);
}
```

### Function Call Analysis

```cpp
std::shared_ptr<AstNode> SemanticAnalyzer::AnalyzeFunctionCall(FunctionCall* call) {
    // Analyze the function expression
    auto funcExpr = AnalyzeExpression(call->GetFunction());
    if (!funcExpr) return nullptr;
    
    call->SetFunction(funcExpr);
    
    // Check if it's actually a function type
    auto funcType = std::dynamic_pointer_cast<CFunctionType>(funcExpr->GetType());
    if (!funcType) {
        diagEngine.Report(call->GetToken(), DiagKind::ERR_NotCallable,
                         "Expression is not callable");
        return nullptr;
    }
    
    // Analyze arguments
    std::vector<std::shared_ptr<AstNode>> analyzedArgs;
    for (auto& arg : call->GetArguments()) {
        auto analyzedArg = AnalyzeExpression(arg);
        if (!analyzedArg) return nullptr;
        analyzedArgs.push_back(analyzedArg);
    }
    
    // Check argument count
    auto& paramTypes = funcType->GetParameterTypes();
    if (analyzedArgs.size() != paramTypes.size()) {
        diagEngine.Report(call->GetToken(), DiagKind::ERR_WrongArgumentCount,
                         "Function expects " + std::to_string(paramTypes.size()) +
                         " arguments, got " + std::to_string(analyzedArgs.size()));
        return nullptr;
    }
    
    // Check argument types and insert casts if needed
    for (size_t i = 0; i < analyzedArgs.size(); i++) {
        auto argType = analyzedArgs[i]->GetType();
        auto paramType = paramTypes[i];
        
        if (!IsTypeCompatible(argType, paramType)) {
            diagEngine.Report(call->GetToken(), DiagKind::ERR_TypeMismatch,
                             "Argument " + std::to_string(i + 1) + " has type '" +
                             argType->ToString() + "', expected '" + paramType->ToString() + "'");
            return nullptr;
        }
        
        // Insert implicit cast if needed
        if (!argType->IsCompatibleWith(paramType)) {
            analyzedArgs[i] = CreateImplicitCast(analyzedArgs[i], paramType);
        }
    }
    
    call->SetArguments(analyzedArgs);
    call->SetType(funcType->GetReturnType());
    
    return std::shared_ptr<AstNode>(call);
}
```

## Part 5: Type Checking Utilities

### Type Compatibility

```cpp
bool SemanticAnalyzer::IsTypeCompatible(std::shared_ptr<CType> from, std::shared_ptr<CType> to) {
    // Exact match
    if (from->IsCompatibleWith(to)) {
        return true;
    }
    
    // Integer promotions
    if (from->IsInteger() && to->IsInteger()) {
        // Can always promote smaller integers to larger ones
        return from->GetSize() <= to->GetSize();
    }
    
    // Pointer conversions
    if (from->IsPointer() && to->IsPointer()) {
        auto fromPtr = std::static_pointer_cast<CPointerType>(from);
        auto toPtr = std::static_pointer_cast<CPointerType>(to);
        
        // void* is compatible with any pointer
        if (toPtr->GetPointeeType()->GetKind() == CType::TY_Void ||
            fromPtr->GetPointeeType()->GetKind() == CType::TY_Void) {
            return true;
        }
        
        return fromPtr->GetPointeeType()->IsCompatibleWith(toPtr->GetPointeeType());
    }
    
    // Array to pointer decay
    if (from->IsArray() && to->IsPointer()) {
        auto arrayType = std::static_pointer_cast<CArrayType>(from);
        auto ptrType = std::static_pointer_cast<CPointerType>(to);
        return arrayType->GetElementType()->IsCompatibleWith(ptrType->GetPointeeType());
    }
    
    return false;
}

std::shared_ptr<CType> SemanticAnalyzer::GetCommonType(std::shared_ptr<CType> type1, std::shared_ptr<CType> type2) {
    // If types are the same, return one of them
    if (type1->IsCompatibleWith(type2)) {
        return type1;
    }
    
    // Integer promotion rules
    if (type1->IsInteger() && type2->IsInteger()) {
        // Return the larger type
        return (type1->GetSize() >= type2->GetSize()) ? type1 : type2;
    }
    
    // Default fallback
    return type1;
}

std::shared_ptr<AstNode> SemanticAnalyzer::CreateImplicitCast(std::shared_ptr<AstNode> expr, std::shared_ptr<CType> targetType) {
    auto castExpr = std::make_shared<CastExpr>();
    castExpr->SetTargetType(targetType);
    castExpr->SetOperand(expr);
    castExpr->SetType(targetType);
    castExpr->SetToken(expr->GetToken());  // Use same source location
    return castExpr;
}
```

## Part 6: Control Flow Analysis

### If Statement Analysis

```cpp
std::shared_ptr<AstNode> SemanticAnalyzer::AnalyzeIfStatement(IfStmt* stmt) {
    // Analyze condition
    auto condition = AnalyzeExpression(stmt->GetCondition());
    if (!condition) return nullptr;
    
    // Condition should be convertible to boolean (any scalar type)
    if (!condition->GetType()->IsInteger() && !condition->GetType()->IsPointer()) {
        diagEngine.Report(stmt->GetToken(), DiagKind::ERR_InvalidCondition,
                         "Condition must be a scalar type");
        return nullptr;
    }
    
    stmt->SetCondition(condition);
    
    // Analyze then branch
    auto thenStmt = AnalyzeStatement(stmt->GetThenStatement());
    if (!thenStmt) return nullptr;
    stmt->SetThenStatement(thenStmt);
    
    // Analyze else branch if present
    if (stmt->GetElseStatement()) {
        auto elseStmt = AnalyzeStatement(stmt->GetElseStatement());
        if (!elseStmt) return nullptr;
        stmt->SetElseStatement(elseStmt);
    }
    
    return std::shared_ptr<AstNode>(stmt);
}
```

### Block Statement Analysis

```cpp
std::shared_ptr<AstNode> SemanticAnalyzer::AnalyzeBlockStatement(BlockStmt* stmt) {
    // Enter new scope for the block
    scopeManager.EnterScope();
    
    // Analyze all statements in the block
    std::vector<std::shared_ptr<AstNode>> analyzedStmts;
    for (auto& childStmt : stmt->GetStatements()) {
        auto analyzed = AnalyzeStatement(childStmt);
        if (analyzed) {
            analyzedStmts.push_back(analyzed);
        }
        // Continue even if one statement fails (error recovery)
    }
    
    stmt->SetStatements(analyzedStmts);
    
    // Exit scope
    scopeManager.ExitScope();
    
    return std::shared_ptr<AstNode>(stmt);
}
```

## Part 7: Integration and Testing

### Complete Semantic Analysis Pipeline

```cpp
bool SemanticAnalyzer::AnalyzeProgram(std::shared_ptr<Program> program) {
    bool success = true;
    
    for (auto& stmt : program->GetStatements()) {
        auto analyzed = AnalyzeStatement(stmt);
        if (!analyzed) {
            success = false;
        }
        // Continue processing even after errors for better error reporting
    }
    
    return success;
}

// Main entry point for semantic analysis
std::shared_ptr<Program> PerformSemanticAnalysis(std::shared_ptr<Program> program, DiagEngine& diagEngine) {
    SemanticAnalyzer analyzer(diagEngine);
    
    if (analyzer.AnalyzeProgram(program)) {
        return program;  // Success - return annotated program
    } else {
        return nullptr;  // Semantic errors found
    }
}
```

### Testing Semantic Analysis

```cpp
void TestSemanticAnalysis() {
    std::string testCode = R"(
        int x = 42;
        int y;
        
        int main() {
            y = x + 10;
            int z = "hello";  // Error: type mismatch
            undeclared_var = 5;  // Error: undeclared variable
            return y;
        }
    )";
    
    // Parse
    Lexer lexer(llvm::StringRef(testCode));
    Parser parser(lexer);
    auto program = parser.ParseProgram();
    
    // Semantic analysis
    DiagEngine diagEngine;
    SemanticAnalyzer analyzer(diagEngine);
    
    bool success = analyzer.AnalyzeProgram(program);
    
    if (success) {
        std::cout << "Semantic analysis passed!\n";
    } else {
        std::cout << "Semantic errors found:\n";
        diagEngine.PrintDiagnostics();
    }
}
```

## Summary: What You've Learned

You now know how to:

1. **Design a complete type system** with primary types, pointers, arrays, and structures
2. **Implement symbol tables** with proper scope management
3. **Perform type checking** with compatibility rules and implicit conversions
4. **Handle variable declarations** with conflict detection
5. **Analyze expressions** with type inference and error reporting
6. **Process control flow** with scope management
7. **Create diagnostic messages** for semantic errors
8. **Bridge parsing and code generation** with annotated ASTs

**Key Algorithms You Implemented:**
- **Symbol table management**: Scope stack with nested environments
- **Type checking**: Compatibility rules and implicit conversion insertion
- **Scope resolution**: Finding symbols in nested scopes
- **Error recovery**: Continuing analysis after errors

**Next Steps:**
With semantic analysis complete, your AST is fully annotated with type information and all symbols are resolved. The code generator can now:
- Trust that all variables are declared
- Know the exact types of all expressions
- Generate correct memory layouts for structures
- Handle function calls with proper calling conventions

You've built the critical bridge between parsing and code generation!