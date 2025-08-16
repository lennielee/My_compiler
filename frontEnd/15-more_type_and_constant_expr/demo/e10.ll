; ModuleID = 'e10.c'
source_filename = "e10.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@sort_arr = dso_local global [5 x i32] zeroinitializer, align 16, !dbg !0
@__const.main.a = private unnamed_addr constant [2 x i32] [i32 1, i32 5], align 4
@__const.main.b = private unnamed_addr constant [3 x i32] [i32 1, i32 4, i32 14], align 4

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @combine(i32* noundef %0, i32 noundef %1, i32* noundef %2, i32 noundef %3) #0 !dbg !17 {
  %5 = alloca i32*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32*, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  store i32* %0, i32** %5, align 8
  call void @llvm.dbg.declare(metadata i32** %5, metadata !22, metadata !DIExpression()), !dbg !23
  store i32 %1, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !24, metadata !DIExpression()), !dbg !25
  store i32* %2, i32** %7, align 8
  call void @llvm.dbg.declare(metadata i32** %7, metadata !26, metadata !DIExpression()), !dbg !27
  store i32 %3, i32* %8, align 4
  call void @llvm.dbg.declare(metadata i32* %8, metadata !28, metadata !DIExpression()), !dbg !29
  call void @llvm.dbg.declare(metadata i32* %9, metadata !30, metadata !DIExpression()), !dbg !31
  store i32 0, i32* %9, align 4, !dbg !31
  call void @llvm.dbg.declare(metadata i32* %10, metadata !32, metadata !DIExpression()), !dbg !33
  store i32 0, i32* %10, align 4, !dbg !33
  call void @llvm.dbg.declare(metadata i32* %11, metadata !34, metadata !DIExpression()), !dbg !35
  store i32 0, i32* %11, align 4, !dbg !35
  br label %12, !dbg !36

12:                                               ; preds = %56, %4
  %13 = load i32, i32* %9, align 4, !dbg !37
  %14 = load i32, i32* %6, align 4, !dbg !40
  %15 = icmp slt i32 %13, %14, !dbg !41
  br i1 %15, label %16, label %20, !dbg !42

16:                                               ; preds = %12
  %17 = load i32, i32* %10, align 4, !dbg !43
  %18 = load i32, i32* %8, align 4, !dbg !44
  %19 = icmp slt i32 %17, %18, !dbg !45
  br label %20

20:                                               ; preds = %16, %12
  %21 = phi i1 [ false, %12 ], [ %19, %16 ], !dbg !46
  br i1 %21, label %22, label %59, !dbg !47

22:                                               ; preds = %20
  %23 = load i32*, i32** %5, align 8, !dbg !48
  %24 = load i32, i32* %9, align 4, !dbg !51
  %25 = sext i32 %24 to i64, !dbg !48
  %26 = getelementptr inbounds i32, i32* %23, i64 %25, !dbg !48
  %27 = load i32, i32* %26, align 4, !dbg !48
  %28 = load i32*, i32** %7, align 8, !dbg !52
  %29 = load i32, i32* %10, align 4, !dbg !53
  %30 = sext i32 %29 to i64, !dbg !52
  %31 = getelementptr inbounds i32, i32* %28, i64 %30, !dbg !52
  %32 = load i32, i32* %31, align 4, !dbg !52
  %33 = icmp slt i32 %27, %32, !dbg !54
  br i1 %33, label %34, label %45, !dbg !55

34:                                               ; preds = %22
  %35 = load i32*, i32** %5, align 8, !dbg !56
  %36 = load i32, i32* %9, align 4, !dbg !58
  %37 = sext i32 %36 to i64, !dbg !56
  %38 = getelementptr inbounds i32, i32* %35, i64 %37, !dbg !56
  %39 = load i32, i32* %38, align 4, !dbg !56
  %40 = load i32, i32* %11, align 4, !dbg !59
  %41 = sext i32 %40 to i64, !dbg !60
  %42 = getelementptr inbounds [5 x i32], [5 x i32]* @sort_arr, i64 0, i64 %41, !dbg !60
  store i32 %39, i32* %42, align 4, !dbg !61
  %43 = load i32, i32* %9, align 4, !dbg !62
  %44 = add nsw i32 %43, 1, !dbg !63
  store i32 %44, i32* %9, align 4, !dbg !64
  br label %56, !dbg !65

