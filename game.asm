#####################################################################
#
# CSCB58 Winter 2024 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Julian Liu, 1008819272, liujul12, laz.liu@mail.utoronto.ca
#
# Bitmap Display Configuration:
# - Unit width in pixels: 4 (update this as needed)
# - Unit height in pixels: 4 (update this as needed)
# - Display width in pixels: 256 (update this as needed)
# - Display height in pixels: 256 (update this as needed) 
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3/4 (choose the one the applies) 
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features) 
# 1. 
# 2. 
# 3. 
# ... (add more if necessary)
#
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it! 
#
# Are you OK with us sharing the video with people outside course staff?
# - yes / no / yes, and please share this project github link as well! 
#
# Any additional information that the TA needs to know:
# - (write here, if any)
# 
#####################################################################

.data
.eqv BASE_ADDRESS 0x10008000
.eqv FRAME_DELAY 50
.eqv GRAVITY 1
.eqv PLAYER_HEIGHT 5
.eqv FLOOR_HEIGHT 62
.eqv BOSS_HEIGHT 8
.eqv BACKGROUND 0x444444
.eqv BODY_COLOUR 0xff7700
.eqv LASER_COLOUR 0x22eecc
.eqv BOSS_COLOUR 0x22cc44
.eqv SPIKE_COLOUR 0xff0000
.eqv FLOOR_LIGHT 0xbbbbcc
.eqv FLOOR_DARK 0x888899
.eqv SCORE_COLOUR 0xffcccc

# player:
# 2 bytes: x position
# 2 bytes: y position
# 1 byte: x velocity
# 1 byte: y velocity
# 1 byte: jump state
# 1 byte: health points
# 1 byte: damaged state
# 1 byte: direction
# 2 bytes: previous x position
# 2 bytes: previous y position
player: .space 14

# laser:
# 2 bytes: x position
# 2 bytes: y position
# 1 byte: x velocity
# 1 byte: y velocity
# 2 bytes: previous x position
# 2 bytes: previous y position
laser: .space 10

# boss_states:
# 2 bytes: x position
# 2 bytes: y position
# 1 byte: x velocity
# 1 byte: y velocity
# 1 byte: jump state
# 1 byte: health points
# 1 byte: damaged state
# 1 byte: shooting
# 2 bytes: previous x position
# 2 bytes: previous y position
boss_states: .space 14

# dart:
# 2 bytes: x position
# 2 bytes: y position
# 1 byte: x velocity
# 1 byte: y velocity
# 2 bytes: previous x position
# 2 bytes: previous y position
dart: .space 10

# platforms:
# 2 bytes: x position
# 2 bytes: y position
platform_1: .space 4
platform_2: .space 4
platform_3: .space 4
platform_4: .space 4
platform_5: .space 4

# moving platform:
# 2 bytes: x position
# 2 bytes: y position
# 1 byte: x velocity
# 1 byte: y velocity
# 2 bytes: previous x position
# 2 bytes: previous y position
slider: .space 10


.globl main_title
.text

