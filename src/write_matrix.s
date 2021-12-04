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
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 92
# ==============================================================================
write_matrix:

    # Prologue
    addi sp sp -36
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    sw s5 24(sp)
    sw s6 28(sp)
    sw s7 32(sp)

    add s1 x0 x0
    add s2 x0 x0
    add s3 x0 a2
    add s4 x0 a3
    add s5 x0 x0
    mul s6 a2 a3
    add s7 x0 a1

	# 1: Open the file
    
    # Setting arguments
  	mv a1 a0
    addi a2 x0 1
    # End setting arguments
    
    jal ra fopen
    
    addi t0 x0 -1
    beq a0 t0 fopen_error

    
    mv s0 a0

    # 2: Write the number of rows and columns to the file.

    # 2a First malloc space for the row and column values
    addi t0 x0 2
    addi t2 x0 4
    mul s5 t0 t2            # Save number of bytes of rows and columns to s5

    # Setting arguments
    mv a0 s5
    # End setting arguments


    jal ra malloc

    sw s3 0(a0)
    sw s4 4(a0)


    # 2b Actually write rows and columns to the buffer.
    # Setting arguments
    mv a1 s0
    mv a2 a0
    addi a3 x0 2
    addi a4 x0 4
    # End setting arguments

    jal fwrite
    addi t0 x0 2
    bne a0 t0 fwrite_error

    # 3: Write the data to the file

    # Setting arguments
    mv a1 s0
    mv a2 s7
    mv a3 s6
    addi a4 x0 4
    # End setting arguments

    jal ra fwrite
    addi a4 x0 4

    bne a0 s6 fwrite_error

    # 4: Close the file

    # Setting arguments
    mv a1 s0
    # End setting arguments  

    jal ra fclose

    bne a0 x0 fclose_error

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
    addi sp sp 36

    ret

fopen_error:
    addi a1 x0 89
    call exit2
    ret

fwrite_error:
    addi a1 x0 92
    call exit2
    ret

fclose_error:
    addi a1 x0 90
    call exit2
    ret
