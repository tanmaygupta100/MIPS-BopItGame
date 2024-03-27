# Text-Based V1.1 - Simon Says
# Tanmay Gupta

.data
sequence:			.space 20	# Array to store the generated sequence.
user_sequence:		.space 20	# Array to store the player's input sequence.
max_attempts:		.word 5	# Maximu number of attempts.
attempts:			.word 0	# Counter for attempts.
win_msg:			.asciiz "You win!\n"
lose_msg:			.asciiz "You lose!\n"
user_prompt:		.asciiz "Enter the sequence (1-4): "

.text
main:
	# Initialization:
	jal clear_sequence
	jal InitRand			# Initialize random number generator.

	# Game loop:
    	j game_loop             # Call game loop to start the game.
	
	# Check user input:
	j user_check			# Call game loop to start the game.

		
game_loop:
	# Generate random sequence:
	jal generate_sequence

	# Display sequence:
	jal display_sequence

	# Get user input:
	jal user_check

	# Check if user input matches sequence:
	bne $t3, $zero, fail # Branch to fail if user input doens't match.

	# Increment attempt counter:
	addi $t0, $t0, 1

	# Check if attempt counter reached max.
	bge $t0, $t1, display_win # Branch to display WIN message if max attempts are reached.

	j game_loop # Repeat game loop.


fail:
	# Display the losing message:
	la $a0, lose_msg
	li $v0, 4
	syscall
	j exit_game
display_win:
	# Display the winning message:
	la $a0, win_msg
	li $v0, 4
	syscall
	j exit_game
exit_game:
	# Exit the program:
	li $v0, 10
	syscall


clear_sequence:
	# Clera the sequence array:
	li $t0, 0
	la $t1, sequence
	li $t2, 5
	
	clear_loop:
		sw $zero, 0($t1)			# Store 0 (aka no colour) in sequence array.
		addi $t0, $t0, 1			# Increment counter.
		addi $t1, $t1, 4			# Move to next element in array.
		blt $t0, $t2, clear_loop	# Repeat until all elements are cleared.
		
	jr $ra


generate_sequence:
	# Generate random sequence of colours.
	# Fill sequence array with random numbers (1 to 4):
	li $t0, 0
	la $t1, sequence
	li $t2, 5
	
	generate_loop:
		jal RandomNum		# Generate random number.
						# Store random number in sequence array.
		addi $t0, $t0, 1			# Increment counter.
		addi $t1, $t1, 4			# Move to next element in array.
		blt $t0, $t2, generate_loop	# Repeat until sequence is generated.
		
	jr $ra


display_sequence:
	# Display sequence"
	li $t0, 0
	la $t1, sequence
	li $t2, 5
	
	display_loop:
		lw $a0, 0($t1)	# Load colour from sequence.
		li $v0, 1
		syscall		# Display colour.
		
		jal pause		# Call pause function for 5-sec delay
		
		# Clear the screen
		li $v0, 30		# Clear screen
		li $a0, 0		# No timeout
		syscall
		
		addi $t0, $t0, 1	# Increment counter
		addi $t1, $t1, 4	# Move to netx element in array.
		blt $t0, $t2, display_loop	# Repeat until entire sequence is displayed.

	jr $ra


user_check:
	# Prompt user to input sequence:
	li $t0, 4
	li $v0, 4
	la $a0, user_prompt
	syscall
	
	# Read user input:
	li $v0, 8
	la $a0, user_sequence
	li $a1, 20		# Read up to 20 characters (For testing, althought 5 is better).
	syscall
	
	# Check if user input matches sequence:
	li $t0, 0
	la $t1, sequence
	la $t2, user_sequence
	
	user_check_loop:
		lw $t4, 0($t1)	# Load colour from sequence.
		lw $t5, 0($t2)	# Load user input.
		
		# Check if user input matches sequence:
		bne $t4, $t5, incorrect_input	# Branch if input doesn't match sequence.
		
		addi $t0, $t0, 1		# Increment counter.
		addi $t1, $t1, 4		# Move to next element in sequence.
		addi $t2, $t2, 4		# Move to next element in user input.
		
		# Check if all elements in sequence are checked:
		blt $t0, $t2, user_check_loop	# Repeat until entire sequence is checked.
		
		j exit_user_check	# Jump to exit subroutine if successful.

	incorrect_input:
		li $t3, 1	# Set failure flag.
	exit_user_check:
        	jr $ra	# Exit subroutine.


pause:
	move $t0, $a0	# Save timeout to $t0.
	li $v0, 30		# Get initial time.
	syscall
	move $t1, $a0	# Save initial time to $t1.
pause_loop:
	syscall				# Get current time
	subu $t2, $a0, $t1		# Calculate elapsed time.
	bltu $t2, $t0, pause_loop	# Loop if elapsed time is less than timeout.
	jr $ra				# Return from function


# Initialize the random number generator with a seed:
InitRand:
	li $v0, 30		# Get system time.
	syscall
	move $a1, $a0	# Move system time to seed.
	li $a0, 0		# Generator ID.
	li $v0, 40		# Set initial seed.
	syscall
	jr $ra

# Generate a random number:
RandomNum:
	li $v0, 42		# Generate random number.
	li $a0, 0		# Generator ID.
	li $a1, 4		# Upper bound (4 for colours 1 - 4).
	syscall
	addi $v0, $v0, 1	# Adjust random number (1 to 4).
	jr $ra
