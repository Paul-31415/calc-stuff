;   ________
;  /        \ | |
;  |   __   | |_|
;  |  |  |  |  _
;  |  |  |_ | /_\
;  |  |__\ \| | |
;  |        \  _
;  \______  / | \
;        /_/  |_/ 
;
; P  L  A  Y  E  R
; QuadPlayer 1.1 -- Benjamin Ryves
;
; 1.0: April 2005
; 1.1: September 2005 (added looping, playback from archive).
; 1.1: February 2006 (repackaging, source conversion to Brass).
; See README.HTM for further information.

; ===============================================================
; Required Headers
; ===============================================================

.include "Includes/headers.inc"
.include "Includes/keyval.inc"

; ===============================================================
; Global Variables
; ===============================================================

#define safeMem savesScreen
#define curSearchFile safeMem+0
#define numSongs safeMem+2
#define selSong safeMem+3
#define scrollOffset safeMem+4
#define fullNumSongs safeMem+5
#define abScrollPos safeMem+6
#define saveLocations safeMem+7
#define songLocations safeMem+100
#define songDetails safeMem+200
#define repeatCount safeMem+50

#define maxLines 9

; ===============================================================
; Main entry point
; ===============================================================

main

	xor a
	ld (selSong),a
	ld (scrollOffset),a

	set textWrite,(iy+sgrFlags)
drawGUILoop:
	bcall(_grBufClr)
	ld hl,22
	ld (penCol),hl
	ld hl,Description
	bcall(_vPuts)
	xor a
	call invertText
	xor a
	ld (numSongs),a
	ld (fullNumSongs),a
	ld a,1
	ld (penRow),a

	ld hl,songLocations
	ld (saveLocations),hl

	ld hl,(progPtr)
	ld a,(scrollOffset)
	or a
	jr z,noScrollOffset

	ld b,a
scrollToFindStartProg:
	push bc
	ld ix,progSearchHeader
	call ionDetect
	pop bc
	jr nz,noScrollOffset

	ld a,(fullNumSongs)
	inc a
	ld (fullNumSongs),a

	ex de,hl
	djnz scrollToFindStartProg

noScrollOffset:

scanFindNextProg:


	ld ix,(saveLocations)
	ld (ix+1),h
	ld (ix+0),l
	inc ix
	inc ix
	ld (saveLocations),ix

	ld ix,progSearchHeader
	call ionDetect
	ld (curSearchFile),de
	jr nz,foundAllSongs; No more songs

	push hl


	ld hl,numSongs
	inc (hl)
	ld hl,fullNumSongs
	inc (hl)
	ld a,(numSongs)
	cp maxLines
	jr nz,notHitMax
	pop hl
	jr foundAllSongs

notHitMax:
	pop hl
	inc hl

	ld e,1
	ld a,(penRow)
	add a,6
	ld d,a
	ld (penCol),de
	
	bcall(_vPutS)
	
	ld hl,(curSearchFile)
	jr scanFindNextProg

foundAllSongs:
	ld hl,(curSearchFile)
countAllSongs:
	ld ix,progSearchHeader
	call ionDetect
	jr nz,countedAllSongs

	ld a,(fullNumSongs)
	inc a
	ld (fullNumSongs),a
	ex de,hl
	jr countAllSongs

countedAllSongs:


	ld a,(numSongs)
	or a
	ret z

	ld a,(selSong)
	ld b,a
	ld a,(scrollOffset)
	add a,b
	inc a
	ld (abScrollPos),a

	ld a,(selSong)
	inc a
	add a,a
	ld b,a
	add a,a
	add a,b
	inc a
	call invertText

	call reloadAllButtons

	ld a,1
	call disableButton
	ld a,2
	call disableButton
	call ionFastCopy

noKeyPressedGUI:
	bcall(_getCSC)
	or a
	jr z,noKeyPressedGUI
	cp skClear
	ret z
	cp skGraph
	ret z
	cp skYEqu
	jp z,loadAndPlaySong
	cp skTrace
	jr z,displaySongInfo
	cp skUp
	jr nz,notGUIUp
	ld a,(selSong)
	or a
	jr nz,notOffTop

	ld a,(scrollOffset)
	or a
	jr z,noKeyPressedGUI

	dec a
	ld (scrollOffset),a
	jp drawGUILoop