45:                                               ; preds = %22
  %46 = load i32*, i32** %7, align 8, !dbg !66
  %47 = load i32, i32* %10, align 4, !dbg !68
  %48 = sext i32 %47 to i64, !dbg !66
  %49 = getelementptr inbounds i32, i32* %46, i64 %48, !dbg !66
  %50 = load i32, i32* %49, align 4, !dbg !66
  %51 = load i32, i32* %11, align 4, !dbg !69
  %52 = sext i32 %51 to i64, !dbg !70
  %53 = getelementptr inbounds [5 x i32], [5 x i32]* @sort_arr, i64 0, i64 %52, !dbg !70
  store i32 %50, i32* %53, align 4, !dbg !71
  %54 = load i32, i32* %10, align 4, !dbg !72
  %55 = add nsw i32 %54, 1, !dbg !73
  store i32 %55, i32* %10, align 4, !dbg !74
  br label %56

56:                                               ; preds = %45, %34
  %57 = load i32, i32* %11, align 4, !dbg !75
  %58 = add nsw i32 %57, 1, !dbg !76
  store i32 %58, i32* %11, align 4, !dbg !77
  br label %12, !dbg !78, !llvm.loop !79

59:                                               ; preds = %20
  %60 = load i32, i32* %9, align 4, !dbg !82
  %61 = load i32, i32* %6, align 4, !dbg !84
  %62 = icmp eq i32 %60, %61, !dbg !85
  br i1 %62, label %63, label %82, !dbg !86

63:                                               ; preds = %59
  br label %64, !dbg !87

64:                                               ; preds = %68, %63
  %65 = load i32, i32* %10, align 4, !dbg !89
  %66 = load i32, i32* %8, align 4, !dbg !92
  %67 = icmp slt i32 %65, %66, !dbg !93
  br i1 %67, label %68, label %81, !dbg !94

68:                                               ; preds = %64
  %69 = load i32*, i32** %7, align 8, !dbg !95
  %70 = load i32, i32* %10, align 4, !dbg !97
  %71 = sext i32 %70 to i64, !dbg !95
  %72 = getelementptr inbounds i32, i32* %69, i64 %71, !dbg !95
  %73 = load i32, i32* %72, align 4, !dbg !95
  %74 = load i32, i32* %11, align 4, !dbg !98
  %75 = sext i32 %74 to i64, !dbg !99
  %76 = getelementptr inbounds [5 x i32], [5 x i32]* @sort_arr, i64 0, i64 %75, !dbg !99
  store i32 %73, i32* %76, align 4, !dbg !100
  %77 = load i32, i32* %11, align 4, !dbg !101
  %78 = add nsw i32 %77, 1, !dbg !102
  store i32 %78, i32* %11, align 4, !dbg !103
  %79 = load i32, i32* %10, align 4, !dbg !104
  %80 = add nsw i32 %79, 1, !dbg !105
  store i32 %80, i32* %10, align 4, !dbg !106
  br label %64, !dbg !107, !llvm.loop !108

81:                                               ; preds = %64
  br label %101, !dbg !110

82:                                               ; preds = %59
  br label %83, !dbg !111

83:                                               ; preds = %87, %82
  %84 = load i32, i32* %9, align 4, !dbg !113
  %85 = load i32, i32* %6, align 4, !dbg !116
  %86 = icmp slt i32 %84, %85, !dbg !117
  br i1 %86, label %87, label %100, !dbg !118

87:                                               ; preds = %83
  %88 = load i32*, i32** %7, align 8, !dbg !119
  %89 = load i32, i32* %9, align 4, !dbg !121
  %90 = sext i32 %89 to i64, !dbg !119
  %91 = getelementptr inbounds i32, i32* %88, i64 %90, !dbg !119
  %92 = load i32, i32* %91, align 4, !dbg !119
  %93 = load i32, i32* %11, align 4, !dbg !122
  %94 = sext i32 %93 to i64, !dbg !123
  %95 = getelementptr inbounds [5 x i32], [5 x i32]* @sort_arr, i64 0, i64 %94, !dbg !123
  store i32 %92, i32* %95, align 4, !dbg !124
  %96 = load i32, i32* %11, align 4, !dbg !125
  %97 = add nsw i32 %96, 1, !dbg !126
  store i32 %97, i32* %11, align 4, !dbg !127
  %98 = load i32, i32* %9, align 4, !dbg !128
  %99 = add nsw i32 %98, 1, !dbg !129
  store i32 %99, i32* %9, align 4, !dbg !130
  br label %83, !dbg !131, !llvm.loop !132

