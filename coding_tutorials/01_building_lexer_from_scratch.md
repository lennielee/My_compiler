# Coding Tutorial 1: Building a Lexer from Scratch

## Learning Objectives
- Write actual C++ code for a complete lexer
- Understand token recognition algorithms step by step
- Handle complex multi-character operators
- Implement proper error handling and source location tracking
- Build a lexer that integrates with the parser

## Part 1: Understanding the Lexer Interface

### The Token Class - Your Data Structure

First, let's understand what a token is and how to represent it:

```cpp
#pragma once
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/raw_ostream.h"

// All possible token types in our language
enum class TokenType : uint8_t {
    // Literals
    number,           // 42, 123
    identifier,       // variable names, function names
    
    // Keywords  
    kw_int,          // int
    kw_if,           // if
    kw_else,         // else
    kw_for,          // for
    kw_return,       // return
    
    // Single-character operators
    plus,            // +
    minus,           // -
    star,            // *
    slash,           // /
    equal,           // =
    l_parent,        // (
    r_parent,        // )
    l_brace,         // {
    r_brace,         // }
    semi,            // ;
    comma,           // ,
    
    // Multi-character operators
    equal_equal,     // ==
    not_equal,       // !=
    less_equal,      // <=
    greater_equal,   // >=
    plus_plus,       // ++
    minus_minus,     // --
    
    // Special
    eof,             // End of file
    unknown          // Error case
};

class Token {
public:
    // Where this token appears in source code
    int row, col;
    
    // What type of token this is
    TokenType tokenType;
    
    // For numbers: the actual numeric value
    int value;
    
    // The actual text from source code
    llvm::StringRef content;
    
    // Constructor
    Token() : row(-1), col(-1), tokenType(TokenType::unknown), value(-1) {}
    
    // Debug output
    void Dump() const {
        llvm::outs() << "Token{type=" << (int)tokenType 
                     << ", content=\"" << content 
                     << "\", row=" << row 
                     << ", col=" << col 
                     << "}\n";
    }
};
```

### The Lexer Class - Your State Machine

```cpp
class Lexer {
public:
    // Constructor: Initialize with source code
    Lexer(llvm::StringRef sourceCode);
    
    // Main interface: Get the next token
    void NextToken(Token &tok);
    
    // Peek at next token without consuming it
    void PeekToken(Token &tok);

private:
    // Current position in source code
    const char *BufPtr;     // Current character
    const char *BufEnd;     // End of source code
    const char *LineHeadPtr; // Start of current line
    int row;                 // Current line number
    
    // Helper methods
    void SkipWhitespace();
    void LexNumber(Token &tok);
    void LexIdentifier(Token &tok);
    void LexOperator(Token &tok);
    bool IsDigit(char ch);
    bool IsAlpha(char ch);
    bool IsAlnum(char ch);
};
```

## Part 2: Implementing the Lexer Step by Step

### Step 1: Constructor and Basic Setup

```cpp
#include "lexer.h"

// Helper functions - these will be used throughout
bool Lexer::IsDigit(char ch) {
    return (ch >= '0' && ch <= '9');
}

bool Lexer::IsAlpha(char ch) {
    return (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') || ch == '_';
}

bool Lexer::IsAlnum(char ch) {
    return IsAlpha(ch) || IsDigit(ch);
}

// Constructor: Set up initial state
Lexer::Lexer(llvm::StringRef sourceCode) {
    BufPtr = sourceCode.begin();    // Start at beginning
    BufEnd = sourceCode.end();      // Remember where to stop
    LineHeadPtr = sourceCode.begin(); // Track line starts for column calculation
    row = 1;                        // Start at line 1
}
```

### Step 2: Whitespace Handling

```cpp
void Lexer::SkipWhitespace() {
    while (BufPtr < BufEnd) {
        char ch = *BufPtr;
        
        if (ch == ' ' || ch == '\t' || ch == '\r') {
            // Skip regular whitespace
            BufPtr++;
        } else if (ch == '\n') {
            // New line: increment row, update line head
            row++;
            BufPtr++;
            LineHeadPtr = BufPtr;  // Next line starts here
        } else {
            // Not whitespace, stop skipping
            break;
        }
    }
}
```

