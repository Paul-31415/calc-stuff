.nolist
/////////////////////////////////////////////////
//              _               _              //
//          _.-` `-._       _.-` `-._          //
//      _.-`    _    `-._.-`    _    `-._      //
//   .-`    _.-`|`-._       _.-`|`-._    `-.   //
//  |`-._.-`    |    `-._.-`    |    `-._.-`|  //
//  |   |    .-` `-._   |   _.-` `-.    |   |  //
//  |   |.-`|`-._.-`|`-.|.-`|`-._.-`|`-.|   |  //
//  |    `-.|   |   |       |   |   |.-`    |  //
//  |           |   |`-._.-`|   |           |  //
//  |   |`-.    |   |   |   |   |    .-`|   |  //
//   `-.|.-`|   |   |`-.|.-`|   |   |`-.|.-`   //
//          |   |   |       |   |   |          //
//           `-.|.-`         `-.|.-`           //
//                                             //
// Maze3D II - a 3D maze game for the TI-83+   //
// Copyright (C) 2006  Kevin Harness           //
// deep42thought42@yahoo.com                   //
/////////////////////////////////////////////////
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

///////////////////////////////////////////////////////
// Preprocessing

option "prefix" "maze3DIIC"
option "anonprefix" "maze3DIIA"
option speed

#include "stdhead.inc"

.echo "*************\nBuild Options:\n"
#ifdef _DEBUG_
.echo "_DEBUG_\n"
#endif
#ifdef EVIL
.echo "EVIL\n"
#endif
.echo "*************\n"

///////////////////////////////////////////////////////
// Definitions

#define TURNUNIT	$0010

///////////////////////////////////////////////////////
// Globals

STARTGLOBALS($86EC)	// SaveSScreen, 768 bytes

// globals go here
// EXAMPLE:
//
// My_8Bit_Var:
// 	.db 0
// My_16Bit_Var:
// 	.dw 0

GlobalsEnd:

.echo "Globals = "
.echo GlobalsEnd-GlobalsStart
.echo " bytes ("
.echo 768-GlobalsEnd+GlobalsStart
.echo " bytes remaining)\n"
#if GlobalsEnd-GlobalsStart>768
!!! GLOBALS DON'T FIT
#endif

///////////////////////////////////////////////////////
// Code

.list
#ifdef EVIL
#define TASMSUCKS_TITLE "Maze 3D II Evil Ed."
IONHEAD(TASMSUCKS_TITLE)
#else
IONHEAD("Maze 3D II")
#endif
#ifdef _DEBUG_
	ld	(Sav_SP),sp
	jr	@F
	.org $9DDD
	jp Exit
@@:
#endif

main:
	call	Mach3DInit
	jp	c,InitFailed
Menu:
	ld	hl,strMenu
	call	Prompt
	cp	$37	;MODE
	jp	z,Exit
	cp	$27	;APPS
	if	z
		ld	hl,strHelp
		call	Prompt
		jr	Menu
	endif
	cp	$09	;ENTER
	jr	nz,Menu	

Start:
	;load our map
	call	GenMaze
	;ld	hl,gMap
	;call	Mach3DLoadMap

	call	Spawn
#ifdef EVIL
	call	SpawnDemon
#endif
mainloop:

	// keep an 8-bit frame number
INLINEVAR(Clock8)
	ld	a,255
	inc	a
	ld	(Clock8),a
#ifdef EVIL
	and	%00111101
	call	z,Tex1Blink
	call	MoveDemon
#endif

#ifndef EVIL
	call	Tex4PutMaze
	call	Tex4PutPlayer
