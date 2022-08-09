#####################################
#   TEJINDRA KHATRI 		    #
#   UNIVERSITY OF MASS LOWELL	    #
#   COMP 2030 P1 ASSEMBLY LANGUAGE  #
#   PROFESSOR:    		    #
#   DATE 09/18/2019                 #
#   HOMEWORK:- 1                    #
#####################################
.data
	arrayA: .word 9080, 220, 83, 72
	size_of_arrayA: .word 4
	print_message_sum: .asciiz "Sum is : "
	sum: .word 0
	print_message_average: .asciiz "Average is : "
	average: .word 0
	index: .word 0
	print_new_line: .asciiz "\n"
.text
main:
	la $t0, arrayA #loads arrayA into register $t0
	lw $t1, index #loads index into register $t1
	lw $t2, size_of_arrayA #loads size_of_arrayA into register $t2
	lw $t3, sum #loads sum into register $t3
while_loop:
	lw $t4, ($t0) #$t4 = arrayA[i]
	add $t3, $t3, $t4 #sum = sum + arrayA[i]
	add $t1, $t1, 1 #updates index, i++
	add $t0, $t0, 4 #updates the array address
	
	blt $t1, $t2, while_loop #if index is < size_of_arrayA let the loop continue
	
	#sw $t3, sum #stores sum in register $t3

#prints the message for sum
la $a0, print_message_sum
li $v0, 4
syscall

#prints the sum
move $a0, $t3
li $v0, 1
syscall

#prints new line
la $a0, print_new_line
li $v0, 4
syscall 

#calculating the average
div $t6, $t3, $t2 #$t6 = sum/average

#prints  the message for average
la $a0, print_message_average
li $v0, 4
syscall

#prints  the average
move $a0, $t6
li $v0, 1
syscall	

#prints  new line
la $a0, print_new_line
li $v0, 4
syscall 

#termination of program
li $v0, 10
syscall
