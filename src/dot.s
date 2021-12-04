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
#   this function terminates the program with error code 57
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 58
# =======================================================

# Plan
# store the first element of each array

# while the number of elements is not zero
#	multiply element of a0 by element of a1
#	add to running total
#	decrement the number of elements
#	adjust the stride for each array to save next values
# return running total



# s0 == the current element of a0
# s1 == the current element of a1
# s2 == the running total

dot:
    # Prologue
    addi sp sp -40
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw s7 28(sp)
    sw s8 32(sp)
    sw s9 36(sp)
    
    # initialize saved registers
	add s0 x0 x0
    add s1 x0 x0
    add s2 x0 x0
    add s3 x0 x0
    add s4 x0 x0
    add s5 x0 a2
    add s6 x0 a3
    add s7 x0 a4
    add s8 x0 a0
    add s9 x0 a1

	addi t0 x0 1
	blt s5 t0 exit57
    blt s6 t0 exit58
    blt s7 t0 exit58

loop_start:
	beq s5 x0 loop_end
    lw s0 0(s8)
    lw s1 0(s9)
	mul t0 s0 s1			# multiply elements
    add s2 s2 t0			# add to running total
    
	addi s5 s5 -1			# decrement number of elements
    
    addi s3 x0 4			# save the number 4
	mul s3 s6 s3			# multiply 4 by the stride
    add s8 s8 s3			# add to set up next element
    
    addi s4 x0 4			# save the number 4
    mul s4 s7 s4			# multiply 4 by the stride
    add s9 s9 s4			# add to set up next element
    
    j loop_start

loop_end:
	mv a0 s2

    # Epilogue
	lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw s7 28(sp)
    lw s8 32(sp)
    lw s9 36(sp)
    addi sp sp 40

    ret

exit57:
	addi a1 x0 57
	call exit2
    
    ret
    
exit58:
	addi a1 x0 58
	call exit2
    
    ret
