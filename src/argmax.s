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
#   this function terminates the program with error code 57
# =================================================================

# Plan
# initialize temp variable
# while length is not zero
# - if value is greater than temp
#		change max index
#	decrement length
# return temp

# s0 our max index
# s1 our current max value
# s2 our current value
# s3 our index counter

argmax:

	addi t0 x0 1
    blt a1 t0 exit
    # Prologue
	addi sp sp -24
    sw s0 0(sp)
    sw s1 4(sp)
	sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    
loop_start:
	add s0 x0 x0
    add s1 x0 x0
    add s2 x0 x0
    add s3 x0 x0
    add s4 x0 a0
    add s5 x0 a1
    
loop_continue:
	beq s5 x0 loop_end
    lw s2 0(s4)
    blt s2 s1 no_change 
    lw s1 0(s4)
    addi s0 s3 0
    addi s5 s5 -1
    addi s4 s4 4
    addi s3 s3 1
    j loop_continue
    
no_change:
	addi s5 s5 -1
	addi s4 s4 4
    addi s3 s3 1
    j loop_continue

loop_end:
	mv a0 s0
	
    # Epilogue
	lw s0 0(sp)
    lw s1 4(sp)
	lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    addi sp sp 24

    ret
    
exit:
	addi a1 x0 57
    call exit2
    
    ret
