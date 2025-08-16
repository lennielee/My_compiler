include "OneInstrFormats.td"

def retglue : SDNode<"OneISD::RET_GLUE", SDTNone, [SDNPHasChain, SDNPOptInGlue, SDNPVariadic]>;

//class ImmLeaf<ValueType vt, code pred, SDNodeXForm xform = NOOP_SDNodeXForm,
//              SDNode ImmNode = imm>
//  : PatFrag<(ops), (vt ImmNode), [{}], xform>

// class PatLeaf<dag frag, code pred = [{}], SDNodeXForm xform = NOOP_SDNodeXForm>
// : PatFrag<(ops), frag, pred, xform>;

def imm12 : Operand<i32>, ImmLeaf<i32, [{ return isInt<12>(Imm);}]>;
def imm20 : Operand<i32>, ImmLeaf<i32, [{ return isInt<20>(Imm);}]>;
// def imm12Pat : ImmLeaf<i32, [{ return isInt<12>(Imm);}]>;
// def imm12Pat : PatLeaf<(imm), [{ return isInt<12>(N->getSExtValue());}]>


// load store
// 操作的是地址 -> base + offset
// 对地址建模 -> 内存操作

// def mem : Operand<iPTR> {
//    /// 具体有哪些操作数
//    let MIOperandInfo = (ops GPR, imm12);
//    /// 指明自定义的打印函数 offset(GPR)这种形式
//    let PrintMethod = "printMemOperand";
// }

// def ptr : Operand<iPTR> {
//    /// 具体有哪些操作数
//    let MIOperandInfo = (ops GPR, imm12);
//    /// 指明自定义的打印函数 offset(GPR)这种形式
//    let PrintMethod = "printPtrOperand";
// }

// SDNPWantParent -> 传递引用frameIndex的节点
// frameindex -> 传递 FrameIndexSDNode
def addrFI : ComplexPattern<iPTR, 2, "SelectAddrFI", [frameindex], [SDNPWantParent]>;


// load 和 store
multiclass LOAD<PatFrag op, string asm> {
    def FI : I<(outs GPR: $rd), (ins GPR:$rs1, imm12:$imm12), !strconcat(asm, "\t$rd, $imm12($rs1)"), [(set GPR:$rd, (op (addrFI GPR:$rs1, imm12:$imm12)))]>;
    def R : I<(outs GPR: $rd), (ins GPR: $rs), !strconcat(asm, "\t$rd, 0($rs)"), [(set GPR:$rd, (op GPR:$rs))]>;
}
defm LOADW:LOAD<load, "lw">;

defm LOADH:LOAD<extloadi16, "lh">;
defm LOADSH:LOAD<sextloadi16, "lh">;
defm LOADZH:LOAD<zextloadi16, "lh">;

defm LOADB:LOAD<extloadi8, "lb">;
defm LOADSB:LOAD<sextloadi8, "lb">;
defm LOADZB:LOAD<zextloadi8, "lb">;

multiclass STORE<PatFrag op, string asm> {
    def FI : S<(outs), (ins GPR: $rd, GPR:$rs1, imm12:$imm12), !strconcat(asm, "\t$rd, $imm12($rs1)"), [(op GPR:$rd, (addrFI GPR:$rs1, imm12:$imm12))]>;
    def R : S<(outs), (ins GPR: $rd, GPR: $rs), !strconcat(asm, "\t$rd, 0($rs)"), [(op GPR:$rd, GPR:$rs)]>;
}

defm STOREW: STORE<store, "sw">;
defm STOREH: STORE<truncstorei16, "sh">;
defm STOREB: STORE<truncstorei8, "sb">;

class ArithLogicI<string inst, SDNode node> : I<
    (outs GPR:$rd),
    (ins GPR:$rs1, imm12: $imm12),
    !strconcat(inst, "\t$rd, $rs1, $imm12"),
    [(set GPR:$rd, (node GPR:$rs1, imm12: $imm12))]
    >;

def ADDI : ArithLogicI<"addi", add>;
def ANDI : ArithLogicI<"andi", and>;
def ORI  : ArithLogicI<"ori", or>;
def XORI  : ArithLogicI<"xori", xor>;
def SLLI  : ArithLogicI<"slli", shl>;
def SRLI  : ArithLogicI<"srli", srl>;
def SRAI  : ArithLogicI<"srai", sra>;

//def ADDI : I<(outs GPR:$rd),
//                (ins GPR:$rs1, imm12: $imm12),
//                "addi $rd, $rs1, $imm12", [(set GPR:$rd, (add GPR: $rs1, imm12: $imm12))]>;


class ArithLogicR<string inst, SDNode node> : R<
    (outs GPR:$rd),
    (ins GPR:$rs1, GPR:$rs2),
    !strconcat(inst, "\t$rd, $rs1, $rs2"),
    [(set GPR:$rd, (node GPR:$rs1, GPR:$rs2))]
    >;
def ADD : ArithLogicR<"add", add>;
def SUB : ArithLogicR<"sub", sub>;
def MUL : ArithLogicR<"mul", mul>;
def DIV : ArithLogicR<"div", sdiv>;
def REM : ArithLogicR<"rem", srem>;
def AND : ArithLogicR<"and", and>;
def OR : ArithLogicR<"or", or>;
def XOR : ArithLogicR<"xor", xor>;
def SLL : ArithLogicR<"sll", shl>;
def SRL : ArithLogicR<"srl", srl>;
def SRA : ArithLogicR<"sra", sra>;

//def ADD : I<(outs GPR:$rd),
//                (ins GPR:$rs1, GPR: $rs2),
//                "add $rd, $rs1, $rs2", [(set GPR:$rd, (add GPR: $rs1, GPR: $rs2))]>;

