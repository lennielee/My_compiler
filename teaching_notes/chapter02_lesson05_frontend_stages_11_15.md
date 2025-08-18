# Chapter 2, Lesson 5: Frontend Development Stages (11-15) - Complete C Compiler

## Learning Objectives
- Understand how the final stages complete the C compiler
- Learn about functions, advanced types, and production-quality features
- See how the compiler evolves to handle real-world programs

## Explanation

Stages 11-15 represent the **culmination** of our frontend development. These final stages transform our compiler from a sophisticated toy into a **production-quality C compiler** capable of compiling real-world programs. Each stage adds critical features that professional compilers must support.

## Stage 11: Functions and Global Variables (11-func-globalvar)

### Purpose
Add function definitions, function calls, and global variable support.

### Major Features Added
1. **Function Definitions**: `int sum(int n) { ... }`
2. **Function Calls**: `sum(100)`
3. **Global Variables**: Variables declared outside functions
4. **Global Scope**: Symbol table management across compilation units

### Example Program Analysis
```c
// Global structure with initialization
struct {
    int a, b; 
    struct {int d; int a;} c;
} a = {1,2, {10}}; 

// Function definition
int sum(int n) {
    int ret = 0;
    for (int i = 0; i <= n; ++i) {
        ret += i;
    }
    return ret;
}

// Main function with function call
int main() {
    return a.c.d + sum(100);  // Global access + function call
}
```

### Compiler Complexity Added
- **Global Symbol Table**: Track symbols across compilation units
- **Function Signatures**: Parameter and return type checking
- **Calling Convention**: Set up function call ABI
- **Stack Management**: Parameter passing and local variable allocation

### LLVM IR Structure for Functions
```llvm
; Function definition
define i32 @sum(i32 %n) {
entry:
  %ret = alloca i32
  store i32 0, i32* %ret
  ; ... loop implementation
  %result = load i32, i32* %ret
  ret i32 %result
}

; Function call
%call_result = call i32 @sum(i32 100)
```

## Stage 12: Functions with Arrays and Structures (12-func_with_array_and_struct)

### Purpose
Enable passing complex data types (arrays, structures) to functions.

### Complex Parameter Handling
1. **Array Parameters**: Passed as pointers (`int arr[]` → `int* arr`)
2. **Structure Parameters**: By value copying vs by reference
3. **Return Complex Types**: Structures returned by value
4. **Multi-dimensional Arrays**: `int matrix[][10]`

### Example
```c
void print_array(int arr[], int size) {
    for (int i = 0; i < size; i++) {
        printf("%d ", arr[i]);
    }
}

struct Point process_point(struct Point p) {
    p.x *= 2;
    p.y *= 2;
    return p;  // Return by value
}
```

### Memory Management Implications
- **Array Decay**: Arrays become pointers when passed to functions
- **Structure Copying**: Value semantics for structure parameters
- **ABI Considerations**: How complex types are passed/returned

## Stage 13: Variadic Functions (13-func_varargs)

### Purpose
Support functions with variable argument lists (`printf`, `scanf` style).

### Grammar Extension
```
parameter-type-list ::= decl-spec declarator (, decl-spec declarator)* (", " "...")?
```

### Variadic Function Examples
```c
int printf(const char *format, ...);        // Declaration
printf("Hello %s, age %d", name, age);      // Usage with variable args
```

### Complete Grammar by Stage 13
The README shows the complete grammar:
```
prog       ::= external-decl+
external-decl ::= func-def | decl-stmt
func-def   ::= decl-spec declarator block-stmt
parameter-type-list ::= decl-spec declarator (, decl-spec declarator)* (", " "...")?

expr         ::= assign (, assign )*
assign ::= conditional ("="|"+="|"-="|"*="|"/="|"%="|"<<="|">>="|"&="|"^="|"|=" assign)?
conditional ::= logor  ("?" expr ":" conditional)?
logor       ::= logand ("||" logand)*
logand      ::= bitor  ("&&" bitor)*
bitor       ::= bitxor ("|" bitxor)*
bitxor      ::= bitand ("^" bitand)*
bitand      ::= equal ("&" equal)*
equal       ::= relational ("==" | "!=" relational)*
relational  ::= shift ("<"|">"|"<="|">=" shift)*
shift       ::= add ("<<" | ">>" add)*
add         ::= mult ("+" | "-" mult)* 
mult        ::= cast ("*" | "/" | "%" cast)* 
cast        ::= unary | "(" type-name ")" cast
unary       ::= postfix | ("++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"sizeof") unary
                | "sizeof" "(" type-name ")"
```

### Runtime Argument Handling
Variadic functions require special runtime support:
- **va_list**: Iterator over variable arguments
- **Type Information**: Arguments must be processed based on format string
- **ABI Compliance**: Platform-specific calling conventions

## Stage 14: Switch Statements and While Loops (14-switch_and_while)

### Purpose
Complete control flow constructs with `switch`/`case` and `while`/`do-while`.

### New Control Structures
1. **Switch Statements**: Multi-way branching
```c
switch (value) {
    case 1: /* code */ break;
    case 2: /* code */ break;
    default: /* code */ break;
}
```

2. **While Loops**: Pre-condition loops
```c
while (condition) {
    /* body */
}
```

3. **Do-While Loops**: Post-condition loops
```c
do {
    /* body */
} while (condition);
```

### Code Generation Complexity
- **Jump Tables**: Efficient switch implementation for dense case values
- **Fall-through**: Handling missing `break` statements
- **Loop Optimization**: Different loop forms for different use cases

## Stage 15: Complete Type System and Constant Expressions (15-more_type_and_constant_expr)

