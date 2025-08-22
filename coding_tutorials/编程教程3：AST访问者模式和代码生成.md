# 编程教程3：AST访问者模式和代码生成

## 学习目标

- 理解访问者设计模式以及为什么它对编译器至关重要
- 为不同的AST遍历目的实现多个访问者
- 逐步编写实际的LLVM IR代码生成
- 构建产生可执行LLVM IR的完整代码生成器
- 学习如何集成多个编译阶段

## 第1部分：理解访问者模式

### 为什么我们需要访问者模式？

当您有一个AST时，您需要对它**做不同的事情**：

- **打印它**用于调试
- **从中生成代码**
- **对其进行类型检查**
- **优化它**
- **分析它**查找错误

**问题**：如果我们直接在AST节点中放置所有这些操作，它们会变得庞大且职责混乱。

**解决方案**：访问者模式将**树结构**与**对树的操作**分离。

### 模式结构

```cpp
// ast.h - AST节点定义结构
class Expr {
public:
    virtual ~Expr() {}
    virtual llvm::Value* Accept(Visitor* v) = 0;  // 接受任何访问者
};

class BinaryExpr : public Expr {
public:
    OpCode op;
    std::shared_ptr<Expr> left;
    std::shared_ptr<Expr> right;
    
    // 分发到访问者针对此特定节点类型的方法
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

// 访问者接口定义操作
class Visitor {
public:
    virtual ~Visitor() {}
    virtual llvm::Value* VisitProgram(Program* p) = 0;
    virtual llvm::Value* VisitBinaryExpr(BinaryExpr* expr) = 0;
    virtual llvm::Value* VisitNumberExpr(NumberExpr* expr) = 0;
};
```

### 双重分发如何工作

当您调用 `expr->Accept(visitor)` 时：

1. **第一次分发**：基于 `expr` 的**实际类型**（动态分发）
2. **第二次分发**：在 `Accept()` 内部，调用**特定的访问者方法**（静态分发）

```cpp
// 这个...
expr->Accept(codeGenVisitor);

// 变成这个...
if (expr is BinaryExpr) {
    return codeGenVisitor->VisitBinaryExpr((BinaryExpr*)expr);
} else if (expr is NumberExpr) {
    return codeGenVisitor->VisitNumberExpr((NumberExpr*)expr);
}
```

## 第2部分：实现打印访问者（调试工具）

让我们从一个打印AST的简单访问者开始：

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
// print_visitor.cc
#include "print_visitor.h"
#include "llvm/Support/raw_ostream.h"

void PrintVisitor::PrintIndent() {
    for (int i = 0; i < indent; i++) {
        llvm::outs() << "  ";
    }
}

llvm::Value* PrintVisitor::VisitProgram(Program* p) {
    llvm::outs() << "Program:\n";
    for (auto& expr : p->expressions) {
        PrintIndent();
        llvm::outs() << "Expression:\n";
        
        // 创建缩进增加的新访问者
        PrintVisitor childVisitor(indent + 1);
        expr->Accept(&childVisitor);
        llvm::outs() << "\n";
    }
    return nullptr;
}

llvm::Value* PrintVisitor::VisitBinaryExpr(BinaryExpr* expr) {
    PrintIndent();
    llvm::outs() << "BinaryExpr (";
    
    // 打印操作符
    switch (expr->op) {
    case OpCode::Add: llvm::outs() << "+"; break;
    case OpCode::Sub: llvm::outs() << "-"; break;
    case OpCode::Mul: llvm::outs() << "*"; break;
    case OpCode::Div: llvm::outs() << "/"; break;
    }
    llvm::outs() << "):\n";
    
    // 打印左子树
    PrintIndent();
    llvm::outs() << "  Left:\n";
    PrintVisitor leftVisitor(indent + 2);
    expr->left->Accept(&leftVisitor);
    
    // 打印右子树
    PrintIndent();
    llvm::outs() << "  Right:\n";
    PrintVisitor rightVisitor(indent + 2);
    expr->right->Accept(&rightVisitor);
    
    return nullptr;
}

llvm::Value* PrintVisitor::VisitNumberExpr(NumberExpr* expr) {
    PrintIndent();
    llvm::outs() << "Number: " << expr->value << "\n";
    return nullptr;
}
```

### 测试打印访问者

```cpp
void TestPrintVisitor() {
    std::string input = "2 + 3 * 4;";
    Lexer lexer(llvm::StringRef(input));
    Parser parser(lexer);
    auto program = parser.ParseProgram();
    
    PrintVisitor printer;
    printer.VisitProgram(program.get());
}

// 输出：
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

## 第3部分：构建代码生成访问者

现在开始真正的工作 - 从AST生成LLVM IR！

### 您需要了解的LLVM IR基础

**LLVM IR** 是一种低级、类型化的、类汇编语言：

