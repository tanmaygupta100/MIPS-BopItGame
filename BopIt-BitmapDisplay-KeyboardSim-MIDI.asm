# Bop-It v3 - Using the Bitmap Display (with finer pixel dimensions of 1x1), Keyboard Simulator, and MIDI effects.

  .data
	.word	0 : 40
Stack:

# Background/foreground colors:
Colors:
	.word	0x000000		# [Black]
	.word	0xffffff		# [White]

DigitTable:
	.byte		' ',	0, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 0
	.byte		'0',	0x7e, 0xff, 0xc3, 0xc3, 0xc3, 0xc3, 0xc3, 0xc3, 0xc3, 0xc3, 0xff, 0x7e
	.byte		'1',	0x38, 0x78, 0xf8, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18, 0x18
	.byte		'2',	0x7e, 0xff, 0x83, 0x06, 0x0c, 0x18, 0x30, 0x60, 0xc0, 0xc1, 0xff, 0x7e
	.byte		'3',	0x7e, 0xff, 0x83, 0x03, 0x03, 0x1e, 0x1e, 0x03, 0x03, 0x83, 0xff, 0x7e
	.byte		'4',	0xc3, 0xc3, 0xc3, 0xc3, 0xc3, 0xff, 0x7f, 0x03, 0x03, 0x03, 0x03, 0x03
	.byte		'5',	0xff, 0xff, 0xc0, 0xc0, 0xc0, 0xfe, 0x7f, 0x03, 0x03, 0x83, 0xff, 0x7f
	.byte		'6',	0xc0, 0xc0, 0xc0, 0xc0, 0xc0, 0xfe, 0xfe, 0xc3, 0xc3, 0xc3, 0xff, 0x7e
	.byte		'7',	0x7e, 0xff, 0x03, 0x06, 0x06, 0x0c, 0x0c, 0x18, 0x18, 0x30, 0x30, 0x60
	.byte		'8',	0x7e, 0xff, 0xc3, 0xc3, 0xc3, 0x7e, 0x7e, 0xc3, 0xc3, 0xc3, 0xff, 0x7e
	.byte		'9',	0x7e, 0xff, 0xc3, 0xc3, 0xc3, 0x7f, 0x7f, 0x03, 0x03, 0x03, 0x03, 0x03
	.byte		'+',	0x00, 0x00, 0x00, 0x18, 0x18, 0x7e, 0x7e, 0x18, 0x18, 0x00, 0x00, 0x00
	.byte		'-',	0x00, 0x00, 0x00, 0x00, 0x00, 0x7e, 0x7e, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte		'*',	0x00, 0x00, 0x00, 0x66, 0x3c, 0x18, 0x18, 0x3c, 0x66, 0x00, 0x00, 0x00
	.byte		'/',	0x00, 0x00, 0x18, 0x18, 0x00, 0x7e, 0x7e, 0x00, 0x18, 0x18, 0x00, 0x00
	.byte		'=',	0x00,0x00,0x00,0x00,0x7e,0x00,0x7e,0x00,0x00,0x00,0x00,0x00
	.byte		'A',	0x18, 0x3c, 0x66, 0xc3, 0xc3, 0xc3, 0xff, 0xff, 0xc3, 0xc3, 0xc3, 0xc3
	.byte		'B',	0xfc, 0xfe, 0xc3, 0xc3, 0xc3, 0xfe, 0xfe, 0xc3, 0xc3, 0xc3, 0xfe, 0xfc
	.byte		'C',	0x7e, 0xff, 0xc1, 0xc0, 0xc0, 0xc0, 0xc0, 0xc0, 0xc0, 0xc1, 0xff, 0x7e
	.byte		'D',	0xfc, 0xfe, 0xc3, 0xc3, 0xc3, 0xc3, 0xc3, 0xc3, 0xc3, 0xc3, 0xfe, 0xfc
	.byte		'E',	0xff, 0xff, 0xc0, 0xc0, 0xc0, 0xfe, 0xfe, 0xc0, 0xc0, 0xc0, 0xff, 0xff
	.byte		'F',	0xff, 0xff, 0xc0, 0xc0, 0xc0, 0xfe, 0xfe, 0xc0, 0xc0, 0xc0, 0xc0, 0xc0
	.byte			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0


ColorTable:
	.word	0xFF9933			# Orange [0]
	.word	0x99CCFF			# Light Blue [1]
	.word	0xFF1A1A			# Cherry Red [2]
	.word	0x84E184			# Lime Green [3]
	.word	0xFFFFFF			# White [4]
	.word	0x000000			# Black [5]

