# BopIt-BitmapDisplay - Simon Says (display-based)
	# Inputs: Each number is entered in the sequence, separated by new lines.
	# Consider: Click "Close", not "Disconnect from MIPS", when in the Bitmap Display screen in MARS.

.data
	# Table: ColorTable
	# STEP 2 - Convert Color Num to Data Value
	colorTable:
	.word 0x000000		# black		[0]
	.word 0x0000ff		# blue		[1]
	.word 0x00ff00		# green		[2]
	.word 0xff0000		# red		[3]
	.word 0x00ffff		# blue + green	[4]
	.word 0xff00ff		# blue + red	[5]
	.word 0xffff00		# green + red	[6]	yellow
	.word 0xffffff		# white		[7]
	
	winMsg:		.asciiz "\nYou win!\n"
	loseMsg:	.asciiz "\nYou lose...\n"
	introMsg:	.asciiz "\nWelcome new challenger!!\n Enter YOUR difficulty!\n Easy = 1, Normal = 2, Hard = 3\n Quit game = 0.\n"
	colorInput:	.asciiz "Yellow = 1\nBlue = 2\nGreen = 3\nRed = 4\n"
	invalidMsg:	.asciiz "Invalid input, try again!"
	stack_beg: 	.word 0 : 40
	stack_end:
	sequenceArray: .space 100
	sequenceMax:	.word 0
	generatorID:	.word 0
	generatorSeed: .word 0
	random_number: .word 0	
	
.text
main:
	la	$sp, stack_end

	# Drawing: YELLOW square
	la	$a0, 1	# x coordinate
	la	$a1, 1	# x coordinate
	la	$a2, 6	# color hex code
	la	$a3, 14	# square size
	jal	drawBox
	
	# Drawing: GREEN square
	la	$a0, 1
	la	$a1, 17
	la	$a2, 2
	la	$a3, 14
	jal	drawBox
	
	# Drawing: BLUE square
	la	$a0, 17
	la	$a1, 1
	la	$a2, 1
	la	$a3, 14
	jal	drawBox
	
	# Drawing: RED square
	la	$a0, 17
	la	$a1, 17
	la	$a2, 3
	la	$a3, 14
	jal	drawBox

	# Loading addresses into $a0 and $a1:
	la	$a0, sequenceArray	# -> $a0
	la	$a1, sequenceMax	# -> $a1

	# Setting up the game:
	jal	initializingVals
	la	$a0, introMsg
	li	$v0, 4
	syscall

	# Reading user inputs for setting states:
	li	$v0, 5
	syscall
	beq	$v0, 0, exit
	beq	$v0, 1, easyMode
	beq	$v0, 2, normalMode
	beq	$v0, 3, hardMode
	j	invalidNum


	# Easy mode (5):
	easyMode:
		li	$t0, 5
		sw	$t0, sequenceMax	# 5 -> sequenceMax
		j	continue
	# Normal mode (8):
	normalMode:
		li	$t0, 8	# 8 -> sequenceMax
		sw	$t0, sequenceMax
		j	continue
	# Hard mode (11):
	hardMode:
		li	$t0, 11	# 11 -> sequenceMax
		sw	$t0, sequenceMax
		j	continue

	continue:
		# Getting the colors for printing and clearing to screen:
		la	$a0, colorInput	# colorInput (address) -> $a0
		li	$v0, 4
		syscall
		jal	clearDisp
	
		# Pausing for 600 milliseconds:
		li	$a0, 600
		li	$v0, 32
		syscall

	# Changing loop for difficulty modes:
	li	$t6, 0	# counter for sequence numbers
	lw	$t5, sequenceMax
	newDifficultyLoop:
		la	$a0, generatorID		# generatorID (address) -> $a0
		la	$a1, generatorSeed		# generatorSeed (address) -> $a1
		jal	randomNumGenerator
		sw	$v0, random_number	# random_number -> $v0
		la	$a0, sequenceArray		# sequenceArray (address) -> $a0
		la	$a1, random_number	# random_number (address) -> $a1
	
		# Incrementing - Correcting the positions of the sequence:
		move $t7, $t6
		sll	$t7, $t7, 2
		add	$a0, $a0, $t7
		addi	$t6, $t6, 1
		jal	addRandomNum_Sequence	
		bne	$t6, $t5, newDifficultyLoop
	
		la	$a0, sequenceArray	# sequenceArray (address) -> $a0
		la	$a1, sequenceMax	# sequenceMax (address) -> $a1
	
		jal	displaySequence
		la	$a0, sequenceArray
		la	$a1, sequenceMax
		jal	gameplay
		beq	$v0, 0, loser
		beq	$v0, 1, winner


	# Procedures for outputs:
	# Winner!
	winner:
		la	$a0, winMsg
		li	$v0, 4
		syscall
		jal	newLine
		j	main	
	# Loser...
	loser:
		la	$a0, loseMsg
		li	$v0, 4
		syscall
		jal	newLine
		j	main	
	# Invalid input??
	invalidNum:
		la	$a0, invalidMsg
		li	$v0, 4
		syscall
		jal	newLine
		j	main	
	# Exiting the program:
	exit:
		li	$v0, 17
		syscall
	# NewLine:
	newLine:
		li	$v0, 11
		addi	$a0, $0, 0xA
		syscall
		jr $ra




