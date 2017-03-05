;************************************************
; Programmer: Francisco Duran Jimenez  		*
; Date: February 28, 2017			*
; File: VowelCount.s & VowelCount.ini  		*
; Description: Program to count vowels and turn *
;		lowercase vowels into uppercase	*
;************************************************
	AREA 	VowelCount, CODE, READONLY	; name this block of code
	ENTRY					; mark first instruction
						; to execute
start
	LDR 	r1, =astring			
	MOV	r3, #0				; counter, r3 used because r2 would change at end
	BL	analyze				; Call subroutine analyze
	B	.	            		; terminate

analyze						; Subroutine analyze
	LDRB	r0,[r1],#1			; first value in [r1] stored in r0, incremented 1 byte
	CMPNE	r0,#0				; compare r0 and #0, at end of string?
	BNE	testChar			; Branch to testChar
	BX	r14				; Return from subroutine

testChar
	TEQ	r0,#'a'				; charAt r0 == a?
	TEQNE	r0,#'e'				; charAt r0 == e?
	TEQNE	r0,#'i'				; charAt r0 == i?
	TEQNE	r0,#'o'				; charAt r0 == o?
	TEQNE	r0,#'u'				; charAt r0 == u?
	SUBEQ	r0, r0, #&20			; converts lowercase to uppercase
	STRBEQ	r0, [r1, #-1]			; ro == M[r1 - 1], r1 does not change!
	TEQNE	r0,#'A'				; charAt r0 == A?
	TEQNE	r0,#'E'				; charAt r0 == B?
	TEQNE	r0,#'I'				; charAt r0 == C?
	TEQNE	r0,#'O'				; charAt r0 == D?
	TEQNE	r0,#'U'				; charAt r0 == F?
	ADDEQ 	r3, r3, #1			; increment counter ---> r2 = r2 + 1
	CMPEQ	r0,#0				; Have to re-compare because z flag would not change
	B		analyze
	
astring
	DCB 	"My name is Francisco Duran",&0d,&0a,0	; String to be tested
	
	ALIGN 					; ALIGN directive to ensure that the instruction is aligned
	END					; mark end of file
