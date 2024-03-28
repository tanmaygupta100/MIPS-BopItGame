# Text-Based V2.2 - Bop It
# Tanmay Gupta
# TO DO: Nest procedures

.data
	prompt:		.asciiz "\n Enter your sequence (1-4): "
	newLine:		.asciiz "\n"
	clrScreen:		.asciiz "\n\n\n\n\n\n\n\n\n\n"
	winMsg:		.asciiz "You win!\n"
	loseMsg:		.asciiz "You lose...\n"
	invalidMsg:	.asciiz "Invalid input, try again!"


.text

# Procedure - main:
# Runs the program and calls the appropriate procedures.
main:
	jal clear_screen

	jal random_number
	jal user_prompt
	
	jal comparison_logic
	jal num_shifter
	
	j main


# Procedure - random_number:
# Generates a random number using syscall 42.
# Stores the number in saved register s0 for later use.
random_number:
	li $a1, 4			# Sets $a1 to the max bound.
	li $v0, 42			# Generates the random number.
	syscall
	add $a0, $a0, 1		# Adds the lowest bound.
	move $s0, $a0		# Moves random number to s0, to use later.
	li $v0, 1			# 1 to print integer.
	syscall
	jr $ra

# Procedure - num_shifter:
# Shifts the randomly generated number for updating the sequences.
num_shifter:
	jr $ra


# Procedure - comparison_logic
# Compares user inputs to the generated sequences.
# TO ADD: checks length of sequence, if reached 6, then winner.
comparison_logic:
	bne $s0, $s1, loser
	jr $ra


# Procedure - user_prompt
# Prints messages to the user.
# Prompts the user for values and accepts inputs.
# Stores inputs to s1 for later use.
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
	move $s1, $a0	# Moves random number to s1, to use later.
	syscall

	j new_line

	jr $ra


# Procedure - new_line:
# Prints 1 empty line to make outputs easier to separate and read.
new_line:
	li $v0, 4
	la $a0, newLine
	syscall
	jr $ra
# Procedure - clear_screen:
# Prints empty lines to "clear" the screen.
clear_screen:
	li $v0, 4
	la $a0, clrScreen
	syscall
	jr $ra


# Procedure - invalid_input:
# Prints a message indicating that the user inputted an invalid value.
# Calls the user_prompt to allow the user to try again, without ending the game.
invalid_input:
	li $v0, 4
	la $a0, invalidMsg
	syscall
	j user_prompt
# Procedure - loser:
# Prints the losing message if any sequence doesn't match..
# Exits the program.
loser:
	li $v0, 4
	la $a0, loseMsg
	syscall
	jal exit_program
# Procedure - winner:
# Prints the winning message if 5 sequences are correct in a row.
# Exits the program.
winner:
	li $v0, 4
	la $a0, winMsg
	syscall
	jal exit_program
# Procedure - exit_program:
# Loads the syscall 10 to invoke exiting the program.
exit_program:
	li $v0, 10
	syscall