#################################################



# Procedure: initializingVals
# Clears sequence and max values for each game.
initializingVals:
	# Clears the sequence
	li	$t0, 24
	li	$t1, 0
	initializingLoop:
		sw	$0, 0($a0)
		addi	$t1, $t1, 1
		addi	$a0, $a0, 4
		bne 	$t1, 25, initializingLoop
		# Clears the max
		sw	$0, 0($a1)
		jr	$ra


# Procedure: randomNumGenerator
# Generates the initial random number.
randomNumGenerator:
	sw		$0, 0($a0)
	move	$t0, $a0
	move	$t1, $a1

	li		$v0, 30
	syscall
	sw		$a0, 0($t1)
	lw		$a0, ($t0)
	lw		$a1, ($t1)
	li		$v0, 40
	syscall
	sw		$a1, 0($t1)
	
	li		$a0, 5
	li		$v0, 32
	syscall
	
	li		$a1, 4
	li		$v0, 42
	syscall
	addi		$a0, $a0, 1
	move	$v0, $a0
	
	move	$a0, $t0
	move	$a1, $t1
	jr		$ra

# Procedure: addRandomNum_Sequence
# Adds each random number to the sequence.
addRandomNum_Sequence:
	lw	$t0, 0($a1)
	sw	$t0, 0($a0)
	jr	$ra

# Procedure: displaySequence
# Displaying the sequence to screen.
displaySequence:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)	

	# Blinking:
	li	$s1 0
	lw	$t1, 0($a1)
	move $t2, $a0
	move $t4, $a1
	jal	clearDisp
	blinkLoop:
		#BLINK ELEMENT
		lw	$t3, 0($t2)	
		beq	$t3, 1, yellowBlink
		beq	$t3, 2, blueBlink
		beq	$t3, 3, greenBlink
		beq	$t3, 4, redBlink			
		returnLoop:
			addi	$t2, $t2, 4
			addi	$s1, $s1, 1
			# Pausing:
			li	$a0, 600
			li	$v0, 32
			syscall
			bne	$s1, $t1, blinkLoop
			lw	$ra, 0($sp)	
			addi	$sp, $sp, 4	
			jr	$ra
	
	yellowBlink:
		la	$a0, 1	# x coordinate
		la	$a1, 1	# y coordinate
		la	$a2, 6	# color hex code
		la	$a3, 14	# square size
		jal	drawBox
		li	$a0, 600
		li	$v0, 32
		syscall
		# Blinking:
		la	$a0, 1
		la	$a1, 1
		la	$a2, 0
		la	$a3, 14
		jal	drawBox
		j	returnLoop
	
	greenBlink:
		la	$a0, 1
		la	$a1, 17
		la	$a2, 2
		la	$a3, 14
		jal	drawBox
		li	$a0, 600
		li	$v0, 32
		syscall
		# Blinking:
		la	$a0, 1
		la	$a1, 17
		la	$a2, 0
		la	$a3, 14
		jal	drawBox
		j	returnLoop
	
	blueBlink:
		la	$a0, 17
		la	$a1, 1
		la	$a2, 1
		la	$a3, 14
		jal	drawBox
		li	$a0, 600
		li	$v0, 32
		syscall
		# Blinking:
		la	$a0, 17
		la	$a1, 1
		la	$a2, 0
		la	$a3, 14
		jal	drawBox
		j	returnLoop
	
	redBlink:
		la	$a0, 17
		la	$a1, 17
		la	$a2, 3
		la	$a3, 14
		jal	drawBox
		li	$a0, 600
		li	$v0, 32
		syscall
		# Blinking:
		la	$a0, 17
		la	$a1, 17
		la	$a2, 0
		la	$a3, 14
		jal	drawBox
		j	returnLoop


