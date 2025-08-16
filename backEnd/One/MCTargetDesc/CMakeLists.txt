add_llvm_component_library(LLVMOneDesc
        OneMCTargetDesc.cpp
        OneMCAsmInfo.cpp
        OneInstPrinter.cpp
        OneMCExpr.cpp

        LINK_COMPONENTS
        MC
        OneInfo
        Support
        TargetParser

        ADD_TO_COMPONENT
        One
)