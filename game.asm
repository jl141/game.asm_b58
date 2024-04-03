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
.eqv FRAME_DELAY 40
player_stats: .space 8

.globl main_title
.text

main_title:
	# main title display
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

game_loop:
	li $t9, 0xffff0000
	lw $t8, 0($t9)
	beq $t8, 1, keypressed

game_loop_refresh:
	li $v0, 32
	li $a0, FRAME_DELAY
	syscall
	j game_loop

keypressed:
	lw $t2, 4($t9) 
	beq $t2, 0x61, a_pressed
	beq $t2, 0x71, q_pressed
	j game_loop_refresh

a_pressed:
	li $t1, 0x0000ff
	move $t4, $t0
	addi $t4, $t4, 256
	sw $t1, 0($t4)
	addi $t4, $t4, 256
	sw $t1, 0($t4)
	addi $t4, $t4, 256
	sw $t1, 0($t4)
	addi $t4, $t4, 256
	sw $t1, 0($t4)
	j game_loop_refresh

q_pressed:
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

