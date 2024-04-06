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
.eqv FPS 20
.eqv GRAVITY 1
.eqv PLAYER_HEIGHT 5
.eqv FLOOR_HEIGHT 62
.eqv BOSS_HEIGHT 8
.eqv TIMER_LOCATION 432
.eqv SCORE_LOCATION 460
.eqv BACKGROUND 0x444444
.eqv BODY_COLOUR 0xff7700
.eqv LASER_COLOUR 0x22eecc
.eqv BOSS_COLOUR 0x22cc44
.eqv DART_COLOUR 0xff0000
.eqv FLOOR_LIGHT 0xbbbbcc
.eqv FLOOR_DARK 0x888899
.eqv SCORE_COLOUR 0xffffcc
.eqv TIMER_COLOUR 0xaa55ff
.eqv CROWN_COLOUR 0xffdd00
.eqv LASER_DMG 10
.eqv BOSS_DMG 1
.eqv MAX_TIME 141
.eqv INVINCIBILITY_FRAMES 10
debug: .asciiz "print me mmmm yea\n "
debug2: .asciiz "print me too hngg\n "

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

# boss:
# 2 bytes: x position
# 2 bytes: y position
# 1 byte: x velocity
# 1 byte: y velocity
# 1 byte: jump state
# 1 byte: health points
# 1 byte: is damaged
# 1 byte: is shooting
# 2 bytes: previous x position
# 2 bytes: previous y position
boss: .space 14

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

# counters:
# 2 bytes: frame counter
# 2 bytes: seconds remaining
# 2 bytes: high score
counters: .space 6

# storage for a return address
retadd: .space 4

.globl init
.text

init:
	# initialize high score to zero
	sh $zero, counters+4($zero)

main_title:
	jal reset_screen
	# print crown symbol
	li $t0, BASE_ADDRESS
	addi $t0, $t0, TIMER_LOCATION # starting point
	jal draw_crown
	# draw high score
	li $a0, BASE_ADDRESS
	addi $a0, $a0, SCORE_LOCATION
	lh $a1, counters+4($zero) # high score
	jal draw_score
	# title "ALIEN"
	li $t0, BASE_ADDRESS
	addi $t0, $t0, 2648
	li $t1, TIMER_COLOUR
	jal small_A
	addi $t0, $t0, 16
	jal small_L
	addi $t0, $t0, 16
	jal small_I
	addi $t0, $t0, 16
	jal small_E
	addi $t0, $t0, 16
	jal small_N
	# title "AB-58"
	li $t0, BASE_ADDRESS
	addi $t0, $t0, 4144
	# first char A
	jal A_hole
	li $t1, BODY_COLOUR
    jal draw_A
	# second char B 
	addi $t0, $t0, 32
	li $t1, BOSS_COLOUR
    jal draw_B
	# third char - 
	addi $t0, $t0, 32
    jal draw_dash
	# fourth char 5
	addi $t0, $t0, 32
	jal big_5
	# fifth char 8
	addi $t0, $t0, 32
	jal big_8
	# draw controls (A/S/D/F J/L)
	li $t0, BASE_ADDRESS
	addi $t0, $t0, 9760
	jal double_left
	jal draw_keycap
	jal small_A
	addi $t0, $t0, 32
	jal single_left
	jal draw_keycap
	jal small_S
	addi $t0, $t0, 32
	jal single_right
	jal draw_keycap
	jal small_D
	addi $t0, $t0, 32
	jal double_right
	jal draw_keycap
	jal small_F
	addi $t0, $t0, 32
	addi $t0, $t0, 16 # space
	jal jump
	jal draw_keycap
	jal small_J
	addi $t0, $t0, 32
	jal target
	jal draw_keycap
	jal small_L
	# initialize player and laser for main screen
	jal init_playser
	li $t0, 31
	li $t2, 44
	li $t6, 2
	sh $t0, player+0($zero)
	sh $t2, player+2($zero)
	sb $t6, player+6($zero)
main_title_loop:
	# check for input
	jal check_keypress
    # update positions
    jal update_playser
	# exit/start game if player reaches left/right border
	lh $t0, player+0($zero)
	blt $t0, 0, BYEBYE
	bgt $t0, 60, game_init
	# check for playser boundaries
    jal player_borders
	jal laser_borders
    # update main title screen
    jal erase_playser
	# draw exit sign
	li $t0, BASE_ADDRESS
	addi $t0, $t0, 13060
	jal door
	jal exit_arrow
	addi $t0, $t0, 220
	jal door
	jal enter_arrow
	# draw enter sign
    jal paint_playser
	# frame delay
	jal frame_delay
	j main_title_loop

init_playser:
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
	li $t0, 55
	li $t2, 1
	sh $t0, laser+0($zero)
	sh $t2, laser+2($zero)
	sb $zero, laser+4($zero)	
	sb $zero, laser+5($zero)	
	sh $t0, laser+6($zero)
	sh $t2, laser+8($zero)
	jr $ra

game_init:
	jal reset_screen
	# print 5 hearts
	li $t0, BASE_ADDRESS
	addi $t0, $t0, 260 # starting point
	li $t2, 5 # counter