CircleTable: 
	.word	0, 10, -4, 18, -6, 22, -8, 26, -9, 28, -11, 32, -12, 34, -13, 36, -14, 38, -15, 40, -15, 40, -16, 42, -17, 44
	.word	-17, 44, -18, 46, -18, 46, -19, 48, -19, 48, -19, 48, -19, 48, -20, 50, -20, 50, -20, 50, -20, 50, -20, 50
	.word	-20, 50, -20, 50, -20, 50, -20, 50, -20, 50, -19, 48, -19, 48, -19, 48, -19, 48, -18, 46, -18, 46, -17, 44
	.word	-17, 44, -16, 42, -15, 40, -15, 40, -14, 38, -13, 36, -12, 34, -11, 32, -9, 28, -8, 26, -6, 22 -4, 18, 0, 10

# x, y, color identifier, pitch
ColorsExt:	
	.word	125, 25, 0, 40		# Orange [0]
	.word	40, 115, 1, 50		# Light Blue [1]
	.word	200, 120, 2, 60		# Cherry Red [2]
	.word	125, 180, 3, 70		# Lime Green [3]

# Stores MIDI, color numbers, and coordinate addresses:
ColorData:
	.word	0 : 4

# Holds sequence of 5 digits for the flashing:
sequence:
	.word	0 : 5

# Different print values:
newLine:
	.asciiz "\n"
prompt1:
	.asciiz "\nAnswer! -> "
winMsg:
	.asciiz "\nVictory!!"
lossMsg:
	.asciiz "\nLoss..."

# Setting the numbers:
number1:
	.asciiz "1"
number2:
	.asciiz "2"
number3:
	.asciiz "3"
number4:
	.asciiz "4"



################################################################


	.text

# Setting up the game:
# Initializing values and sequence of logic.
#Initialize data
li	$s1, 0
li	$s0, 0
jal	InitRand
jal	ClearScreen

# Procedure - Main
# Calling the crosshair borders.
# Sets up the sequence for the game.
# Blinks lights and checks user inputs.
Main:	
	la	$a1, sequence
	jal	DrawCrossHairs
	jal	GetRand
	la	$a1, sequence
	add	$a1, $a1, $s0
	sw	$a0, ($a1)
	addi	$s0, $s0, 4
	addi	$s1, $s1, 1
	la	$a1, sequence
	jal	Blink
	la	$a1, sequence
	jal	UserCheck
	beq	$s1, 5, Victory
	j	Main


#Procedure: UserCheck
# Requests inputs from the user. Gets inputs using the Keyboard Simulator.
# Does checking logic for the game itself.
# Loads in coordinate, color, and incremental values for the game logic to function.
UserCheck:
	li $s5, 0
	la $a0, prompt1
	li $v0, 4
	syscall
	addiu $sp, $sp, -12
	sw $ra, 0($sp)

	CheckLoop:
		# Comparison logic:
		sw		$a1, 4($sp)
		jal	GetChar
		lw		$a1, 4($sp)
		subu		$v0, $v0, 49
		lb		$t1, ($a1)
		bne		$v0, $t1, Failure
		move	$a0, $t1
		sw		$a1, 4($sp)
		sw		$s5, 8($sp)
		# Getting color/coodinate values, and calls the drawing and clearing for the animations.
		jal		GetColorData
		la		$t0, ColorData
		lw		$a2, 8($t0)
		lw		$a0, 0($t0)
		lw		$a1, 4($t0)
		jal		DrawCircle
		jal		ClearScreen
		# Loading for the stack:
		lw		$ra, 0($sp)
		lw		$a1, 4($sp)
		lw		$s5, 8($sp)
		addi		$a1, $a1, 4	
		addi		$s5, $s5, 1
		bne		$s5, $s1, CheckLoop
		addiu	$sp, $sp, 12
		jr		$ra


# Procedure: Failure
# Indicates loss through the MIDI.
# Loads in the color and coordinate values from the temporary registers.
# Indicates through text that the user has lost.
Failure:
	# MIDI pitch, length, instrument, and volume settings:
	li		$a0, 120
	li		$a1, 500
	li		$a2, 50
	li		$a3, 100
	li		$v0, 33
	syscall
	la		$a0, lossMsg
	li		$v0, 4
	syscall
	li		$v0, 10
	syscall

# Procedure: Failure
# Displays winning message and exits the program.
Victory:
	la		$a0, winMsg
	li		$v0, 4	
	syscall	
	li		$v0, 10
	syscall