### Step 3: Number Lexing (Complete Implementation)

```cpp
void Lexer::LexNumber(Token &tok) {
    const char *start = BufPtr;  // Remember where number starts
    int number = 0;
    int len = 0;
    
    // Read all consecutive digits
    while (BufPtr < BufEnd && IsDigit(*BufPtr)) {
        number = number * 10 + (*BufPtr - '0');  // Convert char to digit
        BufPtr++;
        len++;
    }
    
    // Fill in token information
    tok.tokenType = TokenType::number;
    tok.value = number;
    tok.content = llvm::StringRef(start, len);
}
```

**How this works:**
- `*BufPtr - '0'` converts ASCII digit to numeric value ('0' = 48, '1' = 49, so '1' - '0' = 1)
- `number * 10 + digit` builds the number left-to-right (123 = ((1*10 + 2)*10 + 3))
- `StringRef(start, len)` captures the exact text from source

### Step 4: Identifier and Keyword Lexing

```cpp
void Lexer::LexIdentifier(Token &tok) {
    const char *start = BufPtr;
    
    // First character must be letter or underscore
    if (!IsAlpha(*BufPtr)) {
        tok.tokenType = TokenType::unknown;
        return;
    }
    
    // Read letters, digits, underscores
    while (BufPtr < BufEnd && IsAlnum(*BufPtr)) {
        BufPtr++;
    }
    
    int len = BufPtr - start;
    tok.content = llvm::StringRef(start, len);
    
    // Check if this identifier is actually a keyword
    if (tok.content == "int") {
        tok.tokenType = TokenType::kw_int;
    } else if (tok.content == "if") {
        tok.tokenType = TokenType::kw_if;
    } else if (tok.content == "else") {
        tok.tokenType = TokenType::kw_else;
    } else if (tok.content == "for") {
        tok.tokenType = TokenType::kw_for;
    } else if (tok.content == "return") {
        tok.tokenType = TokenType::kw_return;
    } else {
        // Not a keyword, it's an identifier
        tok.tokenType = TokenType::identifier;
    }
}
```

**Advanced Keyword Lookup (More Efficient):**

```cpp
#include <unordered_map>

class Lexer {
private:
    // Static keyword map - initialized once
    static std::unordered_map<std::string, TokenType> keywords;
    
public:
    static void InitializeKeywords() {
        if (keywords.empty()) {
            keywords["int"] = TokenType::kw_int;
            keywords["if"] = TokenType::kw_if;
            keywords["else"] = TokenType::kw_else;
            keywords["for"] = TokenType::kw_for;
            keywords["while"] = TokenType::kw_while;
            keywords["return"] = TokenType::kw_return;
            keywords["break"] = TokenType::kw_break;
            keywords["continue"] = TokenType::kw_continue;
            keywords["sizeof"] = TokenType::kw_sizeof;
            keywords["struct"] = TokenType::kw_struct;
            keywords["union"] = TokenType::kw_union;
            keywords["typedef"] = TokenType::kw_typedef;
            keywords["const"] = TokenType::kw_const;
        }
    }
};

void Lexer::LexIdentifier(Token &tok) {
    const char *start = BufPtr;
    
    // Read identifier characters
    while (BufPtr < BufEnd && IsAlnum(*BufPtr)) {
        BufPtr++;
    }
    
    int len = BufPtr - start;
    tok.content = llvm::StringRef(start, len);
    
    // Look up in keyword table
    std::string str(tok.content.str());
    auto it = keywords.find(str);
    if (it != keywords.end()) {
        tok.tokenType = it->second;  // It's a keyword
    } else {
        tok.tokenType = TokenType::identifier;  // It's an identifier
    }
}
```

### Step 5: Operator Lexing (The Complex Part!)

This is where it gets interesting. We need to handle both single-character (`+`, `-`) and multi-character (`++`, `==`, `<=`) operators:

```cpp
void Lexer::LexOperator(Token &tok) {
    const char *start = BufPtr;
    char ch = *BufPtr++;  // Read current character and advance
    
    // This is the tricky part - we need to look ahead for multi-char operators
    switch (ch) {
    case '+':
        if (BufPtr < BufEnd && *BufPtr == '+') {
            BufPtr++;  // Consume second '+'
            tok.tokenType = TokenType::plus_plus;
            tok.content = llvm::StringRef(start, 2);
        } else {
            tok.tokenType = TokenType::plus;
            tok.content = llvm::StringRef(start, 1);
        }
        break;
        
    case '-':
        if (BufPtr < BufEnd && *BufPtr == '-') {
            BufPtr++;  // Consume second '-'
            tok.tokenType = TokenType::minus_minus;
            tok.content = llvm::StringRef(start, 2);
        } else {
            tok.tokenType = TokenType::minus;
            tok.content = llvm::StringRef(start, 1);
        }
        break;
        
    case '=':
        if (BufPtr < BufEnd && *BufPtr == '=') {
            BufPtr++;  // Consume second '='
            tok.tokenType = TokenType::equal_equal;
            tok.content = llvm::StringRef(start, 2);
        } else {
            tok.tokenType = TokenType::equal;
            tok.content = llvm::StringRef(start, 1);
        }
        break;
        
    case '<':
        if (BufPtr < BufEnd && *BufPtr == '=') {
            BufPtr++;
            tok.tokenType = TokenType::less_equal;
            tok.content = llvm::StringRef(start, 2);
        } else if (BufPtr < BufEnd && *BufPtr == '<') {
            BufPtr++;
            tok.tokenType = TokenType::less_less;  // << (left shift)
            tok.content = llvm::StringRef(start, 2);
        } else {
            tok.tokenType = TokenType::less;
            tok.content = llvm::StringRef(start, 1);
        }
        break;
        
    case '>':
        if (BufPtr < BufEnd && *BufPtr == '=') {
            BufPtr++;
            tok.tokenType = TokenType::greater_equal;
            tok.content = llvm::StringRef(start, 2);
        } else if (BufPtr < BufEnd && *BufPtr == '>') {
            BufPtr++;
            tok.tokenType = TokenType::greater_greater;  // >> (right shift)
            tok.content = llvm::StringRef(start, 2);
        } else {
            tok.tokenType = TokenType::greater;
            tok.content = llvm::StringRef(start, 1);
        }
        break;
        
    case '!':
        if (BufPtr < BufEnd && *BufPtr == '=') {
            BufPtr++;
            tok.tokenType = TokenType::not_equal;
            tok.content = llvm::StringRef(start, 2);
        } else {
            tok.tokenType = TokenType::exclaim;
            tok.content = llvm::StringRef(start, 1);
        }
        break;
        
    case '&':
        if (BufPtr < BufEnd && *BufPtr == '&') {
            BufPtr++;
            tok.tokenType = TokenType::ampamp;  // && (logical and)
            tok.content = llvm::StringRef(start, 2);
        } else {
            tok.tokenType = TokenType::amp;      // & (bitwise and)
            tok.content = llvm::StringRef(start, 1);
        }
        break;
        
    case '|':
        if (BufPtr < BufEnd && *BufPtr == '|') {
            BufPtr++;
            tok.tokenType = TokenType::pipepipe;  // || (logical or)
            tok.content = llvm::StringRef(start, 2);
        } else {
            tok.tokenType = TokenType::pipe;      // | (bitwise or)
            tok.content = llvm::StringRef(start, 1);
        }
        break;
        
    // Simple single-character operators
    case '*':
        tok.tokenType = TokenType::star;
        tok.content = llvm::StringRef(start, 1);
        break;
    case '/':
        tok.tokenType = TokenType::slash;
        tok.content = llvm::StringRef(start, 1);
        break;
    case '%':
        tok.tokenType = TokenType::percent;
        tok.content = llvm::StringRef(start, 1);
        break;
    case '(':
        tok.tokenType = TokenType::l_parent;
        tok.content = llvm::StringRef(start, 1);
        break;
    case ')':
        tok.tokenType = TokenType::r_parent;
        tok.content = llvm::StringRef(start, 1);
        break;
    case '{':
        tok.tokenType = TokenType::l_brace;
        tok.content = llvm::StringRef(start, 1);
        break;
    case '}':
        tok.tokenType = TokenType::r_brace;
        tok.content = llvm::StringRef(start, 1);
        break;
    case ';':
        tok.tokenType = TokenType::semi;
        tok.content = llvm::StringRef(start, 1);
        break;
    case ',':
        tok.tokenType = TokenType::comma;
        tok.content = llvm::StringRef(start, 1);
        break;
    case '^':
        tok.tokenType = TokenType::caret;
        tok.content = llvm::StringRef(start, 1);
        break;
    case '~':
        tok.tokenType = TokenType::tilde;
        tok.content = llvm::StringRef(start, 1);
        break;
        
    default:
        // Unknown character
        tok.tokenType = TokenType::unknown;
        tok.content = llvm::StringRef(start, 1);
        break;
    }
}
```