notOffTop:
	dec a
	ld (selSong),a
	jp drawGUILoop
notGUIUp:
	cp skDown
	jr nz,notGUIDown
	ld a,(numSongs)
	ld b,a
	ld a,(selSong)
	inc a
	cp maxLines-1
	jr nz,notOffBottomScreen

	ld a,(abScrollPos)
	ld b,a
	ld a,(fullNumSongs)
	cp b
	jr z,noKeyPressedGUI
	ld a,(scrollOffset)
	inc a
	ld (scrollOffset),a
	jp drawGUILoop

notOffBottomScreen:
	cp b
	jr z,noKeyPressedGUI
	ld (selSong),a
	jp drawGUILoop
notGUIDown:

	jr noKeyPressedGUI


loadSong:
	ld a,(selSong)
	ld l,a
	ld h,0
	add hl,hl
	ld de,songLocations
	add hl,de

	push hl
	pop ix

	ld h,(ix+1)
	ld l,(ix+0)

	push de
	push bc

	ld ix,progSearchHeader
	call ionDetect
	jr z,loadFoundSong
	pop af
	ret
loadFoundSong:

	push hl

	ld de,-5
	add hl,de

	ld (songLoc+1),hl

	pop hl

	pop bc
	pop de

	ret


displaySongInfo:
	; Draw the large box:

	ld (textSmall+1),hl
	ld (textPos+1),de
	ld hl,plotsScreen+((12*21)+1)
	ld de,2
	ld a,$FF
	ld b,10
	call fillLine

	add hl,de
	xor a

	ld c,19
blankInfoLoop:
	ld b,10
	call fillLine
	add hl,de
	dec c
	jr nz,blankInfoLoop

	ld a,$FF
	ld b,10
	call fillLine
	add hl,de

	; Draw the sides

	ld hl,plotsScreen+(12*22)
	ld de,12
	ld c,%00000001

	ld b,19
	call drawSides
	
	ld hl,plotsScreen+((12*22)+11)
	ld c,%10000000

	ld b,19
	call drawSides


	; Now we have to fill in the text

	call loadSong
	call getNextString

	ld de,9+(22*256)
	ld (penCol),de
	bcall(_vPuts)
	ld de,9+(28*256)
	ld (penCol),de
	bcall(_vPuts)
	ld de,9+(34*256)
	ld (penCol),de
	bcall(_vPuts)


	call reloadAllButtons

	xor a
	call disableButton
	ld a,1
	call disableButton
	ld a,2
	call disableButton
	ld a,3
	call disableButton

	call ionFastCopy

waitHideInfo:
	bcall(_getCSC)
	cp skGraph
	jp z,drawGUILoop
	cp skClear
	jp z,drawGUILoop
	jr waitHideInfo

loadAndPlaySong:


	call loadSong

	ld b,4
scanForEndOfBlock:
	call getNextString
	djnz scanForEndOfBlock
	
	push hl

	call reloadAllButtons
	ld a,3
	call disableButton
	ld a,4
	call disableButton

	ld hl,txtPlaying
	ld de,34+(28*256)
	call drawSmallMessage
	call ionFastCopy

	pop ix
	xor a
	ld (repeatCount),a
	call playSong


	jp drawGUILoop


drawSmallMessage:
	ld (textSmall+1),hl
	ld (textPos+1),de
	ld hl,plotsScreen+((12*27)+3)
	ld de,6
	ld a,$FF
	ld b,12-6
	call fillLine
	add hl,de
	xor a
	ld c,7
blankPlayingLoop:
	ld b,12-6
	call fillLine
	add hl,de
	dec c
	jr nz,blankPlayingLoop

	ld a,$FF
	ld b,12-6
	call fillLine
	add hl,de

	; Draw the sides

	ld hl,plotsScreen+((12*28)+2)
	ld de,12
	ld c,%00000001

	ld b,7
	call drawSides
	
	ld hl,plotsScreen+((12*28)+9)
	ld c,%10000000

	ld b,7
	call drawSides

