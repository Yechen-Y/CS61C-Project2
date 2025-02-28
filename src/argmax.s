.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:
    li t0, 1
    bge a1, t0, NoExit
    li a1, 77
    j exit2
NoExit:
    li t0, 0 # as a counter
    li t1, 0 # the MAX index
    lw t2, 0(a0) # the MAX num
loop_start:
    lw t3, 0(a0)
    bge t2, t3, loop_continue
    mv t2, t3 # change the max num
    mv t1, t0 # change the index
loop_continue:
    addi a0, a0, 4 # increase the offset
    addi t0, t0, 1 # increase the counter
    beq t0, a1, loop_end
    j loop_start
loop_end:
    mv a0, t1
    ret
