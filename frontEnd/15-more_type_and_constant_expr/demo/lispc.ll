; ModuleID = 'demo/lisp.c'
source_filename = "demo/lisp.c"

@0 = private constant [3 x i8] c"%d\00"
@1 = private constant [3 x i8] c"%d\00"
@2 = private constant [3 x i8] c"%d\00"
@3 = private constant [4 x i8] c"%d:\00"
@4 = private constant [4 x i8] c" %d\00"
@ERR_INVALID_DATA_TYPE = global i32 0, align 4
@ERR_BUFFER_OVERFLOW = global i32 1, align 4
@ERR_PARSE_ERROR = global i32 2, align 4
@ERR_SYMBOL_NOT_FOUND = global i32 3, align 4
@ERR_INVALID_LIST = global i32 4, align 4
@ERR_INVALID_FUNC = global i32 5, align 4
@ERR_INVALID_ARG_NUM = global i32 6, align 4
@ERR_TYPE_MISMATCH = global i32 7, align 4
@ERR_INVALID_SYMBOL = global i32 8, align 4
@DATA_TYPE = global i32 0, align 4
@DATA_VALUE = global i32 1, align 4
@DATA_NEXT = global i32 2, align 4
@DATA_REF_COUNT = global i32 3, align 4
@DATA_FIELD_COUNT = global i32 4, align 4
@MAX_DATA_LEN = global i32 2048, align 4
@data = global [2048 x [2048 x i32]] zeroinitializer, align 4
@free_data_ptr = global i32 0, align 4
@DATA_TYPE_SYMBOL = global i32 0, align 4
@DATA_TYPE_NUMBER = global i32 1, align 4
@DATA_TYPE_LIST = global i32 2, align 4
@DATA_TYPE_ENV = global i32 3, align 4
@DATA_TYPE_FUNC = global i32 4, align 4
@MAX_SYM_BUF_LEN = global i32 4096, align 4
@sym_buf = global [4096 x i32] zeroinitializer, align 4
@next_sym = global i32 0, align 4
@SYM_QUOTE = global i32 -1, align 4
@SYM_ATOM = global i32 -2, align 4
@SYM_NUMBER = global i32 -3, align 4
@SYM_EQ = global i32 -4, align 4
@SYM_CAR = global i32 -5, align 4
@SYM_CDR = global i32 -6, align 4
@SYM_CONS = global i32 -7, align 4
@SYM_COND = global i32 -8, align 4
@SYM_LAMBDA = global i32 -9, align 4
@SYM_DEFINE = global i32 -10, align 4
@SYM_T = global i32 -11, align 4
@SYM_F = global i32 -12, align 4
@SYM_LIST = global i32 -13, align 4
@SYM_ADD = global i32 -14, align 4
@SYM_SUB = global i32 -15, align 4
@SYM_MUL = global i32 -16, align 4
@SYM_DIV = global i32 -17, align 4
@SYM_GT = global i32 -18, align 4
@SYM_LT = global i32 -19, align 4
@SYM_GE = global i32 -20, align 4
@SYM_LE = global i32 -21, align 4
@SYM_EQ_NUM = global i32 -22, align 4
@PRE_SYM_COUNT = global i32 22, align 4
@PREDEF_SYMS = global [22 x [8 x i32]] [[8 x i32] [i32 113, i32 117, i32 111, i32 116, i32 101, i32 0, i32 0, i32 0], [8 x i32] [i32 97, i32 116, i32 111, i32 109, i32 63, i32 0, i32 0, i32 0], [8 x i32] [i32 110, i32 117, i32 109, i32 98, i32 101, i32 114, i32 63, i32 0], [8 x i32] [i32 101, i32 113, i32 63, i32 0, i32 0, i32 0, i32 0, i32 0], [8 x i32] [i32 99, i32 97, i32 114, i32 0, i32 0, i32 0, i32 0, i32 0], [8 x i32] [i32 99, i32 100, i32 114, i32 0, i32 0, i32 0, i32 0, i32 0], [8 x i32] [i32 99, i32 111, i32 110, i32 115, i32 0, i32 0, i32 0, i32 0], [8 x i32] [i32 99, i32 111, i32 110, i32 100, i32 0, i32 0, i32 0, i32 0], [8 x i32] [i32 108, i32 97, i32 109, i32 98, i32 100, i32 97, i32 0, i32 0], [8 x i32] [i32 100, i32 101, i32 102, i32 105, i32 110, i32 101, i32 0, i32 0], [8 x i32] [i32 116, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0], [8 x i32] [i32 102, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0], [8 x i32] [i32 108, i32 105, i32 115, i32 116, i32 0, i32 0, i32 0, i32 0], [8 x i32] [i32 43, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0], [8 x i32] [i32 45, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0], [8 x i32] [i32 42, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0], [8 x i32] [i32 47, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0], [8 x i32] [i32 62, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0], [8 x i32] [i32 60, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0], [8 x i32] [i32 62, i32 61, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0], [8 x i32] [i32 60, i32 61, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0], [8 x i32] [i32 61, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0]], align 4
@last_char = global i32 32, align 4
@TOKEN_EOF = global i32 0, align 4
@TOKEN_SYMBOL = global i32 1, align 4
@TOKEN_NUMBER = global i32 2, align 4
@TOKEN_QUOTE = global i32 3, align 4
@TOKEN_LPAREN = global i32 4, align 4
@TOKEN_RPAREN = global i32 5, align 4
@last_token = global i32 0, align 4
@last_token_type = global i32 0, align 4

declare i32 @printf(ptr, ...)

declare i32 @scanf(ptr, ...)

declare i32 @getchar()

declare i32 @putchar(i32)

define i32 @getint() {
entry:
  %val = alloca i32, align 4
  %val1 = load i32, ptr %val, align 4
  %0 = call i32 (ptr, ...) @scanf(ptr @0, ptr %val)
  %val2 = load i32, ptr %val, align 4
  ret i32 %val2
}

define i32 @getch() {
entry:
  %0 = call i32 @getchar()
  ret i32 %0
}

define i32 @getarray(ptr %val) {
entry:
  %i = alloca i32, align 4
  %len = alloca i32, align 4
  %val1 = alloca ptr, align 8
  store ptr %val, ptr %val1, align 8
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i2 = load i32, ptr %i, align 4
  %len3 = load i32, ptr %len, align 4
  %0 = icmp slt i32 %i2, %len3
  %1 = sext i1 %0 to i32
  %2 = icmp ne i32 %1, 0
  br i1 %2, label %for.body, label %for.last

for.body:                                         ; preds = %for.cond
  %val4 = load ptr, ptr %val1, align 8
  %i5 = load i32, ptr %i, align 4
  %3 = getelementptr inbounds i32, ptr %val4, i32 %i5
  %4 = load i32, ptr %3, align 4
  %5 = call i32 (ptr, ...) @scanf(ptr @1, i32 %4)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %i6 = load i32, ptr %i, align 4
  %6 = add i32 %i6, 1
  store i32 %6, ptr %i, align 4
  br label %for.cond

for.last:                                         ; preds = %for.cond
  %len7 = load i32, ptr %len, align 4
  ret i32 %len7
}

define void @putint(i32 %val) {
entry:
  %val1 = alloca i32, align 4
  store i32 %val, ptr %val1, align 4
  %val2 = load i32, ptr %val1, align 4
  %0 = call i32 (ptr, ...) @printf(ptr @2, i32 %val2)
  ret void
}

define void @putch(i32 %val) {
entry:
  %val1 = alloca i32, align 4
  store i32 %val, ptr %val1, align 4
  %val2 = load i32, ptr %val1, align 4
  %0 = call i32 @putchar(i32 %val2)
  ret void
}

define void @putarray(i32 %len, ptr %arr) {
entry:
  %i = alloca i32, align 4
  %len1 = alloca i32, align 4
  store i32 %len, ptr %len1, align 4
  %arr2 = alloca ptr, align 8
  store ptr %arr, ptr %arr2, align 8
  %len3 = load i32, ptr %len1, align 4
  %0 = call i32 (ptr, ...) @printf(ptr @3, i32 %len3)
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i4 = load i32, ptr %i, align 4
  %len5 = load i32, ptr %len1, align 4
  %1 = icmp slt i32 %i4, %len5
  %2 = sext i1 %1 to i32
  %3 = icmp ne i32 %2, 0
  br i1 %3, label %for.body, label %for.last

for.body:                                         ; preds = %for.cond
  %arr6 = load ptr, ptr %arr2, align 8
  %i7 = load i32, ptr %i, align 4
  %4 = getelementptr inbounds i32, ptr %arr6, i32 %i7
  %5 = load i32, ptr %4, align 4
  %6 = call i32 (ptr, ...) @printf(ptr @4, i32 %5)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %i8 = load i32, ptr %i, align 4
  %7 = add i32 %i8, 1
  store i32 %7, ptr %i, align 4
  br label %for.cond

for.last:                                         ; preds = %for.cond
  ret void
}

define i32 @panic(i32 %code) {
entry:
  %code1 = alloca i32, align 4
  store i32 %code, ptr %code1, align 4
  call void @putch(i32 112)
  call void @putch(i32 97)
  call void @putch(i32 110)
  call void @putch(i32 105)
  call void @putch(i32 99)
  call void @putch(i32 32)
  %code2 = load i32, ptr %code1, align 4
  call void @putint(i32 %code2)
  call void @putch(i32 10)
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  br i1 true, label %for.body, label %for.last

for.body:                                         ; preds = %for.cond
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br label %for.cond

for.last:                                         ; preds = %for.cond
  %code3 = load i32, ptr %code1, align 4
  ret i32 %code3
}

define void @init_data() {
entry:
  %i = alloca i32, align 4
  %data = load [2048 x [2048 x i32]], ptr @data, align 4
  %0 = load [2048 x i32], ptr @data, align 4
  %DATA_NEXT = load i32, ptr @DATA_NEXT, align 4
  %1 = getelementptr inbounds i32, ptr @data, i32 %DATA_NEXT
  %2 = load i32, ptr %1, align 4
  store i32 0, ptr %1, align 4
  store i32 1, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i1 = load i32, ptr %i, align 4
  %MAX_DATA_LEN = load i32, ptr @MAX_DATA_LEN, align 4
  %3 = icmp slt i32 %i1, %MAX_DATA_LEN
  %4 = sext i1 %3 to i32
  %5 = icmp ne i32 %4, 0
  br i1 %5, label %for.body, label %for.last

for.body:                                         ; preds = %for.cond
  %data2 = load [2048 x [2048 x i32]], ptr @data, align 4
  %i3 = load i32, ptr %i, align 4
  %6 = getelementptr inbounds [2048 x i32], ptr @data, i32 %i3
  %7 = load [2048 x i32], ptr %6, align 4
  %DATA_NEXT4 = load i32, ptr @DATA_NEXT, align 4
  %8 = getelementptr inbounds i32, ptr %6, i32 %DATA_NEXT4
  %9 = load i32, ptr %8, align 4
  %i5 = load i32, ptr %i, align 4
  %10 = sub nsw i32 %i5, 1
  store i32 %10, ptr %8, align 4
  %i6 = load i32, ptr %i, align 4
  %i7 = load i32, ptr %i, align 4
  %11 = add nsw i32 %i7, 1
  store i32 %11, ptr %i, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br label %for.cond

for.last:                                         ; preds = %for.cond
  %free_data_ptr = load i32, ptr @free_data_ptr, align 4
  %MAX_DATA_LEN8 = load i32, ptr @MAX_DATA_LEN, align 4
  %12 = sub nsw i32 %MAX_DATA_LEN8, 1
  store i32 %12, ptr @free_data_ptr, align 4
  ret void
}

define i32 @alloc_data() {
entry:
  %i = alloca i32, align 4
  %free_data_ptr = load i32, ptr @free_data_ptr, align 4
  %0 = icmp ne i32 %free_data_ptr, 0
  %1 = xor i1 %0, true
  %2 = zext i1 %1 to i32
  %3 = icmp ne i32 %2, 0
  br i1 %3, label %then, label %last

then:                                             ; preds = %entry
  %ERR_BUFFER_OVERFLOW = load i32, ptr @ERR_BUFFER_OVERFLOW, align 4
  %4 = call i32 @panic(i32 %ERR_BUFFER_OVERFLOW)
  br label %last

last:                                             ; preds = %then, %entry
  %free_data_ptr1 = load i32, ptr @free_data_ptr, align 4
  store i32 %free_data_ptr1, ptr %i, align 4
  %free_data_ptr2 = load i32, ptr @free_data_ptr, align 4
  %data = load [2048 x [2048 x i32]], ptr @data, align 4
  %i3 = load i32, ptr %i, align 4
  %5 = getelementptr inbounds [2048 x i32], ptr @data, i32 %i3
  %6 = load [2048 x i32], ptr %5, align 4
  %DATA_NEXT = load i32, ptr @DATA_NEXT, align 4
  %7 = getelementptr inbounds i32, ptr %5, i32 %DATA_NEXT
  %8 = load i32, ptr %7, align 4
  store i32 %8, ptr @free_data_ptr, align 4
  %data4 = load [2048 x [2048 x i32]], ptr @data, align 4
  %i5 = load i32, ptr %i, align 4
  %9 = getelementptr inbounds [2048 x i32], ptr @data, i32 %i5
  %10 = load [2048 x i32], ptr %9, align 4
  %DATA_NEXT6 = load i32, ptr @DATA_NEXT, align 4
  %11 = getelementptr inbounds i32, ptr %9, i32 %DATA_NEXT6
  %12 = load i32, ptr %11, align 4
  store i32 0, ptr %11, align 4
  %data7 = load [2048 x [2048 x i32]], ptr @data, align 4
  %i8 = load i32, ptr %i, align 4
  %13 = getelementptr inbounds [2048 x i32], ptr @data, i32 %i8
  %14 = load [2048 x i32], ptr %13, align 4
  %DATA_REF_COUNT = load i32, ptr @DATA_REF_COUNT, align 4
  %15 = getelementptr inbounds i32, ptr %13, i32 %DATA_REF_COUNT
  %16 = load i32, ptr %15, align 4
  store i32 1, ptr %15, align 4
  %i9 = load i32, ptr %i, align 4
  ret i32 %i9
}

define void @free_data(i32 %data_ptr) {
entry:
  %ref_count = alloca i32, align 4
  %data_ptr1 = alloca i32, align 4
  store i32 %data_ptr, ptr %data_ptr1, align 4
  %data_ptr2 = load i32, ptr %data_ptr1, align 4
  %0 = icmp ne i32 %data_ptr2, 0
  %1 = xor i1 %0, true
  %2 = zext i1 %1 to i32
  %3 = icmp ne i32 %2, 0
  br i1 %3, label %then, label %last

then:                                             ; preds = %entry
  ret void

last:                                             ; preds = %entry
  %data = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr3 = load i32, ptr %data_ptr1, align 4
  %4 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr3
  %5 = load [2048 x i32], ptr %4, align 4
  %DATA_REF_COUNT = load i32, ptr @DATA_REF_COUNT, align 4
  %6 = getelementptr inbounds i32, ptr %4, i32 %DATA_REF_COUNT
  %7 = load i32, ptr %6, align 4
  %8 = sub nsw i32 %7, 1
  store i32 %8, ptr %ref_count, align 4
  %data4 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr5 = load i32, ptr %data_ptr1, align 4
  %9 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr5
  %10 = load [2048 x i32], ptr %9, align 4
  %DATA_REF_COUNT6 = load i32, ptr @DATA_REF_COUNT, align 4
  %11 = getelementptr inbounds i32, ptr %9, i32 %DATA_REF_COUNT6
  %12 = load i32, ptr %11, align 4
  %ref_count7 = load i32, ptr %ref_count, align 4
  store i32 %ref_count7, ptr %11, align 4
  %ref_count8 = load i32, ptr %ref_count, align 4
  %13 = icmp sgt i32 %ref_count8, 0
  %14 = sext i1 %13 to i32
  %15 = icmp ne i32 %14, 0
  br i1 %15, label %then9, label %last10

then9:                                            ; preds = %last
  ret void

last10:                                           ; preds = %last
  %data11 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr12 = load i32, ptr %data_ptr1, align 4
  %16 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr12
  %17 = load [2048 x i32], ptr %16, align 4
  %DATA_TYPE = load i32, ptr @DATA_TYPE, align 4
  %18 = getelementptr inbounds i32, ptr %16, i32 %DATA_TYPE
  %19 = load i32, ptr %18, align 4
  %DATA_TYPE_SYMBOL = load i32, ptr @DATA_TYPE_SYMBOL, align 4
  %20 = icmp ne i32 %19, %DATA_TYPE_SYMBOL
  %21 = sext i1 %20 to i32
  %22 = icmp ne i32 %21, 0
  br i1 %22, label %nextBB, label %falseBB

nextBB:                                           ; preds = %last10
  %data13 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr14 = load i32, ptr %data_ptr1, align 4
  %23 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr14
  %24 = load [2048 x i32], ptr %23, align 4
  %DATA_TYPE15 = load i32, ptr @DATA_TYPE, align 4
  %25 = getelementptr inbounds i32, ptr %23, i32 %DATA_TYPE15
  %26 = load i32, ptr %25, align 4
  %DATA_TYPE_NUMBER = load i32, ptr @DATA_TYPE_NUMBER, align 4
  %27 = icmp ne i32 %26, %DATA_TYPE_NUMBER
  %28 = sext i1 %27 to i32
  %29 = icmp ne i32 %28, 0
  %30 = zext i1 %29 to i32
  br label %mergeBB

falseBB:                                          ; preds = %last10
  br label %mergeBB

mergeBB:                                          ; preds = %falseBB, %nextBB
  %31 = phi i32 [ %30, %nextBB ], [ 0, %falseBB ]
  %32 = icmp ne i32 %31, 0
  br i1 %32, label %then16, label %last19

then16:                                           ; preds = %mergeBB
  %data17 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr18 = load i32, ptr %data_ptr1, align 4
  %33 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr18
  %34 = load [2048 x i32], ptr %33, align 4
  %DATA_VALUE = load i32, ptr @DATA_VALUE, align 4
  %35 = getelementptr inbounds i32, ptr %33, i32 %DATA_VALUE
  %36 = load i32, ptr %35, align 4
  call void @free_data(i32 %36)
  br label %last19

last19:                                           ; preds = %then16, %mergeBB
  %data20 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr21 = load i32, ptr %data_ptr1, align 4
  %37 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr21
  %38 = load [2048 x i32], ptr %37, align 4
  %DATA_NEXT = load i32, ptr @DATA_NEXT, align 4
  %39 = getelementptr inbounds i32, ptr %37, i32 %DATA_NEXT
  %40 = load i32, ptr %39, align 4
  call void @free_data(i32 %40)
  %data22 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr23 = load i32, ptr %data_ptr1, align 4
  %41 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr23
  %42 = load [2048 x i32], ptr %41, align 4
  %DATA_NEXT24 = load i32, ptr @DATA_NEXT, align 4
  %43 = getelementptr inbounds i32, ptr %41, i32 %DATA_NEXT24
  %44 = load i32, ptr %43, align 4
  %free_data_ptr = load i32, ptr @free_data_ptr, align 4
  store i32 %free_data_ptr, ptr %43, align 4
  %free_data_ptr25 = load i32, ptr @free_data_ptr, align 4
  %data_ptr26 = load i32, ptr %data_ptr1, align 4
  store i32 %data_ptr26, ptr @free_data_ptr, align 4
  ret void
}

define i32 @copy_ptr(i32 %data_ptr) {
entry:
  %data_ptr1 = alloca i32, align 4
  store i32 %data_ptr, ptr %data_ptr1, align 4
  %data_ptr2 = load i32, ptr %data_ptr1, align 4
  %0 = icmp ne i32 %data_ptr2, 0
  %1 = xor i1 %0, true
  %2 = zext i1 %1 to i32
  %3 = icmp ne i32 %2, 0
  br i1 %3, label %then, label %last

then:                                             ; preds = %entry
  ret i32 0

last:                                             ; preds = %entry
  %data = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr3 = load i32, ptr %data_ptr1, align 4
  %4 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr3
  %5 = load [2048 x i32], ptr %4, align 4
  %DATA_REF_COUNT = load i32, ptr @DATA_REF_COUNT, align 4
  %6 = getelementptr inbounds i32, ptr %4, i32 %DATA_REF_COUNT
  %7 = load i32, ptr %6, align 4
  %data4 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr5 = load i32, ptr %data_ptr1, align 4
  %8 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr5
  %9 = load [2048 x i32], ptr %8, align 4
  %DATA_REF_COUNT6 = load i32, ptr @DATA_REF_COUNT, align 4
  %10 = getelementptr inbounds i32, ptr %8, i32 %DATA_REF_COUNT6
  %11 = load i32, ptr %10, align 4
  %12 = add nsw i32 %11, 1
  store i32 %12, ptr %6, align 4
  %data_ptr7 = load i32, ptr %data_ptr1, align 4
  ret i32 %data_ptr7
}

define i32 @copy_data(i32 %data_ptr) {
entry:
  %value_ptr = alloca i32, align 4
  %new_data_ptr = alloca i32, align 4
  %data_ptr1 = alloca i32, align 4
  store i32 %data_ptr, ptr %data_ptr1, align 4
  %data_ptr2 = load i32, ptr %data_ptr1, align 4
  %0 = icmp ne i32 %data_ptr2, 0
  %1 = xor i1 %0, true
  %2 = zext i1 %1 to i32
  %3 = icmp ne i32 %2, 0
  br i1 %3, label %then, label %last

then:                                             ; preds = %entry
  ret i32 0

last:                                             ; preds = %entry
  %4 = call i32 @alloc_data()
  store i32 %4, ptr %new_data_ptr, align 4
  %data = load [2048 x [2048 x i32]], ptr @data, align 4
  %new_data_ptr3 = load i32, ptr %new_data_ptr, align 4
  %5 = getelementptr inbounds [2048 x i32], ptr @data, i32 %new_data_ptr3
  %6 = load [2048 x i32], ptr %5, align 4
  %DATA_TYPE = load i32, ptr @DATA_TYPE, align 4
  %7 = getelementptr inbounds i32, ptr %5, i32 %DATA_TYPE
  %8 = load i32, ptr %7, align 4
  %data4 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr5 = load i32, ptr %data_ptr1, align 4
  %9 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr5
  %10 = load [2048 x i32], ptr %9, align 4
  %DATA_TYPE6 = load i32, ptr @DATA_TYPE, align 4
  %11 = getelementptr inbounds i32, ptr %9, i32 %DATA_TYPE6
  %12 = load i32, ptr %11, align 4
  store i32 %12, ptr %7, align 4
  %data7 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr8 = load i32, ptr %data_ptr1, align 4
  %13 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr8
  %14 = load [2048 x i32], ptr %13, align 4
  %DATA_VALUE = load i32, ptr @DATA_VALUE, align 4
  %15 = getelementptr inbounds i32, ptr %13, i32 %DATA_VALUE
  %16 = load i32, ptr %15, align 4
  store i32 %16, ptr %value_ptr, align 4
  %data9 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr10 = load i32, ptr %data_ptr1, align 4
  %17 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr10
  %18 = load [2048 x i32], ptr %17, align 4
  %DATA_TYPE11 = load i32, ptr @DATA_TYPE, align 4
  %19 = getelementptr inbounds i32, ptr %17, i32 %DATA_TYPE11
  %20 = load i32, ptr %19, align 4
  %DATA_TYPE_SYMBOL = load i32, ptr @DATA_TYPE_SYMBOL, align 4
  %21 = icmp ne i32 %20, %DATA_TYPE_SYMBOL
  %22 = sext i1 %21 to i32
  %23 = icmp ne i32 %22, 0
  br i1 %23, label %nextBB, label %falseBB

nextBB:                                           ; preds = %last
  %data12 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr13 = load i32, ptr %data_ptr1, align 4
  %24 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr13
  %25 = load [2048 x i32], ptr %24, align 4
  %DATA_TYPE14 = load i32, ptr @DATA_TYPE, align 4
  %26 = getelementptr inbounds i32, ptr %24, i32 %DATA_TYPE14
  %27 = load i32, ptr %26, align 4
  %DATA_TYPE_NUMBER = load i32, ptr @DATA_TYPE_NUMBER, align 4
  %28 = icmp ne i32 %27, %DATA_TYPE_NUMBER
  %29 = sext i1 %28 to i32
  %30 = icmp ne i32 %29, 0
  %31 = zext i1 %30 to i32
  br label %mergeBB

falseBB:                                          ; preds = %last
  br label %mergeBB

mergeBB:                                          ; preds = %falseBB, %nextBB
  %32 = phi i32 [ %31, %nextBB ], [ 0, %falseBB ]
  %33 = icmp ne i32 %32, 0
  br i1 %33, label %then15, label %last18

then15:                                           ; preds = %mergeBB
  %value_ptr16 = load i32, ptr %value_ptr, align 4
  %value_ptr17 = load i32, ptr %value_ptr, align 4
  %34 = call i32 @copy_ptr(i32 %value_ptr17)
  store i32 %34, ptr %value_ptr, align 4
  br label %last18

last18:                                           ; preds = %then15, %mergeBB
  %data19 = load [2048 x [2048 x i32]], ptr @data, align 4
  %new_data_ptr20 = load i32, ptr %new_data_ptr, align 4
  %35 = getelementptr inbounds [2048 x i32], ptr @data, i32 %new_data_ptr20
  %36 = load [2048 x i32], ptr %35, align 4
  %DATA_VALUE21 = load i32, ptr @DATA_VALUE, align 4
  %37 = getelementptr inbounds i32, ptr %35, i32 %DATA_VALUE21
  %38 = load i32, ptr %37, align 4
  %value_ptr22 = load i32, ptr %value_ptr, align 4
  store i32 %value_ptr22, ptr %37, align 4
  %data23 = load [2048 x [2048 x i32]], ptr @data, align 4
  %new_data_ptr24 = load i32, ptr %new_data_ptr, align 4
  %39 = getelementptr inbounds [2048 x i32], ptr @data, i32 %new_data_ptr24
  %40 = load [2048 x i32], ptr %39, align 4
  %DATA_NEXT = load i32, ptr @DATA_NEXT, align 4
  %41 = getelementptr inbounds i32, ptr %39, i32 %DATA_NEXT
  %42 = load i32, ptr %41, align 4
  store i32 0, ptr %41, align 4
  %new_data_ptr25 = load i32, ptr %new_data_ptr, align 4
  ret i32 %new_data_ptr25
}

