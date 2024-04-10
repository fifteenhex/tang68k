.text
_vectors:
_initial_sp:
	.long	0x0
_initial_pc:
	.long	_start

_configrom_addr:
	.long 0x20000000
	
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
	move.l #0x01010101, %d0
_loop:
	move.l %d0, (%a0)+
	cmp.l %a0, %a1
	jne _loop

dead:
jmp .