### Purpose
Full C type system including type casting, `sizeof`, and compile-time constant evaluation.

### Advanced Type Features
1. **Type Casting**: `(int)3.14`, automatic promotions
2. **Sizeof Operator**: `sizeof(int)`, `sizeof(struct Point)`
3. **Typedef**: `typedef struct {...} Point;`
4. **Constant Expressions**: Compile-time evaluation
5. **Character Literals**: `'a'`, `'\n'` with ASCII values

### Example Programs

**Type Casting**:
```c
int main() {
   int  i = 17;
   char c = 'c';     // ASCII value 99
   int sum = i + c;  // Automatic promotion: char -> int
   printf("Value: %d\n", sum);  // Result: 116
}
```

**Typedef Usage**:
```c
typedef struct {
    int a, b;
} Point;

int main() {
    Point p = {1, 2};       // Structure initialization
    return p.a + p.b;       // Member access
}
```

### Constant Expression Evaluation
The compiler can now evaluate expressions at compile time:
```c
const int SIZE = 10;
int array[SIZE * 2];        // Evaluated to: int array[20];
```

## Real-World Program: 2048 Game

By stage 15, the compiler can handle complex programs like a complete 2048 game:

```c
int printf(const char *fmg, ...);
int scanf(const char *format, ...);

// Global constants
const int UP = 0, DOWN = 1, LEFT = 2, RIGHT = 3;
const int MAP_LEN = 4;
const int POW2[20] = {1, 2, 4, 8, 16, 32, /* ... */};

// Complex functions
int getint() {
  int val;
  scanf("%d", &val);
  return val;
}

void putarray(int len, int arr[]) {
  printf("%d:", len);
  for (int i = 0; i < len; i++) {
    printf(" %d", arr[i]);
  }
}

// Main game logic with complex control flow
int main() {
    // Complete 2048 implementation
    // Uses arrays, structures, functions, loops, etc.
}
```

This program demonstrates:
- **Variadic Functions**: `printf`, `scanf`
- **Global Constants**: `const` declarations
- **Array Initialization**: Global array with initializers
- **Complex Functions**: Multiple parameters, return values
- **Real-world Logic**: Game implementation patterns

## Complete Feature Matrix

By stage 15, our compiler supports the full C subset:

| Category | Features |
|----------|----------|
| **Data Types** | `int`, `char`, pointers (`*`), arrays (`[]`), structures, unions |
| **Declarations** | Variables, functions, global/local scope, `typedef`, `const` |
| **Operators** | Arithmetic (`+`,`-`,`*`,`/`,`%`), Logical (`&&`,`||`,`!`) |
|               | Bitwise (`&`,`|`,`^`,`<<`,`>>`), Comparison (`<`,`>`,`==`,`!=`) |
|               | Assignment (`=`,`+=`,`-=`,etc.), Increment (`++`,`--`) |
|               | Address (`&`), Dereference (`*`), Member (`.`,`->`) |
| **Control Flow** | `if`/`else`, `for`, `while`, `do-while`, `switch`/`case` |
|                 | `break`, `continue`, `return` |
| **Functions** | Definition, calls, parameters, variadic arguments (`...`) |
| **Advanced** | Type casting `(type)`, `sizeof` operator, constant expressions |
| **Preprocessor** | Limited support (string literals, character constants) |

## Building and Testing the Complete Compiler

### Build Process
```bash
cd frontEnd/15-more_type_and_constant_expr
mkdir build && cd build
cmake ..
make
```

### Testing Complex Programs
```bash
# Test the complete compiler with various programs
./15-more_type_and_constant_expr ../demo/2048.c      # Complete game
./15-more_type_and_constant_expr ../demo/cast.c      # Type casting
./15-more_type_and_constant_expr ../demo/typedef.c   # Type definitions
./15-more_type_and_constant_expr ../demo/array.c     # Array operations

# View generated LLVM IR
cat ../demo/2048.ll    # See the complete generated code
```

### Demo Programs Available
```
2048.c          # Complete 2048 game implementation
array.c         # Array manipulation examples
binary_err.c    # Error handling tests
cast.c, cast2.c # Type casting examples
eval1.c, eval2.c # Expression evaluation tests
typedef.c       # Type definition examples
e1.c - e23.c    # Various language feature tests
lisp.c          # LISP interpreter implementation!
maze.c          # Maze solver algorithm
nqueen.c        # N-Queens problem solver
```

## Architecture Achievement

The final frontend architecture represents a complete C compiler:

```
┌─────────────────┐
│   Source Code   │ (.c files)
└─────────┬───────┘
          ▼
┌─────────────────┐
│      Lexer      │ (tokenization)
└─────────┬───────┘
          ▼
┌─────────────────┐
│     Parser      │ (AST construction)
└─────────┬───────┘
          ▼
┌─────────────────┐
│ Semantic Analyzer│ (type checking, scope)
└─────────┬───────┘
          ▼
┌─────────────────┐
│  Code Generator │ (LLVM IR emission)
└─────────┬───────┘
          ▼
┌─────────────────┐
│    LLVM IR      │ (intermediate representation)
└─────────────────┘
```

### Quality Metrics
- **~4000+ lines** of well-structured C++ code
- **Complete C subset** supporting real programs
- **Professional error handling** with detailed diagnostics
- **Comprehensive testing** with unit tests and integration tests
- **Production patterns**: Symbol tables, AST design, visitor patterns

## Next Lesson Preview

In Lesson 6, we'll explore the backend RISC-V implementation that takes LLVM IR and generates actual machine code, completing our understanding of the full compilation pipeline.

---
*Lesson 5 completed. You now understand how a complete, production-quality C compiler frontend is built incrementally!*