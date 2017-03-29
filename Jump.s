	AREA 	Jump, CODE, READONLY	; name this block of code
	ENTRY

start
	MOV r1, #0		; used to calculate which subroutine to jump to
	MOV r2, #2		; used in later subroutines for addition
	MOV r3, #3		; used in later subroutines for addition
	BL	jumps
					; r0 == 6
	B	.

jumps
	ADD	r1, r1, #1	; counter, incremented to jump from sub1 to sub3
	ADR r4, Subtab	; r4 = [Subtab]
	LDR	pc, [r4, r1, LSL #2]	; r4 is address of jump table, uses contents of r1 to then jump to a subroutine

sub0	
	; will never be reached since I r1 starts at 1 and not 0 
	MOV r0, #111
	B	jumps

sub1
	; will be reached when r1 = 1
	ADD r0, r1, r1
	B	jumps

sub2
	; will be reached when r1 = 2
	ADD r0, r1, r2
	B	jumps

sub3
	; will be reached when r1 = 3
	ADD r0, r1, r3
	BX	r14			; exit since this is the last subroutine

Subtab	DCD sub0	; entry address of sub0
		DCD sub1	; entry address of sub1
		DCD sub2	; entry address of sub2
		DCD sub3	; entry address of sub3

	END				; mark the end of this file
