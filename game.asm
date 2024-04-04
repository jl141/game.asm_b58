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
.eqv FLOOR_HEIGHT 62
.eqv FLOOR_COLOUR 0x888899
.eqv BACKGROUND 0x444444
.eqv BODY_COLOUR 0x22ffaa
.eqv GOGGLE_COLOUR 0xff22aa
.eqv PLATFORM_COLOUR 0xbbbbcc


# player_states:
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
player_states: .space 14

# platforms:
# 2 bytes: x position
# 2 bytes: y position
platform_1: .space 4

.globl main_title
.text

main_title:
	# main title display
	jal reset_screen
	li $t0, BASE_ADDRESS
	li $t1, 0x00ff00
	sw $t1, 0($t0)
	sw $t1, 256($t0)
	sw $t1, 512($t0)
	sw $t1, 1024($t0)
	sw $t1, 2048($t0)
	sw $t1, 4096($t0)
	sw $t1, 8192($t0)
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
	jr $ra

game:
	li $t0, BASE_ADDRESS
	li $t1, FLOOR_HEIGHT
	mul $t1, $t1, 256
	add $t0, $t0, $t1 # floor height in $t0
	li $t1, FLOOR_COLOUR # floor colour
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
	
	# initialize player and platform states
	li $t0, 30
	li $t2, 50
	sh $t0, player_states+0($zero)
	sh $t2, player_states+2($zero)
	sh $zero, player_states+4($zero)
	sb $zero, player_states+5($zero)
	sb $zero, player_states+6($zero)
	sb $zero, player_states+9($zero)
	sh $t0, player_states+10($zero)
	sh $t2, player_states+12($zero)
				
	li $t0, 10
	li $t2, 52
	sh $t0, platform_1+0($zero)
	sh $t2, platform_1+2($zero)

game_check_keypress:
	li $t9, 0xffff0000
	lw $t8, 0($t9)
	beq $t8, 1, game_keypressed
	
game_update_positions:
	# apply gravity, update player position
	lh $t0, player_states+0($zero)
	lh $t2, player_states+2($zero)
	lb $t4, player_states+4($zero)
	lb $t5, player_states+5($zero)
	addi $t5, $t5, GRAVITY
	add $t0, $t0, $t4
	add $t2, $t2, $t5
	sh $t0, player_states+0($zero)
	sh $t2, player_states+2($zero)
	sb $t5, player_states+5($zero)
	
game_check_collisions:
	# player states
	lh $t0, player_states+0($zero) # x position
	lh $t2, player_states+2($zero) # y position
	lb $t4, player_states+4($zero) # x velocity
	lb $t5, player_states+5($zero) # y velocity
	lb $t6, player_states+6($zero) # jump state

player_floor:
	# check player-floor collision
	li $t1, FLOOR_HEIGHT
	addi $t1, $t1, -5
	blt $t2, $t1, player_platform
	move $t2, $t1
	li $t4, 0
	li $t5, 0
	li $t6, 0
	sh $t2, player_states+2($zero)	
	sb $t4, player_states+4($zero)
	sb $t5, player_states+5($zero)
	sb $t6, player_states+6($zero)
	j player_left_wall

player_platform:
	# if velocity is going up, do not check for platform collision
	blt $t5, $zero, player_left_wall

player_platform_1:
	# check player-platform_1 collision
	lh $t8, platform_1+2($zero)
	addi $t8, $t8, -5
	blt $t2, $t8, player_left_wall
	lh $t9, platform_1($zero)	
	blt $t0, $t9, player_left_wall
	addi $t9, $t9, 10
	bgt $t0, $t9, player_left_wall
	move $t2, $t8
	li $t4, 0
	li $t5, 0
	li $t6, 0
	sh $t2, player_states+2($zero)	
	sb $t4, player_states+4($zero)
	sb $t5, player_states+5($zero)
	sb $t6, player_states+6($zero)

player_left_wall:
	# check player-left_wall collision
	bgt $t0, 0, player_right_wall
	li $t0, 0
	li $t4, 0
	sh $t0, player_states+0($zero)
	sb $t4, player_states+4($zero)

player_right_wall:
	# check player-right_wall collision
	blt $t0, 60, player_enemy
	li $t0, 60
	li $t4, 0
	sh $t0, player_states+0($zero)
	sb $t4, player_states+4($zero)

player_enemy:
	# check player-enemy collision
	
