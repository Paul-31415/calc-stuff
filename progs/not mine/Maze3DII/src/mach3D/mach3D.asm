;Mach3D - a fast 3D raycasting engine for z80-based calculators
;Copyright (C) 2006  Kevin Harness <deep42thought42@yahoo.com>
;
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
;

; Though not mandated by the license, the author would appreciate
; notification of any projects derived from this project.

///////////////////////////////////////////////////////////////
// To the reader:
//
// This document was created using 8-column tabs.
//

///////////////////////////////////////////////////////////////
// Preprocessor/Assembler directives
//

option "prefix" "mach3DXC"
option "anonprefix" "mach3DXA"
option speed

Mach3D:	.MODULE	M_Mach3D

///////////////////////////////////////////////////////////////
// Definitions
//

#define INLINEVAR(name) name = $+1
#define INLINEFP(name) name = $+1\name.LO = $+1\name.HI = $+2
#define ALIGN256  \ .echo ($+$00FF)&$FF00 - $\ .echo " bytes wasted on alignment\n" \$=($+$00FF)&$FF00

#ifdef TI83P

#define ti_rMov9ToOP1 rst 20h
ti_ProtProgObj		= 6
ti_CreateProtProg	= $4E6D
ti_ChkFindSym		= $42F1
ti_DelVar		= $4351
ti_EnoughMem		= $42FD

#endif

#define CLIP_ANG_LOWH	$08
#define CLIP_ANG_HIGHV	($100 - CLIP_ANG_LOWH)

#define AAMIN $80-((AAVAL)/2)
#define AAMAX (AAMIN)+(AAVAL)
#define AAMASK (AAMIN)^(AAMAX)

#define MAPBUFFER_SIZE $0400
#ifdef MACH3D_HBUFFER
#define HBUFFER_SIZE FOVPIX
#else
#define HBUFFER_SIZE 0
#endif

#define TEMPSIZE $FF+MAPBUFFER_SIZE+HBUFFER_SIZE

///////////////////////////////////////////////////////////////
// Globals
//

_SCount:	.db	0	;doesn't inline well, never directly read
_MemName	.db	ti_ProtProgObj,"MACHMEM",0

///////////////////////////////////////////////////////////////
// Mach3DClose          Uninitializes the Mach3D engine
// inputs:              none
// outputs:             none
// destroys:            all
// notes:               enables interrupts
//

Mach3DClose:
	ei
_CloseNoDelete
	ret	;the following code must only run if Init succeeds
	ld	a,$C9	;RET
	ld	(_CloseNoDelete),a
	;free temp memory
	ld	hl,_MemName
	ti_rMov9ToOP1
	BCAL	ti_ChkFindSym
	ret	c	;file not found.. error but what can we do?
	BCAL	ti_DelVar
	ret

///////////////////////////////////////////////////////////////
// Mach3DInit		Initializes the Mach3D engine
// inputs:		none
// outputs:		carry set on error
// destroys:            all
//

Mach3DInit:
option size
	;is there enough memory?
	ld	hl,TEMPSIZE+$80
	BCAL	ti_EnoughMem
	ret	c	;not enough memory
	;is name taken?
	ld	hl,_MemName
	ti_rMov9ToOP1
	BCAL	ti_ChkFindSym
	ccf
	ret	c	;if the temp file was found, it's an error
	ld	hl,TEMPSIZE+2
	BCAL	ti_CreateProtProg
	inc	de
	inc	de
	;de points to data area
	;fill memory with $FF (saves cycles when map search overflows)
	push	de
	ld	h,d
	ld	l,e
	inc	de
	ld	(hl),$FF
	ld	bc,TEMPSIZE-2 -1
	ldir
	pop	de
	;align256
	ld	hl,$00FF
	add	hl,de
	ld	a,h
	ld	(Mach3DMapBuffer),a
#ifdef MACH3D_HBUFFER
	add	a,MAPBUFFER_SIZE/256
	ld	(_HBuffer),a
#endif	// MACH3D_HBUFFER
	ld	a,AAMIN
	ld	(_aaOffset),a
	di		;we need speed and shadow registers
	xor	a	;clear carry, a := NOP
	ld	(_CloseNoDelete),a	;Allow deletion of MACHMEM
	ret

///////////////////////////////////////////////////////////////
// Mach3DLoadMap	Loads a map into Mach3D's buffers
// inputs:		hl = address of new 16x16 map
//

Mach3DLoadMap:
option size
	;copy map to Q1
	ld	bc,$0100
	ld	a,(Mach3DMapBuffer)
	ld	d,a
	ld	e,c	;e=c=0
	;hl = src, de = &(Q1), bc=256
	ldir
	ld	(_LoadMapSavSP),sp	;we can use SP as a general register
	;bc == 0
	;de == &(Q2)
	
	;for(1..16) {
	;	for(1..16) {
	;		src += 15;
	;		*(dest++) = *(src++);
	;	}
	;	src += (-257)
	;}

	;repeat 3x
	ld	b,6	;b gets dec'd from both bc-- and djnz
	do
		;de == ptr to next quadrant
		// hl := ptr to prev quadrant
		ld	hl,-256
		add	hl,de
		do
			ld	sp,15
			do
				add	hl,sp	;src += 15
				ldi		;*(dst++) = *(src++), bc--;
				ld	a,c
				and	$0F
				again	nz
				ld	sp,-257
				add	hl,sp
				or	c	;a=0|c
				2 again	nz
			enddo
		enddo
	loop djnz
INLINEVAR(_LoadMapSavSP)
	ld	sp,0
	ret

///////////////////////////////////////////////////////////////
// Mach3DRender         Renders walls to buffer
// inputs:              (Mach3D_CX),(Mach3D_CY) = Camera map location
//                      (Mach3D_CA) = Camera angle, clockwise from "East"
//


