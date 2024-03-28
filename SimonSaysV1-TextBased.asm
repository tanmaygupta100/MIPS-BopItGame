# Text-Based V2 - Simon Says
# Tanmay Gupta

.data
	prompt:		.asciiz "\n Enter your sequence (1-4): "
	newLine:		.asciiz "\n"
	clrScreen:		.asciiz "\n\n\n\n\n\n\n\n\n\n"
	winMsg:		.asciiz "You win!\n"
	loseMsg:		.asciiz "You lose...\n"
	invalidMsg:	.asciiz "Invalid input!"


.text

main:
	jal game_loop

	# Tell me when program is done:
	li $v0, 10
	syscall


game_loop:
	# Print lines to "clear" screen:
	li $v0, 4
	la $a0, clrScreen
	syscall

	jal random_number
	jal user_prompt
	j game_loop


random_number:
	li $a1, 4			#Here you set $a1 to the max bound.
	li $v0, 42			#generates the random number.
	syscall
	add $a0, $a0, 1		#Here you add the lowest bound
	li $v0, 1			#1 print integer
	syscall
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

	# Check if the input is within range (1-4):
	li $t1, 1		# Lower bound
	li $t2, 4		# Upper bound
	blt $t0, $t1, invalid_input		# If input is less than 1, prompt again
	bgt $t0, $t2, invalid_input		# If input is greater than 4, prompt again

	# Print the input:
	li $v0, 1
	move $a0, $t0
	syscall

	# Print new line:
	li $v0, 4
	la $a0, newLine
	syscall

	jr $ra

invalid_input:
	# Print message for invalid input:
	li $v0, 4
	la $a0, invalidMsg
	syscall
	j user_prompt		# Prompt again for input
