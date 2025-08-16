//
// Created by 蔡鹏 on 2024/12/1.
//

#include "OneFrameLowering.h"
#include "MCTargetDesc/OneMCTargetDesc.h"

#include "One.h"
#include "OneSubtarget.h"

#include "llvm/CodeGen/MachineFrameInfo.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"

using namespace llvm;

uint64_t OneFrameLowering::computeStateSize(MachineFunction &MF) const {
  uint64_t STACKSIZE = MF.getFrameInfo().getStackSize();
  if (getStackAlignment() > 0) {
    STACKSIZE = ROUND_UP(STACKSIZE, getStackAlignment());
  }
  return STACKSIZE;
}

void OneFrameLowering::emitPrologue(MachineFunction &MF,
                                    MachineBasicBlock &MBB) const {
  MachineBasicBlock::iterator MBBI = MBB.begin();

  const TargetInstrInfo &TII = *STI.getInstrInfo();

  int STACKSIZE = computeStateSize(MF);

  if (STACKSIZE == 0) {
    return;
  }

  DebugLoc DL = MBBI != MBB.end() ? MBBI->getDebugLoc() : DebugLoc();
  BuildMI(MBB, MBBI, DL, TII.get(One::ADDI), One::SP)
      .addReg(One::SP)
      .addImm(-STACKSIZE)
      .setMIFlag(MachineInstr::FrameSetup);
}

void OneFrameLowering::emitEpilogue(MachineFunction &MF,
                                    MachineBasicBlock &MBB) const {
  MachineBasicBlock::iterator MBBI = MBB.getLastNonDebugInstr();

  const TargetInstrInfo &TII = *STI.getInstrInfo();

  int STACKSIZE = computeStateSize(MF);

  if (STACKSIZE == 0) {
    return;
  }

  DebugLoc DL = MBBI != MBB.end() ? MBBI->getDebugLoc() : DebugLoc();
  BuildMI(MBB, MBBI, DL, TII.get(One::ADDI), One::SP)
      .addReg(One::SP)
      .addImm(STACKSIZE)
      .setMIFlag(MachineInstr::FrameDestroy);
}

void OneFrameLowering::determineCalleeSaves(MachineFunction &MF, BitVector &SavedRegs, RegScavenger *RS) const {
  TargetFrameLowering::determineCalleeSaves(MF, SavedRegs, RS);
  if (MF.getFrameInfo().hasCalls()) {
    SavedRegs.set(One::RA);
  }
}

bool OneFrameLowering::hasFPImpl(const MachineFunction &MF) const {
  return false;
}