init_hearts_loop:
	li $t1, SCORE_COLOUR
	sw $t1, 268($t0)
	li $t1, DART_COLOUR	
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
	# print timer symbol
	li $t0, BASE_ADDRESS
	addi $t0, $t0, TIMER_LOCATION # starting point
	li $t1, TIMER_COLOUR
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)	
	sw $t1, 256($t0)
	sw $t1, 272($t0)	
	sw $t1, 512($t0)
	sw $t1, 528($t0)
	sw $t1, 768($t0)
	sw $t1, 784($t0)
	sw $t1, 1028($t0)
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)
	li $t1, SCORE_COLOUR
	sw $t1, 260($t0)
	sw $t1, 268($t0)	
	sw $t1, 516($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	# initialize counters
	sh $zero, counters+0($zero)
	li $t2, MAX_TIME
	sh $t2, counters+2($zero)
	li $a0, BASE_ADDRESS
	addi $a0, $a0, SCORE_LOCATION
	move $a1, $t2
	jal draw_score
	# initialize playser states
	jal init_playser
	# initialize boss states
	li $t0, 56
	li $t2, 54
	li $t7, 58
	sh $t0, boss+0($zero)
	sh $t2, boss+2($zero)
	sh $zero, boss+4($zero)
	sb $zero, boss+5($zero)
	sb $zero, boss+6($zero)
	sb $t7, boss+7($zero)
	sb $zero, boss+8($zero)	
	sb $zero, boss+9($zero)
	sh $t0, boss+10($zero)
	sh $t2, boss+12($zero)
	# initialize dart states
	li $t0, 60
	li $t2, 1
	sh $t0, dart+0($zero)
	sh $t2, dart+2($zero)
	sb $zero, dart+4($zero)	
	sb $zero, dart+5($zero)	
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
	
game_loop:
	# check for input
	jal check_keypress
    # update positions
    jal game_update_positions
	# check for collisions
    jal game_check_collisions
    # update game screen
    jal game_update_screen
	# increment frame counter
	lh $t0, counters+0($zero)
	addi $t0, $t0, 1
	# check if FPS is reached
	beq $t0, FPS, second_elasped
	sh $t0, counters+0($zero)
	j game_frame_delay
second_elasped:
	lh $t2, counters+2($zero)	
	addi $t2, $t2, -1
	sh $zero, counters+0($zero)
	sh $t2, counters+2($zero)
	beqz $t2, end_screen
	jal paint_time
game_frame_delay:
	jal frame_delay
	j game_loop

# Updates positions in game
game_update_positions:
    sw $ra, retadd($zero)
game_update_playser:
    jal update_playser
boss_action:
	# boss action
	li $v0, 42
	li $a0, 0
	li $a1, 32
	syscall
	# only do action if jump state is 0
	lb $t4, boss+4($zero)
	lb $t5, boss+5($zero)
	lb $t6, boss+6($zero)	
	bne $t6, 0, boss_update_position	
	blt $a0, 1, boss_shoot
	blt $a0, 2, boss_jump
	blt $a0, 4, boss_dash
	blt $a0, 16, boss_move
boss_idle:
	li $t4, 0
	li $t5, 0
	j boss_update_position
boss_shoot:
	# only shoot dart if player location is above boss
	lh $t2, boss+2($zero)
	lh $t8, player+2($zero)
	blt $t2, $t8, boss_action
	# only shoot dart if dart velocity is zero
	lb $t5, dart+5($zero)
	bnez $t5, boss_action
	lh $t0, boss+0($zero) # boss x position
	lh $t2, boss+2($zero) # boss y position
	li $t5, -3 # dart velocity
	addi $t0, $t0, 3
	addi $t2, $t2, -1
	sh $t0, dart+0($zero) # store new dart x position
	sh $t2, dart+2($zero) # store new dart y position
	sb $t5, dart+5($zero) # store new dart y velocity	
	li $t4, 0 # boss stands still
	li $t5, 0 # boss stands still
	j boss_update_position
boss_jump:
	li $t4, 0
	li $t5, -3
	li $t6, 1
	j boss_update_position
boss_dash:
	# dash away from player x position
	lh $t0, boss+0($zero)
	lh $t8, player+0($zero)
	bgt $t0, $t8, boss_dash_right
	li $t4, -4
	li $t5, 0
	j boss_update_position	
boss_dash_right:
	li $t4, 4
	li $t5, 0
boss_move:
	# move to player previous x position
	lh $t0, boss+0($zero)
	lh $t8, player+10($zero)
	bgt $t0, $t8, boss_move_left
	li $t4, 1
	li $t5, 0
	j boss_update_position	
boss_move_left:
	li $t4, -1
	li $t5, 0
boss_update_position:
	# apply gravity, update boss position
	lh $t0, boss+0($zero)
	lh $t2, boss+2($zero)
	addi $t5, $t5, GRAVITY
	add $t0, $t0, $t4
	add $t2, $t2, $t5
	sh $t0, boss+0($zero)
	sh $t2, boss+2($zero)
	sb $t4, boss+4($zero)
	sb $t5, boss+5($zero)
	sb $t6, boss+6($zero)
dart_position:
	# update dart y position
	lh $t2, dart+2($zero)
	lb $t5, dart+5($zero)
	add $t2, $t2, $t5
	sh $t2, dart+2($zero)
slider_position:
	# update slider position then velocity
	lh $t0, slider+0($zero)
	lh $t2, slider+2($zero)
	lb $t4, slider+4($zero)
	lb $t5, slider+5($zero)
	add $t0, $t0, $t4
	add $t2, $t2, $t5
	sh $t0, slider+0($zero)
	sh $t2, slider+2($zero)
	blt $t0, 13, slider_180
	beq $t0, 24, slider_turn
	blt $t0, 38, game_update_positions_return
slider_180: 
	mul $t4, $t4, -1
	mul $t5, $t5, -1
	sb $t4, slider+4($zero)
	sb $t5, slider+5($zero)
	j game_update_positions_return
slider_turn:
	beqz $t5, slider_down
	sb $zero, slider+5($zero)
	j game_update_positions_return
slider_down:
	li $t5, 1
	sb $t5, slider+5($zero)	
game_update_positions_return:
    lw $ra, retadd($zero)
    jr $ra

# Updates positions of player and laser
update_playser:
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
    jr $ra

# Checks for collisions in game
game_check_collisions:
    sw $ra, retadd($zero)
game_player_collisions:
    # check borders
    jal player_borders
	# get player states
	lh $t0, player+0($zero) # x position
	lh $t2, player+2($zero) # y position
	lb $t4, player+4($zero) # x velocity
	lb $t5, player+5($zero) # y velocity
	lb $t6, player+6($zero) # jump state
	lb $t7, player+7($zero) # health points
    # if player on floor, skip platform check
    addi $t8, $t2, PLAYER_HEIGHT
    bge $t8, FLOOR_HEIGHT, player_boss
player_platforms:
player_platform_1:
	# check player-platform_1 collision
    # check that player below or on top of platform 
	lh $t8, platform_1+2($zero)
	addi $t8, $t8, -PLAYER_HEIGHT
	blt $t2, $t8, player_platform_2 
    # check that previous player position not below platform
	lh $t9, player+12($zero) # previous y position
    bgt $t9, $t8, player_platform_2
    # check x bounds
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
    # check that player below or on top of platform 
	lh $t8, platform_2+2($zero)
	addi $t8, $t8, -PLAYER_HEIGHT
	blt $t2, $t8, player_platform_3 
    # check that previous player position not below platform
	lh $t9, player+12($zero) # previous y position
    bgt $t9, $t8, player_platform_3
    # check x bounds
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
    # check that player below or on top of platform 
	lh $t8, platform_3+2($zero)
	addi $t8, $t8, -PLAYER_HEIGHT
	blt $t2, $t8, player_platform_4 
    # check that previous player position not below platform
	lh $t9, player+12($zero) # previous y position
    bgt $t9, $t8, player_platform_4
    # check x bounds
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
    # check that player below or on top of platform 
	lh $t8, platform_4+2($zero)
	addi $t8, $t8, -PLAYER_HEIGHT
	blt $t2, $t8, player_platform_5
    # check that previous player position not below platform
	lh $t9, player+12($zero) # previous y position
    bgt $t9, $t8, player_platform_5
    # check x bounds
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
    # check that player below or on top of platform 
	lh $t8, platform_5+2($zero)
	addi $t8, $t8, -PLAYER_HEIGHT
	blt $t2, $t8, player_slider
    # check that previous player position not below platform
	lh $t9, player+12($zero) # previous y position
    bgt $t9, $t8, player_slider
    # check x bounds
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
player_slider:
	# check player-slider collision
    # check that player below or on top of slider 
	lh $t8, slider+2($zero)
	addi $t8, $t8, -PLAYER_HEIGHT
	blt $t2, $t8, player_boss
    # check that previous player position not far below platform
	lh $t9, player+12($zero) # previous y position
    addi $t9, $t9, -1
    bgt $t9, $t8, player_boss
    # check x bounds
	lh $t9, slider+0($zero)
	addi $t9, $t9, -2
	blt $t0, $t9, player_boss # check left edge of platform
	addi $t9, $t9, 11
	bgt $t0, $t9, player_boss # check right edge of platform
	# update player states accordingly
	lb $t4, slider+4($zero)
	lb $t5, slider+5($zero)
	sh $t8, player+2($zero)	
	sb $t4, player+4($zero)
	sb $t5, player+5($zero)
	sb $zero, player+6($zero) 
player_boss:
	# if player damage state is negative, do not check for collision
	lb $t8, player+8($zero)
	bltz $t8, player_walls
	# check player-boss collision
	lh $t8, boss+0($zero) # boss x position
	addi $t8, $t8, -3
	blt $t0, $t8, player_walls # check left x bound
	addi $t8, $t8, 9	
	bgt $t0, $t8, player_walls # check right x bound	
	lh $t9, boss+2($zero) # boss y position
	addi $t9, $t9, -4
	blt $t2, $t9, player_walls # check upper y bound
	addi $t9, $t9, 11
	bgt $t2, $t9, player_walls # check lower y bound
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
	addi $t7, $t7, -BOSS_DMG # lose health
	sb $t4, player+4($zero)
	sb $t5, player+5($zero)	
	sb $t6, player+6($zero)
	sb $t7, player+7($zero)
	jal invincibility_apply
player_walls: # need to check walls again because knockback
    jal player_check_left
player_dart:
	# check player-dart collision
	lh $t8, dart+0($zero) # dart x position
	bgt $t0, $t8, dart_borders # check right x bound	
	addi $t8, $t8, -3
	blt $t0, $t8, dart_borders # check left x bound
	lh $t9, dart+2($zero) # dart y position
	addi $t9, $t9, -4
	blt $t2, $t9, dart_borders # check upper y bound
	addi $t9, $t9, 6	
	bgt $t2, $t9, dart_borders # check lower y bound
	# if player damage state is negative, only stop dart
	lb $t8, player+8($zero)
	bltz $t8, stop_dart
	# update player states accordingly
	addi $t7, $t7, -BOSS_DMG # lose health
	sb $t7, player+7($zero)
	jal invincibility_apply
	j stop_dart
dart_borders:
	# get dart states
	lh $t0, dart+0($zero) # x position
	lh $t2, dart+2($zero) # y position
	# check dart is within borders
	blt $t2, 6, stop_dart # top border
	blt $t0, 0, stop_dart # left border
	bgt $t0, 62, stop_dart # right border
	j boss_collisions
stop_dart:
	li $t0, 55
	li $t2, 1
	sh $t0, dart+0($zero)
	sh $t2, dart+2($zero)
	sb $zero, dart+4($zero)
	sb $zero, dart+5($zero)
boss_collisions:
	# get boss states
	lh $t0, boss+0($zero) # x position
	lh $t2, boss+2($zero) # y position
	lb $t4, boss+4($zero) # x velocity
	lb $t5, boss+5($zero) # y velocity
	lb $t6, boss+6($zero) # jump state
boss_floor:
	# check boss-floor collision
	li $t1, FLOOR_HEIGHT
	addi $t1, $t1, -BOSS_HEIGHT
	blt $t2, $t1, boss_platforms
	# update boss states
	move $t2, $t1
	sh $t2, boss+2($zero)	
	sb $zero, boss+4($zero)
	sb $zero, boss+5($zero)
	sb $zero, boss+6($zero)
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
	# update boss states accordingly
	sh $t8, boss+2($zero)
	sb $zero, boss+4($zero)
	sb $zero, boss+5($zero)
	sb $zero, boss+6($zero)
boss_left_wall:
	# check boss-left_wall collision
	bgt $t0, 0, boss_right_wall
	sh $zero, boss+0($zero)
	sb $zero, boss+4($zero)
boss_right_wall:
	# check boss-right_wall collision
	blt $t0, 57, boss_laser
	li $t0, 57
	sh $t0, boss+0($zero)
	sb $zero, boss+4($zero)
boss_laser:
	# check boss-laser collision
	lh $t8, laser+0($zero) # dart x position
	addi $t8, $t8, -6
	blt $t0, $t8, game_check_laser_borders # check left x bound
	addi $t8, $t8, 7	
	bgt $t0, $t8, game_check_laser_borders # check right x bound		
	lh $t9, laser+2($zero) # dart y position
	bgt $t2, $t9, game_check_laser_borders # check lower y bound
	addi $t9, $t9, -7	
	blt $t2, $t9, game_check_laser_borders # check upper y bound
	# update boss states accordingly
	lb $t7, boss+7($zero)
	addi $t7, $t7, -LASER_DMG # lose health
	li $t8, 1
	sb $t7, boss+7($zero)
	sb $t8, boss+8($zero)
	blez $t7, end_screen
	jal stop_laser
game_check_laser_borders:
    jal laser_borders
game_check_collisions_return:
    lw $ra, retadd($zero)
    jr $ra

# Checks if laser is within the borders
laser_borders:
	# get laser states
	lh $t0, laser+0($zero) # x position
	lh $t2, laser+2($zero) # y position
	# check laser is within borders
	blt $t2, 6, stop_laser # top border
	blt $t0, 0, stop_laser # left border
	bgt $t0, 62, stop_laser # right border
    jr $ra

# Stops laser
stop_laser:
	li $t0, 55
	li $t2, 1
	sh $t0, laser+0($zero)
	sh $t2, laser+2($zero)
	sb $zero, laser+4($zero)
	sb $zero, laser+5($zero)
    jr $ra

# Ensures player stays within the borders
player_borders:
 	lh $t2, player+2($zero) # player y position 
	# check player-floor collision
	li $t1, FLOOR_HEIGHT
	addi $t1, $t1, -PLAYER_HEIGHT
	bge $t2, $t1, player_floor
    j player_check_left
player_floor:
	# update player states
	move $t2, $t1
	sh $t2, player+2($zero)	
	sb $zero, player+4($zero)
	sb $zero, player+5($zero)
	sb $zero, player+6($zero)
player_check_left:
	# check player-left_wall collision
 	lh $t0, player+0($zero) # player x position 
	blt $t0, 0, player_left_wall
    j player_check_right
player_left_wall:
	sh $zero, player+0($zero)
	sb $zero, player+4($zero)
    jr $ra
player_check_right:
	# check player-right_wall collision
	bgt $t0, 60, player_right_wall
    jr $ra
player_right_wall:
	li $t0, 60
	sh $t0, player+0($zero)
	sb $zero, player+4($zero)
    jr $ra

# Updates the game screen
game_update_screen:
    sw $ra, retadd($zero)
game_erase_playser:
	jal erase_playser
erase_boss:
	# erase boss
	lh $t0, boss+10($zero) # previous x position
	lh $t2, boss+12($zero) # previous y position
	li $t1, BACKGROUND # background colour
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 256 into $t2
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
erase_dart:
	# erase dart if in playable range
	lh $t0, dart+6($zero) # previous x position	
	lh $t2, dart+8($zero) # previous y position
	blt $t2, 6, erase_slider
	li $t1, BACKGROUND
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 256 into $t2
	add $t0, $t0, $t2
	addi $t0, $t0, BASE_ADDRESS # dart location in $t0
	sw $t1, 0($t0)
	sw $t1, 256($t0)
	sw $t1, 512($t0)
erase_slider:
	# erase slider
	lh $t0, slider+6($zero) # previous x position	
	lh $t2, slider+8($zero) # previous y position
	li $t1, BACKGROUND
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 256 into $t2
	add $t0, $t0, $t2
	addi $t0, $t0, BASE_ADDRESS # slider location in $t0
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
	lh $a0, platform_1+0($zero) # x position	
	lh $a2, platform_1+2($zero) # y position
    jal paint_platform
	# paint platform_2
	lh $a0, platform_2+0($zero) # x position	
	lh $a2, platform_2+2($zero) # y position
    jal paint_platform
	# paint platform_3
	lh $a0, platform_3+0($zero) # x position	
	lh $a2, platform_3+2($zero) # y position
    jal paint_platform
	# paint platform_4
	lh $a0, platform_4+0($zero) # x position	
	lh $a2, platform_4+2($zero) # y position
    jal paint_platform
	# paint platform_5
	lh $a0, platform_5+0($zero) # x position	
	lh $a2, platform_5+2($zero) # y position
    jal paint_platform
paint_slider:
	# paint slider
	lh $a0, slider+0($zero) # x position
	lh $a2, slider+2($zero) # y position
	sh $a0, slider+6($zero) # store as previous x position
	sh $a2, slider+8($zero) # store as previous y position
    jal paint_platform
paint_boss: 
	# paint boss
	lh $t0, boss+0($zero) # x position
	lh $t2, boss+2($zero) # y position
	sh $t0, boss+10($zero) # store as previous x position
	sh $t2, boss+12($zero) # store as previous y position
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 256 into $t2
	add $t0, $t0, $t2
	addi $t0, $t0, BASE_ADDRESS
	# determine body colour
	lb $t8, boss+8($zero)
	bne $t8, 1, boss_not_damaged
	sb $zero, boss+8($zero) # not damaged for next iteration
	li $t1, LASER_COLOUR
	j paint_boss_continue
boss_not_damaged:
	li $t1, BOSS_COLOUR
paint_boss_continue:	
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
	li $t1, DART_COLOUR
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)
	sw $t1, 1040($t0)