define i32 @make_symbol(i32 %sym_ptr) {
entry:
  %data_ptr = alloca i32, align 4
  %sym_ptr1 = alloca i32, align 4
  store i32 %sym_ptr, ptr %sym_ptr1, align 4
  %0 = call i32 @alloc_data()
  store i32 %0, ptr %data_ptr, align 4
  %data = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr2 = load i32, ptr %data_ptr, align 4
  %1 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr2
  %2 = load [2048 x i32], ptr %1, align 4
  %DATA_TYPE = load i32, ptr @DATA_TYPE, align 4
  %3 = getelementptr inbounds i32, ptr %1, i32 %DATA_TYPE
  %4 = load i32, ptr %3, align 4
  %DATA_TYPE_SYMBOL = load i32, ptr @DATA_TYPE_SYMBOL, align 4
  store i32 %DATA_TYPE_SYMBOL, ptr %3, align 4
  %data3 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr4 = load i32, ptr %data_ptr, align 4
  %5 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr4
  %6 = load [2048 x i32], ptr %5, align 4
  %DATA_VALUE = load i32, ptr @DATA_VALUE, align 4
  %7 = getelementptr inbounds i32, ptr %5, i32 %DATA_VALUE
  %8 = load i32, ptr %7, align 4
  %sym_ptr5 = load i32, ptr %sym_ptr1, align 4
  store i32 %sym_ptr5, ptr %7, align 4
  %data_ptr6 = load i32, ptr %data_ptr, align 4
  ret i32 %data_ptr6
}

define i32 @make_number(i32 %num) {
entry:
  %data_ptr = alloca i32, align 4
  %num1 = alloca i32, align 4
  store i32 %num, ptr %num1, align 4
  %0 = call i32 @alloc_data()
  store i32 %0, ptr %data_ptr, align 4
  %data = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr2 = load i32, ptr %data_ptr, align 4
  %1 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr2
  %2 = load [2048 x i32], ptr %1, align 4
  %DATA_TYPE = load i32, ptr @DATA_TYPE, align 4
  %3 = getelementptr inbounds i32, ptr %1, i32 %DATA_TYPE
  %4 = load i32, ptr %3, align 4
  %DATA_TYPE_NUMBER = load i32, ptr @DATA_TYPE_NUMBER, align 4
  store i32 %DATA_TYPE_NUMBER, ptr %3, align 4
  %data3 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr4 = load i32, ptr %data_ptr, align 4
  %5 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr4
  %6 = load [2048 x i32], ptr %5, align 4
  %DATA_VALUE = load i32, ptr @DATA_VALUE, align 4
  %7 = getelementptr inbounds i32, ptr %5, i32 %DATA_VALUE
  %8 = load i32, ptr %7, align 4
  %num5 = load i32, ptr %num1, align 4
  store i32 %num5, ptr %7, align 4
  %data_ptr6 = load i32, ptr %data_ptr, align 4
  ret i32 %data_ptr6
}

define i32 @make_list(i32 %head_ptr) {
entry:
  %data_ptr = alloca i32, align 4
  %head_ptr1 = alloca i32, align 4
  store i32 %head_ptr, ptr %head_ptr1, align 4
  %0 = call i32 @alloc_data()
  store i32 %0, ptr %data_ptr, align 4
  %data = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr2 = load i32, ptr %data_ptr, align 4
  %1 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr2
  %2 = load [2048 x i32], ptr %1, align 4
  %DATA_TYPE = load i32, ptr @DATA_TYPE, align 4
  %3 = getelementptr inbounds i32, ptr %1, i32 %DATA_TYPE
  %4 = load i32, ptr %3, align 4
  %DATA_TYPE_LIST = load i32, ptr @DATA_TYPE_LIST, align 4
  store i32 %DATA_TYPE_LIST, ptr %3, align 4
  %data3 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr4 = load i32, ptr %data_ptr, align 4
  %5 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr4
  %6 = load [2048 x i32], ptr %5, align 4
  %DATA_VALUE = load i32, ptr @DATA_VALUE, align 4
  %7 = getelementptr inbounds i32, ptr %5, i32 %DATA_VALUE
  %8 = load i32, ptr %7, align 4
  %head_ptr5 = load i32, ptr %head_ptr1, align 4
  store i32 %head_ptr5, ptr %7, align 4
  %data_ptr6 = load i32, ptr %data_ptr, align 4
  ret i32 %data_ptr6
}

define i32 @is_predef_sym(i32 %sym_ptr) {
entry:
  %failed = alloca i32, align 4
  %j = alloca i32, align 4
  %i = alloca i32, align 4
  %sym_ptr1 = alloca i32, align 4
  store i32 %sym_ptr, ptr %sym_ptr1, align 4
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc25, %entry
  %i2 = load i32, ptr %i, align 4
  %PRE_SYM_COUNT = load i32, ptr @PRE_SYM_COUNT, align 4
  %0 = icmp slt i32 %i2, %PRE_SYM_COUNT
  %1 = sext i1 %0 to i32
  %2 = icmp ne i32 %1, 0
  br i1 %2, label %for.body, label %for.last26

for.body:                                         ; preds = %for.cond
  store i32 0, ptr %j, align 4
  store i32 0, ptr %failed, align 4
  br label %for.cond3

for.cond3:                                        ; preds = %for.inc, %for.body
  %sym_buf = load [4096 x i32], ptr @sym_buf, align 4
  %sym_ptr4 = load i32, ptr %sym_ptr1, align 4
  %j5 = load i32, ptr %j, align 4
  %3 = add nsw i32 %sym_ptr4, %j5
  %4 = getelementptr inbounds i32, ptr @sym_buf, i32 %3
  %5 = load i32, ptr %4, align 4
  %6 = icmp ne i32 %5, 0
  br i1 %6, label %for.body6, label %for.last

for.body6:                                        ; preds = %for.cond3
  %sym_buf7 = load [4096 x i32], ptr @sym_buf, align 4
  %sym_ptr8 = load i32, ptr %sym_ptr1, align 4
  %j9 = load i32, ptr %j, align 4
  %7 = add nsw i32 %sym_ptr8, %j9
  %8 = getelementptr inbounds i32, ptr @sym_buf, i32 %7
  %9 = load i32, ptr %8, align 4
  %PREDEF_SYMS = load [22 x [8 x i32]], ptr @PREDEF_SYMS, align 4
  %i10 = load i32, ptr %i, align 4
  %10 = getelementptr inbounds [8 x i32], ptr @PREDEF_SYMS, i32 %i10
  %11 = load [8 x i32], ptr %10, align 4
  %j11 = load i32, ptr %j, align 4
  %12 = getelementptr inbounds i32, ptr %10, i32 %j11
  %13 = load i32, ptr %12, align 4
  %14 = icmp ne i32 %9, %13
  %15 = sext i1 %14 to i32
  %16 = icmp ne i32 %15, 0
  br i1 %16, label %then, label %last

then:                                             ; preds = %for.body6
  %failed12 = load i32, ptr %failed, align 4
  store i32 1, ptr %failed, align 4
  br label %for.last

last:                                             ; preds = %for.body6
  %j13 = load i32, ptr %j, align 4
  %j14 = load i32, ptr %j, align 4
  %17 = add nsw i32 %j14, 1
  store i32 %17, ptr %j, align 4
  br label %for.inc

for.inc:                                          ; preds = %last
  br label %for.cond3

for.last:                                         ; preds = %then, %for.cond3
  %failed15 = load i32, ptr %failed, align 4
  %18 = icmp ne i32 %failed15, 0
  %19 = xor i1 %18, true
  %20 = zext i1 %19 to i32
  %21 = icmp ne i32 %20, 0
  br i1 %21, label %nextBB, label %falseBB

nextBB:                                           ; preds = %for.last
  %PREDEF_SYMS16 = load [22 x [8 x i32]], ptr @PREDEF_SYMS, align 4
  %i17 = load i32, ptr %i, align 4
  %22 = getelementptr inbounds [8 x i32], ptr @PREDEF_SYMS, i32 %i17
  %23 = load [8 x i32], ptr %22, align 4
  %j18 = load i32, ptr %j, align 4
  %24 = getelementptr inbounds i32, ptr %22, i32 %j18
  %25 = load i32, ptr %24, align 4
  %26 = icmp ne i32 %25, 0
  %27 = xor i1 %26, true
  %28 = zext i1 %27 to i32
  %29 = icmp ne i32 %28, 0
  %30 = zext i1 %29 to i32
  br label %mergeBB

falseBB:                                          ; preds = %for.last
  br label %mergeBB

mergeBB:                                          ; preds = %falseBB, %nextBB
  %31 = phi i32 [ %30, %nextBB ], [ 0, %falseBB ]
  %32 = icmp ne i32 %31, 0
  br i1 %32, label %then19, label %last22

then19:                                           ; preds = %mergeBB
  %next_sym = load i32, ptr @next_sym, align 4
  %sym_ptr20 = load i32, ptr %sym_ptr1, align 4
  store i32 %sym_ptr20, ptr @next_sym, align 4
  %i21 = load i32, ptr %i, align 4
  %33 = sub i32 0, %i21
  %34 = sub nsw i32 %33, 1
  ret i32 %34

last22:                                           ; preds = %mergeBB
  %i23 = load i32, ptr %i, align 4
  %i24 = load i32, ptr %i, align 4
  %35 = add nsw i32 %i24, 1
  store i32 %35, ptr %i, align 4
  br label %for.inc25

for.inc25:                                        ; preds = %last22
  br label %for.cond

for.last26:                                       ; preds = %for.cond
  %sym_ptr27 = load i32, ptr %sym_ptr1, align 4
  ret i32 %sym_ptr27
}

define i32 @is_eq_sym(i32 %sym1, i32 %sym2) {
entry:
  %i = alloca i32, align 4
  %sym11 = alloca i32, align 4
  store i32 %sym1, ptr %sym11, align 4
  %sym22 = alloca i32, align 4
  store i32 %sym2, ptr %sym22, align 4
  %sym13 = load i32, ptr %sym11, align 4
  %sym24 = load i32, ptr %sym22, align 4
  %0 = icmp eq i32 %sym13, %sym24
  %1 = sext i1 %0 to i32
  %2 = icmp ne i32 %1, 0
  br i1 %2, label %then, label %last

then:                                             ; preds = %entry
  ret i32 1

last:                                             ; preds = %entry
  %sym15 = load i32, ptr %sym11, align 4
  %3 = icmp slt i32 %sym15, 0
  %4 = sext i1 %3 to i32
  %5 = icmp ne i32 %4, 0
  br i1 %5, label %trueBB, label %nextBB

nextBB:                                           ; preds = %last
  %sym26 = load i32, ptr %sym22, align 4
  %6 = icmp slt i32 %sym26, 0
  %7 = sext i1 %6 to i32
  %8 = icmp ne i32 %7, 0
  %9 = zext i1 %8 to i32
  br label %mergeBB

trueBB:                                           ; preds = %last
  br label %mergeBB

mergeBB:                                          ; preds = %trueBB, %nextBB
  %10 = phi i32 [ %9, %nextBB ], [ 1, %trueBB ]
  %11 = icmp ne i32 %10, 0
  br i1 %11, label %then7, label %last8

then7:                                            ; preds = %mergeBB
  ret i32 0

last8:                                            ; preds = %mergeBB
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %last8
  %sym_buf = load [4096 x i32], ptr @sym_buf, align 4
  %sym19 = load i32, ptr %sym11, align 4
  %i10 = load i32, ptr %i, align 4
  %12 = add nsw i32 %sym19, %i10
  %13 = getelementptr inbounds i32, ptr @sym_buf, i32 %12
  %14 = load i32, ptr %13, align 4
  %15 = icmp ne i32 %14, 0
  br i1 %15, label %for.body, label %for.last

for.body:                                         ; preds = %for.cond
  %sym_buf11 = load [4096 x i32], ptr @sym_buf, align 4
  %sym112 = load i32, ptr %sym11, align 4
  %i13 = load i32, ptr %i, align 4
  %16 = add nsw i32 %sym112, %i13
  %17 = getelementptr inbounds i32, ptr @sym_buf, i32 %16
  %18 = load i32, ptr %17, align 4
  %sym_buf14 = load [4096 x i32], ptr @sym_buf, align 4
  %sym215 = load i32, ptr %sym22, align 4
  %i16 = load i32, ptr %i, align 4
  %19 = add nsw i32 %sym215, %i16
  %20 = getelementptr inbounds i32, ptr @sym_buf, i32 %19
  %21 = load i32, ptr %20, align 4
  %22 = icmp ne i32 %18, %21
  %23 = sext i1 %22 to i32
  %24 = icmp ne i32 %23, 0
  br i1 %24, label %then17, label %last18

then17:                                           ; preds = %for.body
  ret i32 0

last18:                                           ; preds = %for.body
  %i19 = load i32, ptr %i, align 4
  %i20 = load i32, ptr %i, align 4
  %25 = add nsw i32 %i20, 1
  store i32 %25, ptr %i, align 4
  br label %for.inc

for.inc:                                          ; preds = %last18
  br label %for.cond

for.last:                                         ; preds = %for.cond
  %sym_buf21 = load [4096 x i32], ptr @sym_buf, align 4
  %sym122 = load i32, ptr %sym11, align 4
  %i23 = load i32, ptr %i, align 4
  %26 = add nsw i32 %sym122, %i23
  %27 = getelementptr inbounds i32, ptr @sym_buf, i32 %26
  %28 = load i32, ptr %27, align 4
  %sym_buf24 = load [4096 x i32], ptr @sym_buf, align 4
  %sym225 = load i32, ptr %sym22, align 4
  %i26 = load i32, ptr %i, align 4
  %29 = add nsw i32 %sym225, %i26
  %30 = getelementptr inbounds i32, ptr @sym_buf, i32 %29
  %31 = load i32, ptr %30, align 4
  %32 = icmp eq i32 %28, %31
  %33 = sext i1 %32 to i32
  ret i32 %33
}

define void @print_sym(i32 %sym_ptr) {
entry:
  %i10 = alloca i32, align 4
  %i = alloca i32, align 4
  %sym_ptr1 = alloca i32, align 4
  store i32 %sym_ptr, ptr %sym_ptr1, align 4
  %sym_ptr2 = load i32, ptr %sym_ptr1, align 4
  %0 = icmp slt i32 %sym_ptr2, 0
  %1 = sext i1 %0 to i32
  %2 = icmp ne i32 %1, 0
  br i1 %2, label %then, label %else

then:                                             ; preds = %entry
  store i32 0, ptr %i, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %then
  %PREDEF_SYMS = load [22 x [8 x i32]], ptr @PREDEF_SYMS, align 4
  %sym_ptr3 = load i32, ptr %sym_ptr1, align 4
  %3 = sub i32 0, %sym_ptr3
  %4 = sub nsw i32 %3, 1
  %5 = getelementptr inbounds [8 x i32], ptr @PREDEF_SYMS, i32 %4
  %6 = load [8 x i32], ptr %5, align 4
  %i4 = load i32, ptr %i, align 4
  %7 = getelementptr inbounds i32, ptr %5, i32 %i4
  %8 = load i32, ptr %7, align 4
  %9 = icmp ne i32 %8, 0
  br i1 %9, label %for.body, label %for.last

for.body:                                         ; preds = %for.cond
  %PREDEF_SYMS5 = load [22 x [8 x i32]], ptr @PREDEF_SYMS, align 4
  %sym_ptr6 = load i32, ptr %sym_ptr1, align 4
  %10 = sub i32 0, %sym_ptr6
  %11 = sub nsw i32 %10, 1
  %12 = getelementptr inbounds [8 x i32], ptr @PREDEF_SYMS, i32 %11
  %13 = load [8 x i32], ptr %12, align 4
  %i7 = load i32, ptr %i, align 4
  %14 = getelementptr inbounds i32, ptr %12, i32 %i7
  %15 = load i32, ptr %14, align 4
  call void @putch(i32 %15)
  %i8 = load i32, ptr %i, align 4
  %i9 = load i32, ptr %i, align 4
  %16 = add nsw i32 %i9, 1
  store i32 %16, ptr %i, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br label %for.cond

for.last:                                         ; preds = %for.cond
  br label %last

else:                                             ; preds = %entry
  store i32 0, ptr %i10, align 4
  br label %for.cond11

for.cond11:                                       ; preds = %for.inc20, %else
  %sym_buf = load [4096 x i32], ptr @sym_buf, align 4
  %sym_ptr12 = load i32, ptr %sym_ptr1, align 4
  %i13 = load i32, ptr %i10, align 4
  %17 = add nsw i32 %sym_ptr12, %i13
  %18 = getelementptr inbounds i32, ptr @sym_buf, i32 %17
  %19 = load i32, ptr %18, align 4
  %20 = icmp ne i32 %19, 0
  br i1 %20, label %for.body14, label %for.last21

for.body14:                                       ; preds = %for.cond11
  %sym_buf15 = load [4096 x i32], ptr @sym_buf, align 4
  %sym_ptr16 = load i32, ptr %sym_ptr1, align 4
  %i17 = load i32, ptr %i10, align 4
  %21 = add nsw i32 %sym_ptr16, %i17
  %22 = getelementptr inbounds i32, ptr @sym_buf, i32 %21
  %23 = load i32, ptr %22, align 4
  call void @putch(i32 %23)
  %i18 = load i32, ptr %i10, align 4
  %i19 = load i32, ptr %i10, align 4
  %24 = add nsw i32 %i19, 1
  store i32 %24, ptr %i10, align 4
  br label %for.inc20

for.inc20:                                        ; preds = %for.body14
  br label %for.cond11

for.last21:                                       ; preds = %for.cond11
  br label %last

last:                                             ; preds = %for.last21, %for.last
  ret void
}

define i32 @make_env(i32 %outer_ptr) {
entry:
  %data_ptr = alloca i32, align 4
  %outer_ptr1 = alloca i32, align 4
  store i32 %outer_ptr, ptr %outer_ptr1, align 4
  %0 = call i32 @alloc_data()
  store i32 %0, ptr %data_ptr, align 4
  %data = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr2 = load i32, ptr %data_ptr, align 4
  %1 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr2
  %2 = load [2048 x i32], ptr %1, align 4
  %DATA_TYPE = load i32, ptr @DATA_TYPE, align 4
  %3 = getelementptr inbounds i32, ptr %1, i32 %DATA_TYPE
  %4 = load i32, ptr %3, align 4
  %DATA_TYPE_ENV = load i32, ptr @DATA_TYPE_ENV, align 4
  store i32 %DATA_TYPE_ENV, ptr %3, align 4
  %data3 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr4 = load i32, ptr %data_ptr, align 4
  %5 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr4
  %6 = load [2048 x i32], ptr %5, align 4
  %DATA_VALUE = load i32, ptr @DATA_VALUE, align 4
  %7 = getelementptr inbounds i32, ptr %5, i32 %DATA_VALUE
  %8 = load i32, ptr %7, align 4
  store i32 0, ptr %7, align 4
  %data5 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr6 = load i32, ptr %data_ptr, align 4
  %9 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr6
  %10 = load [2048 x i32], ptr %9, align 4
  %DATA_NEXT = load i32, ptr @DATA_NEXT, align 4
  %11 = getelementptr inbounds i32, ptr %9, i32 %DATA_NEXT
  %12 = load i32, ptr %11, align 4
  %outer_ptr7 = load i32, ptr %outer_ptr1, align 4
  store i32 %outer_ptr7, ptr %11, align 4
  %data_ptr8 = load i32, ptr %data_ptr, align 4
  ret i32 %data_ptr8
}

define void @env_add(i32 %env_ptr, i32 %sym_ptr, i32 %val_data_ptr) {
entry:
  %pair = alloca i32, align 4
  %sym = alloca i32, align 4
  %env_ptr1 = alloca i32, align 4
  store i32 %env_ptr, ptr %env_ptr1, align 4
  %sym_ptr2 = alloca i32, align 4
  store i32 %sym_ptr, ptr %sym_ptr2, align 4
  %val_data_ptr3 = alloca i32, align 4
  store i32 %val_data_ptr, ptr %val_data_ptr3, align 4
  %sym_ptr4 = load i32, ptr %sym_ptr2, align 4
  %0 = call i32 @make_symbol(i32 %sym_ptr4)
  store i32 %0, ptr %sym, align 4
  %data = load [2048 x [2048 x i32]], ptr @data, align 4
  %sym5 = load i32, ptr %sym, align 4
  %1 = getelementptr inbounds [2048 x i32], ptr @data, i32 %sym5
  %2 = load [2048 x i32], ptr %1, align 4
  %DATA_NEXT = load i32, ptr @DATA_NEXT, align 4
  %3 = getelementptr inbounds i32, ptr %1, i32 %DATA_NEXT
  %4 = load i32, ptr %3, align 4
  %val_data_ptr6 = load i32, ptr %val_data_ptr3, align 4
  store i32 %val_data_ptr6, ptr %3, align 4
  %sym7 = load i32, ptr %sym, align 4
  %5 = call i32 @make_list(i32 %sym7)
  store i32 %5, ptr %pair, align 4
  %data8 = load [2048 x [2048 x i32]], ptr @data, align 4
  %pair9 = load i32, ptr %pair, align 4
  %6 = getelementptr inbounds [2048 x i32], ptr @data, i32 %pair9
  %7 = load [2048 x i32], ptr %6, align 4
  %DATA_NEXT10 = load i32, ptr @DATA_NEXT, align 4
  %8 = getelementptr inbounds i32, ptr %6, i32 %DATA_NEXT10
  %9 = load i32, ptr %8, align 4
  %data11 = load [2048 x [2048 x i32]], ptr @data, align 4
  %env_ptr12 = load i32, ptr %env_ptr1, align 4
  %10 = getelementptr inbounds [2048 x i32], ptr @data, i32 %env_ptr12
  %11 = load [2048 x i32], ptr %10, align 4
  %DATA_VALUE = load i32, ptr @DATA_VALUE, align 4
  %12 = getelementptr inbounds i32, ptr %10, i32 %DATA_VALUE
  %13 = load i32, ptr %12, align 4
  store i32 %13, ptr %8, align 4
  %data13 = load [2048 x [2048 x i32]], ptr @data, align 4
  %env_ptr14 = load i32, ptr %env_ptr1, align 4
  %14 = getelementptr inbounds [2048 x i32], ptr @data, i32 %env_ptr14
  %15 = load [2048 x i32], ptr %14, align 4
  %DATA_VALUE15 = load i32, ptr @DATA_VALUE, align 4
  %16 = getelementptr inbounds i32, ptr %14, i32 %DATA_VALUE15
  %17 = load i32, ptr %16, align 4
  %pair16 = load i32, ptr %pair, align 4
  store i32 %pair16, ptr %16, align 4
  ret void
}

