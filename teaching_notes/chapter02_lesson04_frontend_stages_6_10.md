# Chapter 2, Lesson 4: Frontend Development Stages (6-10) - Advanced Language Features

## Learning Objectives
- Understand how stages 6-10 add sophisticated language features
- Learn about operator precedence, pointer mechanics, and aggregate data types
- See how compiler complexity grows with advanced language constructs

## Explanation

Stages 6-10 represent a major leap in compiler sophistication. While stages 1-5 gave you the foundation, these stages add **advanced language features** that make the compiler capable of handling real-world C code. Each stage tackles increasingly complex programming constructs.

## Stage 6: For Loops (06-for)

### Purpose
Add iterative control flow with initialization, condition, and increment.

### New Grammar
```
for-stmt : "for" "(" expr? ";" expr? ";" expr? ")" stmt
         | "for" "(" decl-stmt expr? ";" expr? ")" stmt
```

### Complexity Added
The `for` loop is more complex than `if` because it combines multiple control flow elements:
1. **Initialization**: `int i = 0`
2. **Condition**: `i < 10`
3. **Increment**: `i++`
4. **Body**: Loop body execution
5. **Control flow**: Jump back to condition check

### LLVM IR Structure
```llvm
entry:
  ; initialization
  br label %condition

condition:
  ; evaluate loop condition
  br i1 %cond, label %body, label %exit

body:
  ; loop body code
  ; increment expression
  br label %condition

exit:
  ; code after loop
```

## Stage 7: Logical and Bitwise Operations (07-logical-bit)

### Purpose
Complete the expression system with logical (`&&`, `||`) and bitwise (`&`, `|`, `^`, `<<`, `>>`) operators.

### Extended Grammar (Operator Precedence Chain)
```
expr         : assign-expr | logor-expr
logor-expr   : logand-expr ("||" logand-expr)*      # lowest precedence
logand-expr  : bitor-expr ("&&" bitor-expr)*
bitor-expr   : bitxor-expr ("|" bitxor-expr)*
bitxor-expr  : bitand-expr ("^" bitand-expr)*
bitand-expr  : equal-expr ("&" equal-expr)*
equal-expr   : relational-expr (("==" | "!=") relational-expr)*
relational-expr : shift-expr (("<"|">"|"<="|">=") shift-expr)*
shift-expr   : add-expr (("<<" | ">>") add-expr)*
add-expr     : mult-expr (("+" | "-") mult-expr)*
mult-expr    : primary-expr (("*" | "/" | "%") primary-expr)*  # highest precedence
```

### Complex Example Analysis

**Input**: `aa || b && aa || b || aa || b && aa`

**Parsing Tree** (respecting precedence):
```
            ||
          /    \
        aa      ||
               /  \
              &&   ||
             / \   / \
            b  aa aa  &&
                     / \
                    b  aa
```

### Short-Circuit Evaluation
Logical operators require **short-circuit evaluation**:
- `a || b`: If `a` is true, don't evaluate `b`
- `a && b`: If `a` is false, don't evaluate `b`

**LLVM IR for `a || b`**:
```llvm
  %a_val = load i32, ptr %a
  %a_bool = icmp ne i32 %a_val, 0
  br i1 %a_bool, label %true_result, label %eval_b

eval_b:
  %b_val = load i32, ptr %b
  %b_bool = icmp ne i32 %b_val, 0
  br label %merge

true_result:
  br label %merge

merge:
  %result = phi i1 [true, %true_result], [%b_bool, %eval_b]
```

## Stage 8: Pointers (08-point)

### Purpose
Memory addressing, dereferencing, and pointer arithmetic.

### New Grammar Extensions
```
declarator : "*"* direct-declarator
unary-expr : ("&" | "*") unary-expr | postfix-expr
```

### Example Operations
```c
{
    int a = 3;         // Variable declaration
    int *p = &a;       // Pointer declaration and address-of
    p++;               // Pointer arithmetic
    p--;               // Pointer arithmetic
    *p++;              // Dereference and post-increment
    *p--;              // Dereference and post-decrement
    ++*p;              // Pre-increment of dereferenced value
    --*p;              // Pre-decrement of dereferenced value
}
```

