!============================================================
! CS-2200 Homework 1
!
! Please do not change main's functionality, 
! except to change the argument for factorial or to meet your 
! calling convention
!============================================================
!
!fact(n) {
!    if (n < 2) {
!        return 1;
!    } else {
!        return n*fact(n-1);
!    }
!}


main:       la $sp, stack		        ! load ADDRESS of stack label into $sp

            lw $sp, 0x0($sp)            ! FIXME: load the actual value of the 
                                        ! stack (defined in the label below) 
                                        ! into $sp

		    la $at, factorial	        ! load address of factorial label into $at
		    addi $a0, $zero, 5   	    ! $a0 = 5, the number to factorialize
		    add $pr, $zero, $sp         ! Set Frame pointer = stack pointer
		    jalr $at, $ra		        ! jump to factorial, set $ra to return addr
		    halt				        ! when we return, just halt

factorial:  sw $ra, 0x00($pr)           ! Store RA onto the stack
            beq $zero, $a0, return0     ! Check if n == 0
            addi $t2, $zero, 1          ! t2 = 1
            beq $t2, $a0, return1       ! Check if n == 1

            addi $pr, $pr, 1            ! Increment Frame pointer to create space for n
            sw $a0, 0x00($pr)           ! Store n onto the stack
            addi $pr, $pr, 1            ! Increment Frame pointer for next variable
            
            addi $a0, $a0, -1           ! Decrement n
                                    
            jalr $at, $ra               ! Call this function recursively
            
            
return0:    addi $a0, $a0, 1            ! Set n to 1            
return1:    beq $sp, $pr, finish        ! If stack pointer == frame pointer, stack is empty - function is done.
            addi $pr, $pr, -1           ! Pop off an object from the stack
            addi $pr, $pr, -1           ! Pop off an object from the stack
            lw $a1, 0x01($pr)           ! Get n from the stack
            la $t1, multiply            ! Load address of multiply subroutine into $t1
            jalr $t1, $ra               ! Multiply n*fact(n-1)
            add $a0, $v0, $zero         ! n = return value
            la $t1, return1             ! Load the address to return back to
            jalr $t1, $ra               ! Return the function back to the caller


finish:     add $v0, $a0, $zero         ! Return value = final value
            lw $ra, 0x00($sp)           ! Get first Return Address from stack
            jalr $ra, $t1               ! Return to the caller function

! Multiplication (n*fact(n-1)) is handled by adding fact(n-1) to itself n times
multiply:   add $v0, $a0, $zero         ! Return value = fact(n-1)
            add $t0, $a1, $zero         ! Save n
            addi $t0, $t0, -1           ! Decrement n
multiply2:  beq $zero, $t0, ret         ! if n == 0, return
            add $v0, $v0, $a0           ! Add fact(n-1) to itself
            addi $t0, $t0, -1           ! Decrement n
            beq $zero, $zero, multiply2 ! Keep on adding until n=0

ret:        jalr $ra, $t1               ! Return the caller function         

stack:	    .word 0x4000		        ! the stack begins here (for example, that is)