main_title:
	# main title display
	jal reset_screen
	li $t0, BASE_ADDRESS
	li $t1, 0x00ff00
	
	# title AB-58 
	addi $t0, $t0, 8192
	# first letter A
	addi $t0, $t0, 48
	li $t1, BODY_COLOUR
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 516($t0)
	li $t1, LASER_COLOUR
	sw $t1, 520($t0)
	sw $t1, 524($t0)
	sw $t1, 528($t0)
	li $t1, BODY_COLOUR
	sw $t1, 532($t0)
	sw $t1, 768($t0)
	sw $t1, 772($t0)
	li $t1, LASER_COLOUR	
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 784($t0)
	li $t1, BODY_COLOUR
	sw $t1, 788($t0)
	sw $t1, 792($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)
	sw $t1, 1040($t0)
	sw $t1, 1044($t0)
	sw $t1, 1048($t0)
	sw $t1, 1280($t0)
	sw $t1, 1284($t0)
	sw $t1, 1288($t0)
	sw $t1, 1292($t0)
	sw $t1, 1296($t0)
	sw $t1, 1300($t0)
	sw $t1, 1304($t0)
	sw $t1, 1536($t0)
	sw $t1, 1540($t0)
	sw $t1, 1556($t0)
	sw $t1, 1560($t0)
	sw $t1, 1792($t0)
	sw $t1, 1796($t0)
	sw $t1, 1812($t0)
	sw $t1, 1816($t0)
	
	# second letter B 
	addi $t0, $t0, 32
	li $t1, BOSS_COLOUR
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 256($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 528($t0)
	sw $t1, 532($t0)
	sw $t1, 768($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 784($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)
	sw $t1, 1040($t0)
	sw $t1, 1044($t0)
	sw $t1, 1280($t0)
	sw $t1, 1284($t0)
	sw $t1, 1296($t0)
	sw $t1, 1300($t0)
	sw $t1, 1536($t0)
	sw $t1, 1548($t0)
	sw $t1, 1552($t0)
	sw $t1, 1556($t0)
	sw $t1, 1792($t0)
	sw $t1, 1796($t0)
	sw $t1, 1800($t0)
	sw $t1, 1804($t0)
	sw $t1, 1808($t0)

	# third char - 
	addi $t0, $t0, 32
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 784($t0)
	sw $t1, 788($t0)
	sw $t1, 1028($t0)
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)
	sw $t1, 1040($t0)

	# fourth char 5
	addi $t0, $t0, 32
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 784($t0)
	sw $t1, 788($t0)
	sw $t1, 1036($t0)
	sw $t1, 1040($t0)
	sw $t1, 1044($t0)
	sw $t1, 1048($t0)
	sw $t1, 1284($t0)
	sw $t1, 1296($t0)
	sw $t1, 1300($t0)
	sw $t1, 1304($t0)
	sw $t1, 1540($t0)
	sw $t1, 1544($t0)
	sw $t1, 1548($t0)
	sw $t1, 1552($t0)
	sw $t1, 1556($t0)
	sw $t1, 1560($t0)
	sw $t1, 1800($t0)
	sw $t1, 1804($t0)
	sw $t1, 1808($t0)
	sw $t1, 1812($t0)

	# fifth char 8
	addi $t0, $t0, 32
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 532($t0)
	sw $t1, 536($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 784($t0)
	sw $t1, 788($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	sw $t1, 1044($t0)
	sw $t1, 1048($t0)
	sw $t1, 1280($t0)
	sw $t1, 1284($t0)
	sw $t1, 1300($t0)
	sw $t1, 1304($t0)
	sw $t1, 1536($t0)
	sw $t1, 1540($t0)
	sw $t1, 1556($t0)
	sw $t1, 1560($t0)
	sw $t1, 1796($t0)
	sw $t1, 1800($t0)
	sw $t1, 1804($t0)
	sw $t1, 1808($t0)
	sw $t1, 1812($t0)

main_title_loop:
	li $t9, 0xffff0000
	lw $t8, 0($t9)
	beq $t8, 1, main_title_keypressed
main_title_loop_refresh:
	li $v0, 32
	li $a0, FRAME_DELAY
	syscall
	j main_title_loop
main_title_keypressed:
	lw $t8, 4($t9) 
	beq $t8, 0x67, game # key g
	j main_title_loop_refresh

reset_screen:
	li $t1, BACKGROUND
	move $t2, $zero
reset_screen_loop:
	sw $t1, BASE_ADDRESS($t2)
	addi $t2, $t2, 4
	bne $t2, 16380, reset_screen_loop
draw_floor:
	# draw floor
	li $t0, BASE_ADDRESS
	li $t1, FLOOR_HEIGHT
	mul $t1, $t1, 256
	add $t0, $t0, $t1 # floor height in $t0
	li $t1, FLOOR_DARK
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	sw $t1, 36($t0)
	sw $t1, 40($t0)
	sw $t1, 44($t0)
	sw $t1, 48($t0)
	sw $t1, 52($t0)
	sw $t1, 56($t0)
	sw $t1, 60($t0)
	sw $t1, 64($t0)
	sw $t1, 68($t0)
	sw $t1, 72($t0)
	sw $t1, 76($t0)
	sw $t1, 80($t0)
	sw $t1, 84($t0)
	sw $t1, 88($t0)
	sw $t1, 92($t0)
	sw $t1, 96($t0)
	sw $t1, 100($t0)
	sw $t1, 104($t0)
	sw $t1, 108($t0)
	sw $t1, 112($t0)
	sw $t1, 116($t0)
	sw $t1, 120($t0)
	sw $t1, 124($t0)
	sw $t1, 128($t0)
	sw $t1, 132($t0)
	sw $t1, 136($t0)
	sw $t1, 140($t0)
	sw $t1, 144($t0)
	sw $t1, 148($t0)
	sw $t1, 152($t0)
	sw $t1, 156($t0)
	sw $t1, 160($t0)
	sw $t1, 164($t0)
	sw $t1, 168($t0)
	sw $t1, 172($t0)
	sw $t1, 176($t0)
	sw $t1, 180($t0)
	sw $t1, 184($t0)
	sw $t1, 188($t0)
	sw $t1, 192($t0)
	sw $t1, 196($t0)
	sw $t1, 200($t0)
	sw $t1, 204($t0)
	sw $t1, 208($t0)
	sw $t1, 212($t0)
	sw $t1, 216($t0)
	sw $t1, 220($t0)
	sw $t1, 224($t0)
	sw $t1, 228($t0)
	sw $t1, 232($t0)
	sw $t1, 236($t0)
	sw $t1, 240($t0)
	sw $t1, 244($t0)
	sw $t1, 248($t0)
	sw $t1, 252($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 284($t0)
	sw $t1, 288($t0)
	sw $t1, 292($t0)
	sw $t1, 296($t0)
	sw $t1, 300($t0)
	sw $t1, 304($t0)
	sw $t1, 308($t0)
	sw $t1, 312($t0)
	sw $t1, 316($t0)
	sw $t1, 320($t0)
	sw $t1, 324($t0)
	sw $t1, 328($t0)
	sw $t1, 332($t0)
	sw $t1, 336($t0)
	sw $t1, 340($t0)
	sw $t1, 344($t0)
	sw $t1, 348($t0)
	sw $t1, 352($t0)
	sw $t1, 356($t0)
	sw $t1, 360($t0)
	sw $t1, 364($t0)
	sw $t1, 368($t0)
	sw $t1, 372($t0)
	sw $t1, 376($t0)
	sw $t1, 380($t0)
	sw $t1, 384($t0)
	sw $t1, 388($t0)
	sw $t1, 392($t0)
	sw $t1, 396($t0)
	sw $t1, 400($t0)
	sw $t1, 404($t0)
	sw $t1, 408($t0)
	sw $t1, 412($t0)
	sw $t1, 416($t0)
	sw $t1, 420($t0)
	sw $t1, 424($t0)
	sw $t1, 428($t0)
	sw $t1, 432($t0)
	sw $t1, 436($t0)
	sw $t1, 440($t0)
	sw $t1, 444($t0)
	sw $t1, 448($t0)
	sw $t1, 452($t0)
	sw $t1, 456($t0)
	sw $t1, 460($t0)
	sw $t1, 464($t0)
	sw $t1, 468($t0)
	sw $t1, 472($t0)
	sw $t1, 476($t0)
	sw $t1, 480($t0)
	sw $t1, 484($t0)
	sw $t1, 488($t0)
	sw $t1, 492($t0)
	sw $t1, 496($t0)
	sw $t1, 500($t0)
	sw $t1, 504($t0)
	sw $t1, 508($t0)
	
	jr $ra

game:
	jal reset_screen
		
	# print hearts
	li $t0, BASE_ADDRESS
	addi $t0, $t0, 260 # starting point
	li $t2, 5 # counter
init_hearts_loop:
	li $t1, SCORE_COLOUR
	sw $t1, 268($t0)
	li $t1, SPIKE_COLOUR	
	sw $t1, 4($t0)
	sw $t1, 12($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 272($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 524($t0)
	sw $t1, 528($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 1032($t0)
	addi $t0, $t0, 24
	addi $t2, $t2, -1
	bnez $t2, init_hearts_loop
	
	# initialize player states
	li $t0, 1
	li $t2, 57
	li $t7, 5
	li $t9, 1
	sh $t0, player+0($zero)
	sh $t2, player+2($zero)
	sh $zero, player+4($zero)
	sb $zero, player+5($zero)
	sb $zero, player+6($zero)
	sb $t7, player+7($zero)
	sb $zero, player+8($zero)
	sb $t9, player+9($zero)
	sh $t0, player+10($zero)
	sh $t2, player+12($zero)
	
	# initialize laser states
	li $t0, 50
	li $t2, 0
	li $t4, 0
	li $t5, 0
	sh $t0, laser+0($zero)
	sh $t2, laser+2($zero)
	sb $t4, laser+4($zero)	
	sb $t5, laser+5($zero)	
	sh $t0, laser+6($zero)
	sh $t2, laser+8($zero)
	
	# initialize boss states
	li $t0, 56
	li $t2, 54
	li $t7, 100
	li $t9, 0
	sh $t0, boss_states+0($zero)
	sh $t2, boss_states+2($zero)
	sh $zero, boss_states+4($zero)
	sb $zero, boss_states+5($zero)
	sb $zero, boss_states+6($zero)
	sb $t7, boss_states+7($zero)
	sb $zero, boss_states+8($zero)	
	sb $t9, boss_states+9($zero)
	sh $t0, boss_states+10($zero)
	sh $t2, boss_states+12($zero)
	
	# initialize dart states
	li $t0, 60
	li $t2, 0
	li $t4, 0
	li $t5, 0
	sh $t0, dart+0($zero)
	sh $t2, dart+2($zero)
	sb $t4, dart+4($zero)	
	sb $t5, dart+5($zero)	
	sh $t0, dart+6($zero)
	sh $t2, dart+8($zero)
			
	# initialize platform states		
	li $t0, 27
	li $t2, 55
	sh $t0, platform_1+0($zero)
	sh $t2, platform_1+2($zero)

	li $t0, 40
	li $t2, 44
	sh $t0, platform_2+0($zero)
	sh $t2, platform_2+2($zero)

	li $t0, 53
	li $t2, 33
	sh $t0, platform_3+0($zero)
	sh $t2, platform_3+2($zero)

	li $t0, 8
	li $t2, 44
	sh $t0, platform_4+0($zero)
	sh $t2, platform_4+2($zero)

	li $t0, 0
	li $t2, 26
	sh $t0, platform_5+0($zero)
	sh $t2, platform_5+2($zero)
	
	# initialize slider states
	li $t0, 13
	li $t2, 37
	li $t4, 1
	li $t5, -1
	sh $t0, slider+0($zero)
	sh $t2, slider+2($zero)
	sb $t4, slider+4($zero)	
	sb $t5, slider+5($zero)	
	sh $t0, slider+6($zero)
	sh $t2, slider+8($zero)
	

game_check_keypress:
	li $t9, 0xffff0000
	lw $t8, 0($t9)
	beq $t8, 1, game_keypressed
	
game_update_positions:
	# apply gravity, update player position
	lh $t0, player+0($zero)
	lh $t2, player+2($zero)
	lb $t4, player+4($zero)
	lb $t5, player+5($zero)
	addi $t5, $t5, GRAVITY
	add $t0, $t0, $t4
	add $t2, $t2, $t5
	sh $t0, player+0($zero)
	sh $t2, player+2($zero)
	sb $t5, player+5($zero)
	
	# update laser x position
	lh $t0, laser+0($zero)
	lb $t4, laser+4($zero)
	add $t0, $t0, $t4
	sh $t0, laser+0($zero)

	# choose velocity for boss depending on jump state

	# update dart y position
	lh $t2, dart+2($zero)
	lb $t5, dart+5($zero)
	add $t2, $t2, $t5
	sh $t2, dart+2($zero)

	
	# update slider position then velocity
	lh $t0, slider+0($zero)
	lh $t2, slider+2($zero)
	lb $t4, slider+4($zero)
	lb $t5, slider+5($zero)
	add $t0, $t0, $t4
	add $t2, $t2, $t5
	sh $t0, slider+0($zero)
	sh $t2, slider+2($zero)
	blt $t0, 13, turn_slider
	blt $t0, 27, game_check_collisions
turn_slider: 
	mul $t4, $t4, -1
	mul $t5, $t5, -1	
	sb $t4, slider+4($zero)
	sb $t5, slider+5($zero)
	
	
game_check_collisions:

player_collisions:
	# get player states
	lh $t0, player+0($zero) # x position
	lh $t2, player+2($zero) # y position
	lb $t4, player+4($zero) # x velocity
	lb $t5, player+5($zero) # y velocity
	lb $t6, player+6($zero) # jump state
	lb $t7, player+7($zero) # health points
	
player_floor:
	# check player-floor collision
	li $t1, FLOOR_HEIGHT
	addi $t1, $t1, -PLAYER_HEIGHT
	blt $t2, $t1, player_platforms
	# update player states
	move $t2, $t1
	sh $t2, player+2($zero)	
	sb $zero, player+4($zero)
	sb $zero, player+5($zero)
	sb $zero, player+6($zero)
	j player_left_wall

player_platforms:
	# if velocity is going up, do not check for platform collision
	blt $t5, $zero, player_left_wall

player_platform_1:
	# check player-platform_1 collision
	lh $t8, platform_1+2($zero)
	bgt $t2, $t8, player_platform_2 # check y position
	addi $t8, $t8, -PLAYER_HEIGHT
	blt $t2, $t8, player_platform_2 # check foot position
	lh $t9, platform_1+0($zero)
	addi $t9, $t9, -2
	blt $t0, $t9, player_platform_2 # check left edge of platform
	addi $t9, $t9, 11
	bgt $t0, $t9, player_platform_2 # check right edge of platform
	# update player states accordingly
	sh $t8, player+2($zero)	
	sb $zero, player+4($zero)
	sb $zero, player+5($zero)
	sb $zero, player+6($zero)
	j player_slider

player_platform_2:
	# check player-platform_2 collision
	lh $t8, platform_2+2($zero)
	bgt $t2, $t8, player_platform_3 # check y position
	addi $t8, $t8, -PLAYER_HEIGHT
	blt $t2, $t8, player_platform_3 # check foot position
	lh $t9, platform_2+0($zero)
	addi $t9, $t9, -2
	blt $t0, $t9, player_platform_3 # check left edge of platform
	addi $t9, $t9, 11
	bgt $t0, $t9, player_platform_3 # check right edge of platform
	# update player states accordingly
	sh $t8, player+2($zero)	
	sb $zero, player+4($zero)
	sb $zero, player+5($zero)
	sb $zero, player+6($zero)
	j player_slider

player_platform_3:
	# check player-platform_3 collision
	lh $t8, platform_3+2($zero)
	bgt $t2, $t8, player_platform_4 # check y position
	addi $t8, $t8, -PLAYER_HEIGHT
	blt $t2, $t8, player_platform_4 # check foot position
	lh $t9, platform_3+0($zero)
	addi $t9, $t9, -2
	blt $t0, $t9, player_platform_4 # check left edge of platform
	addi $t9, $t9, 11
	bgt $t0, $t9, player_platform_4 # check right edge of platform
	# update player states accordingly
	sh $t8, player+2($zero)	
	sb $zero, player+4($zero)
	sb $zero, player+5($zero)
	sb $zero, player+6($zero)
	j player_slider

player_platform_4:
	# check player-platform_4 collision
	lh $t8, platform_4+2($zero)
	bgt $t2, $t8, player_platform_5 # check y position
	addi $t8, $t8, -PLAYER_HEIGHT
	blt $t2, $t8, player_platform_5 # check foot position
	lh $t9, platform_4+0($zero)
	addi $t9, $t9, -2
	blt $t0, $t9, player_platform_5 # check left edge of platform
	addi $t9, $t9, 11
	bgt $t0, $t9, player_platform_5 # check right edge of platform
	# update player states accordingly
	sh $t8, player+2($zero)	
	sb $zero, player+4($zero)
	sb $zero, player+5($zero)
	sb $zero, player+6($zero)
	j player_slider

player_platform_5:
	# check player-platform_5 collision
	lh $t8, platform_5+2($zero)
	bgt $t2, $t8, player_slider # check y position
	addi $t8, $t8, -PLAYER_HEIGHT
	blt $t2, $t8, player_slider # check foot position
	lh $t9, platform_5+0($zero)
	addi $t9, $t9, -2
	blt $t0, $t9, player_slider # check left edge of platform
	addi $t9, $t9, 11
	bgt $t0, $t9, player_slider # check right edge of platform
	# update player states accordingly
	sh $t8, player+2($zero)	
	sb $zero, player+4($zero)
	sb $zero, player+5($zero)
	sb $zero, player+6($zero)
	j player_slider

player_slider:
	# check player-slider collision
	lh $t8, slider+2($zero)
	bgt $t2, $t8, player_left_wall # check y position
	addi $t8, $t8, -PLAYER_HEIGHT
	blt $t2, $t8, player_left_wall # check foot position
	lh $t9, slider+0($zero)
	addi $t9, $t9, -2
	blt $t0, $t9, player_left_wall # check left edge of platform
	addi $t9, $t9, 11
	bgt $t0, $t9, player_left_wall # check right edge of platform
	# update player states accordingly
	lb $t4, slider+4($zero)
	lb $t5, slider+5($zero)
	sh $t8, player+2($zero)	
	sb $t4, player+4($zero)
	sb $t5, player+5($zero)
	sb $zero, player+6($zero)

player_left_wall:
	# check player-left_wall collision
	bgt $t0, 0, player_right_wall
	sh $zero, player+0($zero)
	sb $zero, player+4($zero)

player_right_wall:
	# check player-right_wall collision
	blt $t0, 60, player_boss
	li $t0, 60
	sh $t0, player+0($zero)
	sb $zero, player+4($zero)

player_boss:
	# check player-boss collision
	lh $t8, boss_states+0($zero) # boss x position
	addi $t8, $t8, -4
	bgt $t8, $t0, player_dart # check left x bound
	addi $t8, $t8, 11	
	blt $t8, $t0, player_dart # check right x bound	
	lh $t9, boss_states+2($zero) # boss y position
	addi $t9, $t9, -5
	bgt $t9, $t0, player_dart # check upper y bound
	addi $t9, $t9, 13	
	blt $t9, $t0, player_dart # check lower x bound
	# update player states accordingly
	lb $t9, player+9($zero) # get player direction to calculate knockback
	beqz $t9, knockback_right
	li $t4, -3
	j finish_knockback
knockback_right:
	li $t4, 3
finish_knockback:
	li $t5, -3 # upwards knockback	
	li $t6, 2 # cannot jump or double jump
	addi $t7, $t7, -1 # lose one life
	li $t8, 1
	sb $t4, player+4($zero)
	sb $t5, player+5($zero)	
	sb $t6, player+6($zero)		
	sb $t7, player+7($zero)
	sb $t8, player+8($zero)
	
	
	
	
player_dart:
	# check player-projectile collision

boss_collisions:
	# get boss states
	lh $t0, boss_states+0($zero) # x position
	lh $t2, boss_states+2($zero) # y position
	lb $t4, boss_states+4($zero) # x velocity
	lb $t5, boss_states+5($zero) # y velocity
	lb $t6, boss_states+6($zero) # jump state

boss_floor:
	# check boss-floor collision
	li $t1, FLOOR_HEIGHT
	addi $t1, $t1, -BOSS_HEIGHT
	blt $t2, $t1, boss_platforms
	# update boss states
	move $t2, $t1
	sh $t2, boss_states+2($zero)	
	sb $zero, boss_states+4($zero)
	sb $zero, boss_states+5($zero)
	sb $zero, boss_states+6($zero)
	j boss_left_wall

boss_platforms:
	# if velocity is going up, do not check for platform collision
	blt $t5, $zero, boss_left_wall

boss_platform_1:
	# check boss-platform_1 collision
	lh $t8, platform_1+2($zero)
	bgt $t2, $t8, boss_left_wall # check y position
	addi $t8, $t8, -BOSS_HEIGHT
	blt $t2, $t8, boss_left_wall # check foot position
	lh $t9, platform_1+0($zero)
	addi $t9, $t9, -4
	blt $t0, $t9, boss_left_wall # check left edge of platform
	addi $t9, $t9, 11
	bgt $t0, $t9, boss_left_wall # check right edge of platform
	# update player states accordingly
	sh $t8, boss_states+2($zero)	
	sb $zero, boss_states+4($zero)
	sb $zero, boss_states+5($zero)
	sb $zero, boss_states+6($zero)

boss_left_wall:
	# check boss-left_wall collision
	bgt $t0, 0, boss_right_wall
	sh $zero, boss_states+0($zero)
	sb $zero, boss_states+4($zero)

boss_right_wall:
	# check boss-right_wall collision
	blt $t0, 60, game_update_screen
	li $t0, 60
	sh $t0, player+0($zero)
	sb $zero, player+4($zero)



game_update_screen:
	#sw $t1, 16380($t0)

erase_player:
	# erase player
	lh $t0, player+10($zero) # previous x position
	lh $t2, player+12($zero) # previous y position
	li $t1, BACKGROUND # background colour
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 4 into $t2
	add $t0, $t0, $t2
	addi $t0, $t0, BASE_ADDRESS
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 524($t0)
	sw $t1, 768($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)

erase_laser:
	# erase laser
	lh $t0, laser+6($zero) # previous x position	
	lh $t2, laser+8($zero) # previous y position
	li $t1, BACKGROUND
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 4 into $t2
	add $t0, $t0, $t2
	addi $t0, $t0, BASE_ADDRESS # laser location in $t0
	sw $t1, 0($t0)
	sw $t1, 4($t0)

erase_boss:
	# erase boss
	lh $t0, boss_states+10($zero) # previous x position
	lh $t2, boss_states+12($zero) # previous y position
	li $t1, BACKGROUND # background colour
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 4 into $t2
	add $t0, $t0, $t2
	addi $t0, $t0, BASE_ADDRESS
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)

	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)

	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 524($t0)
	sw $t1, 528($t0)
	sw $t1, 532($t0)
	sw $t1, 536($t0)

	sw $t1, 768($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 784($t0)
	sw $t1, 788($t0)
	sw $t1, 792($t0)

	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)
	sw $t1, 1040($t0)
	sw $t1, 1044($t0)
	sw $t1, 1048($t0)

	sw $t1, 1280($t0)
	sw $t1, 1284($t0)
	sw $t1, 1288($t0)
	sw $t1, 1292($t0)
	sw $t1, 1296($t0)
	sw $t1, 1300($t0)
	sw $t1, 1304($t0)

	sw $t1, 1536($t0)
	sw $t1, 1540($t0)
	sw $t1, 1544($t0)
	sw $t1, 1548($t0)
	sw $t1, 1552($t0)
	sw $t1, 1556($t0)
	sw $t1, 1560($t0)

	sw $t1, 1792($t0)
	sw $t1, 1796($t0)
	sw $t1, 1800($t0)
	sw $t1, 1804($t0)
	sw $t1, 1808($t0)
	sw $t1, 1812($t0)
	sw $t1, 1816($t0)

erase_slider:
	# erase slider
	lh $t0, slider+6($zero) # previous x position	
	lh $t2, slider+8($zero) # previous y position
	li $t1, BACKGROUND
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 4 into $t2
	add $t0, $t0, $t2
	addi $t0, $t0, BASE_ADDRESS
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	sw $t1, 36($t0)
	sw $t1, 40($t0)	
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 284($t0)
	sw $t1, 288($t0)
	sw $t1, 292($t0)

paint_platforms:
	# paint platform_1
	lh $t0, platform_1+0($zero) # x position	
	lh $t2, platform_1+2($zero) # y position
	li $t1, FLOOR_LIGHT
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 4 into $t2
	add $t0, $t0, $t2
	addi $t0, $t0, BASE_ADDRESS
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	sw $t1, 36($t0)
	sw $t1, 40($t0)
	li $t1, FLOOR_DARK	
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 284($t0)
	sw $t1, 288($t0)
	sw $t1, 292($t0)

	# paint platform_2
	lh $t0, platform_2+0($zero) # x position	
	lh $t2, platform_2+2($zero) # y position
	li $t1, FLOOR_LIGHT
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 4 into $t2
	add $t0, $t0, $t2
	addi $t0, $t0, BASE_ADDRESS
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	sw $t1, 36($t0)
	sw $t1, 40($t0)	
	li $t1, FLOOR_DARK	
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 284($t0)
	sw $t1, 288($t0)
	sw $t1, 292($t0)

	# paint platform_3
	lh $t0, platform_3+0($zero) # x position	
	lh $t2, platform_3+2($zero) # y position
	li $t1, FLOOR_LIGHT
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 4 into $t2
	add $t0, $t0, $t2
	addi $t0, $t0, BASE_ADDRESS
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	sw $t1, 36($t0)
	sw $t1, 40($t0)	
	li $t1, FLOOR_DARK	
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 284($t0)
	sw $t1, 288($t0)
	sw $t1, 292($t0)

	# paint platform_4
	lh $t0, platform_4+0($zero) # x position	
	lh $t2, platform_4+2($zero) # y position
	li $t1, FLOOR_LIGHT
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 4 into $t2
	add $t0, $t0, $t2
	addi $t0, $t0, BASE_ADDRESS
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	sw $t1, 36($t0)
	sw $t1, 40($t0)	
	li $t1, FLOOR_DARK	
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 284($t0)
	sw $t1, 288($t0)
	sw $t1, 292($t0)

	# paint platform_5
	lh $t0, platform_5+0($zero) # x position	
	lh $t2, platform_5+2($zero) # y position
	li $t1, FLOOR_LIGHT
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 4 into $t2
	add $t0, $t0, $t2
	addi $t0, $t0, BASE_ADDRESS
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	sw $t1, 36($t0)
	sw $t1, 40($t0)	
	li $t1, FLOOR_DARK	
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 284($t0)
	sw $t1, 288($t0)
	sw $t1, 292($t0)

paint_slider:
	# paint slider
	lh $t0, slider+0($zero) # x position
	lh $t2, slider+2($zero) # y position
	sh $t0, slider+6($zero) # store as previous x position
	sh $t2, slider+8($zero) # store as previous y position
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 4 into $t2
	add $t0, $t0, $t2
	addi $t0, $t0, BASE_ADDRESS # slider location in $t0
	li $t1, FLOOR_LIGHT
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	sw $t1, 36($t0)
	sw $t1, 40($t0)	
	li $t1, FLOOR_DARK	
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 284($t0)
	sw $t1, 288($t0)
	sw $t1, 292($t0)

paint_boss: 
	# paint boss
	lh $t0, boss_states+0($zero) # x position
	lh $t2, boss_states+2($zero) # y position
	sh $t0, boss_states+10($zero) # store as previous x position
	sh $t2, boss_states+12($zero) # store as previous y position
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 4 into $t2
	add $t0, $t0, $t2
	addi $t0, $t0, BASE_ADDRESS
	li $t1, BOSS_COLOUR
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 264($t0)
	sw $t1, 272($t0)
	sw $t1, 520($t0)
	sw $t1, 524($t0)
	sw $t1, 528($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 784($t0)
	sw $t1, 788($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	sw $t1, 1044($t0)
	sw $t1, 1048($t0)
	sw $t1, 1280($t0)
	sw $t1, 1284($t0)
	sw $t1, 1288($t0)
	sw $t1, 1292($t0)
	sw $t1, 1296($t0)
	sw $t1, 1300($t0)
	sw $t1, 1304($t0)
	sw $t1, 1536($t0)
	sw $t1, 1544($t0)
	sw $t1, 1548($t0)
	sw $t1, 1552($t0)
	sw $t1, 1560($t0)
	sw $t1, 1800($t0)
	sw $t1, 1808($t0)
	li $t1, SPIKE_COLOUR
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)
	sw $t1, 1040($t0)
	
paint_player:
	# paint player
	lh $t0, player+0($zero) # x position
	lh $t2, player+2($zero) # y position
	sh $t0, player+10($zero) # store as previous x position
	sh $t2, player+12($zero) # store as previous y position
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 4 into $t2
	add $t0, $t0, $t2
	addi $t0, $t0, BASE_ADDRESS
	# determine body colour
	lb $t8, player+8($zero)
	bne $t8, 1, is_not_damaged
	li $t1, SPIKE_COLOUR
	j paint_player_continue
is_not_damaged:
	li $t1, BODY_COLOUR

paint_player_continue:
	# body parts independent of direction
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 524($t0)
	sw $t1, 768($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	# parts dependent of direction	
	lb $t9, player+9($zero)
	beqz $t9, player_facing_left
	sw $t1, 12($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 1028($t0)
	sw $t1, 1036($t0)
	li $t1, LASER_COLOUR # goggle colour
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	j paint_laser
		
player_facing_left:
	sw $t1, 0($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 1024($t0)
	sw $t1, 1032($t0)
	li $t1, LASER_COLOUR # goggle colour
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	j paint_laser

paint_laser:
	# paint laser if velocity is not zero
	lb $t4, laser+4($zero)
	beqz $t4, paint_dart
	lh $t0, laser+0($zero) # x position
	lh $t2, laser+2($zero) # y position
	sh $t0, laser+6($zero) # store as previous x position
	sh $t2, laser+8($zero) # store as previous y position
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 256 into $t2
	add $t0, $t0, $t2
	addi $t0, $t0, BASE_ADDRESS # laser location in $t0
	li $t1, LASER_COLOUR
	sw $t1, 0($t0)
	sw $t1, 4($t0)

paint_dart:
	# paint dart if velocity is not zero
	lb $t5, dart+4($zero)
	beqz $t5, paint_hearts
	lh $t0, dart+0($zero) # x position
	lh $t2, dart+2($zero) # y position
	sh $t0, dart+6($zero) # store as previous x position
	sh $t2, dart+8($zero) # store as previous y position
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 256 into $t2
	add $t0, $t0, $t2
	addi $t0, $t0, BASE_ADDRESS # dart location in $t0
	li $t1, SPIKE_COLOUR
	sw $t1, 0($t0)
	sw $t1, 256($t0)
	sw $t1, 512($t0)

paint_hearts:
	# paint hearts if player is taking damage
	lb $t8, player+8($zero)
	bne $t8, 1, paint_timer
	li $t0, BASE_ADDRESS
	addi $t0, $t0, 260 # starting point
	lb $t7, player+7($zero) # health
	beqz $t7, end_screen
paint_hearts_loop:
	li $t1, SCORE_COLOUR
	sw $t1, 268($t0)
	li $t1, SPIKE_COLOUR	
	sw $t1, 4($t0)
	sw $t1, 12($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 272($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 524($t0)
	sw $t1, 528($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 1032($t0)
	addi $t0, $t0, 24
	addi $t7, $t7, -1
	bnez $t7, paint_hearts_loop
	# erase previous heart
	li $t1, BACKGROUND
	sw $t1, 268($t0)
	sw $t1, 4($t0)
	sw $t1, 12($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 272($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 524($t0)
	sw $t1, 528($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 1032($t0)
	# player not taking damage
	sb $zero, player+8($zero)	

paint_timer:

game_refresh:	
	# frame delay before looping
	li $v0, 32
	li $a0, FRAME_DELAY
	syscall
	j game_check_keypress

game_keypressed:
	lw $t8, 4($t9) 
	beq $t8, 0x61, a_pressed
	beq $t8, 0x73, s_pressed
	beq $t8, 0x64, d_pressed
	beq $t8, 0x66, f_pressed
	beq $t8, 0x6a, j_pressed
	beq $t8, 0x6c, l_pressed	
	beq $t8, 0x71, q_pressed
	beq $t8, 0x72, r_pressed
	j game_update_positions

a_pressed:
	# only left double jump if jump state is 1
	lb $t6, player+6($zero)
	bne $t6, 1, game_update_positions
left_dbl:
	li $t4, -1 # left speed
	sb $t4, player+4($zero)
	li $t5, -4 # up speed
	sb $t5, player+5($zero)
	li $t6, 2 # new jump state
	sb $t6, player+6($zero)
	li $t9, 0 # facing left
	sb $t9, player+9($zero)
	j game_update_positions

s_pressed:
	li $t9, 0 # facing left
	sb $t9, player+9($zero)
	# only move left if jump state is 0
	lb $t6, player+6($zero)
	bne $t6, 0, game_update_positions
move_left:
	lb $t4, player+4($zero)
	add $t4, $t4, -1 # left speed
	sb $t4, player+4($zero)
	li $t6, 1 # new jump state
	sb $t6, player+6($zero)
	j game_update_positions

d_pressed:
	li $t9, 1 # facing right
	sb $t9, player+9($zero)
	# only move right if jump state is 0
	lb $t6, player+6($zero)
	bne $t6, 0, game_update_positions
move_right:
	lb $t4, player+4($zero)
	add $t4, $t4, 1 # right speed
	sb $t4, player+4($zero)
	li $t6, 1 # new jump state
	sb $t6, player+6($zero)
	j game_update_positions

f_pressed:
	# only right double jump if jump state is 1
	lb $t6, player+6($zero)
	bne $t6, 1, game_update_positions
right_dbl:
	li $t4, 1 # right speed
	sb $t4, player+4($zero)
	li $t5, -4 # up speed
	sb $t5, player+5($zero)
	li $t6, 2 # new jump state
	sb $t6, player+6($zero)
	li $t9, 1 # facing right
	sb $t9, player+9($zero)
	j game_update_positions

j_pressed:
	# only jump if jump state is 0 
	lb $t6, player+6($zero)
	bne $t6, 0, game_update_positions
jump:
	li $t4, 0 # x speed
	sb $t4, player+4($zero)
	li $t5, -4 # jump speed
	sb $t5, player+5($zero)	
	li $t6, 1 # new jump state
	sb $t6, player+6($zero)
	j game_update_positions

l_pressed:
	# only shoot laser if laser velocity is zero
	lb $t4, laser+4($zero)
	bnez $t4, game_update_positions
	lh $t0, player+0($zero) # player x position
	lh $t2, player+2($zero) # player y position
	# decide whether to shoot left or right
	lb $t9, player+9($zero)
	beqz $t9, shoot_laser_left
	li $t4, -2
	addi $t0, $t0, 2
	addi $t2, $t2, 1 
	j finish_shooting_laser
shoot_laser_left:
	li $t4, -2	
	addi $t2, $t2, 1 
finish_shooting_laser:
	sh $t0, laser+0($zero) # store new laser x position
	sh $t2, laser+2($zero) # store new laser y position
	sb $t4, laser+4($zero) # store new laser x velocity	
	j game_update_positions

q_pressed:
	j end_screen

r_pressed: 
	j game

end_screen:
	jal reset_screen

	li $t1, 0xff0000
	sw $t1, 0($t0)
	sw $t1, 256($t0)

	li $v0, 10 
	syscall