### Key Concepts
1. **Address-of operator** (`&`): Get memory address of variable
2. **Dereference operator** (`*`): Access value at memory address
3. **Pointer arithmetic**: `p++` moves to next memory location
4. **Operator precedence**: `*p++` means `*(p++)`, not `(*p)++`

### Type System Extensions
- **Pointer types**: `int*`, `char*`, `void*`
- **Type checking**: Ensure compatible pointer assignments
- **Pointer arithmetic**: Only valid on certain types

## Stage 9: Arrays (09-array)

### Purpose
Aggregate data types with indexing and multi-dimensional support.

### New Grammar
```
direct-declarator : identifier "[" expr "]"
postfix-expr     : postfix-expr "[" expr "]"
```

### Array Concepts
1. **Array declarations**: `int arr[10]`
2. **Array indexing**: `arr[5]`
3. **Multi-dimensional**: `int matrix[3][4]`
4. **Array-pointer relationship**: `arr[i]` ≡ `*(arr + i)`

### Memory Layout
Arrays are stored as contiguous memory blocks:
```
int arr[5] = {1, 2, 3, 4, 5};

Memory: [1][2][3][4][5]
        ^
      arr points here
```

## Stage 10: Structures (10-struct)

### Purpose
Custom data types with member access (`.` and `->`).

### New Grammar
```
struct-specifier : "struct" identifier "{" struct-declaration-list "}"
postfix-expr    : postfix-expr "." identifier
                | postfix-expr "->" identifier
```

### Structure Concepts
1. **Structure definition**: `struct Point { int x, y; };`
2. **Structure variables**: `struct Point p;`
3. **Member access**: `p.x`, `p.y`
4. **Pointer access**: `ptr->x` (equivalent to `(*ptr).x`)

### Memory Layout Example
```c
struct Point {
    int x;    // offset 0
    int y;    // offset 4
};
```

Memory layout:
```
Point p:  [x: 4 bytes][y: 4 bytes]
          ^           ^
        offset 0    offset 4
```

## Building and Testing Advanced Stages

Each stage includes comprehensive testing infrastructure:

### Basic Build Process
```bash
# Build any stage (example: stage 7)
cd frontEnd/07-logical-bit
mkdir build && cd build
cmake ..
make

# Run unit tests
./test/lexer/lexer_test
./test/parser/parser_test

# Test compilation
./07-logical-bit ../demo/e1.txt
```

### Testing with Scripts
```bash
# Many stages include test scripts
cd frontEnd/07-logical-bit
./script/test.sh
```

### Examining Generated Code
```bash
# View generated LLVM IR
cat demo/expr.ll

# Compare input and output
cat demo/e1.txt      # Input C code
cat demo/expr.ll     # Generated LLVM IR
```

## File Structure Evolution

Notice how file structure becomes more sophisticated:

### Stage 7+ Structure
```
stage-N/
├── CMakeLists.txt        # Build configuration
├── main.cc              # Entry point
├── lexer.cc/h           # Tokenization
├── parser.cc/h          # Syntax analysis
├── ast.h                # AST definitions (growing!)
├── codegen.cc/h         # LLVM IR generation
├── scope.cc/h           # Symbol table management
├── sema.cc/h            # Semantic analysis
├── type.cc/h            # Type system
├── diag_engine.cc/h     # Error reporting
├── diag.inc             # Error message definitions
├── doc/
│   └── ebnf.txt         # Extended grammar
├── demo/                # Example programs
├── script/              # Build/test scripts
└── test/                # Unit tests
    ├── lexer/
    ├── parser/
    └── codegen/         # Code generation tests
```

## Complexity Growth Analysis

| Stage | Lines of Code | Major Components | Key Challenge |
|-------|---------------|------------------|---------------|
| 6 | ~1500 | Loop control flow | Multiple exit points |
| 7 | ~2000 | Operator precedence | Short-circuit evaluation |
| 8 | ~2500 | Pointer system | Memory safety |
| 9 | ~3000 | Array handling | Bounds and indexing |
| 10 | ~3500 | Structure types | Custom type definitions |

## Next Lesson Preview

In Lesson 5, we'll explore the final stages (11-15) that complete the C compiler with functions, advanced types, and sophisticated language features that bring us to a production-quality compiler.

---
*Lesson 4 completed. You now understand how sophisticated language features are incrementally added to create a powerful compiler!*