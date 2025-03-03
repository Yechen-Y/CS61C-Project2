.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================

read_matrix:
    addi sp, sp, -24
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw ra, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    # Prologue
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv a1, s0
    li a2, 0
    jal fopen#调用fopen后判断是否报错，报错则a0 == -1 
    li t0, -1
    beq a0, t0, Exit90#如果报错则使exitcode == 90
    mv s3, a0#保存fopen返回的文件码，以便后续读取该文件
    li a0, 8
    jal malloc#如果a0 == 0 则表示failed
    beq a0, x0, Exit88
    mv s4, a0#保存malloc获得的指针
    mv a1, s3
    mv a2, s4
    li a3, 8
    jal fread
    li t0, 8
    bne t0, a0, Exit91 
    lw t0, 0(s4) # row
    lw t1, 4(s4) # col
    sw t0, 0(s1)
    sw t1, 0(s2)
    mul t0, t0, t1
    li t1, 4
    mul t0, t0, t1 #获取总bytes
    mv a0, t0
    jal malloc 
    mv s4, a0
    mv a1, s3
    mv a2, s4
    lw t0, 0(s1) # row
    lw t1, 0(s2) # col
    mul t0, t0, t1
    li t1 , 4
    mul t0, t0, t1 
    mv a3, t0
    jal fread
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul t0, t0, t1
    li t1 , 4
    mul t0, t0, t1 
    bne t0, a0, Exit91
    mv a1, s3
    jal fclose
    li t0, -1
    beq a0, t0, Exit92 
    mv a0, s4
    mv a1, s1
    mv a2, s2
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw ra, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24
    ret

Exit88:
    li a1, 88
    jal exit2

Exit90:
    li a1, 90
    jal exit2

Exit91:
    li a1, 91
    jal exit2

Exit92:
    li a1, 92
    jal exit2