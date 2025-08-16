//
// Created by 蔡鹏 on 2025/1/20.
//

#include "OneMCExpr.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

void OneMCExpr::printImpl(raw_ostream &OS, const MCAsmInfo *MAI) const {
  switch (Kd) {
  case HI:
    OS << "%hi(";
    break;
  case LO:
    OS << "%lo(";
    break;
  default:
    break;
  }
  Expr->print(OS, MAI, true);

  switch (Kd) {
  case HI:
  case LO:
    OS << ")";
    break;
  default:
    break;
  }
}