define i32 @env_get(i32 %env_ptr, i32 %sym_ptr) {
entry:
  %sym = alloca i32, align 4
  %pair = alloca i32, align 4
  %env_ptr1 = alloca i32, align 4
  store i32 %env_ptr, ptr %env_ptr1, align 4
  %sym_ptr2 = alloca i32, align 4
  store i32 %sym_ptr, ptr %sym_ptr2, align 4
  %data = load [2048 x [2048 x i32]], ptr @data, align 4
  %env_ptr3 = load i32, ptr %env_ptr1, align 4
  %0 = getelementptr inbounds [2048 x i32], ptr @data, i32 %env_ptr3
  %1 = load [2048 x i32], ptr %0, align 4
  %DATA_VALUE = load i32, ptr @DATA_VALUE, align 4
  %2 = getelementptr inbounds i32, ptr %0, i32 %DATA_VALUE
  %3 = load i32, ptr %2, align 4
  store i32 %3, ptr %pair, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %pair4 = load i32, ptr %pair, align 4
  %4 = icmp ne i32 %pair4, 0
  br i1 %4, label %for.body, label %for.last

for.body:                                         ; preds = %for.cond
  %data5 = load [2048 x [2048 x i32]], ptr @data, align 4
  %pair6 = load i32, ptr %pair, align 4
  %5 = getelementptr inbounds [2048 x i32], ptr @data, i32 %pair6
  %6 = load [2048 x i32], ptr %5, align 4
  %DATA_VALUE7 = load i32, ptr @DATA_VALUE, align 4
  %7 = getelementptr inbounds i32, ptr %5, i32 %DATA_VALUE7
  %8 = load i32, ptr %7, align 4
  store i32 %8, ptr %sym, align 4
  %sym_ptr8 = load i32, ptr %sym_ptr2, align 4
  %data9 = load [2048 x [2048 x i32]], ptr @data, align 4
  %sym10 = load i32, ptr %sym, align 4
  %9 = getelementptr inbounds [2048 x i32], ptr @data, i32 %sym10
  %10 = load [2048 x i32], ptr %9, align 4
  %DATA_VALUE11 = load i32, ptr @DATA_VALUE, align 4
  %11 = getelementptr inbounds i32, ptr %9, i32 %DATA_VALUE11
  %12 = load i32, ptr %11, align 4
  %13 = call i32 @is_eq_sym(i32 %sym_ptr8, i32 %12)
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %then, label %last

then:                                             ; preds = %for.body
  %pair12 = load i32, ptr %pair, align 4
  ret i32 %pair12

last:                                             ; preds = %for.body
  %pair13 = load i32, ptr %pair, align 4
  %data14 = load [2048 x [2048 x i32]], ptr @data, align 4
  %pair15 = load i32, ptr %pair, align 4
  %15 = getelementptr inbounds [2048 x i32], ptr @data, i32 %pair15
  %16 = load [2048 x i32], ptr %15, align 4
  %DATA_NEXT = load i32, ptr @DATA_NEXT, align 4
  %17 = getelementptr inbounds i32, ptr %15, i32 %DATA_NEXT
  %18 = load i32, ptr %17, align 4
  store i32 %18, ptr %pair, align 4
  br label %for.inc

for.inc:                                          ; preds = %last
  br label %for.cond

for.last:                                         ; preds = %for.cond
  ret i32 0
}

define void @env_set(i32 %env_ptr, i32 %sym_ptr, i32 %val_data_ptr) {
entry:
  %sym = alloca i32, align 4
  %pair = alloca i32, align 4
  %env_ptr1 = alloca i32, align 4
  store i32 %env_ptr, ptr %env_ptr1, align 4
  %sym_ptr2 = alloca i32, align 4
  store i32 %sym_ptr, ptr %sym_ptr2, align 4
  %val_data_ptr3 = alloca i32, align 4
  store i32 %val_data_ptr, ptr %val_data_ptr3, align 4
  %env_ptr4 = load i32, ptr %env_ptr1, align 4
  %sym_ptr5 = load i32, ptr %sym_ptr2, align 4
  %0 = call i32 @env_get(i32 %env_ptr4, i32 %sym_ptr5)
  store i32 %0, ptr %pair, align 4
  %pair6 = load i32, ptr %pair, align 4
  %1 = icmp ne i32 %pair6, 0
  br i1 %1, label %then, label %else

then:                                             ; preds = %entry
  %data = load [2048 x [2048 x i32]], ptr @data, align 4
  %pair7 = load i32, ptr %pair, align 4
  %2 = getelementptr inbounds [2048 x i32], ptr @data, i32 %pair7
  %3 = load [2048 x i32], ptr %2, align 4
  %DATA_VALUE = load i32, ptr @DATA_VALUE, align 4
  %4 = getelementptr inbounds i32, ptr %2, i32 %DATA_VALUE
  %5 = load i32, ptr %4, align 4
  store i32 %5, ptr %sym, align 4
  %data8 = load [2048 x [2048 x i32]], ptr @data, align 4
  %sym9 = load i32, ptr %sym, align 4
  %6 = getelementptr inbounds [2048 x i32], ptr @data, i32 %sym9
  %7 = load [2048 x i32], ptr %6, align 4
  %DATA_NEXT = load i32, ptr @DATA_NEXT, align 4
  %8 = getelementptr inbounds i32, ptr %6, i32 %DATA_NEXT
  %9 = load i32, ptr %8, align 4
  call void @free_data(i32 %9)
  %data10 = load [2048 x [2048 x i32]], ptr @data, align 4
  %sym11 = load i32, ptr %sym, align 4
  %10 = getelementptr inbounds [2048 x i32], ptr @data, i32 %sym11
  %11 = load [2048 x i32], ptr %10, align 4
  %DATA_NEXT12 = load i32, ptr @DATA_NEXT, align 4
  %12 = getelementptr inbounds i32, ptr %10, i32 %DATA_NEXT12
  %13 = load i32, ptr %12, align 4
  %val_data_ptr13 = load i32, ptr %val_data_ptr3, align 4
  store i32 %val_data_ptr13, ptr %12, align 4
  br label %last

else:                                             ; preds = %entry
  %env_ptr14 = load i32, ptr %env_ptr1, align 4
  %sym_ptr15 = load i32, ptr %sym_ptr2, align 4
  %val_data_ptr16 = load i32, ptr %val_data_ptr3, align 4
  call void @env_add(i32 %env_ptr14, i32 %sym_ptr15, i32 %val_data_ptr16)
  br label %last

last:                                             ; preds = %else, %then
  ret void
}

define i32 @env_find(i32 %env_ptr, i32 %sym_ptr) {
entry:
  %pair = alloca i32, align 4
  %env_ptr1 = alloca i32, align 4
  store i32 %env_ptr, ptr %env_ptr1, align 4
  %sym_ptr2 = alloca i32, align 4
  store i32 %sym_ptr, ptr %sym_ptr2, align 4
  %env_ptr3 = load i32, ptr %env_ptr1, align 4
  %0 = icmp ne i32 %env_ptr3, 0
  %1 = xor i1 %0, true
  %2 = zext i1 %1 to i32
  %3 = icmp ne i32 %2, 0
  br i1 %3, label %then, label %last

then:                                             ; preds = %entry
  ret i32 0

last:                                             ; preds = %entry
  %env_ptr4 = load i32, ptr %env_ptr1, align 4
  %sym_ptr5 = load i32, ptr %sym_ptr2, align 4
  %4 = call i32 @env_get(i32 %env_ptr4, i32 %sym_ptr5)
  store i32 %4, ptr %pair, align 4
  %pair6 = load i32, ptr %pair, align 4
  %5 = icmp ne i32 %pair6, 0
  br i1 %5, label %then7, label %last10

then7:                                            ; preds = %last
  %data = load [2048 x [2048 x i32]], ptr @data, align 4
  %data8 = load [2048 x [2048 x i32]], ptr @data, align 4
  %pair9 = load i32, ptr %pair, align 4
  %6 = getelementptr inbounds [2048 x i32], ptr @data, i32 %pair9
  %7 = load [2048 x i32], ptr %6, align 4
  %DATA_VALUE = load i32, ptr @DATA_VALUE, align 4
  %8 = getelementptr inbounds i32, ptr %6, i32 %DATA_VALUE
  %9 = load i32, ptr %8, align 4
  %10 = getelementptr inbounds [2048 x i32], ptr @data, i32 %9
  %11 = load [2048 x i32], ptr %10, align 4
  %DATA_NEXT = load i32, ptr @DATA_NEXT, align 4
  %12 = getelementptr inbounds i32, ptr %10, i32 %DATA_NEXT
  %13 = load i32, ptr %12, align 4
  ret i32 %13

last10:                                           ; preds = %last
  %data11 = load [2048 x [2048 x i32]], ptr @data, align 4
  %env_ptr12 = load i32, ptr %env_ptr1, align 4
  %14 = getelementptr inbounds [2048 x i32], ptr @data, i32 %env_ptr12
  %15 = load [2048 x i32], ptr %14, align 4
  %DATA_NEXT13 = load i32, ptr @DATA_NEXT, align 4
  %16 = getelementptr inbounds i32, ptr %14, i32 %DATA_NEXT13
  %17 = load i32, ptr %16, align 4
  %sym_ptr14 = load i32, ptr %sym_ptr2, align 4
  %18 = call i32 @env_find(i32 %17, i32 %sym_ptr14)
  ret i32 %18
}

define i32 @make_func(i32 %param_list_ptr, i32 %body_ptr, i32 %env_ptr) {
entry:
  %data_ptr = alloca i32, align 4
  %param_list_ptr1 = alloca i32, align 4
  store i32 %param_list_ptr, ptr %param_list_ptr1, align 4
  %body_ptr2 = alloca i32, align 4
  store i32 %body_ptr, ptr %body_ptr2, align 4
  %env_ptr3 = alloca i32, align 4
  store i32 %env_ptr, ptr %env_ptr3, align 4
  %0 = call i32 @alloc_data()
  store i32 %0, ptr %data_ptr, align 4
  %data = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr4 = load i32, ptr %data_ptr, align 4
  %1 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr4
  %2 = load [2048 x i32], ptr %1, align 4
  %DATA_TYPE = load i32, ptr @DATA_TYPE, align 4
  %3 = getelementptr inbounds i32, ptr %1, i32 %DATA_TYPE
  %4 = load i32, ptr %3, align 4
  %DATA_TYPE_FUNC = load i32, ptr @DATA_TYPE_FUNC, align 4
  store i32 %DATA_TYPE_FUNC, ptr %3, align 4
  %data5 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr6 = load i32, ptr %data_ptr, align 4
  %5 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr6
  %6 = load [2048 x i32], ptr %5, align 4
  %DATA_VALUE = load i32, ptr @DATA_VALUE, align 4
  %7 = getelementptr inbounds i32, ptr %5, i32 %DATA_VALUE
  %8 = load i32, ptr %7, align 4
  %param_list_ptr7 = load i32, ptr %param_list_ptr1, align 4
  store i32 %param_list_ptr7, ptr %7, align 4
  %data8 = load [2048 x [2048 x i32]], ptr @data, align 4
  %param_list_ptr9 = load i32, ptr %param_list_ptr1, align 4
  %9 = getelementptr inbounds [2048 x i32], ptr @data, i32 %param_list_ptr9
  %10 = load [2048 x i32], ptr %9, align 4
  %DATA_NEXT = load i32, ptr @DATA_NEXT, align 4
  %11 = getelementptr inbounds i32, ptr %9, i32 %DATA_NEXT
  %12 = load i32, ptr %11, align 4
  %body_ptr10 = load i32, ptr %body_ptr2, align 4
  store i32 %body_ptr10, ptr %11, align 4
  %data11 = load [2048 x [2048 x i32]], ptr @data, align 4
  %body_ptr12 = load i32, ptr %body_ptr2, align 4
  %13 = getelementptr inbounds [2048 x i32], ptr @data, i32 %body_ptr12
  %14 = load [2048 x i32], ptr %13, align 4
  %DATA_NEXT13 = load i32, ptr @DATA_NEXT, align 4
  %15 = getelementptr inbounds i32, ptr %13, i32 %DATA_NEXT13
  %16 = load i32, ptr %15, align 4
  %env_ptr14 = load i32, ptr %env_ptr3, align 4
  store i32 %env_ptr14, ptr %15, align 4
  %data_ptr15 = load i32, ptr %data_ptr, align 4
  ret i32 %data_ptr15
}

define i32 @is_space(i32 %c) {
entry:
  %c1 = alloca i32, align 4
  store i32 %c, ptr %c1, align 4
  %c2 = load i32, ptr %c1, align 4
  %0 = icmp eq i32 %c2, 32
  %1 = sext i1 %0 to i32
  %2 = icmp ne i32 %1, 0
  br i1 %2, label %trueBB, label %nextBB

nextBB:                                           ; preds = %entry
  %c3 = load i32, ptr %c1, align 4
  %3 = icmp eq i32 %c3, 9
  %4 = sext i1 %3 to i32
  %5 = icmp ne i32 %4, 0
  %6 = zext i1 %5 to i32
  br label %mergeBB

trueBB:                                           ; preds = %entry
  br label %mergeBB

mergeBB:                                          ; preds = %trueBB, %nextBB
  %7 = phi i32 [ %6, %nextBB ], [ 1, %trueBB ]
  %8 = icmp ne i32 %7, 0
  br i1 %8, label %trueBB6, label %nextBB4

nextBB4:                                          ; preds = %mergeBB
  %c5 = load i32, ptr %c1, align 4
  %9 = icmp eq i32 %c5, 10
  %10 = sext i1 %9 to i32
  %11 = icmp ne i32 %10, 0
  %12 = zext i1 %11 to i32
  br label %mergeBB7

trueBB6:                                          ; preds = %mergeBB
  br label %mergeBB7

mergeBB7:                                         ; preds = %trueBB6, %nextBB4
  %13 = phi i32 [ %12, %nextBB4 ], [ 1, %trueBB6 ]
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %trueBB10, label %nextBB8

nextBB8:                                          ; preds = %mergeBB7
  %c9 = load i32, ptr %c1, align 4
  %15 = icmp eq i32 %c9, 13
  %16 = sext i1 %15 to i32
  %17 = icmp ne i32 %16, 0
  %18 = zext i1 %17 to i32
  br label %mergeBB11

trueBB10:                                         ; preds = %mergeBB7
  br label %mergeBB11

mergeBB11:                                        ; preds = %trueBB10, %nextBB8
  %19 = phi i32 [ %18, %nextBB8 ], [ 1, %trueBB10 ]
  ret i32 %19
}

define i32 @is_digit(i32 %c) {
entry:
  %c1 = alloca i32, align 4
  store i32 %c, ptr %c1, align 4
  %c2 = load i32, ptr %c1, align 4
  %0 = icmp sge i32 %c2, 48
  %1 = sext i1 %0 to i32
  %2 = icmp ne i32 %1, 0
  br i1 %2, label %nextBB, label %falseBB

nextBB:                                           ; preds = %entry
  %c3 = load i32, ptr %c1, align 4
  %3 = icmp sle i32 %c3, 57
  %4 = sext i1 %3 to i32
  %5 = icmp ne i32 %4, 0
  %6 = zext i1 %5 to i32
  br label %mergeBB

falseBB:                                          ; preds = %entry
  br label %mergeBB

mergeBB:                                          ; preds = %falseBB, %nextBB
  %7 = phi i32 [ %6, %nextBB ], [ 0, %falseBB ]
  ret i32 %7
}

define i32 @next_token() {
entry:
  %sym_ptr = alloca i32, align 4
  %num = alloca i32, align 4
  %c = alloca i32, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %last_char = load i32, ptr @last_char, align 4
  %0 = call i32 @is_space(i32 %last_char)
  %1 = icmp ne i32 %0, 0
  br i1 %1, label %for.body, label %for.last

for.body:                                         ; preds = %for.cond
  %last_char1 = load i32, ptr @last_char, align 4
  %2 = call i32 @getch()
  store i32 %2, ptr @last_char, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br label %for.cond

for.last:                                         ; preds = %for.cond
  %last_char2 = load i32, ptr @last_char, align 4
  %3 = icmp eq i32 %last_char2, -1
  %4 = sext i1 %3 to i32
  %5 = icmp ne i32 %4, 0
  br i1 %5, label %then, label %last

then:                                             ; preds = %for.last
  %TOKEN_EOF = load i32, ptr @TOKEN_EOF, align 4
  ret i32 %TOKEN_EOF

last:                                             ; preds = %for.last
  %last_char3 = load i32, ptr @last_char, align 4
  %6 = icmp sge i32 %last_char3, 39
  %7 = sext i1 %6 to i32
  %8 = icmp ne i32 %7, 0
  br i1 %8, label %nextBB, label %falseBB

nextBB:                                           ; preds = %last
  %last_char4 = load i32, ptr @last_char, align 4
  %9 = icmp sle i32 %last_char4, 41
  %10 = sext i1 %9 to i32
  %11 = icmp ne i32 %10, 0
  %12 = zext i1 %11 to i32
  br label %mergeBB

falseBB:                                          ; preds = %last
  br label %mergeBB

mergeBB:                                          ; preds = %falseBB, %nextBB
  %13 = phi i32 [ %12, %nextBB ], [ 0, %falseBB ]
  %14 = icmp ne i32 %13, 0
  br i1 %14, label %then5, label %last9

then5:                                            ; preds = %mergeBB
  %last_char6 = load i32, ptr @last_char, align 4
  store i32 %last_char6, ptr %c, align 4
  %last_char7 = load i32, ptr @last_char, align 4
  %15 = call i32 @getch()
  store i32 %15, ptr @last_char, align 4
  %TOKEN_QUOTE = load i32, ptr @TOKEN_QUOTE, align 4
  %c8 = load i32, ptr %c, align 4
  %16 = add nsw i32 %TOKEN_QUOTE, %c8
  %17 = sub nsw i32 %16, 39
  ret i32 %17

last9:                                            ; preds = %mergeBB
  %last_char10 = load i32, ptr @last_char, align 4
  %18 = call i32 @is_digit(i32 %last_char10)
  %19 = icmp ne i32 %18, 0
  br i1 %19, label %then11, label %last22

then11:                                           ; preds = %last9
  store i32 0, ptr %num, align 4
  br label %for.cond12

for.cond12:                                       ; preds = %for.inc19, %then11
  %last_char13 = load i32, ptr @last_char, align 4
  %20 = call i32 @is_digit(i32 %last_char13)
  %21 = icmp ne i32 %20, 0
  br i1 %21, label %for.body14, label %for.last20

for.body14:                                       ; preds = %for.cond12
  %num15 = load i32, ptr %num, align 4
  %num16 = load i32, ptr %num, align 4
  %22 = mul nsw i32 %num16, 10
  %last_char17 = load i32, ptr @last_char, align 4
  %23 = add nsw i32 %22, %last_char17
  %24 = sub nsw i32 %23, 48
  store i32 %24, ptr %num, align 4
  %last_char18 = load i32, ptr @last_char, align 4
  %25 = call i32 @getch()
  store i32 %25, ptr @last_char, align 4
  br label %for.inc19

for.inc19:                                        ; preds = %for.body14
  br label %for.cond12

for.last20:                                       ; preds = %for.cond12
  %last_token = load i32, ptr @last_token, align 4
  %num21 = load i32, ptr %num, align 4
  store i32 %num21, ptr @last_token, align 4
  %TOKEN_NUMBER = load i32, ptr @TOKEN_NUMBER, align 4
  ret i32 %TOKEN_NUMBER

last22:                                           ; preds = %last9
  %next_sym = load i32, ptr @next_sym, align 4
  store i32 %next_sym, ptr %sym_ptr, align 4
  br label %for.cond23

for.cond23:                                       ; preds = %for.inc43, %last22
  %last_char24 = load i32, ptr @last_char, align 4
  %26 = icmp ne i32 %last_char24, -1
  %27 = sext i1 %26 to i32
  %28 = icmp ne i32 %27, 0
  br i1 %28, label %nextBB25, label %falseBB31

nextBB25:                                         ; preds = %for.cond23
  %last_char26 = load i32, ptr @last_char, align 4
  %29 = icmp sge i32 %last_char26, 39
  %30 = sext i1 %29 to i32
  %31 = icmp ne i32 %30, 0
  br i1 %31, label %nextBB27, label %falseBB29

nextBB27:                                         ; preds = %nextBB25
  %last_char28 = load i32, ptr @last_char, align 4
  %32 = icmp sle i32 %last_char28, 41
  %33 = sext i1 %32 to i32
  %34 = icmp ne i32 %33, 0
  %35 = zext i1 %34 to i32
  br label %mergeBB30

falseBB29:                                        ; preds = %nextBB25
  br label %mergeBB30

mergeBB30:                                        ; preds = %falseBB29, %nextBB27
  %36 = phi i32 [ %35, %nextBB27 ], [ 0, %falseBB29 ]
  %37 = icmp ne i32 %36, 0
  %38 = xor i1 %37, true
  %39 = zext i1 %38 to i32
  %40 = icmp ne i32 %39, 0
  %41 = zext i1 %40 to i32
  br label %mergeBB32

falseBB31:                                        ; preds = %for.cond23
  br label %mergeBB32

mergeBB32:                                        ; preds = %falseBB31, %mergeBB30
  %42 = phi i32 [ %41, %mergeBB30 ], [ 0, %falseBB31 ]
  %43 = icmp ne i32 %42, 0
  br i1 %43, label %nextBB33, label %falseBB35

nextBB33:                                         ; preds = %mergeBB32
  %last_char34 = load i32, ptr @last_char, align 4
  %44 = call i32 @is_space(i32 %last_char34)
  %45 = icmp ne i32 %44, 0
  %46 = xor i1 %45, true
  %47 = zext i1 %46 to i32
  %48 = icmp ne i32 %47, 0
  %49 = zext i1 %48 to i32
  br label %mergeBB36

falseBB35:                                        ; preds = %mergeBB32
  br label %mergeBB36

mergeBB36:                                        ; preds = %falseBB35, %nextBB33
  %50 = phi i32 [ %49, %nextBB33 ], [ 0, %falseBB35 ]
  %51 = icmp ne i32 %50, 0
  br i1 %51, label %for.body37, label %for.last44

for.body37:                                       ; preds = %mergeBB36
  %sym_buf = load [4096 x i32], ptr @sym_buf, align 4
  %next_sym38 = load i32, ptr @next_sym, align 4
  %52 = getelementptr inbounds i32, ptr @sym_buf, i32 %next_sym38
  %53 = load i32, ptr %52, align 4
  %last_char39 = load i32, ptr @last_char, align 4
  store i32 %last_char39, ptr %52, align 4
  %next_sym40 = load i32, ptr @next_sym, align 4
  %next_sym41 = load i32, ptr @next_sym, align 4
  %54 = add nsw i32 %next_sym41, 1
  store i32 %54, ptr @next_sym, align 4
  %last_char42 = load i32, ptr @last_char, align 4
  %55 = call i32 @getch()
  store i32 %55, ptr @last_char, align 4
  br label %for.inc43

for.inc43:                                        ; preds = %for.body37
  br label %for.cond23

for.last44:                                       ; preds = %mergeBB36
  %sym_buf45 = load [4096 x i32], ptr @sym_buf, align 4
  %next_sym46 = load i32, ptr @next_sym, align 4
  %56 = getelementptr inbounds i32, ptr @sym_buf, i32 %next_sym46
  %57 = load i32, ptr %56, align 4
  store i32 0, ptr %56, align 4
  %next_sym47 = load i32, ptr @next_sym, align 4
  %next_sym48 = load i32, ptr @next_sym, align 4
  %58 = add nsw i32 %next_sym48, 1
  store i32 %58, ptr @next_sym, align 4
  %next_sym49 = load i32, ptr @next_sym, align 4
  %MAX_SYM_BUF_LEN = load i32, ptr @MAX_SYM_BUF_LEN, align 4
  %59 = icmp sge i32 %next_sym49, %MAX_SYM_BUF_LEN
  %60 = sext i1 %59 to i32
  %61 = icmp ne i32 %60, 0
  br i1 %61, label %then50, label %last51

then50:                                           ; preds = %for.last44
  %ERR_BUFFER_OVERFLOW = load i32, ptr @ERR_BUFFER_OVERFLOW, align 4
  %62 = call i32 @panic(i32 %ERR_BUFFER_OVERFLOW)
  br label %last51

last51:                                           ; preds = %then50, %for.last44
  %last_token52 = load i32, ptr @last_token, align 4
  %sym_ptr53 = load i32, ptr %sym_ptr, align 4
  %63 = call i32 @is_predef_sym(i32 %sym_ptr53)
  store i32 %63, ptr @last_token, align 4
  %TOKEN_SYMBOL = load i32, ptr @TOKEN_SYMBOL, align 4
  ret i32 %TOKEN_SYMBOL
}