textPos:
	ld hl,0
	ld (penCol),hl
textSmall:
	ld hl,0
	bcall(_vPuts)
	ret

invertText:
	ld l,a
	ld h,0
	add hl,hl
	add hl,hl
	push hl
	add hl,hl
	pop de
	add hl,de
	ld de,plotsScreen
	add hl,de
	ld bc,12*7

invertTextLoop:
	ld a,(hl)
	cpl
	ld (hl),a
	inc hl
	dec bc
	ld a,b
	or c
	jr nz,invertTextLoop
	ret

fillLine:	
	ld (hl),a
	inc hl
	djnz fillLine
	ret

drawSides:
	ld a,c
	or (hl)
	ld (hl),a
	add hl,de
	djnz drawSides
	ret

getNextString:
	ld a,(hl)
	inc hl
	or a
	jr nz,getNextString
	ret

buttons:
 .db $7F,$FF,$EF,$FF,$FD,$FF,$FF,$BF,$FF,$F7,$FF,$FE
 .db $80,$00,$10,$00,$02,$00,$00,$40,$00,$08,$00,$01

reloadAllButtons:

	ld de,plotsScreen+((64-7)*12)
	xor a
	ld b,12*7
eraseLastLineLoop:
	ld (de),a
	inc de
	djnz eraseLastLineLoop

	ld hl,3+(57*256)
	ld (penCol),hl
	ld hl,txtButtons
	bcall(_vPuts)


	ld hl,buttons
	ld de,plotsScreen+((64-8)*12)
	ld bc,12
	ldir

	ld b,7
fillLowerButtonsLoop:
	push bc
	ld hl,buttons+12
	ld bc,12
drawButtonBarsLoop:
	ld a,(de)
	or (hl)
	ld (de),a
	inc hl
	inc de
	dec bc
	ld a,b
	or c
	jr nz,drawButtonBarsLoop
	pop bc
	djnz fillLowerButtonsLoop 


	ret

disableButton:
	ld c,a
	add a,a
	ld b,a
	add a,a
	add a,a
	add a,a
	add a,c
	add a,b
	inc a
	ld l,57
	ld b,7
	ld c,3
	ld ix,disableRegion
	call i_largeSprite
	ret

disableRegion:
	.db %10101010,%10101010,%10000000
	.db %01010101,%01010101,%01000000
	.db %10101010,%10101010,%10000000
	.db %01010101,%01010101,%01000000
	.db %10101010,%10101010,%10000000
	.db %01010101,%01010101,%01000000
	.db %10101010,%10101010,%10000000

i_largeSprite:
	di
	ex af,af'
	ld a,c
	push af
	ex af,af'
	ld e,l
	ld h,$00
	ld d,h
	add hl,de
	add hl,de
	add hl,hl
	add hl,hl
	ld e,a
	and $07
	ld c,a
	srl e
	srl e
	srl e
	add hl,de
	ld de,plotsScreen
	add hl,de
largeSpriteLoop1:
	push hl
largeSpriteLoop2:
	ld d,(ix)
	ld e,$00
	ld a,c
	or a
	jr z,largeSpriteSkip1
largeSpriteLoop3:
	srl d
	rr e
	dec a
	jr nz,largeSpriteLoop3
largeSpriteSkip1:
	ld a,(hl)
	or d
	ld (hl),a
	inc hl
	ld a,(hl)
	or e
	ld (hl),a
	inc ix
	ex af,af'
	dec a
	push af
	ex af,af'
	pop af
	jr nz,largeSpriteLoop2
	pop hl
	pop af
	push af
	ex af,af'
	ld de,$0C
	add hl,de
	djnz largeSpriteLoop1
	pop af
	ret

progSearchHeader:
	.db "QUAD1",0
txtPlaying:
	.db "Playing...",0
txtButtons:
	.db "Play   F. Fw   Stop    Info     Exit",0
	
; Main playing code
.include "Source/Quad.asm"