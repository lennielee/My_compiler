#!/bin/bash
# Complete Compiler Build and Test Script
# Usage: ./build_and_test.sh [program.c]

set -e  # Exit on any error

echo "=== Building Complete Compiler System ==="

# 1. Build the Frontend (Stage 15 - Complete Compiler)
echo "Building Frontend..."
cd frontEnd/15-more_type_and_constant_expr
if [ ! -d "build" ]; then
    mkdir build
fi
cd build
cmake ..
make -j$(nproc)
cd ../../..

# 2. Check if LLVM backend is integrated (would require LLVM source tree)
echo "Checking Backend Integration..."
if command -v llc >/dev/null 2>&1; then
    echo "LLVM tools found: $(llc --version | head -1)"
    BACKEND_AVAILABLE=true
else
    echo "Note: LLVM backend integration requires full LLVM build"
    BACKEND_AVAILABLE=false
fi

echo "=== Compiler Build Complete ==="

# 3. Test compilation if program provided
if [ $# -eq 1 ]; then
    PROGRAM=$1
    echo "=== Testing with $PROGRAM ==="
    
    # Frontend: C → LLVM IR
    echo "Step 1: Compiling C to LLVM IR..."
    ./frontEnd/15-more_type_and_constant_expr/build/15-more_type_and_constant_expr $PROGRAM > output.ll
    echo "Generated LLVM IR in output.ll"
    
    if [ "$BACKEND_AVAILABLE" = true ]; then
        # Backend: LLVM IR → Assembly (if available)
        echo "Step 2: Compiling LLVM IR to assembly..."
        llc output.ll -o output.s
        echo "Generated assembly in output.s"
        
        # Show the results
        echo "=== Generated LLVM IR (first 20 lines) ==="
        head -20 output.ll
        echo "=== Generated Assembly (first 20 lines) ==="
        head -20 output.s
    else
        echo "=== Generated LLVM IR ==="
        cat output.ll
    fi
else
    echo "=== Usage ==="
    echo "To test the compiler:"
    echo "  $0 program.c"
    echo ""
    echo "Example test programs in frontEnd/15-more_type_and_constant_expr/demo/:"
    ls frontEnd/15-more_type_and_constant_expr/demo/*.c | head -5
fi