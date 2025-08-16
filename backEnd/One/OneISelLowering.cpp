//
// Created by 蔡鹏 on 2024/12/1.
//

#include "OneISelLowering.h"
#include "MCTargetDesc/OneMCExpr.h"
#include "MCTargetDesc/OneMCTargetDesc.h"
#include "OneSubtarget.h"
#include "llvm/CodeGen/CallingConvLower.h"
#include "llvm/CodeGen/MachineFrameInfo.h"
#include "OneCallingConv.h"

#include <deque>

using namespace llvm;

#include "OneGenCallingConv.inc"

OneTargetLowering::OneTargetLowering(const TargetMachine &TM,
                                     const OneSubtarget &STI)
    : TargetLowering(TM), Subtarget(STI) {
  /// 注册RegiserClass
  /// 还要处理合法化（类型和操作）
  addRegisterClass(MVT::i32, &One::GPRRegClass);

  /// 注册合法化的操作
  setOperationAction(ISD::GlobalAddress, MVT::i32, Custom);
  setOperationAction(ISD::Constant, MVT::i32, Custom);
  setOperationAction(ISD::BR_CC, MVT::i32, Expand);

  computeRegisterProperties(STI.getRegisterInfo());
}

SDValue OneTargetLowering::LowerCall(CallLoweringInfo &CLI,
                                     SmallVectorImpl<SDValue> &InVals) const {
  SelectionDAG &DAG = CLI.DAG;
  SDLoc &DL = CLI.DL;
  SmallVectorImpl<ISD::OutputArg> &Outs = CLI.Outs;
  SmallVectorImpl<SDValue> &OutVals = CLI.OutVals;
  SmallVectorImpl<ISD::InputArg> &Ins = CLI.Ins;
  SDValue Chain = CLI.Chain;
  SDValue Callee = CLI.Callee;
  CallingConv::ID CallConv = CLI.CallConv;
  bool IsVarArg = CLI.IsVarArg;

  /// 1. 处理实参，根据调用约定（通过寄存器，内存栈来传递参数）
  /// 2. 根据参数的寄存器的个数，来生成相应的copyFromReg
  /// 3. 生成Call节点
  /// 4. 处理Call的返回值，根据Ins，填充InVals
  ///
  MachineFunction &MF = DAG.getMachineFunction();
  SmallVector<CCValAssign, 16> ArgLocs;
  CCState CCInfo(CallConv, IsVarArg, MF, ArgLocs, *DAG.getContext());
  CCInfo.AnalyzeCallOperands(Outs, CC_One);

  /// 寄存器的编号，实参
  SmallVector<std::pair<unsigned, SDValue>> RegsPairs;
  SDValue StackPtr;

  for (unsigned i = 0, e = ArgLocs.size(); i != e; ++i) {
    CCValAssign &VA = ArgLocs[i];
    if (VA.isRegLoc()) {
      RegsPairs.push_back(std::make_pair(VA.getLocReg(), OutVals[i]));
    } else {
      // store
      assert(VA.isMemLoc());
      if (!StackPtr.getNode()) {
        StackPtr = DAG.getCopyFromReg(Chain, DL, One::SP,
                                      getPointerTy(DAG.getDataLayout()));
      }
      unsigned LocMemOffset = VA.getLocMemOffset();
      SDValue PtrOff = DAG.getIntPtrConstant(LocMemOffset, DL);
      PtrOff = DAG.getNode(ISD::ADD, DL, getPointerTy(DAG.getDataLayout()),
                           StackPtr, PtrOff);
      /// store val -> reg + offset
      Chain = DAG.getStore(Chain, DL, OutVals[i], PtrOff,
                           MachinePointerInfo::getStack(MF, LocMemOffset));
    }
  }

  /// 处理第三步
  if (GlobalAddressSDNode *N = dyn_cast<GlobalAddressSDNode>(Callee)) {
    MVT Ty = getPointerTy(DAG.getDataLayout());
    SDValue Hi =
        DAG.getTargetGlobalAddress(N->getGlobal(), DL, Ty, 0, OneMCExpr::HI);
    SDValue Lo =
        DAG.getTargetGlobalAddress(N->getGlobal(), DL, Ty, 0, OneMCExpr::LO);

    SDValue MHiNode = SDValue(DAG.getMachineNode(One::LUI, DL, Ty, Hi), 0);
    Callee = SDValue(DAG.getMachineNode(One::ADDI, DL, Ty, MHiNode, Lo), 0);
  } else if (ExternalSymbolSDNode *S = dyn_cast<ExternalSymbolSDNode>(Callee)) {
    MVT Ty = getPointerTy(DAG.getDataLayout());
    SDValue Hi = DAG.getTargetExternalSymbol(S->getSymbol(), Ty, OneMCExpr::HI);
    SDValue Lo = DAG.getTargetExternalSymbol(S->getSymbol(), Ty, OneMCExpr::LO);

    SDValue MHiNode = SDValue(DAG.getMachineNode(One::LUI, DL, Ty, Hi), 0);
    Callee = SDValue(DAG.getMachineNode(One::ADDI, DL, Ty, MHiNode, Lo), 0);
  }
  SmallVector<SDValue, 8> Ops(1, Chain);
  Ops.push_back(Callee);

  SDValue Glue;
  for (int i = 0, e = RegsPairs.size(); i != e; ++i) {
    auto &[reg, val] = RegsPairs[i];
    Chain = DAG.getCopyToReg(Chain, DL, reg, val, Glue);
    Glue = Chain.getValue(1);
    Ops.push_back(DAG.getRegister(reg, val.getValueType()));
  }

  const TargetRegisterInfo *TRI = Subtarget.getRegisterInfo();
  const uint32_t *Mask =
      TRI->getCallPreservedMask(DAG.getMachineFunction(), CallConv);
  Ops.push_back(DAG.getRegisterMask(Mask));
  if (Glue.getNode()) {
    Ops.push_back(Glue);
  }

  SDVTList NodeTys = DAG.getVTList(MVT::Other, MVT::Glue);
  Chain = DAG.getNode(OneISD::Call, DL, NodeTys, Ops);

  {
    /// 处理第四步
    SDValue Glue = Chain.getValue(1);
    SmallVector<CCValAssign, 2> RVLos;
    CCState CCInfo(CallConv, IsVarArg, DAG.getMachineFunction(), RVLos,
                   *DAG.getContext());
    CCInfo.AnalyzeCallResult(Ins, RetCC_One);

    for (unsigned i = 0, e = RVLos.size(); i != e; ++i) {
      CCValAssign &VA = RVLos[i];
      EVT vt = RVLos[i].getLocVT();
      assert(VA.isRegLoc());
      unsigned RVReg = VA.getLocReg();
      SDValue Val = DAG.getCopyFromReg(Chain, DL, RVReg, vt, Glue);
      Chain = Val.getValue(1);
      Glue = Val.getValue(2);
      InVals.push_back(Val);
    }
  }

  return Chain;
}

