//
// Created by 蔡鹏 on 2024/11/26.
//

#ifndef ONETARGETMACHINE_H
#define ONETARGETMACHINE_H
#include "OneSubtarget.h"
#include "llvm/Target/TargetMachine.h"

namespace llvm {
class OneTargetMachine : public LLVMTargetMachine {
  std::unique_ptr<TargetLoweringObjectFile> TLOF;
  OneSubtarget Subtarget;

public:
  OneTargetMachine(const Target &T, const Triple &TT, StringRef CPU,
                   StringRef FS, const TargetOptions &Options,
                   std::optional<Reloc::Model> RM,
                   std::optional<CodeModel::Model> CM, CodeGenOptLevel OL,
                   bool JIT);

  const OneSubtarget *getSubtargetImpl() const { return &Subtarget; }
  const OneSubtarget *getSubtargetImpl(const Function &) const override {
    return &Subtarget;
  }
  TargetLoweringObjectFile *getObjFileLowering() const override {
    return TLOF.get();
  }

  // Pass Pipeline Configuration
  TargetPassConfig *createPassConfig(PassManagerBase &PM) override;
};
} // namespace llvm

#endif //ONETARGETMACHINE_H