#endif

	// keys
	ld	a,$FF
	out (1),a
	ld	a,$BF
	out (1),a
	in	a,(1)
	bit 6,a		;mode
	jp	z,Exit

	ld	hl,(Mach3D_CA)
	ld	a,$FF
	out (1),a
	ld	a,$FD
	out (1),a
	in	a,(1)
	bit	0,a			;enter
	if	z
		ld	hl,Physics
		push	hl
		jp	AutoMove
	endif
	and	%01000000		;clear
	if	z
		;step right
		push	hl
		ld	de,ANG90
		add	hl,de
		call	Mach3DMoveFwd
		pop	hl
	endif

	ld	a,$FF
	out (1),a
	ld	a,$FB
	out (1),a
	in	a,(1)
	and	%01000000		;vars
	if	z
		;step left
		push	hl
		ld	de,3*ANG90
		add	hl,de
		call	Mach3DMoveFwd
		pop	hl
	endif

	ld	a,$FF
	out (1),a
	ld	a,$FE
	out	(1),a
	in	a,(1)
	ld	de,TURNUNIT
	bit 1,a
	if z
		or	a
		sbc	hl,de
	endif
	bit 2,a
	if z
		add	hl,de
	endif
	ld	(Mach3D_CA),hl
	bit	3,a	// up
	if z
		push	af
		push	hl
		call	Mach3DMoveFwd
		pop	hl
		pop	af
	endif
	bit	0,a	// down
	if z
		ld	de,2*ANG90
		add	hl,de
		call	Mach3DMoveFwd
	endif
	// physics, etc.
Physics:
	call	Mach3DValidateXY	;wall collision check
	ld	a,(Mach3D_CX+1)
	ld	l,a
	ld	a,(Mach3D_CY+1)
	ld	h,a
	ld	de,$0D0D	// exit at (13,13)
	or	a
	sbc	hl,de
	jp	z,Win
#ifdef EVIL
	// Check if soul has been reaped
	add	hl,de	;hl = YX
	ld	a,(DemonX+1)
	ld	e,a
	ld	a,(DemonY+1)
	ld	d,a
	or	a
	sbc	hl,de
	jp	z,Lose
#endif
Render:
	// drawing
	;draw compass
	ld	hl,imgNorth
	ld	de,gbuf+64-18
	ld	bc,8
	ldir

	ld	hl,-ANG90 + (ANG90/4)
	ld	bc,(Mach3D_CA)
	sbc	hl,bc
	add	hl,hl
	ld	a,h
	and	7
	add	a,a
	add	a,a
	add	a,a
	ld	l,a
	ld	h,imgCompass>>8
	ld	de,gbuf+64-9
	ld	bc,8
	ldir
	// draw the walls
	call Mach3DRender
	// draw the exit
#ifndef EVIL
	call Mach3DDrawSprite
#else
	ld	hl,$0D80
	ld	(Mach3D_SX),hl
	ld	(Mach3D_SY),hl
	call Mach3DDrawSprite
	ld	hl,(DemonX)
	ld	(Mach3D_SX),hl
	ld	hl,(DemonY)
	ld	(Mach3D_SY),hl
	ld	hl,Mach3DSTexBuf
	inc	(hl)
	call Mach3DDrawSprite
	ld	hl,Mach3DSTexBuf
	dec	(hl)
#endif

	call Mach3DFlip
	jp mainloop

// Resets player's location
// required for error handling in Mach3DValidateXY

Spawn:
	ld	bc,$0180	// 1.5f
	ld	(Mach3D_CX),bc
	ld	bc,$0180	// 1.5f
	ld	(Mach3D_CY),bc
	ld	bc,0		// East
	// check if East is an open path on the map
	ld	a,(Mach3DMapBuffer)
	ld	h,a
	ld	l,16+2
	ld	a,(hl)
	or	a
	if	nz		// east isn't open
		ld	bc,ANG90	// South
	endif
	ld	(Mach3D_CA),bc
	ret

// returns z if path is open, nz if closed
// direction passed in "d"
// 0 = ahead, 1=right, -1=left
// destroys: af de hl
AutoMoveDirTable:
	.db	-16,1,16,-1