SDValue OneTargetLowering::LowerFormalArguments(
    SDValue Chain, CallingConv::ID CallConv, bool IsVarArg,
    const SmallVectorImpl<ISD::InputArg> &Ins, const SDLoc &DL,
    SelectionDAG &DAG, SmallVectorImpl<SDValue> &InVals) const {

  /// 1. 分析ins的存储
  /// 2. 产生节点
  ///
  /// ir type, MVT, EVT
  /// ir type: i1 ~i128, f32, f64, struct, array
  /// MVT : machine value type, 寄存器的类型，架构所具体支持的类型，一般都是整型
  /// i8~i32 EVT : 扩展的value type，包含了架构所不支持的类型，比如 i3, i99

  MachineFunction &MF = DAG.getMachineFunction();
  MachineFrameInfo &MFI = MF.getFrameInfo();

  SmallVector<CCValAssign, 16> ArgLocs;
  CCState CCInfo(CallConv, IsVarArg, MF, ArgLocs, *DAG.getContext());
  CCInfo.AnalyzeFormalArguments(Ins, CC_One);

  SDValue ArgValue;
  for (unsigned i = 0, e = ArgLocs.size(); i != e; ++i) {
    CCValAssign &VA = ArgLocs[i];
    if (VA.isRegLoc()) {
      MVT RegVT = VA.getLocVT();
      Register Reg = MF.addLiveIn(VA.getLocReg(), &One::GPRRegClass);
      ArgValue = DAG.getCopyFromReg(Chain, DL, Reg, RegVT);
      InVals.push_back(ArgValue);
    } else {
      assert(VA.isMemLoc());
      MVT ValVT = VA.getValVT();
      int Offset = VA.getLocMemOffset();
      int FI = MFI.CreateFixedObject(ValVT.getSizeInBits() / 8, Offset, true);
      SDValue FIN = DAG.getFrameIndex(FI, getPointerTy(DAG.getDataLayout()));
      SDValue Val = DAG.getLoad(
          ValVT, DL, Chain, FIN,
          MachinePointerInfo::getFixedStack(DAG.getMachineFunction(), FI));
      InVals.push_back(Val);
    }
  }

  return Chain;
}

