
    .data
A: .word 129
B: .word 8370
C: .word -15
space:    .asciiz " "
result:    .asciiz "The product of the two numbers is: "
overflowText:  .asciiz "Warning - there is an overflow"
endLine: .asciiz "\n"

    .text
main:
    # First, we will do A*B
    la $t0, A
    lw $t0, 0($t0) # Read the value of “A” from memory
    la $t1, B
    lw $t1, 0($t1) # Read the value of “B” from memory.
    move $a0, $t0# Copy the arguments "A" and "B" into the
    move $a1, $t1 # argument registers
    
    addi $sp, $sp, -8 #save registers we use in prcedure to stuck
    sw $t0,0($sp)
    sw $t1,4($sp)

    jal Product # Call procedure "Product" A*B (make it!)
    
    lw $t0,0($sp) #restore registers from stack
    lw $t1,4($sp)
    addi $sp, $sp, 8
    
    move $t2, $v1 # Store return valuein temporary register.
     
    # Add here code to print result $t2 to screen
    #print finish line text         
    li $v0, 4 
    la $a0, result
    syscall
    
    #print result
    li $v0, 1
    move $a0,$t2
    syscall
    
    #print enter
    li $v0, 4 
    la $a0, endLine
    syscall
    
    # Now let’s do A*C
    la $t0, A
    lw $t0, 0($t0) # Read the value of “A” from memory
    la $t1, C
    lw $t1, 0($t1) # Read the value of “B” from memory.
    move $a0 , $t0
    move $a1, $t1
    
    addi $sp, $sp, -12 #save registers we use in prcedure to stuck
    sw $t0,0($sp)
    sw $t1,4($sp)
    sw $t2,8($sp)

    jal Product # Call procedure "Product" A*B (make it!)
    
    lw $t0,0($sp) #restore registers from stack
    lw $t1,4($sp)
    sw $t2,8($sp)
    addi $sp, $sp, 12
  
    move $t2, $v1 # Store return value in temporary register.
    
    # Add here code to print result $t2 to screen
    #print finish line text         
    li $v0, 4 
    la $a0, result
    syscall
    
    #print result
    li $v0, 1
    move $a0,$t2
    syscall
    
    li $v0, 10
    syscall # Ready to quit 
    
Product:
    
    addi $sp, $sp, -12 #save registers we use in prcedure to st
    sw $s0, 0($sp)
    sw $s1, 4($sp)
    sw $s2, 8($sp)

    move $s0, $a0        
    move $s1, $a1        
    move $s2, $0        
    
    #if 1 of the inputs is 0 return 0   
    beq $s1, $0, finish
    beq $s0, $0, finish
      
whileLoop:
    andi $t0, $s0, 1 #check if least significant bit is 0
    beq $t0, $0, skip 
    addu $s2, $s2, $s1  #add current bit multiply to result

skip:
    srl $s0, $s0, 1 # perform shift right for lower number in product
    sll $s1, $s1, 1 # perform shift left for upper number in product
    bne $s0, $0, whileLoop

finish:

    move $v1 , $s2

    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    
    addi $sp, $sp, 12 #restore registers ans stack
    
    jr $ra
    