# Procedure: gameplay
# Shows the generated sequence to screen.
# Takes input, and compares for loss/win.
gameplay:
	# Blinking sequence:
	li	$t0, 0
	lw	$t1, 0($a1)
	move $t2, $a0

	gameplayLoop:	
		# User input:
		li	$v0, 5
		syscall
	
		lw	$a0, 0($t2)
		bne	$v0, $a0, loss
		addi	$t2, $t2, 4
		addi	$t0, $t0, 1
		bne	$t0, $t1, gameplayLoop
	
		# When player wins:
		li	$v0, 1
		jr	$ra
	# When player loses:
	loss:
		li	$v0, 0
		jr	$ra



#####################################################
#####################################################
#####################################################



# Procedure: calcAddr
# STEP 1 - Convert X,Y coordinate to address
# $a0 = x coordinate (0-31)
# $a1 = y coordinate (0-31)
# returns $v0 = memory address
calcAddr:
	sll	$a0, $a0, 2			# $a0 * 4
	sll	$a1, $a1, 5			# $a1 * 32
	sll	$a1, $a1, 2			# $a1* 4
	add	$a0, $a0, $a1			# $a1 + $a0
	addi	$v0, $a0, 0x10040000	# ((base address for display) + $a0), then store in $v0
	jr	$ra


# Procedure: getColor
# STEP 3 - Function to lookup color number
# $a2 = color number (0-7)
# returns $v1 = actual number to write to the display
getColor:
	la	$t0, colorTable	# load base
	sll	$a2, $a2, 2	# index x4 is offset
	add	$a2, $a2, $t0	# address is base + offset
	lw	$v1, 0($a2)	# get actual color from memory
	jr	$ra


# Procedure: drawDot
# STEP 4a - Draw a dot
# $a0 = x coordinate (0-31)
# $a1 = y coordinate (0-31)
# $a2 = color number (0-7)
drawDot:
	addi	$sp, $sp, -8	# make room on stack, 2 words
	sw	$ra, 4($sp)		# store $ra (in element 1 of stack, 4 bytes in)
	sw	$a2, 0($sp)	# store $a2 (in element 0 of stack)

	jal	calcAddr	# $v0 has address for pixel (returns address)
	lw	$a2, 0($sp)		# restore $a2 (restores from stack, 0 bytes in)
	sw	$v0, 0($sp)		# save $v0 (saves from stack, 0 bytes in)

	jal	getColor		# $v1 has color (returns color)
	lw	$v0, 0($sp)	# Restore $v0 (from stack)

	sw	$v1, 0($v0)	# make dot
	lw	$ra, 4($sp)		# load original $ra (from stack)
	addi	$sp, $sp, 8		# adjust $sp (stack)
	jr	$ra


# Procedures: horzLine & horzLoop
# STEP 5a - Draw a horizontal line
# $a0 = x coordinate (0-31)
# $a1 = y coordinate (0-31)
# $a2 = color number (0-7)
# $a3 = length of the line (1-32)
horzLine:
	# create stack frame (space in stack for 4 words)
	# save $ra in element 4 of the stack
	# store $a0-$a2 in elements 0-2 of the stack
	addi	$sp, $sp, -16
	sw	$ra, 12($sp)
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)	# 4 bytes in
	sw	$a2, 8($sp)	# 8 bytes in
	
	horzLoop:
		jal	drawDot # drawing a line using repeating dots

		# restore registers $a0-$a2 from the stack
		lw	$a0, 0($sp)
		lw	$a1, 4($sp)	# 4 bytes in
		lw	$a2, 8($sp)	# 8 bytes in

		addi	$a0, $a0, 1		# increment x coordinate ($a0) by 1
		sw	$a0, 0($sp)		# store $a0 in stack
		addi	$a3, $a3, -1		# decrement length ($a3)
		bne	$a3, $0, horzLoop	# if length =/= 0, then horzLoop

		lw	$ra, 12($sp)	# restore $ra (3 bytes in)
		addi	$sp, $sp, 16	# readjust stack space
		jr	$ra

