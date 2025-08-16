//
// Created by 蔡鹏 on 2024/12/1.
//

#ifndef ONEREGISTERINFO_H
#define ONEREGISTERINFO_H

#define GET_REGINFO_HEADER
#include "OneGenRegisterInfo.inc"

namespace llvm {
class OneSubtarget;
class OneRegisterInfo : public OneGenRegisterInfo {
  const OneSubtarget &STI;
public:
  OneRegisterInfo(const OneSubtarget &STI);

  const MCPhysReg *getCalleeSavedRegs(const MachineFunction *MF) const override;
  const uint32_t *getCallPreservedMask(const MachineFunction &MF, CallingConv::ID) const override;

  BitVector getReservedRegs(const MachineFunction &MF) const override;

  bool eliminateFrameIndex(MachineBasicBlock::iterator II, int SPAdj,
                           unsigned FIOperandNum,
                           RegScavenger *RS = nullptr) const override;

  Register getFrameRegister(const MachineFunction &MF) const override;
};
} // namespace llvm

#endif // ONEREGISTERINFO_H