AutoMoveGetWalls:
	ld	a,(Mach3D_CA+1)
	add	a,d
	and	3
	ld	e,a
	ld	d,0
	ld	hl,AutoMoveDirTable
	add	hl,de
	ld	h,(hl)
	ld	a,(Mach3D_CY+1)
	rrca\ rrca\ rrca\ rrca
	and	$F0
	ld	l,a
	ld	a,(Mach3D_CX+1)
	or	l
	add	a,h
	ld	l,a
	ld	a,(Mach3DMapBuffer)
	ld	h,a
	ld	a,(hl)
	or	a
	ret

AutoMoveSavePos0:
	pop	de
	ld	hl,(Mach3D_CX)
	push	hl
	ld	hl,(Mach3D_CY)
	push	hl
	push	de
	ret

AutoMoveSavePos1:
	pop	de
	ld	a,(Mach3D_CX)
	ld	l,a
	ld	a,(Mach3D_CY)
	ld	h,a
	push	hl
	push	de
	ret

;z = move was ok
AutoMoveWasOK:
	pop	hl
	ld	(@F),hl
	ld	a,(Mach3D_CX)
	ld	c,a
	ld	a,(Mach3D_CY)
	ld	b,a
	pop	hl
	pop	de
	ld	(Mach3D_CY),de
	pop	de
	ld	(Mach3D_CX),de
	or	a
	sbc	hl,bc
INLINEVAR(@@)
	jp	0

AutoMove:
/*
	;always turn right until straight
	ld	a,(Mach3D_CA)
	or	a
	if	nz
		add	a,TURNUNIT
		if	c
			ld	hl,Mach3D_CA+1
			inc	(hl)
			xor	a
		endif
		ld	(Mach3D_CA),a
		jp	Mach3DMoveFwd
		;ret
	endif
//*/
	;try sidestepping right
	;save original position
	call	AutoMoveSavePos0
	ld	hl,(Mach3D_CA)
	;try right
	ld	de,ANG90
	add	hl,de
	call	Mach3DMoveFwd
	call	AutoMoveSavePos1
	call	Mach3DValidateXY
	call	AutoMoveWasOK
	if	z
		;sidestepping would succeed, turn right a little
		ld	hl,(Mach3D_CA)
		ld	de,TURNUNIT
		add	hl,de
		ld	(Mach3D_CA),hl
INLINEVAR(@@)
		ld	a,1
		dec	a
		jp	z,Mach3DMoveFwd
		ld	(@B),a
		ret
	endif
	ld	a,12
	ld	(@B),a
	;sidestep failed, try to move forward instead
	call	AutoMoveSavePos0
	ld	hl,(Mach3D_CA)
	call	Mach3DMoveFwd
	call	AutoMoveSavePos1
	call	Mach3DValidateXY
	call	AutoMoveWasOK
	if	z
		ld	hl,(Mach3D_CA)
		jp	Mach3DMoveFwd
	endif
	;forward movement failed, turn left a little
	ld	hl,(Mach3D_CA)
	ld	de,0-TURNUNIT
	add	hl,de
	ld	(Mach3D_CA),hl
	ret

Win:
	ld	hl,strWin
	call	Prompt
	jp	Menu


////////////////////////////////////////////////
// InitFailed: for when the Mach3D engine can't start

strInitFailed:
	.db	"3D Engine could not start",0
	.db	"Ensure 1.5K free RAM",0
	.db	"For more help, see",0
	.db	"documentation",0
	.db	"PRESS A KEY",0
	.db	0

InitFailed:
	ld	hl,strInitFailed
	call	Prompt

	// no return, continue on to Exit

////////////////////////////////////////////////
// Exit: cleans up and quits program

Exit:
#ifdef _DEBUG_
INLINEVAR(Sav_SP)
	ld	sp,0
#endif
	call	Mach3DClose
	ret

////////////////////////////////////////////////
// Specialty functions

option size

#ifdef EVIL

////////////////////////////////////////////////
// Tex1Blink
// Makes the little guy on texture 1 blink