define i32 @parse() {
entry:
  %elem_ptr26 = alloca i32, align 4
  %cur_elem = alloca i32, align 4
  %list_ptr24 = alloca i32, align 4
  %list_ptr = alloca i32, align 4
  %quote_ptr = alloca i32, align 4
  %elem_ptr = alloca i32, align 4
  %data_ptr8 = alloca i32, align 4
  %data_ptr = alloca i32, align 4
  %last_token_type = load i32, ptr @last_token_type, align 4
  %TOKEN_EOF = load i32, ptr @TOKEN_EOF, align 4
  %0 = icmp eq i32 %last_token_type, %TOKEN_EOF
  %1 = sext i1 %0 to i32
  %2 = icmp ne i32 %1, 0
  br i1 %2, label %then, label %last

then:                                             ; preds = %entry
  ret i32 0

last:                                             ; preds = %entry
  %last_token_type1 = load i32, ptr @last_token_type, align 4
  %TOKEN_SYMBOL = load i32, ptr @TOKEN_SYMBOL, align 4
  %3 = icmp eq i32 %last_token_type1, %TOKEN_SYMBOL
  %4 = sext i1 %3 to i32
  %5 = icmp ne i32 %4, 0
  br i1 %5, label %then2, label %last5

then2:                                            ; preds = %last
  %last_token = load i32, ptr @last_token, align 4
  %6 = call i32 @make_symbol(i32 %last_token)
  store i32 %6, ptr %data_ptr, align 4
  %last_token_type3 = load i32, ptr @last_token_type, align 4
  %7 = call i32 @next_token()
  store i32 %7, ptr @last_token_type, align 4
  %data_ptr4 = load i32, ptr %data_ptr, align 4
  ret i32 %data_ptr4

last5:                                            ; preds = %last
  %last_token_type6 = load i32, ptr @last_token_type, align 4
  %TOKEN_NUMBER = load i32, ptr @TOKEN_NUMBER, align 4
  %8 = icmp eq i32 %last_token_type6, %TOKEN_NUMBER
  %9 = sext i1 %8 to i32
  %10 = icmp ne i32 %9, 0
  br i1 %10, label %then7, label %last12

then7:                                            ; preds = %last5
  %last_token9 = load i32, ptr @last_token, align 4
  %11 = call i32 @make_number(i32 %last_token9)
  store i32 %11, ptr %data_ptr8, align 4
  %last_token_type10 = load i32, ptr @last_token_type, align 4
  %12 = call i32 @next_token()
  store i32 %12, ptr @last_token_type, align 4
  %data_ptr11 = load i32, ptr %data_ptr8, align 4
  ret i32 %data_ptr11

last12:                                           ; preds = %last5
  %last_token_type13 = load i32, ptr @last_token_type, align 4
  %TOKEN_QUOTE = load i32, ptr @TOKEN_QUOTE, align 4
  %13 = icmp eq i32 %last_token_type13, %TOKEN_QUOTE
  %14 = sext i1 %13 to i32
  %15 = icmp ne i32 %14, 0
  br i1 %15, label %then14, label %last20

then14:                                           ; preds = %last12
  %last_token_type15 = load i32, ptr @last_token_type, align 4
  %16 = call i32 @next_token()
  store i32 %16, ptr @last_token_type, align 4
  %17 = call i32 @parse()
  store i32 %17, ptr %elem_ptr, align 4
  %SYM_QUOTE = load i32, ptr @SYM_QUOTE, align 4
  %18 = call i32 @make_symbol(i32 %SYM_QUOTE)
  store i32 %18, ptr %quote_ptr, align 4
  %data = load [2048 x [2048 x i32]], ptr @data, align 4
  %quote_ptr16 = load i32, ptr %quote_ptr, align 4
  %19 = getelementptr inbounds [2048 x i32], ptr @data, i32 %quote_ptr16
  %20 = load [2048 x i32], ptr %19, align 4
  %DATA_NEXT = load i32, ptr @DATA_NEXT, align 4
  %21 = getelementptr inbounds i32, ptr %19, i32 %DATA_NEXT
  %22 = load i32, ptr %21, align 4
  %elem_ptr17 = load i32, ptr %elem_ptr, align 4
  store i32 %elem_ptr17, ptr %21, align 4
  %quote_ptr18 = load i32, ptr %quote_ptr, align 4
  %23 = call i32 @make_list(i32 %quote_ptr18)
  store i32 %23, ptr %list_ptr, align 4
  %list_ptr19 = load i32, ptr %list_ptr, align 4
  ret i32 %list_ptr19

last20:                                           ; preds = %last12
  %last_token_type21 = load i32, ptr @last_token_type, align 4
  %TOKEN_LPAREN = load i32, ptr @TOKEN_LPAREN, align 4
  %24 = icmp eq i32 %last_token_type21, %TOKEN_LPAREN
  %25 = sext i1 %24 to i32
  %26 = icmp ne i32 %25, 0
  br i1 %26, label %then22, label %last41

then22:                                           ; preds = %last20
  %last_token_type23 = load i32, ptr @last_token_type, align 4
  %27 = call i32 @next_token()
  store i32 %27, ptr @last_token_type, align 4
  %28 = call i32 @make_list(i32 0)
  store i32 %28, ptr %list_ptr24, align 4
  store i32 0, ptr %cur_elem, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %then22
  %last_token_type25 = load i32, ptr @last_token_type, align 4
  %TOKEN_RPAREN = load i32, ptr @TOKEN_RPAREN, align 4
  %29 = icmp ne i32 %last_token_type25, %TOKEN_RPAREN
  %30 = sext i1 %29 to i32
  %31 = icmp ne i32 %30, 0
  br i1 %31, label %for.body, label %for.last

for.body:                                         ; preds = %for.cond
  %32 = call i32 @parse()
  store i32 %32, ptr %elem_ptr26, align 4
  %cur_elem27 = load i32, ptr %cur_elem, align 4
  %33 = icmp ne i32 %cur_elem27, 0
  br i1 %33, label %then28, label %else

then28:                                           ; preds = %for.body
  %data29 = load [2048 x [2048 x i32]], ptr @data, align 4
  %cur_elem30 = load i32, ptr %cur_elem, align 4
  %34 = getelementptr inbounds [2048 x i32], ptr @data, i32 %cur_elem30
  %35 = load [2048 x i32], ptr %34, align 4
  %DATA_NEXT31 = load i32, ptr @DATA_NEXT, align 4
  %36 = getelementptr inbounds i32, ptr %34, i32 %DATA_NEXT31
  %37 = load i32, ptr %36, align 4
  %elem_ptr32 = load i32, ptr %elem_ptr26, align 4
  store i32 %elem_ptr32, ptr %36, align 4
  br label %last36

else:                                             ; preds = %for.body
  %data33 = load [2048 x [2048 x i32]], ptr @data, align 4
  %list_ptr34 = load i32, ptr %list_ptr24, align 4
  %38 = getelementptr inbounds [2048 x i32], ptr @data, i32 %list_ptr34
  %39 = load [2048 x i32], ptr %38, align 4
  %DATA_VALUE = load i32, ptr @DATA_VALUE, align 4
  %40 = getelementptr inbounds i32, ptr %38, i32 %DATA_VALUE
  %41 = load i32, ptr %40, align 4
  %elem_ptr35 = load i32, ptr %elem_ptr26, align 4
  store i32 %elem_ptr35, ptr %40, align 4
  br label %last36

last36:                                           ; preds = %else, %then28
  %cur_elem37 = load i32, ptr %cur_elem, align 4
  %elem_ptr38 = load i32, ptr %elem_ptr26, align 4
  store i32 %elem_ptr38, ptr %cur_elem, align 4
  br label %for.inc

for.inc:                                          ; preds = %last36
  br label %for.cond

for.last:                                         ; preds = %for.cond
  %last_token_type39 = load i32, ptr @last_token_type, align 4
  %42 = call i32 @next_token()
  store i32 %42, ptr @last_token_type, align 4
  %list_ptr40 = load i32, ptr %list_ptr24, align 4
  ret i32 %list_ptr40

last41:                                           ; preds = %last20
  %ERR_PARSE_ERROR = load i32, ptr @ERR_PARSE_ERROR, align 4
  %43 = call i32 @panic(i32 %ERR_PARSE_ERROR)
  ret i32 %43
}

define i32 @make_bool(i32 %value) {
entry:
  %data_ptr = alloca i32, align 4
  %value1 = alloca i32, align 4
  store i32 %value, ptr %value1, align 4
  %0 = call i32 @alloc_data()
  store i32 %0, ptr %data_ptr, align 4
  %data = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr2 = load i32, ptr %data_ptr, align 4
  %1 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr2
  %2 = load [2048 x i32], ptr %1, align 4
  %DATA_TYPE = load i32, ptr @DATA_TYPE, align 4
  %3 = getelementptr inbounds i32, ptr %1, i32 %DATA_TYPE
  %4 = load i32, ptr %3, align 4
  %DATA_TYPE_SYMBOL = load i32, ptr @DATA_TYPE_SYMBOL, align 4
  store i32 %DATA_TYPE_SYMBOL, ptr %3, align 4
  %value3 = load i32, ptr %value1, align 4
  %5 = icmp ne i32 %value3, 0
  br i1 %5, label %then, label %else

then:                                             ; preds = %entry
  %data4 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr5 = load i32, ptr %data_ptr, align 4
  %6 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr5
  %7 = load [2048 x i32], ptr %6, align 4
  %DATA_VALUE = load i32, ptr @DATA_VALUE, align 4
  %8 = getelementptr inbounds i32, ptr %6, i32 %DATA_VALUE
  %9 = load i32, ptr %8, align 4
  %SYM_T = load i32, ptr @SYM_T, align 4
  store i32 %SYM_T, ptr %8, align 4
  br label %last

else:                                             ; preds = %entry
  %data6 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr7 = load i32, ptr %data_ptr, align 4
  %10 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr7
  %11 = load [2048 x i32], ptr %10, align 4
  %DATA_VALUE8 = load i32, ptr @DATA_VALUE, align 4
  %12 = getelementptr inbounds i32, ptr %10, i32 %DATA_VALUE8
  %13 = load i32, ptr %12, align 4
  %SYM_F = load i32, ptr @SYM_F, align 4
  store i32 %SYM_F, ptr %12, align 4
  br label %last

last:                                             ; preds = %else, %then
  %data_ptr9 = load i32, ptr %data_ptr, align 4
  ret i32 %data_ptr9
}

define i32 @is_true(i32 %bool_ptr) {
entry:
  %bool_ptr1 = alloca i32, align 4
  store i32 %bool_ptr, ptr %bool_ptr1, align 4
  %bool_ptr2 = load i32, ptr %bool_ptr1, align 4
  %0 = icmp ne i32 %bool_ptr2, 0
  %1 = xor i1 %0, true
  %2 = zext i1 %1 to i32
  %3 = icmp ne i32 %2, 0
  br i1 %3, label %then, label %last

then:                                             ; preds = %entry
  ret i32 1

last:                                             ; preds = %entry
  %data = load [2048 x [2048 x i32]], ptr @data, align 4
  %bool_ptr3 = load i32, ptr %bool_ptr1, align 4
  %4 = getelementptr inbounds [2048 x i32], ptr @data, i32 %bool_ptr3
  %5 = load [2048 x i32], ptr %4, align 4
  %DATA_TYPE = load i32, ptr @DATA_TYPE, align 4
  %6 = getelementptr inbounds i32, ptr %4, i32 %DATA_TYPE
  %7 = load i32, ptr %6, align 4
  %DATA_TYPE_SYMBOL = load i32, ptr @DATA_TYPE_SYMBOL, align 4
  %8 = icmp ne i32 %7, %DATA_TYPE_SYMBOL
  %9 = sext i1 %8 to i32
  %10 = icmp ne i32 %9, 0
  br i1 %10, label %then4, label %last5

then4:                                            ; preds = %last
  %ERR_TYPE_MISMATCH = load i32, ptr @ERR_TYPE_MISMATCH, align 4
  %11 = call i32 @panic(i32 %ERR_TYPE_MISMATCH)
  br label %last5

last5:                                            ; preds = %then4, %last
  %data6 = load [2048 x [2048 x i32]], ptr @data, align 4
  %bool_ptr7 = load i32, ptr %bool_ptr1, align 4
  %12 = getelementptr inbounds [2048 x i32], ptr @data, i32 %bool_ptr7
  %13 = load [2048 x i32], ptr %12, align 4
  %DATA_VALUE = load i32, ptr @DATA_VALUE, align 4
  %14 = getelementptr inbounds i32, ptr %12, i32 %DATA_VALUE
  %15 = load i32, ptr %14, align 4
  %SYM_T = load i32, ptr @SYM_T, align 4
  %16 = icmp eq i32 %15, %SYM_T
  %17 = sext i1 %16 to i32
  %18 = icmp ne i32 %17, 0
  br i1 %18, label %then8, label %last9

then8:                                            ; preds = %last5
  ret i32 1

last9:                                            ; preds = %last5
  %data10 = load [2048 x [2048 x i32]], ptr @data, align 4
  %bool_ptr11 = load i32, ptr %bool_ptr1, align 4
  %19 = getelementptr inbounds [2048 x i32], ptr @data, i32 %bool_ptr11
  %20 = load [2048 x i32], ptr %19, align 4
  %DATA_VALUE12 = load i32, ptr @DATA_VALUE, align 4
  %21 = getelementptr inbounds i32, ptr %19, i32 %DATA_VALUE12
  %22 = load i32, ptr %21, align 4
  %SYM_F = load i32, ptr @SYM_F, align 4
  %23 = icmp eq i32 %22, %SYM_F
  %24 = sext i1 %23 to i32
  %25 = icmp ne i32 %24, 0
  br i1 %25, label %then13, label %last14

then13:                                           ; preds = %last9
  ret i32 0

last14:                                           ; preds = %last9
  %ERR_TYPE_MISMATCH15 = load i32, ptr @ERR_TYPE_MISMATCH, align 4
  %26 = call i32 @panic(i32 %ERR_TYPE_MISMATCH15)
  ret i32 %26
}

define i32 @is_equal(i32 %val1, i32 %val2) {
entry:
  %list2 = alloca i32, align 4
  %list1 = alloca i32, align 4
  %val11 = alloca i32, align 4
  store i32 %val1, ptr %val11, align 4
  %val22 = alloca i32, align 4
  store i32 %val2, ptr %val22, align 4
  %val13 = load i32, ptr %val11, align 4
  %val24 = load i32, ptr %val22, align 4
  %0 = icmp eq i32 %val13, %val24
  %1 = sext i1 %0 to i32
  %2 = icmp ne i32 %1, 0
  br i1 %2, label %then, label %last

then:                                             ; preds = %entry
  ret i32 1

last:                                             ; preds = %entry
  %val15 = load i32, ptr %val11, align 4
  %3 = icmp ne i32 %val15, 0
  %4 = xor i1 %3, true
  %5 = zext i1 %4 to i32
  %6 = icmp ne i32 %5, 0
  br i1 %6, label %trueBB, label %nextBB

nextBB:                                           ; preds = %last
  %val26 = load i32, ptr %val22, align 4
  %7 = icmp ne i32 %val26, 0
  %8 = xor i1 %7, true
  %9 = zext i1 %8 to i32
  %10 = icmp ne i32 %9, 0
  %11 = zext i1 %10 to i32
  br label %mergeBB

trueBB:                                           ; preds = %last
  br label %mergeBB

mergeBB:                                          ; preds = %trueBB, %nextBB
  %12 = phi i32 [ %11, %nextBB ], [ 1, %trueBB ]
  %13 = icmp ne i32 %12, 0
  br i1 %13, label %then7, label %last8

then7:                                            ; preds = %mergeBB
  ret i32 0

last8:                                            ; preds = %mergeBB
  %data = load [2048 x [2048 x i32]], ptr @data, align 4
  %val19 = load i32, ptr %val11, align 4
  %14 = getelementptr inbounds [2048 x i32], ptr @data, i32 %val19
  %15 = load [2048 x i32], ptr %14, align 4
  %DATA_TYPE = load i32, ptr @DATA_TYPE, align 4
  %16 = getelementptr inbounds i32, ptr %14, i32 %DATA_TYPE
  %17 = load i32, ptr %16, align 4
  %data10 = load [2048 x [2048 x i32]], ptr @data, align 4
  %val211 = load i32, ptr %val22, align 4
  %18 = getelementptr inbounds [2048 x i32], ptr @data, i32 %val211
  %19 = load [2048 x i32], ptr %18, align 4
  %DATA_TYPE12 = load i32, ptr @DATA_TYPE, align 4
  %20 = getelementptr inbounds i32, ptr %18, i32 %DATA_TYPE12
  %21 = load i32, ptr %20, align 4
  %22 = icmp ne i32 %17, %21
  %23 = sext i1 %22 to i32
  %24 = icmp ne i32 %23, 0
  br i1 %24, label %then13, label %last14

then13:                                           ; preds = %last8
  ret i32 0

last14:                                           ; preds = %last8
  %data15 = load [2048 x [2048 x i32]], ptr @data, align 4
  %val116 = load i32, ptr %val11, align 4
  %25 = getelementptr inbounds [2048 x i32], ptr @data, i32 %val116
  %26 = load [2048 x i32], ptr %25, align 4
  %DATA_TYPE17 = load i32, ptr @DATA_TYPE, align 4
  %27 = getelementptr inbounds i32, ptr %25, i32 %DATA_TYPE17
  %28 = load i32, ptr %27, align 4
  %DATA_TYPE_SYMBOL = load i32, ptr @DATA_TYPE_SYMBOL, align 4
  %29 = icmp eq i32 %28, %DATA_TYPE_SYMBOL
  %30 = sext i1 %29 to i32
  %31 = icmp ne i32 %30, 0
  br i1 %31, label %then18, label %last24

then18:                                           ; preds = %last14
  %data19 = load [2048 x [2048 x i32]], ptr @data, align 4
  %val120 = load i32, ptr %val11, align 4
  %32 = getelementptr inbounds [2048 x i32], ptr @data, i32 %val120
  %33 = load [2048 x i32], ptr %32, align 4
  %DATA_VALUE = load i32, ptr @DATA_VALUE, align 4
  %34 = getelementptr inbounds i32, ptr %32, i32 %DATA_VALUE
  %35 = load i32, ptr %34, align 4
  %data21 = load [2048 x [2048 x i32]], ptr @data, align 4
  %val222 = load i32, ptr %val22, align 4
  %36 = getelementptr inbounds [2048 x i32], ptr @data, i32 %val222
  %37 = load [2048 x i32], ptr %36, align 4
  %DATA_VALUE23 = load i32, ptr @DATA_VALUE, align 4
  %38 = getelementptr inbounds i32, ptr %36, i32 %DATA_VALUE23
  %39 = load i32, ptr %38, align 4
  %40 = call i32 @is_eq_sym(i32 %35, i32 %39)
  ret i32 %40

last24:                                           ; preds = %last14
  %data25 = load [2048 x [2048 x i32]], ptr @data, align 4
  %val126 = load i32, ptr %val11, align 4
  %41 = getelementptr inbounds [2048 x i32], ptr @data, i32 %val126
  %42 = load [2048 x i32], ptr %41, align 4
  %DATA_TYPE27 = load i32, ptr @DATA_TYPE, align 4
  %43 = getelementptr inbounds i32, ptr %41, i32 %DATA_TYPE27
  %44 = load i32, ptr %43, align 4
  %DATA_TYPE_NUMBER = load i32, ptr @DATA_TYPE_NUMBER, align 4
  %45 = icmp eq i32 %44, %DATA_TYPE_NUMBER
  %46 = sext i1 %45 to i32
  %47 = icmp ne i32 %46, 0
  br i1 %47, label %then28, label %last35

then28:                                           ; preds = %last24
  %data29 = load [2048 x [2048 x i32]], ptr @data, align 4
  %val130 = load i32, ptr %val11, align 4
  %48 = getelementptr inbounds [2048 x i32], ptr @data, i32 %val130
  %49 = load [2048 x i32], ptr %48, align 4
  %DATA_VALUE31 = load i32, ptr @DATA_VALUE, align 4
  %50 = getelementptr inbounds i32, ptr %48, i32 %DATA_VALUE31
  %51 = load i32, ptr %50, align 4
  %data32 = load [2048 x [2048 x i32]], ptr @data, align 4
  %val233 = load i32, ptr %val22, align 4
  %52 = getelementptr inbounds [2048 x i32], ptr @data, i32 %val233
  %53 = load [2048 x i32], ptr %52, align 4
  %DATA_VALUE34 = load i32, ptr @DATA_VALUE, align 4
  %54 = getelementptr inbounds i32, ptr %52, i32 %DATA_VALUE34
  %55 = load i32, ptr %54, align 4
  %56 = icmp eq i32 %51, %55
  %57 = sext i1 %56 to i32
  ret i32 %57

last35:                                           ; preds = %last24
  %data36 = load [2048 x [2048 x i32]], ptr @data, align 4
  %val137 = load i32, ptr %val11, align 4
  %58 = getelementptr inbounds [2048 x i32], ptr @data, i32 %val137
  %59 = load [2048 x i32], ptr %58, align 4
  %DATA_TYPE38 = load i32, ptr @DATA_TYPE, align 4
  %60 = getelementptr inbounds i32, ptr %58, i32 %DATA_TYPE38
  %61 = load i32, ptr %60, align 4
  %DATA_TYPE_LIST = load i32, ptr @DATA_TYPE_LIST, align 4
  %62 = icmp eq i32 %61, %DATA_TYPE_LIST
  %63 = sext i1 %62 to i32
  %64 = icmp ne i32 %63, 0
  br i1 %64, label %then39, label %last68

then39:                                           ; preds = %last35
  %data40 = load [2048 x [2048 x i32]], ptr @data, align 4
  %val141 = load i32, ptr %val11, align 4
  %65 = getelementptr inbounds [2048 x i32], ptr @data, i32 %val141
  %66 = load [2048 x i32], ptr %65, align 4
  %DATA_VALUE42 = load i32, ptr @DATA_VALUE, align 4
  %67 = getelementptr inbounds i32, ptr %65, i32 %DATA_VALUE42
  %68 = load i32, ptr %67, align 4
  store i32 %68, ptr %list1, align 4
  %data43 = load [2048 x [2048 x i32]], ptr @data, align 4
  %val244 = load i32, ptr %val22, align 4
  %69 = getelementptr inbounds [2048 x i32], ptr @data, i32 %val244
  %70 = load [2048 x i32], ptr %69, align 4
  %DATA_VALUE45 = load i32, ptr @DATA_VALUE, align 4
  %71 = getelementptr inbounds i32, ptr %69, i32 %DATA_VALUE45
  %72 = load i32, ptr %71, align 4
  store i32 %72, ptr %list2, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %then39
  %list146 = load i32, ptr %list1, align 4
  %73 = icmp ne i32 %list146, 0
  br i1 %73, label %nextBB47, label %falseBB

nextBB47:                                         ; preds = %for.cond
  %list248 = load i32, ptr %list2, align 4
  %74 = icmp ne i32 %list248, 0
  %75 = zext i1 %74 to i32
  br label %mergeBB49

falseBB:                                          ; preds = %for.cond
  br label %mergeBB49

mergeBB49:                                        ; preds = %falseBB, %nextBB47
  %76 = phi i32 [ %75, %nextBB47 ], [ 0, %falseBB ]
  %77 = icmp ne i32 %76, 0
  br i1 %77, label %for.body, label %for.last

for.body:                                         ; preds = %mergeBB49
  %list150 = load i32, ptr %list1, align 4
  %list251 = load i32, ptr %list2, align 4
  %78 = call i32 @is_equal(i32 %list150, i32 %list251)
  %79 = icmp ne i32 %78, 0
  %80 = xor i1 %79, true
  %81 = zext i1 %80 to i32
  %82 = icmp ne i32 %81, 0
  br i1 %82, label %then52, label %last53

then52:                                           ; preds = %for.body
  ret i32 0

last53:                                           ; preds = %for.body
  %list154 = load i32, ptr %list1, align 4
  %data55 = load [2048 x [2048 x i32]], ptr @data, align 4
  %list156 = load i32, ptr %list1, align 4
  %83 = getelementptr inbounds [2048 x i32], ptr @data, i32 %list156
  %84 = load [2048 x i32], ptr %83, align 4
  %DATA_NEXT = load i32, ptr @DATA_NEXT, align 4
  %85 = getelementptr inbounds i32, ptr %83, i32 %DATA_NEXT
  %86 = load i32, ptr %85, align 4
  store i32 %86, ptr %list1, align 4
  %list257 = load i32, ptr %list2, align 4
  %data58 = load [2048 x [2048 x i32]], ptr @data, align 4
  %list259 = load i32, ptr %list2, align 4
  %87 = getelementptr inbounds [2048 x i32], ptr @data, i32 %list259
  %88 = load [2048 x i32], ptr %87, align 4
  %DATA_NEXT60 = load i32, ptr @DATA_NEXT, align 4
  %89 = getelementptr inbounds i32, ptr %87, i32 %DATA_NEXT60
  %90 = load i32, ptr %89, align 4
  store i32 %90, ptr %list2, align 4
  br label %for.inc

for.inc:                                          ; preds = %last53
  br label %for.cond

for.last:                                         ; preds = %mergeBB49
  %list161 = load i32, ptr %list1, align 4
  %91 = icmp ne i32 %list161, 0
  br i1 %91, label %trueBB64, label %nextBB62

nextBB62:                                         ; preds = %for.last
  %list263 = load i32, ptr %list2, align 4
  %92 = icmp ne i32 %list263, 0
  %93 = zext i1 %92 to i32
  br label %mergeBB65

trueBB64:                                         ; preds = %for.last
  br label %mergeBB65

mergeBB65:                                        ; preds = %trueBB64, %nextBB62
  %94 = phi i32 [ %93, %nextBB62 ], [ 1, %trueBB64 ]
  %95 = icmp ne i32 %94, 0
  br i1 %95, label %then66, label %last67

then66:                                           ; preds = %mergeBB65
  ret i32 0

last67:                                           ; preds = %mergeBB65
  ret i32 1

last68:                                           ; preds = %last35
  %ERR_TYPE_MISMATCH = load i32, ptr @ERR_TYPE_MISMATCH, align 4
  %96 = call i32 @panic(i32 %ERR_TYPE_MISMATCH)
  ret i32 %96
}