- **SSA形式**：每个值只赋值一次
- **类型化**：每个值都有特定类型（`i32`, `i8*`, 等）
- **基本块**：代码组织为具有控制流的基本块
- **指令**：加载、存储、算术、调用、分支等

### CodeGen访问者结构

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
    
    // 主入口点
    void GenerateCode(std::shared_ptr<Program> program);
    
    // 打印生成的IR
    void PrintIR();

private:
    llvm::Value* VisitProgram(Program* p) override;
    llvm::Value* VisitBinaryExpr(BinaryExpr* expr) override;
    llvm::Value* VisitNumberExpr(NumberExpr* expr) override;
    
    // 辅助方法
    void CreateMainFunction();
    void CreatePrintfDeclaration();

private:
    llvm::LLVMContext context;
    llvm::IRBuilder<> builder;
    std::unique_ptr<llvm::Module> module;
    
    // 我们需要的函数声明
    llvm::Function* mainFunc;
    llvm::Function* printfFunc;
};
```

### 步骤1：设置LLVM基础设施

```cpp
// codegen.cc
#include "codegen.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

CodeGen::CodeGen() : builder(context) {
    // 创建新模块（编译单元）
    module = std::make_unique<Module>("expr_compiler", context);
}

void CodeGen::CreatePrintfDeclaration() {
    // printf签名：int printf(const char* format, ...)
    
    // 获取类型
    Type* i32Type = builder.getInt32Ty();
    Type* i8PtrType = builder.getInt8PtrTy();
    
    // 创建函数类型：int(char*, ...)  [可变参数]
    FunctionType* printfType = FunctionType::get(
        i32Type,           // 返回类型
        {i8PtrType},       // 参数类型
        true               // 是可变参数（接受...参数）
    );
    
    // 创建函数声明
    printfFunc = Function::Create(
        printfType,
        Function::ExternalLinkage,  // 外部链接（在别处定义）
        "printf",
        module.get()
    );
}

void CodeGen::CreateMainFunction() {
    // main签名：int main()
    
    FunctionType* mainType = FunctionType::get(
        builder.getInt32Ty(),  // 返回类型：int
        {},                    // 无参数
        false                  // 非可变参数
    );
    
    mainFunc = Function::Create(
        mainType,
        Function::ExternalLinkage,
        "main",
        module.get()
    );
    
    // 创建入口基本块
    BasicBlock* entryBB = BasicBlock::Create(context, "entry", mainFunc);
    builder.SetInsertPoint(entryBB);  // 所有后续指令都放在这里
}
```

### 步骤2：主生成入口点

```cpp
void CodeGen::GenerateCode(std::shared_ptr<Program> program) {
    // 设置LLVM基础设施
    CreatePrintfDeclaration();
    CreateMainFunction();
    
    // 访问程序并生成代码
    VisitProgram(program.get());
    
    // 验证生成的IR是否正确
    verifyFunction(*mainFunc);
    verifyModule(*module);
}

llvm::Value* CodeGen::VisitProgram(Program* p) {
    // 对于程序中的每个表达式：
    // 1. 为表达式生成代码
    // 2. 使用printf打印结果
    
    for (auto& expr : p->expressions) {
        // 为此表达式生成代码
        Value* result = expr->Accept(this);
        
        if (result) {
            // 为printf创建格式字符串
            Value* formatStr = builder.CreateGlobalStringPtr("Result: %d\n");
            
            // 调用printf(formatStr, result)
            builder.CreateCall(printfFunc, {formatStr, result});
        }
    }
    
    // 从main返回0
    builder.CreateRet(builder.getInt32(0));
    
    return nullptr;
}
```

### 步骤3：为数字生成代码

```cpp
llvm::Value* CodeGen::VisitNumberExpr(NumberExpr* expr) {
    // 创建常量整数值
    return builder.getInt32(expr->value);
}
```

**就这样！** 数字在LLVM IR中只是常量。

### 步骤4：为二元表达式生成代码

```cpp
llvm::Value* CodeGen::VisitBinaryExpr(BinaryExpr* expr) {
    // 为左右操作数生成代码
    Value* leftVal = expr->left->Accept(this);
    Value* rightVal = expr->right->Accept(this);
    
    // 确保两个操作数都成功生成
    if (!leftVal || !rightVal) {
        return nullptr;
    }
    
    // 根据操作符生成适当的LLVM指令
    switch (expr->op) {
    case OpCode::Add:
        // 创建'add'指令
        return builder.CreateAdd(leftVal, rightVal, "add_tmp");
        
    case OpCode::Sub:
        // 创建'sub'指令
        return builder.CreateSub(leftVal, rightVal, "sub_tmp");
        
    case OpCode::Mul:
        // 创建'mul'指令
        return builder.CreateMul(leftVal, rightVal, "mul_tmp");
        
    case OpCode::Div:
        // 创建有符号除法指令
        return builder.CreateSDiv(leftVal, rightVal, "div_tmp");
        
    default:
        // 未知操作符
        return nullptr;
    }
}
```

**关键洞察：**

- 每个LLVM指令产生一个**Value**，可以被其他指令使用
- 临时名称（`"add_tmp"`）帮助使IR可读
- `CreateAdd`, `CreateSub`等创建实际的LLVM指令

### 步骤5：整合一切

```cpp
void CodeGen::PrintIR() {
    module->print(outs(), nullptr);
}

