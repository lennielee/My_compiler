//
// Created by 蔡鹏 on 2025/1/20.
//

#ifndef ONEMCEXPR_H
#define ONEMCEXPR_H

#include "llvm/MC/MCExpr.h"

namespace llvm {
class OneMCExpr : public MCTargetExpr {
public:
  enum Kind { NONE, HI, LO };
  OneMCExpr(Kind K, const MCExpr *Expr) : Kd(K), Expr(Expr) {}

  void printImpl(raw_ostream &OS, const MCAsmInfo *MAI) const override;
  bool evaluateAsRelocatableImpl(MCValue &Res, const MCAssembler *Asm,
                                 const MCFixup *Fixup) const override {
    return false;
  };
  void visitUsedExpr(MCStreamer &Streamer) const override {}
  MCFragment *findAssociatedFragment() const override { return nullptr; }

  void fixELFSymbolsInTLSFixups(MCAssembler &) const override {}

private:
  const Kind Kd;
  const MCExpr *Expr;
};
} // namespace llvm

#endif // ONEMCEXPR_H
