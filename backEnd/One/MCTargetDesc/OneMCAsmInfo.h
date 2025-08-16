//
// Created by 蔡鹏 on 2024/12/1.
//

#ifndef ONEMCASMINFO_H
#define ONEMCASMINFO_H

#include "llvm/MC/MCAsmInfoELF.h"

namespace llvm {

class Triple;

class OneMCAsmInfo : public MCAsmInfoELF {
public:
  explicit OneMCAsmInfo(const Triple &TargetTriple);
};
} // namespace llvm

#endif // ONEMCASMINFO_H
