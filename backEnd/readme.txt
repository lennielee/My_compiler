课程基于llvm-project的commit: ae4fc80574cfbbf2b2b53f2728cd785db76e9e69


One文件夹表示整个后端的代码，放入到 llvm-project/llvm/lib/Target 文件夹下面

Triple.h 和 Triple.cpp 文件是LLVM项目的公共代码，我们需要加入自己架构的枚举值

Triple.h文件的路径在： llvm-project/llvm/include/llvm/TargetParser/Triple.h
Triple.cpp文件的路径在：llvm-project/llvm/lib/TargetParser/Triple.cpp