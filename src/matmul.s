.globl matmul
.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:
    ble a1, x0, exit72 # check errors
    ble a2, x0, exit72
    ble a4, x0, exit73
    ble a5, x0, exit73
    bne a2, a4, exit74
    addi sp, sp, -32
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw s6, 24(sp)
    sw ra, 28(sp)
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4
    mv s5, a5
    mv s6, a6
    li t0, 0 #outerLoopCounter
    mv t4, s6
     

outer_loop_start:
    li t1, 0 #innerLoopCounter
    mv t2, s3 #innerLoopHelper

inner_loop_start:
    mv a0, s0 
    mv a1, t2
    mv a2, s2
    li a3, 1 
    mv a4, s5
    addi sp, sp, -20
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw t3, 12(sp)
    sw t4, 16(sp)
    jal dot
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw t3, 12(sp)
    lw t4, 16(sp)
    addi sp, sp, 20
    sw a0, 0(t4)
    ebreak
    addi t1, t1, 1
    beq t1, s5, inner_loop_end
    addi t4, t4, 4 #如果没有结束循环，则将a6指向下一个int
    addi t2, t2, 4 #指向m1的下一列
    j inner_loop_start

inner_loop_end:
    addi t0, t0, 1 #increase the outeLoopCounter
    beq t0, s1, outer_loop_end
    li t3, 4
    mul t3, s2, t3 #计算到下一行的offset
    add s0, s0, t3 #将行指针指向下一行
    addi t4, t4, 4 # 将s6 指向下一个int
    j outer_loop_start

outer_loop_end:
    mv a6, s6
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw ra, 28(sp)
    addi sp, sp, 32
    ret

exit72:
    li a1, 72
    j exit2 

exit73:
    li a1, 73
    j exit2

exit74:
    li a1, 74
    j exit2 