// 使用示例：
int main() {
    std::string input = "2 + 3 * 4; 10 - 5;";
    
    // 解析输入
    Lexer lexer(llvm::StringRef(input));
    Parser parser(lexer);
    auto program = parser.ParseProgram();
    
    // 生成LLVM IR
    CodeGen codegen;
    codegen.GenerateCode(program);
    
    // 打印生成的IR
    codegen.PrintIR();
    
    return 0;
}
```

## 第4部分：理解生成的LLVM IR

### 输入代码：

```c
2 + 3 * 4;
```

### 生成的LLVM IR：

```llvm
; ModuleID = 'expr_compiler'

@0 = private unnamed_addr constant [12 x i8] c"Result: %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %mul_tmp = mul i32 3, 4           ; 3 * 4 = 12
  %add_tmp = add i32 2, %mul_tmp    ; 2 + 12 = 14
  %0 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([12 x i8], [12 x i8]* @0, i32 0, i32 0), i32 %add_tmp)
  ret i32 0
}
```

### 分解IR：

1. **全局字符串**：`@0 = private unnamed_addr constant [12 x i8] c"Result: %d\0A\00"`
   - 这是printf的格式字符串
2. **函数声明**：`declare i32 @printf(i8*, ...)`
   - 我们可以调用的外部函数
3. **主函数**：`define i32 @main()`
   - 我们生成的main函数
4. **算术指令**：
   - `%mul_tmp = mul i32 3, 4` - 将3和4相乘
   - `%add_tmp = add i32 2, %mul_tmp` - 将2加到结果上
5. **函数调用**：`call i32 @printf(...)`
   - 打印结果
6. **返回**：`ret i32 0`
   - 从main返回0

## 第5部分：高级代码生成功能

### 处理更多表达式类型

让我们扩展代码生成器以处理比较操作符：

```cpp
// 添加到OpCode枚举
enum class OpCode {
    Add, Sub, Mul, Div,
    Equal, NotEqual, Less, Greater  // 新比较操作符
};

