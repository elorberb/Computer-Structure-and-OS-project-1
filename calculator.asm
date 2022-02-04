    .data
operation: .asciiz "\nEnter operation symbol (+, -,*,/) or '!' to quit: "
numA: .asciiz "\nEnter first number (A): "
numB: .asciiz "\nEnter second number (B): "
printResult: .asciiz "\nThe result is "
badInput: .asciiz "Bad input"
goodBye: .asciiz "\nGood bye!"
startCalculator: .asciiz "Start Calculator? (0: no, 1: yes):"


    .text

     main: 

	#print statring line
	li $v0, 4
	la $a0, startCalculator
	syscall

	#get user input - 0 or 1
	li $v0,5
	syscall

	move $t0,$v0
	li $t1, 1

	bne $t0, $t1 ,elif #if use didnt click 1
	
	addi $sp, $sp, -12
	sw $t0,0($sp)
	sw $t1,4($sp)
	sw $v0,8($sp)

	
	jal calculator
	
	lw $t0,0($sp)
	lw $t1,4($sp)
	lw $v0,8($sp)
	addi $sp, $sp, 12
	
	j exit

	#print good bye
	li $v0, 4
	la $a0, goodBye
	syscall

	j exit

     elif:
	beqz $t0 ,exit #if user clicked 0 exit
	li $v0, 4
	la $a0, badInput #if user input is not 0 or 1
	syscall

	j exit

     exit:
	#print goodbye message
	li $v0 ,4
	la,$a0,goodBye
	syscall

	#end program
	li $v0,10
	syscall

     calculator:
	#save registers to stack
	addi $sp, $sp, -12
	sw $a0,0($sp)
	sw $a1,4($sp)
	sw $a2,8($sp)
    

	loop: 
	#operation string text
	li $v0, 4
	la $a0, operation
	syscall

	# reads a character
	li $v0, 12
	syscall
	move $t0, $v0

	#read input A text
	li $v0, 4
	la $a0, numA
	syscall

	#read input A
	li $v0,5
	syscall
	move $a1 , $v0

	#read input B text
	li $v0, 4
	la $a0, numB
	syscall

	#read input B
	li $v0,5
	syscall
	move $a2 , $v0
	
	#Switch case
	beq $t0, '+',addLabel #if + clicked do add
	beq $t0, '-', subLabel  #if - clicked do sub
	beq $t0, '*', mulLabel  #if * clicked do mul
	beq $t0, '/', divLabel  #if * clicked do m
	beq $t0, '!', exitLoop # if equal ! exit loop

	#default
	li $v0, 4
	la $a0, badInput
	syscall
	
	j loop

	exitLoop:
	#recover registers from stack
	lw $a0,0($sp)
	lw $a1,4($sp)
	lw $a2,8($sp)
	addi $sp, $sp, 12
	jr $ra

	addLabel:
		#save registers before nested procedure
		addi $sp, $sp, -8
		sw $s3, 0($sp)
		sw $ra , 4($sp)
		
		#perform add
		jal addd
		
		#recover registers from stack
		lw $s3, 0($sp)
		lw $ra , 4($sp)
		addi $sp, $sp, 8
		
		li $v0, 4
		la $a0, printResult
		syscall

		li $v0, 1
		add $a0,$zero, $v1
		syscall
		
		j loop
		
		#add function
		addd:
			add $s3, $a1,$a2
			add $v1 , $zero, $s3

			jr $ra
			
	subLabel:
		#save registers before nested procedure
		addi $sp, $sp, -8
		sw $s3, 0($sp)
		sw $ra , 4($sp)
		
		#perform sub
		jal subb
		
		#recover registers from stack
		lw $s3, 0($sp)
		lw $ra , 4($sp)
		addi $sp, $sp, 8
		
		li $v0, 4
		la $a0, printResult
		syscall

		li $v0, 1
		add $a0,$zero, $v1
		syscall
		
		j loop
		
		#sub function
		subb:
			sub $s3, $a1,$a2
			add $v1, $zero, $s3

			jr  $ra
			
	mulLabel:
		#save registers before nested procedure
		addi $sp, $sp, -8
		sw $s3, 0($sp)
		sw $ra , 4($sp)
		
		#perform multipication
		jal mull
		
		#recover registers from stack
		lw $s3, 0($sp)
		lw $ra , 4($sp)
		addi $sp, $sp, 8
		
		li $v0, 4
		la $a0, printResult
		syscall

		li $v0, 1
		add $a0,$zero, $v1
		syscall
		
		j loop
		
		#mul function
		mull:
			mul $s3, $a1,$a2
			add $v1, $zero, $s3
	
			jr  $ra

	divLabel:
		#save registers before nested procedure
		addi $sp, $sp, -28
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $t3, 12($sp)
		sw $t4, 16($sp)
		sw $t5, 20($sp)		
		sw $ra , 24($sp)
		
		#perform divide
		jal divide
		
		#recover registers from stack
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $t4, 16($sp)
		lw $t5, 20($sp)		
		lw $ra , 24($sp)
		addi $sp, $sp,28
		
		li $v0, 4
		la $a0, printResult
		syscall

		li $v0, 1
		add $a0,$zero, $v1
		syscall
		
		j loop	
	
	
		divide:
    			move $t0, $a1   #getting arguments for function     
    			move $t1, $a2     

   			 addi $t2,$t2,0        
   			 addi $t3,$t3,0        
   			 addi $t4,$t4,0        
   			 addi $t5,$t5,32        
   			 divLoop: sll $t2,$t2,1 
				bgez $t0,oparation1
				addi $t2,$t2,1

				oparation1: 
				    sll $t0,$t0,1 #shift left devident
				    subu $t3,$t2,$t1
				    bgez $t3,oparation2
	
				oparation3: 
	 			   addi $t4,$t4,1 #running iterations until 32
	  			  beq $t4,$t5,finishDiv
	   			 j divLoop

				oparation2: move $t2,$t3
				    ori $t0,1
				    j oparation3

				finishDiv:
    				   move $v1,$t0               
	 			   jr $ra 
    	





