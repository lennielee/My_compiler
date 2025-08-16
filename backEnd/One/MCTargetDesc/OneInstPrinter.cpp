//
// Created by 蔡鹏 on 2024/12/1.
//

#include "OneInstPrinter.h"
#include "OneInstrInfo.h"
#include "OneRegisterInfo.h"

using namespace llvm;

#define DEBUG_TYPE "asm-printer"

#define PRINT_ALIAS_INSTR
#include "OneGenAsmWriter.inc"

void OneInstPrinter::printRegName(raw_ostream &OS, MCRegister Reg) {
  OS << getRegisterName(Reg);
}

void OneInstPrinter::printInst(const MCInst *MI, uint64_t Address,
                               StringRef Annot, const MCSubtargetInfo &STI,
                               raw_ostream &O) {
  if (!printAliasInstr(MI, Address, O))
    printInstruction(MI, Address, O);

  printAnnotation(O, Annot);
}

void OneInstPrinter::printOperand(const MCInst *MI, unsigned OpNo,
                                  raw_ostream &O) {
  const MCOperand &MO = MI->getOperand(OpNo);
  if (MO.isReg()) {
    printRegName(O, MO.getReg());
    return;
  }

  if (MO.isImm()) {
    printImmediate(MI, OpNo, O);
    return;
  }

  assert(MO.isExpr() && "Unknown operand kind in printOperand");
  MO.getExpr()->print(O, &MAI);
}

void OneInstPrinter::printImmediate(const MCInst *MI, unsigned opNum,
                                    raw_ostream &O) {
  const MCOperand &MO = MI->getOperand(opNum);
  if (MO.isImm())
    O << MO.getImm();
  else if (MO.isExpr()) {
    MO.getExpr()->print(O, &MAI);
  } else
    llvm_unreachable("Unknown immediate kind");
}

void OneInstPrinter::printMemOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O) {
  /// 先打印立即数 12(sp)
  printOperand(MI, OpNo + 1, O);
  O << "(";
  printOperand(MI, OpNo, O);
  O << ")";
}

void OneInstPrinter::printPtrOperand(const MCInst *MI, unsigned OpNo, raw_ostream &O) {
  printOperand(MI, OpNo, O);
  O << ",";
  printOperand(MI, OpNo+1, O);
}