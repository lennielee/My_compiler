//
// Created by 蔡鹏 on 2024/12/1.
//

#include "OneAsmPrinter.h"

#include "MCTargetDesc/OneMCExpr.h"
#include "MCTargetDesc/OneMCTargetDesc.h"
#include "TargetInfo/OneTargetInfo.h"

#include "llvm/MC/TargetRegistry.h"

using namespace llvm;

#define DEBUG_TYPE "asm-printer"

#define PRINT_ALIAS_INSTR
#include "OneGenMCPseudoLowering.inc"

bool OneAsmPrinter::runOnMachineFunction(MachineFunction &MF) {
  AsmPrinter::runOnMachineFunction(MF);
  return true;
}

void OneAsmPrinter::emitInstruction(const MachineInstr *MI) {
  // Do any auto-generated pseudo lowerings.
  if (MCInst OutInst; lowerPseudoInstExpansion(MI, OutInst)) {
    EmitToStreamer(*OutStreamer, OutInst);
    return;
  }

  MCInst TmpInst;
  lowerToMCInst(MI, TmpInst);
  EmitToStreamer(*OutStreamer, TmpInst);
}

void OneAsmPrinter::lowerToMCInst(const MachineInstr *MI, MCInst &Out) {
  Out.setOpcode(MI->getOpcode());

  for (const MachineOperand &MO : MI->operands()) {
    MCOperand MCOp;
    lowerOperand(MO, MCOp);
    Out.addOperand(MCOp);
  }
}

MCOperand OneAsmPrinter::lowerSymbolOperand(const MachineOperand &MO) const {
  // auto *symbol = getSymbol(MO.getGlobal());
  // const auto &expr = MCSymbolRefExpr::create(symbol,
  // MCSymbolRefExpr::VK_None, OutContext); MCOp = MCOperand::createExpr(expr);
  OneMCExpr::Kind kind = OneMCExpr::NONE;
  const MCSymbol *symbol = nullptr;
  switch (MO.getTargetFlags()) {
  case OneMCExpr::HI:
    kind = OneMCExpr::HI;
    break;
  case OneMCExpr::LO:
    kind = OneMCExpr::LO;
    break;
  default:
    break;
  }
  if (MO.getType() == MachineOperand::MO_MachineBasicBlock) {
    symbol = MO.getMBB()->getSymbol();
  } else if (MO.getType() == MachineOperand::MO_ExternalSymbol) {
    symbol = GetExternalSymbolSymbol(MO.getSymbolName());
  }
  else {
    symbol = getSymbol(MO.getGlobal());
  }
  const MCExpr *Expr = MCSymbolRefExpr::create(symbol, OutContext);
  Expr = new OneMCExpr(kind, Expr);
  return MCOperand::createExpr(Expr);
}

bool OneAsmPrinter::lowerOperand(const MachineOperand &MO,
                                 MCOperand &MCOp) const {
  switch (MO.getType()) {
  case MachineOperand::MO_Register: {
    MCOp = MCOperand::createReg(MO.getReg());
    return true;
  }
  case MachineOperand::MO_Immediate: {
    MCOp = MCOperand::createImm(MO.getImm());
    return true;
  }
  case MachineOperand::MO_GlobalAddress:
  case MachineOperand::MO_ExternalSymbol:
  case MachineOperand::MO_MachineBasicBlock: {
    MCOp = lowerSymbolOperand(MO);
    return true;
  }
  case MachineOperand::MO_RegisterMask: {
    /// Ignore
    break;
  }
  default:
    break;
  }
  MCOp = MCOperand();
  return true;
}

extern "C" LLVM_EXTERNAL_VISIBILITY void LLVMInitializeOneAsmPrinter() {
  RegisterAsmPrinter<OneAsmPrinter> X(getTheOneTarget());
}