define i32 @unwrap_list(i32 %list_ptr) {
entry:
  %list_ptr1 = alloca i32, align 4
  store i32 %list_ptr, ptr %list_ptr1, align 4
  %data = load [2048 x [2048 x i32]], ptr @data, align 4
  %list_ptr2 = load i32, ptr %list_ptr1, align 4
  %0 = getelementptr inbounds [2048 x i32], ptr @data, i32 %list_ptr2
  %1 = load [2048 x i32], ptr %0, align 4
  %DATA_TYPE = load i32, ptr @DATA_TYPE, align 4
  %2 = getelementptr inbounds i32, ptr %0, i32 %DATA_TYPE
  %3 = load i32, ptr %2, align 4
  %DATA_TYPE_LIST = load i32, ptr @DATA_TYPE_LIST, align 4
  %4 = icmp ne i32 %3, %DATA_TYPE_LIST
  %5 = sext i1 %4 to i32
  %6 = icmp ne i32 %5, 0
  br i1 %6, label %then, label %last

then:                                             ; preds = %entry
  %ERR_TYPE_MISMATCH = load i32, ptr @ERR_TYPE_MISMATCH, align 4
  %7 = call i32 @panic(i32 %ERR_TYPE_MISMATCH)
  br label %last

last:                                             ; preds = %then, %entry
  %data3 = load [2048 x [2048 x i32]], ptr @data, align 4
  %list_ptr4 = load i32, ptr %list_ptr1, align 4
  %8 = getelementptr inbounds [2048 x i32], ptr @data, i32 %list_ptr4
  %9 = load [2048 x i32], ptr %8, align 4
  %DATA_VALUE = load i32, ptr @DATA_VALUE, align 4
  %10 = getelementptr inbounds i32, ptr %8, i32 %DATA_VALUE
  %11 = load i32, ptr %10, align 4
  ret i32 %11
}

define i32 @unwrap_symbol(i32 %sym_ptr) {
entry:
  %sym_ptr1 = alloca i32, align 4
  store i32 %sym_ptr, ptr %sym_ptr1, align 4
  %data = load [2048 x [2048 x i32]], ptr @data, align 4
  %sym_ptr2 = load i32, ptr %sym_ptr1, align 4
  %0 = getelementptr inbounds [2048 x i32], ptr @data, i32 %sym_ptr2
  %1 = load [2048 x i32], ptr %0, align 4
  %DATA_TYPE = load i32, ptr @DATA_TYPE, align 4
  %2 = getelementptr inbounds i32, ptr %0, i32 %DATA_TYPE
  %3 = load i32, ptr %2, align 4
  %DATA_TYPE_SYMBOL = load i32, ptr @DATA_TYPE_SYMBOL, align 4
  %4 = icmp ne i32 %3, %DATA_TYPE_SYMBOL
  %5 = sext i1 %4 to i32
  %6 = icmp ne i32 %5, 0
  br i1 %6, label %then, label %last

then:                                             ; preds = %entry
  %ERR_TYPE_MISMATCH = load i32, ptr @ERR_TYPE_MISMATCH, align 4
  %7 = call i32 @panic(i32 %ERR_TYPE_MISMATCH)
  br label %last

last:                                             ; preds = %then, %entry
  %data3 = load [2048 x [2048 x i32]], ptr @data, align 4
  %sym_ptr4 = load i32, ptr %sym_ptr1, align 4
  %8 = getelementptr inbounds [2048 x i32], ptr @data, i32 %sym_ptr4
  %9 = load [2048 x i32], ptr %8, align 4
  %DATA_VALUE = load i32, ptr @DATA_VALUE, align 4
  %10 = getelementptr inbounds i32, ptr %8, i32 %DATA_VALUE
  %11 = load i32, ptr %10, align 4
  ret i32 %11
}

define i32 @unwrap_number(i32 %num_ptr) {
entry:
  %num_ptr1 = alloca i32, align 4
  store i32 %num_ptr, ptr %num_ptr1, align 4
  %data = load [2048 x [2048 x i32]], ptr @data, align 4
  %num_ptr2 = load i32, ptr %num_ptr1, align 4
  %0 = getelementptr inbounds [2048 x i32], ptr @data, i32 %num_ptr2
  %1 = load [2048 x i32], ptr %0, align 4
  %DATA_TYPE = load i32, ptr @DATA_TYPE, align 4
  %2 = getelementptr inbounds i32, ptr %0, i32 %DATA_TYPE
  %3 = load i32, ptr %2, align 4
  %DATA_TYPE_NUMBER = load i32, ptr @DATA_TYPE_NUMBER, align 4
  %4 = icmp ne i32 %3, %DATA_TYPE_NUMBER
  %5 = sext i1 %4 to i32
  %6 = icmp ne i32 %5, 0
  br i1 %6, label %then, label %last

then:                                             ; preds = %entry
  %ERR_TYPE_MISMATCH = load i32, ptr @ERR_TYPE_MISMATCH, align 4
  %7 = call i32 @panic(i32 %ERR_TYPE_MISMATCH)
  br label %last

last:                                             ; preds = %then, %entry
  %data3 = load [2048 x [2048 x i32]], ptr @data, align 4
  %num_ptr4 = load i32, ptr %num_ptr1, align 4
  %8 = getelementptr inbounds [2048 x i32], ptr @data, i32 %num_ptr4
  %9 = load [2048 x i32], ptr %8, align 4
  %DATA_VALUE = load i32, ptr @DATA_VALUE, align 4
  %10 = getelementptr inbounds i32, ptr %8, i32 %DATA_VALUE
  %11 = load i32, ptr %10, align 4
  ret i32 %11
}

