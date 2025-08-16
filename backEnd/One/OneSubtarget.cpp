//
// Created by 蔡鹏 on 2024/12/1.
//

#include "OneSubtarget.h"

using namespace llvm;

#define DEBUG_TYPE "One-Subtarget"

#define GET_SUBTARGETINFO_TARGET_DESC
#define GET_SUBTARGETINFO_CTOR
#include "OneGenSubtargetInfo.inc"

OneSubtarget::OneSubtarget(const Triple &TT, StringRef CPU, StringRef FS,
                           const TargetMachine &TM)
    : OneGenSubtargetInfo(TT, CPU, CPU, FS), RegInfo(*this),
      FrameLowering(*this), TLI(TM, *this) {}

OneSubtarget &
OneSubtarget::initializeSubtargetDependencies(StringRef CPU, StringRef FS,
                                              const TargetMachine &TM)

{
  if (CPU.empty()) {
    CPU = "one";
  }
  ParseSubtargetFeatures(CPU, /*TuneCPU*/ CPU, FS);

  return *this;
}