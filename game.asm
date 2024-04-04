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
.eqv BLACK 0x00000000
.eqv FRAME_DELAY 40
.eqv GRAVITY -1
.eqv FLOOR 60

# player_states:
# 2 bytes: x position
# 2 bytes: y position
# 1 byte: x velocity
# 1 byte: y velocity
# 1 byte: jump state
# 1 byte: health state
player_states: .space 8

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
	li $t1, BLACK
	move $t2, $zero
reset_screen_loop:
	sw $t1, BASE_ADDRESS($t2)
	addi $t2, $t2, 4
	bne $t2, 16380, reset_screen_loop
	jr $ra

game:
	li $t0, BASE_ADDRESS
	li $t1, 0x00aaff
	sw $t1, 0($t0)
	sw $t1, 256($t0)
	sw $t1, 512($t0)
	sw $t1, 1024($t0)
	sw $t1, 2048($t0)
	sw $t1, 4096($t0)
	sw $t1, 8192($t0)
	
	# initialize player and platform states
	li $t0, 30
	li $t2, 50
	sh $t0, player_states+0($zero)
	sh $t2, player_states+2($zero)
	sh $zero, player_states+4($zero)
	sb $zero, player_states+5($zero)
	sb $zero, player_states+6($zero)	
				
	li $t0, 10
	li $t2, 60
	li $t4, 10
	sh $t0, platform_1+0($zero)
	sh $t2, platform_1+2($zero)
	sb $t4, platform_1+4($zero)	


game_check_keypress:
	li $t9, 0xffff0000
	lw $t8, 0($t9)
	beq $t8, 1, game_keypressed
	
game_update_positions:
	# apply gravity update player position
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

player_bottom_check:
	# check player-floor collision
	blt $t2, FLOOR, player_wall
	li $t2, 60
	j player_bottom_move
	
	# check player-platform_1 collision
	lh $t8, platform_1+2($zero)
	blt $t2, $t8, player_wall
	lh $t7, platform_1($zero)	
	blt $t0, $t7, player_wall
	addi $t7, $t7, 10
	bgt $t0, $t7, player_wall
	move $t2, $t8
	j player_bottom_move	
	
player_bottom_move:
	li $t5, 0
	li $t6, 0
	sh $t2, player_states+2($zero)	
	sb $t5, player_states+5($zero)
	sb $t6, player_states+6($zero)
	
player_upper_check:


player_wall:
	# check player-wall collision
	
player_enemy:
	# check player-enemy collision
	
player_projectile:
	# check player-projectile collision

game_update_screen:
	li $t0, BASE_ADDRESS
	li $t1, 0xff00ff
	sw $t1, 256($t0)
	sw $t1, 8576($t0)
	sw $t1, 8448($t0)
	sw $t1, 16380($t0)
	
	# paint player
	lh $t0, player_states+0($zero) # x position
	lh $t2, player_states+2($zero) # y position
	li $t1, 0x6699ff # colour
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 4 into $t2
	add $t3, $t0, $t2
	addi $t4, $t3, BASE_ADDRESS
	sw $t1, 0($t4)
	sw $t1, 4($t4)
	sw $t1, 8($t4)
	sw $t1, 256($t4)
	sw $t1, 260($t4)
	sw $t1, 264($t4)
	sw $t1, 512($t4)
	sw $t1, 516($t4)
	sw $t1, 520($t4)
	
	# paint platform_1
	lh $t7, platform_1+0($zero) # x position	
	lh $t8, platform_1+2($zero) # y position
	li $t1, 0x885522 # colour
	mul $a0, $a0, 4 # x * 4 into $t2
	move $t2, $a0
	mul $a2, $a2, 256 # y * 4 into $t3
	move $t3, $a2
	add $t4, $t2, $t3
	addi $t4, $t4, BASE_ADDRESS
	sw $t1, 0($t4)
	sw $t1, 4($t4)
	sw $t1, 8($t4)
	sw $t1, 256($t4)
	sw $t1, 260($t4)
	
	
	

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
	li $t4, -2 # left speed
	sb $t4, player_states+4($zero)
	li $t5, 2 # up speed
	sb $t5, player_states+5($zero)
	li $t6, 2 # new jump state
	sb $t6, player_states+6($zero)
	j game_update_positions

w_pressed:
	li $t4, -2 # left speed
	sb $t4, player_states+4($zero)
	j game_update_positions

e_pressed:
	li $t4, 2 # right speed
	sb $t4, player_states+4($zero)
	j game_update_positions

r_pressed:
	# only right flip if jump state is 1
	lb $t6, player_states+6($zero)
	bne $t6, 1, game_update_positions
right_flip:
	li $t4, 2 # right speed
	sb $t4, player_states+4($zero)
	li $t5, 2 # up speed
	sb $t5, player_states+5($zero)
	li $t6, 2 # new jump state
	sb $t6, player_states+6($zero)
	j game_update_positions

sp_pressed:
	# only jump if jump state is 0 
	lb $t6, player_states+6($zero)
	bne $t6, 0, game_update_positions
jump:
	li $t5, 3 # jump speed
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