Mach3DRender:
option speed

#ifdef MACH3D_DARK_SKY
INLINEVAR(_DarkSky0x40)
	ld	a,(7-(XOFFSET&7))*8 + $86	;res 7,(hl)
#else
	ld	a,(7-(XOFFSET&7))*8 + $C6	;set 7,(hl)
#endif
	ld	(_smDrawSet0),a
	ld	(_smDrawSet1),a

	// update antialiasing factor
_TasmHatesMacrosFOVPIX .equ FOVPIX
#if (~_TasmHatesMacrosFOVPIX)&1
	ld	a,(_aaOffset)
	xor	AAMASK
	ld	(_aaOffset),a
#endif

	// buffer already cleared by last render
	ld	hl,gbuf + (8 * (XOFFSET&-8))
	ld	(_grLoc),hl
	// zero any 8-bit vars here
#ifdef MACH3D_HBUFFER
	xor	a
	ld	(_hbufLoc),a
#endif


	ld	a,FOVPIX
	ld	(_SCount),a
INLINEVAR(Mach3D_CA)
	ld	hl,0
	ld	de,0-(FOVANG/2)	// half screen
	add	hl,de
	// prepare 'normalized' angle for 8 bit lookups
	ld	a,l
	ld	(_NormSA),a
	// check which quadrant, set appropriate map
	ld	a,h
	skip
_RenderNewQuad:
INLINEVAR(_CA.HI)
		ld	a,0
		inc	a
	endskip
	ld	(_CA.HI),a
	ld	e,a		;save for later
	and	3
INLINEVAR(Mach3DMapBuffer)
	add	a,0
	ld	(_pMapH),a
	ld	(_pMapV),a
	;setup _CX and _CY
	ld	a,e
INLINEFP(Mach3D_CX)
	ld	bc,0
INLINEFP(Mach3D_CY)
	ld	de,0
	;make CX and CY odd
	set	0,c
	set	0,e
	rrca
#define MAP_WIDTH_FP $0FFE
	if	c
		rrca
		if	c	;11 = Q4
			ld	hl,MAP_WIDTH_FP+1	;+1 to offset -carry
			sbc	hl,de
			ld	(_CX),hl	;_CX = 15.99 - Y
			ld	(_CY),bc	;_CY = X
			jp	@F
		endif		;01 = Q2
		ld	hl,MAP_WIDTH_FP
		sbc	hl,bc
		ld	(_CY),hl
		ld	(_CX),de
	else
		rrca
		if	c	;10 = Q3
			ld	hl,MAP_WIDTH_FP+1	;+1 to offset -carry
			sbc	hl,bc
			ld	(_CX),hl	;_CX = 15.99 - X
			ld	hl,MAP_WIDTH_FP
			sbc	hl,de	;c should be 0
			ld	(_CY),hl	;_CY = 15.99 - Y
			jp	@F
		endif		;00 = Q1
		ld	(_CX),bc		;_CX = X
		ld	(_CY),de		;_CY = Y
	endif
@@:
	do	// for each column
		;max vertical dist
		ld	a,16
		ld	(_HCount),a

_RenderV:
		// find verticals
;deltaX = 1
;deltaY = tan(NormSA)
;searchX = int(CX+$00.FF)
;searchY = CY + deltaY * -(CX & 0x00FF)
;searchAddress = addr.y.x.frac
;delta = Y.X.frac
;	if(*searchAddress) break;
;	searchAddress += delta
;???
;searchDist = (searchY-CY)/cos(0x40-SearchAngle)
;maxiter = 16-X

;deltaY = tan(NormSA)
INLINEVAR(_NormSA)
		ld	a,0
		cp	CLIP_ANG_HIGHV
		far jmp	a>=n,_RenderH
		ld	l,a
		ld	h,tblTan>>8
		ld	c,(hl)
		inc	h
		ld	b,(hl)
		ld	a,c
		ld	(_RenderV_dY),a
		ld	a,b
		rlca\	rlca\	rlca\	rlca
		ld	e,a
;deltaX = 1
		inc	e
;searchY = CY + deltaY * -(CX & 0x00FF)
		ld	a,(_CX.LO)
		neg
		call	_MultBCA		
		;add CY to hl
INLINEFP(_CY)
		ld	bc,0
		add	hl,bc
		;hl == SY
		;hla := MMMMMMMM YYYYXXXX YYYYYYYY
		ld	c,l
		ld	a,h
		;if we're at map's edge and a steep angle, this can overflow
		cp	$10
		near jmp a>=n, _RenderH
		rlca\	rlca\	rlca\	rlca
		ld	l,a
		xor	a
		ld	d,a
		ex	af,af'
		
		;ld	a,(_CX.LO)	;we've ensured that CX.LO is never even, thus never 0
		;add	a,$FF
		ld	a,(_CX.HI)
		inc	a
		;adc	a,0
		
		or	l
		ld	l,a
		ld	a,c
INLINEVAR(_pMapV)
		ld	h,0
		;bc  = 00000000 00010000
		ld	bc,$0010
		;de  == 00000000 yyyy0001 (yyyy=dY.hi)
		;avg = ? cyc
		
		;registers:
		;a = y's fractional part
		;a' = 0 (for comparison purposes)
		;hl = map pointer
		;de = integer part of X,Y deltas
		;bc = 1Y, for when fractional Y overflows
		
		do
			ex	af,af'	;4
			or	(hl)	;7
			near break nz	;7 - 12
			ex	af,af'	;4
			add	hl,de	;11
INLINEVAR(_RenderV_dY)
			add	a,0	;7
			near again nc	;12/7
			add	hl,bc	;11
		far loop		;10
		// a=tex num, a' = column
		ld	(_TexNum),a

		// did we overflow into the next page?
		ld	a,(_pMapV)
		cp	h
		jr	nz, _RenderH
		
		ex	af,af'
		ld	(_TexCol),a
		// unpack and store dY for comparision
		ld	a,l
		rrca\	rrca\	rrca\	rrca
		and	$0F
		ld	d,a
		;d == SY.HI
		// store dX for future reference
		ld	a,l
		and	$0F
		ld	h,a
		xor	a
		ld	l,a
INLINEFP(_CX)
		ld	bc,0
		sbc	hl,bc
		ld	(_dX),hl
		;d==SY.HI
		ld	a,(_CY.HI)
		neg
		add	a,d
		jp	z,_RenderGotDX
		ld	(_HCount),a
_RenderH:
		// Horizontal intersection
;deltaX := tan(-NormSA)
;deltaY := 1
;searchX := CX + deltaX * -(CY & 0x00FF)
;searchY := int(CY+$00.FF)
;searchAddress := addr.y.x.frac
;delta := 0.dY.dX.frac
;	if(*searchAddress) break;
;	searchAddress += delta
;dY := (searchY-CY)
;deltaX	= bc
;deltaY	= code
;delta	= de,c
;searaddr	= hl,a

;deltaX := tan(90-SearchAngle)
		ld	a,(_NormSA)
		cp	CLIP_ANG_LOWH
		far jmp	a<n,_RenderGotDX	// if too far
		neg
		ld	l,a
		ld	h,tblTan>>8
		ld	c,(hl)
		inc	h
		ld	b,(hl)
		ld	a,b
;deltaY := 1
		add	a,%00010000	// dy = 1
		ld	e,a
		ld	d,c
		// delta == 0.e.d
;searchX[4.8] := CX + deltaX[8.8] * (-CY.LO)[0.8]
		;a = -CY.LO
		ld	a,(_CY.LO)
		neg
		;preserve: de
		call	_MultBCA

		;add CX to hl
		ld	bc,(_CX)
		add	hl,bc
;searchY := int(CY+$00.FF)
		;ld	a,(_CY.LO)	;we've ensured that CY.LO is never even, thus never 0
		;add	a,$FF
		ld	a,(_CY.HI)
		inc	a
		;adc	a,0
;searchAddress := addr.y.x.frac hla[8.4.4.8]
		;hl	= SX[8.8]
		;a	= SY[8.0]
		rlca\	rlca\	rlca\	rlca
		add	a,h
		ld	h,l
		ld	l,a
		xor	a
		ld	c,d	;c := low byte of deltaX
		ld	d,a	;d := 0
		ex	af,af'
		ld	a,h
INLINEVAR(_pMapH)
		ld	h,0
		;hla == MMMMMMMM YYYYXXXX XXXXXXXX
;delta := dY.dX.frac
		;already done above
		;dec = 00000000 0001xxxx xxxxxxxx
;limit distance
INLINEVAR(_HCount)
		ld	b,16
		;loop total=54
		do
			ex	af,af'
			or	(hl)
			jr	nz,@F
			ex	af,af'
			add	a,c
			adc	hl,de
		loop djnz
		jp	_RenderGotDX
@@:
		// Unquestionably horizontal intersection
		ld	(_TexNum),a
		// calc dY
		ld	a,l
		rlca\	rlca\	rlca\	rlca
		and	$0F
		ld	h,a
		xor	a
		ld	l,a
		ld	de,(_CY)
		sbc	hl,de
		;hl == dY
		// horizontal intersection
		// restore dY
		;a' == column
		ex	af,af'
		cpl
		ld	(_TexCol),a
		// now find column height
;WallHeight = sin(SearchAngle)/(searchY-CY)
		;hl == (SearchY-CY)[8.8]
		ld	a,(_NormSA)
		skip

		// vertical intersection
_RenderGotDX:
INLINEVAR(_dX)
		ld	hl,0
		// now find column height
;WallHeight = cos(SearchAngle)/(searchX-CX)
		;hl == (SearchX-CX)[8.8]
		ld	a,(_NormSA)
		cpl

		endskip
#ifndef MACH3D_SQUARE_WALLS
		add	hl,hl		;denominator *= 2 so that walls will be shorter
#endif
		ex	de,hl
		ld	h,tblSin>>8
		ld	l,a
		ld	l,(hl)
		ld	h,0	; h := 0

		;hl = sin(SA), de=dY
		;calc hl/de to 8 bits	;TOTAL:	min(321) < E(361) < max(401)
		call	_DivHLDE

		;a == wall height
#ifdef MACH3D_HBUFFER
		ex	af,af'
INLINEVAR(_hbufLoc)
		ld	a,0
		ld	l,a
		inc	a
		ld	(_hbufLoc),a
INLINEVAR(_HBuffer)
		ld	h,0
		ex	af,af'
		ld	(hl),a
#endif

		
		// Render Wall
		// a=WallHeight,(_TexNum),(_TexCol),(_grLoc),(_smDrawSet{012})
/*
VARS:
dx	=	height		=	c
dy	=	numpix		=	d	= 64
err	=	error		=	a
cnt	=	index		=	b
grloc	=			=	hl'
texloc	=			=	hl

code:
height = c
cnt = c
error = [0-64)
do
	// copy pixel
	error += 64
	while(error > height) {
		error -= height
		rloc++
	}
loop nz

*/
	or	a
	jr	z,_RenderWallDone0	;no point drawing nothing
	// a = wall height
	ex	af,af'
INLINEVAR(_TexNum)
	ld	h,0
INLINEVAR(_TexCol)
	ld	a,0
#ifndef MACH3D_SQUARE_WALLS
#ifndef MACH3D_TEX_STRETCH
	add	a,a
#endif
#endif
	add	a,a
	rl	h
	ld	d,a
	and	%11000000
	ld	l,a
	ld	bc,Mach3DTextures-512	;-512 b/c texture #1 is at tex[0]
	add	hl,bc
	// hl = ptr to texture bits
	ld	a,d
	and	%00111000
	xor	%01111110	// or's BIT n,(HL) instruction
				// and negates bit num in one op
	ld	(_smDrawGet0),a	// self-mod code
	ld	(_smDrawGet1),a	// self-mod code

	ex	af,af'
	ld	c,a
;hl  == texloc
;c   == height
	
	;508848 cyc for typical frame

	sub	65
	if	nc
	
		;texloc += 32 - 32*(64/h)
		;       += 32 - ((256*(64/h))>>3)
		ld	d,tbl64Div>>8
		ld	e,c
		ld	a,(de)
		ld	c,a		;c := frac(64/height)
		rrca\	rrca\	rrca
		cpl
		ld	e,a		;save fractional part (top 3 bits)
		or	%11100000	;a := -32*(64/h)-1
		add	a,33		;32 + 1 (for 2's complement negation)
		add	a,l
		ld	l,a		

		ld	a,(_aaOffset)		;a := error
		
		add	a,e			;error += fractional part
		if	c
			inc	l
		endif

		;hl' := grLoc
		exx
		ld	hl,(_grLoc)
		exx

		ld	b,64			;b := 64
		do
			;read
_smDrawGet0 = $+1
			bit	0,(hl)				;12
			exx					;4
#ifdef MACH3D_DARK_SKY
_DarkSky0x08:		// for dark sky, switch nz and z
			jmp	nz,@F
#else
			jmp	z,@F
#endif
_smDrawSet0 = $+1
				set	7,(hl)
@@:
			inc	l				;4
			exx					;4
			add	a,c				;4
			if	c				;11.5 (12/11)
				inc	l
			endif
		loop djnz					;13 / 8  = 69.5 cyc/pix
_RenderWallDone0:
		jp	_RenderWallDone
	endif
	
	;hl' := grBuf pointer
	ld	a,64	;a := 64
	sub	c	;a := 64-height
	exx
INLINEVAR(_grLoc)
	ld	hl,0
	rra		;a := 32-height/2 (carry is clear from sub c)
	ld	e,a
	ld	d,0
	add	hl,de	;hl := _grLoc + 32 - height/2
	exx

	;de := floor(64/height)
	ld	a,64	;a := 64
	ld	de,$00FF
	;loop division is slow for small heights, but those are rare
	;and small heights are fast to draw, so this helps to even
	;the framerate
	do
		inc	e
		sub	c
	near loop nc

	ld	b,c			;b := height
	ld	a,(_aaOffset)		;a := error
	
	;c := frac(64/height)
	push	hl
	ld	h,tbl64Div>>8
	ld	l,c
	ld	c,(hl)
	pop	hl
	
	do
		;read
_smDrawGet1 = $+1
		bit	0,(hl)				;12
		exx					;4
#ifdef MACH3D_DARK_SKY
_DarkSky1x08:	// for dark sky, switch nz and z
		jmp	nz,@F
#else
		jmp	z,@F
#endif
_smDrawSet1 = $+1
			set	7,(hl)
@@:
		inc	l				;4
		exx					;4
		add	a,c				;4
		adc	hl,de				;15
	loop djnz					;13 / 8  = 73 cyc/pix

_RenderWallDone:
	// Done drawing wall
	
		// end of loop increment
		;Update antialiasing offset
INLINEVAR(_aaOffset)
		ld	a,0
		xor	AAMASK
		ld	(_aaOffset),a
		;update self-modifying drawing code


		ld	a,(_smDrawSet0)
		add	a,%00111000 // subtracts one from bit num

		or	%11000000		// restore bit command
#ifdef MACH3D_DARK_SKY
INLINEVAR(_DarkSky1x40)	// for light sky, and %11111111
		and	%10111111
#endif
		ld	(_smDrawSet0),a
		ld	(_smDrawSet1),a

		and	%00111000	// check bit num
		xor	%00111000
		if z		// if rolled over to bit 7
			ld hl,(_grLoc)
			ld de,64
			add hl,de
			ld (_grLoc),hl
		endif
		
		ld hl,_SCount
		dec (hl)
		break	z
		
		ld	hl,_NormSA
		inc	(hl)
		far again nz
		jp	_RenderNewQuad
	enddo
	ret

//////////////////////////////////////////////////////////
// Mach3DFlip		Copies special buffer to screen
// inputs:		contents of gbuf
//

Mach3DFlip:
	ld	a,$80			; 7
	out	($10),a			; 11
	ld	hl,gbuf-1		; 10
	ld	a,$20			; 7
	ld	c,a			; 4
	inc	hl			; 6 waste
	dec	hl			; 6 waste
	do
		ld	b,64			; 7
		inc	c			; 4
		ld	de,0			; 10
		out	($10),a			; 11
		add	hl,de			; 11
		ld	de,1			; 10
		do
			inc	hl		; 6
			ld	a,(hl)		; 7
			or	a		; 4
#ifdef MACH3D_DARK_SKY
INLINEVAR(_DarkSky0xFF)
			ld	(hl),$FF
#else
			ld	(hl),$00	; 10
#endif
			inc	de		; 6
			out	($11),a		; 11
			dec	de		; 6
		loop djnz			; 13/8
		ld	a,c			; 4
		cp	$2B+1			; 7
	near while nz				; 12/7
	ret

	
///////////////////////////////////////////////////////////////
// _MultBCA             Multiplies BC by A, returns result in HL
// inputs:              bc, a
// outputs:             hl = bc*a/256
//                      bc /= 2
// destroys:            f bc hl
// timing:              best: 276 cyc, worst: 321 cyc, avg: 298.5 cyc
_MultBCA:
	;this method offers high-quality results
	;compared to the shift bc version
	ld	hl,0			;10
	srl	b\	rr	c	;16
	rrca				;4
	if	c			;12	7
		ld	h,b		;	4
		ld	l,c		;	4
	endif		
	srl h\	rr l\	rrca		;20
	if c\ add hl,bc\ endif		;12/18
	srl h\	rr l\	rrca		;20
	if c\ add hl,bc\ endif		;12/18
	srl h\	rr l\	rrca		;20
	if c\ add hl,bc\ endif		;12/18
	srl h\	rr l\	rrca		;20
	if c\ add hl,bc\ endif		;12/18
	srl h\	rr l\	rrca		;20
	if c\ add hl,bc\ endif		;12/18
	srl h\	rr l\	rrca		;20
	if c\ add hl,bc\ endif		;12/18
	srl h\	rr l\	rrca		;20
	if c\ add hl,bc\ endif		;12/18
	ret				;10
	
///////////////////////////////////////////////////////////////
// _DivHLDE             Divides HL by DE, returns result in A
// inputs:              hl, de
// outputs:             a = hl*128/de, clipped to the integers [0,255]
// destroys:            af hl
// timing:              best: 339 cyc, worst: 419 cyc, avg: 329 cyc
_DivHLDE:
	xor	a	        ;4      a := 0, clear carry

	sbc	hl,de		;15
	if	c		;7	12
	add	hl,de		;11
	inc	a		;4
	endif			;37/27 total

	add	hl,hl		;11
	rlca			; 4
	sbc	hl,de		;15
	if	c		; 7	12
	add	hl,de		;11
	inc	a		; 4
	endif			;52	42

	add hl,hl\ rlca\ sbc hl,de
	if c\ add hl,de\ inc a\ endif	;52/42
	add hl,hl\ rlca\ sbc hl,de
	if c\ add hl,de\ inc a\ endif	;52/42
	add hl,hl\ rlca\ sbc hl,de
	if c\ add hl,de\ inc a\ endif	;52/42
	add hl,hl\ rlca\ sbc hl,de
	if c\ add hl,de\ inc a\ endif	;52/42
	add hl,hl\ rlca\ sbc hl,de
	if c\ add hl,de\ inc a\ endif	;52/42
	add hl,hl\ rlca\ sbc hl,de
	if c\ add hl,de\ inc a\ endif	;52/42		
	cpl				;4	correct for recording opposite digits
	ret				;10
	
#ifdef MACH3D_DARK_SKY
///////////////////////////////////////////////////////////////
// Mach3DDarkSky        Switches between light sky and dark sky
// inputs:              none
// outputs:             none
// destroys:            af bc de hl

Mach3DDarkSky:
	ld	hl,_DarkSky0x40
	ld	a,(hl)
	xor	$40
	ld	(hl),a
	ld	hl,_DarkSky0x08
	ld	a,(hl)
	xor	$08
	ld	(hl),a
	ld	(_DarkSky1x08),a
	ld	hl,_DarkSky1x40
	ld	a,(hl)
	xor	$40
	ld	(hl),a
	ld	hl,_DarkSky0xFF
	ld	a,(hl)
	cpl
	ld	(hl),a

	;eliminates single-frame flash when called before Mach3DRender
	ld	hl,gBuf
	ld	de,gBuf+1
	ld	bc,767
	ld	(hl),a
	ldir

	ret
#endif

#ifdef MACH3D_MOVEFWD
///////////////////////////////////////////////////////////////
// Mach3DGetSin         finds Sin(theta)/2
// inputs:              a = theta [0-255], 256=360 degrees
// outputs:             a = (256)*(Sin(theta)/2) (signed int)
// destroys:            f c hl

Mach3DGetSin:
	ld	c,a
	bit	6,c
	if	nz		;QII or QIV
		cpl		;roughly negate a
	endif
	add	a,a
	add	a,a
	ld	l,a
	ld	h,tblSin>>8
	ld	a,(hl)
	srl	a
	bit	7,c
	if	nz		;QIII or QIV
		neg
	endif
	ret

///////////////////////////////////////////////////////////////
// Mach3DMoveFwd        Moves camera location forward one step
// inputs:              (CX,CY) = current location
//                      hl = direction to move
// outputs:             (CX,CY) = new camera location
// destroys:            af bc de hl
// notes:               no collision checking is done; use
//                      Mach3DValidateXY after moving

Mach3DMoveFwd:
	ld	a,l
	srl	h
	rra
	srl	h
	rra
	ld	e,a
	ld	d,0
	call	Mach3DGetSin
	;Y SPEED SET HERE
	sra	a
	sra	a
	ld	c,a
	;sign extend into b
	add	a,a
	ld	a,d
	sbc	a,d
	ld	b,a
	;add it
	ld	hl,(Mach3D_CY)
	add	hl,bc
	ld	(Mach3D_CY),hl
	ld	a,e
	add	a,$40
	call	Mach3DGetSin
	;X SPEED SET HERE
	sra	a
	sra	a
	ld	c,a
	;sign extend into b
	add	a,a
	ld	a,d
	sbc	a,d
	ld	b,a
	;add it
	ld	hl,(Mach3D_CX)
	add	hl,bc
	ld	(Mach3D_CX),hl
	ret
#endif	// MACH3D_MOVEFWD

#ifdef MACH3D_VALIDATEXY
///////////////////////////////////////////////////////////////
// Mach3DValidateXY     Moves camera location forward one step
// inputs:              (CX,CY) = current location
// outputs:             (CX,CY) = at least MIN_WALL_DIST from wall
// destroys:            af bc de hl
// notes:               if (CX,CY) is currently in a wall,
//                      Mach3DValidateXY will call the user-defined
//                      function Spawn, which should reset the camera
//                      position

Mach3DValidateXY:
	ld	a,(Mach3D_CY.HI)
	rlca\	rlca\	rlca\	rlca
	ld	hl,Mach3D_CX.HI
	or	(hl)
	ld	l,a
	ld	a,(Mach3DMapBuffer)
	ld	h,a
	;hl=map ptr
	ld	a,(hl)
	or	a
	jp	nz,Spawn	// laws of physics break down
	// try X+1,X-1
	do	;not really a loop
		ld	a,(Mach3D_CX.LO)
		cp	MIN_WALL_DIST
		if	c
			;small X
			dec	hl
			ld	a,(hl)
			inc	hl
			or	a
			break	z
			ld	a,MIN_WALL_DIST
			ld	(Mach3D_CX.LO),a
			break
		endif
		cp	$0100-MIN_WALL_DIST
		break	c
		;large X
		inc	hl
		ld	a,(hl)
		dec	hl
		or	a
		break	z
		ld	a,$0100-MIN_WALL_DIST
		ld	(Mach3D_CX.LO),a
	enddo
	ld	a,(Mach3D_CY.LO)
	ld	c,a
	cp	MIN_WALL_DIST
	if	c
		;small Y
		ld	de,-16
		add	hl,de
		ld	a,(hl)
		or	a
		if	nz
			ld	a,MIN_WALL_DIST
			ld	(Mach3D_CY.LO),a
			ret
		endif
		;corner?
		ld	a,(Mach3D_CX.LO)
		ld	b,a
		cp	MIN_WALL_DIST
		if	c
			dec	hl
			ld	a,(hl)
			or	a
			ret	z
			;X-1,Y-1 corner
			ld	a,b
			cp	c	;x-y
			ld	a,MIN_WALL_DIST
			if	c
				ld	(Mach3D_CY.LO),a	;y>x
				ret
			endif
			ld	(Mach3D_CX.LO),a	;y<=x
			ret
		endif
		cp	$0100-MIN_WALL_DIST
		ret	c
		inc	hl
		ld	a,(hl)
		or	a
		ret	z
		;X+1,Y-1 corner
		ld	a,b
		add	a,c
		if	c
			ld	a,MIN_WALL_DIST
			ld	(Mach3D_CY.LO),a	;x+1 dominant
			ret
		endif
		ld	a,$0100-MIN_WALL_DIST
		ld	(Mach3D_CX.LO),a
		ret
	endif
	cp	$0100-MIN_WALL_DIST
	ret	c
	;large Y
	ld	de,16	;10
	add	hl,de	;11
	ld	a,(hl)
	or	a
	if	nz
		ld	a,$0100-MIN_WALL_DIST
		ld	(Mach3D_CY.LO),a
		ret
	endif
	;corner?
	ld	a,(Mach3D_CX.LO)
	ld	b,a
	cp	MIN_WALL_DIST
	if	c
		dec	hl
		ld	a,(hl)
		or	a
		ret	z
		;X-1,Y+1 corner
		ld	a,b
		add	a,c
		if	c
			ld	a,MIN_WALL_DIST
			ld	(Mach3D_CX.LO),a	;y+1 dominant
			ret
		endif
		ld	a,$0100-MIN_WALL_DIST
		ld	(Mach3D_CY.LO),a
		ret
	endif
	cp	$0100-MIN_WALL_DIST
	ret	c
	inc	hl
	ld	a,(hl)
	or	a
	ret	z
	;X+1,Y+1 corner
	ld	a,b
	cp	c	;x-y
	ld	a,$0100-MIN_WALL_DIST
	if	c
		ld	(Mach3D_CX.LO),a	;y>x
		ret
	endif
	ld	(Mach3D_CY.LO),a	;y<=x
	ret
#endif	// MACH3D_VALIDATEXY

#ifdef MACH3D_HBUFFER
//////////////////////////////////////////////////////////
// Mach3DDrawSprite     Draws the sprite
// inputs:              (SX,SY) = sprite location
//                      (CX,CY) = camera location
// outputs:             Sprite is drawn on the buffer if needed
// destroys:            af bc de hl
// notes:               Mach3DDrawSprite must be called
//                      after Mach3DRender and before Mach3DFlip
//                      so MACH3D_POSTPROC must be defined.
//                      Also, MACH3D_HBUFFER must be defined.

#if ($&255)>(256-8)
ALIGN256
#endif
_tblSpriteOctant:	
	.db	%000,%101,%110,%001,%100,%011,%010,%111
_SpriteNCols:
	.db	0

Mach3DDrawSprite:
	;setup problem so that (SX-CX)>=0 and (SY-CY)>=0
	xor	a
	ld	(_SpriteYErr),a		;zero these out while we have a zero
	ld	(_SpriteYOffset),a
INLINEVAR(Mach3D_SY)
	ld	hl,0
	ld	de,(Mach3D_CY)
	sbc	hl,de
	if	c
		add	a,4	;clc
		ld	de,0
		ex	de,hl
		sbc	hl,de
	endif
	ld	(_SpriteDY),hl

INLINEVAR(Mach3D_SX)
	ld	hl,0
	ld	de,(Mach3D_CX)
	or	a
	sbc	hl,de
	if	c
		add	a,2	;7 clc
		ld	de,0	;10
		ex	de,hl	;4
		sbc	hl,de	;15
	endif
/*
	ld	(_SpriteDX),hl
INLINEVAR(_SpriteDX)
	ld	hl,0
*/
	;hl = DX
INLINEVAR(_SpriteDY)
INLINEVAR(_SpriteNumerator)
	ld	de,0
	or	a	;clc
	;hl = DX
	;de = DY
	sbc	hl,de
	if	c
		add	hl,de	;hl := DX (DX<DY)
		inc	a
	else
		add	hl,de	;hl := DX (DX>=DX)
		ex	de,hl
		ld	(_SpriteNumerator),de
	endif
	;hl <= de
	ld	(_SpriteOctant),a
	add	hl,hl	;DivHLDE is "off" by a factor of two
	call	_DivHLDE
	;binary search the tangent table to find arctan(a)
	ld	hl,tblTan & $FF00
	ld	de,$0040
	do
		add	hl,de
		cp	(hl)
		if	c	;(c) == (a<n) == (search target < *location)
			ccf	;clc
			sbc	hl,de
		endif
		srl	e
	far loop nz
	;l = arctan(a)
	push	hl
	ld	e,l
	;d = 0, de = arctan(a)
	;figure out how to correct for the octant
	ld	h,_tblSpriteOctant>>8
INLINEVAR(_SpriteOctant)
	ld	a,0
	add	a,_tblSpriteOctant&$FF
	ld	l,a
	ld	h,(hl)
	xor	a	;clc
	ld	l,a
	bit	2,h	;add or subtract?
	if	z
		add	hl,de
	else
		sbc	hl,de
	endif
	;hl = direction (angle) of sprite
	ld	de,(Mach3D_CA)
	or	a
	sbc	hl,de
	ld	de,FOVANG/2
	add	hl,de
	;hl = angular difference between sprite center and left edge of screen

	pop	de
	push	hl
	;calc sprite height (=const*numerator/cos(ang))
	ld	a,e	;a := ang
	cpl
	ld	l,a
	ld	h,tblSin>>8
	ld	e,(hl)
	ld	d,0
	ld	hl,(_SpriteNumerator)
#ifndef MACH3D_SQUARE_WALLS
	add	hl,hl		;denominator *= 2 so that walls will be shorter
#endif
	ex	de,hl
	call	_DivHLDE
	pop	hl
	;a = sprite height
	;hl = sprite center - left edge of screen + high bits
	or	a
	ret	z	;to small to see
	ld	(_SpriteHeight),a
	ld	e,a
	cp	65
	if	a>=n
		;preserve hl and de
		;texloc += 16 - 16*(64/h)
		;       += 16 - ((256*(64/h))>>4)
		ld	b,tbl64Div>>8
		ld	c,a
		ld	a,(bc)
		rrca\	rrca\	rrca\	rrca
		cpl
		ld	(_SpriteYErr),a		;save fractional part (top 4 bits)
		or	%11110000		;a := -16*(64/h)-1
		add	a,17			;16 + 1 (for 2's complement negation)
		;a = 16 - 16*(64/h)
		ld	(_SpriteYOffset),a
		;draw only 64 rows
		ld	a,64
	endif
	ld	(_SpriteDrawnRows),a
	ld	a,e
	ld	d,0
	srl	e
	add	hl,de	;hl := right edge
	ld	e,a	;de := width
	ld a,h\ and 3\ ld h,a	;correct for overflow
	ld	a,e
	sbc	hl,de	;hl := left edge
	;hl = sprite left edge relative to screen's left edge
	if	c
		;sprite is clipped on left side
		ld	d,l	;save -(offscreen portion)
		add	a,l	;a := sprite width - offscreen portion
		ret	z	;no width to draw
		cp	FOVPIX
		if	a>=n	;allow no more than FOVPIX columns to be drawn
			ld	a,FOVPIX
		endif
		ld	(_SpriteNCols),a
		
		;object-space clipping
		ld	l,e		;l := height
		ld	h,tbl64Div>>8
		ld	c,(hl)		;c := 0xFF & (256 * 64/height)
		ld	b,-1
		ld	a,64
		do			;do { b++ } while(a-=height >= 0);
			inc	b
			sub	e
		loop	a>=n
		;bc = 256 * 64/height
		;a := offscreen part
		ld	a,d
		neg
		;hl := (bc * a) = offscreen * 256 * 64/height
	
		ld	hl,0			;10
		rlca				;4
		if	c			;12	7
			ld	h,b		;	4
			ld	l,c		;	4
		endif
		add	hl,hl\	rlca		;15
		if c\ add hl,bc\ endif		;12/18
		add	hl,hl\	rlca		;15
		if c\ add hl,bc\ endif		;12/18
		add	hl,hl\	rlca		;15
		if c\ add hl,bc\ endif		;12/18
		add	hl,hl\	rlca		;15
		if c\ add hl,bc\ endif		;12/18
		add	hl,hl\	rlca		;15
		if c\ add hl,bc\ endif		;12/18
		add	hl,hl\	rlca		;15
		if c\ add hl,bc\ endif		;12/18
		add	hl,hl\	rlca		;15
		if c\ add hl,bc\ endif		;12/18
	
		;hl := 256 * offscreen * 32/height
		srl	h
		rr	l
		;save hl as _SpriteTexCol._SpriteXErr
		ld	a,h
		ld	(_SpriteTexCol),a
		ld	a,l
		ld	(_SpriteXErr),a

		xor	a
		ld	(_SpriteCol0),a
	else
		;left edge not clipped
		;hl = left edge
		ld	c,l		;save left edge in case we aren't totally clipped
		ld	de,FOVPIX	;de := screen width
		ex	de,hl		;hl := screen width, de := left edge
		sbc	hl,de
		ret	c		;(hl<de) => (screen width < left edge)
		ret	z		;(screen width = left edge)
		;hl = screen width - left edge
		cp	l
		if	a>=n		;if sprite width>=space on screen
			ld	a,l	;use screen width instead
		endif
		ld	(_SpriteNCols),a
		xor	a
		ld	(_SpriteTexCol),a
		ld	(_SpriteXErr),a
		ld	a,c
		ld	(_SpriteCol0),a
	endif


	ld	h,0
INLINEVAR(_SpriteHBufLoc)
INLINEVAR(_SpriteCol0)
	ld	a,0
_TasmHatesMacrosXOFF .equ XOFFSET
#if _TasmHatesMacrosXOFF != 0
	add	a,XOFFSET&7
#endif
	add	a,a	;Col0 + XOFFSET&7 < FOVPIX+7 <= 96+7 < 128, so no carry
	add	a,a
	rl	h
	add	a,a
	rl	h
	ld	l,a
	and	%00111000
	xor	%11111110
	ld	(_SpriteSet0),a
	xor	%01000000
	ld	(_SpriteRes0),a
	ld	a,l
	and	%11000000
	ld	l,a
	ld	de,gBuf+(8*(XOFFSET&-8))
	add	hl,de
	;hl = ptr to gBuf at top of column
	;hl := ptr to correct row in column
	ld	a,(_SpriteDrawnRows)
	sub	64
	neg
	srl	a
	add	a,l
	ld	l,a
	;hl = ptr to correct row and column
	ld	(_SpriteBufPtr),hl

INLINEVAR(_SpriteHeight)
	ld	c,0

	;de := 2*floor(32/height)
	ld	a,32		;a := 32
	ld	de,$00FF	;e := -1
	;loop division is slow for small heights, but those are rare
	;and small heights are fast to draw, so this helps to even
	;the framerate
	do
		inc	e
		sub	c
	near loop nc
	ld	(_SpriteTexDelHI),de
	;a := frac(32/height)
	ld	h,tbl64Div>>8
	bit	7,c
	if	z		;if height < 128
		ld	a,c
		add	a,a
		ld	l,a
		ld	a,(hl)	; a := frac(64/(2*height))
	else			;else
		ld	l,c
		ld	a,(hl)
		srl	a	; a := frac(64/height)/2
	endif
	ld	(_SpriteTexDelLO),a

	do
		;check hBuffer
		ld	hl,_SpriteHBufLoc
		ld	a,(hl)
		inc	(hl)
		ld	l,a
		ld	a,(_HBuffer)
		ld	h,a
		ld	a,(_SpriteHeight)
		cp	(hl)
		if	a>=n	;hBuffer says it's ok to draw
			// if we're drawing multiple sprites, where each sprite
			// is mostly transparent, things look a little nicer
			// (though still not perfect) if we don't update hbuf
			// The reason is that mostly transparent sprites
			// don't really hide the stuff behind them.
			//ld	(hl),a		;update the hBuffer

			;hl' := buf ptr
INLINEVAR(_SpriteBufPtr)
			ld	hl,0
			exx
			;hl := texture ptr
INLINEVAR(_SpriteTexCol)
			ld	a,0
			add	a,a
			add	a,a
			add	a,a
			ld	l,a
			and	%00111000
			xor	%01111110		;make the number a BIT instruction
			ld	(_SpriteBit0t),a
			ld	(_SpriteBit0),a
			ld	a,l
			and	%11000000
INLINEVAR(_SpriteYOffset)
			add	a,0
			ld	l,a
INLINEVAR(Mach3DSTexBuf)
			ld	h,Mach3DSpriteTexture>>8
			;de := delta hi
INLINEVAR(_SpriteTexDelHI)
			ld	de,0
			;b := DrawnRows, c := delta lo
_SpriteTexDelLO = $+1
_SpriteDrawnRows = $+2
			ld	bc,0
			;a := error fraction
INLINEVAR(_SpriteYErr)
			ld	a,0
			// START OF COLUMN DRAWING LOOP
			do
				;read
_SpriteBit0t = $+1
				bit	0,(hl)				;12
				if	z				;7		12
					set	5,l			;8
_SpriteBit0 = $+1
					bit	0,(hl)			;12
					exx				;4
					if	z			;12	7
_SpriteRes0 = $+1
						res	0,(hl)		;	15
					else				;	10
_SpriteSet0 = $+1
						set	0,(hl)		;15
					endif
					inc	l			;4
					exx				;4
					res	5,l			;8
					add	a,c			;4
					adc	hl,de			;15
					again	djnz			;13/8
					break
				endif
				exx					;		4
				inc	l				;		4
				exx					;		4
				add	a,c				;		4
				adc	hl,de				;		15
			loop djnz					;		13 / 8
			// END OF COLUMN DRAWING LOOP
			;68 cyc for transparent
			; cyc for black
			; cyc for white
		endif
		// Update texture column
		ld	a,(_SpriteTexDelLO)
INLINEVAR(_SpriteXErr)
		add	a,0
		ld	(_SpriteXErr),a
		ld	a,(_SpriteTexDelHI)
		ld	l,a
		ld	a,(_SpriteTexCol)
		adc	a,l
		ld	(_SpriteTexCol),a
		// Update drawing buffer location
		ld	a,(_SpriteSet0)
		add	a,%00111000		// subtracts one from bit num
		if	nc
			;rollover from 000 to 111
			ld	de,64
			ld	hl,(_SpriteBufPtr)
			add	hl,de
			ld	(_SpriteBufPtr),hl
		endif
		or	%11000000		// restore "set" command
		ld	(_SpriteSet0),a
		xor	%01000000
		ld	(_SpriteRes0),a
		// loop counter
		ld	hl,_SpriteNCols
		dec	(hl)
	far loop nz
	ret

	
#endif

//////////////////////////////////////////////////////////
// Aligned data
//

@@:
ALIGN256
#include "tables.inc"

.echo "Mach3D engine: "
.echo $-Mach3D
.echo " bytes\n\t"
.echo @B-Mach3D
.echo " bytes code\n\t"
.echo $-@B
.echo " bytes data\n"
