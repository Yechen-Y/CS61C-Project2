.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:
    addi sp, sp, -28
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    sw s4, 16(sp)
    sw s5, 20(sp)
    sw ra, 24(sp)
    # Prologue
    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv a1, s0
    li a2, 1
    jal fopen
    li t0, -1
    beq a0, t0, Exit93
    mv s4, a0 #The file tab
    li a0, 8
    jal malloc
    beq a0, x0, Exit93
    mv s5, a0 #The heap tab
    sw s2, 0(s5)
    sw s3, 4(s5)
    mv a1, s4
    mv a2, s5
    li a3, 2
    li a4, 4
    jal fwrite
    li a3, 2
    blt a0, a3, Exit94
    mv a1, s4
    mv a2, s1
    mul a3, s2, s3
    li a4, 4
    jal fwrite
    mul a3, s2, s3
    blt a0, a3, Exit94
    mv a1, s4
    jal fclose
    li t0, -1
    beq a0, t0, Exit95
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw ra, 24(sp)
    addi sp, sp, 28
    ret

Exit93:
    li a1, 93
    jal exit2

Exit94:
    li a1, 94
    jal exit2

Exit95:
    li a1, 95
    jal exit2
