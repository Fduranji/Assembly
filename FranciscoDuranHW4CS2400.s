;****************************************************
; Programmer: Francisco Duran Jimenez  				*
; Date: March 4, 2017			   					*
; File: FranciscoDuranHW4CS2400.s					*
; Description: IEEE floating point number to		*
;	TNS floating point number converter, and vise	*
;	versa, a comparison of the converted numbers	*
;	to the originals is also done, to check for 	*
;	accuracy. 										*
;	r0 == Original IEEE, r1 == Original TNS			*
;	r9 == Converted IEEE, r8 == Converted TNS		*
;	Comparison between r0 and r9 then r1 and r8		*
;	If both numbers are correct, r10 and r11 will	*
;	hold the values of 1, 0 if otherwise			*
;****************************************************
	AREA	FranciscoDuranHW4CS2400, CODE, READONLY
	ENTRY
	
start
	LDR r0, IEEE	; loads IEEE FP number 436B1000 into r0
	LDR r1, TNS		; loads TNS FP number 6B100107 into r1
	BL IEEEtoTNS	; subroutine to convert IEEE into TNS
					; converted number stored in r8
	CMP r1, r8		; comparing r1(original TNS) to r8(converted TNS), should be equal
	MOVEQ r10, #1	; if they equal, move 1 into r10
	MOVNE r10, #0	; if they are not equal, move 0 into r10
	BL TNStoIEEE	; subroutine to convert TNS into IEEE
					; converted number stored in r9
	CMP r0, r9		; comparing r0(original IEEE) to r9(converted IEEE), should be equal
	MOVEQ r11, #1	; if they equal, move 1 into r11
	MOVNE r11, #0 	; if they are not equal, move 0 into r11	
	B	.			; terminate

IEEEtoTNS
	;masks used for IEEE to TNS conversion
	LDR	r2, SignMask
	LDR r3, IEEEExMask
	LDR r4, IEEESigMask
	
	AND r5, r0, r2		; unpack sign bit, store in r5
	AND r6, r0, r3		; unpack exponent, store in r6
	MOV r6, r6, LSR #23	; shift the exponent right 23 bits
	SUB r6, r6, #127	; subtract the excess 127
	ADD r6, r6, #256	; add excess 256, now exponent for TNS
	AND r7, r0, r4		; unpack significand, store in r7
	MOV r7, r7, LSR #1	; gets rid of least significant bit -> 22 bits now
	MOV r7, r7, LSL #9	; shifts significand 9 bits to the right for TNS
	ORR r8, r5, r6		; pack sign and exponent
	ORR r8, r8, r7		; pack significand with sign and exponent into r8
						; r8 now holds the converted number (TNS)
	BX	r14				; return

TNStoIEEE
	;masks used for TNS to IEEE conversion
	LDR r2, SignMask
	LDR r3, TNSExMask
	LDR r4, TNSSigMask
	
	AND r5, r1, r2		; unpack sign bit, store in r5
	AND r6, r1, r3		; unpack exponent, store in r6
	SUB r6, r6, #256	; subtract excess 256
	ADD r6, r6, #127	; add excess 127, now exponent for IEEE	
	MOV r6, r6, LSL #23	; shifts exponent 23 bits to the left for IEEE
	AND r7, r1, r4		; unpack significand, store in r7
	MOV r7, r7, LSR #8	; shifts significand 8 bits to the right, 
						; loosing 1 bit precision at the LSB
	ORR r9, r5, r6		; pack sign and exponent
	ORR r9, r9, r7		; pack significand with sign and exponent into r9
						; r9 now holds the converted number (IEEE)
	BX r14				; return


IEEE	DCD	&436B1000	; IEEE floating point number. In decimal = 235.0625
						; 0|10000110|11010110001000000000000| in binary IEEE format
TNS		DCD &6B100107	; TNS floating point number. In decimal = 235.0625
						; 0|1101011000100000000000|100000111| in binary TNS format

SignMask	DCD &80000000	; Mask for sign bit, same for IEEE and TNS
IEEEExMask	DCD &7F800000	; Mask for IEEE exponent
IEEESigMask DCD &007FFFFF	; Mask for IEEE significand
TNSExMask	DCD &000001FF	; Mask for TNS exponent
TNSSigMask	DCD &7FFFFE00	; Mask for TNS significand

	END