Tex1Blink:
	ld	de,_Tex1BlinkMasks
	ld	hl,Mach3DTextures+512+(64*2)+18
	ld	b,3
	do
		ld	a,(de)
		inc	de
		xor	(hl)
		ld	(hl),a
		inc	hl
	loop	djnz
	ld	hl,Mach3DTextures+512+(64*3)+18
	ld	b,3
	do
		ld	a,(de)
		inc	de
		xor	(hl)
		ld	(hl),a
		inc	hl
	loop	djnz
	ret
_Tex1BlinkMasks:
	.db	%01110000
	.db	%11011001
	.db	%01110000
	.db	%11100000
	.db	%10110000
	.db	%11100000

////////////////////////////////////////////////
// SpawnDemon
// Starts the Demon and its soul

#define DEMON_SPEED $20

SpawnDemon:
	ld	hl,$0D80
	ld	(DemonX),hl
	ld	(DemonY),hl
	xor	a
	ld	(DemonA),a
	ld	(DemonTick),a
	jp	DemonPlan

////////////////////////////////////////////////
// MoveDemon
// Does Demon-moving stuff

DemonAngMap:
	.db	1,16,-1,-16
DemonAngDelta:
	.dw	DEMON_SPEED,0
	.dw	0,DEMON_SPEED
	.dw	-DEMON_SPEED,0
	.dw	0,-DEMON_SPEED

MoveDemon:
INLINEVAR(DemonDX)
	ld	de,0
INLINEVAR(DemonX)
	ld	hl,0
	add	hl,de
	ld	(DemonX),hl
INLINEVAR(DemonDY)
	ld	de,0
INLINEVAR(DemonY)
	ld	hl,0
	add	hl,de
	ld	(DemonY),hl
INLINEVAR(DemonTick)
	ld	a,0
	add	a,DEMON_SPEED
	ld	(DemonTick),a
	ret	nc
DemonPlan:
	;turn around, then search right for an opening
	ld	a,(DemonY+1)
	add	a,a
	add	a,a
	add	a,a
	add	a,a
	ld	l,a
	ld	a,(DemonX+1)
	add	a,l
	ld	l,a
	ld	a,(Mach3DMapBuffer)
	ld	h,a
INLINEVAR(DemonA)
	ld	a,0
	xor	2
	ld	c,a
	do
		push	hl
		inc	c
		ld	a,c
		and	3
		ld	e,a
		ld	d,0
		ld	hl,DemonAngMap
		add	hl,de
		ld	a,(hl)
		pop	hl
		push	hl
		add	a,l
		ld	l,a
		ld	a,(hl)
		pop	hl
		or	a
		break	z	;opening found
	loop
	ld	a,c
	and	3
	ld	(DemonA),a
	add	a,a
	add	a,a
	ld	e,a
	ld	d,0
	ld	hl,DemonAngDelta
	add	hl,de
	ld	e,(hl)\	inc	hl
	ld	d,(hl)\	inc	hl
	ld	(DemonDX),de
	ld	e,(hl)\	inc	hl
	ld	d,(hl)
	ld	(DemonDY),de
	ret

Lose:
	ld	hl,strLoss
	call	Prompt
	jp	Menu
#endif	;EVIL

#ifndef EVIL
Tex4PutMaze:
	ld	l,0
	ld	de,$FF0F
	ld	ix,Mach3DTextures+(512*3)+(64*3)+16
	call	@F
	ld	l,8
	ld	ix,Mach3DTextures+(512*3)+(64*4)+16
	ld	de,$FE0F
@@:
	ld	a,(Mach3DMapBuffer)
	ld	h,a
	do
		ld	b,8
		do
			ld	a,$FF
			add	a,(hl)
			rl	c
			inc	hl
		loop	djnz
		ld	a,c
		and	d
		ld	(ix),a
		inc	ix
		ld	(ix),a
		inc	ix
		ld	bc,8
		add	hl,bc
		dec	e
	loop	nz
	ret