game_paint_playser:
	jal paint_playser
paint_dart:
	# paint dart if velocity is not zero
	lb $t5, dart+5($zero)
	beqz $t5, paint_hearts
	lh $t0, dart+0($zero) # x position
	lh $t2, dart+2($zero) # y position
	sh $t0, dart+6($zero) # store as previous x position
	sh $t2, dart+8($zero) # store as previous y position
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 256 into $t2
	add $t0, $t0, $t2
	addi $t0, $t0, BASE_ADDRESS # dart location in $t0
	li $t1, DART_COLOUR
	sw $t1, 0($t0)
	sw $t1, 256($t0)
	sw $t1, 512($t0)
paint_hearts:
	lb $t8, player+8($zero) # player damage state
	# only print hearts if damage state = -invincibility frames
	li $t9, -INVINCIBILITY_FRAMES
	bne $t8, $t9, invincibility_decay
	# do not reprint hearts unless damage state = -invincibility frames
	bne $t8, $t9, game_update_screen_return
	li $t0, BASE_ADDRESS
	addi $t0, $t0, 260 # starting point
	lb $t7, player+7($zero) # player health
	beqz $t7, end_screen
paint_hearts_loop:
	li $t1, SCORE_COLOUR
	sw $t1, 268($t0)
	li $t1, DART_COLOUR	
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
invincibility_decay:
	addi $t8, $t8, 1
	# only set value if not positive
	bgtz $t8, game_update_screen_return
	sb $t8, player+8($zero)
