include "llvm/Target/Target.td"

include "OneRegisterInfo.td"
include "OneInstrInfo.td"
include "OneCallingConv.td"

def : ProcessorModel<"one", NoSchedModel, []>;

def OneInstrInfo : InstrInfo;

def One : Target {
    let InstructionSet = OneInstrInfo;
}