### Step 6: The Main NextToken Method (Putting It All Together)

```cpp
void Lexer::NextToken(Token &tok) {
    // Step 1: Skip any whitespace
    SkipWhitespace();
    
    // Step 2: Record current position for this token
    tok.row = row;
    tok.col = BufPtr - LineHeadPtr + 1;  // Column number (1-based)
    
    // Step 3: Check for end of file
    if (BufPtr >= BufEnd) {
        tok.tokenType = TokenType::eof;
        tok.content = llvm::StringRef("");
        return;
    }
    
    // Step 4: Look at current character and decide what to do
    char ch = *BufPtr;
    
    if (IsDigit(ch)) {
        // It's a number
        LexNumber(tok);
    } else if (IsAlpha(ch)) {
        // It's an identifier or keyword
        LexIdentifier(tok);
    } else {
        // It's an operator or punctuation
        LexOperator(tok);
    }
}
```

## Part 3: Advanced Features and Error Handling

### String Literals (Optional but Useful)

```cpp
void Lexer::LexString(Token &tok) {
    const char *start = BufPtr;
    BufPtr++;  // Skip opening quote
    
    std::string stringValue;
    
    while (BufPtr < BufEnd && *BufPtr != '"') {
        if (*BufPtr == '\\') {
            // Handle escape sequences
            BufPtr++;
            if (BufPtr >= BufEnd) break;
            
            switch (*BufPtr) {
            case 'n': stringValue += '\n'; break;
            case 't': stringValue += '\t'; break;
            case 'r': stringValue += '\r'; break;
            case '\\': stringValue += '\\'; break;
            case '"': stringValue += '"'; break;
            case '0': stringValue += '\0'; break;
            default:
                // Unknown escape sequence - just include literally
                stringValue += *BufPtr;
                break;
            }
        } else {
            stringValue += *BufPtr;
        }
        BufPtr++;
    }
    
    if (BufPtr < BufEnd && *BufPtr == '"') {
        BufPtr++;  // Skip closing quote
        tok.tokenType = TokenType::str;
        tok.content = llvm::StringRef(start, BufPtr - start);
        // Store the actual string value somewhere (maybe in Token class)
    } else {
        // Unterminated string
        tok.tokenType = TokenType::unknown;
        tok.content = llvm::StringRef(start, BufPtr - start);
    }
}
```

### Comment Handling

```cpp
void Lexer::SkipLineComment() {
    // Skip until end of line
    while (BufPtr < BufEnd && *BufPtr != '\n') {
        BufPtr++;
    }
    // Don't skip the newline - let SkipWhitespace handle it
}

void Lexer::SkipBlockComment() {
    BufPtr += 2;  // Skip /*
    
    while (BufPtr + 1 < BufEnd) {
        if (*BufPtr == '*' && *(BufPtr + 1) == '/') {
            BufPtr += 2;  // Skip */
            return;
        }
        if (*BufPtr == '\n') {
            row++;
            LineHeadPtr = BufPtr + 1;
        }
        BufPtr++;
    }
    // Unterminated block comment - should report error
}

// Modify LexOperator to handle comments
void Lexer::LexOperator(Token &tok) {
    const char *start = BufPtr;
    char ch = *BufPtr++;
    
    switch (ch) {
    case '/':
        if (BufPtr < BufEnd && *BufPtr == '/') {
            // Line comment
            SkipLineComment();
            NextToken(tok);  // Get next token after comment
            return;
        } else if (BufPtr < BufEnd && *BufPtr == '*') {
            // Block comment
            SkipBlockComment();
            NextToken(tok);  // Get next token after comment
            return;
        } else {
            tok.tokenType = TokenType::slash;
            tok.content = llvm::StringRef(start, 1);
        }
        break;
    // ... rest of cases
    }
}
```

