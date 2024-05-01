.text
_vectors:
_initial_sp:
	.long (0x40000000 + 0x800)
_initial_pc:
	.long _start

_configrom_addr:
	.long 0x20000000

str_tag:
	.asciz "tang68k bootrom:"
str_starting:
	.asciz "starting..."
str_draminit:
	.asciz "DRAM init.."

.balign 4
.global _start
_start:

#load required offsets from config rom
	lea	_configrom_addr, %a0

#internal ram test
	move.l #0xffffffff, %d0
	move.l #0x40000000, %a0
	move.l %a0, %a1
	add.l #0x200, %a1
_ir_loop:
	move.l %d0, (%a0)
	move.l (%a0)+, %d1
	cmp.l %d0, %d1
	bne dead
	cmp.l %a0, %a1
	bne _ir_loop
	
# framebuffer
	move.l #0x60000000, %a0
	move.l %a0, %a1
	add.l #0x10000, %a1
	move.l #0x0, %d0
_loop:
	move.l %d0, (%a0)+
	cmp.l %a0, %a1
	jne _loop

#define REG_FB_ADDR %a4	
#define REG_FONT_ADDR %a5

# setup the various pointers
# framebuffer
	move.l #0x60000000, REG_FB_ADDR
# font rom
	move.l #0x80000000, REG_FONT_ADDR

	bra _main

#define REG_FB_ADDR_CUR %a0
#define REG_FONT_ADDR_LEFT %a1
#define REG_FONT_ADDR_RIGHT %a2
#define REG_STR %a3

_drawchar:
	move.l #0x10, %d0
__xx:
	move.w #0, %d1
	move.b (REG_FONT_ADDR_LEFT)+, %d1
	move.b (REG_FONT_ADDR_RIGHT)+, %d2
	lsl.w #8, %d2
	#and.w #0xff, %d1
	or.w %d1, %d2
	move.w %d2, (REG_FB_ADDR_CUR)
	add.l #0x80, %a0
	sub #1, %d0
	cmp.l #0, %d0
	bne __xx
	rts

# in: d0 left ascii char
# in: d1 right ascii char
# out: a1 left
# out: a2 right
_setchar:
# left char
	move.l REG_FONT_ADDR, %a1
	mulu #0x10, %d0
	add.l %d0, REG_FONT_ADDR_LEFT
# right char
	move.l REG_FONT_ADDR, %a2
	mulu #0x10, %d1
	add.l %d1, REG_FONT_ADDR_RIGHT
	rts

# d0 y (row)
# d1 x (col) (Should be multiple of 2)
_setxy:
	move.l REG_FB_ADDR, REG_FB_ADDR_CUR
	mulu #(0x80 * 16), %d0
	add.l %d0, REG_FB_ADDR_CUR
	add.l %d1, REG_FB_ADDR_CUR
	rts

# REG_STR - start of string
# d0 - row
# d1 - col
_puts:
_puts_loop:
	#push row and col
	move.l %d0,-(%sp)
	move.l %d1,-(%sp)

	bsr _setxy
	clr %d0
	clr %d1
	move.b (REG_STR)+, %d0
	move.b (REG_STR)+, %d1

	# end of string in d0, get outta here
	cmp #0, %d0
	beq	_puts_exit

	move.l %d1,-(%sp)

	bsr _setchar
	bsr _drawchar

	move.l (%sp)+, %d1
	# end of string in d1, get outta here
	cmp #0, %d1
	beq	_puts_exit

	# pop row and col and move right by 2
	move.l (%sp)+, %d1
	move.l (%sp)+, %d0
	add.l #2, %d1
	bra _puts_loop

_puts_exit:
	move.l (%sp)+, %d1
	move.l (%sp)+, %d0
	rts

# internal ram is ok, framebuffer is cleared, we can now
# use the stack and do cool stuff
_main:
#if 0
	move.l #8, %d0
	move.l #2, %d1
	bsr _setxy
	move.l #'0', %d0
	move.l #'1', %d1
	bsr _setchar
	bsr _drawchar
#endif

	lea str_tag, REG_STR
	move.l #30, %d0
	move.l #2, %d1
	bsr _puts

	lea str_starting, REG_STR
	move.l #30, %d0
	move.l #20, %d1
	bsr _puts
dead:
	stop #0
	jmp .

