.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    # checkArgcError
    li t0, 5
    bne a0, t0, Exit89
    addi sp, sp, -48
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    mv s0, a1
    mv s1, a2 

	# =====================================
    # LOAD MATRICES
    # =====================================
    li a0, 8
    jal malloc
    beq a0, x0, Exit88
    mv s2, a0 #s2 point to the m0.row m0.col
    # Load pretrained m0
    lw a0, 4(s0) #pointer to m0 filePath
    addi a1, s2, 0
    addi a2, s2, 4
    jal read_matrix
    mv s3, a0 #s3 is the pointer to the m0 matrix
 
    li a0, 8
    jal malloc
    beq a0, x0, Exit88
    mv s4, a0 #s4 point to the m1.row m1.col
    # Load pretrained m1
    lw a0, 8(s0) #pointer to the m1 filePath
    addi a1, s4, 0
    addi a2, s4, 4
    jal read_matrix
    mv s5, a0 #s5 is the pointer to the m1 matrix
    
    li a0, 8
    jal malloc
    beq a0, x0, Exit88
    mv s6, a0 #s6 point to the input.row input.col
    # Load input matrix
    lw a0, 12(s0) #pointer to the input matrix
    addi a1, s6, 0
    addi a2, s6, 4
    jal read_matrix
    mv s7, a0 #s7 is the pointer to the input matrix

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    lw t0, 0(s2) #allocate the memory for the Relu
    li t1, 4
    mul a0, t0, t1
    jal malloc
    beq a0, x0, Exit88
    mv s8, a0 #s8 point to Relu

    mv a0, s3
    lw a1, 0(s2)
    lw a2, 4(s2)
    mv a3, s7
    lw t0, 0(s6)
    lw t1, 4(s6)
    mul a4, t0, t1
    li a5, 1 #convert to one col
    mv a6, s8
    jal matmul

    mv a0, s8
    lw a1, 0(s2)
    jal relu

    lw t0, 0(s4) #allocate the memory for the resultMatrix
    li t1, 4
    mul a0, t0, t1
    jal malloc
    beq a0, x0, Exit88
    mv s9, a0 #s9 point to resultMatrix

    mv a0, s5
    lw a1, 0(s4)
    lw a2, 4(s4)
    mv a3, s8
    lw a4, 0(s2)
    li a5, 1
    mv a6, s9
    jal matmul


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0, 16(s0)
    mv a1, s9
    lw a2, 0(s4)
    li a3, 1
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s9
    lw a1, 0(s4)
    jal argmax
    mv s10, a0
    # Print classification
    bne s1, x0, not_print
    mv a1, s10
    jal print_int
    # Print newline afterwards for clarity
	li a1 '\n'
    jal print_char
    
not_print:
	# free the space
    mv a0, s2
    jal free
    mv a0, s3
    jal free
    mv a0, s4
    jal free
    mv a0, s5
    jal free
    mv a0, s6
    jal free
    mv a0, s7
    jal free
    mv a0, s8
    jal free
    mv a0, s9
    jal free

    # epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    lw s10, 44(sp)
    addi sp, sp, 48


    ret


Exit88:
    li a1, 88
    j exit2

Exit89:
    li a1, 89
    j exit2
