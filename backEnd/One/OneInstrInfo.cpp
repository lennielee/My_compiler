//
// Created by 蔡鹏 on 2024/12/1.
//

#include "OneInstrInfo.h"
#include "MCTargetDesc/OneMCTargetDesc.h"

using namespace llvm;

#define GET_INSTRINFO_CTOR_DTOR
#include "OneGenInstrInfo.inc"

OneInstrInfo::OneInstrInfo() : OneGenInstrInfo() {}

void OneInstrInfo::storeRegToStackSlot(
    MachineBasicBlock &MBB, MachineBasicBlock::iterator MI, Register SrcReg,
    bool isKill, int FrameIndex, const TargetRegisterClass *RC,
    const TargetRegisterInfo *TRI, Register VReg) const {
  DebugLoc DL;
  BuildMI(MBB, MI, DL, get(One::STOREWFI))
      .addReg(SrcReg, getKillRegState(isKill))
      .addFrameIndex(FrameIndex)
      .addImm(0);
}

void OneInstrInfo::loadRegFromStackSlot(MachineBasicBlock &MBB,
                                        MachineBasicBlock::iterator MI,
                                        Register DestReg, int FrameIndex,
                                        const TargetRegisterClass *RC,
                                        const TargetRegisterInfo *TRI,
                                        Register VReg) const {
  DebugLoc DL;
  BuildMI(MBB, MI, DL, get(One::LOADWFI), DestReg)
      .addFrameIndex(FrameIndex)
      .addImm(0);
}

void OneInstrInfo::copyPhysReg(MachineBasicBlock &MBB, MachineBasicBlock::iterator MI, const DebugLoc &DL, MCRegister DestReg, MCRegister SrcReg, bool KillSrc, bool RenamableDest, bool RenamableSrc) const {
  /// add dst, zero, src
  MachineInstrBuilder MIB = BuildMI(MBB, MI, DL, get(One::ADD));
  MIB.addReg(DestReg, RegState::Define);
  MIB.addReg(One::ZERO);
  MIB.addReg(SrcReg, getKillRegState(KillSrc));
}