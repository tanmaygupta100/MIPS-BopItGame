# Text-Based V2 - Simon Says
# Tanmay Gupta

.data
	prompt:	.asciiz "\n Enter your sequence (1-4): "
	newLine:	.asciiz "\n"
	clrScreen:	.asciiz "\n\n\n\n\n\n\n\n\n\n"
	winMsg:	.asciiz "You win!\n"
	loseMsg:	.asciiz "You lose...\n"


.text

main:
	game_loop:
		# Print lines to "clear" screen:
		li $v0, 4
		la $a0, clrScreen
		syscall

		jal random_number
		jal user_prompt
		j game_loop

	# Tell me when program is done:
	li $v0, 10
	syscall


random_number:
	li $a1, 4  #Here you set $a1 to the max bound.
	li $v0, 42  #generates the random number.
	syscall
	add $a0, $a0, 1  #Here you add the lowest bound
	li $v0, 1   #1 print integer
	syscall
	move $t0, $v0
	
	num_shifter:
		addi $t1, $zero, 10
		mult $t0, $t1
		# has the result of the multi
		mflo $s0
		# DISPLAY TO SCREEN:
		li $v0, 1
		syscall
		jr $ra
		
	jr $ra

user_prompt:
	# Print prompt:
	li $v0, 4
	la $a0, prompt
	syscall

	# Get user input and store value:
	li $v0, 5
	syscall
	move $t0, $v0

	# Print the input:
	li $v0, 1
	move $a0, $t0
	syscall

	# Print new line:
	li $v0, 4
	la $a0, newLine
	syscall

	jr $ra