player_projectile:
	# check player-projectile collision

game_update_screen:
	#sw $t1, 16380($t0)

erase_player:
	# erase player
	lh $t0, player_states+10($zero) # previous x position
	lh $t2, player_states+12($zero) # previous y position
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

paint_platforms:
	# paint platform_1
	lh $t0, platform_1+0($zero) # x position	
	lh $t2, platform_1+2($zero) # y position
	li $t1, PLATFORM_COLOUR # platform colour
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

paint_player:
	# paint player
	lh $t0, player_states+0($zero) # x position
	lh $t2, player_states+2($zero) # y position
	sh $t0, player_states+10($zero) # store as previous x position
	sh $t2, player_states+12($zero) # store as previous y position
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 4 into $t2
	add $t0, $t0, $t2
	addi $t0, $t0, BASE_ADDRESS
	li $t1, BODY_COLOUR # body colour
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
	lb $t9, player_states+9($zero)
	beqz $t9, player_facing_left
	sw $t1, 12($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 1028($t0)
	sw $t1, 1036($t0)
	li $t1, GOGGLE_COLOUR # goggle colour
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	j game_refresh
		
player_facing_left:
	sw $t1, 0($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 1024($t0)
	sw $t1, 1032($t0)
	li $t1, GOGGLE_COLOUR # goggle colour
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	j game_refresh


game_refresh:	
	# frame delay before looping
	li $v0, 32
	li $a0, FRAME_DELAY
	syscall
	j game_check_keypress

game_keypressed:
	lw $t8, 4($t9) 
	beq $t8, 0x71, q_pressed
	beq $t8, 0x77, w_pressed
	beq $t8, 0x65, e_pressed
	beq $t8, 0x72, r_pressed
	beq $t8, 0x20, sp_pressed
	beq $t8, 0x6c, l_pressed
	j game_update_positions

q_pressed:
	# only left flip if jump state is 1
	lb $t6, player_states+6($zero)
	bne $t6, 1, game_update_positions
left_flip:
	li $t4, -1 # left speed
	sb $t4, player_states+4($zero)
	li $t5, -3 # up speed
	sb $t5, player_states+5($zero)
	li $t6, 2 # new jump state
	sb $t6, player_states+6($zero)
	li $t9, 0 # facing left
	sb $t9, player_states+9($zero)
	j game_update_positions

w_pressed:
	# only move left if jump state is 0
	lb $t6, player_states+6($zero)
	bne $t6, 0, game_update_positions
move_left:
	li $t4, -1 # left speed
	sb $t4, player_states+4($zero)
	li $t6, 1 # new jump state
	sb $t6, player_states+6($zero)
	li $t9, 0 # facing left
	sb $t9, player_states+9($zero)
	j game_update_positions

e_pressed:
	# only move right if jump state is 0
	lb $t6, player_states+6($zero)
	bne $t6, 0, game_update_positions
move_right:
	li $t4, 1 # right speed
	sb $t4, player_states+4($zero)
	li $t6, 1 # new jump state
	sb $t6, player_states+6($zero)
	li $t9, 1 # facing right
	sb $t9, player_states+9($zero)
	j game_update_positions

r_pressed:
	# only right flip if jump state is 1
	lb $t6, player_states+6($zero)
	bne $t6, 1, game_update_positions
right_flip:
	li $t4, 1 # right speed
	sb $t4, player_states+4($zero)
	li $t5, -3 # up speed
	sb $t5, player_states+5($zero)
	li $t6, 2 # new jump state
	sb $t6, player_states+6($zero)
	li $t9, 1 # facing right
	sb $t9, player_states+9($zero)
	j game_update_positions

sp_pressed:
	# only jump if jump state is 0 
	lb $t6, player_states+6($zero)
	bne $t6, 0, game_update_positions
jump:
	li $t5, -4 # jump speed
	sb $t5, player_states+5($zero)	
	li $t6, 1 # new jump state
	sb $t6, player_states+6($zero)
	j game_update_positions

l_pressed:
	j end_screen

end_screen:
	li $t1, 0xff0000
	sw $t1, 0($t0)
	sw $t1, 256($t0)
	sw $t1, 512($t0)
	sw $t1, 1024($t0)
	sw $t1, 2048($t0)
	sw $t1, 4096($t0)
	sw $t1, 8192($t0)
	li $v0, 10 
	syscall

