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
#   this function terminates the program with error code 88
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 89
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 90
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91
# ==============================================================================
read_matrix:

    # Prologue
   	addi sp sp -24
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    
	# End Prologue
 	add s1 x0 a1
    add s2 x0 a2
    add s3 x0 x0
    add s4 x0 x0
    
	# 1: Open the file
    
    # Setting arguments
  	mv a1 a0
    addi a2 x0 0
    # End setting arguments
    
    jal ra fopen

    
    addi t0 x0 -1
    beq a0 t0 fopen_error

    mv s0 a0
    
	# 2: Read the number of rows and columns
    
    #2a Reading rows

    # Setting arguments
	mv a2 s1
    mv a1 s0
    addi a3 x0 4
    # End setting arguments

    jal ra fread

    
    addi a3 x0 4
    bne a0 a3 fread_error
    addi a3 x0 4
    
	#2b Reading columns
    
    # Setting arguments

	mv a2 s2
    mv a1 s0
    addi a3 x0 4
    # End setting arguments

    
    jal ra fread

    
    addi a3 x0 4
    bne a0 a3 fread_error
    addi a3 x0 4

    # 3 Allocate space on heap to store matrix

    lw t0 0(s1)
    lw t1 0(s2)
    mul s3 t0 t1
    addi t0 x0 4
    mul s3 s3 t0
    
    # Setting variables
	mv a0 s3
    # End setting variables

    
    jal ra malloc

    
    beq a0 x0 malloc_error

    
    mv s4 a0
    
    # 4 Read the matrix

    # Setting arguments
	mv a2 s4
    mv a1 s0
    mv a3 s3
    # End setting arguments

   
    jal ra fread
 

    mv a3 s3
    bne a0 a3 fread_error
    mv a3 s3
    
    # 5 Close the file
    
    # Setting arguments
	mv a1 s0
    # End setting arguments
    
    jal ra fclose

    
    bne a0 x0 fclose_error
 
    # 6 Return a pointer to the matrix in memory
	add a1 x0 s1
    add a2 x0 s2
    add a0 x0 s4

    
    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    addi sp sp 24
    
	# End Epilogue
    
    ret

malloc_error:
	addi a1 x0 88
    call exit2
   	ret

fopen_error:
	addi a1 x0 89
    call exit2
    ret

fclose_error:
	addi a1 x0 90
    call exit2
    ret

fread_error:
	addi a1 x0 91
    call exit2
    ret