game_update_screen_return:
    lw $ra, retadd($zero)
	jr $ra
# Applies invincibility frames to the player
invincibility_apply:
	li $t8, -INVINCIBILITY_FRAMES
	sb $t8, player+8($zero)
	jr $ra
# Paints a platform at ($a0, $a2)
paint_platform:
	li $t1, FLOOR_LIGHT
	mul $t0, $a0, 4 # x * 4 into $t0
	mul $t2, $a2, 256 # y * 256 into $t2
	add $t0, $t0, $t2
	addi $t0, $t0, BASE_ADDRESS # platform location in $t0
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
    jr $ra

# Paints the player and laser
paint_playser:
	# paint player
	lh $t0, player+0($zero) # x position
	lh $t2, player+2($zero) # y position
	sh $t0, player+10($zero) # store as previous x position
	sh $t2, player+12($zero) # store as previous y position
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 256 into $t2
	add $t0, $t0, $t2
	addi $t0, $t0, BASE_ADDRESS
	# determine body colour
	lb $t8, player+8($zero)
	li $t9, -INVINCIBILITY_FRAMES
	beqz $t8, player_not_damaged
	li $t1, DART_COLOUR
	j paint_player_continue
player_not_damaged:
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
	beqz $t9, paint_player_left
	sw $t1, 12($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 1028($t0)
	sw $t1, 1036($t0)
	li $t1, LASER_COLOUR # goggle colour
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	j laser_velocity_check	
paint_player_left:
	sw $t1, 0($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 1024($t0)
	sw $t1, 1032($t0)
	li $t1, LASER_COLOUR # goggle colour
	sw $t1, 256($t0)
	sw $t1, 260($t0)
laser_velocity_check:
	# paint laser if velocity is not zero
	lb $t4, laser+4($zero)
	bnez $t4, paint_laser
	jr $ra
paint_laser:
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
	jr $ra

# Erases player and laser
erase_playser:
	# erase player
	lh $t0, player+10($zero) # previous x position
	lh $t2, player+12($zero) # previous y position
	li $t1, BACKGROUND # background colour
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 256 into $t2
	add $t0, $t0, $t2
	addi $t0, $t0, BASE_ADDRESS # player location in $t0
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
	# erase laser if in playable range
	lh $t0, laser+6($zero) # previous x position	
	lh $t2, laser+8($zero) # previous y position
	bge $t2, 6, erase_laser
	jr $ra
erase_laser:
	li $t1, BACKGROUND
	mul $t0, $t0, 4 # x * 4 into $t0
	mul $t2, $t2, 256 # y * 256 into $t2
	add $t0, $t0, $t2
	addi $t0, $t0, BASE_ADDRESS # laser location in $t0
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	jr $ra

# Paints the timer value in the score position
paint_time:
	li $a0, BASE_ADDRESS
	addi $a0, $a0, SCORE_LOCATION
	lh $t2, counters+2($zero)
	move $a1, $t2
    sw $ra, retadd($zero)
	jal draw_score
    lw $ra, retadd($zero)
	jr $ra

# Does frame delay
frame_delay:
	li $v0, 32
	li $a0, FRAME_DELAY
	syscall
	jr $ra

# Checks for a keypress and controls the player accordingly.
check_keypress:
	li $t9, 0xffff0000
	lw $t8, 0($t9)
	beq $t8, 1, keypressed
	jr $ra
keypressed:
	lw $t8, 4($t9) 
	beq $t8, 0x61, a_pressed
	beq $t8, 0x73, s_pressed
	beq $t8, 0x64, d_pressed
	beq $t8, 0x66, f_pressed
	beq $t8, 0x6a, j_pressed
	beq $t8, 0x6c, l_pressed	
	beq $t8, 0x71, q_pressed
	beq $t8, 0x72, r_pressed
	jr $ra
a_pressed: # left double jump
	# only proceed if player jump state is 1
	lb $t6, player+6($zero)
	beq $t6, 1, left_double_jump
	jr $ra
left_double_jump:
	li $t4, -1 # left speed
	sb $t4, player+4($zero)
	li $t5, -4 # up speed
	sb $t5, player+5($zero)
	li $t6, 2 # new jump state
	sb $t6, player+6($zero)
	li $t9, 0 # face left
	sb $t9, player+9($zero)
	jr $ra
s_pressed: # move left
	li $t9, 0 # face left
	sb $t9, player+9($zero)
	# only proceed if player jump state is 0
	lb $t6, player+6($zero)
	beq $t6, 0, player_move_left
	jr $ra
player_move_left:
	lb $t4, player+4($zero) # get x velocity
	add $t4, $t4, -1 # add left speed
	sb $t4, player+4($zero)
	jr $ra
d_pressed: # move right
	li $t9, 1 # face right
	sb $t9, player+9($zero)
	# only proceed if player jump state is 0
	lb $t6, player+6($zero)
	beq $t6, 0, player_move_right
	jr $ra
player_move_right:
	lb $t4, player+4($zero) # get x velocity
	add $t4, $t4, 1 # add right speed
	sb $t4, player+4($zero)
	jr $ra
f_pressed: # right double jump
	# only proceed if player jump state is 1
	lb $t6, player+6($zero)
	beq $t6, 1, right_double_jump
	jr $ra
right_double_jump:
	li $t4, 1 # right speed
	sb $t4, player+4($zero)
	li $t5, -4 # up speed
	sb $t5, player+5($zero)
	li $t6, 2 # new jump state
	sb $t6, player+6($zero)
	li $t9, 1 # face right
	sb $t9, player+9($zero)
	jr $ra
j_pressed: # jump
	# only proceed if jump state is 0
	lb $t6, player+6($zero)
	beq $t6, 0, player_jump
	jr $ra
player_jump:
	li $t4, 0 # x speed
	sb $t4, player+4($zero)
	lb $t5, player+5($zero)	# get y velocity
	addi $t5, $t5, -4 # add jump speed
	sb $t5, player+5($zero)	
	li $t6, 1 # new jump state
	sb $t6, player+6($zero)
	jr $ra
l_pressed: # shoot laser
	# only proceed if laser velocity is zero
	lb $t4, laser+4($zero)
	beqz $t4, shoot_laser
	jr $ra
shoot_laser:
	lh $t0, player+0($zero) # player x position
	lh $t2, player+2($zero) # player y position
	# decide whether to shoot left or right
	lb $t9, player+9($zero)
	beqz $t9, shoot_laser_left
	li $t4, 2
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
	jr $ra
q_pressed:
	j BYEBYE
r_pressed:
	j main_title

# end screen where game results are shown
end_screen:
	jal reset_screen
	li $t0, BASE_ADDRESS
	addi $t0, $t0, TIMER_LOCATION # starting point
    jal draw_timer
	# draw remaining time
	lh $t2, counters+2($zero)
	li $a0, BASE_ADDRESS
	addi $a0, $a0, SCORE_LOCATION
	move $a1, $t2
	jal draw_score
    # check if time up
    lh $t2, counters+2($zero)
    beqz $t2, time_up
	# check if player won/lost
	lb $t7, player+7($zero)
	beqz $t7, defeat
victory:
	# remaining time is high score?
	lh $t2, counters+2($zero)
	lh $t4, counters+4($zero)
	bgt $t2, $t4, new_high_score
	j draw_success
new_high_score:
	sh $t2, counters+4($zero)
draw_success:
	# draw "SUCCESS"
	li $t0, BASE_ADDRESS
	addi $t0, $t0, 4116
	li $t1, BOSS_COLOUR
    jal draw_S
    addi $t0, $t0, 32
    jal draw_U
    addi $t0, $t0, 32
    jal draw_C
    addi $t0, $t0, 32
    jal draw_C
    addi $t0, $t0, 32
    jal draw_E
    addi $t0, $t0, 32
    jal draw_S
    addi $t0, $t0, 32
    jal draw_S
	# draw "RANK: "
	li $t0, BASE_ADDRESS
	addi $t0, $t0, 6692
	li $t1, FLOOR_LIGHT
    jal draw_R
    addi $t0, $t0, 32
    jal draw_A
    addi $t0, $t0, 32
    jal draw_N
    addi $t0, $t0, 32
    jal draw_K
    addi $t0, $t0, 32
    jal draw_colon
    addi $t0, $t0, 28 # space
    # draw rank (either A B C D S)
    bge $t2, 100, rank_A
    bge $t2, 80, rank_B
    bge $t2, 47, rank_C
    bgt $t2, 1, rank_D
rank_S: # exactly 1 second left !!!
    li $t1, CROWN_COLOUR 
    jal draw_S
    j finish_rank
rank_A:
	jal A_hole
	li $t1, BODY_COLOUR
    jal draw_A
    j finish_rank
rank_B:
    li $t1, BOSS_COLOUR
    jal draw_B
    j finish_rank
rank_C:
    li $t1, FLOOR_DARK
    jal draw_C
    j finish_rank
rank_D:
    li $t1, DART_COLOUR
    jal draw_D
finish_rank:
    j end_screen_loop

defeat:
	# draw "YOU DIED"
	li $t0, BASE_ADDRESS
	addi $t0, $t0, 4108
	li $t1, DART_COLOUR
    jal draw_Y
    addi $t0, $t0, 32
    jal draw_O
    addi $t0, $t0, 32
    jal draw_U
    addi $t0, $t0, 12 # space
    addi $t0, $t0, 32
    jal draw_D
    addi $t0, $t0, 32
    jal draw_I
    addi $t0, $t0, 32
    jal draw_E
    addi $t0, $t0, 32
    jal draw_D

    j end_screen_loop

time_up:
    # draw "TIME'S UP"
	li $t0, BASE_ADDRESS
	addi $t0, $t0, 4104
	li $t1, DART_COLOUR
    jal draw_T
    addi $t0, $t0, 32
    jal draw_I
    addi $t0, $t0, 32
    jal draw_M
    addi $t0, $t0, 32
    jal draw_E
    # apostrophe
    addi $t0, $t0, 32
	sw $t1, 0($t0)
	sw $t1, 256($t0)
    addi $t0, $t0, 8    
    jal draw_S
    addi $t0, $t0, 12 # space
    addi $t0, $t0, 32
    jal draw_U
    addi $t0, $t0, 32
    jal draw_P

    j end_screen_loop

end_screen_loop:
	# check for keypress
	li $t9, 0xffff0000
	lw $t8, 0($t9)
	beq $t8, 1, end_screen_keypressed
	j end_screen_frame_delay
end_screen_keypressed:
	lw $t8, 4($t9)
	beq $t8, 0x71, q_pressed
	beq $t8, 0x72, r_pressed
end_screen_frame_delay:
	jal frame_delay
	j end_screen_loop
# lots of drawing functions	from here on
door:
	li $t1, FLOOR_DARK
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 280($t0)
	sw $t1, 536($t0)
	sw $t1, 792($t0)
	sw $t1, 1048($t0)
	sw $t1, 1304($t0)
	sw $t1, 1560($t0)
	sw $t1, 1796($t0)
	sw $t1, 1800($t0)
	sw $t1, 1804($t0)
	sw $t1, 1808($t0)
	sw $t1, 1812($t0)
	sw $t1, 1816($t0)
	li $t1, SCORE_COLOUR
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 524($t0)
	sw $t1, 528($t0)
	sw $t1, 532($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 784($t0)
	sw $t1, 788($t0)
	sw $t1, 1028($t0)
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)
	sw $t1, 1040($t0)
	sw $t1, 1044($t0)
	sw $t1, 1284($t0)
	sw $t1, 1288($t0)
	sw $t1, 1292($t0)
	sw $t1, 1296($t0)
	sw $t1, 1300($t0)
	sw $t1, 1540($t0)
	sw $t1, 1544($t0)
	sw $t1, 1548($t0)
	sw $t1, 1552($t0)
	sw $t1, 1556($t0)
	jr $ra
enter_arrow:
	li $t1, BOSS_COLOUR
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 528($t0)
	sw $t1, 532($t0)
	sw $t1, 768($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 784($t0)
	sw $t1, 788($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)
	sw $t1, 1040($t0)
	sw $t1, 1044($t0)
	sw $t1, 1296($t0)
	sw $t1, 1300($t0)
	sw $t1, 1548($t0)
	sw $t1, 1552($t0)
	sw $t1, 1800($t0)
	sw $t1, 1804($t0)
	jr $ra
exit_arrow:
	li $t1, DART_COLOUR
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 768($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 784($t0)
	sw $t1, 788($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)
	sw $t1, 1040($t0)
	sw $t1, 1044($t0)
	sw $t1, 1284($t0)
	sw $t1, 1288($t0)
	sw $t1, 1544($t0)
	sw $t1, 1548($t0)
	sw $t1, 1804($t0)
	sw $t1, 1808($t0)
	jr $ra
double_left:
	addi $t0, $t0, -1796
	li $t1, SCORE_COLOUR
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 256($t0)
	sw $t1, 512($t0)
	li $t1, FLOOR_LIGHT
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 516($t0)
	sw $t1, 772($t0)
	li $t1, FLOOR_DARK
	sw $t1, 520($t0)
	sw $t1, 524($t0)
	sw $t1, 528($t0)
	sw $t1, 776($t0)
	sw $t1, 1032($t0)
	addi $t0, $t0, 1796
	jr $ra
single_left:
	addi $t0, $t0, -1792
	li $t1, BODY_COLOUR
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
	sw $t1, 0($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 1024($t0)
	sw $t1, 1032($t0)
	li $t1, LASER_COLOUR
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	addi $t0, $t0, 1792
	jr $ra
single_right:
	addi $t0, $t0, -1796
	li $t1, BODY_COLOUR
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
	sw $t1, 12($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 1028($t0)
	sw $t1, 1036($t0)
	li $t1, LASER_COLOUR
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	addi $t0, $t0, 1796
	jr $ra
double_right:
	addi $t0, $t0, -1796
	li $t1, SCORE_COLOUR
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 272($t0)
	sw $t1, 528($t0)
	li $t1, FLOOR_LIGHT
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 524($t0)
	sw $t1, 780($t0)
	li $t1, FLOOR_DARK
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 776($t0)
	sw $t1, 1032($t0)
	addi $t0, $t0, 1796
	jr $ra
jump:
	addi $t0, $t0, -1796
	li $t1, SCORE_COLOUR
	sw $t1, 8($t0)
	sw $t1, 260($t0)
	sw $t1, 268($t0)
	sw $t1, 512($t0)
	sw $t1, 528($t0)
	li $t1, FLOOR_LIGHT
	sw $t1, 264($t0)
	sw $t1, 516($t0)
	sw $t1, 524($t0)
	sw $t1, 768($t0)
	sw $t1, 784($t0)
	li $t1, FLOOR_DARK
	sw $t1, 520($t0)
	sw $t1, 772($t0)
	sw $t1, 780($t0)
	sw $t1, 1024($t0)
	sw $t1, 1040($t0)
	addi $t0, $t0, 1796
	jr $ra
target:
	addi $t0, $t0, -1796
	li $t1, LASER_COLOUR
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 256($t0)
	sw $t1, 272($t0)
	sw $t1, 512($t0)
	sw $t1, 528($t0)
	sw $t1, 768($t0)
	sw $t1, 784($t0)
	sw $t1, 1028($t0)
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)
	li $t1, SCORE_COLOUR
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 516($t0)
	sw $t1, 524($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	li $t1, BODY_COLOUR
	sw $t1, 520($t0)
	addi $t0, $t0, 1796
	jr $ra
small_J:
	sw $t1, 8($t0)
	sw $t1, 264($t0)
	sw $t1, 520($t0)
	sw $t1, 768($t0)
	sw $t1, 776($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	jr $ra
small_F:
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 256($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 768($t0)
	sw $t1, 1024($t0)
	jr $ra
small_D:
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 256($t0)
	sw $t1, 264($t0)
	sw $t1, 512($t0)
	sw $t1, 520($t0)
	sw $t1, 768($t0)
	sw $t1, 776($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	jr $ra
small_S:
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 256($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 776($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	jr $ra
small_R:
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 256($t0)
	sw $t1, 264($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 768($t0)
	sw $t1, 776($t0)
	sw $t1, 1024($t0)
	sw $t1, 1032($t0)
	jr $ra
small_Q:
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 256($t0)
	sw $t1, 264($t0)
	sw $t1, 512($t0)
	sw $t1, 520($t0)
	sw $t1, 768($t0)
	sw $t1, 772($t0)
	sw $t1, 1032($t0)
	jr $ra
draw_keycap:
	addi $t0, $t0, -264
	li $t1, FLOOR_DARK
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
	li $t1, SCORE_COLOUR
	addi $t0, $t0, 264
	jr $ra
big_8:
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
	jr $ra
big_5:
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
	jr $ra
A_hole: # fill up A hole
	li $t1, LASER_COLOUR 
	sw $t1, 520($t0)
	sw $t1, 524($t0)
	sw $t1, 528($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 784($t0)
	jr $ra
small_N:
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 256($t0)
	sw $t1, 264($t0)
	sw $t1, 512($t0)
	sw $t1, 520($t0)
	sw $t1, 768($t0)
	sw $t1, 776($t0)
	sw $t1, 1024($t0)
	sw $t1, 1032($t0)
	jr $ra
small_E:
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 256($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 768($t0)
	sw $t1, 1028($t0)
	sw $t1, 1032($t0)
	jr $ra
small_I:
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 260($t0)
	sw $t1, 516($t0)
	sw $t1, 772($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	sw $t1, 1032($t0)
	jr $ra
small_L:
	sw $t1, 0($t0)
	sw $t1, 256($t0)
	sw $t1, 512($t0)
	sw $t1, 768($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	sw $t1, 1032($t0)
	jr $ra
small_A:
	sw $t1, 4($t0)
	sw $t1, 256($t0)
	sw $t1, 264($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 768($t0)
	sw $t1, 776($t0)
	sw $t1, 1024($t0)
	sw $t1, 1032($t0)
	jr $ra
draw_crown:
	li $t1, CROWN_COLOUR
	sw $t1, 8($t0)
	sw $t1, 256($t0)
	sw $t1, 264($t0)
	sw $t1, 272($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 524($t0)
	sw $t1, 528($t0)
	sw $t1, 768($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 784($t0)
	li $t1, LASER_COLOUR
	sw $t1, 520($t0)
	jr $ra
draw_P:
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
	sw $t1, 532($t0)
	sw $t1, 536($t0)
	sw $t1, 768($t0)
	sw $t1, 772($t0)
	sw $t1, 784($t0)
	sw $t1, 788($t0)
	sw $t1, 792($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)
	sw $t1, 1040($t0)
	sw $t1, 1044($t0)
	sw $t1, 1280($t0)
	sw $t1, 1284($t0)
	sw $t1, 1536($t0)
	sw $t1, 1540($t0)
	sw $t1, 1792($t0)
    jr $ra
draw_M:
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
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
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 788($t0)
	sw $t1, 792($t0)
	sw $t1, 1024($t0)
	sw $t1, 1032($t0)
	sw $t1, 1044($t0)
	sw $t1, 1048($t0)
	sw $t1, 1280($t0)
	sw $t1, 1300($t0)
	sw $t1, 1304($t0)
	sw $t1, 1536($t0)
	sw $t1, 1556($t0)
	sw $t1, 1560($t0)
	sw $t1, 1792($t0)
	sw $t1, 1808($t0)
	sw $t1, 1812($t0)
	sw $t1, 1816($t0)
    jr $ra
draw_T:
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
	sw $t1, 524($t0)
	sw $t1, 528($t0)
	sw $t1, 532($t0)
	sw $t1, 536($t0)
	sw $t1, 780($t0)
	sw $t1, 784($t0)
	sw $t1, 792($t0)
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)
	sw $t1, 1288($t0)
	sw $t1, 1292($t0)
	sw $t1, 1540($t0)
	sw $t1, 1544($t0)
	sw $t1, 1548($t0)
	sw $t1, 1552($t0)
	sw $t1, 1796($t0)
	sw $t1, 1800($t0)
	sw $t1, 1804($t0)
	sw $t1, 1808($t0)
    jr $ra
draw_timer:
	li $t1, TIMER_COLOUR
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)	
	sw $t1, 256($t0)
	sw $t1, 272($t0)	
	sw $t1, 512($t0)
	sw $t1, 528($t0)
	sw $t1, 768($t0)
	sw $t1, 784($t0)
	sw $t1, 1028($t0)
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)
	li $t1, SCORE_COLOUR
	sw $t1, 260($t0)
	sw $t1, 268($t0)	
	sw $t1, 516($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)	
    jr $ra
reset_screen:
	li $t1, BACKGROUND
	move $t2, $zero
reset_screen_loop:
	sw $t1, BASE_ADDRESS($t2)
	addi $t2, $t2, 4
	bne $t2, 16380, reset_screen_loop
draw_floor:
	# draw floor as part of the reset
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
# Draws the score in a1 with location a0
# a0: start location
# a1: score value
draw_score:
	move $a3, $ra # save $ra in $a3
	move $t0, $a0 # start location into $t0
	li $t1, 100
	div $a1, $t1 # divide a1 by 100
	mflo $t5 # 100's digit in $t5
	mfhi $a1 # remainder in $a1
	li $t1, 10
	div $a1, $t1 # divide a1 by 10
	mflo $t6 # 10's digit in $t6
	mfhi $t7 # 1's digit in $t7
digit_100:
	jal draw_space # space for digit
	move $a0, $t5 # print $t5
	jal draw_digit
digit_10:
	addi $t0, $t0, 16 # move to next digit
	jal draw_space # space for digit
	move $a0, $t6 # print $t6	
	jal draw_digit
digit_1:
	addi $t0, $t0, 16 # move to next digit
	jal draw_space # space for digit
	move $a0, $t7 # print $t7	
	jal draw_digit
	jr $a3 # final return address
draw_space:
	li $t1, BACKGROUND
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)

	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)

	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)

	sw $t1, 768($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)

	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	sw $t1, 1032($t0)
	jr $ra
draw_digit:
	li $t1, SCORE_COLOUR
	beq $a0, 1, draw_1
	beq $a0, 2, draw_2
	beq $a0, 3, draw_3
	beq $a0, 4, draw_4
	beq $a0, 5, draw_5
	beq $a0, 6, draw_6
	beq $a0, 7, draw_7
	beq $a0, 8, draw_8
	beq $a0, 9, draw_9
draw_0:
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 256($t0)
	sw $t1, 264($t0)
	sw $t1, 512($t0)
	sw $t1, 520($t0)
	sw $t1, 768($t0)
	sw $t1, 776($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	jr $ra
draw_1:
	sw $t1, 4($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 516($t0)
	sw $t1, 772($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	sw $t1, 1032($t0)
	jr $ra
draw_2:
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 264($t0)
	sw $t1, 516($t0)
	sw $t1, 768($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	sw $t1, 1032($t0)
	jr $ra
draw_3:
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 264($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 776($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	jr $ra
draw_4:
	sw $t1, 0($t0)
	sw $t1, 8($t0)
	sw $t1, 256($t0)
	sw $t1, 264($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 776($t0)
	sw $t1, 1032($t0)
	jr $ra
draw_5:
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 256($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 776($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	jr $ra
draw_6:
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 256($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 768($t0)
	sw $t1, 776($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	jr $ra
draw_7:
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 264($t0)
	sw $t1, 516($t0)
	sw $t1, 772($t0)
	sw $t1, 1024($t0)
	jr $ra
draw_8:
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 256($t0)
	sw $t1, 264($t0)
	sw $t1, 516($t0)
	sw $t1, 768($t0)
	sw $t1, 776($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	jr $ra
draw_9:
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 256($t0)
	sw $t1, 264($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 776($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	jr $ra
draw_colon:
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 1540($t0)
	sw $t1, 1544($t0)
	sw $t1, 1796($t0)
	sw $t1, 1800($t0)
    jr $ra
draw_K:
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 24($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 524($t0)
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
	sw $t1, 1280($t0)
	sw $t1, 1284($t0)
	sw $t1, 1292($t0)
	sw $t1, 1296($t0)
	sw $t1, 1304($t0)
	sw $t1, 1536($t0)
	sw $t1, 1540($t0)
	sw $t1, 1552($t0)
	sw $t1, 1556($t0)
	sw $t1, 1560($t0)
	sw $t1, 1792($t0)
	sw $t1, 1812($t0)
	sw $t1, 1816($t0)
    jr $ra
draw_N:
	sw $t1, 4($t0)
	sw $t1, 24($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 524($t0)
	sw $t1, 532($t0)
	sw $t1, 536($t0)
	sw $t1, 768($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 788($t0)
	sw $t1, 792($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	sw $t1, 1036($t0)
	sw $t1, 1040($t0)
	sw $t1, 1044($t0)
	sw $t1, 1048($t0)
	sw $t1, 1280($t0)
	sw $t1, 1284($t0)
	sw $t1, 1292($t0)
	sw $t1, 1296($t0)
	sw $t1, 1300($t0)
	sw $t1, 1304($t0)
	sw $t1, 1536($t0)
	sw $t1, 1540($t0)
	sw $t1, 1552($t0)
	sw $t1, 1556($t0)
	sw $t1, 1560($t0)
	sw $t1, 1792($t0)
	sw $t1, 1812($t0)
    jr $ra
draw_dash:
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 784($t0)
	sw $t1, 788($t0)
	sw $t1, 1028($t0)
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)
	sw $t1, 1040($t0)
    jr $ra
draw_B:
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
    jr $ra
draw_A:
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
	sw $t1, 532($t0)
	sw $t1, 768($t0)
	sw $t1, 772($t0)
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
    jr $ra
draw_C:
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
	sw $t1, 536($t0)
	sw $t1, 768($t0)
	sw $t1, 772($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	sw $t1, 1048($t0)
	sw $t1, 1280($t0)
	sw $t1, 1284($t0)
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
    jr $ra
draw_S:
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
	sw $t1, 536($t0)
	sw $t1, 768($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 1036($t0)
	sw $t1, 1040($t0)
	sw $t1, 1044($t0)
	sw $t1, 1048($t0)
	sw $t1, 1280($t0)
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
    jr $ra
draw_R:
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 528($t0)
	sw $t1, 532($t0)
	sw $t1, 536($t0)
	sw $t1, 768($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 784($t0)
	sw $t1, 788($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)
	sw $t1, 1040($t0)
	sw $t1, 1280($t0)
	sw $t1, 1284($t0)
	sw $t1, 1292($t0)
	sw $t1, 1296($t0)
	sw $t1, 1300($t0)
	sw $t1, 1536($t0)
	sw $t1, 1540($t0)
	sw $t1, 1552($t0)
	sw $t1, 1556($t0)
	sw $t1, 1560($t0)
	sw $t1, 1792($t0)
	sw $t1, 1812($t0)
	sw $t1, 1816($t0)
    jr $ra



















	# space
	addi $t0, $t0, 12

    j BYEBYE

draw_Y:
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 528($t0)
	sw $t1, 532($t0)
	sw $t1, 536($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 784($t0)
	sw $t1, 788($t0)
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)
	sw $t1, 1040($t0)
	sw $t1, 1288($t0)
	sw $t1, 1292($t0)
	sw $t1, 1296($t0)
	sw $t1, 1540($t0)
	sw $t1, 1544($t0)
	sw $t1, 1548($t0)
	sw $t1, 1792($t0)
	sw $t1, 1796($t0)
	sw $t1, 1800($t0)
    jr $ra
draw_O:
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
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 536($t0)
	sw $t1, 768($t0)
	sw $t1, 772($t0)
	sw $t1, 788($t0)
	sw $t1, 792($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	sw $t1, 1044($t0)
	sw $t1, 1048($t0)
	sw $t1, 1280($t0)
	sw $t1, 1296($t0)
	sw $t1, 1300($t0)
	sw $t1, 1304($t0)
	sw $t1, 1536($t0)
	sw $t1, 1540($t0)
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
    jr $ra
draw_U:
	sw $t1, 0($t0)
	sw $t1, 24($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 276($t0)
	sw $t1, 280($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 532($t0)
	sw $t1, 536($t0)
	sw $t1, 768($t0)
	sw $t1, 772($t0)
	sw $t1, 788($t0)
	sw $t1, 792($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	sw $t1, 1040($t0)
	sw $t1, 1044($t0)
	sw $t1, 1048($t0)
	sw $t1, 1280($t0)
	sw $t1, 1284($t0)
	sw $t1, 1296($t0)
	sw $t1, 1300($t0)
	sw $t1, 1304($t0)
	sw $t1, 1536($t0)
	sw $t1, 1540($t0)
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
    jr $ra
draw_D:
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 532($t0)
	sw $t1, 536($t0)
	sw $t1, 768($t0)
	sw $t1, 772($t0)
	sw $t1, 788($t0)
	sw $t1, 792($t0)
	sw $t1, 1024($t0)
	sw $t1, 1044($t0)
	sw $t1, 1048($t0)
	sw $t1, 1280($t0)
	sw $t1, 1296($t0)
	sw $t1, 1300($t0)
	sw $t1, 1304($t0)
	sw $t1, 1536($t0)
	sw $t1, 1544($t0)
	sw $t1, 1548($t0)
	sw $t1, 1552($t0)
	sw $t1, 1556($t0)
	sw $t1, 1792($t0)
	sw $t1, 1796($t0)
	sw $t1, 1800($t0)
	sw $t1, 1804($t0)
    jr $ra
draw_I:
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 272($t0)
	sw $t1, 276($t0)
	sw $t1, 524($t0)
	sw $t1, 528($t0)
	sw $t1, 780($t0)
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)
	sw $t1, 1284($t0)
	sw $t1, 1288($t0)
	sw $t1, 1292($t0)
	sw $t1, 1536($t0)
	sw $t1, 1540($t0)
	sw $t1, 1544($t0)
	sw $t1, 1548($t0)
	sw $t1, 1552($t0)
	sw $t1, 1792($t0)
	sw $t1, 1796($t0)
	sw $t1, 1800($t0)
	sw $t1, 1804($t0)
	sw $t1, 1808($t0)
	sw $t1, 1812($t0)
    jr $ra
draw_E:
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 268($t0)
	sw $t1, 280($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 772($t0)
	sw $t1, 776($t0)
	sw $t1, 780($t0)
	sw $t1, 1028($t0)
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)
	sw $t1, 1040($t0)
	sw $t1, 1280($t0)
	sw $t1, 1284($t0)
	sw $t1, 1288($t0)
	sw $t1, 1536($t0)
	sw $t1, 1540($t0)
	sw $t1, 1544($t0)
	sw $t1, 1548($t0)
	sw $t1, 1560($t0)
	sw $t1, 1796($t0)
	sw $t1, 1800($t0)
	sw $t1, 1804($t0)
	sw $t1, 1808($t0)
	sw $t1, 1812($t0)
	sw $t1, 1816($t0)
    jr $ra

BYEBYE:
	li $v0, 10 
	syscall

# :shushing_face: :deaf_man:
