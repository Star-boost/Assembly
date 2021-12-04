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
#     this function terminates the program with exit code 59
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 59
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 59
# =======================================================

# Plan

#Initialize row counter variable, set it to number of rows of A (a1)
#Initialize column counter variable, set it to number of columns of B (a5)

#while our row counter is not zero
#	while our column counter is not zero
#		Dot the row of A (with stride 1) with column of B (with stride a5)
#		Load the result into corresponding entry of C (a6)
#		Increment a1 pointer by 1 to reach next column
#		Decrement column counter by 1
#	Increment a0 pointer to reach next row
#	Decrement row counter by 1
#	Make column counter a5 again
#	Jump to "while our row counter is not zero" line
	
	

#s0 == row counter
#s1 == column counter
#s2 == result of dotting
#s3 == length of the vectors

matmul:

    # Error checks
    addi t0 x0 1
	blt a1 t0 exit
    blt a2 t0 exit
	blt a4 t0 exit
    blt a5 t0 exit
    bne a2 a4 exit

    # Prologue
    addi sp sp -44
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

    # Setting variables
    add s0 x0 a0
    add s1 x0 a1
    add s2 x0 a2
    add s3 x0 a3
    add s4 x0 a4
    add s5 x0 a5
    add s6 x0 a6
    add s7 x0 a1          # s7 is our outer counter
    add s8 x0 a5          # s8 is our inner counter
    add s9 x0 a3          # s9 has reference of m1
    # End setting variables

outer_loop_start:
    beq s7 x0 outer_loop_end

    add s3 x0 s9

    add s8 x0 s5

inner_loop_start:
    beq s8 x0 inner_loop_end
    
    mv a0 s0
    mv a1 s3
    mv a2 s2
    addi a3 x0 1
    mv a4 s5
    
    jal ra dot

    sw a0 0(s6)

    addi s8 s8 -1

    addi s6 s6 4

    addi s3 s3 4

    j inner_loop_start


inner_loop_end:
    addi t0 x0 4
    mul t1 s2 t0

    add s0 s0 t1

    addi s7 s7 -1

    j outer_loop_start


outer_loop_end:
    add a6 x0 s6

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
    addi sp sp 44

    ret

exit:
	addi a1 x0 59
    call exit2
    
    ret

    
#     # Prologue
#     addi sp sp -48
#     sw ra 0(sp)
#     sw s0 4(sp)
#     sw s1 8(sp)
#     sw s2 12(sp)
#     sw s3 16(sp)
#     sw s4 20(sp)
#     sw s5 24(sp)
#     sw s6 28(sp)
#     sw s7 32(sp)
#     sw s8 36(sp)
#     sw s9 40(sp)
#     sw s10 44(sp)

    
#     add s0 x0 a1
#     add s1 x0 a5
#    	mul s3 a1 a2		# To find length of vectors
#     add s4 x0 a0
#     add s5 x0 a1
#     add s6 x0 a2
#     add s7 x0 a3
#     add s8 x0 a4
#     add s9 x0 a5
#     add s10 x0 a6

# outer_loop_start:
# 	beq s0 x0 outer_loop_end

# inner_loop_start:
# 	beq s1 x0 inner_loop_end
    
#     mv a0 s4
#     mv a2 s8
#     mv a1 s7
#     addi a3 x0 1
#     mv a4 s9
    
#     jal dot
    
#     add s2 x0 a0
   
#     sw s2 0(s10)
    
# 	addi s10 s10 4
# 	addi s7 s7 4				# We're advancing a3 here
# 	addi s1 s1 -1
#     j inner_loop_start
	
# inner_loop_end:
# 	addi t0 x0 4
#     mul t0 t0 s6				# a2 originally 
# 	add s4 s4 t0				# We're advancing a0 here
    
#     addi t0 x0 -4
#     mul t0 t0 s9				# a4 originally
#     add s7 s7 t0
    
#     addi s0 s0 -1
# 	add s1 x0 s9
# 	j outer_loop_start

# outer_loop_end:
# 	add a6 x0 s10

#     # Epilogue
#     lw ra 0(sp)
#     lw s0 4(sp)
#     lw s1 8(sp)
#     lw s2 12(sp)
#     lw s3 16(sp)
#     lw s4 20(sp)
#     lw s5 24(sp)
#     lw s6 28(sp)
#     lw s7 32(sp)
#     lw s8 36(sp)
#     lw s9 40(sp)
#     lw s10 44(sp)
#     addi sp sp 48
	
#     ret

# exit:
# 	addi a1 x0 59
#     call exit2
    
#     ret