#Procedures: Pause & PauseLoop
#Function will "pause" MIPS so that output can be displayed for 0.5 seconds
Pause:
	li		$v0, 30
	syscall
	move	$t9, $a0
	PauseLoop:
		syscall
		subu		$t2, $a0, $t9
		bltu		$t2, 500, PauseLoop
		jr		$ra


# Procedure: InitRand
# Sets up logic using time for GetRand.
InitRand:
	li		$v0, 30
	syscall
	move	$a1, $a0
	li		$a0, 0
	li		$v0, 40
	syscall
	jr		$ra
# Procedure: GetRand
# Gets a random number for the game to use.
# The random number can range between 0 to 3.
GetRand:
	li		$a1, 4
	li		$v0, 42
	syscall
	jr		$ra


# Procedures: Blink & BoxLoop 
# Creates space for loading and using values to blink.
# Also loops for the blink using counters that incrementally increase.
Blink:
	li		$v0, 4
	la		$a0, newLine
	syscall
	addiu	$sp, $sp, -20
	li		$s5, 0
	sw		$ra, 12($sp)
	BlinkLoop:	
		li		$v0, 1
		lw		$a0, ($a1)
		addi		$a0, $a0, 1
		syscall
		addi		$a0, $a0, -1
		addi		$a1, $a1, 4
		sw		$a1, 8($sp)
		jal		GetColorData
		la		$t0, ColorData
		lw		$a2, 8($t0)
		lw		$a0, 0($t0)
		lw		$a1, 4($t0)
		sw		$s5, 16($sp)
		jal		DrawCircle
		jal		Pause
		jal		ClearScreen
		jal		HideText
		lw		$s5, 16($sp)
		addi		$s5, $s5, 1
		lw		$a1, 8($sp)
		blt		$s5, $s1, BlinkLoop
		lw		$ra, 12($sp)
		addiu	$sp, $sp, 20
		jr		$ra


# Procedure: GetColorData
# Loads in color data values and saves values to use with them.
# Also saves MIDI value.
GetColorData:
	mul	$a0, $a0, 16
	la	$t1, ColorData
	la	$t0, ColorsExt
	add	$a0, $a0, $t0
	lw	$t2, ($a0)
	sw	$t2, ($t1)
	addi	$a0, $a0, 4
	lw	$t2, ($a0)
	sw	$t2, 4($t1)
	addi	$a0, $a0, 4	
	lw	$t2, ($a0)
	sw	$t2, 8($t1)
	addi	$a0, $a0, 4
	lw	$t2, ($a0)
	sw	$t2, 12($t1)
	jr	$ra


# Procedures: DrawCircle & CircLoop
# Draws a circle by creating space for it.
# Uses a loop to set colors and numbers.
DrawCircle:
	addiu	$sp, $sp, -28
	sw		$ra, 20($sp)
	sw		$s0, 16($sp)
	sw		$a0, 12($sp)
	sw		$a2, 8($sp)
	li		$s2, 0
	CircLoop:
		la		$t1, CircleTable
		addi		$t2, $s2, 0
		mul		$t2, $t2, 8
		add		$t2, $t1, $t2
		lw		$t3, ($t2)
		add		$a0, $a0, $t3

		addi		$t2, $t2, 4
		lw		$a3, ($t2)
		sw		$a1, 4($sp)
		sw		$a3, 0($sp)
		sw		$s2, 24($sp)
		jal		DrawHorz

		lw		$a3, 0($sp)
		lw		$a1, 4($sp)
		lw		$a2, 8($sp)
		lw		$a0, 12($sp)
		lw		$s2, 24($sp)
		addi		$a1, $a1, 1
		addi		$s2, $s2, 1
		bne		$s2, 50, CircLoop
	
		# Drawing the numbers onto the shapes:
		addi		$t0, $a2, 0
		addi		$a1, $a1, -30
		beq		$t0, 0, setNum1
		beq		$t0, 1, setNum2
		beq		$t0, 2, setNum3
		beq		$t0, 3, setNum4

		setNum1:
			la	$a2, number1
			j	numOut
		setNum2:
			la	$a2, number2
			j	numOut
		setNum3:
			la	$a2, number3
			j	numOut
		setNum4:
			la	$a2, number4

		# Storing and Loading from stack:
		numOut:
		     sw	$a2, 8($sp)
		     jal	OutText

		lw	$a2, 8($sp)
	
		# Controlling the MIDI:
		# Setting instrument, volume, pitch, and rate values to be loaded up.
		la		$t0, ColorData
		lw		$a0, 12($t0)
		li		$a1, 500
		li		$a2, 3
		li		$a3, 64
		li		$v0, 33
		syscall
	
		# Restoring registers for use
		lw		$ra, 20($sp)
		lw		$s0, 16($sp)
		addiu	$sp, $sp, 28
		jr		$ra



