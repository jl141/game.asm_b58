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
.eqv GRAVITY 1
# player_states:
# 2 bytes: x position
# 2 bytes: y position
# 1 byte: x velocity
# 1 byte: y velocity
# 1 byte: jump state
# 1 byte: health state
player_states: .space 8


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

game_check_keypress:
	li $t9, 0xffff0000
	lw $t8, 0($t9)
	beq $t8, 1, game_keypressed
	
game_check_collisions:

game_update_positions:
	# update player position
	lh $t0, player_states+0($zero)
	lh $t2, player_states+2($zero)
	lb $t4, player_states+4($zero)
	lb $t5, player_states+5($zero)
	add $t0, $t0, $t4
	add $t2, $t2, $t5
	sh $t0, player_states+0($zero)
	sh $t2, player_states+2($zero)
	
game_update_screen:
	li $t1, 0xff00ff
	li $t4, BASE_ADDRESS
	sw $t1, 256($t4)
	sw $t1, 8576($t4)
	sw $t1, 8448($t4)
	sw $t1, 16380($t4)
	# paint player
	

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
	j game_check_collisions

q_pressed:
	# only left flip if jump state is 1
	lb $t6, player_states+6($zero)
	bne $t6, 1, game_check_collisions
left_flip:
	li $t4, -4 # left speed
	sb $t4, player_states+4($zero)
	li $t5, 4 # up speed
	sb $t5, player_states+5($zero)
	li $t6, 2 # new jump state
	sb $t6, player_states+6($zero)
	j game_check_collisions

w_pressed:
	li $t4, -3 # left speed
	sb $t4, player_states+4($zero)
	j game_check_collisions

e_pressed:
	li $t4, 3 # right speed
	sb $t4, player_states+4($zero)
	j game_check_collisions

r_pressed:
	# only right flip if jump state is 1
	lb $t6, player_states+6($zero)
	bne $t6, 1, game_check_collisions
right_flip:
	li $t4, 4 # right speed
	sb $t4, player_states+4($zero)
	li $t5, 4 # up speed
	sb $t5, player_states+5($zero)
	li $t6, 2 # new jump state
	sb $t6, player_states+6($zero)
	j game_check_collisions

sp_pressed:
	# only jump if jump state is 0 
	lb $t6, player_states+6($zero)
	bne $t6, 0, game_check_collisions
jump:
	li $t5, 5 # jump speed
	sb $t5, player_states+5($zero)	
	li $t6, 1 # new jump state
	sb $t6, player_states+6($zero)
	j game_check_collisions

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

