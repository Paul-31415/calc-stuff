.MODULE FASTCIRCLE
FastCircle:
;FastCircle
;
;Author:  Sean McLaughlin (sigma_zk@yahoo.com)
;Date:    01/18/04 (mm/dd/yy)
;Calc:    TI-83 Plus
;Notes:   Uses SMC
;
;D = center_x
;E = center_y
;C = radius
			; REGS			STACK
	LD	A,C	;
	OR	A	;
	RET	Z	;
	RET	M	;
	LD	(_x),DE	;
	LD	B,0	; B = y
	LD	H,B	;
	LD	L,C	;
	ADD	HL,HL	;
	LD	DE,3	;
	EX	DE,HL	;
	SBC	HL,DE	;
	DI		;
_loop:			;
_x .equ $+1		;
	LD	DE,0	; DE = (xc,yc)
	LD	A,C	; A = x
	CP	B	; nc if (x <= y)
	RET	C	;
;PSet(xc + x, yc + y)	;
	LD	A,E	; A = yc
	ADD	A,B	; A = yc + y
	LD	E,A	; E = yc + y
	EX	AF,AF'	;
	LD	A,D	; A = xc
	ADD	A,C	; A = xc + x
	LD	D,A	; DE = (xc+x,yc+y)
	CALL	PSet	;
;PSet(xc + x, yc - y)	;
	LD	A,E	; A = yc + y
	SUB	B	; A = yc
	SUB	B	; A = yc - y
	LD	E,A	; DE = (xc+x,yc-y)
	CALL	PSet	;
;PSet(xc - x, yc - y)	;
	LD	A,D	; A = xc + x
	SUB	C	; A = xc
	SUB	C	; A = xc - x
	LD	D,A	; DE = (xc-x,yc-y)
	CALL	PSet	;
;PSet(xc - x, yc + y)	;
	EX	AF,AF'	;
	LD	E,A	; DE = (xc-x,yc+y)
	CALL	PSet	;
;PSet(xc + y, yc + x)	;
	LD	A,E	; A = yc + y
	SUB	B	; A = yc
	ADD	A,C	; A = yc + x
	LD	E,A	; E = yc + x
	LD	A,D	; A = xc - x
	ADD	A,C	; A = xc
	ADD	A,B	; A = xc + y
	LD	D,A	; DE = (xc+y,yc+x)
	PUSH	AF	;			[XC+Y]
	CALL	PSet	;
;PSet(xc - y, yc + x)	;
	LD	A,D	; A = xc + y
	SUB	B	; A = xc
	SUB	B	; A = xc - y
	LD	D,A	; DE = (xc-y,yc+x)
	CALL	PSet	;
;PSet(xc - y, yc - x)	;
	LD	A,E	; A = yc + x
	SUB	C	; A = yc
	SUB	C	; A = yc - x
	LD	E,A	; DE = (xc-y,yc-x)
	CALL	PSet	;
;PSet(xc + y, yc - x)	;
	POP	AF	; A = xc + y		-
	LD	D,A	; DE = (xc+y,yc-x)
	CALL	PSet	;

;if(d < 0) err += y << 2 + 6
	BIT	7,H	;
	JR	Z,_PosError
	EX	DE,HL	;
	LD	H,0	;
	LD	L,B	;
	ADD	HL,HL	;
	ADD	HL,HL
	ADD	HL,DE
	LD	DE,6
	ADD	HL,DE
	INC	B
	JP	_loop

_PosError:
;err += (y - x) << 2 + 10: y--
	LD	DE,10
	ADD	HL,DE
	DEC	D
	LD	A,B
	SUB	C
	ADD	A,A
	RL	D
	ADD	A,A
	RL	D
	LD	E,A
	ADD	HL,DE
	INC	B
	DEC	C
	JP	_loop

.MODULE PSET
_LCD_MEM .EQU $9340
_PixTable:	.DB	128,64,32,16,8,4,2,1
PSet:
; DE = (x,y)
	LD	A,E
	OR	A
	RET	M
	CP	64
	RET	NC
	LD	A,D
	OR	A
	RET	M
	CP	96
	RET	NC
	PUSH	DE
	PUSH	HL
	SLA	E
	SLA	E
	LD	D,0
	LD	H,D
	LD	L,E
	ADD	HL,HL
	ADD	HL,DE
	LD	E,A
	SRA	E
	SRA	E
	SRA	E
	ADD	HL,DE
	LD	DE,_LCD_MEM
	ADD	HL,DE
	AND	7
	EX	DE,HL
	LD	HL,_PixTable
	ADD	A,L
	LD	L,A
	ADC	A,H
	SUB	L
	LD	H,A
	LD	A,(DE)
	OR	(HL)
	LD	(DE),A
	POP	HL
	POP	DE
	RET
