;********************************************************		
; Programmer: Francisco Duran Jimenez					*
; Date: March 14, 2017									*
; File: FranciscoDuranHW5CS2400.s & .ini				*
; Description: 11 numbers are "randomly" generated		*
;	and stored in an array, array is then bubble		*
;	sorted. Once the array has been sorted, the			*
;	number of 1' and 0's are counted from the numbers	*
;	binary versions.  r4 = 1's count & r5 = 0's count	*
;********************************************************	
	AREA	FranciscoDuranHW5CS2400, CODE, READONLY
	ENTRY

start
	LDR r9, =M			; initial seed location
	LDR r2, =array		; array location
	MOV r12, #1			; initial seed
	MOV r11, #0			; random loop counter
	STR r12, [r9]		; store seed into r9, M = 1
	BL	randLoop		; branch to random loop
	CMP	r4, #11			; z flag toggle
	BL	outer			; branch to outer "for" loop
	MOV r4, #0			; initially, r4 = outer loop counter
	MOV r5, #0			; initially, r5 = inner loop counter
	LDR r2, =array		; load the array from the beginning again
	BL	onesLoop		; branch to onesLoop for ones count
	LDR r2, =array		; load the array from the beginning again
	BL	zerosLoop		; branch to zerosLoop for zeros count
	B	.				; terminate

outer
	;for(int i = 0, i < n; i++)
	LDR		r2, =array	; load the array to r2
	CMPNE 	r4, #11		; compare r4 to ll, i < n, i < 11
	MOVNE 	r5, #0		; reset the inner loop counter
	BNE		inner		; branch to inner "for" loop
	BX		r14			; leave the loop

inner
	;for(int j=1; j < (n-1); j++)
	CMPNE	r5, #10		; compare r5 to 10, j > (n - 1), j > 10
	BNE		bubbleSort	; branch to bubbleSort
	ADDEQ	r4, r4, #1	; add one to outer loop counter
	CMP		r4, #11		; re-compare r4 again to 11
	B		outer		; branch out to outer for loop
	
onesLoop
	LDR		r0, [r2], #4	; load the first word into r0, increment 4 bytes
	CMP		r0, #0			; while word != 0
	BNE		onesCount		; branch into onesCount
	BX		r14				; leave the loop
	
onesCount
	;word = r0	word' = r1
	CMP		r0, #&0000011C	; we cmp here so we don't count 1s & 0s
	CMPNE	r0, #&00000120	; same as above, we don't count 1s & 0s
	CMPNE	r0, #0			; compare word to 0 
	SUBNE	r1, r0, #1		; word' = word - 1
	ANDNE	r0, r0, r1		; word = word AND word'
	ADDNE	r4, r4, #1		; counter++, at end holds the count of 1s
	BNE		onesCount		; branch back to count if word != 0
	B		onesLoop		; branch to loop for next word

zerosLoop
	LDR		r0, [r2], #4	; load the first word into r0, increment 4 bytes
	CMP		r0, #0			; while there is a word
	BNE		zerosCount		; branch to zerosCount
	BX		r14
	
zerosCount
	;word = r0	word' = r1
	CMP		r0, #&0000011C	; we cmp here so we don't count 1s & 0s
	CMPNE	r0, #&00000120	; same as above, we don't count 1s & 0s
	CMPNE	r0, #&FFFFFFFF	; compare word to FFFFFFFF, max # of 1s
	ADDNE	r1, r0, #1		; word' = word + 1
	ORRNE	r0, r0, r1		; word = word AND word'
	ADDNE	r5, r5, #1		; counter++, at end holds the count of 0s
	BNE		zerosCount		; branc back to count if word != FFFFFFFF
	B		zerosLoop		; branch to loop for next word

bubbleSort
	;compares and swaps
	LDR		r6, [r2], #4	; loads first word into r6
	LDR		r7, [r2]		; loads next word into r7
	
	;if(array[j-1] > array[j]) 
	;swap
	CMP		r6, r7			; r6 > r7?
	ADDLS	r5, r5, #1		; r6 < r7, add one to couter
	BLS		inner			; r6 < r7, go back to inner loop
	STRNE	r6, [r2]		; r6 > r7, store r6 into r7 position
	STRNE	r7, [r2, #-4]	; r6 > r7, store r7 into r6 position
	ADD		r5, r5, #1		; add one to inner loop counter
	BNE		inner			; go back to inner, for next cmp and swap
	BX		r14				; exit bubble sort

randLoop
	CMP r11, #11			; r11 > 11?
	ADD r11, r11, #1		; add one to counter
	BNE	random				; branch into random subroutine
	BX 	r14					; leave loop

random
	;pseudo random generator
	LDR r12, [r9], #4		; r12 = M
	LDR r8, =1664525		; r8 = 1664525
	MUL r10, r12, r8		; r10 = 1664525*M
	MOV r12, r10			; r12 = r10
	LDR r8, =1013904223		; r8 = 1013904223
	ADD r12, r12, r8		; 1664525*M+1013904223
	STR r12, [r2], #4		; stores the random word into the array
	B	randLoop			; go back into the random loop

M	DCD &00000000			; seed holder

array 	% 11 * 4			; array, 44 bytes of zeros

	END