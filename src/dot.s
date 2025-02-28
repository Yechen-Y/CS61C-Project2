.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:
    li t0, 1
    bge a2, t0, JudgeStride1
    li a1, 75
    j exit2
JudgeStride1:
    bge a3, t0, JudgeStride2
    li a1, 76
    j exit2
JudgeStride2:
    bge a4, t0, NoExit
    li a1, 76
    j exit2
NoExit:
    mv t0, x0 #Set counter
    mv t3, x0 #Set the SUM
loop_start:
    lw t1, 0(a0) #v0[t0]
    lw t2, 0(a1) #v1[t0]

loop_continue:
    mul t4, t1, t2 #temp mul
    add t3, t3, t4
    addi t0, t0, 1
    beq t0, a2, loop_end
    li t5, 4 #offset
    mul t4, a3, t5 # count v0 offset
    add a0, a0, t4
    mul t4, a4, t5 # count v1 offset
    add a1, a1, t4
    j loop_start

loop_end:
    mv a0, t3
    ret