// 扩展VisitBinaryExpr
llvm::Value* CodeGen::VisitBinaryExpr(BinaryExpr* expr) {
    Value* leftVal = expr->left->Accept(this);
    Value* rightVal = expr->right->Accept(this);
    
    if (!leftVal || !rightVal) return nullptr;
    
    switch (expr->op) {
    // 算术操作符
    case OpCode::Add:
        return builder.CreateAdd(leftVal, rightVal, "add_tmp");
    case OpCode::Sub:
        return builder.CreateSub(leftVal, rightVal, "sub_tmp");
    case OpCode::Mul:
        return builder.CreateMul(leftVal, rightVal, "mul_tmp");
    case OpCode::Div:
        return builder.CreateSDiv(leftVal, rightVal, "div_tmp");
        
    // 比较操作符（返回i1，然后扩展为i32）
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

**为什么ZExt？** 比较操作返回`i1`（1位布尔值），但我们想要`i32`以保持一致性。

### 代码生成中的错误处理

```cpp
llvm::Value* CodeGen::VisitBinaryExpr(BinaryExpr* expr) {
    Value* leftVal = expr->left->Accept(this);
    Value* rightVal = expr->right->Accept(this);
    
    // 检查生成错误
    if (!leftVal) {
        llvm::errs() << "Error: Failed to generate code for left operand\n";
        return nullptr;
    }
    if (!rightVal) {
        llvm::errs() << "Error: Failed to generate code for right operand\n";
        return nullptr;
    }
    
    // 检查类型不匹配（更高级）
    if (leftVal->getType() != rightVal->getType()) {
        llvm::errs() << "Error: Type mismatch in binary expression\n";
        return nullptr;
    }
    
    // ... 方法的其余部分
}
```

### 优化机会：常量折叠

LLVM自动执行许多优化，但您可以在AST级别进行一些优化：

```cpp
llvm::Value* CodeGen::VisitBinaryExpr(BinaryExpr* expr) {
    // 检查两个操作数是否都是常量
    auto leftNum = dynamic_cast<NumberExpr*>(expr->left.get());
    auto rightNum = dynamic_cast<NumberExpr*>(expr->right.get());
    
    if (leftNum && rightNum) {
        // 两者都是常量 - 在编译时折叠！
        int result;
        switch (expr->op) {
        case OpCode::Add: result = leftNum->value + rightNum->value; break;
        case OpCode::Sub: result = leftNum->value - rightNum->value; break;
        case OpCode::Mul: result = leftNum->value * rightNum->value; break;
        case OpCode::Div: 
            if (rightNum->value == 0) {
                llvm::errs() << "Error: Division by zero\n";
                return nullptr;
            }
            result = leftNum->value / rightNum->value; 
            break;
        default:
            goto normal_generation;  // 回退到正常生成
        }
        
        return builder.getInt32(result);
    }
    
normal_generation:
    // 非常量表达式的正常代码生成
    Value* leftVal = expr->left->Accept(this);
    Value* rightVal = expr->right->Accept(this);
    // ... 如前所述的其余部分
}
```

## 第6部分：测试和调试

### 完整测试程序

```cpp
// test_codegen.cc
#include "lexer.h"
#include "parser.h"
#include "codegen.h"
#include <iostream>

void TestCodeGeneration(const std::string& input) {
    std::cout << "\n=== Testing: " << input << " ===\n";
    
    // 解析
    Lexer lexer(llvm::StringRef(input));
    Parser parser(lexer);
    auto program = parser.ParseProgram();
    
    if (!program || program->expressions.empty()) {
        std::cout << "Parse failed!\n";
        return;
    }
    
    // 生成代码
    CodeGen codegen;
    codegen.GenerateCode(program);
    
    // 打印IR
    std::cout << "Generated LLVM IR:\n";
    codegen.PrintIR();
}

int main() {
    // 测试各种表达式
    TestCodeGeneration("42;");
    TestCodeGeneration("2 + 3;");
    TestCodeGeneration("2 + 3 * 4;");
    TestCodeGeneration("(2 + 3) * 4;");
    TestCodeGeneration("10 / 2 - 1;");
    
    return 0;
}
```

### 编译和执行

```bash
# 编译您的编译器
g++ -std=c++17 \
    test_codegen.cc lexer.cc parser.cc codegen.cc \
    `llvm-config --cxxflags --ldflags --libs core` \
    -o expr_compiler

# 运行它
./expr_compiler

# 执行生成的IR：
./expr_compiler > output.ll
lli output.ll  # LLVM解释器
# 或者：
llc output.ll -o output.s  # 编译为汇编
gcc output.s -o output     # 链接为可执行文件
./output                   # 运行可执行文件
```

## 第7部分：与完整编译器管道集成

### 完整管道集成

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
        std::cerr << "Usage: " << argv[0] << " <source_file>\n";
        return 1;
    }
    
    // 读取源文件
    std::ifstream file(argv[1]);
    if (!file) {
        std::cerr << "Error: Cannot open file " << argv[1] << "\n";
        return 1;
    }
    
    std::stringstream buffer;
    buffer << file.rdbuf();
    std::string source = buffer.str();
    
    // 词法分析
    std::cout << "=== Lexical Analysis ===\n";
    Lexer lexer(llvm::StringRef(source));
    
    // 语法分析
    std::cout << "=== Syntax Analysis ===\n";
    Parser parser(lexer);
    auto program = parser.ParseProgram();
    
    if (!program) {
        std::cerr << "Parse failed\n";
        return 1;
    }
    
    // AST可视化
    std::cout << "=== Abstract Syntax Tree ===\n";
    PrintVisitor printer;
    printer.VisitProgram(program.get());
    
    // 代码生成
    std::cout << "=== Code Generation ===\n";
    CodeGen codegen;
    codegen.GenerateCode(program);
    codegen.PrintIR();
    
    return 0;
}
```

## 总结：您学到了什么

现在您知道如何：

1. **设计和实现访问者模式**用于清晰的AST遍历
2. **为不同目的创建多个访问者**（打印、代码生成）
3. **设置LLVM IR生成基础设施**与上下文、模块和构建器
4. **为算术和比较操作生成LLVM指令**
5. **处理函数声明和调用**（printf示例）
6. **创建完整的LLVM函数**与基本块和控制流
7. **将代码生成与词法分析器和解析器集成**

**您掌握的关键LLVM概念：**

- **LLVMContext**：所有LLVM状态的容器
- **Module**：包含函数和全局变量的编译单元
- **IRBuilder**：创建LLVM指令的工具
- **Value**：LLVM中所有计算值的基类
- **Function**：LLVM函数表示
- **BasicBlock**：函数内控制流的单元

**下一步：**

- **变量和内存**：栈分配，加载/存储指令
- **控制流**：If语句，带分支和PHI节点的循环
- **函数**：参数传递，返回值，调用约定
- **类型系统**：多种类型，类型检查，类型转换

您现在有了一个工作的代码生成器，可以将AST转换为可执行的LLVM IR！