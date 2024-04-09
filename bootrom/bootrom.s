.text
_vectors:
_initial_sp:
	.long	0x0
_initial_pc:
	.long	_start

.global _start
_start:

#internal ram test
	move.l #0xffffffff, %d0
	move.l #0x20000000, %a0
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
	move.l #0x40000000, %a0
	move.l %a0, %a1
	add.l #0x8000, %a1
	move.l #0xaaaaaaaa, %d0
_loop:
	move.l %d0, (%a0)+
	cmp.l %a0, %a1
	jne _loop

dead:
jmp .

