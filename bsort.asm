.data
nums: .word 0x16,0x6,0x9,0x20,0x39,0x5,0x8,0x18
 .space 200
 sptop:

.text
.globl main

main:
	# let $s0, $s1, $s2 have initial values 
  addi $s0,$s0,0
  addi $s1,$s1,0
  addi $s2,$s2,0

  la $sp,sptop 

  add $a0, $zero, $zero
  #la $a0,nums   
  li $a1,8
  jal sort

	# output sort result 
 add $s0, $zero, $zero
  #la $s0,nums  
  lw $s1,0($s0)
  lw $s1,4($s0)
  lw $s1,8($s0)
  lw $s1,12($s0)
  lw $s1,16($s0)
  lw $s1,20($s0)
  lw $s1,24($s0)
  lw $s1,28($s0)

loop: 
   j loop

#v(array) in $a0, k(length) in $a1
sort: 
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $s3, 12($sp)
	sw $s2, 8($sp)	
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	move $s2, $a0 # copy parameters into $a0, $a1
	move $s3, $a1 
	
	move $s0, $zero # i = 0
for1tst:
	slt $t0, $s0, $s3      # reg $t0 = 0 if $s0 >= $s3 (i >= n)
	beq $t0, $zero, exit1  # go to exit1 if $s0 >= $s3 (i >= n)
	
	addi $s1, $s0, -1      # j = i - 1
for2tst:
	slti $t0, $s1, 0  	   # reg $t0 = 1 if $s1 < 0 (j < 0)   
	bne $t0, $zero, exit2  	   # go to exit2 if $s1 < 0 (j < 0) 
	sll $t1, $s1, 2 	   # reg $t1 = j * 4
	add $t2, $s2, $t1	   # reg $t2 = v + (j * 4)
	lw $t3, 0($t2)   	   # reg $t0 = v[j] 
	lw $t4, 4($t2)	 	   # reg $t4 = v[j+1]
	slt $t0, $t4, $t3      # reg $t0 = 0 if $t4 < $t3
	beq $t0, $zero, exit2  # go to eit2 if $t4 < $t3
	
	move $a0, $s2
	move $a1, $s1
	jal swap
	
	addi $s1, $s1, -1 # j -= 1
	j for2tst		  # jump to test of inner loop	
exit2: 
    addi $s0, $s0, 1   # i += 1
	j for1tst          # jump to test of outer loop

exit1:
	lw $s0, 0($sp)	   # restore $s0 from stack
	lw $s1, 4($sp)	   # restore $s1 from stack
	lw $s2, 8($sp)	   # restore $s2 from stack	
	lw $s3, 12($sp)	   # restore $s3 from stack
	lw $ra, 16($sp)	   # restore $ra from stack
	addi $sp, $sp, 20  # restore stack pointer
	
    jr $ra                 # return to calling routine


swap: 
	  sll $t1, $a1, 2	# reg $t1 = k*4
	  add $t1, $a0, $t1	# reg $t1 = v + (k * 4)
						#  reg $t1 has the address of v[k]
	  lw $t0, 0($t1)	# reg $t0(temp) = v[k]
	  lw $t2, 4($t1)	# reg $t2 = v[k+1]
	  
	  sw $t2, 0($t1)	# v[k] = reg $t2
	  sw $t0, 4($t1)	# v[k+1] = reg $t0 (temp)
	  
      jr $ra            # return to calling routine