# Procedure: DrawDot
# Draws a dot that can be used to create other shapes in the design.
# Gets hex values, calculates and saves address values.
DrawDot:
	addiu	$sp, $sp, -8
	sw		$ra, 4($sp)
	sw		$a2, 0($sp)
	jal		CalcAddress
	lw		$a2, 0($sp)
	sw		$v0, 0($sp)
	jal		GetColor
	lw		$v0, 0($sp)
	sw		$v1, ($v0)
	lw		$ra, 4($sp)
	addiu	$sp, $sp, 8
	jr		$ra
	

# Procedures: DrawHorz & HorzLoop
# Uses repeating dots to create lines, depending on how long we need them.
DrawHorz:
	addiu	$sp, $sp, -20
	sw		$ra, 16($sp)
	sw		$a1, 12($sp)
	sw		$a2, 8($sp)
	HorzLoop:
		# Saving and loading registers from the stack to use:
		sw		$a0, 4($sp)
		sw		$a3, 0($sp)
		jal		DrawDot
		lw		$a0, 4($sp)
		lw		$a1, 12($sp)
		lw		$a2, 8($sp)
		lw		$a3, 0($sp)	
		# Adjusting dimentions:
		addi		$a3, $a3, -1
		addi		$a0, $a0, 1
		bnez		$a3, HorzLoop
		lw		$ra, 16($sp)
		addiu	$sp, $sp, 20
		jr		$ra


# Procedure: DrawBox
# Setting coordinates, color values, and box dimensions.
# Uses repeating lines to create boxes.
DrawBox:
	# Saving registers and creating space for them to be used.
	addiu	$sp, $sp, -24
	sw		$ra, 20($sp)
	sw		$s0, 16($sp)
	sw		$a0, 12($sp)
	sw		$a2, 8($sp)
	move	$s0, $a3
	BoxLoop:
		# Storing and Restoring registers for values:
		# Incrementing and adjusting values for coordinates and dimentions using counter values.
		sw		$a1, 4($sp)
		sw		$a3, 0($sp)
		jal		DrawHorz
		lw		$a3, 0($sp)
		lw		$a1, 4($sp)
		lw		$a2, 8($sp)
		lw		$a0, 12($sp)
		addi		$a1, $a1, 1	
		addi		$s0, $s0, -1
		bne		$zero, $s0, BoxLoop
		lw		$ra, 20($sp)
		lw		$s0, 16($sp)
		addiu	$sp, $sp, 24
		jr		$ra
	
# Procedure: DrawCrossHairs
# Draws the actual white crosshairs for the game.
DrawCrossHairs:
	addiu	$sp, $sp, -8
	sw		$ra, 4($sp)
	
	# Using back-slashes:
	li	$t0, 0
	bkslshLoop:
	li	$a0, 25
	add	$a0, $a0, $t0
	li	$a1, 30
	add	$a1, $a1, $t0
	li	$a2, 4
	li	$a3, 3
	sw	$t0, 0($sp)
	jal	DrawHorz
	lw	$t0, 0($sp)
	addi	$t0, $t0, 1
	bne	$t0, 200, bkslshLoop
	
	# Using forward-slashes
	li	$t0, 0
	fwslshLoop:
	li	$a0, 25
	add	$a0, $a0, $t0
	li	$a1, 226
	sub	$a1, $a1, $t0
	li	$a2, 4
	li	$a3, 3
	sw	$t0, 0($sp)
	jal	DrawHorz
	lw	$t0, 0($sp)
	addi	$t0, $t0, 1
	bne	$t0, 200, fwslshLoop

	lw		$ra, 4($sp)
	addiu	$sp, $sp, 8
	jr		$ra


# Procedure: CalcAddress
# Calculates addresses for use.
CalcAddress:
	sll	$a0, $a0, 2
	sll	$a1, $a1, 10
	add	$v0, $a0, $a1
	addi	$v0, $v0, 0x10040000
	jr	$ra

# Procedure: GetColor
# Gets hex values of colors.
GetColor:
	la	$t0, ColorTable
	sll	$a2, $a2, 2
	add	$a2, $a2, $t0
	lw	$v1, ($a2)
	jr	$ra

