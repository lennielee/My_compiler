//
// Created by 蔡鹏 on 2024/12/1.
//
#include "MCTargetDesc/OneMCTargetDesc.h"
#include "One.h"
#include "OneSubtarget.h"
#include "OneTargetMachine.h"
#include "llvm/CodeGen/SelectionDAGISel.h"

using namespace llvm;

#define DEBUG_TYPE "one-isel"
#define PASS_NAME "One DAG->DAG Pattern Instruction Selection"

class OneDAGToDAGISel : public SelectionDAGISel {
public:
  OneDAGToDAGISel() = delete;
  explicit OneDAGToDAGISel(OneTargetMachine &TM, CodeGenOptLevel OL)
      : SelectionDAGISel(TM, OL), Subtarget(nullptr) {}

  bool runOnMachineFunction(MachineFunction &MF) override;

  bool SelectAddrFI(SDNode *Parent, SDValue AddrFI, SDValue &BASE, SDValue &Offset);

private:
  const OneSubtarget *Subtarget;

#include "OneGenDAGISel.inc"

  /// getTargetMachine - Return a reference to the TargetMachine, casted
  /// to the target-specific type.
  const OneTargetMachine &getTargetMachine() {
    return static_cast<const OneTargetMachine &>(TM);
  }

  void Select(SDNode *N) override;
};

bool OneDAGToDAGISel::runOnMachineFunction(MachineFunction &MF) {
  Subtarget = &MF.getSubtarget<OneSubtarget>();
  return SelectionDAGISel::runOnMachineFunction(MF);
}

void OneDAGToDAGISel::Select(SDNode *Node) {
  if (Node->isMachineOpcode()) {
    Node->setNodeId(-1);
    return;
  }
  SDLoc DL(Node);

  LLVM_DEBUG(dbgs() << "Selecting: "; Node->dump(CurDAG); dbgs() << '\n');

  SelectCode(Node);
}

bool OneDAGToDAGISel::SelectAddrFI(SDNode *Parent, SDValue AddrFI, SDValue &Base, SDValue &Offset) {
  /// FrameIndex -> TargetFrameIndex
  if (FrameIndexSDNode *FIN = dyn_cast<FrameIndexSDNode>(AddrFI)) {
    Base = CurDAG->getTargetFrameIndex(FIN->getIndex(), AddrFI.getValueType());
    Offset = CurDAG->getTargetConstant(0, SDLoc(AddrFI), AddrFI.getValueType());
    return true;
  }
  if (CurDAG->isBaseWithConstantOffset(AddrFI)) {
    ConstantSDNode *CN = dyn_cast<ConstantSDNode>(AddrFI.getOperand(1));

    if (FrameIndexSDNode *FS = dyn_cast<FrameIndexSDNode>(AddrFI.getOperand(0))) {
      Base = CurDAG->getTargetFrameIndex(FS->getIndex(), AddrFI.getValueType());
    }else {
      Base = AddrFI.getOperand(0);
    }
    Offset = CurDAG->getTargetConstant(CN->getZExtValue(), SDLoc(AddrFI), AddrFI.getValueType());
    return true;
  }
  return false;
}

class OneDAGToDAGISelLegacy : public SelectionDAGISelLegacy {
public:
  static char ID;
  explicit OneDAGToDAGISelLegacy(OneTargetMachine &TM)
      : SelectionDAGISelLegacy(ID, std::make_unique<OneDAGToDAGISel>(TM, TM.getOptLevel())) {}
};

char OneDAGToDAGISelLegacy::ID;

INITIALIZE_PASS(OneDAGToDAGISelLegacy, DEBUG_TYPE, PASS_NAME, false, false)

/// This pass converts a legalized DAG into a M68k-specific DAG,
/// ready for instruction scheduling.
FunctionPass *llvm::createOneISelDag(OneTargetMachine &TM) {
  return new OneDAGToDAGISelLegacy(TM);
}