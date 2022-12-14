.data
  
inBuf: .space 80
Tokens: .byte ' ':120
TOKEN: .byte ' ':12
prompt: .asciiz "Enter an input string:\n"
Error: .asciiz "Error:\n"

.text
newLine: jal getLine
la $s1, Q0 #CUR = Q0
li $s0, 1 #T = 1
li $t6, 0  
li $s4, 0


nextState: lw $s2, 0($s1)
jalr $v1, $s2 #save return addr in $v1

sll $s0, $s0, 2 #multiply by 4 for word boundary
add $s1, $s1, $s0 #$s1 = Q1
sra $s0, $s0, 2 #$s0 is back to 1
lw $s1, 0($s1) #loads the function/1st element in that table
b nextState



RETURN:
li $t8, 0 #clear inBuf
li $t7, ' '
clearBuf: bge $t8, 80, outLine
sb $t7, inBuf($t8)
addi $t8, $t8, 1
b clearBuf

outLine: #print token table
li $v0, 4
la $a0, Tokens
syscall

li $s4, 0
clearTokenTab:li $t1, ' ' #clear token table with blanks
bge $s4, 120, newLine
sw $t1, Tokens($s4)
sw $t1, Tokens+4($s4)
sw $t1, Tokens+8($s4)
addi $s4, $s4, 12
b clearTokenTab




getLine: la $a0, prompt
li $v0, 4
syscall
  
la $a0, inBuf
li $a1, 80
li $v0, 8
syscall

jr $ra

  
  
lin_search: #argument key is in $a0
#return value through $s0
li $s0, -1 #index = -1
li $t9, 0 #i = 0
bge $t9, 75, return #i>=75, return

rept2: lb $s0, Tabchar($t9) #$s0 = Tabchar[i, 0]
bne $s0, $a0, nextChar #($s0 != key) goto nextChar
lw $s0, Tabchar+4($t9) #found: return Tabchar[i,1]
b return

nextChar:
addi $t9, $t9, 1
b rept2

return: jr $ra

leave: li $v0, 10 # exit
syscall   

  
  
ACT1:   
lb $a0, inBuf($t6)
# beq $a0, '#', leave
jal lin_search #returns T
addi $t6, $t6, 1
jr $v1

ACT2: li $t5, 0
sb $a0, TOKEN($t5)
addi $s0, $s0, 0x30 #converts to chartype
sb $s0, TOKEN+10($zero)
li $t4, '\n'
sb $t4, TOKEN+11($zero)
addi $s0, $s0, -0x30

addi $t5, $t5, 1
jr $v1

ACT3: bgt $t5, 7, ERROR
sb $a0, TOKEN($t5)
addi $t5, $t5, 1
jr $v1

ACT4: lw $t3, TOKEN($zero) #first word/4 bytes in TOKEN
sw $t3, Tokens($s4)
lw $t3, TOKEN+4($zero)
sw $t3, Tokens+4($s4)
lw $t3, TOKEN+8($zero)
sw $t3, Tokens+8($s4)
addi $s4, $s4, 12
li $t3, ' ' #clear TOKEN
li $t2, 0
rept3: bgt $t2, 7, return2
sb $t3, TOKEN($t2)
addi $t2, $t2, 1
b rept3

return2: jr $v1



ERROR: la $a0, Error
li $v0, 4
syscall
b RETURN   


  
.data
STAB:
Q0: .word ACT1
.word Q1 # T1
.word Q1 # T2
.word Q1 # T3
.word Q1 # T4
.word Q1 # T5
.word Q1 # T6
.word Q11 # T7

Q1: .word ACT2
.word Q2 # T1
.word Q5 # T2
.word Q3 # T3
.word Q3 # T4
.word Q0 # T5
.word Q4 # T6
.word Q11 # T7

Q2: .word ACT1
.word Q6 # T1
.word Q7 # T2
.word Q7 # T3
.word Q7 # T4
.word Q7 # T5
.word Q7 # T6
.word Q11 # T7

Q3: .word ACT4
.word Q0 # T1
.word Q0 # T2
.word Q0 # T3
.word Q0 # T4
.word Q0 # T5
.word Q0 # T6
.word Q11 # T7

Q4: .word ACT4
.word Q10 # T1
.word Q10 # T2
.word Q10 # T3
.word Q10 # T4
.word Q10 # T5
.word Q10 # T6
.word Q11 # T7

Q5: .word ACT1
.word Q8 # T1
.word Q8 # T2
.word Q9 # T3
.word Q9 # T4
.word Q9 # T5
.word Q9 # T6
.word Q11 # T7

Q6: .word ACT3
.word Q2 # T1
.word Q2 # T2
.word Q2 # T3
.word Q2 # T4
.word Q2 # T5
.word Q2 # T6
.word Q11 # T7

Q7: .word ACT4
.word Q1 # T1
.word Q1 # T2
.word Q1 # T3
.word Q1 # T4
.word Q1 # T5
.word Q1 # T6
.word Q11 # T7

Q8: .word ACT3
.word Q5 # T1
.word Q5 # T2
.word Q5 # T3
.word Q5 # T4
.word Q5 # T5
.word Q5 # T6
.word Q11 # T7

Q9: .word ACT4
.word Q1 # T1
.word Q1 # T2
.word Q1 # T3
.word Q1 # T4
.word Q1 # T5
.word Q1 # T6
.word Q11 # T7

Q10: .word RETURN
.word Q10 # T1
.word Q10 # T2
.word Q10 # T3
.word Q10 # T4
.word Q10 # T5
.word Q10 # T6
.word Q11 # T7

Q11: .word ERROR
.word Q4 # T1
.word Q4 # T2
.word Q4 # T3
.word Q4 # T4
.word Q4 # T5
.word Q4 # T6
.word Q4 # T7



Tabchar: .word 0x0a, 6

.word ' ', 5
.word '#', 6
.word '$', 4
.word '(', 4
.word ')', 4
.word '*', 3   
.word '+', 3
.word ',', 4
.word '-', 3
.word '.', 4
.word '/', 3   

.word '0', 1
.word '1', 1
.word '2', 1
.word '3', 1
.word '4', 1   
.word '5', 1
.word '6', 1   
.word '7', 1   
.word '8', 1
.word '9', 1

.word ':', 4

.word 'A', 2
.word 'B', 2   
.word 'C', 2   
.word 'D', 2
.word 'E', 2
.word 'F', 2
.word 'G', 2
.word 'H', 2
.word 'I', 2
.word 'J', 2
.word 'K', 2
.word 'L', 2   
.word 'M', 2   
.word 'N', 2
.word 'O', 2
.word 'P', 2
.word 'Q', 2   
.word 'R', 2
.word 'S', 2
.word 'T', 2
.word 'U', 2
.word 'V', 2
.word 'W', 2
.word 'X', 2
.word 'Y', 2
.word 'Z', 2

.word 'a', 2
.word 'b', 2
.word 'c', 2   
.word 'd', 2
.word 'e', 2
.word 'f', 2
.word 'g', 2
.word 'h', 2
.word 'i', 2
.word 'j', 2
.word 'k', 2
.word 'l', 2
.word 'm', 2   
.word 'n', 2
.word 'o', 2
.word 'p', 2
.word 'q', 2
.word 'r', 2
.word 's', 2   
.word 't', 2
.word 'u', 2
.word 'v', 2
.word 'w', 2   
.word 'x', 2   
.word 'y', 2
.word 'z', 2
  
.word '\\', -1 # if you ?\? as the end-of-table symbol