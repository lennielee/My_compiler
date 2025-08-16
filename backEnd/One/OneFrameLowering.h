//
// Created by 蔡鹏 on 2024/12/1.
//

#ifndef ONEFRAMELOWERING_H
#define ONEFRAMELOWERING_H

#include "llvm/CodeGen/TargetFrameLowering.h"
namespace llvm {
class OneSubtarget;
class OneFrameLowering : public TargetFrameLowering {
  const OneSubtarget &STI;

public:
  explicit OneFrameLowering(const OneSubtarget &STI)
      : TargetFrameLowering(TargetFrameLowering::StackGrowsDown, Align(16), 0,
                            Align(16)),
        STI(STI) {}
  void emitPrologue(MachineFunction &MF, MachineBasicBlock &MBB) const override;

  void emitEpilogue(MachineFunction &MF, MachineBasicBlock &MBB) const override;

  void determineCalleeSaves(MachineFunction &MF, BitVector &SavedRegs, RegScavenger *RS) const override;

protected:
  bool hasFPImpl(const MachineFunction &MF) const override;

private:
  uint64_t computeStateSize(MachineFunction &MF) const;
};
} // namespace llvm

#endif // ONEFRAMELOWERING_H