## Part 4: Testing Your Lexer

### Simple Test Program

```cpp
#include "lexer.h"
#include <iostream>

void TestLexer() {
    // Test input
    std::string input = R"(
        int main() {
            int x = 42;
            int y = x + 10;
            if (x == 42) {
                return y;
            }
        }
    )";
    
    Lexer lexer(llvm::StringRef(input));
    Token tok;
    
    std::cout << "Tokenizing input:\n" << input << "\n\n";
    std::cout << "Tokens:\n";
    
    do {
        lexer.NextToken(tok);
        tok.Dump();
    } while (tok.tokenType != TokenType::eof);
}

int main() {
    TestLexer();
    return 0;
}
```

### Expected Output:
```
Token{type=4, content="int", row=2, col=9}
Token{type=2, content="main", row=2, col=13}
Token{type=27, content="(", row=2, col=17}
Token{type=28, content=")", row=2, col=18}
Token{type=32, content="{", row=2, col=20}
Token{type=4, content="int", row=3, col=13}
Token{type=2, content="x", row=3, col=17}
Token{type=30, content="=", row=3, col=19}
Token{type=0, content="42", row=3, col=21}
Token{type=29, content=";", row=3, col=23}
// ... more tokens
```

## Part 5: Integration with Parser

Your lexer needs to work seamlessly with the parser. Here's how to create the interface:

```cpp
class Parser {
private:
    Lexer& lexer;
    Token currentToken;
    
public:
    Parser(Lexer& lex) : lexer(lex) {
        // Get first token
        lexer.NextToken(currentToken);
    }
    
    void ConsumeToken() {
        lexer.NextToken(currentToken);
    }
    
    bool IsToken(TokenType type) {
        return currentToken.tokenType == type;
    }
    
    bool ConsumeToken(TokenType expected) {
        if (currentToken.tokenType == expected) {
            ConsumeToken();
            return true;
        }
        return false;  // Error: unexpected token
    }
};
```

## Part 6: Error Handling and Diagnostics

### Enhanced Token with Source Location

```cpp
struct SourceLocation {
    int row, col;
    const char* filename;
    
    SourceLocation(int r = -1, int c = -1, const char* f = nullptr) 
        : row(r), col(c), filename(f) {}
};

class Token {
public:
    SourceLocation loc;
    TokenType tokenType;
    llvm::StringRef content;
    union {
        int intValue;       // For numbers
        const char* strValue; // For strings
    };
    
    void ReportError(const std::string& message) {
        std::cerr << loc.filename << ":" << loc.row << ":" << loc.col 
                  << ": error: " << message << std::endl;
    }
};
```

## Summary: What You've Learned

You now know how to:

1. **Design token representation** with all necessary information
2. **Implement character-by-character scanning** with proper state tracking
3. **Handle complex multi-character operators** with lookahead
4. **Distinguish keywords from identifiers** efficiently
5. **Track source locations** for error reporting
6. **Handle edge cases** like comments, strings, and end-of-file
7. **Create clean interfaces** for parser integration

**Key Algorithms You Implemented:**
- **Finite State Machine**: For recognizing different token types
- **Lookahead**: For multi-character operators
- **Hash Table Lookup**: For keyword recognition
- **String Building**: For numbers and identifiers

**Next Step**: Now you're ready to learn how to build a parser that consumes these tokens and builds an Abstract Syntax Tree!