define i32 @eval(i32 %data_ptr, i32 %env_ptr) {
entry:
  %result_ptr422 = alloca i32, align 4
  %rhs = alloca i32, align 4
  %lhs = alloca i32, align 4
  %value2_ptr417 = alloca i32, align 4
  %value1_ptr414 = alloca i32, align 4
  %arg2_ptr396 = alloca i32, align 4
  %elem_ptr = alloca i32, align 4
  %value_ptr370 = alloca i32, align 4
  %cur_ptr366 = alloca i32, align 4
  %result_ptr365 = alloca i32, align 4
  %value_ptr356 = alloca i32, align 4
  %sym_ptr354 = alloca i32, align 4
  %arg2_ptr336 = alloca i32, align 4
  %result_ptr328 = alloca i32, align 4
  %arg2_ptr310 = alloca i32, align 4
  %body_result_ptr = alloca i32, align 4
  %body_ptr291 = alloca i32, align 4
  %result_ptr286 = alloca i32, align 4
  %test_ptr = alloca i32, align 4
  %cur_ptr = alloca i32, align 4
  %result_ptr273 = alloca i32, align 4
  %head_ptr267 = alloca i32, align 4
  %value2_ptr264 = alloca i32, align 4
  %value1_ptr261 = alloca i32, align 4
  %arg2_ptr243 = alloca i32, align 4
  %result_ptr234 = alloca i32, align 4
  %head_ptr228 = alloca i32, align 4
  %value_ptr225 = alloca i32, align 4
  %result_ptr204 = alloca i32, align 4
  %value_ptr201 = alloca i32, align 4
  %result_ptr182 = alloca i32, align 4
  %value2_ptr = alloca i32, align 4
  %value1_ptr = alloca i32, align 4
  %arg2_ptr = alloca i32, align 4
  %result_ptr151 = alloca i32, align 4
  %value_ptr148 = alloca i32, align 4
  %result_ptr128 = alloca i32, align 4
  %value_ptr = alloca i32, align 4
  %sym_ptr = alloca i32, align 4
  %result_ptr = alloca i32, align 4
  %arg_ptr70 = alloca i32, align 4
  %param_sym_ptr = alloca i32, align 4
  %cur_arg_ptr = alloca i32, align 4
  %cur_param_ptr = alloca i32, align 4
  %func_env_ptr = alloca i32, align 4
  %outer_ptr = alloca i32, align 4
  %body_ptr = alloca i32, align 4
  %param_list_ptr = alloca i32, align 4
  %func_ptr = alloca i32, align 4
  %arg_ptr = alloca i32, align 4
  %head_ptr = alloca i32, align 4
  %val_ptr = alloca i32, align 4
  %data_ptr1 = alloca i32, align 4
  store i32 %data_ptr, ptr %data_ptr1, align 4
  %env_ptr2 = alloca i32, align 4
  store i32 %env_ptr, ptr %env_ptr2, align 4
  %data = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr3 = load i32, ptr %data_ptr1, align 4
  %0 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr3
  %1 = load [2048 x i32], ptr %0, align 4
  %DATA_TYPE = load i32, ptr @DATA_TYPE, align 4
  %2 = getelementptr inbounds i32, ptr %0, i32 %DATA_TYPE
  %3 = load i32, ptr %2, align 4
  %DATA_TYPE_SYMBOL = load i32, ptr @DATA_TYPE_SYMBOL, align 4
  %4 = icmp eq i32 %3, %DATA_TYPE_SYMBOL
  %5 = sext i1 %4 to i32
  %6 = icmp ne i32 %5, 0
  br i1 %6, label %then, label %last10

then:                                             ; preds = %entry
  %env_ptr4 = load i32, ptr %env_ptr2, align 4
  %data5 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr6 = load i32, ptr %data_ptr1, align 4
  %7 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr6
  %8 = load [2048 x i32], ptr %7, align 4
  %DATA_VALUE = load i32, ptr @DATA_VALUE, align 4
  %9 = getelementptr inbounds i32, ptr %7, i32 %DATA_VALUE
  %10 = load i32, ptr %9, align 4
  %11 = call i32 @env_find(i32 %env_ptr4, i32 %10)
  store i32 %11, ptr %val_ptr, align 4
  %val_ptr7 = load i32, ptr %val_ptr, align 4
  %12 = icmp ne i32 %val_ptr7, 0
  %13 = xor i1 %12, true
  %14 = zext i1 %13 to i32
  %15 = icmp ne i32 %14, 0
  br i1 %15, label %then8, label %last

then8:                                            ; preds = %then
  %ERR_SYMBOL_NOT_FOUND = load i32, ptr @ERR_SYMBOL_NOT_FOUND, align 4
  %16 = call i32 @panic(i32 %ERR_SYMBOL_NOT_FOUND)
  br label %last

last:                                             ; preds = %then8, %then
  %val_ptr9 = load i32, ptr %val_ptr, align 4
  %17 = call i32 @copy_ptr(i32 %val_ptr9)
  ret i32 %17

last10:                                           ; preds = %entry
  %data11 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr12 = load i32, ptr %data_ptr1, align 4
  %18 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr12
  %19 = load [2048 x i32], ptr %18, align 4
  %DATA_TYPE13 = load i32, ptr @DATA_TYPE, align 4
  %20 = getelementptr inbounds i32, ptr %18, i32 %DATA_TYPE13
  %21 = load i32, ptr %20, align 4
  %DATA_TYPE_NUMBER = load i32, ptr @DATA_TYPE_NUMBER, align 4
  %22 = icmp eq i32 %21, %DATA_TYPE_NUMBER
  %23 = sext i1 %22 to i32
  %24 = icmp ne i32 %23, 0
  br i1 %24, label %then14, label %last16

then14:                                           ; preds = %last10
  %data_ptr15 = load i32, ptr %data_ptr1, align 4
  %25 = call i32 @copy_ptr(i32 %data_ptr15)
  ret i32 %25

last16:                                           ; preds = %last10
  %data17 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr18 = load i32, ptr %data_ptr1, align 4
  %26 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr18
  %27 = load [2048 x i32], ptr %26, align 4
  %DATA_TYPE19 = load i32, ptr @DATA_TYPE, align 4
  %28 = getelementptr inbounds i32, ptr %26, i32 %DATA_TYPE19
  %29 = load i32, ptr %28, align 4
  %DATA_TYPE_LIST = load i32, ptr @DATA_TYPE_LIST, align 4
  %30 = icmp eq i32 %29, %DATA_TYPE_LIST
  %31 = sext i1 %30 to i32
  %32 = icmp ne i32 %31, 0
  br i1 %32, label %then20, label %last489

then20:                                           ; preds = %last16
  %data21 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr22 = load i32, ptr %data_ptr1, align 4
  %33 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr22
  %34 = load [2048 x i32], ptr %33, align 4
  %DATA_VALUE23 = load i32, ptr @DATA_VALUE, align 4
  %35 = getelementptr inbounds i32, ptr %33, i32 %DATA_VALUE23
  %36 = load i32, ptr %35, align 4
  store i32 %36, ptr %head_ptr, align 4
  %head_ptr24 = load i32, ptr %head_ptr, align 4
  %37 = icmp ne i32 %head_ptr24, 0
  %38 = xor i1 %37, true
  %39 = zext i1 %38 to i32
  %40 = icmp ne i32 %39, 0
  br i1 %40, label %then25, label %last26

then25:                                           ; preds = %then20
  %ERR_INVALID_LIST = load i32, ptr @ERR_INVALID_LIST, align 4
  %41 = call i32 @panic(i32 %ERR_INVALID_LIST)
  br label %last26

last26:                                           ; preds = %then25, %then20
  %data27 = load [2048 x [2048 x i32]], ptr @data, align 4
  %head_ptr28 = load i32, ptr %head_ptr, align 4
  %42 = getelementptr inbounds [2048 x i32], ptr @data, i32 %head_ptr28
  %43 = load [2048 x i32], ptr %42, align 4
  %DATA_NEXT = load i32, ptr @DATA_NEXT, align 4
  %44 = getelementptr inbounds i32, ptr %42, i32 %DATA_NEXT
  %45 = load i32, ptr %44, align 4
  store i32 %45, ptr %arg_ptr, align 4
  %data29 = load [2048 x [2048 x i32]], ptr @data, align 4
  %head_ptr30 = load i32, ptr %head_ptr, align 4
  %46 = getelementptr inbounds [2048 x i32], ptr @data, i32 %head_ptr30
  %47 = load [2048 x i32], ptr %46, align 4
  %DATA_TYPE31 = load i32, ptr @DATA_TYPE, align 4
  %48 = getelementptr inbounds i32, ptr %46, i32 %DATA_TYPE31
  %49 = load i32, ptr %48, align 4
  %DATA_TYPE_SYMBOL32 = load i32, ptr @DATA_TYPE_SYMBOL, align 4
  %50 = icmp ne i32 %49, %DATA_TYPE_SYMBOL32
  %51 = sext i1 %50 to i32
  %52 = icmp ne i32 %51, 0
  br i1 %52, label %trueBB, label %nextBB

nextBB:                                           ; preds = %last26
  %env_ptr33 = load i32, ptr %env_ptr2, align 4
  %data34 = load [2048 x [2048 x i32]], ptr @data, align 4
  %head_ptr35 = load i32, ptr %head_ptr, align 4
  %53 = getelementptr inbounds [2048 x i32], ptr @data, i32 %head_ptr35
  %54 = load [2048 x i32], ptr %53, align 4
  %DATA_VALUE36 = load i32, ptr @DATA_VALUE, align 4
  %55 = getelementptr inbounds i32, ptr %53, i32 %DATA_VALUE36
  %56 = load i32, ptr %55, align 4
  %57 = call i32 @env_find(i32 %env_ptr33, i32 %56)
  %58 = icmp ne i32 %57, 0
  %59 = zext i1 %58 to i32
  br label %mergeBB

trueBB:                                           ; preds = %last26
  br label %mergeBB

mergeBB:                                          ; preds = %trueBB, %nextBB
  %60 = phi i32 [ %59, %nextBB ], [ 1, %trueBB ]
  %61 = icmp ne i32 %60, 0
  br i1 %61, label %then37, label %last96

then37:                                           ; preds = %mergeBB
  %head_ptr38 = load i32, ptr %head_ptr, align 4
  %env_ptr39 = load i32, ptr %env_ptr2, align 4
  %62 = call i32 @eval(i32 %head_ptr38, i32 %env_ptr39)
  store i32 %62, ptr %func_ptr, align 4
  %func_ptr40 = load i32, ptr %func_ptr, align 4
  %63 = icmp ne i32 %func_ptr40, 0
  %64 = xor i1 %63, true
  %65 = zext i1 %64 to i32
  %66 = icmp ne i32 %65, 0
  br i1 %66, label %trueBB45, label %nextBB41

nextBB41:                                         ; preds = %then37
  %data42 = load [2048 x [2048 x i32]], ptr @data, align 4
  %func_ptr43 = load i32, ptr %func_ptr, align 4
  %67 = getelementptr inbounds [2048 x i32], ptr @data, i32 %func_ptr43
  %68 = load [2048 x i32], ptr %67, align 4
  %DATA_TYPE44 = load i32, ptr @DATA_TYPE, align 4
  %69 = getelementptr inbounds i32, ptr %67, i32 %DATA_TYPE44
  %70 = load i32, ptr %69, align 4
  %DATA_TYPE_FUNC = load i32, ptr @DATA_TYPE_FUNC, align 4
  %71 = icmp ne i32 %70, %DATA_TYPE_FUNC
  %72 = sext i1 %71 to i32
  %73 = icmp ne i32 %72, 0
  %74 = zext i1 %73 to i32
  br label %mergeBB46

trueBB45:                                         ; preds = %then37
  br label %mergeBB46

mergeBB46:                                        ; preds = %trueBB45, %nextBB41
  %75 = phi i32 [ %74, %nextBB41 ], [ 1, %trueBB45 ]
  %76 = icmp ne i32 %75, 0
  br i1 %76, label %then47, label %last48

then47:                                           ; preds = %mergeBB46
  %ERR_INVALID_FUNC = load i32, ptr @ERR_INVALID_FUNC, align 4
  %77 = call i32 @panic(i32 %ERR_INVALID_FUNC)
  br label %last48

last48:                                           ; preds = %then47, %mergeBB46
  %data49 = load [2048 x [2048 x i32]], ptr @data, align 4
  %func_ptr50 = load i32, ptr %func_ptr, align 4
  %78 = getelementptr inbounds [2048 x i32], ptr @data, i32 %func_ptr50
  %79 = load [2048 x i32], ptr %78, align 4
  %DATA_VALUE51 = load i32, ptr @DATA_VALUE, align 4
  %80 = getelementptr inbounds i32, ptr %78, i32 %DATA_VALUE51
  %81 = load i32, ptr %80, align 4
  store i32 %81, ptr %param_list_ptr, align 4
  %data52 = load [2048 x [2048 x i32]], ptr @data, align 4
  %param_list_ptr53 = load i32, ptr %param_list_ptr, align 4
  %82 = getelementptr inbounds [2048 x i32], ptr @data, i32 %param_list_ptr53
  %83 = load [2048 x i32], ptr %82, align 4
  %DATA_NEXT54 = load i32, ptr @DATA_NEXT, align 4
  %84 = getelementptr inbounds i32, ptr %82, i32 %DATA_NEXT54
  %85 = load i32, ptr %84, align 4
  store i32 %85, ptr %body_ptr, align 4
  %data55 = load [2048 x [2048 x i32]], ptr @data, align 4
  %body_ptr56 = load i32, ptr %body_ptr, align 4
  %86 = getelementptr inbounds [2048 x i32], ptr @data, i32 %body_ptr56
  %87 = load [2048 x i32], ptr %86, align 4
  %DATA_NEXT57 = load i32, ptr @DATA_NEXT, align 4
  %88 = getelementptr inbounds i32, ptr %86, i32 %DATA_NEXT57
  %89 = load i32, ptr %88, align 4
  store i32 %89, ptr %outer_ptr, align 4
  %outer_ptr58 = load i32, ptr %outer_ptr, align 4
  %90 = call i32 @copy_ptr(i32 %outer_ptr58)
  %91 = call i32 @make_env(i32 %90)
  store i32 %91, ptr %func_env_ptr, align 4
  %data59 = load [2048 x [2048 x i32]], ptr @data, align 4
  %param_list_ptr60 = load i32, ptr %param_list_ptr, align 4
  %92 = getelementptr inbounds [2048 x i32], ptr @data, i32 %param_list_ptr60
  %93 = load [2048 x i32], ptr %92, align 4
  %DATA_VALUE61 = load i32, ptr @DATA_VALUE, align 4
  %94 = getelementptr inbounds i32, ptr %92, i32 %DATA_VALUE61
  %95 = load i32, ptr %94, align 4
  store i32 %95, ptr %cur_param_ptr, align 4
  %arg_ptr62 = load i32, ptr %arg_ptr, align 4
  store i32 %arg_ptr62, ptr %cur_arg_ptr, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %last48
  %cur_param_ptr63 = load i32, ptr %cur_param_ptr, align 4
  %96 = icmp ne i32 %cur_param_ptr63, 0
  br i1 %96, label %nextBB64, label %falseBB

nextBB64:                                         ; preds = %for.cond
  %cur_arg_ptr65 = load i32, ptr %cur_arg_ptr, align 4
  %97 = icmp ne i32 %cur_arg_ptr65, 0
  %98 = zext i1 %97 to i32
  br label %mergeBB66

falseBB:                                          ; preds = %for.cond
  br label %mergeBB66

mergeBB66:                                        ; preds = %falseBB, %nextBB64
  %99 = phi i32 [ %98, %nextBB64 ], [ 0, %falseBB ]
  %100 = icmp ne i32 %99, 0
  br i1 %100, label %for.body, label %for.last

for.body:                                         ; preds = %mergeBB66
  %data67 = load [2048 x [2048 x i32]], ptr @data, align 4
  %cur_param_ptr68 = load i32, ptr %cur_param_ptr, align 4
  %101 = getelementptr inbounds [2048 x i32], ptr @data, i32 %cur_param_ptr68
  %102 = load [2048 x i32], ptr %101, align 4
  %DATA_VALUE69 = load i32, ptr @DATA_VALUE, align 4
  %103 = getelementptr inbounds i32, ptr %101, i32 %DATA_VALUE69
  %104 = load i32, ptr %103, align 4
  store i32 %104, ptr %param_sym_ptr, align 4
  %cur_arg_ptr71 = load i32, ptr %cur_arg_ptr, align 4
  %env_ptr72 = load i32, ptr %env_ptr2, align 4
  %105 = call i32 @eval(i32 %cur_arg_ptr71, i32 %env_ptr72)
  store i32 %105, ptr %arg_ptr70, align 4
  %func_env_ptr73 = load i32, ptr %func_env_ptr, align 4
  %param_sym_ptr74 = load i32, ptr %param_sym_ptr, align 4
  %arg_ptr75 = load i32, ptr %arg_ptr70, align 4
  call void @env_add(i32 %func_env_ptr73, i32 %param_sym_ptr74, i32 %arg_ptr75)
  %cur_param_ptr76 = load i32, ptr %cur_param_ptr, align 4
  %data77 = load [2048 x [2048 x i32]], ptr @data, align 4
  %cur_param_ptr78 = load i32, ptr %cur_param_ptr, align 4
  %106 = getelementptr inbounds [2048 x i32], ptr @data, i32 %cur_param_ptr78
  %107 = load [2048 x i32], ptr %106, align 4
  %DATA_NEXT79 = load i32, ptr @DATA_NEXT, align 4
  %108 = getelementptr inbounds i32, ptr %106, i32 %DATA_NEXT79
  %109 = load i32, ptr %108, align 4
  store i32 %109, ptr %cur_param_ptr, align 4
  %cur_arg_ptr80 = load i32, ptr %cur_arg_ptr, align 4
  %data81 = load [2048 x [2048 x i32]], ptr @data, align 4
  %cur_arg_ptr82 = load i32, ptr %cur_arg_ptr, align 4
  %110 = getelementptr inbounds [2048 x i32], ptr @data, i32 %cur_arg_ptr82
  %111 = load [2048 x i32], ptr %110, align 4
  %DATA_NEXT83 = load i32, ptr @DATA_NEXT, align 4
  %112 = getelementptr inbounds i32, ptr %110, i32 %DATA_NEXT83
  %113 = load i32, ptr %112, align 4
  store i32 %113, ptr %cur_arg_ptr, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br label %for.cond

for.last:                                         ; preds = %mergeBB66
  %cur_param_ptr84 = load i32, ptr %cur_param_ptr, align 4
  %114 = icmp ne i32 %cur_param_ptr84, 0
  br i1 %114, label %trueBB87, label %nextBB85

nextBB85:                                         ; preds = %for.last
  %cur_arg_ptr86 = load i32, ptr %cur_arg_ptr, align 4
  %115 = icmp ne i32 %cur_arg_ptr86, 0
  %116 = zext i1 %115 to i32
  br label %mergeBB88

trueBB87:                                         ; preds = %for.last
  br label %mergeBB88

mergeBB88:                                        ; preds = %trueBB87, %nextBB85
  %117 = phi i32 [ %116, %nextBB85 ], [ 1, %trueBB87 ]
  %118 = icmp ne i32 %117, 0
  br i1 %118, label %then89, label %last90

then89:                                           ; preds = %mergeBB88
  %ERR_INVALID_ARG_NUM = load i32, ptr @ERR_INVALID_ARG_NUM, align 4
  %119 = call i32 @panic(i32 %ERR_INVALID_ARG_NUM)
  br label %last90

last90:                                           ; preds = %then89, %mergeBB88
  %body_ptr91 = load i32, ptr %body_ptr, align 4
  %func_env_ptr92 = load i32, ptr %func_env_ptr, align 4
  %120 = call i32 @eval(i32 %body_ptr91, i32 %func_env_ptr92)
  store i32 %120, ptr %result_ptr, align 4
  %func_env_ptr93 = load i32, ptr %func_env_ptr, align 4
  call void @free_data(i32 %func_env_ptr93)
  %func_ptr94 = load i32, ptr %func_ptr, align 4
  call void @free_data(i32 %func_ptr94)
  %result_ptr95 = load i32, ptr %result_ptr, align 4
  ret i32 %result_ptr95

last96:                                           ; preds = %mergeBB
  %data97 = load [2048 x [2048 x i32]], ptr @data, align 4
  %head_ptr98 = load i32, ptr %head_ptr, align 4
  %121 = getelementptr inbounds [2048 x i32], ptr @data, i32 %head_ptr98
  %122 = load [2048 x i32], ptr %121, align 4
  %DATA_VALUE99 = load i32, ptr @DATA_VALUE, align 4
  %123 = getelementptr inbounds i32, ptr %121, i32 %DATA_VALUE99
  %124 = load i32, ptr %123, align 4
  store i32 %124, ptr %sym_ptr, align 4
  %sym_ptr100 = load i32, ptr %sym_ptr, align 4
  %SYM_QUOTE = load i32, ptr @SYM_QUOTE, align 4
  %125 = icmp eq i32 %sym_ptr100, %SYM_QUOTE
  %126 = sext i1 %125 to i32
  %127 = icmp ne i32 %126, 0
  br i1 %127, label %then101, label %last113

then101:                                          ; preds = %last96
  %arg_ptr102 = load i32, ptr %arg_ptr, align 4
  %128 = icmp ne i32 %arg_ptr102, 0
  %129 = xor i1 %128, true
  %130 = zext i1 %129 to i32
  %131 = icmp ne i32 %130, 0
  br i1 %131, label %trueBB107, label %nextBB103

nextBB103:                                        ; preds = %then101
  %data104 = load [2048 x [2048 x i32]], ptr @data, align 4
  %arg_ptr105 = load i32, ptr %arg_ptr, align 4
  %132 = getelementptr inbounds [2048 x i32], ptr @data, i32 %arg_ptr105
  %133 = load [2048 x i32], ptr %132, align 4
  %DATA_NEXT106 = load i32, ptr @DATA_NEXT, align 4
  %134 = getelementptr inbounds i32, ptr %132, i32 %DATA_NEXT106
  %135 = load i32, ptr %134, align 4
  %136 = icmp ne i32 %135, 0
  %137 = zext i1 %136 to i32
  br label %mergeBB108

trueBB107:                                        ; preds = %then101
  br label %mergeBB108

mergeBB108:                                       ; preds = %trueBB107, %nextBB103
  %138 = phi i32 [ %137, %nextBB103 ], [ 1, %trueBB107 ]
  %139 = icmp ne i32 %138, 0
  br i1 %139, label %then109, label %last111

then109:                                          ; preds = %mergeBB108
  %ERR_INVALID_ARG_NUM110 = load i32, ptr @ERR_INVALID_ARG_NUM, align 4
  %140 = call i32 @panic(i32 %ERR_INVALID_ARG_NUM110)
  br label %last111

last111:                                          ; preds = %then109, %mergeBB108
  %arg_ptr112 = load i32, ptr %arg_ptr, align 4
  %141 = call i32 @copy_ptr(i32 %arg_ptr112)
  ret i32 %141

last113:                                          ; preds = %last96
  %sym_ptr114 = load i32, ptr %sym_ptr, align 4
  %SYM_ATOM = load i32, ptr @SYM_ATOM, align 4
  %142 = icmp eq i32 %sym_ptr114, %SYM_ATOM
  %143 = sext i1 %142 to i32
  %144 = icmp ne i32 %143, 0
  br i1 %144, label %then115, label %last135

then115:                                          ; preds = %last113
  %arg_ptr116 = load i32, ptr %arg_ptr, align 4
  %145 = icmp ne i32 %arg_ptr116, 0
  %146 = xor i1 %145, true
  %147 = zext i1 %146 to i32
  %148 = icmp ne i32 %147, 0
  br i1 %148, label %trueBB121, label %nextBB117

nextBB117:                                        ; preds = %then115
  %data118 = load [2048 x [2048 x i32]], ptr @data, align 4
  %arg_ptr119 = load i32, ptr %arg_ptr, align 4
  %149 = getelementptr inbounds [2048 x i32], ptr @data, i32 %arg_ptr119
  %150 = load [2048 x i32], ptr %149, align 4
  %DATA_NEXT120 = load i32, ptr @DATA_NEXT, align 4
  %151 = getelementptr inbounds i32, ptr %149, i32 %DATA_NEXT120
  %152 = load i32, ptr %151, align 4
  %153 = icmp ne i32 %152, 0
  %154 = zext i1 %153 to i32
  br label %mergeBB122

trueBB121:                                        ; preds = %then115
  br label %mergeBB122

mergeBB122:                                       ; preds = %trueBB121, %nextBB117
  %155 = phi i32 [ %154, %nextBB117 ], [ 1, %trueBB121 ]
  %156 = icmp ne i32 %155, 0
  br i1 %156, label %then123, label %last125

then123:                                          ; preds = %mergeBB122
  %ERR_INVALID_ARG_NUM124 = load i32, ptr @ERR_INVALID_ARG_NUM, align 4
  %157 = call i32 @panic(i32 %ERR_INVALID_ARG_NUM124)
  br label %last125

last125:                                          ; preds = %then123, %mergeBB122
  %arg_ptr126 = load i32, ptr %arg_ptr, align 4
  %env_ptr127 = load i32, ptr %env_ptr2, align 4
  %158 = call i32 @eval(i32 %arg_ptr126, i32 %env_ptr127)
  store i32 %158, ptr %value_ptr, align 4
  %data129 = load [2048 x [2048 x i32]], ptr @data, align 4
  %value_ptr130 = load i32, ptr %value_ptr, align 4
  %159 = getelementptr inbounds [2048 x i32], ptr @data, i32 %value_ptr130
  %160 = load [2048 x i32], ptr %159, align 4
  %DATA_TYPE131 = load i32, ptr @DATA_TYPE, align 4
  %161 = getelementptr inbounds i32, ptr %159, i32 %DATA_TYPE131
  %162 = load i32, ptr %161, align 4
  %DATA_TYPE_LIST132 = load i32, ptr @DATA_TYPE_LIST, align 4
  %163 = icmp ne i32 %162, %DATA_TYPE_LIST132
  %164 = sext i1 %163 to i32
  %165 = call i32 @make_bool(i32 %164)
  store i32 %165, ptr %result_ptr128, align 4
  %value_ptr133 = load i32, ptr %value_ptr, align 4
  call void @free_data(i32 %value_ptr133)
  %result_ptr134 = load i32, ptr %result_ptr128, align 4
  ret i32 %result_ptr134

last135:                                          ; preds = %last113
  %sym_ptr136 = load i32, ptr %sym_ptr, align 4
  %SYM_NUMBER = load i32, ptr @SYM_NUMBER, align 4
  %166 = icmp eq i32 %sym_ptr136, %SYM_NUMBER
  %167 = sext i1 %166 to i32
  %168 = icmp ne i32 %167, 0
  br i1 %168, label %then137, label %last158

then137:                                          ; preds = %last135
  %arg_ptr138 = load i32, ptr %arg_ptr, align 4
  %169 = icmp ne i32 %arg_ptr138, 0
  %170 = xor i1 %169, true
  %171 = zext i1 %170 to i32
  %172 = icmp ne i32 %171, 0
  br i1 %172, label %trueBB143, label %nextBB139

nextBB139:                                        ; preds = %then137
  %data140 = load [2048 x [2048 x i32]], ptr @data, align 4
  %arg_ptr141 = load i32, ptr %arg_ptr, align 4
  %173 = getelementptr inbounds [2048 x i32], ptr @data, i32 %arg_ptr141
  %174 = load [2048 x i32], ptr %173, align 4
  %DATA_NEXT142 = load i32, ptr @DATA_NEXT, align 4
  %175 = getelementptr inbounds i32, ptr %173, i32 %DATA_NEXT142
  %176 = load i32, ptr %175, align 4
  %177 = icmp ne i32 %176, 0
  %178 = zext i1 %177 to i32
  br label %mergeBB144

trueBB143:                                        ; preds = %then137
  br label %mergeBB144

mergeBB144:                                       ; preds = %trueBB143, %nextBB139
  %179 = phi i32 [ %178, %nextBB139 ], [ 1, %trueBB143 ]
  %180 = icmp ne i32 %179, 0
  br i1 %180, label %then145, label %last147

then145:                                          ; preds = %mergeBB144
  %ERR_INVALID_ARG_NUM146 = load i32, ptr @ERR_INVALID_ARG_NUM, align 4
  %181 = call i32 @panic(i32 %ERR_INVALID_ARG_NUM146)
  br label %last147

last147:                                          ; preds = %then145, %mergeBB144
  %arg_ptr149 = load i32, ptr %arg_ptr, align 4
  %env_ptr150 = load i32, ptr %env_ptr2, align 4
  %182 = call i32 @eval(i32 %arg_ptr149, i32 %env_ptr150)
  store i32 %182, ptr %value_ptr148, align 4
  %data152 = load [2048 x [2048 x i32]], ptr @data, align 4
  %value_ptr153 = load i32, ptr %value_ptr148, align 4
  %183 = getelementptr inbounds [2048 x i32], ptr @data, i32 %value_ptr153
  %184 = load [2048 x i32], ptr %183, align 4
  %DATA_TYPE154 = load i32, ptr @DATA_TYPE, align 4
  %185 = getelementptr inbounds i32, ptr %183, i32 %DATA_TYPE154
  %186 = load i32, ptr %185, align 4
  %DATA_TYPE_NUMBER155 = load i32, ptr @DATA_TYPE_NUMBER, align 4
  %187 = icmp eq i32 %186, %DATA_TYPE_NUMBER155
  %188 = sext i1 %187 to i32
  %189 = call i32 @make_bool(i32 %188)
  store i32 %189, ptr %result_ptr151, align 4
  %value_ptr156 = load i32, ptr %value_ptr148, align 4
  call void @free_data(i32 %value_ptr156)
  %result_ptr157 = load i32, ptr %result_ptr151, align 4
  ret i32 %result_ptr157

last158:                                          ; preds = %last135
  %sym_ptr159 = load i32, ptr %sym_ptr, align 4
  %SYM_EQ = load i32, ptr @SYM_EQ, align 4
  %190 = icmp eq i32 %sym_ptr159, %SYM_EQ
  %191 = sext i1 %190 to i32
  %192 = icmp ne i32 %191, 0
  br i1 %192, label %then160, label %last188

then160:                                          ; preds = %last158
  %data161 = load [2048 x [2048 x i32]], ptr @data, align 4
  %arg_ptr162 = load i32, ptr %arg_ptr, align 4
  %193 = getelementptr inbounds [2048 x i32], ptr @data, i32 %arg_ptr162
  %194 = load [2048 x i32], ptr %193, align 4
  %DATA_NEXT163 = load i32, ptr @DATA_NEXT, align 4
  %195 = getelementptr inbounds i32, ptr %193, i32 %DATA_NEXT163
  %196 = load i32, ptr %195, align 4
  store i32 %196, ptr %arg2_ptr, align 4
  %arg_ptr164 = load i32, ptr %arg_ptr, align 4
  %197 = icmp ne i32 %arg_ptr164, 0
  %198 = xor i1 %197, true
  %199 = zext i1 %198 to i32
  %200 = icmp ne i32 %199, 0
  br i1 %200, label %trueBB167, label %nextBB165

nextBB165:                                        ; preds = %then160
  %arg2_ptr166 = load i32, ptr %arg2_ptr, align 4
  %201 = icmp ne i32 %arg2_ptr166, 0
  %202 = xor i1 %201, true
  %203 = zext i1 %202 to i32
  %204 = icmp ne i32 %203, 0
  %205 = zext i1 %204 to i32
  br label %mergeBB168

trueBB167:                                        ; preds = %then160
  br label %mergeBB168

mergeBB168:                                       ; preds = %trueBB167, %nextBB165
  %206 = phi i32 [ %205, %nextBB165 ], [ 1, %trueBB167 ]
  %207 = icmp ne i32 %206, 0
  br i1 %207, label %trueBB173, label %nextBB169

nextBB169:                                        ; preds = %mergeBB168
  %data170 = load [2048 x [2048 x i32]], ptr @data, align 4
  %arg2_ptr171 = load i32, ptr %arg2_ptr, align 4
  %208 = getelementptr inbounds [2048 x i32], ptr @data, i32 %arg2_ptr171
  %209 = load [2048 x i32], ptr %208, align 4
  %DATA_NEXT172 = load i32, ptr @DATA_NEXT, align 4
  %210 = getelementptr inbounds i32, ptr %208, i32 %DATA_NEXT172
  %211 = load i32, ptr %210, align 4
  %212 = icmp ne i32 %211, 0
  %213 = zext i1 %212 to i32
  br label %mergeBB174

trueBB173:                                        ; preds = %mergeBB168
  br label %mergeBB174

mergeBB174:                                       ; preds = %trueBB173, %nextBB169
  %214 = phi i32 [ %213, %nextBB169 ], [ 1, %trueBB173 ]
  %215 = icmp ne i32 %214, 0
  br i1 %215, label %then175, label %last177

then175:                                          ; preds = %mergeBB174
  %ERR_INVALID_ARG_NUM176 = load i32, ptr @ERR_INVALID_ARG_NUM, align 4
  %216 = call i32 @panic(i32 %ERR_INVALID_ARG_NUM176)
  br label %last177

last177:                                          ; preds = %then175, %mergeBB174
  %arg_ptr178 = load i32, ptr %arg_ptr, align 4
  %env_ptr179 = load i32, ptr %env_ptr2, align 4
  %217 = call i32 @eval(i32 %arg_ptr178, i32 %env_ptr179)
  store i32 %217, ptr %value1_ptr, align 4
  %arg2_ptr180 = load i32, ptr %arg2_ptr, align 4
  %env_ptr181 = load i32, ptr %env_ptr2, align 4
  %218 = call i32 @eval(i32 %arg2_ptr180, i32 %env_ptr181)
  store i32 %218, ptr %value2_ptr, align 4
  %value1_ptr183 = load i32, ptr %value1_ptr, align 4
  %value2_ptr184 = load i32, ptr %value2_ptr, align 4
  %219 = call i32 @is_equal(i32 %value1_ptr183, i32 %value2_ptr184)
  %220 = call i32 @make_bool(i32 %219)
  store i32 %220, ptr %result_ptr182, align 4
  %value1_ptr185 = load i32, ptr %value1_ptr, align 4
  call void @free_data(i32 %value1_ptr185)
  %value2_ptr186 = load i32, ptr %value2_ptr, align 4
  call void @free_data(i32 %value2_ptr186)
  %result_ptr187 = load i32, ptr %result_ptr182, align 4
  ret i32 %result_ptr187

last188:                                          ; preds = %last158
  %sym_ptr189 = load i32, ptr %sym_ptr, align 4
  %SYM_CAR = load i32, ptr @SYM_CAR, align 4
  %221 = icmp eq i32 %sym_ptr189, %SYM_CAR
  %222 = sext i1 %221 to i32
  %223 = icmp ne i32 %222, 0
  br i1 %223, label %then190, label %last212

then190:                                          ; preds = %last188
  %arg_ptr191 = load i32, ptr %arg_ptr, align 4
  %224 = icmp ne i32 %arg_ptr191, 0
  %225 = xor i1 %224, true
  %226 = zext i1 %225 to i32
  %227 = icmp ne i32 %226, 0
  br i1 %227, label %trueBB196, label %nextBB192

nextBB192:                                        ; preds = %then190
  %data193 = load [2048 x [2048 x i32]], ptr @data, align 4
  %arg_ptr194 = load i32, ptr %arg_ptr, align 4
  %228 = getelementptr inbounds [2048 x i32], ptr @data, i32 %arg_ptr194
  %229 = load [2048 x i32], ptr %228, align 4
  %DATA_NEXT195 = load i32, ptr @DATA_NEXT, align 4
  %230 = getelementptr inbounds i32, ptr %228, i32 %DATA_NEXT195
  %231 = load i32, ptr %230, align 4
  %232 = icmp ne i32 %231, 0
  %233 = zext i1 %232 to i32
  br label %mergeBB197

trueBB196:                                        ; preds = %then190
  br label %mergeBB197

mergeBB197:                                       ; preds = %trueBB196, %nextBB192
  %234 = phi i32 [ %233, %nextBB192 ], [ 1, %trueBB196 ]
  %235 = icmp ne i32 %234, 0
  br i1 %235, label %then198, label %last200

then198:                                          ; preds = %mergeBB197
  %ERR_INVALID_ARG_NUM199 = load i32, ptr @ERR_INVALID_ARG_NUM, align 4
  %236 = call i32 @panic(i32 %ERR_INVALID_ARG_NUM199)
  br label %last200

last200:                                          ; preds = %then198, %mergeBB197
  %arg_ptr202 = load i32, ptr %arg_ptr, align 4
  %env_ptr203 = load i32, ptr %env_ptr2, align 4
  %237 = call i32 @eval(i32 %arg_ptr202, i32 %env_ptr203)
  store i32 %237, ptr %value_ptr201, align 4
  %value_ptr205 = load i32, ptr %value_ptr201, align 4
  %238 = call i32 @unwrap_list(i32 %value_ptr205)
  %239 = call i32 @copy_ptr(i32 %238)
  store i32 %239, ptr %result_ptr204, align 4
  %result_ptr206 = load i32, ptr %result_ptr204, align 4
  %240 = icmp ne i32 %result_ptr206, 0
  %241 = xor i1 %240, true
  %242 = zext i1 %241 to i32
  %243 = icmp ne i32 %242, 0
  br i1 %243, label %then207, label %last209

then207:                                          ; preds = %last200
  %ERR_INVALID_LIST208 = load i32, ptr @ERR_INVALID_LIST, align 4
  %244 = call i32 @panic(i32 %ERR_INVALID_LIST208)
  br label %last209

last209:                                          ; preds = %then207, %last200
  %value_ptr210 = load i32, ptr %value_ptr201, align 4
  call void @free_data(i32 %value_ptr210)
  %result_ptr211 = load i32, ptr %result_ptr204, align 4
  ret i32 %result_ptr211

last212:                                          ; preds = %last188
  %sym_ptr213 = load i32, ptr %sym_ptr, align 4
  %SYM_CDR = load i32, ptr @SYM_CDR, align 4
  %245 = icmp eq i32 %sym_ptr213, %SYM_CDR
  %246 = sext i1 %245 to i32
  %247 = icmp ne i32 %246, 0
  br i1 %247, label %then214, label %last240

then214:                                          ; preds = %last212
  %arg_ptr215 = load i32, ptr %arg_ptr, align 4
  %248 = icmp ne i32 %arg_ptr215, 0
  %249 = xor i1 %248, true
  %250 = zext i1 %249 to i32
  %251 = icmp ne i32 %250, 0
  br i1 %251, label %trueBB220, label %nextBB216

nextBB216:                                        ; preds = %then214
  %data217 = load [2048 x [2048 x i32]], ptr @data, align 4
  %arg_ptr218 = load i32, ptr %arg_ptr, align 4
  %252 = getelementptr inbounds [2048 x i32], ptr @data, i32 %arg_ptr218
  %253 = load [2048 x i32], ptr %252, align 4
  %DATA_NEXT219 = load i32, ptr @DATA_NEXT, align 4
  %254 = getelementptr inbounds i32, ptr %252, i32 %DATA_NEXT219
  %255 = load i32, ptr %254, align 4
  %256 = icmp ne i32 %255, 0
  %257 = zext i1 %256 to i32
  br label %mergeBB221

trueBB220:                                        ; preds = %then214
  br label %mergeBB221

mergeBB221:                                       ; preds = %trueBB220, %nextBB216
  %258 = phi i32 [ %257, %nextBB216 ], [ 1, %trueBB220 ]
  %259 = icmp ne i32 %258, 0
  br i1 %259, label %then222, label %last224

then222:                                          ; preds = %mergeBB221
  %ERR_INVALID_ARG_NUM223 = load i32, ptr @ERR_INVALID_ARG_NUM, align 4
  %260 = call i32 @panic(i32 %ERR_INVALID_ARG_NUM223)
  br label %last224

last224:                                          ; preds = %then222, %mergeBB221
  %arg_ptr226 = load i32, ptr %arg_ptr, align 4
  %env_ptr227 = load i32, ptr %env_ptr2, align 4
  %261 = call i32 @eval(i32 %arg_ptr226, i32 %env_ptr227)
  store i32 %261, ptr %value_ptr225, align 4
  %value_ptr229 = load i32, ptr %value_ptr225, align 4
  %262 = call i32 @unwrap_list(i32 %value_ptr229)
  store i32 %262, ptr %head_ptr228, align 4
  %head_ptr230 = load i32, ptr %head_ptr228, align 4
  %263 = icmp ne i32 %head_ptr230, 0
  %264 = xor i1 %263, true
  %265 = zext i1 %264 to i32
  %266 = icmp ne i32 %265, 0
  br i1 %266, label %then231, label %last233

then231:                                          ; preds = %last224
  %ERR_INVALID_LIST232 = load i32, ptr @ERR_INVALID_LIST, align 4
  %267 = call i32 @panic(i32 %ERR_INVALID_LIST232)
  br label %last233

last233:                                          ; preds = %then231, %last224
  %data235 = load [2048 x [2048 x i32]], ptr @data, align 4
  %head_ptr236 = load i32, ptr %head_ptr228, align 4
  %268 = getelementptr inbounds [2048 x i32], ptr @data, i32 %head_ptr236
  %269 = load [2048 x i32], ptr %268, align 4
  %DATA_NEXT237 = load i32, ptr @DATA_NEXT, align 4
  %270 = getelementptr inbounds i32, ptr %268, i32 %DATA_NEXT237
  %271 = load i32, ptr %270, align 4
  %272 = call i32 @copy_ptr(i32 %271)
  %273 = call i32 @make_list(i32 %272)
  store i32 %273, ptr %result_ptr234, align 4
  %value_ptr238 = load i32, ptr %value_ptr225, align 4
  call void @free_data(i32 %value_ptr238)
  %result_ptr239 = load i32, ptr %result_ptr234, align 4
  ret i32 %result_ptr239

last240:                                          ; preds = %last212
  %sym_ptr241 = load i32, ptr %sym_ptr, align 4
  %SYM_CONS = load i32, ptr @SYM_CONS, align 4
  %274 = icmp eq i32 %sym_ptr241, %SYM_CONS
  %275 = sext i1 %274 to i32
  %276 = icmp ne i32 %275, 0
  br i1 %276, label %then242, label %last278

then242:                                          ; preds = %last240
  %data244 = load [2048 x [2048 x i32]], ptr @data, align 4
  %arg_ptr245 = load i32, ptr %arg_ptr, align 4
  %277 = getelementptr inbounds [2048 x i32], ptr @data, i32 %arg_ptr245
  %278 = load [2048 x i32], ptr %277, align 4
  %DATA_NEXT246 = load i32, ptr @DATA_NEXT, align 4
  %279 = getelementptr inbounds i32, ptr %277, i32 %DATA_NEXT246
  %280 = load i32, ptr %279, align 4
  store i32 %280, ptr %arg2_ptr243, align 4
  %arg_ptr247 = load i32, ptr %arg_ptr, align 4
  %281 = icmp ne i32 %arg_ptr247, 0
  %282 = xor i1 %281, true
  %283 = zext i1 %282 to i32
  %284 = icmp ne i32 %283, 0
  br i1 %284, label %trueBB250, label %nextBB248

nextBB248:                                        ; preds = %then242
  %arg2_ptr249 = load i32, ptr %arg2_ptr243, align 4
  %285 = icmp ne i32 %arg2_ptr249, 0
  %286 = xor i1 %285, true
  %287 = zext i1 %286 to i32
  %288 = icmp ne i32 %287, 0
  %289 = zext i1 %288 to i32
  br label %mergeBB251

trueBB250:                                        ; preds = %then242
  br label %mergeBB251

mergeBB251:                                       ; preds = %trueBB250, %nextBB248
  %290 = phi i32 [ %289, %nextBB248 ], [ 1, %trueBB250 ]
  %291 = icmp ne i32 %290, 0
  br i1 %291, label %trueBB256, label %nextBB252

nextBB252:                                        ; preds = %mergeBB251
  %data253 = load [2048 x [2048 x i32]], ptr @data, align 4
  %arg2_ptr254 = load i32, ptr %arg2_ptr243, align 4
  %292 = getelementptr inbounds [2048 x i32], ptr @data, i32 %arg2_ptr254
  %293 = load [2048 x i32], ptr %292, align 4
  %DATA_NEXT255 = load i32, ptr @DATA_NEXT, align 4
  %294 = getelementptr inbounds i32, ptr %292, i32 %DATA_NEXT255
  %295 = load i32, ptr %294, align 4
  %296 = icmp ne i32 %295, 0
  %297 = zext i1 %296 to i32
  br label %mergeBB257

trueBB256:                                        ; preds = %mergeBB251
  br label %mergeBB257

mergeBB257:                                       ; preds = %trueBB256, %nextBB252
  %298 = phi i32 [ %297, %nextBB252 ], [ 1, %trueBB256 ]
  %299 = icmp ne i32 %298, 0
  br i1 %299, label %then258, label %last260

then258:                                          ; preds = %mergeBB257
  %ERR_INVALID_ARG_NUM259 = load i32, ptr @ERR_INVALID_ARG_NUM, align 4
  %300 = call i32 @panic(i32 %ERR_INVALID_ARG_NUM259)
  br label %last260

last260:                                          ; preds = %then258, %mergeBB257
  %arg_ptr262 = load i32, ptr %arg_ptr, align 4
  %env_ptr263 = load i32, ptr %env_ptr2, align 4
  %301 = call i32 @eval(i32 %arg_ptr262, i32 %env_ptr263)
  store i32 %301, ptr %value1_ptr261, align 4
  %arg2_ptr265 = load i32, ptr %arg2_ptr243, align 4
  %env_ptr266 = load i32, ptr %env_ptr2, align 4
  %302 = call i32 @eval(i32 %arg2_ptr265, i32 %env_ptr266)
  store i32 %302, ptr %value2_ptr264, align 4
  %value1_ptr268 = load i32, ptr %value1_ptr261, align 4
  %303 = call i32 @copy_data(i32 %value1_ptr268)
  store i32 %303, ptr %head_ptr267, align 4
  %data269 = load [2048 x [2048 x i32]], ptr @data, align 4
  %head_ptr270 = load i32, ptr %head_ptr267, align 4
  %304 = getelementptr inbounds [2048 x i32], ptr @data, i32 %head_ptr270
  %305 = load [2048 x i32], ptr %304, align 4
  %DATA_NEXT271 = load i32, ptr @DATA_NEXT, align 4
  %306 = getelementptr inbounds i32, ptr %304, i32 %DATA_NEXT271
  %307 = load i32, ptr %306, align 4
  %value2_ptr272 = load i32, ptr %value2_ptr264, align 4
  %308 = call i32 @unwrap_list(i32 %value2_ptr272)
  %309 = call i32 @copy_ptr(i32 %308)
  store i32 %309, ptr %306, align 4
  %head_ptr274 = load i32, ptr %head_ptr267, align 4
  %310 = call i32 @make_list(i32 %head_ptr274)
  store i32 %310, ptr %result_ptr273, align 4
  %value1_ptr275 = load i32, ptr %value1_ptr261, align 4
  call void @free_data(i32 %value1_ptr275)
  %value2_ptr276 = load i32, ptr %value2_ptr264, align 4
  call void @free_data(i32 %value2_ptr276)
  %result_ptr277 = load i32, ptr %result_ptr273, align 4
  ret i32 %result_ptr277

last278:                                          ; preds = %last240
  %sym_ptr279 = load i32, ptr %sym_ptr, align 4
  %SYM_COND = load i32, ptr @SYM_COND, align 4
  %311 = icmp eq i32 %sym_ptr279, %SYM_COND
  %312 = sext i1 %311 to i32
  %313 = icmp ne i32 %312, 0
  br i1 %313, label %then280, label %last307

then280:                                          ; preds = %last278
  %arg_ptr281 = load i32, ptr %arg_ptr, align 4
  store i32 %arg_ptr281, ptr %cur_ptr, align 4
  br label %for.cond282

for.cond282:                                      ; preds = %for.inc305, %then280
  %cur_ptr283 = load i32, ptr %cur_ptr, align 4
  %314 = icmp ne i32 %cur_ptr283, 0
  br i1 %314, label %for.body284, label %for.last306

for.body284:                                      ; preds = %for.cond282
  %cur_ptr285 = load i32, ptr %cur_ptr, align 4
  %315 = call i32 @unwrap_list(i32 %cur_ptr285)
  store i32 %315, ptr %test_ptr, align 4
  %test_ptr287 = load i32, ptr %test_ptr, align 4
  %env_ptr288 = load i32, ptr %env_ptr2, align 4
  %316 = call i32 @eval(i32 %test_ptr287, i32 %env_ptr288)
  store i32 %316, ptr %result_ptr286, align 4
  %result_ptr289 = load i32, ptr %result_ptr286, align 4
  %317 = call i32 @is_true(i32 %result_ptr289)
  %318 = icmp ne i32 %317, 0
  br i1 %318, label %then290, label %last299

then290:                                          ; preds = %for.body284
  %data292 = load [2048 x [2048 x i32]], ptr @data, align 4
  %test_ptr293 = load i32, ptr %test_ptr, align 4
  %319 = getelementptr inbounds [2048 x i32], ptr @data, i32 %test_ptr293
  %320 = load [2048 x i32], ptr %319, align 4
  %DATA_NEXT294 = load i32, ptr @DATA_NEXT, align 4
  %321 = getelementptr inbounds i32, ptr %319, i32 %DATA_NEXT294
  %322 = load i32, ptr %321, align 4
  store i32 %322, ptr %body_ptr291, align 4
  %body_ptr295 = load i32, ptr %body_ptr291, align 4
  %env_ptr296 = load i32, ptr %env_ptr2, align 4
  %323 = call i32 @eval(i32 %body_ptr295, i32 %env_ptr296)
  store i32 %323, ptr %body_result_ptr, align 4
  %result_ptr297 = load i32, ptr %result_ptr286, align 4
  call void @free_data(i32 %result_ptr297)
  %body_result_ptr298 = load i32, ptr %body_result_ptr, align 4
  ret i32 %body_result_ptr298

last299:                                          ; preds = %for.body284
  %result_ptr300 = load i32, ptr %result_ptr286, align 4
  call void @free_data(i32 %result_ptr300)
  %cur_ptr301 = load i32, ptr %cur_ptr, align 4
  %data302 = load [2048 x [2048 x i32]], ptr @data, align 4
  %cur_ptr303 = load i32, ptr %cur_ptr, align 4
  %324 = getelementptr inbounds [2048 x i32], ptr @data, i32 %cur_ptr303
  %325 = load [2048 x i32], ptr %324, align 4
  %DATA_NEXT304 = load i32, ptr @DATA_NEXT, align 4
  %326 = getelementptr inbounds i32, ptr %324, i32 %DATA_NEXT304
  %327 = load i32, ptr %326, align 4
  store i32 %327, ptr %cur_ptr, align 4
  br label %for.inc305

for.inc305:                                       ; preds = %last299
  br label %for.cond282

for.last306:                                      ; preds = %for.cond282
  ret i32 0

last307:                                          ; preds = %last278
  %sym_ptr308 = load i32, ptr %sym_ptr, align 4
  %SYM_LAMBDA = load i32, ptr @SYM_LAMBDA, align 4
  %328 = icmp eq i32 %sym_ptr308, %SYM_LAMBDA
  %329 = sext i1 %328 to i32
  %330 = icmp ne i32 %329, 0
  br i1 %330, label %then309, label %last333

then309:                                          ; preds = %last307
  %data311 = load [2048 x [2048 x i32]], ptr @data, align 4
  %arg_ptr312 = load i32, ptr %arg_ptr, align 4
  %331 = getelementptr inbounds [2048 x i32], ptr @data, i32 %arg_ptr312
  %332 = load [2048 x i32], ptr %331, align 4
  %DATA_NEXT313 = load i32, ptr @DATA_NEXT, align 4
  %333 = getelementptr inbounds i32, ptr %331, i32 %DATA_NEXT313
  %334 = load i32, ptr %333, align 4
  store i32 %334, ptr %arg2_ptr310, align 4
  %arg_ptr314 = load i32, ptr %arg_ptr, align 4
  %335 = icmp ne i32 %arg_ptr314, 0
  %336 = xor i1 %335, true
  %337 = zext i1 %336 to i32
  %338 = icmp ne i32 %337, 0
  br i1 %338, label %trueBB317, label %nextBB315

nextBB315:                                        ; preds = %then309
  %arg2_ptr316 = load i32, ptr %arg2_ptr310, align 4
  %339 = icmp ne i32 %arg2_ptr316, 0
  %340 = xor i1 %339, true
  %341 = zext i1 %340 to i32
  %342 = icmp ne i32 %341, 0
  %343 = zext i1 %342 to i32
  br label %mergeBB318

trueBB317:                                        ; preds = %then309
  br label %mergeBB318

mergeBB318:                                       ; preds = %trueBB317, %nextBB315
  %344 = phi i32 [ %343, %nextBB315 ], [ 1, %trueBB317 ]
  %345 = icmp ne i32 %344, 0
  br i1 %345, label %trueBB323, label %nextBB319

nextBB319:                                        ; preds = %mergeBB318
  %data320 = load [2048 x [2048 x i32]], ptr @data, align 4
  %arg2_ptr321 = load i32, ptr %arg2_ptr310, align 4
  %346 = getelementptr inbounds [2048 x i32], ptr @data, i32 %arg2_ptr321
  %347 = load [2048 x i32], ptr %346, align 4
  %DATA_NEXT322 = load i32, ptr @DATA_NEXT, align 4
  %348 = getelementptr inbounds i32, ptr %346, i32 %DATA_NEXT322
  %349 = load i32, ptr %348, align 4
  %350 = icmp ne i32 %349, 0
  %351 = zext i1 %350 to i32
  br label %mergeBB324

trueBB323:                                        ; preds = %mergeBB318
  br label %mergeBB324

mergeBB324:                                       ; preds = %trueBB323, %nextBB319
  %352 = phi i32 [ %351, %nextBB319 ], [ 1, %trueBB323 ]
  %353 = icmp ne i32 %352, 0
  br i1 %353, label %then325, label %last327

then325:                                          ; preds = %mergeBB324
  %ERR_INVALID_ARG_NUM326 = load i32, ptr @ERR_INVALID_ARG_NUM, align 4
  %354 = call i32 @panic(i32 %ERR_INVALID_ARG_NUM326)
  br label %last327

last327:                                          ; preds = %then325, %mergeBB324
  %arg_ptr329 = load i32, ptr %arg_ptr, align 4
  %355 = call i32 @copy_data(i32 %arg_ptr329)
  %arg2_ptr330 = load i32, ptr %arg2_ptr310, align 4
  %356 = call i32 @copy_data(i32 %arg2_ptr330)
  %env_ptr331 = load i32, ptr %env_ptr2, align 4
  %357 = call i32 @copy_ptr(i32 %env_ptr331)
  %358 = call i32 @make_func(i32 %355, i32 %356, i32 %357)
  store i32 %358, ptr %result_ptr328, align 4
  %result_ptr332 = load i32, ptr %result_ptr328, align 4
  ret i32 %result_ptr332

last333:                                          ; preds = %last307
  %sym_ptr334 = load i32, ptr %sym_ptr, align 4
  %SYM_DEFINE = load i32, ptr @SYM_DEFINE, align 4
  %359 = icmp eq i32 %sym_ptr334, %SYM_DEFINE
  %360 = sext i1 %359 to i32
  %361 = icmp ne i32 %360, 0
  br i1 %361, label %then335, label %last362

then335:                                          ; preds = %last333
  %data337 = load [2048 x [2048 x i32]], ptr @data, align 4
  %arg_ptr338 = load i32, ptr %arg_ptr, align 4
  %362 = getelementptr inbounds [2048 x i32], ptr @data, i32 %arg_ptr338
  %363 = load [2048 x i32], ptr %362, align 4
  %DATA_NEXT339 = load i32, ptr @DATA_NEXT, align 4
  %364 = getelementptr inbounds i32, ptr %362, i32 %DATA_NEXT339
  %365 = load i32, ptr %364, align 4
  store i32 %365, ptr %arg2_ptr336, align 4
  %arg_ptr340 = load i32, ptr %arg_ptr, align 4
  %366 = icmp ne i32 %arg_ptr340, 0
  %367 = xor i1 %366, true
  %368 = zext i1 %367 to i32
  %369 = icmp ne i32 %368, 0
  br i1 %369, label %trueBB343, label %nextBB341

nextBB341:                                        ; preds = %then335
  %arg2_ptr342 = load i32, ptr %arg2_ptr336, align 4
  %370 = icmp ne i32 %arg2_ptr342, 0
  %371 = xor i1 %370, true
  %372 = zext i1 %371 to i32
  %373 = icmp ne i32 %372, 0
  %374 = zext i1 %373 to i32
  br label %mergeBB344

trueBB343:                                        ; preds = %then335
  br label %mergeBB344

mergeBB344:                                       ; preds = %trueBB343, %nextBB341
  %375 = phi i32 [ %374, %nextBB341 ], [ 1, %trueBB343 ]
  %376 = icmp ne i32 %375, 0
  br i1 %376, label %trueBB349, label %nextBB345

nextBB345:                                        ; preds = %mergeBB344
  %data346 = load [2048 x [2048 x i32]], ptr @data, align 4
  %arg2_ptr347 = load i32, ptr %arg2_ptr336, align 4
  %377 = getelementptr inbounds [2048 x i32], ptr @data, i32 %arg2_ptr347
  %378 = load [2048 x i32], ptr %377, align 4
  %DATA_NEXT348 = load i32, ptr @DATA_NEXT, align 4
  %379 = getelementptr inbounds i32, ptr %377, i32 %DATA_NEXT348
  %380 = load i32, ptr %379, align 4
  %381 = icmp ne i32 %380, 0
  %382 = zext i1 %381 to i32
  br label %mergeBB350

trueBB349:                                        ; preds = %mergeBB344
  br label %mergeBB350

mergeBB350:                                       ; preds = %trueBB349, %nextBB345
  %383 = phi i32 [ %382, %nextBB345 ], [ 1, %trueBB349 ]
  %384 = icmp ne i32 %383, 0
  br i1 %384, label %then351, label %last353

then351:                                          ; preds = %mergeBB350
  %ERR_INVALID_ARG_NUM352 = load i32, ptr @ERR_INVALID_ARG_NUM, align 4
  %385 = call i32 @panic(i32 %ERR_INVALID_ARG_NUM352)
  br label %last353

last353:                                          ; preds = %then351, %mergeBB350
  %arg_ptr355 = load i32, ptr %arg_ptr, align 4
  %386 = call i32 @unwrap_symbol(i32 %arg_ptr355)
  store i32 %386, ptr %sym_ptr354, align 4
  %arg2_ptr357 = load i32, ptr %arg2_ptr336, align 4
  %env_ptr358 = load i32, ptr %env_ptr2, align 4
  %387 = call i32 @eval(i32 %arg2_ptr357, i32 %env_ptr358)
  store i32 %387, ptr %value_ptr356, align 4
  %env_ptr359 = load i32, ptr %env_ptr2, align 4
  %sym_ptr360 = load i32, ptr %sym_ptr354, align 4
  %value_ptr361 = load i32, ptr %value_ptr356, align 4
  call void @env_set(i32 %env_ptr359, i32 %sym_ptr360, i32 %value_ptr361)
  ret i32 0

last362:                                          ; preds = %last333
  %sym_ptr363 = load i32, ptr %sym_ptr, align 4
  %SYM_LIST = load i32, ptr @SYM_LIST, align 4
  %388 = icmp eq i32 %sym_ptr363, %SYM_LIST
  %389 = sext i1 %388 to i32
  %390 = icmp ne i32 %389, 0
  br i1 %390, label %then364, label %last395

then364:                                          ; preds = %last362
  %391 = call i32 @make_list(i32 0)
  store i32 %391, ptr %result_ptr365, align 4
  store i32 0, ptr %cur_ptr366, align 4
  br label %for.cond367

for.cond367:                                      ; preds = %for.inc392, %then364
  %arg_ptr368 = load i32, ptr %arg_ptr, align 4
  %392 = icmp ne i32 %arg_ptr368, 0
  br i1 %392, label %for.body369, label %for.last393

for.body369:                                      ; preds = %for.cond367
  %arg_ptr371 = load i32, ptr %arg_ptr, align 4
  %env_ptr372 = load i32, ptr %env_ptr2, align 4
  %393 = call i32 @eval(i32 %arg_ptr371, i32 %env_ptr372)
  store i32 %393, ptr %value_ptr370, align 4
  %value_ptr373 = load i32, ptr %value_ptr370, align 4
  %394 = call i32 @copy_data(i32 %value_ptr373)
  store i32 %394, ptr %elem_ptr, align 4
  %value_ptr374 = load i32, ptr %value_ptr370, align 4
  call void @free_data(i32 %value_ptr374)
  %cur_ptr375 = load i32, ptr %cur_ptr366, align 4
  %395 = icmp ne i32 %cur_ptr375, 0
  br i1 %395, label %then376, label %else

then376:                                          ; preds = %for.body369
  %data377 = load [2048 x [2048 x i32]], ptr @data, align 4
  %cur_ptr378 = load i32, ptr %cur_ptr366, align 4
  %396 = getelementptr inbounds [2048 x i32], ptr @data, i32 %cur_ptr378
  %397 = load [2048 x i32], ptr %396, align 4
  %DATA_NEXT379 = load i32, ptr @DATA_NEXT, align 4
  %398 = getelementptr inbounds i32, ptr %396, i32 %DATA_NEXT379
  %399 = load i32, ptr %398, align 4
  %elem_ptr380 = load i32, ptr %elem_ptr, align 4
  store i32 %elem_ptr380, ptr %398, align 4
  br label %last385

else:                                             ; preds = %for.body369
  %data381 = load [2048 x [2048 x i32]], ptr @data, align 4
  %result_ptr382 = load i32, ptr %result_ptr365, align 4
  %400 = getelementptr inbounds [2048 x i32], ptr @data, i32 %result_ptr382
  %401 = load [2048 x i32], ptr %400, align 4
  %DATA_VALUE383 = load i32, ptr @DATA_VALUE, align 4
  %402 = getelementptr inbounds i32, ptr %400, i32 %DATA_VALUE383
  %403 = load i32, ptr %402, align 4
  %elem_ptr384 = load i32, ptr %elem_ptr, align 4
  store i32 %elem_ptr384, ptr %402, align 4
  br label %last385

last385:                                          ; preds = %else, %then376
  %cur_ptr386 = load i32, ptr %cur_ptr366, align 4
  %elem_ptr387 = load i32, ptr %elem_ptr, align 4
  store i32 %elem_ptr387, ptr %cur_ptr366, align 4
  %arg_ptr388 = load i32, ptr %arg_ptr, align 4
  %data389 = load [2048 x [2048 x i32]], ptr @data, align 4
  %arg_ptr390 = load i32, ptr %arg_ptr, align 4
  %404 = getelementptr inbounds [2048 x i32], ptr @data, i32 %arg_ptr390
  %405 = load [2048 x i32], ptr %404, align 4
  %DATA_NEXT391 = load i32, ptr @DATA_NEXT, align 4
  %406 = getelementptr inbounds i32, ptr %404, i32 %DATA_NEXT391
  %407 = load i32, ptr %406, align 4
  store i32 %407, ptr %arg_ptr, align 4
  br label %for.inc392

for.inc392:                                       ; preds = %last385
  br label %for.cond367

for.last393:                                      ; preds = %for.cond367
  %result_ptr394 = load i32, ptr %result_ptr365, align 4
  ret i32 %result_ptr394

last395:                                          ; preds = %last362
  %data397 = load [2048 x [2048 x i32]], ptr @data, align 4
  %arg_ptr398 = load i32, ptr %arg_ptr, align 4
  %408 = getelementptr inbounds [2048 x i32], ptr @data, i32 %arg_ptr398
  %409 = load [2048 x i32], ptr %408, align 4
  %DATA_NEXT399 = load i32, ptr @DATA_NEXT, align 4
  %410 = getelementptr inbounds i32, ptr %408, i32 %DATA_NEXT399
  %411 = load i32, ptr %410, align 4
  store i32 %411, ptr %arg2_ptr396, align 4
  %arg_ptr400 = load i32, ptr %arg_ptr, align 4
  %412 = icmp ne i32 %arg_ptr400, 0
  %413 = xor i1 %412, true
  %414 = zext i1 %413 to i32
  %415 = icmp ne i32 %414, 0
  br i1 %415, label %trueBB403, label %nextBB401

nextBB401:                                        ; preds = %last395
  %arg2_ptr402 = load i32, ptr %arg2_ptr396, align 4
  %416 = icmp ne i32 %arg2_ptr402, 0
  %417 = xor i1 %416, true
  %418 = zext i1 %417 to i32
  %419 = icmp ne i32 %418, 0
  %420 = zext i1 %419 to i32
  br label %mergeBB404

trueBB403:                                        ; preds = %last395
  br label %mergeBB404

mergeBB404:                                       ; preds = %trueBB403, %nextBB401
  %421 = phi i32 [ %420, %nextBB401 ], [ 1, %trueBB403 ]
  %422 = icmp ne i32 %421, 0
  br i1 %422, label %trueBB409, label %nextBB405

nextBB405:                                        ; preds = %mergeBB404
  %data406 = load [2048 x [2048 x i32]], ptr @data, align 4
  %arg2_ptr407 = load i32, ptr %arg2_ptr396, align 4
  %423 = getelementptr inbounds [2048 x i32], ptr @data, i32 %arg2_ptr407
  %424 = load [2048 x i32], ptr %423, align 4
  %DATA_NEXT408 = load i32, ptr @DATA_NEXT, align 4
  %425 = getelementptr inbounds i32, ptr %423, i32 %DATA_NEXT408
  %426 = load i32, ptr %425, align 4
  %427 = icmp ne i32 %426, 0
  %428 = zext i1 %427 to i32
  br label %mergeBB410

trueBB409:                                        ; preds = %mergeBB404
  br label %mergeBB410

mergeBB410:                                       ; preds = %trueBB409, %nextBB405
  %429 = phi i32 [ %428, %nextBB405 ], [ 1, %trueBB409 ]
  %430 = icmp ne i32 %429, 0
  br i1 %430, label %then411, label %last413

then411:                                          ; preds = %mergeBB410
  %ERR_INVALID_ARG_NUM412 = load i32, ptr @ERR_INVALID_ARG_NUM, align 4
  %431 = call i32 @panic(i32 %ERR_INVALID_ARG_NUM412)
  br label %last413

last413:                                          ; preds = %then411, %mergeBB410
  %arg_ptr415 = load i32, ptr %arg_ptr, align 4
  %env_ptr416 = load i32, ptr %env_ptr2, align 4
  %432 = call i32 @eval(i32 %arg_ptr415, i32 %env_ptr416)
  store i32 %432, ptr %value1_ptr414, align 4
  %arg2_ptr418 = load i32, ptr %arg2_ptr396, align 4
  %env_ptr419 = load i32, ptr %env_ptr2, align 4
  %433 = call i32 @eval(i32 %arg2_ptr418, i32 %env_ptr419)
  store i32 %433, ptr %value2_ptr417, align 4
  %value1_ptr420 = load i32, ptr %value1_ptr414, align 4
  %434 = call i32 @unwrap_number(i32 %value1_ptr420)
  store i32 %434, ptr %lhs, align 4
  %value2_ptr421 = load i32, ptr %value2_ptr417, align 4
  %435 = call i32 @unwrap_number(i32 %value2_ptr421)
  store i32 %435, ptr %rhs, align 4
  store i32 0, ptr %result_ptr422, align 4
  %sym_ptr423 = load i32, ptr %sym_ptr, align 4
  %SYM_ADD = load i32, ptr @SYM_ADD, align 4
  %436 = icmp eq i32 %sym_ptr423, %SYM_ADD
  %437 = sext i1 %436 to i32
  %438 = icmp ne i32 %437, 0
  br i1 %438, label %then424, label %else428

then424:                                          ; preds = %last413
  %result_ptr425 = load i32, ptr %result_ptr422, align 4
  %lhs426 = load i32, ptr %lhs, align 4
  %rhs427 = load i32, ptr %rhs, align 4
  %439 = add nsw i32 %lhs426, %rhs427
  %440 = call i32 @make_number(i32 %439)
  store i32 %440, ptr %result_ptr422, align 4
  br label %last485

else428:                                          ; preds = %last413
  %sym_ptr429 = load i32, ptr %sym_ptr, align 4
  %SYM_SUB = load i32, ptr @SYM_SUB, align 4
  %441 = icmp eq i32 %sym_ptr429, %SYM_SUB
  %442 = sext i1 %441 to i32
  %443 = icmp ne i32 %442, 0
  br i1 %443, label %then430, label %else434

then430:                                          ; preds = %else428
  %result_ptr431 = load i32, ptr %result_ptr422, align 4
  %lhs432 = load i32, ptr %lhs, align 4
  %rhs433 = load i32, ptr %rhs, align 4
  %444 = sub nsw i32 %lhs432, %rhs433
  %445 = call i32 @make_number(i32 %444)
  store i32 %445, ptr %result_ptr422, align 4
  br label %last484

else434:                                          ; preds = %else428
  %sym_ptr435 = load i32, ptr %sym_ptr, align 4
  %SYM_MUL = load i32, ptr @SYM_MUL, align 4
  %446 = icmp eq i32 %sym_ptr435, %SYM_MUL
  %447 = sext i1 %446 to i32
  %448 = icmp ne i32 %447, 0
  br i1 %448, label %then436, label %else440

then436:                                          ; preds = %else434
  %result_ptr437 = load i32, ptr %result_ptr422, align 4
  %lhs438 = load i32, ptr %lhs, align 4
  %rhs439 = load i32, ptr %rhs, align 4
  %449 = mul nsw i32 %lhs438, %rhs439
  %450 = call i32 @make_number(i32 %449)
  store i32 %450, ptr %result_ptr422, align 4
  br label %last483

else440:                                          ; preds = %else434
  %sym_ptr441 = load i32, ptr %sym_ptr, align 4
  %SYM_DIV = load i32, ptr @SYM_DIV, align 4
  %451 = icmp eq i32 %sym_ptr441, %SYM_DIV
  %452 = sext i1 %451 to i32
  %453 = icmp ne i32 %452, 0
  br i1 %453, label %then442, label %else446

then442:                                          ; preds = %else440
  %result_ptr443 = load i32, ptr %result_ptr422, align 4
  %lhs444 = load i32, ptr %lhs, align 4
  %rhs445 = load i32, ptr %rhs, align 4
  %454 = sdiv i32 %lhs444, %rhs445
  %455 = call i32 @make_number(i32 %454)
  store i32 %455, ptr %result_ptr422, align 4
  br label %last482

else446:                                          ; preds = %else440
  %sym_ptr447 = load i32, ptr %sym_ptr, align 4
  %SYM_LT = load i32, ptr @SYM_LT, align 4
  %456 = icmp eq i32 %sym_ptr447, %SYM_LT
  %457 = sext i1 %456 to i32
  %458 = icmp ne i32 %457, 0
  br i1 %458, label %then448, label %else452

then448:                                          ; preds = %else446
  %result_ptr449 = load i32, ptr %result_ptr422, align 4
  %lhs450 = load i32, ptr %lhs, align 4
  %rhs451 = load i32, ptr %rhs, align 4
  %459 = icmp slt i32 %lhs450, %rhs451
  %460 = sext i1 %459 to i32
  %461 = call i32 @make_bool(i32 %460)
  store i32 %461, ptr %result_ptr422, align 4
  br label %last481

else452:                                          ; preds = %else446
  %sym_ptr453 = load i32, ptr %sym_ptr, align 4
  %SYM_LE = load i32, ptr @SYM_LE, align 4
  %462 = icmp eq i32 %sym_ptr453, %SYM_LE
  %463 = sext i1 %462 to i32
  %464 = icmp ne i32 %463, 0
  br i1 %464, label %then454, label %else458

then454:                                          ; preds = %else452
  %result_ptr455 = load i32, ptr %result_ptr422, align 4
  %lhs456 = load i32, ptr %lhs, align 4
  %rhs457 = load i32, ptr %rhs, align 4
  %465 = icmp sle i32 %lhs456, %rhs457
  %466 = sext i1 %465 to i32
  %467 = call i32 @make_bool(i32 %466)
  store i32 %467, ptr %result_ptr422, align 4
  br label %last480

else458:                                          ; preds = %else452
  %sym_ptr459 = load i32, ptr %sym_ptr, align 4
  %SYM_GT = load i32, ptr @SYM_GT, align 4
  %468 = icmp eq i32 %sym_ptr459, %SYM_GT
  %469 = sext i1 %468 to i32
  %470 = icmp ne i32 %469, 0
  br i1 %470, label %then460, label %else464

then460:                                          ; preds = %else458
  %result_ptr461 = load i32, ptr %result_ptr422, align 4
  %lhs462 = load i32, ptr %lhs, align 4
  %rhs463 = load i32, ptr %rhs, align 4
  %471 = icmp sgt i32 %lhs462, %rhs463
  %472 = sext i1 %471 to i32
  %473 = call i32 @make_bool(i32 %472)
  store i32 %473, ptr %result_ptr422, align 4
  br label %last479

else464:                                          ; preds = %else458
  %sym_ptr465 = load i32, ptr %sym_ptr, align 4
  %SYM_GE = load i32, ptr @SYM_GE, align 4
  %474 = icmp eq i32 %sym_ptr465, %SYM_GE
  %475 = sext i1 %474 to i32
  %476 = icmp ne i32 %475, 0
  br i1 %476, label %then466, label %else470

then466:                                          ; preds = %else464
  %result_ptr467 = load i32, ptr %result_ptr422, align 4
  %lhs468 = load i32, ptr %lhs, align 4
  %rhs469 = load i32, ptr %rhs, align 4
  %477 = icmp sge i32 %lhs468, %rhs469
  %478 = sext i1 %477 to i32
  %479 = call i32 @make_bool(i32 %478)
  store i32 %479, ptr %result_ptr422, align 4
  br label %last478

else470:                                          ; preds = %else464
  %sym_ptr471 = load i32, ptr %sym_ptr, align 4
  %SYM_EQ_NUM = load i32, ptr @SYM_EQ_NUM, align 4
  %480 = icmp eq i32 %sym_ptr471, %SYM_EQ_NUM
  %481 = sext i1 %480 to i32
  %482 = icmp ne i32 %481, 0
  br i1 %482, label %then472, label %else476

then472:                                          ; preds = %else470
  %result_ptr473 = load i32, ptr %result_ptr422, align 4
  %lhs474 = load i32, ptr %lhs, align 4
  %rhs475 = load i32, ptr %rhs, align 4
  %483 = icmp eq i32 %lhs474, %rhs475
  %484 = sext i1 %483 to i32
  %485 = call i32 @make_bool(i32 %484)
  store i32 %485, ptr %result_ptr422, align 4
  br label %last477

else476:                                          ; preds = %else470
  %ERR_INVALID_SYMBOL = load i32, ptr @ERR_INVALID_SYMBOL, align 4
  %486 = call i32 @panic(i32 %ERR_INVALID_SYMBOL)
  br label %last477

last477:                                          ; preds = %else476, %then472
  br label %last478

last478:                                          ; preds = %last477, %then466
  br label %last479

last479:                                          ; preds = %last478, %then460
  br label %last480

last480:                                          ; preds = %last479, %then454
  br label %last481

last481:                                          ; preds = %last480, %then448
  br label %last482

last482:                                          ; preds = %last481, %then442
  br label %last483

last483:                                          ; preds = %last482, %then436
  br label %last484

last484:                                          ; preds = %last483, %then430
  br label %last485

last485:                                          ; preds = %last484, %then424
  %value1_ptr486 = load i32, ptr %value1_ptr414, align 4
  call void @free_data(i32 %value1_ptr486)
  %value2_ptr487 = load i32, ptr %value2_ptr417, align 4
  call void @free_data(i32 %value2_ptr487)
  %result_ptr488 = load i32, ptr %result_ptr422, align 4
  ret i32 %result_ptr488

last489:                                          ; preds = %last16
  %ERR_INVALID_DATA_TYPE = load i32, ptr @ERR_INVALID_DATA_TYPE, align 4
  %487 = call i32 @panic(i32 %ERR_INVALID_DATA_TYPE)
  ret i32 %487
}

