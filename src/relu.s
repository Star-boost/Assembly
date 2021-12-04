.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 57
# ==============================================================================

# Plan
#store element counter
#while element counter is not equal to length of array
#	if zero is greater than or equal to value at 0(a0)
#		change it to zero
#	advance a0 counter
#	increment element counter

#s0 == element counter
#s1 == current element


relu:
	addi t0 x0 1
	blt a1 t0 exit
	# Prologue
    addi sp sp -16
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)

    add s0 x0 x0
    add s1 x0 x0
    add s2 x0 a0
    add s3 x0 a1
loop_start:
	beq s0 s3 loop_end
    lw s1 0(s2)
    bge s1 x0 loop_continue
    sw x0 0(s2)

loop_continue:
	addi s2 s2 4
   	addi s0 s0 1
    j loop_start

exit:
	addi a1 x0 57
    call exit2
    
    ret

loop_end:
	 # Epilogue
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
	addi sp sp 16

	ret


