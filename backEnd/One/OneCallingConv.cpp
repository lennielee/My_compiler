//
// Created by 蔡鹏 on 2025/1/29.
//

#include "OneCallingConv.h"
#include "llvm/CodeGen/TargetLowering.h"


using namespace llvm;

bool llvm::CC_One(unsigned ValNo, MVT ValVT, MVT LocVT,
              CCValAssign::LocInfo LocInfo, ISD::ArgFlagsTy ArgFlags,
              CCState &State) {
  unsigned XLen = 32;

  if (LocVT == MVT::i32) {
    static const MCPhysReg RegList1[] = {
      One::A0, One::A1, One::A2, One::A3, One::A4, One::A5, One::A6, One::A7
    };

    // If this is a variadic argument, the RISC-V calling convention requires
    // that it is assigned an 'even' or 'aligned' register if it has 8-byte
    // alignment (RV32) or 16-byte alignment (RV64). An aligned register should
    // be used regardless of whether the original argument was split during
    // legalisation or not. The argument will not be passed by registers if the
    // original type is larger than 2*XLEN, so the register alignment rule does
    // not apply.
    // TODO: To be compatible with GCC's behaviors, we don't align registers
    // currently if we are using ILP32E calling convention. This behavior may be
    // changed when RV32E/ILP32E is ratified.
    unsigned TwoXLenInBytes = (2 * XLen) / 8;
    if (ArgFlags.getNonZeroOrigAlign() == TwoXLenInBytes) {
      unsigned RegIdx = State.getFirstUnallocated(RegList1);
      // Skip 'odd' register if necessary.
      if (RegIdx != std::size(RegList1) && RegIdx % 2 == 1)
        State.AllocateReg(RegList1);
    }

    if (MCRegister Reg = State.AllocateReg(RegList1)) {
      State.addLoc(CCValAssign::getReg(ValNo, ValVT, Reg, LocVT, LocInfo));
      return false;
    }
  }

  int64_t Offset2 = State.AllocateStack(4, Align(4));
  State.addLoc(CCValAssign::getMem(ValNo, ValVT, Offset2, LocVT, LocInfo));
  return false;

  return true; // CC didn't match.
}