define void @print(i32 %data_ptr) {
entry:
  %list_ptr = alloca i32, align 4
  %data_ptr1 = alloca i32, align 4
  store i32 %data_ptr, ptr %data_ptr1, align 4
  %data = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr2 = load i32, ptr %data_ptr1, align 4
  %0 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr2
  %1 = load [2048 x i32], ptr %0, align 4
  %DATA_TYPE = load i32, ptr @DATA_TYPE, align 4
  %2 = getelementptr inbounds i32, ptr %0, i32 %DATA_TYPE
  %3 = load i32, ptr %2, align 4
  %DATA_TYPE_SYMBOL = load i32, ptr @DATA_TYPE_SYMBOL, align 4
  %4 = icmp eq i32 %3, %DATA_TYPE_SYMBOL
  %5 = sext i1 %4 to i32
  %6 = icmp ne i32 %5, 0
  br i1 %6, label %then, label %last

then:                                             ; preds = %entry
  %data3 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr4 = load i32, ptr %data_ptr1, align 4
  %7 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr4
  %8 = load [2048 x i32], ptr %7, align 4
  %DATA_VALUE = load i32, ptr @DATA_VALUE, align 4
  %9 = getelementptr inbounds i32, ptr %7, i32 %DATA_VALUE
  %10 = load i32, ptr %9, align 4
  call void @print_sym(i32 %10)
  ret void

last:                                             ; preds = %entry
  %data5 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr6 = load i32, ptr %data_ptr1, align 4
  %11 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr6
  %12 = load [2048 x i32], ptr %11, align 4
  %DATA_TYPE7 = load i32, ptr @DATA_TYPE, align 4
  %13 = getelementptr inbounds i32, ptr %11, i32 %DATA_TYPE7
  %14 = load i32, ptr %13, align 4
  %DATA_TYPE_NUMBER = load i32, ptr @DATA_TYPE_NUMBER, align 4
  %15 = icmp eq i32 %14, %DATA_TYPE_NUMBER
  %16 = sext i1 %15 to i32
  %17 = icmp ne i32 %16, 0
  br i1 %17, label %then8, label %last12

then8:                                            ; preds = %last
  %data9 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr10 = load i32, ptr %data_ptr1, align 4
  %18 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr10
  %19 = load [2048 x i32], ptr %18, align 4
  %DATA_VALUE11 = load i32, ptr @DATA_VALUE, align 4
  %20 = getelementptr inbounds i32, ptr %18, i32 %DATA_VALUE11
  %21 = load i32, ptr %20, align 4
  call void @putint(i32 %21)
  ret void

last12:                                           ; preds = %last
  %data13 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr14 = load i32, ptr %data_ptr1, align 4
  %22 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr14
  %23 = load [2048 x i32], ptr %22, align 4
  %DATA_TYPE15 = load i32, ptr @DATA_TYPE, align 4
  %24 = getelementptr inbounds i32, ptr %22, i32 %DATA_TYPE15
  %25 = load i32, ptr %24, align 4
  %DATA_TYPE_LIST = load i32, ptr @DATA_TYPE_LIST, align 4
  %26 = icmp eq i32 %25, %DATA_TYPE_LIST
  %27 = sext i1 %26 to i32
  %28 = icmp ne i32 %27, 0
  br i1 %28, label %then16, label %last28

then16:                                           ; preds = %last12
  call void @putch(i32 40)
  %data17 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr18 = load i32, ptr %data_ptr1, align 4
  %29 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr18
  %30 = load [2048 x i32], ptr %29, align 4
  %DATA_VALUE19 = load i32, ptr @DATA_VALUE, align 4
  %31 = getelementptr inbounds i32, ptr %29, i32 %DATA_VALUE19
  %32 = load i32, ptr %31, align 4
  store i32 %32, ptr %list_ptr, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %then16
  %list_ptr20 = load i32, ptr %list_ptr, align 4
  %33 = icmp ne i32 %list_ptr20, 0
  br i1 %33, label %for.body, label %for.last

for.body:                                         ; preds = %for.cond
  %list_ptr21 = load i32, ptr %list_ptr, align 4
  call void @print(i32 %list_ptr21)
  %list_ptr22 = load i32, ptr %list_ptr, align 4
  %data23 = load [2048 x [2048 x i32]], ptr @data, align 4
  %list_ptr24 = load i32, ptr %list_ptr, align 4
  %34 = getelementptr inbounds [2048 x i32], ptr @data, i32 %list_ptr24
  %35 = load [2048 x i32], ptr %34, align 4
  %DATA_NEXT = load i32, ptr @DATA_NEXT, align 4
  %36 = getelementptr inbounds i32, ptr %34, i32 %DATA_NEXT
  %37 = load i32, ptr %36, align 4
  store i32 %37, ptr %list_ptr, align 4
  %list_ptr25 = load i32, ptr %list_ptr, align 4
  %38 = icmp ne i32 %list_ptr25, 0
  br i1 %38, label %then26, label %last27

then26:                                           ; preds = %for.body
  call void @putch(i32 32)
  br label %last27

last27:                                           ; preds = %then26, %for.body
  br label %for.inc

for.inc:                                          ; preds = %last27
  br label %for.cond

for.last:                                         ; preds = %for.cond
  call void @putch(i32 41)
  ret void

last28:                                           ; preds = %last12
  %data29 = load [2048 x [2048 x i32]], ptr @data, align 4
  %data_ptr30 = load i32, ptr %data_ptr1, align 4
  %39 = getelementptr inbounds [2048 x i32], ptr @data, i32 %data_ptr30
  %40 = load [2048 x i32], ptr %39, align 4
  %DATA_TYPE31 = load i32, ptr @DATA_TYPE, align 4
  %41 = getelementptr inbounds i32, ptr %39, i32 %DATA_TYPE31
  %42 = load i32, ptr %41, align 4
  %DATA_TYPE_FUNC = load i32, ptr @DATA_TYPE_FUNC, align 4
  %43 = icmp eq i32 %42, %DATA_TYPE_FUNC
  %44 = sext i1 %43 to i32
  %45 = icmp ne i32 %44, 0
  br i1 %45, label %then32, label %last34

then32:                                           ; preds = %last28
  call void @putch(i32 35)
  call void @putch(i32 60)
  call void @putch(i32 102)
  call void @putch(i32 117)
  call void @putch(i32 110)
  call void @putch(i32 99)
  call void @putch(i32 32)
  %data_ptr33 = load i32, ptr %data_ptr1, align 4
  call void @putint(i32 %data_ptr33)
  call void @putch(i32 62)
  ret void

last34:                                           ; preds = %last28
  %ERR_INVALID_DATA_TYPE = load i32, ptr @ERR_INVALID_DATA_TYPE, align 4
  %46 = call i32 @panic(i32 %ERR_INVALID_DATA_TYPE)
  ret void
}

