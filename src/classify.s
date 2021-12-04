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
    #   this function terminates the program with exit code 72
    # - If malloc fails, this function terminates the program with exit code 88
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # Checking if arguments match

    # Prologue
    addi sp sp -52
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    sw s5 24(sp)
    sw s6 28(sp)
    sw s7 32(sp)
    sw s8 36(sp)
    sw s9 40(sp)
    sw s10 44(sp)
    sw s11 48(sp)

	# =====================================
    # LOAD MATRICES
    # =====================================

    addi t0 x0 5
    bne a0 t0 command_line_error

    mv s0 a1            # s0 has argv
    add s11 x0 a2           # s11 has classification bit

    # Load pretrained m0

        # Malloc space
        addi t0 x0 8
        add a0 x0 t0

        jal ra malloc
        beq a0 x0 malloc_error

        add s1 x0 a0        # s1 has m0's rows and columns
        # End malloc space

        # Setting variables
        lw a0 4(s0)
        add a1 x0 s1
        addi a2 s1 4
        # End setting variables

        jal ra read_matrix

        add s2 x0 a0        # s2 has a pointer to m0 in memory

    # Load pretrained m1

        # Malloc space
        addi t0 x0 8
        add a0 x0 t0

        jal ra malloc
        beq a0 x0 malloc_error

        add s3 x0 a0        # s3 has m1's rows and columns
        # End malloc space

        # Setting variables
        lw a0 8(s0)
        add a1 x0 s3
        addi a2 s3 4
        # End setting variables

        jal ra read_matrix

        add s4 x0 a0        # s4 has a pointer to m1 in memory

    # Load input matrix

        # Malloc space
        addi t0 x0 8
        add a0 x0 t0

        jal ra malloc
        beq a0 x0 malloc_error
        
        add s5 x0 a0        # s5 has input's rows and columns
        # End malloc space

        # Setting variables
        lw a0 12(s0)
        add a1 x0 s5
        addi a2 s5 4
        # End setting variables

        jal ra read_matrix

        add s6 x0 a0        # s6 has a pointer to input in memory


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)


    # Compute h = matmul(m0, input).

        # Malloc space
        lw t1 0(s1)
        lw t2 4(s5)
        mul t3 t1 t2
        addi t4 x0 4
        mul t3 t3 t4
        
        add a0 x0 t3
        jal ra malloc
        beq a0 x0 malloc_error

        add s7 x0 a0
        # End malloc space

        # Setting variables
        add a0 x0 s2
        lw a1 0(s1)
        lw a2 4(s1)
        add a3 x0 s6
        lw a4 0(s5)
        lw a5 4(s5)
        add a6 x0 s7
        # End setting variables

        jal ra matmul


    # Compute h = relu(h)
        
        lw t1 0(s1)
        lw t2 4(s5)
        mul t3 t1 t2
        # Setting variables
        add a0 x0 s7
        add a1 x0 t3
        # End setting variables

        jal ra relu

    # Compute o = matmul(m1, h)

        # Malloc space
        lw t1 0(s3)
        lw t2 4(s5)
        mul t3 t1 t2
        addi t4 x0 4
        mul t3 t3 t4

        add a0 x0 t3
        jal ra malloc
        beq a0 x0 malloc_error

        add s8 x0 a0
        # End malloc space

        # Setting variables
        add a0 x0 s4
        lw a1 0(s3)
        lw a2 4(s3)
        add a3 x0 s7
        lw a4 0(s1)
        lw a5 4(s5)
        add a6 x0 s8        # s8 contains pointer to output
        # End setting variables

        jal ra matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

        # Setting variables
        lw a0 16(s0)
        add a1 x0 s8
        lw a2 0(s3)
        lw a3 4(s5)
        # End setting variables

        jal write_matrix


    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax

        lw t1 0(s3)
        lw t2 4(s5)
        mul t3 t1 t2
        # Setting variables
        add a0 x0 s8
        add a1 x0 t3
        # End setting variables

        jal ra argmax

        add s9 x0 a0        # s9 has the result from argmax

        bne s11 x0 print_nothing

    # Print classification

        # Setting variables
        add a1 x0 s9
        # End setting variables

        jal ra print_int

    # Print newline afterwards for clarity

        # Setting variables
        addi a1 x0 '\n'
        # End setting variables

        jal ra print_char


    # Free any data you allocated with malloc in this function.
end:
    add a0 x0 s1
    jal ra free

    add a0 x0 s2
    jal ra free

    add a0 x0 s3
    jal ra free

    add a0 x0 s4
    jal ra free

    add a0 x0 s5
    jal ra free

    add a0 x0 s6
    jal ra free

    add a0 x0 s7
    jal ra free

    add a0 x0 s8
    jal ra free

    add a0 x0 s9

    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    lw s5 24(sp)
    lw s6 28(sp)
    lw s7 32(sp)
    lw s8 36(sp)
    lw s9 40(sp)
    lw s10 44(sp)
    lw s11 48(sp)
    addi sp sp 52

    ret


print_nothing:
    # Free any data you allocated with malloc in this function.

    add a0 x0 s1
    jal ra free

    add a0 x0 s2
    jal ra free

    add a0 x0 s3
    jal ra free

    add a0 x0 s4
    jal ra free

    add a0 x0 s5
    jal ra free

    add a0 x0 s6
    jal ra free

    add a0 x0 s7
    jal ra free

    add a0 x0 s8
    jal ra free

    add a0 x0 s9

    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    lw s5 24(sp)
    lw s6 28(sp)
    lw s7 32(sp)
    lw s8 36(sp)
    lw s9 40(sp)
    lw s10 44(sp)
    lw s11 48(sp)
    addi sp sp 52

    ret


malloc_error:
    addi a1 x0 88
    call exit2
    ret

command_line_error:
    addi a1 x0 72
    call exit2
    ret