def : Pat<(i32 (imm12:$imm12)), (ADDI ZERO, imm12:$imm12)>;


let isCall = 1 in {
  def JALR : I<(outs GPR:$rd),
              (ins GPR:$rs1, imm12:$imm12),
              "jalr $rd, $rs1, $imm12",
              []>;
}

let isBarrier = 1, isReturn = 1, isTerminator = 1 in {
  def PseudoRET : PseudoInst<
              (outs),
              (ins),
              [(retglue)]>,
              PseudoInstExpansion<(JALR ZERO, RA, 0)>;
}

/// 1. Call 的 SDNode定义
/// 2. SDNode pattern Instruction(Call的instruction)

def OneSDT_Call : SDTypeProfile<0, -1, [SDTCisVT<0, iPTR>]>;
def one_call  : SDNode<"OneISD::Call", OneSDT_Call,
                            [SDNPHasChain, SDNPOutGlue,
                             SDNPOptInGlue, SDNPVariadic]>;

// def tglobaladdr : SDNode<"ISD::TargetGlobalAddress",  SDTPtrLeaf, [],
//                            "GlobalAddressSDNode">;

// def call_symbol : Operand<iPTR>;

def CALL : PseudoInst<(outs), (ins GPR:$rs1), [(one_call GPR:$rs1)]>, PseudoInstExpansion<(JALR RA, GPR:$rs1, 0)> {
    let isCall = 1;
}

// def HI: SDNode<"OneISD::HI", SDTIntUnaryOp>;
// def LO: SDNode<"OneISD::LO", SDTIntUnaryOp>;

def LUI : U<(outs GPR:$rd), (ins imm20: $imm), "lui \t$rd, $imm", []>;

// def : Pat<(HI tglobaladdr: $in), (LUI tglobaladdr:$in)>;
// def : Pat<(add GPR: $hi, (LO tglobaladdr: $lo)), (ADDI GPR:$hi, tglobaladdr:$lo)>;

def : InstAlias<"ret", (JALR ZERO, RA, 0)>;
def : InstAlias<"li $rd, $imm",  (ADDI GPR:$rd, ZERO, imm12:$imm)>;

def SLT : R<(outs GPR:$rd), (ins GPR:$rs1, GPR:$rs2), "slt \t$rd, $rs1, $rs2", []>;

def : Pat<(setgt GPR:$rs1, GPR:$rs2), (SLT GPR:$rs2, GPR:$rs1)>;
def : Pat<(setlt GPR:$rs1, GPR:$rs2), (SLT GPR:$rs1, GPR:$rs2)>;
def : Pat<(seteq GPR:$rs1, GPR:$rs2), (SLT (XOR GPR:$rs1, GPR:$rs2), 1)>;
def : Pat<(setne GPR:$rs1, GPR:$rs2), (SLT ZERO, (XOR GPR:$rs1, GPR:$rs2))>;
def : Pat<(setge GPR:$rs1, GPR:$rs2), (XORI (SLT GPR:$rs1, GPR:$rs2), 1)>;
def : Pat<(setle GPR:$rs1, GPR:$rs2), (XORI (SLT GPR:$rs2, GPR:$rs1), 1)>;

def brtarget : Operand<OtherVT>;

let isTerminator = 1 in {
    def J : J<(outs), (ins brtarget:$imm12), "j ${imm12}", []>;
    def BLT : B<(outs), (ins GPR:$rs1, GPR:$rs2, brtarget: $imm), "blt \t$rs1, $rs2, $imm", []>;
    def BEQ : B<(outs), (ins GPR:$rs1, GPR:$rs2, brtarget: $imm), "beq \t$rs1, $rs2, $imm", []>;
    def BNE : B<(outs), (ins GPR:$rs1, GPR:$rs2, brtarget: $imm), "bne \t$rs1, $rs2, $imm", []>;
    def BGE : B<(outs), (ins GPR:$rs1, GPR:$rs2, brtarget: $imm), "bge \t$rs1, $rs2, $imm", []>;
}

def : Pat<(brcond (i32 (setlt GPR:$rs1, GPR:$rs2)), bb:$dst), (BLT GPR:$rs1, GPR:$rs2, brtarget:$dst)>;
def : Pat<(brcond (i32 (setgt GPR:$rs1, GPR:$rs2)), bb:$dst), (BLT GPR:$rs2, GPR:$rs1, brtarget:$dst)>;
def : Pat<(brcond (i32 (seteq GPR:$rs1, GPR:$rs2)), bb:$dst), (BEQ GPR:$rs1, GPR:$rs2, brtarget:$dst)>;
def : Pat<(brcond (i32 (setne GPR:$rs1, GPR:$rs2)), bb:$dst), (BNE GPR:$rs1, GPR:$rs2, brtarget:$dst)>;
def : Pat<(brcond (i32 (setge GPR:$rs1, GPR:$rs2)), bb:$dst), (BGE GPR:$rs1, GPR:$rs2, brtarget:$dst)>;
def : Pat<(brcond (i32 (setle GPR:$rs1, GPR:$rs2)), bb:$dst), (BGE GPR:$rs2, GPR:$rs1, brtarget:$dst)>;
def : Pat<(br bb:$dst), (J brtarget:$dst)>;

// def : I<(outs GPR:$rd), (ins ptr:$p), "addi \t$rd, $p", [(set GPR:$rd, addrFI:$p)]>;

def : Pat<(addrFI GPR:$rs1, imm12:$imm12), (ADDI GPR:$rs1, imm12:$imm12)>;