define i32 @main() {
entry:
  %result_ptr = alloca i32, align 4
  %data_ptr = alloca i32, align 4
  %global_env_ptr = alloca i32, align 4
  call void @init_data()
  %0 = call i32 @make_env(i32 0)
  store i32 %0, ptr %global_env_ptr, align 4
  %last_token_type = load i32, ptr @last_token_type, align 4
  %1 = call i32 @next_token()
  store i32 %1, ptr @last_token_type, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  br i1 true, label %for.body, label %for.last

for.body:                                         ; preds = %for.cond
  %2 = call i32 @parse()
  store i32 %2, ptr %data_ptr, align 4
  %data_ptr1 = load i32, ptr %data_ptr, align 4
  %3 = icmp eq i32 %data_ptr1, 0
  %4 = sext i1 %3 to i32
  %5 = icmp ne i32 %4, 0
  br i1 %5, label %then, label %last

then:                                             ; preds = %for.body
  br label %for.last

last:                                             ; preds = %for.body
  %data_ptr2 = load i32, ptr %data_ptr, align 4
  %global_env_ptr3 = load i32, ptr %global_env_ptr, align 4
  %6 = call i32 @eval(i32 %data_ptr2, i32 %global_env_ptr3)
  store i32 %6, ptr %result_ptr, align 4
  %result_ptr4 = load i32, ptr %result_ptr, align 4
  %7 = icmp ne i32 %result_ptr4, 0
  br i1 %7, label %then5, label %last7

then5:                                            ; preds = %last
  %result_ptr6 = load i32, ptr %result_ptr, align 4
  call void @print(i32 %result_ptr6)
  call void @putch(i32 10)
  br label %last7

last7:                                            ; preds = %then5, %last
  %data_ptr8 = load i32, ptr %data_ptr, align 4
  call void @free_data(i32 %data_ptr8)
  %result_ptr9 = load i32, ptr %result_ptr, align 4
  call void @free_data(i32 %result_ptr9)
  br label %for.inc

for.inc:                                          ; preds = %last7
  br label %for.cond

for.last:                                         ; preds = %then, %for.cond
  ret i32 0
}