SDValue
OneTargetLowering::LowerReturn(SDValue Chain, CallingConv::ID CallConv,
                               bool IsVarArg,
                               const SmallVectorImpl<ISD::OutputArg> &Outs,
                               const SmallVectorImpl<SDValue> &OutVals,
                               const SDLoc &DL, SelectionDAG &DAG) const {
  /// 1. 返回物理寄存器（调用约定的限值）
  SmallVector<CCValAssign, 16> RVLocs;

  CCState CCInfo(CallConv, IsVarArg, DAG.getMachineFunction(), RVLocs,
                 *DAG.getContext());
  CCInfo.AnalyzeReturn(Outs, RetCC_One);

  SDValue Glue;
  SmallVector<SDValue, 4> RetOps(1, Chain);

  for (unsigned i = 0, e = RVLocs.size(); i < e; ++i) {
    CCValAssign &VA = RVLocs[i];
    assert(VA.isRegLoc() && "Can only return in registers!");

    Chain = DAG.getCopyToReg(Chain, DL, VA.getLocReg(), OutVals[i], Glue);
    Glue = Chain.getValue(1);
    RetOps.push_back(DAG.getRegister(VA.getLocReg(), VA.getLocVT()));
  }

  RetOps[0] = Chain;

  if (Glue.getNode()) {
    RetOps.push_back(Glue);
  }

  return DAG.getNode(OneISD::RET_GLUE, DL, MVT::Other, RetOps);
}

SDValue OneTargetLowering::LowerOperation(SDValue Op, SelectionDAG &DAG) const {
  switch (Op.getOpcode()) {
  case ISD::GlobalAddress:
    return LowerGlobalAddress(Op, DAG);
  case ISD::Constant:
    return LowerConstant(Op, DAG);
  default:
    llvm::llvm_unreachable_internal("unknown op");
  }
  return SDValue();
}

/// GlobalAddress -> HI / LO
SDValue OneTargetLowering::LowerGlobalAddress(SDValue Op,
                                              SelectionDAG &DAG) const {
  EVT VT = Op.getValueType();
  GlobalAddressSDNode *N = dyn_cast<GlobalAddressSDNode>(Op);
  int64_t Offset = N->getOffset();
  SDLoc DL(N);
  SDValue Hi =
      DAG.getTargetGlobalAddress(N->getGlobal(), DL, VT, 0, OneMCExpr::HI);
  SDValue Lo =
      DAG.getTargetGlobalAddress(N->getGlobal(), DL, VT, 0, OneMCExpr::LO);

  SDValue MHiNode = SDValue(DAG.getMachineNode(One::LUI, DL, VT, Hi), 0);
  SDValue BaseAddr =
      SDValue(DAG.getMachineNode(One::ADDI, DL, VT, MHiNode, Lo), 0);
  if (Offset) {
    return DAG.getNode(ISD::ADD, DL, VT, BaseAddr,
                       DAG.getConstant(Offset, DL, VT));
  }
  return BaseAddr;
}
/// ADDI rd, rs1, imm12
#define RISCV_IMM_BITS 12
#define RISCV_IMM_REACH (1LL << RISCV_IMM_BITS)
#define RISCV_CONST_HIGH_PART(VALUE)                                           \
  (((VALUE) + (RISCV_IMM_REACH / 2)) & ~(RISCV_IMM_REACH - 1))
#define RISCV_CONST_LOW_PART(VALUE) ((VALUE)-RISCV_CONST_HIGH_PART(VALUE))

SDValue OneTargetLowering::LowerConstant(SDValue Op, SelectionDAG &DAG) const {
  SDLoc DL(Op);
  EVT VT = Op.getValueType();

  int32_t Imm = dyn_cast<ConstantSDNode>(Op)->getSExtValue();

  if (isInt<12>(Imm)) {
    SDValue SDImm = DAG.getTargetConstant(Imm, DL, VT);
    return SDValue(DAG.getMachineNode(One::ADDI, DL, VT,
                                      DAG.getRegister(One::ZERO, VT), SDImm),
                   0);
  } else {
    uint32_t Hi = RISCV_CONST_HIGH_PART(Imm);
    uint32_t Lo = RISCV_CONST_LOW_PART(Imm);
    SDValue ImmHI = DAG.getTargetConstant(Hi >> 12, DL, VT);
    SDValue ImmLo = DAG.getTargetConstant(Lo, DL, VT);
    SDValue MImmHi = SDValue(DAG.getMachineNode(One::LUI, DL, VT, ImmHI), 0);
    return SDValue(DAG.getMachineNode(One::ADDI, DL, VT, MImmHi, ImmLo), 0);
  }
}

const char *OneTargetLowering::getTargetNodeName(unsigned Opcode) const {
  switch (Opcode) {
  case OneISD::RET_GLUE:
    return "OneISD::RET_GLUE";
  case OneISD::Call:
    return "OneISD::Call";
  case OneISD::HI:
    return "OneISD::HI";
  case OneISD::LO:
    return "OneISD::LO";
  default:
      return nullptr;
  }
}