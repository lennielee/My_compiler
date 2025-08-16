//
// Created by 蔡鹏 on 2024/11/26.
//

#include "OneMCTargetDesc.h"
#include "OneInstPrinter.h"
#include "OneInstrInfo.h"
#include "OneMCAsmInfo.h"
#include "OneRegisterInfo.h"
#include "OneSubtarget.h"
#include "TargetInfo/OneTargetInfo.h"
#include "llvm/MC/TargetRegistry.h"

#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"

using namespace llvm;

#define GET_INSTRINFO_MC_DESC
#include "OneGenInstrInfo.inc"

#define GET_SUBTARGETINFO_MC_DESC
#include "OneGenSubtargetInfo.inc"

#define GET_REGINFO_MC_DESC
#include "OneGenRegisterInfo.inc"
/*
*  using MCInstrInfoCtorFnTy = MCInstrInfo *(*)();
  using MCInstrAnalysisCtorFnTy = MCInstrAnalysis *(*)(const MCInstrInfo *Info);
  using MCRegInfoCtorFnTy = MCRegisterInfo *(*)(const Triple &TT);
  using MCSubtargetInfoCtorFnTy = MCSubtargetInfo *(*)(const Triple &TT,
                                                       StringRef CPU,
                                                       StringRef Features);
 */

MCAsmInfo *createOneMCAsmInfo(const MCRegisterInfo &MRI, const Triple &TT,
                              const MCTargetOptions &Options) {
  return new OneMCAsmInfo(TT);
}

MCRegisterInfo *createOneMCRegisterInfo(const Triple &TT) {
  MCRegisterInfo *X = new MCRegisterInfo();
  InitOneMCRegisterInfo(X, One::RA);
  return X;
}

MCInstrInfo *createOneMCInstrInfo() {
  MCInstrInfo *X = new MCInstrInfo();
  InitOneMCInstrInfo(X);
  return X;
}

MCInstPrinter *createOneMCInstPrinter(const Triple &T, unsigned SyntaxVariant,
                                      const MCAsmInfo &MAI,
                                      const MCInstrInfo &MII,
                                      const MCRegisterInfo &MRI) {
  return new OneInstPrinter(MAI, MII, MRI);
}

MCSubtargetInfo *createOneMCSubtargetInfo(const Triple &TT, StringRef CPU,
                                          StringRef FS) {
  if (CPU.empty()) {
    CPU = "one";
  }
  return createOneMCSubtargetInfoImpl(TT, CPU, CPU, FS);
}

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeOneTargetMC() {
  TargetRegistry::RegisterMCAsmInfo(getTheOneTarget(), createOneMCAsmInfo);
  TargetRegistry::RegisterMCRegInfo(getTheOneTarget(), createOneMCRegisterInfo);
  TargetRegistry::RegisterMCInstrInfo(getTheOneTarget(), createOneMCInstrInfo);
  TargetRegistry::RegisterMCSubtargetInfo(getTheOneTarget(),
                                          createOneMCSubtargetInfo);
  TargetRegistry::RegisterMCInstPrinter(getTheOneTarget(),
                                        createOneMCInstPrinter);
}