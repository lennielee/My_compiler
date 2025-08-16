add_llvm_component_group(One)

set(LLVM_TARGET_DEFINITIONS One.td)

tablegen(LLVM OneGenAsmWriter.inc -gen-asm-writer)
tablegen(LLVM OneGenDAGISel.inc  -gen-dag-isel)
tablegen(LLVM OneGenCallingConv.inc -gen-callingconv)
tablegen(LLVM OneGenInstrInfo.inc -gen-instr-info)
tablegen(LLVM OneGenRegisterInfo.inc -gen-register-info)
tablegen(LLVM OneGenSubtargetInfo.inc -gen-subtarget)
tablegen(LLVM OneGenMCPseudoLowering.inc -gen-pseudo-lowering)

add_public_tablegen_target(OneCommonTableGen)

add_llvm_target(OneCodeGen
        OneTargetMachine.cpp
        OneInstrInfo.cpp
        OneRegisterInfo.cpp
        OneSubtarget.cpp
        OneFrameLowering.cpp
        OneISelLowering.cpp
        OneISelDAGToDAG.cpp
        OneAsmPrinter.cpp
        OneCallingConv.cpp

        LINK_COMPONENTS
        AsmPrinter
        CodeGen
        CodeGenTypes
        Core
        MC
        SelectionDAG
        OneDesc
        OneInfo
        Support
        Target
        TargetParser

        ADD_TO_COMPONENT
        One
)

add_subdirectory(MCTargetDesc)
add_subdirectory(TargetInfo)