Tex4PutPlayer:
	ld	h,(Mach3DTextures+(512*3))>>8
	ld	a,(Mach3D_CY.HI)
	add	a,a
	add	a,(64*3)+16
	ld	l,a
	ld	a,(Mach3D_CX.HI)
	cp	8
	if	a>=n
		ld	de,64
		add	hl,de
	endif
	ld	e,%10000000
	and	7
	if	nz
		ld	b,a
		do
			srl	e
		while djnz
	endif
	ld	a,(Clock8)
	and	1
	if	nz
		inc	l
	endif
	ld	a,(hl)
	or	e
	ld	(hl),a
	ret
#endif

// GenMaze: generates maze and loads it
GenMaze:
	;setup sprite location (to mark exit)
	ld	hl,$0D80
	ld	(Mach3D_SX),hl
	ld	(Mach3D_SY),hl
	ld	a,(Mach3DMapBuffer)
	;hl := map pointer
	ld	h,a
	ld	l,0
	;make grid
	ld	b,l
	ld	d,2
	do
		ld	a,l
		rrca\	rrca\	rrca\	rrca
		and	l
		rrca
		if	c	;neither of (x,y) is even
			ld	(hl),d
			inc	d
		else
			ld	(hl),1
		endif
		inc	hl
	loop	djnz
	;enumerate edges
	;horizontal edges
	ld	a,18	;index of first edge
	ld	c,7	;7 rows of them
	do	
		ld	b,6	;6 per row
		do
			ld	(hl),a
			inc	l
			add	a,2
		loop djnz
		add	a,20
		dec	c
	loop	nz
	;vertical edges
	ld	a,33	;index of first edge
	ld	c,6	;6 rows of them
	do	
		ld	b,7	;7 per row
		do
			ld	(hl),a
			inc	l
			add	a,2
		loop djnz
		add	a,18
		dec	c
	loop	nz
	ld	e,l	;e := number of edges
	dec	h	;h := maze buffer
	;add edges until we have a spanning tree
	ld	d,48	;grid has 7x7 = 49 vertices, so spanning tree will have 48 edges
	do
		do
			;pick a random edge
			ld	b,e
			call	ionRandom
			ld	l,a
			inc	h	;h := edge list
			ld	c,(hl)	;c := random edge ID
			dec	e	;available_edges--
			ld	l,e
			ld	b,(hl)	;take the last edge in the list
			ld	l,a
			ld	(hl),b	;and move it to the freed position
			dec	h	;h := maze buffer
			ld	a,c
			rrca
			if	c
				;vertical edge
				rlca	;a = edge offset
				add	a,-16
				ld	l,a
				ld	b,(hl)	;b := class of top vertex
				add	a,32
				ld	l,a
				ld	a,(hl)	;a := class of bottom vertex
			else
				;horizontal edge
				ld	l,c
				dec	l
				ld	b,(hl)	;b := class of left vertex
				inc	l
				inc	l
				ld	a,(hl)	;a := class of right vertex
			endif
			cp	b
		loop	eq	;if classes match, we need a different edge
		;remove edge c
		ld	l,c
		ld	(hl),0
		call	_GenMazeReplace
		dec	d
	loop nz
	ld	l,17
	ld	b,(hl)
	xor	a	;a := 0
	;fill paths with 0s
	call	_GenMazeReplace
	;replace 1's with a variety of textures
	ld	l,0
	do
		ld	a,(hl)
		or	a
		if	nz
			ld	de,_GenMazeWallProbs
			ld	b,0
			call	ionRandom
			ld	c,0
			ld	b,a
			do
				inc	c
				ld	a,(de)
				inc	de
				add	a,b
				ld	b,a
			loop	nc
			ld	(hl),c
		endif
		inc	l
	loop	nz
	;l = 0, so hl points to map
	jp	Mach3DLoadMap	;faster/smaller than call/ret
_GenMazeWallProbs:
#ifdef EVIL
	.db	$F0	;plain brick
	.db	$08	;eye creature
	.db	$08	;skulls and gore
#else
	.db	$E0	;plain brick
	.db	$10	;pickets
	.db	$08	;confused mouse
	.db	$08	;map