# Procedures: vertLine & vertLoop
# STEP 5b - Draw a vertical line
# $a0 = x coordinate (0-31)
# $a1 = y coordinate (0-31)
# $a2 = color number (0-7)
# $a3 = length of the line (1-32)
# Same as horzLine, except for y (using $a1 instead of $a0)
vertLine:
	addi	$sp, $sp, -16
	sw	$ra, 12($sp)
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	sw	$a2, 8($sp)

	vertLoop:
		jal	drawDot

		lw	$a0, 0($sp)
		lw	$a1, 4($sp)
		lw	$a2, 8($sp)

		addi	$a1, $a1, 1	# increment y coordinate ($a1) by 1
		sw	$a1, 4($sp)	# store $a1in stack
		addi	$a3, $a3, -1
		bne	$a3, $0, vertLoop

		lw	$ra, 12($sp)
		addi	$sp, $sp, 16
		jr	$ra


# Procedures: drawBox & boxLoop
# STEP 6a - Draw a filled box
# $a0 = x coordinate (0-31)
# $a1 = y coordinate (0-31)
# $a2 = color number (0-7)
# $a3 = size of the line (1-32)
drawBox:
	# create stack frame / save registers $ra & $s0
	# copy $a3 -> register $s0
	addi	$sp, $sp, -24	# make space for 6 words
	sw	$ra, 12($sp)	# $ra -> element 4
	sw	$a0, 0($sp)	# $a0 -> element 0
	sw	$a1, 4($sp)	# $a1 -> element 1
	sw	$a2, 8($sp)	# $a2 -> element 2
	sw	$a3, 20($sp)	# $a3 -> element 6
	move $s0, $a3		# $a3 -> $s0
	sw	$s0, 16($sp)	# $s0 -> element 5

	boxLoop:
		jal	horzLine	# draw horizontal lines

		# restore registers $a0-$a3 & $s0
		lw	$a0, 0($sp)	# $a0 <- element 0
		lw	$a1, 4($sp)	# $a1 <- element 1
		lw	$a2, 8($sp)	# $a2 <- element 2
		lw	$a3, 20($sp)	# $a3 <- element 6
		lw	$s0, 16($sp)	# $s0 <- element 5

		addi	$a1, $a1, 1		# increment y coordinate by 1 space
		sw	$a1, 4($sp)		# $a1 -> element 1
		addi	$s0, $s0, -1		# decrement the counter
		sw	$s0, 16($sp)		# $s0 -> element 5
		bne	$s0, $0, boxLoop	# if length =/= 0, then boxLoop

		lw	$ra, 12($sp)	# restore $ra: $ra <- element 4
		addi	$sp, $sp, 24	# readjust/fix stack
		addi	$s0, $s0, 0		# reset $s0
		jr	$ra


# Procedure: clearDisp
# STEP 6b: Clear the display
# Draws a large black box over the entire display
clearDisp:
	addi	$sp, $sp, -4	# create space for 1 word in 
	sw	$ra, 0($sp)		# $ra -> stack
	
	# clear registers
	la	$a0, 0	# x-coordinate = 0
	la	$a1, 0	# y-coordinate = 0
	la	$a2, 0	# color = black
	la	$a3, 32	# size = 32
	jal	drawBox	# clear screen

	lw	$ra, 0($sp)		# $ra <- stack
	addi	$sp, $sp, 4		# readjust/fix stack
	jr	$ra




##################################################################
#
#SAMPLE TEST CASES:
#
#
#Welcome new challenger!!
# Enter YOUR difficulty!
# Easy = 1, Normal = 2, Hard = 3
# Quit game = 0.
#2
#Yellow = 1
#Blue = 2
#Green = 3
#Red = 4
#4
#
#You lose...
#
#
#Welcome new challenger!!
# Enter YOUR difficulty!
# Easy = 1, Normal = 2, Hard = 3
# Quit game = 0.
#1
#Yellow = 1
#Blue = 2
#Green = 3
#Red = 4
#4
#
#You lose...
#
#
#Welcome new challenger!!
# Enter YOUR difficulty!
# Easy = 1, Normal = 2, Hard = 3
# Quit game = 0.
#1
#Yellow = 1
#Blue = 2
#Green = 3
#Red = 4
#1
#4
#1
#4
#4
#
#You win!
#
#
#Welcome new challenger!!
# Enter YOUR difficulty!
# Easy = 1, Normal = 2, Hard = 3
# Quit game = 0.
#0