100:                                              ; preds = %83
  br label %101

101:                                              ; preds = %100, %81
  %102 = load i32, i32* %6, align 4, !dbg !134
  %103 = load i32, i32* %8, align 4, !dbg !135
  %104 = add nsw i32 %102, %103, !dbg !136
  %105 = sub nsw i32 %104, 1, !dbg !137
  %106 = sext i32 %105 to i64, !dbg !138
  %107 = getelementptr inbounds [5 x i32], [5 x i32]* @sort_arr, i64 0, i64 %106, !dbg !138
  %108 = load i32, i32* %107, align 4, !dbg !138
  ret i32 %108, !dbg !139
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !140 {
  %1 = alloca i32, align 4
  %2 = alloca [2 x i32], align 4
  %3 = alloca [3 x i32], align 4
  store i32 0, i32* %1, align 4
  call void @llvm.dbg.declare(metadata [2 x i32]* %2, metadata !143, metadata !DIExpression()), !dbg !147
  %4 = bitcast [2 x i32]* %2 to i8*, !dbg !147
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %4, i8* align 4 bitcast ([2 x i32]* @__const.main.a to i8*), i64 8, i1 false), !dbg !147
  call void @llvm.dbg.declare(metadata [3 x i32]* %3, metadata !148, metadata !DIExpression()), !dbg !152
  %5 = bitcast [3 x i32]* %3 to i8*, !dbg !152
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %5, i8* align 4 bitcast ([3 x i32]* @__const.main.b to i8*), i64 12, i1 false), !dbg !152
  %6 = getelementptr inbounds [2 x i32], [2 x i32]* %2, i64 0, i64 0, !dbg !153
  %7 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i64 0, i64 0, !dbg !154
  %8 = call i32 @combine(i32* noundef %6, i32 noundef 2, i32* noundef %7, i32 noundef 3), !dbg !155
  ret i32 %8, !dbg !156
}

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly nofree nounwind willreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!9, !10, !11, !12, !13, !14, !15}
!llvm.ident = !{!16}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "sort_arr", scope: !2, file: !3, line: 1, type: !5, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "Ubuntu clang version 14.0.0-1ubuntu1.1", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "e10.c", directory: "/home/ubuntu/08-backup/demo", checksumkind: CSK_MD5, checksum: "7fc7fdbb1d1ae9a8c6842460a0e613ad")
!4 = !{!0}
!5 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 160, elements: !7)
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !{!8}
!8 = !DISubrange(count: 5)
!9 = !{i32 7, !"Dwarf Version", i32 5}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{i32 1, !"wchar_size", i32 4}
!12 = !{i32 7, !"PIC Level", i32 2}
!13 = !{i32 7, !"PIE Level", i32 2}
!14 = !{i32 7, !"uwtable", i32 1}
!15 = !{i32 7, !"frame-pointer", i32 2}
!16 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!17 = distinct !DISubprogram(name: "combine", scope: !3, file: !3, line: 2, type: !18, scopeLine: 2, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !21)
!18 = !DISubroutineType(types: !19)
!19 = !{!6, !20, !6, !20, !6}
!20 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!21 = !{}
!22 = !DILocalVariable(name: "arr1", arg: 1, scope: !17, file: !3, line: 2, type: !20)
!23 = !DILocation(line: 2, column: 17, scope: !17)
!24 = !DILocalVariable(name: "arr1_length", arg: 2, scope: !17, file: !3, line: 2, type: !6)
!25 = !DILocation(line: 2, column: 29, scope: !17)
!26 = !DILocalVariable(name: "arr2", arg: 3, scope: !17, file: !3, line: 2, type: !20)
!27 = !DILocation(line: 2, column: 46, scope: !17)
!28 = !DILocalVariable(name: "arr2_length", arg: 4, scope: !17, file: !3, line: 2, type: !6)
!29 = !DILocation(line: 2, column: 58, scope: !17)
!30 = !DILocalVariable(name: "i", scope: !17, file: !3, line: 3, type: !6)
!31 = !DILocation(line: 3, column: 9, scope: !17)
!32 = !DILocalVariable(name: "j", scope: !17, file: !3, line: 4, type: !6)
!33 = !DILocation(line: 4, column: 9, scope: !17)
!34 = !DILocalVariable(name: "k", scope: !17, file: !3, line: 5, type: !6)
!35 = !DILocation(line: 5, column: 9, scope: !17)
!36 = !DILocation(line: 6, column: 5, scope: !17)
!37 = !DILocation(line: 6, column: 11, scope: !38)
!38 = distinct !DILexicalBlock(scope: !39, file: !3, line: 6, column: 5)
!39 = distinct !DILexicalBlock(scope: !17, file: !3, line: 6, column: 5)
!40 = !DILocation(line: 6, column: 15, scope: !38)
!41 = !DILocation(line: 6, column: 13, scope: !38)
!42 = !DILocation(line: 6, column: 27, scope: !38)
!43 = !DILocation(line: 6, column: 30, scope: !38)
!44 = !DILocation(line: 6, column: 34, scope: !38)
!45 = !DILocation(line: 6, column: 32, scope: !38)
!46 = !DILocation(line: 0, scope: !38)
!47 = !DILocation(line: 6, column: 5, scope: !39)
!48 = !DILocation(line: 7, column: 13, scope: !49)
!49 = distinct !DILexicalBlock(scope: !50, file: !3, line: 7, column: 13)
!50 = distinct !DILexicalBlock(scope: !38, file: !3, line: 6, column: 48)
!51 = !DILocation(line: 7, column: 18, scope: !49)
!52 = !DILocation(line: 7, column: 23, scope: !49)
!53 = !DILocation(line: 7, column: 28, scope: !49)
!54 = !DILocation(line: 7, column: 21, scope: !49)
!55 = !DILocation(line: 7, column: 13, scope: !50)
!56 = !DILocation(line: 8, column: 27, scope: !57)
!57 = distinct !DILexicalBlock(scope: !49, file: !3, line: 7, column: 32)
!58 = !DILocation(line: 8, column: 32, scope: !57)
!59 = !DILocation(line: 8, column: 22, scope: !57)
!60 = !DILocation(line: 8, column: 13, scope: !57)
!61 = !DILocation(line: 8, column: 25, scope: !57)
!62 = !DILocation(line: 9, column: 17, scope: !57)
!63 = !DILocation(line: 9, column: 19, scope: !57)
!64 = !DILocation(line: 9, column: 15, scope: !57)
!65 = !DILocation(line: 10, column: 9, scope: !57)
!66 = !DILocation(line: 12, column: 27, scope: !67)
!67 = distinct !DILexicalBlock(scope: !49, file: !3, line: 11, column: 14)
!68 = !DILocation(line: 12, column: 32, scope: !67)
!69 = !DILocation(line: 12, column: 22, scope: !67)
!70 = !DILocation(line: 12, column: 13, scope: !67)
!71 = !DILocation(line: 12, column: 25, scope: !67)
!72 = !DILocation(line: 13, column: 17, scope: !67)
!73 = !DILocation(line: 13, column: 19, scope: !67)
!74 = !DILocation(line: 13, column: 15, scope: !67)
!75 = !DILocation(line: 15, column: 13, scope: !50)
!76 = !DILocation(line: 15, column: 15, scope: !50)
!77 = !DILocation(line: 15, column: 11, scope: !50)
!78 = !DILocation(line: 6, column: 5, scope: !38)
!79 = distinct !{!79, !47, !80, !81}
!80 = !DILocation(line: 16, column: 5, scope: !39)
!81 = !{!"llvm.loop.mustprogress"}
!82 = !DILocation(line: 17, column: 9, scope: !83)
!83 = distinct !DILexicalBlock(scope: !17, file: !3, line: 17, column: 9)
!84 = !DILocation(line: 17, column: 14, scope: !83)
!85 = !DILocation(line: 17, column: 11, scope: !83)
!86 = !DILocation(line: 17, column: 9, scope: !17)
!87 = !DILocation(line: 18, column: 9, scope: !88)
!88 = distinct !DILexicalBlock(scope: !83, file: !3, line: 17, column: 27)
!89 = !DILocation(line: 18, column: 15, scope: !90)
!90 = distinct !DILexicalBlock(scope: !91, file: !3, line: 18, column: 9)
!91 = distinct !DILexicalBlock(scope: !88, file: !3, line: 18, column: 9)
!92 = !DILocation(line: 18, column: 19, scope: !90)
!93 = !DILocation(line: 18, column: 17, scope: !90)
!94 = !DILocation(line: 18, column: 9, scope: !91)
!95 = !DILocation(line: 19, column: 27, scope: !96)
!96 = distinct !DILexicalBlock(scope: !90, file: !3, line: 18, column: 33)
!97 = !DILocation(line: 19, column: 32, scope: !96)
!98 = !DILocation(line: 19, column: 22, scope: !96)
!99 = !DILocation(line: 19, column: 13, scope: !96)
!100 = !DILocation(line: 19, column: 25, scope: !96)
!101 = !DILocation(line: 20, column: 17, scope: !96)
!102 = !DILocation(line: 20, column: 19, scope: !96)
!103 = !DILocation(line: 20, column: 15, scope: !96)
!104 = !DILocation(line: 21, column: 17, scope: !96)
!105 = !DILocation(line: 21, column: 19, scope: !96)
!106 = !DILocation(line: 21, column: 15, scope: !96)
!107 = !DILocation(line: 18, column: 9, scope: !90)
!108 = distinct !{!108, !94, !109, !81}
!109 = !DILocation(line: 22, column: 9, scope: !91)
!110 = !DILocation(line: 23, column: 5, scope: !88)
!111 = !DILocation(line: 25, column: 9, scope: !112)
!112 = distinct !DILexicalBlock(scope: !83, file: !3, line: 24, column: 10)
!113 = !DILocation(line: 25, column: 15, scope: !114)
!114 = distinct !DILexicalBlock(scope: !115, file: !3, line: 25, column: 9)
!115 = distinct !DILexicalBlock(scope: !112, file: !3, line: 25, column: 9)
!116 = !DILocation(line: 25, column: 19, scope: !114)
!117 = !DILocation(line: 25, column: 17, scope: !114)
!118 = !DILocation(line: 25, column: 9, scope: !115)
!119 = !DILocation(line: 26, column: 27, scope: !120)
!120 = distinct !DILexicalBlock(scope: !114, file: !3, line: 25, column: 33)
!121 = !DILocation(line: 26, column: 32, scope: !120)
!122 = !DILocation(line: 26, column: 22, scope: !120)
!123 = !DILocation(line: 26, column: 13, scope: !120)
!124 = !DILocation(line: 26, column: 25, scope: !120)
!125 = !DILocation(line: 27, column: 17, scope: !120)
!126 = !DILocation(line: 27, column: 19, scope: !120)
!127 = !DILocation(line: 27, column: 15, scope: !120)
!128 = !DILocation(line: 28, column: 17, scope: !120)
!129 = !DILocation(line: 28, column: 19, scope: !120)
!130 = !DILocation(line: 28, column: 15, scope: !120)
!131 = !DILocation(line: 25, column: 9, scope: !114)
!132 = distinct !{!132, !118, !133, !81}
!133 = !DILocation(line: 29, column: 9, scope: !115)
!134 = !DILocation(line: 31, column: 21, scope: !17)
!135 = !DILocation(line: 31, column: 35, scope: !17)
!136 = !DILocation(line: 31, column: 33, scope: !17)
!137 = !DILocation(line: 31, column: 47, scope: !17)
!138 = !DILocation(line: 31, column: 12, scope: !17)
!139 = !DILocation(line: 31, column: 5, scope: !17)
!140 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 34, type: !141, scopeLine: 34, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !21)
!141 = !DISubroutineType(types: !142)
!142 = !{!6}
!143 = !DILocalVariable(name: "a", scope: !140, file: !3, line: 35, type: !144)
!144 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 64, elements: !145)
!145 = !{!146}
!146 = !DISubrange(count: 2)
!147 = !DILocation(line: 35, column: 9, scope: !140)
!148 = !DILocalVariable(name: "b", scope: !140, file: !3, line: 36, type: !149)
!149 = !DICompositeType(tag: DW_TAG_array_type, baseType: !6, size: 96, elements: !150)
!150 = !{!151}
!151 = !DISubrange(count: 3)
!152 = !DILocation(line: 36, column: 9, scope: !140)
!153 = !DILocation(line: 37, column: 20, scope: !140)
!154 = !DILocation(line: 37, column: 26, scope: !140)
!155 = !DILocation(line: 37, column: 12, scope: !140)
!156 = !DILocation(line: 37, column: 5, scope: !140)
