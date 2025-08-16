; ModuleID = 'e16.c'
source_filename = "e16.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [11 x i8] c"\E5\BE\88\E6\A3\92\EF\BC\81\0A\00", align 1
@.str.1 = private unnamed_addr constant [11 x i8] c"\E5\81\9A\E5\BE\97\E5\A5\BD\0A\00", align 1
@.str.2 = private unnamed_addr constant [14 x i8] c"\E6\82\A8\E9\80\9A\E8\BF\87\E4\BA\86\0A\00", align 1
@.str.3 = private unnamed_addr constant [20 x i8] c"\E6\9C\80\E5\A5\BD\E5\86\8D\E8\AF\95\E4\B8\80\E4\B8\8B\0A\00", align 1
@.str.4 = private unnamed_addr constant [17 x i8] c"\E6\97\A0\E6\95\88\E7\9A\84\E6\88\90\E7\BB\A9\0A\00", align 1
@.str.5 = private unnamed_addr constant [20 x i8] c"\E6\82\A8\E7\9A\84\E6\88\90\E7\BB\A9\E6\98\AF %c\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i8, align 1
  store i32 0, i32* %1, align 4
  store i8 66, i8* %2, align 1
  %3 = load i8, i8* %2, align 1
  %4 = sext i8 %3 to i32
  switch i32 %4, label %13 [
    i32 65, label %5
    i32 66, label %7
    i32 67, label %7
    i32 68, label %9
    i32 70, label %11
  ]

5:                                                ; preds = %0
  %6 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str, i64 0, i64 0))
  br label %15

7:                                                ; preds = %0, %0
  %8 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.1, i64 0, i64 0))
  br label %15

9:                                                ; preds = %0
  %10 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([14 x i8], [14 x i8]* @.str.2, i64 0, i64 0))
  br label %15

11:                                               ; preds = %0
  %12 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str.3, i64 0, i64 0))
  br label %15

13:                                               ; preds = %0
  %14 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.4, i64 0, i64 0))
  br label %15

15:                                               ; preds = %13, %11, %9, %7, %5
  %16 = load i8, i8* %2, align 1
  %17 = sext i8 %16 to i32
  %18 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([20 x i8], [20 x i8]* @.str.5, i64 0, i64 0), i32 noundef %17)
  ret i32 0
}

declare i32 @printf(i8* noundef, ...) #1

attributes #0 = { noinline nounwind optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