#endif
_GenMazeReplace:
	;set (hl):=a where (hl)==b
	;preserve de h
	ld	(_GenMazeRepNum),a
	ld	a,b
	ld	l,17	;first vertex location
	ld	bc,256-17-32
	do
		cpir
		ret	nz
		dec	l	;move back to the match
INLINEVAR(_GenMazeRepNum)
		ld	(hl),0
		inc	l
	loop

///////////////////////////////////////////////
Prompt:
	push	hl
	bcal	ti_clrscrf
	ld	hl,0
	ld	(pencol),hl
	pop	hl
	do
		push	hl
		bcal	ti_vputs
		pop	hl
		ld	a,(penrow)
		add	a,6
		ld	(penrow),a
		xor	a
		ld	(pencol),a
		ld	b,a
		ld	c,a
		cpir
		ld	a,(hl)
		or	a
	again	nz
	ei
	;debounce (142ms delay)
	ld	bc,0
	do
		again	djnz
		dec	c
	loop	nz
	bcal	ti_getk
	;wait for key
	do
		halt
		bcal	ti_getk
		or	a
	loop	z
	di
	ret

#include "mach3D.z80"

ModuleData: .MODULE M_Data

ALIGN256
Mach3DTextures:
#ifdef EVIL
#include "walltex_evil.inc"
#else
#include "walltex.inc"
#endif
ALIGN256
Mach3DSpriteTexture:
#ifdef EVIL
#include "sprite_evil.inc"
#else
#include "sprite.inc"
#endif

ALIGN256
imgCompass:
imgNorth = $+(8*8)
#ifdef EVIL
#include "compass_evil.inc"
#else
#include "compass.inc"
#endif

strMenu:
#ifdef EVIL
	.db	"Maze",6,"3D",6,"II",6,"Evil",6,"Ed.",0
#else
	.db	"Maze",6,"3D",6,"II",0
#endif
	.db	$C1,"ENTER",$5D,6,"to",6,"start",0
	.db	$C1,"APPS",$5D,6,"for",6,"help",0
	.db	$C1,"MODE",$5D,6,"to",6,"quit",0
	.db	0

strHelp:
#ifdef EVIL
	.db	"Maze",6,"3D",6,"II",6,"Evil",6,"Ed.",0
	.db	"Goal: find salvation",0
	.db	"before damnation",0
#else
	.db	"Maze",6,"3D",6,"II",0
	.db	"Goal: find the smiley face",0
#endif
	.db	"Keys:",0
	.db	$1E,',',$1F,6,"to go forward, back",0
	.db	$CF,',',$05,6,"to turn",0
	.db	$C1,"VARS",$5D,',',$C1,"CLEAR",$5D,6,"to sidestep",0
	.db	$C1,"MODE",$5D,6,"to quit",0
	.db	$C1,"ENTER",$5D,6,"to wall follow",0
	.db	"Press a key",0
	.db	0

strWin:
#ifdef EVIL
	.db	"Your",6,"soul",6,"has",6,"been",0
	.db	"reaped",6,"by",6,"the",0
	.db	"HOLY",6,"SPIRIT",0
	.db	0
strLoss:
	.db	"Your",6,"soul",6,"has",6,"been",0
	.db	"devoured",6,"by",6,"a",6,"demon",0
	.db	"from",6,"H",$C0,"LL",0
	.db	6,0
	.db	"GAME",6,"OVER",0
	.db	0

#else
	.db	"All",6,"your",6,"maze",0
	.db	"are",6,"belong",6,"to",6,"us",0
	.db	0
#endif

/*
.echo "Code size = "
.echo ModuleData-progstart
.echo " bytes. ("
.echo (100*(ModuleData-progstart))/($-progstart)
.echo "%)\n"
.echo "Data size = "
.echo $-ModuleData
.echo " bytes. ("
.echo (100*($-ModuleData))/($-progstart)
.echo "%)\n"
*/
.echo "Program size = "
.echo $-progstart
.echo " bytes.\n"
 .end

