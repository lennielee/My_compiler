//
// Created by 蔡鹏 on 2025/1/29.
//

#ifndef ONECALLINGCONV_H
#define ONECALLINGCONV_H
#include "MCTargetDesc/OneMCTargetDesc.h"
#include "llvm/CodeGen/CallingConvLower.h"

namespace llvm {
bool CC_One(unsigned ValNo, MVT ValVT, MVT LocVT,
              CCValAssign::LocInfo LocInfo, ISD::ArgFlagsTy ArgFlags,
              CCState &State);

}


#endif //ONECALLINGCONV_H