# Procedures: GetChar, CharLoop, & CharCheck
# Checks existence of a character based on user inputs, and creates a loop for checking timeout losses.
GetChar:
	addiu	$sp, $sp, -8
	sw		$ra, 0($sp)
	li		$s3, 0
	j		CharCheck
	CharLoop:
		sw		$s3, 4($sp)
		jal		Pause
		lw		$s3, 4($sp)
		addi		$s3, $s3, 1
		beq		$s3, 10, Timeout
	CharCheck:
		jal		IsCharThere
		beqz		$v0, CharLoop
		lui		$t0, 0xFFFF
		lw		$v0, 4($t0)
		lw		$ra, 0($sp)
		addiu	$sp, $sp, 8
		jr		$ra

# Procedure: IsCharThere
# Checks existence of a character in the memory using register control data.
IsCharThere:
	lui	$t0, 0xFFFF
	lw	$t1, ($t0)
	andi	$v0, $t1, 1
	jr	$ra


# Procedure: Timeout
# Used to check if user is taking too long to answer.
# Can be called to load up a failure state.
Timeout:
	la	$t0, sequence
	mul	$t2, $s5, 4
	add	$t0, $t0, $t2
	lb	$t1, ($t0)
	addi	$a0, $t1, 0	
	j	Failure
	
# Procedure: ClearScreen
# Clears the entire display for game resets or round changes using crosshairs.
ClearScreen:
	addiu	$sp, $sp, -4
	sw		$ra, ($sp)
	li		$a0, 0
	li		$a1, 0
	li		$a2, 5
	li		$a3, 256
	jal		DrawBox
	jal		DrawCrossHairs
	lw		$ra, ($sp)
	addiu	$sp, $sp, 4
	jr		$ra
	
# Procedure: HideText
# Prints a bunch of new lines to hide text from the screen.
HideText:
	li		$v0, 4
	la		$a0, newLine
	syscall
	syscall
	syscall
	syscall
	syscall
	syscall
	syscall
	syscall
	jr		$ra

# OutText: display ascii characters on the bit mapped display
# $a0 = horizontal pixel co-ordinate (0-255)
# $a1 = vertical pixel co-ordinate (0-255)
# $a2 = pointer to asciiz text (to be displayed)
OutText:
	addiu	$sp, $sp, -24
	sw		$ra, 20($sp)

	li		$t8, 1			# line number in the digit array (1-12)
_text1:
	la		$t9, 0x10040000	# get the memory start address
	sll		$t0, $a0, 2			# assumes mars was configured as 256 x 256
	addu		$t9, $t9, $t0		# and 1 pixel width, 1 pixel height
	sll		$t0, $a1, 10		# (a0 * 4) + (a1 * 4 * 256)
	addu		$t9, $t9, $t0		# t9 = memory address for this pixel

	move	$t2, $a2			# t2 = pointer to the text string
_text2:
	lb		$t0, 0($t2)			# character to be displayed
	addiu	$t2, $t2, 1			# last character is a null
	beq		$t0, $zero, _text9

	la		$t3, DigitTable		# find the character in the table
_text3:
	lb		$t4, 0($t3)			# get an entry from the table
	beq		$t4, $t0, _text4
	beq		$t4, $zero, _text4
	addiu	$t3, $t3, 13		# go to the next entry in the table
	j		_text3
_text4:
	addu		$t3, $t3, $t8		# t8 is the line number
	lb		$t4, 0($t3)			# bit map to be displayed

	sw		$zero, 0($t9)		# first pixel is black
	addiu	$t9, $t9, 4

	li		$t5, 8			# 8 bits to go out
_text5:
	la		$t7, Colors
	lw		$t7, 0($t7)			# assume black
	andi		$t6, $t4, 0x80		# mask out the bit (0=black, 1=white)
	beq		$t6, $zero, _text6
	la		$t7, Colors		# else it is white
	lw		$t7, 4($t7)
_text6:
	sw		$t7, 0($t9)			# write the pixel color
	addiu	$t9, $t9, 4			# go to the next memory position
	sll		$t4, $t4, 1			# and line number
	addiu	$t5, $t5, -1		# and decrement down (8,7,...0)
	bne		$t5, $zero, _text5

	sw		$zero, 0($t9)		# last pixel is black
	addiu	$t9, $t9, 4
	j		_text2			# go get another character
_text9:
	addiu	$a1, $a1, 1		# advance to the next line
	addiu	$t8, $t8, 1			# increment the digit array offset (1-12)
	bne		$t8, 13, _text1
	lw		$ra, 20($sp)
	addiu	$sp, $sp, 24
	jr		$ra
