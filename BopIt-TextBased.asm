# Text-Based V2.4 - Bop It
# Tanmay Gupta
# Notes:
	# Game works perfectly. No issues. Sample run provided at the end in comments.

.data
	title:			.asciiz "Welcome new challenger!\n\nHere's your starting number (you have 5 seconds): "
	newNumTitle:	.asciiz "Next sequence: "
	prompt:		.asciiz "\nEnter your sequence (1-4): "
	newLine:		.asciiz "\n"
	clrScreen:		.asciiz "\n\n\n\n\n\n\n\n\n\n"
	winMsg:		.asciiz "\nYou win!\n"
	loseMsg:		.asciiz "\nYou lose...\n"
	invalidMsg:	.asciiz "Invalid input, try again!"
	timeInt:		.word 4000000


.text

# Procedure - main:
# Loads in title, initial random number, and calls the game_loop.
main:
	li $v0, 4
	la $a0, title
	syscall
	
	jal random_number # generates 1-digit random number
	jal game_loop
	
# Procedure - game_loop:
# Runs the program with proper logic, and calls the appropriate procedures.
game_loop:
	jal pause				# stays paused on previous number.
	jal clear_screen
	
	jal new_line
	jal user_prompt		# asks user to enter a number
	jal comparison_logic	# checks if user input (s1) matches the random number (s0).
	
	jal random_number2	# new random (s3).
	li $v0, 4
	la $a0, newNumTitle
	syscall
	jal num_shifter			# multiplies s0 by 10, then stores in s2. Adds new random s3 to s2 and stores back in s0.

	jal winner_checker
	jal new_line
	j game_loop


# Procedure - random_number:
# Generates the initial random number using syscall 42.
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
# Procedure - random_number2:
# Generates the additional random numbers.
# Stores the number in saved register s3 for later use.
random_number2:
	li $a1, 4			# Sets $a1 to the max bound.
	li $v0, 42			# Generates the random number.
	syscall
	add $a0, $a0, 1		# Adds the lowest bound.
	move $s3, $a0		# Moves random number to s3, to use later.
	#li $v0, 1			# 1 to print integer.
	#syscall
	jr $ra


# Procedure - num_shifter:
# Shifts the randomly generated number for updating the sequences.
# First, multiplies the value in $s0 by a constant (e.g., 10). Stores result in s2.
# Then, adds new random number (s3) to s2, and stores the new sequence in s0 again.
num_shifter:
	li $t0, 10			# Load the constant value (e.g., 10) into a temporary register $t0.
	mul $s2, $s0, $t0	# Multiply the value in $s0 by the constant and store the result in $s2.
    
	# Display the result
	#li $v0, 1
	move $a0, $s2		# Load the result into argument register $a0.
	#syscall
	
	move $s0, $s2
	
	add $s0, $s0, $s3	# Add the value in $s3 to the value in $s0
	li $v0, 1
	move $a0, $s0          # Load the new result into argument register $a0.
	syscall
	jr $ra


# Procedure - comparison_logic:
# Compares user inputs to the generated sequences.
# TO ADD: checks length of sequence, if reached 6, then winner.
comparison_logic:
	bne $s0, $s1, loser
	jr $ra
# Procedure - winner_checker:
# Checks if s0 has reached 5 digits yet in the sequence.
# If reached, then the player has won. Shown by branching to "winner" procedure.
winner_checker:
	li $t0, 100000			# Loading in value 1000.
	bge $s0, $t0, winner		# Branch to "winner" if $s0 is greater than or equal to 10000
	jr $ra				# Return if $s0 is less than 10000


# Procedure - user_prompt:
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
	li $t1, 1					# Lower bound
	#li $t2, 4					# Upper bound
	blt $t0, $t1, invalid_input		# If input is less than 1, prompt again
	#bgt $t0, $t2, invalid_input		# If input is greater than 4, prompt again

	# Print the input:
	#li $v0, 1
	move $a0, $t0
	move $s1, $a0				# Moves random number to s1, to use later.
	#syscall

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
# Procedure - pause & delay_loop:
# Pauses the screen for 5 seconds to let the user see the sequence.
pause:
	# Load the number of iterations for the delay loop:
	lw $t0, timeInt
delay_loop:
	# Decrement loop counter:
	subi $t0, $t0, 1
	# Check if loop counter reached zero:
	bnez $t0, delay_loop		# If not zero, continue looping...
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
	jal clear_screen
	li $v0, 4
	la $a0, winMsg
	syscall
	jal exit_program
# Procedure - exit_program:
# Loads the syscall 10 to invoke exiting the program.
exit_program:
	li $v0, 10
	syscall


# SAMPLE OUTPUT (with cleared screens and additional empty lines removed):
# ____________________________________________________________________________
# Welcome new challenger!
#
# Here's your starting number (you have 5 seconds): 1
# Enter your sequence (1-4): 1
#
# Next sequence: 12
# Enter your sequence (1-4): 12
#
# Next sequence: 124
# Enter your sequence (1-4): 124
#
# Next sequence: 1243
# Enter your sequence (1-4): 1243
#
# Next sequence: 12434
# Enter your sequence (1-4): 12434
#
# Next sequence: 124341
#
# You win!
#
# -- program is finished running --
