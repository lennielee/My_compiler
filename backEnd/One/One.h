//
// Created by 蔡鹏 on 2024/12/1.
//

#ifndef ONE_H
#define ONE_H
namespace llvm {

#define DIV_ROUND_UP(n, d)  (((n) + (d) - 1) / (d))
#define ROUND_UP(x, align)  (DIV_ROUND_UP(x, align) * (align))

class FunctionPass;
class OneTargetMachine;
class PassRegistry;

FunctionPass *createOneISelDag(OneTargetMachine &TM);

void initializeOneDAGToDAGISelLegacyPass(PassRegistry &);

} // namespace llvm
#endif // ONE_H
