;Author: Patrick Stetter
;Program: Double Dragon
;Date:	
;Began		6.29.06
;Finished	7.30.06


#include	"ti83plus.inc"
#include	"mirage.inc"

PlayerX			.equ	AppBackUpScreen
PlayerY			.equ	AppBackUpScreen+1
PlayerPose		.equ	AppBackUpScreen+2
;0 = walk left
;2 = walk right
;4 = crouch left
;6 = crouch right
;8 = jump left
;9 = jump right
PlayerPose2		.equ	AppBackUpScreen+3
Jumptime		.equ	AppBackUpScreen+4
FirstTime		.equ	AppBackUpScreen+5
Floorcounter	.equ	AppBackUpScreen+6
Wallcounter		.equ	AppBackUpScreen+7
MapPointer		.equ	AppBackUpScreen+8
Maponoff		.equ	AppBackUpScreen+9
MapShift		.equ	AppBackUpScreen+10
Level			.equ	AppBackUpScreen+11
ObjLog			.equ	AppBackUpScreen+12
ObjectPosition	.equ	AppBackUpScreen+26
ObjectType		.equ	AppBackUpScreen+42
ObjectLaunch	.equ	AppBackUpScreen+43
BoxX			.equ	AppBackUpScreen+44
BoxY			.equ	AppBackUpScreen+45
BoxDirection	.equ	AppBackUpScreen+46
Objectholdtime	.equ	AppBackUpScreen+47
PunchPosition	.equ	AppBackUpScreen+48
KickPosition	.equ	AppBackUpScreen+49
Health			.equ	AppBackUpScreen+50
Lives			.equ	AppBackUpScreen+51
EnemiesUsed		.equ	AppBackUpScreen+52
EnemyList		.equ	AppBackUpScreen+53
EnemyPointer	.equ	AppBackUpScreen+114
EnemyDelay		.equ	AppBackUpScreen+115
Stamina			.equ	AppBackUpScreen+116
HasHit			.equ	AppBackUpScreen+117
PlayerFall		.equ	AppBackUpScreen+118
EnemyFall		.equ	AppBackUpScreen+119
WhichEnemyFell	.equ	AppBackUpScreen+120
ThumbsUp		.equ	AppBackUpScreen+121
NewLevelDisplay	.equ	AppBackUpScreen+122
LevelY			.equ	AppBackUpScreen+123
EnterTimer		.equ	AppBackUpScreen+124
MenSpriteY		.equ	AppBackUpScreen+125
EnemyTemp		.equ	AppBackUpScreen+126
StackSave		.equ	AppBackUpScreen+133
Flicker			.equ	AppBackUpScreen+135


	.org	$9d93
	.db	$BB,$6D
	ret
	.db	1
	.db	%00000011,%11000000
	.db	%01100100,%00100000
	.db	%01010110,%01100000
	.db	%01100100,%00100000
	.db	%00000010,%01000000
	.db	%00000100,%00100000
	.db	%00001000,%00010000
	.db	%00001010,%01010000
	.db	%00001110,%01110000
	.db	%00000100,%00100000
	.db	%00000100,%00100000
	.db	%00000011,%11001100
	.db	%00000100,%00101010
	.db	%00000100,%00101100
	.db	%00000100,%00100000
	.db	"Double Dragon",0


	
Opening:
	ld (StackSave),sp
	set Textwrite,(iy+SgrFlags)
	bcall(_runindicoff)
	bcall(_clrlcdfull)
	bcall(_grbufclr)
	bcall(_grbufcpy)
	ld bc,300
Openingloop:
	push bc
	ld hl,OpeningPicLayer1
	ld de,PlotsScreen
	ld bc,768
	ldir
	call ifastcopy
	ld hl,OpeningPicLayer2
	ld de,PlotsScreen
	ld bc,768
	ldir
	call ifastcopy
	ld a,$FD
	out (1),a
	nop
	nop
	in a,(1)
	cp $FE
	jr z,Menu
	pop bc
	dec bc
	ld a,c
	or b
	jr nz,Openingloop
	
Menu:
	bcall(_clrlcdfull)
	bcall(_grbufclr)
	bcall(_grbufcpy)
	ld hl,Menupic
	ld de,PlotsScreen
	ld bc,768
	ldir
	bcall(_grbufcpy)
	ld a,19
	ld (MenSpriteY),a
	ld hl,Playerright1
	ld b,15
	call putMensprite
Menuloop:
	bcall(_getcsc)
	cp skup
	jr nz,notMenuUp
	ld a,(MenSpriteY)
	cp 19
	jr z,Menuloop
	sub 8
	ld (MenSpriteY),a
	add a,8
	cp 51
	jr z,putbottomone
	ld e,a
	xor a
	ld b,15
	ld hl,Playerright1
	call putsprite
putbottomoneback:
	ld hl,Playerright1
	ld b,15
	call putMensprite
	jr Menuloop
putbottomone:
	ld e,a
	xor a
	ld b,13
	ld hl,Playerright1
	call putsprite
	jr putbottomoneback
notMenuUp:
	cp skdown
	jr nz,notMenuDown
	ld a,(MenSpriteY)
	cp 51
	jr z,Menuloop
	add a,8
	ld (MenSpriteY),a
	sub 8
	ld e,a
	xor a
	ld b,15
	ld hl,Playerright1
	call putsprite
	ld a,(MenSpriteY)
	cp 51
	jr z,putbottomsprite
	ld hl,Playerright1
	ld b,15
	call putMensprite
	jr Menuloop
putbottomsprite:
	ld b,13
	ld hl,Playerright1
	call putMensprite
	jr Menuloop
notMenuDown:
	cp skclear
	ret z
notMenuClear
	cp sk2nd
	jr nz,notMenu2nd
Blackout:
	ld a,(MenSpriteY)
	add a,5
	ld c,10
	ld b,85
blackoutloop:
	push bc
	push af
	ld h,c
	ld l,a
	ld d,c
	add a,7
	ld e,a
	ld a,1
	call fastline
	bcall(_grbufcpy)
	ei
	halt	
	pop af
	pop bc
	inc c
	djnz blackoutloop
	ld a,(MenSpriteY)
	sub 19
	srl a			;/2
	srl a			;/4
	ld d,0
	ld e,a
	ld hl,MenuVectorTable
	add hl,de
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	jp (hl)
notMenu2nd:
	cp sk1
	jr nz,notMenu1
	xor a
	jr MenuNumber
notMenu1:
	cp sk2
	jr nz,notMenu2
	ld a,1
	jr MenuNumber
notMenu2:
	cp sk3
	jr nz,notMenu3
	ld a,2
	jr MenuNumber
notMenu3:
	cp sk4
	jr nz,notMenu4
	ld a,3
	jr MenuNumber
notMenu4:
	cp sk5
	jr nz,notMenu5
	ld a,4
	jr MenuNumber
notMenu5:
	jp Menuloop
	
	
MenuNumber:
;Input a = Number pressed - 1
;puts cursor at correct place and initializes blackout
	add a,a
	add a,a
	add a,a		;x8
	add a,19
	ld (MenSpriteY),a
	push af
	bcall(_grbufclr)
	ld hl,Menupic
	ld de,PlotsScreen
	ld bc,768
	ldir
	ld hl,Playerright1
	pop af
	cp 47
	jr nc,putbottomspritenumber
	ld b,15
putbottomspritenumberback:
	call putMensprite
	jp Blackout
putbottomspritenumber:
	ld b,13
	jr putbottomspritenumberback
	
	
	
ContinueGame:
;need to load:
;Health
;Lives
;PlayerX
;Level
;MapPointer
;Score 9bytes
;EnemyDamageTable all 10 bytes of it
	ld hl,DDragonTxt
	rst 20h                   ;rMOV9TOOP1
	bcall(_ChkFindSym)
	jp c,Menu				;doesn't exist
	ld a,b
	or a
	jr z,load				;in ram
	bcall(_arc_unarc)				;in ram now 
load:
	inc de
	inc de					;2 byte header
	push de
	ld a,(de)
	or a
	jp z,cheater
	inc de
	ld a,(de)
	ld (Health),a
	inc de					;+3
	ld a,(de)
	ld (Lives),a
	inc de					;+4
	ld a,(de)
	ld (PlayerX),a
	inc de					;+5
	ld a,(de)
	ld (Level),a
	inc de					;+6
	ld a,(de)
	ld (MapPointer),a
	inc de					;+7
	ex de,hl
	ld de,Score
	ld bc,9
	ldir
	ld de,EnemyDamageTable
	ld bc,10
	ldir
	pop hl
	ld (hl),0
	push hl
	pop de
	inc de
	ld bc,28
	ldir
	ld hl,DDragonTxt
	rst 20h                   ;rMOV9TOOP1
	bcall(_ChkFindSym)
	bcall(_arc_unarc)		;archive it
	bcall(_grbufclr)
	ld a,40
	ld (PlayerY),a
	ld a,12
	ld (Stamina),a
	ld a,2
	ld (PlayerPose),a
	ld a,(MapPointer)
	dec a
	ld (EnemiesUsed),a
	xor a
	ld (NewLevelDisplay),a
	ld (Maponoff),a
	ld (PlayerPose2),a
	ld (MapShift),a
	ld (ObjectType),a
	ld (ObjectLaunch),a
	ld (PunchPosition),a
	ld (KickPosition),a
	ld (EnemyPointer),a
	ld (EnemyDelay),a
	ld (HasHit),a
	ld (PlayerFall),a
	ld (EnemyFall),a
	ld (ThumbsUp),a
	ld (EnterTimer),a
	call dispstats
	jp Mainloop
cheater:
	pop hl
	jp menu
	
	
	
	
	
	
HighScores:
	bcall(_grbufclr)
	bcall(_grbufcpy)
	ld hl,0
	ld (pencol),hl
	ld hl,HighScore
	rst 20h
	ld a,10
	bcall(_dispOp1a)
	ld hl,256*10
	ld (pencol),hl
	ld hl,HighScoreName
	call vputs
	bcall(_grbufcpy)
	bcall(_getkey)	
	jp Menu
Controls:
	bcall(_clrlcdfull)
	bcall(_grbufclr)	
	ld hl,0
	ld (pencol),hl
	ld hl,MsgControls
	call vputs
	bcall(_grbufcpy)
	bcall(_getkey)
	jp Menu
Quit:
	ret

vputsnl:
	ld a,(penrow)
	add a,7
	ld (penrow),a
	xor a
	ld (pencol),a
vputs:
	ld a,(hl)
	inc hl
	or a
	ret z
	cp $D6
	jr z,vputsnl
	bcall(_vputmap)
	jr vputs
	
	
	
NewGame:
	bcall(_grbufclr)
	ld hl,0
	ld (pencol),hl
	ld hl,msgDifficulty
	call vputs
	bcall(_grbufcpy)
NewGamekeyloop:
	bcall(_getcsc)
	cp sk1
	jr z,MakeGameEasy
	cp sk2
	jr z,MakeGameMedium
	cp sk3
	jr z,MakeGameHard
	cp skclear
	jp z,Menu
	jr NewGamekeyloop
MakeGameEasy:
	ld hl,BackUpEnemyDamageTable
	ld de,EnemyDamageTable
	ld bc,10
	ldir
	jr NewGameBegin
MakeGameMedium:
	ld hl,BackUpEnemyDamageTable
	ld de,EnemyDamageTable
	ld bc,10
	ld a,5
	ld hl,GuyGirlDamagePunchKick
	add a,(hl)
	ld (hl),a
	inc hl
	inc hl
	ld a,5
	add a,(hl)
	ld (hl),a
	inc hl
	inc hl
	ld a,10
	add a,(hl)
	ld (hl),a
	inc hl
	inc hl
	ld a,10
	add a,(hl)
	ld (hl),a
	inc hl
	inc hl
	ld a,10
	add a,(hl)
	ld (hl),a
	inc hl
	inc hl
	ld a,25
	add a,(hl)
	ld (hl),a
	jr NewGameBegin
MakeGameHard:
	ld hl,BackUpEnemyDamageTable
	ld de,EnemyDamageTable
	ld bc,10
	ld a,10
	ld hl,GuyGirlDamagePunchKick
	add a,(hl)
	ld (hl),a
	inc hl
	inc hl
	ld a,10
	add a,(hl)
	ld (hl),a
	inc hl
	inc hl
	ld a,20
	add a,(hl)
	ld (hl),a
	inc hl
	inc hl
	ld a,20
	add a,(hl)
	ld (hl),a
	inc hl
	inc hl
	ld a,20
	add a,(hl)
	ld (hl),a
	inc hl
	inc hl
	ld a,50
	add a,(hl)
	ld (hl),a

NewGameBegin:
	call IntroMovie
	bcall(_grbufclr)
	ld a,40
	ld (PlayerY),a
	ld a,46
	ld (Health),a
	ld a,12
	ld (Stamina),a
	ld a,5
	ld (PlayerX),a
	dec a
	dec a				;a = 3
	ld (Lives),a
	dec a				;a = 2
	ld (PlayerPose),a
	dec a				;a = 1
	ld (FirstTime),a
	ld (NewLevelDisplay),a
	xor a
	ld (MapPointer),a
	ld (Maponoff),a
	ld (PlayerPose2),a
	ld (MapShift),a
	ld (Level),a
	ld (ObjectType),a
	ld (ObjectLaunch),a
	ld (PunchPosition),a
	ld (KickPosition),a
	ld (EnemiesUsed),a
	ld (EnemyPointer),a
	ld (EnemyDelay),a
	ld (Score),a
	ld (HasHit),a
	ld (PlayerFall),a
	ld (EnemyFall),a
	ld (ThumbsUp),a
	ld (EnterTimer),a
	ld a,$80
	ld (Score+1),a
	ld b,7
	ld hl,Score+2
	xor a
clearScore:
	ld (hl),a
	inc hl
	djnz clearScore
	ld b,60				;a = 0
	ld hl,EnemyList
clearEnemyList:
	ld (hl),a
	inc hl
	djnz clearEnemyList
	call clearObjPosition
	call dispstats


Mainloop:
	call jump
	call boxjump
	call refresh
	ld a,(NewLevelDisplay)
	or a
	jp nz,NewLevelSetup
	call getkey
;0 = %0000 = no arrows pressed
;1 = %0001 = down
;2 = %0010 = left
;3 = %0011 = left + down
;4 = %0100 = right
;5 = %0101 = right + down
;6 = %0110 = right + left
;7 = %0111 = right + left + down
;8 = %1000 = up
;9 = %1001 = up + down
;10 = %1010 = up + left
;11 = %1011 = up + left + down
;12 = %1100 = up + right
;13 = %1101 = up + right + down
;14 = %1110 = up + right + left
;15 = %1111 = all four keys pressed
;16 = clear
;17 = X,T,Theta,n/Link
;18 = 2nd
;19 = Alpha
;20 = Enter
;21 = Sto->
	cp 4
	jr nz,notright
	ld a,(PlayerFall)
	or a
	jr nz,Mainloop
	ld a,(PlayerPose)
	cp 7
	jp nc,mainjumpmoveright
MoveRight:
	ld a,2
	ld (PlayerPose),a
	ld hl,PlayerPose2
	inc (hl)
	ld a,(PlayerX)
	cp 86
	jr nc,Mainloop
	cp 65
	jp nc,shiftmap
MoveRightnotshift:
	ld a,(PlayerX)
	inc a
	ld (PlayerX),a
	jr Mainloop
notright:
	cp 2
	jr nz,notleft
	ld a,(PlayerFall)
	or a
	jr nz,Mainloop
	ld a,(PlayerPose)
	cp 7
	jp nc,mainjumpmoveleft
Moveleft:
	xor a
	ld (PlayerPose),a
	ld hl,PlayerPose2
	inc (hl)
	ld a,(PlayerX)
	cp 5
	jr z,Mainloop
	dec a
	ld (PlayerX),a
	jr Mainloop
notleft:
	cp 1
	jr nz,notdown
	ld a,(PlayerFall)
	or a
	jr nz,Mainloop
	ld a,(PlayerPose)
	cp 7
	jr nc,Mainloop
	ld a,(ObjectType)
	or a
	jp nz,Mainloop
	ld a,(PunchPosition)
	or a
	jp nz,Mainloop
	ld a,(KickPosition)
	or a
	jp nz,Mainloop
	ld a,(PlayerPose)
	or a
	jp z,maincrouchleft
	cp 4
	jp z,maincrouchleft
	jp maincrouchright
notdown:
	cp 3
	jr nz,notdownleft
	ld a,(PlayerFall)
	or a
	jp nz,Mainloop
	ld a,(ObjectType)
	or a
	jr nz,MoveLeft
	ld a,(PunchPosition)
	or a
	jr nz,MoveLeft
	ld a,(KickPosition)
	or a
	jr nz,MoveLeft
	ld a,(PlayerPose)
	cp 7
	jp nc,mainjumpmoveleft
	ld a,4
	ld (PlayerPose),a
	ld hl,PlayerPose2
	inc (hl)
	ld a,(PlayerX)
	or a
	jp z,Mainloop
	dec a
	ld (PlayerX),a
	jp Mainloop
notdownleft:
	cp 5
	jr nz,notdownright
	ld a,(PlayerFall)
	or a
	jp nz,Mainloop
	ld a,(ObjectType)
	or a
	jp nz,MoveRight
	ld a,(PunchPosition)
	or a
	jp nz,MoveRight
	ld a,(KickPosition)
	or a
	jp nz,MoveRight
	ld a,(PlayerPose)
	cp 7
	jp nc,mainjumpmoveright
	ld a,6
	ld (PlayerPose),a
	ld hl,(PlayerPose2)
	inc (hl)
	ld a,(PlayerX)
	cp 86
	jp nc,Mainloop
	cp 70
	jp nc,shiftmap
	inc a
	ld (PlayerX),a
	jp Mainloop
notdownright:
	cp 16
	jp nz,notclear
	jp PauseMenu
notclear:
	or a
	jp nz,notnothing
	ld a,1
	ld (ObjectHoldTime),a  ;allow the user to drop the object after they picked it up and released
	ld a,(PlayerFall)
	or a
	jp nz,Mainloop
	ld a,(PlayerPose)
	cp 4
	jp c,Mainloop
	cp 7
	jp nc,Mainloop
	ld a,(PlayerPose)
	sub 4			;Standup if you don't press anything
	ld (PlayerPose),a
	jp Mainloop
notnothing:
	cp 8
	jp nz,notup
	ld a,(PlayerFall)
	or a
	jp nz,Mainloop
	ld a,(ObjectType)
	or a
	jp nz,Mainloop
	ld a,(PunchPosition)
	or a
	jp nz,Mainloop
	ld a,(KickPosition)
	or a
	jp nz,Mainloop
	ld a,(PlayerPose)
	cp 7
	jp nc,Mainloop
	or a
	jr z,mainjumpleft
	cp 4
	jr z,mainjumpleft
mainjumpright:
	ld a,9
	ld (PlayerPose),a
	xor a
	ld (PlayerPose2),a
	ld a,25
	ld (JumpTime),a	
	jp Mainloop
mainjumpleft:
	ld a,8
	ld (PlayerPose),a
	xor a
	ld (PlayerPose2),a
	ld a,25
	ld (JumpTime),a
	jp Mainloop
notup:
	cp 10
	jr nz,notupleft
	ld a,(PlayerFall)
	or a
	jp nz,Mainloop
mainjumpmoveleft:
	ld a,(ObjectType)
	or a
	jp nz,MoveLeft
	ld a,(PunchPosition)
	or a
	jp nz,MoveLeft
	ld a,(KickPosition)
	or a
	jp nz,MoveLeft
	ld a,(PlayerPose)
	cp 7
	jr c,mainjumpleft
	ld a,8
	ld (PlayerPose),a
	ld a,(PlayerX)
	or a
	jp z,Mainloop
	dec a
	ld (PlayerX),a
	jp Mainloop	
notupleft:
	cp 12
	jr nz,notupright
	ld a,(PlayerFall)
	or a
	jp nz,Mainloop
mainjumpmoveright:
	ld a,(ObjectType)
	or a
	jp nz,MoveRight
	ld a,(PunchPosition)
	or a
	jp nz,MoveRight
	ld a,(KickPosition)
	or a
	jp nz,MoveRight
	ld a,(PlayerPose)
	cp 7
	jp c,mainjumpright
	ld a,9
	ld (PlayerPose),a
	ld a,(PlayerX)
	cp 86
	jp z,Mainloop
	cp 70
	jp nc,shiftmap
	inc a
	ld (PlayerX),a
	jp Mainloop	
notupright:
	cp 17
	jr nz,notLink
	ld a,(PlayerFall)
	or a
	jp nz,Mainloop
	ld a,(PlayerPose)
	cp 3
	jp nc,Mainloop
	ld a,(PunchPosition)
	or a
	jp nz,Mainloop
	ld a,(KickPosition)
	or a
	jp nz,MainLoop
	ld a,(ObjectType)
	or a
	call nz,dropobject
	call isobjthere
	or a
	jp z,Mainloop
pickup:
	ld (ObjectType),a
	xor a
	ld (ObjectHoldTime),a	
	jp Mainloop
notLink:
	cp 18
	jr nz,not2nd
	ld a,(PlayerFall)
	or a
	jp nz,Mainloop
	ld a,(KickPosition)
	or a
	jp nz,Mainloop
	ld a,(PunchPosition)
	or a
	jp nz,Mainloop
	ld a,(PlayerPose)
	cp 3
	jp nc,Mainloop
	ld a,(ObjectType)
	or a
	jp z,punch
	ld a,(ObjectLaunch)
	or a
	jp nz,Mainloop
	inc a        ; a = 1
	ld (ObjectLaunch),a
	jp Mainloop
not2nd:
	cp 19
	jr nz,notAlpha
	ld a,(PlayerFall)
	or a
	jp nz,Mainloop
	ld a,(PunchPosition)
	or a
	jp nz,Mainloop
	ld a,(PlayerPose)
	cp 3
	jp nc,Mainloop
	ld a,(ObjectType)
	or a
	jp nz, Mainloop
	ld a,(ObjectLaunch)
	or a
	jp nz,Mainloop
	ld a,(KickPosition)
	or a
	jp nz,Mainloop
	inc a		;a = 1
	ld (KickPosition),a
	jp Mainloop	
notAlpha:
	cp 20
	jr nz,notEnter
	ld a,(EnterTimer)
	or a
	jp nz,Mainloop
	xor a
	bcall(_getkey)
pauseloop:
	bcall(_getkey)
	cp kEnter
	jr nz,pauseloop
	ld a,25
	ld (EnterTimer),a
	jp Mainloop
notEnter:
	cp 21
	jr nz,notSto
   	call quittoshell
notSto:
	jp Mainloop
	
	
maincrouchleft:
	ld a,4
	ld (PlayerPose),a
	jp Mainloop
maincrouchright:
	ld a,6
	ld (PlayerPose),a
	jp Mainloop


shiftmap:
	ld a,(EnemyPointer)
	or a
	jp nz,MoveRightnotshift
	ld a,(MapPointer)
	cp 15
	jp nc,MoveRightnotshift	
	ld hl,PlayerPose2
	inc (hl)
	ld a,(MapShift)
	cp 15
	jr z,bigshift
	inc a              ;insert can shift routine here later
	ld (Mapshift),a   
	jp Mainloop
bigshift:
	ld a,(MapPointer)
	add a,7
	cp 15
	jr z,nextlevel
	sub 7
	inc a
	ld (MapPointer),a
	xor a
	ld (Mapshift),a
	jp Mainloop
nextlevel:
	ld hl,Level
	inc (hl)
	ld a,(hl)
	cp 10
	jp nc,YouWon
	xor a
	ld (MapPointer),a
	ld (Mapshift),a
	call clearObjPosition
	ld hl,GuyGirlDamagePunchKick
	inc (hl)
	inc (hl)
	inc hl
	inc hl
	inc (hl)
	inc (hl)
	inc (hl)
	inc (hl)
	inc (hl)
	inc hl
	inc hl
	ld a,(hl)
	add a,5
	ld (hl),a
	inc hl
	inc hl
	ld a,(hl)
	add a,5
	ld (hl),a
	inc hl
	inc hl
	ld a,(hl)
	add a,10
	ld (hl),a
	ld a,1
	ld (NewLevelDisplay),a
	jp Mainloop
	
clearObjPosition:
	ld hl,ObjectPosition
	ld b,15
	xor a 
clearObjectPosition:
	ld (hl),a
	inc hl
	djnz clearObjectPosition
	ret
	
punch:
	ld a,1
	ld (PunchPosition),a
	jp MainLoop
	
	
	
	
	
;Routines
refresh:
;0 = walk left
;2 = walk right
;4 = crouch left
;6 = crouch right
;8 = jump left
;9 = jump right
	ld a,(EnterTimer)
	or a
	call nz,DecreaseEnterTimer
	ld a,(NewLevelDisplay)
	or a
	jr nz,nobackorfloordisplay
	call displayfloor
	call loadmap
	call dispobjects
nobackorfloordisplay:
	ld a,(PunchPosition)
	or a
	jp nz,DisplayPlayerPunch
	ld a,(KickPosition)
	or a
	jp nz,DisplayPlayerKick
	ld a,(PlayerFall)
	or a
	jp nz,DisplayPlayerFall
	ld a,(PlayerPose)
	ld b,a
	ld a,(PlayerPose2)
	rra
	ld a,b
	adc a,0
	ld b,a
	add a,a  ;2
	add a,a  ;4
	add a,a  ;8
	add a,a  ;16
	sub b    ;15
	ld hl,SpriteTable
	ld d,0
	ld e,a
	add hl,de
	ld b,15
	ld a,(PlayerY)
	ld e,a
	ld a,(PlayerX)
	call putsprite
returnPlayerPunch:	
	ld a,(ObjectType)
	or a
	jr z,noobjectdisplay
	ld a,(ObjectLaunch)
	or a
	jr nz,displayobjectlaunch
	call displayObject
noobjectdisplay:
	call addMoreEnemies
	ld a,(EnemyPointer)
	cp 2
	call nc,whichAIIsCloser
	call moveai
	call dispenemies
	ld a,(PlayerPose)
	cp 7
	jr c,nohitdetectJump
	call hitdetectJump
;returns a = 0: no hit, a = 1: hit
	or a
	jr z,nohitdetectJump
	ld hl,JumpDamage
	xor a
	call CauseDamage
nohitdetectJump:
	ld a,(ThumbsUp)
	or a
	jr z,nodispthumbsup
	call dispThumbsup
nodispthumbsup:
	call ifastcopy
	ret
displayobjectlaunch:
	call displayobjectmove
	jr noobjectdisplay

	
	
	

putsprite:
;hl=address of sprite
;e=y
;a=x
;b=rows	
	push af
	pop af
	push hl
	call getplot
	pop de           ;de = PlayerBuffer, hl = Plots
	and 7
	jr z,aligned
outerloopa:
	push bc
	push af
	ld b,a
	ex de,hl
	ld c,(hl)
	inc hl
	ex de,hl
	xor a
shiftloopa:
	srl c
	rra
	djnz shiftloopa
	inc hl
	or (hl)
	ld (hl),a
	dec hl
	ld a,c
	or (hl)
	ld (hl),a
	ld bc,12
	add hl,bc
	pop af
	pop bc
	djnz outerloopa
	ret
aligned:
	push bc
	ex de,hl
	ld a,(hl)
	inc hl
	ex de,hl
	or (hl)
	ld (hl),a
	ld bc,12
	add hl,bc
	pop bc
	djnz aligned
	ret
	
getplot:
	ld h,0
	ld d,h
	ld l,e
	add hl,hl
	add hl,de
	add hl,hl
	add hl,hl
	ld e,a
	srl e
	srl e
	srl e
	add hl,de
	ld de,plotsScreen
	add hl,de
	ret
	
	
	
getkey:
;0 = %0000 = no arrows pressed
;1 = %0001 = down
;2 = %0010 = left
;3 = %0011 = left + down
;4 = %0100 = right
;5 = %0101 = right + down
;6 = %0110 = right + left
;7 = %0111 = right + left + down
;8 = %1000 = up
;9 = %1001 = up + down
;10 = %1010 = up + left
;11 = %1011 = up + left + down
;12 = %1100 = up + right
;13 = %1101 = up + right + down
;14 = %1110 = up + right + left
;15 = %1111 = all four keys pressed
;16 = clear
;17 = X,T,Theta,n/Link
;18 = 2nd
;19 = Alpha
;20 = Enter
;21 = Sto->
	ld a,$BF
	out (1),a
	nop
	nop
	in a,(1)
	cp $DF
	jr nz,getkeynot2nd
	ld a,18
	ret
getkeynot2nd:
	ld a,$DF
	out (1),a
	nop
	nop
	in a,(1)
	cp $7F
	jr nz,getkeynotAlpha
	ld a,19
	ret
getkeynotAlpha:
	cp $FD
	jr nz,getkeynotSto
	ld a,21
	ret
getkeynotSto:
	ld a,$FD
	out (1),a
	nop
	nop
	in a,(1)
	cp $BF
	jr nz,getkeynotclear
	ld a,16
	ret
getkeynotclear:
	cp $FE
	jr nz,getkeynotenter
	ld a,20
	ret
getkeynotenter:
	ld a,$EF
	out (1),a
	nop
	nop
	in a,(1)
	cp $7F
	jr nz,getkeynotLink
	ld a,17
	ret
getkeynotLink:
	ld a,$FE
	out (1),a
	nop
	nop
	in a,(1)
	cpl
	or a
	ret nz
getkeynothing:
	xor a
	ret
	
	
	
	
jump:
	ld a,(PlayerPose)
	cp 7
	ret c
	ld a,(JumpTime)
	or a
	jr z,jumpfall
	dec a
	ld (JumpTime),a
	ld hl,PlayerY
	dec (hl)
	ret
jumpfall:
	ld a,(PlayerY)
	cp 40
	jr z,stopjump
	inc a
	ld (PlayerY),a
	ret
stopjump:
	xor a
	ld (HasHit),a
	ld a,(PlayerPose)
	cp 8
	jr z,landleft
	ld a,2
	ld (PlayerPose),a
	ret
landleft:
	xor a
	ld (PlayerPose),a
	ret
	
	
displayfloor:
	call clearfloor
	ld a,(Floorcounter)
	rra
	jr c,displayfloor2
	ld a,(Floorcounter)
	inc a
	ld (Floorcounter),a
	ld b,12
	xor a
floordisplayloop:
	push bc
	push af
	ld hl,Floor1Layer1
	ld e,55
	ld b,7
	call putsprite
	pop af
	add a,8
	pop bc
	djnz floordisplayloop
	ret
displayfloor2:
	ld a,(Floorcounter)
	inc a
	ld (Floorcounter),a	
	ld b,12
	xor a
floordisplayloop2:
	push bc
	push af
	ld hl,Floor1Layer2
	ld e,55
	ld b,7
	call putsprite
	pop af
	add a,8
	pop bc
	djnz floordisplayloop2
	ret
clearfloor:
	ld hl,PlotsScreen+612
	xor a
	ld b,108
clearfloorloop:
	ld (hl),a
	inc hl
	djnz clearfloorloop
	ret
	
	
loadmap:
	ld a,(Maponoff)
	or a
	jr nz,mapoff
	inc a
	ld (Maponoff),a	
	ld b,6
	ld a,(MapPointer)
	ld c,0
loadloop:
	push bc
	push af
	ld a,(Level)
	add a,a
	ld hl,Levels
	ld d,0
	ld e,a
	add hl,de   ;Hl = Level1	
	ld a,(hl)
	ld e,a
	inc hl
	ld a,(hl)
	ld d,a
	ex de,hl	;HL = .dw Wall1Level1
	pop af
	push af
	add a,a
	ld d,0
	ld e,a
	add hl,de	;HL = .dw correct wall
	ld a,(hl)
	ld e,a
	inc hl
	ld a,(hl)
	ld d,a
	ex de,hl 	;HL = data from correct wall
	pop af
	pop bc
	push bc
	push af
	ld a,c
	ld b,45
	ld e,10
	call putsprite16bit
	pop af
	pop bc
	push af
	ld a,c
	add a,16
	ld c,a
	pop af
	inc a
	cp 15
	ret nc
	djnz loadloop
	ld a,(MapShift)
	or a
	jr nz,loadlastone
	ret
	
loadlastone:
	ld hl,Levels
	ld a,(Level)
	add a,a
	ld e,a
	ld d,0
	add hl,de
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl		;HL = Level1
	ld a,(MapPointer)
	add a,6
	add a,a
	ld d,0
	ld e,a
	add hl,de       ;HL = Wall1
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	call putlastwall
	ret
	
	
	
	
	
mapoff:
	xor a
	ld (Maponoff),a
	ld hl,PlotsScreen+(12*10)
	ld bc,12*45
mapoffloop:
	xor a
	ld (hl),a
	inc hl
	dec bc
	ld a,c
	or b
	jr nz,mapoffloop
	ret
	
putsprite16bit:
;hl=address of sprite
;e=y
;a=x
;b=rows
;16pixels per row
	push af
	ld a,(MapShift)
	ld d,a
	or a
	jr z,dontshift
	pop af
	or a
	jr z,shiftleft
	sub d
putsprite16bitdontshift:
	push af
dontshift:
	pop af
	push hl
	call getplot
	pop de
	and 7
	jr z,aligneda
outerloopab:
	push bc
	push af
	ld b,a
	ex de,hl
	ld c,(hl)
	inc hl
	ex de,hl
	xor a
shiftloopabc:
	srl c
	rra
	djnz shiftloopabc
	inc hl
	or (hl)
	ld (hl),a
	dec hl
	ld a,c
	or (hl)
	ld (hl),a
	inc hl
	pop af
	push af
	ld b,a
	ex de,hl
	ld c,(hl)
	inc hl
	ex de,hl
	xor a
shiftloopab:
	srl c
	rra
	djnz shiftloopab
	inc hl
	or (hl)
	ld (hl),a
	dec hl
	ld a,c
	or (hl)
	ld (hl),a
	ld bc,11
	add hl,bc	
	pop af
	pop bc
	djnz outerloopab
	ret
aligneda:
	push bc
	ex de,hl
	ld a,(hl)
	inc hl
	ex de,hl
	or (hl)
	ld (hl),a
	inc hl
	ex de,hl
	ld a,(hl)
	inc hl
	ex de,hl
	or (hl)
	ld (hl),a	
	ld bc,11
	add hl,bc
	pop bc
	djnz aligneda
	ret
	
Shiftleft:
	push hl
	call getplot
	pop de
alignedsl:
	push bc
	ex de,hl
	ld a,(hl)
	ld c,a
	inc hl
	ld a,(Mapshift)
	ld b,a
	ld a,(hl)
	inc hl
shiftleftloop:
	sla a
	rl  c
	djnz shiftleftloop
	ex de,hl
	ld b,a
	ld a,c
	or (hl)
	ld (hl),a
	inc hl
	ld a,b
	or (hl)
	ld (hl),a
	dec hl
	ld bc,12
	add hl,bc
	pop bc
	djnz alignedsl
	ret
	
Putlastwall:
	ld b,45
	ld de,PlotsScreen+130
rightloop:
	push bc
	ld a,(Mapshift)
	ld b,a
	ld a,16
	sub b    ;a = shifts
	ld b,a
	ld c,(hl)
	inc hl
	ld a,(hl)
	inc hl
shiftrightloop:
	srl c
	rra
	djnz shiftrightloop
	ex de,hl
	ld b,a
	ld a,c
	or (hl)
	ld (hl),a
	inc hl
	ld a,b
	or (hl)
	ld (hl),a
	dec hl
	ld bc,12
	add hl,bc
	pop bc
	ex de,hl
	djnz rightloop
	ret
	
dispobjects:
	ld b,6
	ld a,(MapPointer)
	ld c,0
Objloadloop:
	push bc
	push af
	ld hl,ObjectPosition
	pop af
	push af
	inc a
	ld e,a
	ld d,0
	add hl,de
	ld a,(hl)
	or a
	jr nz,objnothing	;if it has been picked up, don't display it
	ld a,(Level)
	add a,a
	ld hl,ObjLevels
	ld d,0
	ld e,a
	add hl,de   ;Hl = ObjLevel1	
	ld a,(hl)
	ld e,a
	inc hl
	ld a,(hl)
	ld d,a
	ex de,hl	;HL = .dw box
	pop af
	push af
	add a,a
	ld d,0
	ld e,a
	add hl,de	;HL = .dw correct object
	call objlogtype
	ld a,(hl)
	ld e,a
	inc hl
	ld a,(hl)
	ld d,a
	or e
	jr z,objnothing
	ex de,hl 	;HL = data from correct object
	pop af
	pop bc
	push bc
	push af
	ld b,c
	ld a,(MapShift)
	ld c,a
	ld a,b
	sub c
	jr c,objnothing
	pop de
	pop bc
	push bc
	push de
	call objlogx
	ld b,5
	ld e,50
	call putsprite
objnothing:
	pop af
	pop bc
	push af
	ld a,c
	add a,16
	ld c,a
	pop af
	inc a
	djnz Objloadloop
	ret
	
Objlogx:
;stores x coordinate
;format:  (x,type),(x,type)...
;type:
;0 = nothing
;1 = box
;2 = pipe
;3 = ax
;6 total		
	push hl
	push af
	call findobjlog
	pop af
	ld (hl),a
	pop hl
	ret
Objlogtype:
	push af
	push bc
	push de
	push hl
	ld a,(hl)
	ld e,a
	inc hl
	ld a,(hl)
	dec hl
	or e
	jr z,objlogblank
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	inc hl
	inc hl	;identify by the third byte of each
	ld a,(hl)
	cp $81
	jr nz,notbox
	call findobjlog
	ld a,1
	inc hl
	ld (hl),a
	pop hl
	pop de
	pop bc
	pop af
	ret
notbox:
	cp $FE
	jr nz,notpipe
	call findobjlog
	ld a,2
	inc hl
	ld (hl),a
	pop hl
	pop de
	pop bc
	pop af
	ret
notpipe:
	call findobjlog
	ld a,3
	inc hl
	ld (hl),a
	pop hl
	pop de
	pop bc
	pop af
	ret
objlogblank:
	call findobjlog
	xor a
	ld (hl),a
	inc hl
	ld (hl),a
	pop hl
	pop de
	pop bc
	pop af
	ret	
findobjlog:
	ld hl,Objlog
	ld a,b
	add a,a
	ld e,a
	ld d,0
	add hl,de
	ret
	
	
isobjthere:
;0 = no
;1 = yes
;if yes, Object will be killed, a = type
	ld hl,Objlog+2
	ld b,6
findanobject:
	ld a,(hl)
	or a
	jr nz,isitinrange
findanotherobject:
	inc hl
	inc hl
	djnz findanobject
	xor a
	ret
isitinrange:
	push bc
	push af
	ld b,a
	ld a,(PlayerX)
	add a,8
	sub b
	jr c,notinrange
	ld a,(PlayerX)
	ld b,a
	pop af
	add a,8
	sub b
	jr c,notinrange2
	;it's in range.  Pick that sucker up and kill it from being displayed
	inc hl
	ld a,(hl)
	pop bc
	push af
	ld a,(MapPointer)
	add a,b
	ld hl,ObjectPosition
	ld e,a
	ld d,0
	add hl,de
	ld a,(hl)
	or a
	jr nz,alreadypickedup
	ld a,1
	ld (hl),a
	pop af
	ret
notinrange:
	pop af
	pop bc
	jr findanotherobject
notinrange2:
	pop bc
	jr findanotherobject
alreadypickedup:
	pop af
	xor a
	ret
	
	
displayObject:
;Displays the object in object type in the correct position
;If it is a box, it will be displayed over the persons head at X = PlayerX Y = PlayerY-5
;If it is a pipe, it will be displayed verticle with side pointing out from player based on the way the player faces X=PlayerX-3 Y = PlayerY+1,  X=PlayerX+8  Y = PlayerY+1
;If it is an ax, it will be displayed verticle with side pointing out from player based on the way the player faces  X=PlayerX-2   Y = PlayerY+1,  X=PlayerX+8  Y = PlayerY+1
	ld a,(ObjectType)	
	cp 1
	jr nz,dontdisplaybox
	ld a,(PlayerY)
	sub 5
	ld e,a
	ld a,(PlayerX)
	ld b,5
	ld hl,Box
	jr displayObjectjoin
dontdisplaybox:
	cp 2
	jr nz,dontdisplaypipe
	ld a,(PlayerPose)
	or a
	jr nz,dontdisplaypipeleft
	ld a,(PlayerY)
	add a,1
	ld e,a
	ld a,(PlayerX)
	sub 3
	ld b,7
	ld hl,PipeLeft
	jr displayObjectjoin
dontdisplaypipeleft:
	ld a,(PlayerY)
	add a,1
	ld e,a
	ld a,(PlayerX)
	add a,8
	ld b,7
	ld hl,PipeRight
	jr displayObjectjoin
dontdisplaypipe:
	ld a,(PlayerPose)
	or a
	jr nz,dontdisplayaxleft
	ld a,(PlayerY)
	add a,1
	ld e,a
	ld a,(PlayerX)
	sub 2
	ld b,7
	ld hl,AxLeft
	jr displayObjectjoin
dontdisplayaxleft
	ld a,(PlayerY)
	add a,1
	ld e,a
	ld a,(PlayerX)
	add a,8
	ld b,7
	ld hl,AxRight
displayObjectjoin:
	call putsprite
	ret
	
boxjump:
;Continue the path of the box if it needs to be moved in BoxDirection
;BoxDirection = 0, Move left
;BoxDirection = 1, Move right
;Moves every other refresh, increases object launch each time
	ld a,(ObjectType)
	or a
	ret z
	cp 2
	ret nc
	ld a,(ObjectLaunch)
	or a
	ret z
	cp 1
	call z,boxjumpfirst
	ld a,(ObjectLaunch)
	inc a
	ld (ObjectLaunch),a
	rra
	ret nc
	ld a,(BoxDirection)
	or a
	jr z,boxjumpleft
boxjumpright:
	ld hl,boxX
	inc (hl)
	inc hl
	inc (hl)
	ld a,(hl)
	cp 55
	jr z,stopbox
	ret
boxjumpleft:
	ld hl,boxX
	dec (hl)
	inc hl
	inc (hl)
	ld a,(hl)
	cp 51
	ret nz
stopbox:
	xor a
	ld (ObjectType),a
	ld (ObjectLaunch),a
	ld (HasHit),a
	ret
boxjumpfirst:
	ld a,(PlayerX)
	ld (boxX),a
	ld a,(PlayerY)
	sub 5
	ld (BoxY),a
	ld a,(PlayerPose)
	or a
	jr nz,boxjumpfirstright
	xor a
	ld (BoxDirection),a
	jr boxjumpfirstfinish
boxjumpfirstright:
	ld a,1
	ld (boxDirection),a
boxjumpfirstfinish:
	ld a,2
	ld (ObjectLaunch),a
	ret
	

Displayobjectmove:
;If it's a box, it will display at current BoxX and BoxY
;If it's a pipe, displays according to chart
;If it's an ax, displays according to chart

;box
	ld a,(ObjectType)
	cp 1
	jr nz,displayobjectmovenotbox
	ld hl,Box
;Recieve:
;c = 0: Right, c = 1: Left
;b = Height in pixels
;hl = address of sprite
;a = Xval
;8 bit sprite
;e = 0: Player, e = 1: Enemy
;
;Return:
;d = 0: No hit, d = 1: Hit
;If Hit:
;e = Pointer to enemy that it hit, or 254 = Hit Player
;BoxDirection = 0, Move left
;BoxDirection = 1, Move right
	ld a,(BoxDirection)
	ld b,a
	ld a,1
	sub b
	ld c,a 
	ld b,5
	ld a,(BoxX)
	ld e,0
	call hitdetect
	ld a,d
	or a
;for some reason I can't jump here
	jp z,noboxdamage
	xor a
	ld hl,BoxDamage
	call CauseDamage
noboxdamage:
	ld b,5		
	ld a,(BoxY)
	ld e,a
	ld a,(BoxX)
	call putsprite
	ret
	
displayobjectmovenotbox:
	cp 2
	jr nz,displayobjectmovenotpipe
;pipe
	ld a,(PlayerPose)
	or a
	jr nz,displaypipemoveright
	ld a,(ObjectLaunch)
	cp 11
	jr nc,notpipefirst
pipefirst:
	ld a,(PlayerY)
	add a,6
	ld e,a
	ld a,(PlayerX)
	add a,6
	ld hl,Piperight1
	ld b,5
	jp displaymovepipejoin
notpipefirst:
	cp 21
	jp c,displaymovepipejoin2
notpipesecond:
	ld a,(PlayerY)
	add a,7
	ld e,a
	ld a,(PlayerX)
	sub 7
	ld hl,Pipeleft1
	ld b,3
	jp displaymovepipejoin
	
displaypipemoveright:
	ld a,(ObjectLaunch)
	cp 11
	jr nc,notpiperightfirst
	ld a,(PlayerY)
	add a,7
	ld e,a
	ld a,(PlayerX)
	sub 6
	ld hl,Pipeleft1
	ld b,3
	jp displaymovepipejoin
notpiperightfirst:
	cp 21
	jp c,displaymovepipejoin2
notpiperightsecond:
	ld a,(PlayerY)
	add a,5
	ld e,a
	ld a,(PlayerX)
	add a,7
	ld hl,Piperight1
	ld b,5
	jp displaymovepipejoin
	
displayobjectmovenotpipe:
;ax
	ld a,(PlayerPose)
	or a
	jr nz,displayaxmoveright
	ld a,(ObjectLaunch)
	cp 5
	jr nc,notaxfirst
axfirst:
	ld a,(PlayerY)
	add a,2
	ld e,a
	ld a,(PlayerX)
	sub 7
	ld hl,axleft1
	ld b,6
	jr displaymoveobjectjoin
notaxfirst:
	cp 9
	jr c,axfirst
	ld a,(PlayerY)
	add a,7
	ld e,a
	ld a,(PlayerX)
	sub 7
	ld hl,axleft2
	ld b,2
	jr displaymoveobjectjoin

displayaxmoveright:
	ld a,(ObjectLaunch)
	cp 5
	jr nc,notaxrightfirst
axrightfirst:
	ld a,(PlayerY)
	add a,2
	ld e,a
	ld a,(PlayerX)
	add a,7
	ld hl,axright1
	ld b,6
	jr displaymoveobjectjoin
notaxrightfirst:
	cp 9
	jr c,axrightfirst
	ld a,(PlayerY)
	add a,4
	ld e,a
	ld a,(PlayerX)
	add a,7
	ld hl,axright2
	ld b,5
	jr displaymoveobjectjoin

displaymoveobjectjoin:
;Recieve:
;c = 0: Right, c = 1: Left
;b = Height in pixels
;hl = address of sprite
;a = Xval
;8 bit sprite
;e = 0: Player, e = 1: Enemy
;
;Return:
;d = 0: No hit, d = 1: Hit
;If Hit:
;e = Pointer to enemy that it hit, or 254 = Hit Player
	push de
	ld c,a
	ld a,(PlayerPose)
	or a
	jr nz,axeraxright
	ld a,c
	ld c,1
axeraxjoin:
	ld e,0
	call hitdetect
	push hl
	push af
	push bc
	ld a,d
	or a
	jr z,noaxdamagedone
	xor a
	ld hl,AxDamage
	call CauseDamage
noaxdamagedone:
	pop bc
	pop af
	pop hl
	pop de
	call putsprite
displaymoveobjectjoin2:
	ld a,(ObjectLaunch)
	inc a
	cp 13
	jr nc,stopmotion
	ld (ObjectLaunch),a
	ret
stopmotion:
	xor a
	ld (ObjectLaunch),a
	ld (HasHit),a
	ret

axeraxright:
	ld a,c
	ld c,0
	jr axeraxjoin
	
displaymovepipejoin:
;Recieve:
;c = 0: Right, c = 1: Left
;b = Height in pixels
;hl = address of sprite
;a = Xval
;8 bit sprite
;e = 0: Player, e = 1: Enemy
;
;Return:
;d = 0: No hit, d = 1: Hit
;If Hit:
;e = Pointer to enemy that it hit, or 254 = Hit Player
	push de
	ld c,a
	ld a,(PlayerPose)
	or a
	jr nz,piperpiperight
	ld a,c
	ld c,1
piperpipejoin:
	ld e,0
	call hitdetect
	push af
	ld a,d
	or a
	jr z,nopipedamagedone
	push hl
	push bc
	xor a
	ld hl,PipeDamage
	call CauseDamage
	pop bc
	pop hl
nopipedamagedone:
	pop af
	pop de
	call putsprite
displaymovepipejoin2:
	ld a,(ObjectLaunch)
	inc a
	cp 31
	jr nc,stopmotion
	ld (ObjectLaunch),a
	ret
piperpiperight:
	ld a,c
	ld c,0
	jr piperpipejoin
	
	
dropobject:
;drops the object you hold
	ld a,(ObjectHoldTime)
	or a
	ret z	
	xor a
	ld (ObjectType),a
	ld (ObjectLaunch),a
	ret


	
DisplayPlayerPunch:
;Displays the correct picture of the Player in the correct Punching position at PlayerX,PlayerY
;c = 0:  right, c = 1:  left
;d = 0:  Punch, d = 1:  Kick, d = 2: box, d = 3: pipe, d = 4: ax
;e = 0: Player, e = 1: Enemy
	ld e,0
	ld c,0
	ld a,(PlayerPose)
	or a
	jr nz,punchright
	inc c
	ld a,(PunchPosition)
	cp 6
	jr nc,notfirstleftpunch
firstleftpunch:
	ld hl,PlayerPunchLeft1
	jr punchjoin
notfirstleftpunch:
	cp 18
	jr nc,firstleftpunch
secondleftpunch:
	ld hl,PlayerPunchLeft2
	jr punchjoin
punchright:
	ld a,(PunchPosition)
	cp 6
	jr nc,notfirstrightpunch
firstrightpunch:
	ld hl,PlayerPunchRight1
	jr punchjoin
notfirstrightpunch:
	cp 18
	jr nc,firstrightpunch
secondrightpunch:
	ld hl,PlayerPunchRight2
punchjoin:
	ld a,(PlayerX)
	ld b,15
;Recieve:
;c = 0: Right, c = 1: Left
;b = Height in pixels
;hl = address of sprite
;a = Xval
;8 bit sprite
;d = 0:  Punch, d = 1:  Kick, d = 2: box, d = 3: pipe, d = 4: ax
;e = 0: Player, e = 1: Enemy
;
;Return:
;d = 0: No hit, d = 1: Hit
;If Hit:
;e = Pointer to enemy that it hit, or 254 = Hit Player
	call hitdetect
	ld a,d
	or a
	call nz,playerpunchhit
	ld a,(PlayerY)
	ld e,a
	ld a,(PlayerX)
	ld b,15
	call putsprite
	ld a,(PunchPosition)
	inc a
	cp 22
	jr nc,stopPunch
stopPunchback:
	ld (PunchPosition),a
	jp returnPlayerPunch
stopPunch:
	xor a
	ld (HasHit),a			;a needs to = 0 after this to load into PunchPosition
	jr stopPunchback
	
playerpunchhit:
;oh boy we punched him.  Let's take away some health and stamina points
	push hl
	ld hl,PunchDamage
	xor a
	call CauseDamage
	pop hl
	ret
	
	
	
DisplayPlayerKick:
;Displays the correct picture of the Player in the correct Kicking position at PlayerX,PlayerY
	ld e,0
	ld c,0
	ld a,(PlayerPose)
	or a
	jr nz,kickright
	inc c
	ld a,(KickPosition)
	cp 6
	jr nc,notfirstleftkick
firstleftkick:
	ld hl,PlayerKickLeft1
	jr kickjoin
notfirstleftkick:
	cp 18
	jr nc,firstleftkick
secondleftkick:
	ld hl,PlayerkickLeft2
	jr kickjoin
kickright:
	ld a,(KickPosition)
	cp 6
	jr nc,notfirstrightkick
firstrightkick:
	ld hl,PlayerKickRight1
	jr kickjoin
notfirstrightkick:
	cp 18
	jr nc,firstrightkick
secondrightkick:
	ld hl,PlayerkickRight2
kickjoin:
	ld b,15
	ld a,(PlayerX)
;Recieve:
;c = 0: Right, c = 1: Left
;b = Height in pixels
;hl = address of sprite
;a = Xval
;8 bit sprite
;e = 0: Player, e = 1: Enemy
;
;Return:
;d = 0: No hit, d = 1: Hit
;If Hit:
;e = Pointer to enemy that it hit, or 254 = Hit Player
	call hitdetect
	ld a,d
	or a
	call nz,playerkickhit
	ld a,(PlayerY)
	ld e,a
	ld a,(PlayerX)
	ld b,15
	call putsprite
	ld a,(KickPosition)
	inc a
	cp 22
	jr nc,stopKick
stopKickback:
	ld (KickPosition),a
	jp returnPlayerPunch
stopKick:
	xor a
	ld (HasHit),a
	jr stopKickback
	
playerkickhit:
;-Input-
;-------
;hl = Pointer to Damage Data
;a = 0: Player Hit AI, a = 1: AI hit Player
;e = Enemy in Enemy List that damage should be done to (if a = 0)
;
;-Returns-
;---------
;all registers are destroyed
;Enemy or Player Health is Hurt Accordingly
;Enemy or Player May be hit to ground
	push hl
	ld hl,KickDamage
	xor a
	call CauseDamage
	pop hl
	ret
	
	
	
	
dispstats:
	call cleararea
	call disphealth
	call dispscore
	call displives
	ret
	
	
	
	
disphealth:	
;draws line from 0,0 to 0,47
;draws line from 3,0 to 3,47
;draws pixel at 1,0
;draws pixel at 2,0
;draws pixel at 1,47
;draws pixel at 2,47
;draws in pixels at 1,x and 2,x while x<=Health
	ld b,2
	ld e,0
lineouterloop:
	push bc
	ld b,6
	xor a
lineloop:
	push bc
	push af
	push de
	ld b,1
	ld hl,box		;first byte is $FF
	call putsprite
	pop de
	pop af
	add a,8
	pop bc
	djnz lineloop
	ld a,e
	add a,3
	ld e,a
	pop bc
	djnz lineouterloop
	
	xor a
	ld b,2
pixelouterloop:
	push bc
	ld e,1
	ld b,2
pixelinnerloop:
	push bc
	push af
	push de
	ld b,1
	ld hl,PipeRight+1	;second byte of PipeRight is $80
	call putsprite
	pop de
	inc e
	pop af
	pop bc
	djnz pixelinnerloop
	ld a,47
	pop bc
	djnz pixelouterloop
	
	ld b,2
healthloop:
	push bc
	ld a,(Health)
	ld h,1
	ld l,b
	ld d,a
	ld e,b
	ld a,1
	call fastline
	pop bc
	djnz healthloop
	ret
	

dispscore:
;displays the score stored in 9 byte floating point at Score:
;displayed at 4,0
	ld hl,Score
	rst 20h
	ld hl,256*4+1
	ld (pencol),hl
	ld a,6
	bcall(_dispop1a)
	ret
	
	
displives:
;displays one life face per life.  Max of 4 accross starting at 50 and leaving 2 spaces in between each
;each sprite is at X = 50+SpriteNumber*10 (first sprite is 0)
;if more than four, display one at 80 and then display Number of them to the left of it, and an X in between
	ld a,(Lives)
	cp 5
	jr nc,morethan4lives
	or a
	ret z
	ld b,a
	ld a,50
displivesloop:
	push bc
	push af
	ld e,0
	ld b,10
	ld hl,LifeSprite
	call putSprite
	pop af
	add a,10
	pop bc
	djnz displivesloop
	ret
morethan4lives:
	bcall(_setxxop1)
	ld hl,256*4+70
	ld (pencol),hl
	ld a,2
	bcall(_dispop1a)
	ld a,'X'
	ld hl,256*4+75
	ld (pencol),hl
	bcall(_vputmap)
	ld a,80
	ld e,0
	ld b,10
	ld hl,LifeSprite
	call putSprite
	ret

cleararea:
	ld hl,PlotsScreen
	ld bc,12*10
cleararealoop:
	xor a
	ld (hl),a
	inc hl
	dec bc
	ld a,b
	or c
	jr nz,cleararealoop
	ret
	
	
	
addMoreEnemies:
;recieve:
;first byte: 0 = nothing, 1 = as you get to the square, 2 = when it is about to go off screen
;second byte:  0 = nothing, 1 = Guy, 2 = Girl, 3 = Boss
;store:
;byte1 = Type (girl/boy/boss) byte2 = X, byte3 = Direction, byte 4 = status (punch/kick), byte 5 = Hit Points, byte 6 = Stamina
	ld a,(EnemiesUsed)
	ld b,a
	ld a,(MapPointer)
	cp b
	ret z
	ld (EnemiesUsed),a		;screen has shifted 16 bits
	ld hl,EnemyLevels
	ld a,(Level)
	add a,a
	ld e,a
	ld d,0
	add hl,de
	ld e,(hl)
	inc hl
	ld d,(hl)
	ex de,hl
	push hl
	ld a,(EnemiesUsed)
	add a,a
	ld e,a
	ld d,0
	add hl,de
	ld a,(hl)
	cp 2
	jr nz,notfirstenemy
	inc hl
	ld a,(hl)
	ld b,a
	ld a,(EnemyPointer)
	add a,a
	push bc
	ld b,a
	add a,a
	add a,b
	pop bc
	ld hl,EnemyList
	ld d,0
	ld e,a
	add hl,de
	ld a,b
	ld (hl),a
	ld b,a
	inc hl
	xor a
	ld (hl),a		;x = 0
	inc hl
	inc a			;a = 1
	ld (hl),a		;direction = left
	inc hl
	dec a			; a = 0
	ld (hl),a		;not punching or kicking
	inc hl
	ld a,b
	dec a				;Guy is now 0
	add a,a				;multiply by 2
	push hl				; hl = enemylist
	ld hl,EnemyHealthTable	;hl = enemy health table
	ld d,0
	ld e,a					
	add hl,de				;hl = enemyhealthtable at correct spot
	ld a,(hl)
	ex de,hl				;de = enemyhealthtable at correct spot
	pop hl					;hl = enemylist
	ld (hl),a
	inc hl
	inc de
	ld a,(de)
	ld (hl),a
	ld hl,EnemyPointer
	inc (hl)
notfirstenemy:
	pop hl
	ld a,(EnemiesUsed)
	add a,5
	add a,a
	ld e,a
	ld d,0
	add hl,de
	ld a,(hl)
	cp 1
	ret nz
	inc hl
	ld a,(hl)
	ld b,a
	ld a,(EnemyPointer)
	add a,a
	push bc
	ld b,a
	add a,a
	add a,b
	pop bc
	ld hl,EnemyList
	ld d,0
	ld e,a
	add hl,de
	ld a,b
	ld (hl),a
	ld b,a
	inc hl
	ld a,85
	ld (hl),a			;x = 0
	inc hl
	xor a
	ld (hl),a			;Direction = right
	inc hl				; a = 0
	ld (hl),a			;not punching or kicking
	inc hl
	ld a,b
	dec a				;Guy is now 0
	add a,a				;multiply by 2
	push hl				; hl = enemylist
	ld hl,EnemyHealthTable	;hl = enemy health table
	ld d,0
	ld e,a					
	add hl,de				;hl = enemyhealthtable at correct spot
	ld a,(hl)
	ex de,hl				;de = enemyhealthtable at correct spot
	pop hl					;hl = enemylist
	ld (hl),a
	inc hl
	inc de
	ld a,(de)
	ld (hl),a
	ld hl,EnemyPointer
	inc (hl)
	ret	
	
	
	
dispenemies:
;displays the enemies in EnemyList at current X positions and current directions and current punch/kick status
	ld a,(EnemyPointer)
	or a
	ret z
	ld b,a
	ld a,(EnemyFall)
	or a
	jp nz,dispEnemyFall
dispenemyloop:
	push bc
	ld a,b
	dec a
	add a,a
	ld b,a
	add a,a
	add a,b
	ld e,a
	ld d,0
	ld hl,EnemyList
	add hl,de
	ld a,(hl)
	cp 1
	jr nz,notguy
	inc hl
	inc hl
	ld a,(hl)
	or a
	jr z,notguyright
	inc hl
	ld a,(hl)
	or a
	jp nz,guypunchkickright
	dec hl
	dec hl
	ld a,(hl)
	ld e,40
	ld hl,GuyRight
	ld b,15
	call putsprite
	pop bc
	djnz dispenemyloop
	ret
notguyright:
	inc hl
	ld a,(hl)
	or a
	jp nz,guypunchkickleft
	dec hl
	dec hl
	ld a,(hl)
	ld e,40
	ld hl,GuyLeft
	ld b,15
	call putsprite
	pop bc
	djnz dispenemyloop
	ret
notguy:
	cp 2
	jr nz,notgirl
	inc hl
	inc hl
	ld a,(hl)
	or a
	jr z,notgirlright
	inc hl
	ld a,(hl)
	or a
	jp nz,girlpunchkickright
	dec hl
	dec hl
	ld a,(hl)
	ld e,40
	ld hl,GirlRight
	ld b,15
	call putsprite
	pop bc
	djnz dispenemyloop
	ret
notgirlright:
	inc hl
	ld a,(hl)
	or a
	jp nz,girlpunchkickleft
	dec hl	
	dec hl
	ld a,(hl)
	ld e,40
	ld hl,GirlLeft
	ld b,15
	call putsprite
	pop bc
	djnz dispenemyloop
	ret
notgirl:
	inc hl
	inc hl
	ld a,(hl)
	or a
	jr z,notbossright
	inc hl
	ld a,(hl)
	or a
	jp nz,bosspunchkickright
	dec hl
	dec hl
	ld a,(hl)
	ld e,30
	ld hl,BossRight
	ld b,25
	call putsprite
	pop bc
	dec b
	ld a,b
	or a
	jp nz,dispenemyloop
	ret
notbossright:
	inc hl
	ld a,(hl)
	or a
	jp nz,bosspunchkickleft
	dec hl
	dec hl
	ld a,(hl)
	ld e,30
	ld hl,BossLeft
	ld b,25
	call putsprite
	pop bc
	dec b
	ld a,b
	or a
	jp nz,dispenemyloop
	ret
	
	
dispEnemyFall:
	cp 1
	jr z,beginenemyfall
	cp 100
	jr z,endenemyfall
	inc a
	ld (Enemyfall),a
beginenemyfallreturn:
	ld a,(WhichEnemyFell)
	add a,a
	ld b,a
	add a,a
	add a,b
	ld d,0
	ld e,a
;byte1 = Type (girl/boy/boss) byte2 = X, byte3 = Direction, byte 4 = status (punch/kick), byte 5 = Hit Points, byte 6 = Stamina
	ld hl,EnemyList+1
	add hl,de
	ld a,(hl)
	push af
	dec hl
	ld a,(hl)
	dec a				;0 = guy, 1 = girl etc...
	add a,a				;2
	ld b,a
	add a,a				;4
	add a,a				;8
	add a,a				;16
	sub b
	ld hl,EnemyFallTable
	ld d,0
	ld e,a
	add hl,de
	ld b,7
	pop af
	ld e,48
	call putsprite16bitdontshift
	ret
beginenemyfall:
	inc a
	ld (EnemyFall),a
	ld a,(WhichEnemyFell)
	add a,a
	ld b,a
	add a,a
	add a,b
	ld d,0
	ld e,a
	ld hl,EnemyList+1
	add hl,de
	ld a,(hl)
	sub 5
	call c,enemyfallzero
	ld (hl),a
	jr beginenemyfallreturn
endenemyfall:
	xor a
	ld (EnemyFall),a
	ret
enemyfallzero:
	xor a
	ret
	
	
	
	
guypunchkickright:
	inc (hl)
	dec hl
	dec hl
	ld c,a
	ld a,(hl)
	ld b,a
	ld a,c
	ld c,0
	cp 8
	jr nc,notguypunchright1a
guypunchright1a:
	ld hl,GuyPunchRight1
	jr mergepunchkick
notguypunchright1a:
	cp 20
	jr nc,notguypunchright2
guypunchright2a:
	ld hl,GuyPunchRight2
	jr mergepunchkick
notguypunchright2:
	cp 24
	jr c,guypunchright1a
	cp 24
	jr nz,notguystoppunchright
guystoppunchright:
	xor a
	inc hl
	inc hl
	ld (hl),a
	ld (HasHit),a
	ld a,220
	ld (EnemyDelay),a
	jr mergepunchkickafter
notguystoppunchright:
	cp 31
	jr nc,notguykickright1
guykickright1a:
	ld hl,GuyKickRight1
	jr mergepunchkick
notguykickright1:
	cp 43
	jr nc,notguykickright2
guykickright2a:
	ld hl,GuyKickRight2
	jr mergepunchkick
notguykickright2:
	cp 47
	jr c,guykickright1a
	xor a
	inc hl
	inc hl
	ld (hl),a
	ld (HasHit),a
	ld a,220
	ld (EnemyDelay),a
	jr mergepunchkickafter
	
	
mergepunchkick:
	ld a,b
	ld b,15
	ld e,1
	call hitdetect
	push af
	push bc
	push hl
	ld a,d
	or a
	jr z,noguygirlpunchkickdamagedone
	ld a,1
	ld hl,GuyGirlDamagePunchKick
	call CauseDamage
noguygirlpunchkickdamagedone:
	pop hl
	pop bc
	pop af
	ld e,40
	call putsprite
mergepunchkickafter:
	pop bc
	dec b
	ld a,b
	or a
	jp nz, dispenemyloop
	ret
	
	
	
guypunchkickleft:
	inc (hl)
	dec hl
	dec hl
	ld c,a
	ld a,(hl)
	ld b,a
	ld a,c
	ld c,1
	cp 8
	jr nc,notguypunchleft1
guypunchleft1a:
	ld hl,GuyPunchleft1
	jr mergepunchkick
notguypunchleft1:
	cp 20
	jr nc,notguypunchleft2
guypunchleft2a:
	ld hl,GuyPunchleft2
	jr mergepunchkick
notguypunchleft2:
	cp 24
	jr c,guypunchleft1a
	cp 24
	jr nz,notguystoppunchleft
guystoppunchleft:
	xor a
	inc hl
	inc hl
	ld (hl),a
	ld (HasHit),a
	ld a,220
	ld (EnemyDelay),a
	jr mergepunchkickafter
notguystoppunchleft:
	cp 31
	jr nc,notguykickleft1
guykickleft1a:
	ld hl,GuyKickleft1
	jr mergepunchkick
notguykickleft1:
	cp 43
	jr nc,notguykickleft2
guykickleft2a:
	ld hl,GuyKickleft2
	jr mergepunchkick
notguykickleft2:
	cp 47
	jr c,guykickleft1a
	xor a
	inc hl
	inc hl
	ld (hl),a
	ld (HasHit),a
	ld a,220
	ld (EnemyDelay),a
	jr mergepunchkickafter
	
	

girlpunchkickright:
	inc (hl)
	dec hl
	dec hl
	ld c,a
	ld a,(hl)
	ld b,a
	ld a,c
	ld c,0
	cp 8
	jr nc,notgirlpunchright1
girlpunchright1a:
	ld hl,girlPunchRight1
	jp mergepunchkick
notgirlpunchright1:
	cp 20
	jr nc,notgirlpunchright2
girlpunchright2a:
	ld hl,girlPunchRight2
	jp mergepunchkick
notgirlpunchright2:
	cp 24
	jr c,girlpunchright1a
	cp 24
	jr nz,notgirlstoppunchright
girlstoppunchright:
	xor a
	inc hl
	inc hl
	ld (hl),a
	ld (HasHit),a
	ld a,220
	ld (EnemyDelay),a
	jp mergepunchkickafter
notgirlstoppunchright:
	cp 31
	jr nc,notgirlkickright1
girlkickright1a:
	ld hl,girlKickRight1
	jp mergepunchkick
notgirlkickright1:
	cp 43
	jr nc,notgirlkickright2
girlkickright2a:
	ld hl,girlKickRight2
	jp mergepunchkick
notgirlkickright2:
	cp 47
	jr c,girlkickright1a
	xor a
	inc hl
	inc hl
	ld (hl),a
	ld (HasHit),a
	ld a,220
	ld (EnemyDelay),a
	jp mergepunchkickafter
	
	
	
	
girlpunchkickleft:
	inc (hl)
	dec hl
	dec hl
	ld c,a
	ld a,(hl)
	ld b,a
	ld a,c
	ld c,1
	cp 8
	jr nc,notgirlpunchleft1
girlpunchleft1a:
	ld hl,girlPunchleft1
	jp mergepunchkick
notgirlpunchleft1:
	cp 20
	jr nc,notgirlpunchleft2
girlpunchleft2a:
	ld hl,girlPunchleft2
	jp mergepunchkick
notgirlpunchleft2:
	cp 24
	jr c,girlpunchleft1a
	cp 24
	jr nz,notgirlstoppunchleft
girlstoppunchleft:
	xor a
	inc hl
	inc hl
	ld (hl),a
	ld (HasHit),a
	ld a,220
	ld (EnemyDelay),a
	jp mergepunchkickafter
notgirlstoppunchleft:
	cp 31
	jr nc,notgirlkickleft1
girlkickleft1a:
	ld hl,girlKickleft1
	jp mergepunchkick
notgirlkickleft1:
	cp 43
	jr nc,notgirlkickleft2
girlkickleft2a:
	ld hl,girlKickleft2
	jp mergepunchkick
notgirlkickleft2:
	cp 47
	jr c,girlkickleft1a
	xor a
	inc hl
	inc hl
	ld (hl),a
	ld (HasHit),a
	ld a,220
	ld (EnemyDelay),a
	jp mergepunchkickafter

	
	
bosspunchkickright:
	inc (hl)
	dec hl
	dec hl
	ld c,a
	ld a,(hl)
	ld b,a
	ld a,c
	ld c,0
	cp 8
	jr nc,notbosspunchright1
bosspunchright1a:
	ld hl,bossPunchRight1
	jp mergepunchkickboss
notbosspunchright1:
	cp 20
	jr nc,notbosspunchright2
bosspunchright2a:
	ld hl,bossPunchRight2
	jp mergepunchkickboss
notbosspunchright2:
	cp 24
	jr c,bosspunchright1a
	cp 24
	jr nz,notbossstoppunchright
bossstoppunchright:
	xor a
	inc hl
	inc hl
	ld (hl),a
	ld (HasHit),a
	ld a,220
	ld (EnemyDelay),a
	jp mergepunchkickbossafter
notbossstoppunchright:
	cp 31
	jr nc,notbosskickright1
bosskickright1a:
	ld hl,bossKickRight1
	jp mergepunchkickboss
notbosskickright1:
	cp 43
	jr nc,notbosskickright2
bosskickright2a:
	ld hl,bossKickRight2
	jp mergepunchkickboss
notbosskickright2:
	cp 47
	jr c,bosskickright1a
	xor a
	inc hl
	inc hl
	ld (hl),a
	ld (HasHit),a
	ld a,220
	ld (EnemyDelay),a
	jp mergepunchkickbossafter
	
	


bosspunchkickleft:
	inc (hl)
	dec hl
	dec hl
	ld c,a
	ld a,(hl)
	ld b,a
	ld a,c
	ld c,1
	cp 8
	jr nc,notbosspunchleft1
bosspunchleft1a:
	ld hl,bossPunchleft1
	jr mergepunchkickboss
notbosspunchleft1:
	cp 20
	jr nc,notbosspunchleft2
bosspunchleft2a:
	ld hl,bossPunchleft2
	jr mergepunchkickboss
notbosspunchleft2:
	cp 24
	jr c,bosspunchleft1a
	cp 24
	jr nz,notbossstoppunchleft
bossstoppunchleft:
	xor a
	inc hl
	inc hl
	ld (hl),a
	ld (HasHit),a
	ld a,220
	ld (EnemyDelay),a
	jr mergepunchkickbossafter
notbossstoppunchleft:
	cp 31
	jr nc,notbosskickleft1
bosskickleft1a:
	ld hl,bossKickleft1
	jr mergepunchkickboss
notbosskickleft1:
	cp 43
	jr nc,notbosskickleft2
bosskickleft2a:
	ld hl,bossKickleft2
	jr mergepunchkickboss
notbosskickleft2:
	cp 47
	jr c,bosskickleft1a
	xor a
	inc hl
	inc hl
	ld (hl),a
	ld (HasHit),a
	ld a,220
	ld (EnemyDelay),a
	jr mergepunchkickbossafter

mergepunchkickboss:
	ld a,b
	ld b,25
	ld e,1
	call hitdetect
	push af
	push hl
	ld a,d
	or a
	jr z,nobossdamagedone
	ld a,1
	ld hl,BossDamagePunchKick
	call CauseDamage
nobossdamagedone:
	pop hl
	pop af
	ld b,25
	ld e,30
	call putsprite
mergepunchkickbossafter:
	pop bc
	dec b
	ld a,b
	or a
	jp nz, dispenemyloop
	ret
	
	
whichAIIsCloser:
	ld hl,EnemyList+1
	ld a,(EnemyPointer)
	ld b,a
	ld c,255
whichAIIsCloserloop:
	ld a,(hl)
	push bc
	ld b,a
	ld a,(PlayerX)
	cp b
	jr c,Playerisleft
	sub b	
Playerisleftreturn:
	pop bc
	cp c
	call c,aiIsCloser
	push de
	ld de,6
	add hl,de
	pop de
	djnz whichAIIsCloserloop
	ld a,(EnemyPointer)
	sub d			;a = which ai is closest
	ret z
	ld de,EnemyTemp
	ld hl,EnemyList
	ld bc,6
	ldir
	add a,a		;2
	ld b,a
	add a,a		;4
	add a,b		;6
	ld d,0
	ld e,a
	ld hl,EnemyList
	add hl,de
	push hl
	ld de,EnemyList
	ld bc,6
	ldir
	pop de
	ld hl,EnemyTemp
	ld bc,6
	ldir
	ret	
aiIsCloser:
	ld c,a
	ld d,b
	ret
Playerisleft:
	ld e,a
	ld a,b
	sub e
	jr Playerisleftreturn
	
	
moveai:
;byte1 = Type (girl/boy/boss) byte2 = X, byte3 = Direction (0=left) , byte 4 = status (punch/kick)
	ld a,(EnemyPointer)
	or a
	ret z
	ld a,(EnemyList+3)
	or a
	ret nz
	ld a,(PlayerFall)
	or a
	ret nz
	ld a,(EnemyFall)
	or a
	ret nz
	ld a,(EnemyDelay)
	cp 4
	jr nz,incEnemyDelay
	xor a
	ld (EnemyDelay),a
	ld hl,EnemyList+1
	ld a,(hl)
	ld b,a
	ld a,(PlayerX)
	sub 7
	call c,specialaicase
	cp b
	jr c,enemyistotheright
	inc b
	ld a,b
	ld (hl),a
	inc hl
	ld a,1
	ld (hl),a
	ret
enemyistotheright:
	ld a,(PlayerX)
	add a,6
	cp b
	jr nc,makeaikickorpunch
	dec b
	ld a,b
	ld (hl),a
	inc hl
	xor a
	ld (hl),a
	ret
	
incEnemyDelay:
	inc a
	ld (EnemyDelay),a
	ret
	
makeaikickorpunch:
	ld b,2
	call irandom
	cp 1
	jr nz,makeaikick
	ld a,1
	ld (EnemyList+3),a
	ret
makeaikick:
	ld a,25
	ld (EnemyList+3),a
	ret
	
specialaicase:
	xor a
	ret
	
	
hitdetect:
;Recieve:
;c = 0: Right, c = 1: Left
;b = Height in pixels
;hl = address of sprite
;a = Xval
;8 bit sprite
;e = 0: Player, e = 1: Enemy
;
;Return:
;d = 0: No hit, d = 1: Hit
;If Hit:
;e = Pointer to enemy that it hit, or random
	push af
	ld a,(EnemyPointer)
	or a
	jr nz,noquickhitdetectreturn
	ld d,0
	pop af
	ret
noquickhitdetectreturn:
	pop af
	push bc
	push hl
	push af
	ld a,c
	or a
	jp nz,hitdetectleft
	ld c,0
hitdetectrightloop1:
	ld d,8
	ld a,(hl)
hitdetectrightloop:			
	srl a
	jr c,foundrightmostbit
	or a						;reset carry flag
	dec d
	jr nz,hitdetectrightloop
foundrightmostbit:
	ld a,d
	cp c
	jr c,rightLessthanC
	ld c,a
rightLessthanC:
	inc hl
	djnz hitdetectrightloop1			;c = how many pixels to the right 0-7 is the right most
	ld a,e
	or a
	jr nz,Enemyhitdetectright
Playerhitdetectright:
	pop af
	push af
	add a,c
	ld c,a
	ld a,(EnemyPointer)
	ld b,a
	ld hl,EnemyList+1
Playerhitdetectrightloop:
	push bc
	ld a,(hl)
	dec a
	cp c
	jr c,possiblyhitEnemyright
didnothitEnemyright:
	pop bc
	ld de,6
	add hl,de
	djnz Playerhitdetectrightloop
	pop af
	pop hl
	pop bc
	ld d,0
	ret
possiblyhitEnemyright:
	ld e,a
	pop bc
	pop af
	push af
	push bc
	dec a
	dec a
	ld c,a
	ld a,e
	cp c
	jr c,didnothitEnemyright
;d = 0: No hit, a = 1: Hit
;If Hit:
;e = Pointer to enemy that it hit, or 254 = Hit Player
	pop bc
	ld a,(EnemyPointer)
	sub b
	ld e,a
	ld d,1
	pop af
	pop hl
	pop bc
	ret
Enemyhitdetectright:
	ld a,(JumpTime)
	or a
	jr nz,Enemycanthit
	ld a,(PlayerPose)
	cp 4
	jr z,Enemycanthit
	cp 6
	jr z,Enemycanthit
	pop af
	push af
	add a,c
	ld c,a
	ld a,(PlayerX)
	inc a
	cp c
	jr c,possiblyhitPlayerright
didnothitPlayerright:
	pop af
	pop hl
	pop bc
	ld d,0
	ret
possiblyhitPlayerright:
	ld e,a
	ld a,c
	sub 8
	ld c,a
	ld a,e
	cp c
	jr c,didnothitPlayerright
;d = 0: No hit, d = 1: Hit
;If Hit:
;e = Pointer to enemy that it hit, or random
	ld d,1
	pop af
	pop hl
	pop bc
	ret	

Enemycanthit:
	pop af
	pop hl
	pop bc
	ld d,0
	ret


hitdetectleft:
	ld c,0
hitdetectleftloop1:
	ld d,7
	ld a,(hl)
hitdetectleftloop:			
	sla a
	jr c,foundleftmostbit
	or a						;reset carry flag
	dec d
	jr nz,hitdetectleftloop
foundleftmostbit:
	ld a,d
	cp c
	jr c,leftLessthanC
	ld c,a
leftLessthanC:
	inc hl
	djnz hitdetectleftloop1			;c = how many pixels to the left 0-7 is the left most  (reversed) ie 7 = left most, 0 = right
	ld a,7
	sub c
	ld c,a
	ld a,e
	or a
	jr nz,Enemyhitdetectleft
Playerhitdetectleft:				;works
	pop af
	push af
	add a,c
	ld c,a
	ld a,(EnemyPointer)
	ld b,a
	ld hl,EnemyList+1
Playerhitdetectleftloop:
	ld a,(hl)
	inc c
	inc c
	cp c
	jr c,possiblyhitEnemyleft
didnothitEnemyleft:
	ld de,6
	add hl,de
	djnz Playerhitdetectleftloop
	pop af
	pop hl
	pop bc
	ld d,0
	ret
possiblyhitEnemyleft:
	ld e,a
	pop af
	push af
	ld c,a
	ld a,e
	add a,8
	cp c
	jr c,didnothitEnemyleft
;d = 0: No hit, d = 1: Hit
;If Hit:
;e = Pointer to enemy that it hit, or 254 = Hit Player
	ld a,(EnemyPointer)
	sub b
	ld e,a
	ld d,1
	pop af
	pop hl
	pop bc
	ret
Enemyhitdetectleft:
	ld a,(JumpTime)
	or a
	jr nz,Enemycanthit
	pop af
	push af
	add a,c
	ld c,a
	ld a,(PlayerX)
	cp c
	jr c,possiblyhitPlayerleft
didnothitPlayerleft:
	pop af
	pop hl
	pop bc
	ld d,0
	ret
possiblyhitPlayerleft:
	add a,7
	ld e,a
	ld a,c
	ld c,e
	cp c
	jr nc,didnothitPlayerleft
;d = 0: No hit, a = 1: Hit
;If Hit:
;e = Pointer to enemy that it hit, or random
	ld d,1
	pop af
	pop hl
	pop bc
	ret	

	
	
	
hitdetectJump:
;Checks to see if your foot hits the ai
;returns a = 0: no hit, a = 1: hit
;returns e = pointer to enemy
	ld a,(EnemyPointer)
	or a
	ret z
	ld a,(PlayerY)
	add a,11
	cp 40
	jr nc,noquickjumphitdetect			;screw bosses, just make them have to hit half way down
	xor a
	ret
noquickjumphitdetect:
	ld a,(PlayerPose)
	cp 8
	jr nz,hitdetectjumpright
hitdetectjumpleft:
	ld a,(PlayerX)
	ld c,a
	ld a,(EnemyPointer)
	ld b,a
	ld hl,EnemyList+1
hitdetectjumpleftloop:
	ld a,(hl)
	add a,7
	cp c
	jr nc,possiblyhitjumpleft
	ld de,6
	add hl,de
	djnz hitdetectjumpleftloop
nohitjumpleft:
	xor a
	ret
possiblyhitjumpleft:
	sub 4
	cp c
	jr nc,nohitjumpleft
	ld a,(EnemyPointer)
	sub b
	ld e,a
	ld a,1
	ret
hitdetectjumpright:
	ld a,(PlayerX)
	add a,7
	ld c,a
	ld a,(EnemyPointer)
	ld b,a
	ld hl,EnemyList+1
hitdetectjumprightloop:
	ld a,(hl)
	ld d,a
	ld a,c
	cp d
	jr nc,possiblyhitjumpright
	ld de,6
	add hl,de
	djnz hitdetectjumprightloop
nohitjumpright:
	xor a
	ret
possiblyhitjumpright:
	sub 4
	cp d
	jr nc,nohitjumpright
	ld a,(EnemyPointer)
	sub b
	ld e,a
	ld a,1
	ret
	
	
	
	
CauseDamage:
;-Input-
;-------
;hl = Pointer to Damage Data
;a = 0: Player Hit AI, a = 1: AI hit Player
;e = Enemy in Enemy List that damage should be done to (if a = 0)
;
;-Returns-
;---------
;all registers are destroyed
;Enemy or Player Health is Hurt Accordingly
;Enemy or Player May be hit to ground
	push af
	ld a,(HasHit)
	or a
	jr z,noquickcausedamagequit
	pop af
	ret	
noquickcausedamagequit:
	ld a,(PlayerFall)
	or a
	jr z,noquickcausedamagequit1
	pop af
	ret
noquickcausedamagequit1:
	ld a,(EnemyFall)
	or a
	jr z,noquickcausedamagequit2
	pop af
	ret
noquickcausedamagequit2:
	ld a,1
	ld (HasHit),a
	pop af
	or a
	jp nz,CauseDamagetoPlayer
	ld a,e
	ld (WhichEnemyFell),a			;load it up here so we don't have to worry about it.   It doesn't matter unless
	add a,a							;EnemyFall > 0
	ld b,a
	add a,a
	add a,b
	ld d,0
	ld e,a
	push hl
	ld hl,EnemyList+4
	add hl,de			;Points to HitPoints of AI to be hurt
	pop de				;Points to Damage Data
	ld a,(hl)
	ld b,a
	ld a,(de)
	cp b
	jr nc,KillAI
	ld c,a
	ld a,b
	sub c
	ld (hl),a			;take away hit points
	inc hl
	ld a,(hl)
	inc de
	inc de
	inc de
	ld b,a
	ld a,(de)
	cp b
	jr nc,FinalBlow
	ld c,a
	ld a,b
	sub c				;take away stamina
	ld (hl),a
finalblowback:
	dec de
	dec de
	ld a,(de)
	inc de
	ld l,a
	ld a,(de)
	ld h,a
	bcall(_setxxxxop2)
	ld hl,Score
	rst 20h
	bcall(_fpadd)
	ld hl,Op1
	ld de,Score
	ld bc,9
	ldir
	call dispstats
	ret
FinalBlow:
	;trigger fall down sequence here and wait for next attack sequence
	ld a,1
	ld (EnemyFall),a
	push hl
	push de
	ld a,(WhichEnemyFell)
	add a,a
	ld b,a
	add a,a
	add a,b
	ld d,0
	ld e,a
	ld hl,EnemyList
	add hl,de
	ld a,(hl)
	dec a
	add a,a
	ld hl,EnemyHealthTable+1
	ld e,a
	add hl,de
	ld a,(hl)
	pop de	
	pop hl
	ld (hl),a
	jr finalblowback
KillAI:
	;trigger death sequence later
	push de
	dec hl
	dec hl
	dec hl
	dec hl
	ld d,h
	ld e,l
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	ld bc,6
	ldir
	ld hl,EnemyPointer
	dec (hl)
	ld a,(hl)
	or a
	call z,doathumbsup
	pop de
	inc de
	inc de
	inc de
	jr finalBlowBack
	
doathumbsup:
	ld a,100
	ld (ThumbsUp),a
	ret
	

CauseDamagetoPlayer:
	ld a,(PlayerPose)
	or a
	jr z,okhitme
	cp 2
	jr z,okhitme
	ret
okhitme:
	ld a,(Health)
	ld b,a
	ld a,(hl)
	cp b
	jr nc,KillPlayer
	ld b,a
	ld a,(Health)
	sub b
	ld (Health),a
	inc hl
	ld a,(Stamina)
	ld b,a
	ld a,(hl)
	cp b
	jr nc,FinalBlowToPlayer
	ld c,a
	ld a,b
	sub c
	ld (Stamina),a
	call dispstats
	ret
KillPlayer:
	ld a,46
	ld (Health),a
	ld a,12
	ld (Stamina),a
	ld a,(Lives)
	or a
	jr z,GameOver
	dec a
	ld (Lives),a
	call dispstats
	ld a,1
	ld (PlayerFall),a
	ret
FinalBlowToPlayer:
	ld a,1
	ld (PlayerFall),a
	ld a,12
	ld (Stamina),a
	call dispstats
	ret
GameOver:
	bcall(_grbufclr)
	ld b,30
GameOverloop:
	push bc
	ld b,96
	call irandom
	ld (pencol),a
	ld b,63
	call irandom
	ld (penrow),a
	ld hl,msgGameover
	call vputs
	bcall(_grbufcpy)
	ei
	ld b,10
haltloop3:
	halt
	djnz haltloop3
	pop bc
	djnz GameOverloop
	call checkHighScore	
	ld sp,(StackSave)
	jp Menu
	
	
DisplayPlayerFall:
	ld a,(PlayerFall)
	cp 1
	jr z,beginplayerfall
	cp 100
	jr z,endplayerfall
beginplayerfallreturn:
	ld a,(PlayerFall)
	inc a
	ld (PlayerFall),a
endplayerfallreturn:
	ld a,(PlayerPose)
	srl a				;make it either 0 or 1
	add a,a				;2
	ld b,a
	add a,a				;4
	add a,a				;8
	add a,a				;16
	sub b				;14 for 14 bytes
	ld hl,PlayerFallTable
	ld d,0
	ld e,a
	add hl,de
	ld e,48
	ld a,(PlayerX)
	ld b,7
	call putsprite16bitdontshift
	jp returnPlayerPunch
beginplayerfall:
	ld a,(PlayerX)
	sub 5
	call c,fallallthewaytotheleft
	ld (PlayerX),a
	jr beginplayerfallreturn
endplayerfall:
	xor a
	ld (PlayerFall),a
	jr endplayerfallreturn
	
fallallthewaytotheleft:
	xor a
	ret
	
	
dispThumbsup:
;displays Thumbs up
;alternates for greyscale
	ld a,(Thumbsup)
	dec a
	ld (Thumbsup),a
	or a
	srl a
	ld a,0
	adc a,0
	add a,a			;2
	add a,a			;4
	add a,a			;8
	add a,a			;16
	add a,a			;32
	ld d,0
	ld e,a
	ld hl,ThumbsUpLayer1
	add hl,de
	ld b,16
	ld a,80
	ld e,10
	call putsprite16bitdontshift
	ret
	
	
NewLevelSetup:
;Starts Player at default starting location
;Full health and stamina
;Displays Level indicator
	ld a,5
	ld (PlayerX),a
	ld a,40
	ld (PlayerY),a
	ld a,46
	ld (Health),a
	ld a,12
	ld (Stamina),a
	xor a
	ld (ObjectType),a			;drop weapons each level
	ld a,(NewLevelDisplay)
	cp 1
	jr z,beginNewLeveldisplay
beginNewLeveldisplayreturn:
	inc a
	ld (NewLevelDisplay),a
	ld a,(LevelY)
	ld (penrow),a
	ld a,35
	ld (pencol),a
	ld hl,msgLevel
	bcall(_vputs)
	ld a,(Level)
	inc a
	bcall(_setxxop1)
	ld a,2
	bcall(_dispop1a)
	ld a,(NewLevelDisplay)
	cp 140
	jr nc,stopmovingLeveldisplay
	ld a,(NewLevelDisplay)
	and 7
	call z,increaseLevelY
	jp Mainloop
beginNewLeveldisplay:
	ld a,10
	ld (LevelY),a
	ld a,(NewLevelDisplay)
	jr beginNewLeveldisplayreturn
increaseLevelY:
	ld hl,LevelY
	inc (hl)
	ret
stopmovingLeveldisplay:
	cp 200
	jr nc,stopLeveldisplay
	jp Mainloop
stopLeveldisplay:
	xor a
	ld (NewLevelDisplay),a
	call dispstats
	jp Mainloop
	
	
PauseMenu:
;Clears Screen and gives options
	bcall(_grbufclr)
	bcall(_grbufcpy)
	bcall(_clrlcdfull)
	bcall(_homeup)
	ld hl,msgPause
	bcall(_puts)
PauseMenuloop:
	bcall(_getcsc)
	cp sk1
	jp z,Mainloop
	cp sk2
	jr z,SaveGame
	cp sk3
	jp z,Menu
	jr PauseMenuloop
	
	
DecreaseEnterTimer:
	ld hl,EnterTimer
	dec (hl)
	ret
	
	
putMensprite:
	ld a,(menSpriteY)
	ld e,a
	xor a
	call putspriteinvert
	bcall(_grbufcpy)
	ret
	
	
SaveGame:
;need to save:
;Health
;Lives
;PlayerX
;Level
;MapPointer
;EnemyDamageTable all 10 bytes of it
	ld hl,DDragonTxt
	rst 20h                   ;rMOV9TOOP1
	bcall(_ChkFindSym)
	jr c,notExist
	ld a,b
	or a
	jr z,store				;in ram
	bcall(_arc_unarc)
	jr store				;in ram now
notExist:
	ld hl,DDragonTxt
	rst 20h                 ;rMOV9TOOP1
	ld hl,28				;bytes
	bcall(_CreateAppVar)    ;assuming enough Free RAM 
store:
	inc de
	inc de					;2 byte header
	ld a,1
	ld (de),a
	inc de					;+3
	ld a,(Health)
	ld (de),a
	inc de					;+4
	ld a,(Lives)
	ld (de),a
	inc de					;+5
	ld a,(PlayerX)
	ld (de),a
	inc de					;+6
	ld a,(Level)
	ld (de),a
	inc de					;+7
	ld a,(MapPointer)
	ld (de),a
	inc de					;+8
	ld hl,Score
	ld bc,9
	ldir
	ld hl,EnemyDamageTable
	ld bc,10
	ldir
	ld hl,DDragonTxt
	rst 20h                   ;rMOV9TOOP1
	bcall(_ChkFindSym)
	bcall(_arc_unarc)		;archive it
	jp menu
DDragonTxt:
	.db AppVarObj,"DDragon",0
	
	
	
	
	
putspriteinvert:
;hl=address of sprite
;e=y
;a=x
;b=rows	
	push af
	pop af
	push hl
	call getplot
	pop de           ;de = PlayerBuffer, hl = Plots
	and 7
	jr z,alignedi
outerloopai:
	push bc
	push af
	ld b,a
	ex de,hl
	ld c,(hl)
	inc hl
	ex de,hl
	xor a
shiftloopai:
	srl c
	rra
	djnz shiftloopai
	inc hl
	cpl
	ld (hl),a
	dec hl
	ld a,c
	cpl
	ld (hl),a
	ld bc,12
	add hl,bc
	pop af
	pop bc
	djnz outerloopai
	ret
alignedi:
	push bc
	ex de,hl
	ld a,(hl)
	inc hl
	ex de,hl
	cpl
	ld (hl),a
	ld bc,12
	add hl,bc
	pop bc
	djnz alignedi
	ret
	
	
IntroMovie:
	bcall(_grbufclr)
	ld b,34			;Moving 34 pixels accross screen
	xor a			;X coord of man, a+8 = woman
FirstPartloop:
	push bc
	push af
	ld e,40
	ld b,15
	ld hl,Playerright1
	call putsprite
	pop af
	push af
	add a,8
	ld e,40
	ld b,15
	ld hl,GirlRight
	call putsprite
	ld hl,0
	ld (pencol),hl
	ld hl,msgIntro1
	call vputs
	bcall(_grbufcpy)
	ei
	halt
	bcall(_grbufclr)
	pop af
	inc a
	pop bc
	djnz FirstPartloop
	bcall(_grbufclr)
	ld b,38
	ld a,88
SecondMovieloop:
	push bc
	push af
	ld hl,0
	ld (pencol),hl
	ld hl,msgIntro2
	call vputs
	ld a,34
	ld e,40
	ld b,15
	ld hl,Playerright1
	call putsprite
	ld a,34+8
	ld e,40
	ld b,15
	ld hl,GirlRight
	call putsprite
	pop af
	push af
	ld e,40
	ld b,15
	ld hl,GuyLeft
	call putsprite
	pop af
	push af
	add a,8
	cp 89
	jr nc,dontdisplay22mov
	ld e,30
	ld b,25
	ld hl,BossLeft
	call putsprite
	pop af
	push af
	add a,16
	cp 89
	jr nc,dontdisplay22mov
	ld e,40
	ld b,15
	ld hl,GuyLeft
	call putsprite
dontdisplay22mov:
	bcall(_grbufcpy)
	ei
	halt
	bcall(_grbufclr)
	pop af
	dec a
	pop bc
	djnz SecondMovieloop
	ld b,20
flashloop:
	push bc
	bcall(_grbufclr)
	bcall(_grbufcpy)
	ei
	ld b,10
haltloop:
	halt
	djnz haltloop
	ld hl,PlotsScreen
	ld (hl),$FF
	push hl
	pop de
	inc de
	ld bc,768
	ldir
	bcall(_grbufcpy)
	ld b,10
haltloop1:
	halt
	djnz haltloop1
	pop bc
	djnz flashloop
	ld b,50
Introloop3:
	push bc
	bcall(_grbufclr)
	ld hl,CloseUp
	ld de,PlotsScreen+132
	ld bc,612
	ldir
	ld hl,0
	ld (pencol),hl
	ld hl,msgIntro3
	call vputs
	bcall(_grbufcpy)
	ei
	halt
	pop bc
	djnz Introloop3
	ld b,50
Introloop4:
	push bc
	bcall(_grbufclr)
	ld hl,CloseUp
	ld de,PlotsScreen+132
	ld bc,612
	ldir
	ld hl,0
	ld (pencol),hl
	ld hl,msgIntro4
	call vputs
	bcall(_grbufcpy)
	ei
	halt
	pop bc
	djnz Introloop4
	ld b,75
Introloop5:
	push bc
	bcall(_grbufclr)
	ld hl,CloseUp
	ld de,PlotsScreen+132
	ld bc,612
	ldir
	ld a,28
	ld (penrow),a
	ld a,40
	ld (pencol),a
	ld hl,msgIntro5
	call vputs
	ld a,35
	ld (penrow),a
	ld a,40
	ld (pencol),a
	ld hl,msgIntro6
	call vputs
	bcall(_grbufcpy)
	ei
	halt
	pop bc
	djnz Introloop5
	ret
	
	
YouWon:
	bcall(_grbufclr)
	ld hl,0
	ld (pencol),hl
	ld hl,msgYouWon
	call vputs
	bcall(_grbufcpy)
	ld bc,400
	ei
haltloop4:
	halt
	dec bc
	ld a,b
	or c
	jr nz,haltloop4
	call checkHighScore	
	ld sp,(StackSave)
	jp Menu
	

checkHighScore:
	ld hl,HighScore
	rst 20h
	bcall(_Op1toOp2)
	ld hl,Score
	rst 20h
	bcall(_fpsub)
	ld a,(Op1)
	or a
	ret nz
	ld a,(Op1+1)
	cp $80
	ret c
	cp $81
	jr nc,NewHighScore
	ld b,7
	ld hl,Op1+2
findhighOp1loop:
	ld a,(hl)
	or a
	jr nz,NewHighScore
	inc hl
	djnz findhighOp1loop
	ret
NewHighScore:
	ld hl,Score
	ld de,HighScore
	ld bc,9
	ldir
	
	bcall(_grbufclr)
	bcall(_grbufcpy)
	bcall(_clrlcdfull)
	bcall(_homeup)
	ld hl,msgInputName
	bcall(_puts)
	xor a
	ld (curcol),a
	ld (Flicker),a
	inc a
	ld (currow),a
	ld a,'A'
	bcall(_PutMap)
	ld hl,Alphabet
	ld de,HighScoreName
	xor a
	ld (de),a
	ld b,0
	push bc
	push hl
	push de
InputNameloop:
	ei
	halt
	bcall(_getcsc)
	cp skdown
	jr nz,notInputNamedown
	pop de
	pop hl
	push hl
	inc hl
	push de
	ld de,HighScoreName
	or a
	sbc hl,de
	jr z,InputNameloopAlphadown
	pop de
	pop hl
	inc hl	
InputNameloopAlphadownReturn:
	push hl
	push de
	jr InputNameloop
InputNameloopAlphadown:
	ld hl,Alphabet
	pop de
	jr InputNameloopAlphadownReturn
notInputNamedown:
	cp skup
	jr nz,notInputNameUp
	pop de
	pop hl
	push hl
	push de
	ld de,Alphabet
	or a
	sbc hl,de
	jr z,InputNameloopAlphaup
	pop de
	pop hl
	dec hl
InputNameloopAlphaupReturn:
	push hl
	push de
	jr InputNameloop
InputNameloopAlphaup:
	pop de
	pop hl
	ld hl,Alphabet+76
	jr InputNameloopAlphaupReturn
notInputNameup:
	cp skRight
	jr nz,notInputNameRight
	pop de
	pop hl
	push hl
	push de
	ld hl,HighScoreName+20
	or a
	sbc hl,de
	jr z,InputNameloop
	pop de
	pop hl
	ld a,(hl)
	ld (de),a
	inc de
	xor a
	ld (de),a
	ld hl,Alphabet
	push hl
	push de
	jr InputNameloop
notInputNameRight:
	cp skdel
	jr nz,notInputNameDelete
InputNameDelete:
	pop de
	pop hl
	push hl
	push de
	ld hl,Alphabet+76
	dec de
	or a
	sbc hl,de
	jr z,nodigitstodel
	pop de
	pop hl
	dec de
	ld a,' '
	ld (de),a
	push hl
	push de
	ld hl,AlphaBet+76
	ld a,1
	ld (Flicker),a
	call Flashletter
	pop de
	pop hl
	xor a
	ld (de),a
	push hl
	push de
	jp InputNameloop
nodigitstodel:
	pop de
	pop hl
	push hl
	push de
	jp InputNameloop
notInputNameDelete:
	cp skLeft
	jr z,InputNameDelete
	cp skEnter
	jr nz,notInputNameEnter
	pop de
	pop hl
	push hl
	push de
	ld hl,HighScoreName
	or a
	sbc hl,de
	jr z,cantquitInputName
	pop de
	pop hl
	ld a,(hl)
	ld (de),a
	inc de
	xor a
	ld (de),a
	ld sp,(StackSave)
	jp Menu
cantquitInputName:
	jp InputNameloop
notInputNameEnter:
	pop de
	pop hl
	pop bc
	push hl
	push de
	inc b
	ld a,b
	cp 50
	call z,FlashLetter
	pop de
	pop hl
	push bc
	push hl
	push de
	jp InputNameloop
	
FlashLetter:
	push hl
	ld hl,Flicker
	ld a,(hl)
	inc (hl)
	or a
	jr z,Flickeroff
	xor a
	ld (hl),a
	ld hl,HighScoreName
	xor a
	ld (curcol),a
	inc a
	ld (currow),a
	bcall(_puts)
	pop hl
	ld a,(hl)
	bcall(_putmap)
	ld b,0
	ret
Flickeroff:
	ld hl,HighScoreName
	xor a
	ld (curcol),a
	inc a
	ld (currow),a
	bcall(_puts)
	ld a,' '
	bcall(_putmap)
	ld b,0
	pop hl
	ret
	
	
	
	

	
;Sprites


;0 = walk left
;2 = walk right
;4 = crouch left
;6 = crouch right
;8 = jump left
;9 = jump right
SpriteTable:
Playerleft1:
	.db $3C,$42,$62,$42,$24,$22,$22,$E2,$2A,$2E,$24,$38,$28,$24,$22
Playerleft2:
	.db $3C,$42,$62,$42,$24,$22,$22,$E2,$2A,$2E,$24,$38,$28,$28,$48
Playerright1:
	.db $3C,$42,$46,$42,$24,$44,$44,$47,$54,$74,$24,$1C,$14,$24,$44
Playerright2:
	.db $3C,$42,$46,$42,$24,$44,$44,$47,$54,$74,$24,$1C,$14,$14,$12
Playercrouchleft1:
	.db $00,$00,$00,$00,$00,$1E,$21,$31,$A1,$9E,$4C,$3C,$0C,$1C,$37
Playercrouchleft2:
	.db $00,$00,$00,$00,$00,$1E,$21,$31,$A1,$9E,$4C,$3C,$0C,$1C,$76
Playercrouchright1:
	.db $00,$00,$00,$00,$00,$78,$84,$8C,$85,$79,$32,$3C,$30,$38,$EC
Playercrouchright2:
	.db $00,$00,$00,$00,$00,$78,$84,$8C,$85,$79,$32,$3C,$30,$38,$6E
Playerjumpleft:
	.db $00,$1E,$21,$31,$21,$92,$A1,$65,$23,$21,$1E,$E2,$02,$01,$00
Playerjumpright:
	.db $00,$78,$84,$8C,$84,$49,$85,$A6,$C4,$84,$78,$47,$40,$80,$00
	
	
	
	
	
Objects:
;all 5 pixels tall
Box:
	.db $FF,$81,$81,$81,$FF
Pipe:
PipeRight1:	;to save space
	.db 0,0,$FE,$02,$02
Ax:
AxRight2:	;to save space
	.db 0,0,0,$FF,$07

	
HoldingObjects:
PipeLeft:
	.db $E0,$20,$20,$20,$20,$20,$20		;7 pixels tall
PipeRight:
	.db $E0,$80,$80,$80,$80,$80,$80
AxLeft:
	.db $C0,$C0,$C0,$40,$40,$40,$40,$40	;8 pixels tall
AxRight:
	.db $C0,$C0,$C0,$80,$80,$80,$80,$80	
	
	
MovingObjects:
PipeLeft1:
	.db $7F,$40,$40						;3
AxLeft1:
	.db $60,$70,$38,$04,$02,$01 		;6
AxLeft2:	
	.db $FF,$E0							;2
AxRight1:
	.db $06,$0E,$1C,$20,$40,$80			;6
	
PlayerPunchTable:
PlayerPunchLeft1:
	.db $3C,$42,$62,$42,$24,$26,$26,$F6,$2E,$22,$24,$38,$28,$24,$22			;15 pixels tall
PlayerPunchLeft2:
	.db $1E,$21,$31,$21,$12,$13,$FF,$11,$31,$11,$12,$1C,$14,$12,$11
PlayerPunchRight1:
	.db $3C,$42,$46,$42,$24,$64,$64,$6F,$74,$44,$24,$1C,$14,$24,$44
PlayerPunchRight2:
	.db $78,$84,$8C,$84,$48,$C8,$FF,$88,$8C,$88,$48,$38,$28,$48,$88
	
	
PlayerKickTable:
PlayerKickLeft1:
	.db $3C,$42,$62,$42,$24,$22,$22,$E2,$22,$2A,$2E,$3C,$24,$44,$82
PlayerKickLeft2:
	.db $1E,$21,$31,$21,$12,$11,$11,$71,$11,$15,$17,$9E,$FE,$03,$01
PlayerKickRight1:
	.db $3C,$42,$46,$42,$24,$44,$44,$47,$44,$54,$74,$3C,$24,$22,$41
PlayerKickRight2:
	.db $78,$84,$8C,$84,$48,$88,$88,$8E,$88,$A8,$E8,$79,$7F,$C0,$80
	
	
	
FloorTable:
Floor1Layer1:
	.db $FF,$88,$88,$FF,$88,$88,$FF
Floor1Layer2:
	.db $FF,$FF,$FF,$FF,$FF,$FF,$FF


WallTable:
Wall1Level1:
	.db $00,$80,$00,$80,$00,$80,$00,$80,$00,$80,$00,$80,$00,$80,$81,$C0
	.db $FF,$FF,$38,$1C,$10,$08,$10,$08,$10,$08,$10,$08,$10,$08,$10,$08
	.db $38,$1C,$FF,$FF,$81,$C0,$00,$80,$00,$80,$00,$80,$00,$80,$00,$80
	.db $00,$80,$81,$C0,$FF,$FF,$38,$1C,$10,$08,$10,$08,$10,$08,$10,$08
	.db $10,$08,$10,$08,$38,$1C,$FF,$FF,$00,$80,$00,$80,$00,$80,$00,$80
	.db $00,$80,$00,$80,$00,$80,$81,$C0,$FF,$FF
	
Wall2Level1:
	.db $FF,$FF,$B0,$00,$A9,$B0,$AA,$48,$AA,$48,$B2,$3C,$80,$00,$FF,$FF
	.db $80,$01,$80,$01,$80,$01,$80,$01,$9F,$C1,$90,$41,$90,$41,$90,$41
	.db $90,$41,$90,$41,$90,$41,$9F,$C1,$80,$01,$80,$01,$80,$01,$80,$01
	.db $80,$01,$80,$01,$80,$01,$80,$05,$80,$07,$80,$01,$80,$01,$80,$01
	.db $80,$01,$80,$01,$80,$01,$80,$01,$80,$01,$80,$01,$BF,$E1,$A0,$21
	.db $BF,$E1,$A0,$21,$BF,$E1,$A0,$21,$FF,$FF
Wall3Level1:
	.db $FF,$FF,$00,$01,$63,$39,$94,$A5,$74,$A5,$13,$25,$60,$01,$FF,$FF
	.db $80,$01,$80,$01,$80,$01,$80,$01,$83,$F9,$82,$09,$82,$09,$82,$09
	.db $82,$09,$83,$F9,$80,$01,$80,$01,$80,$01,$80,$01,$80,$01,$80,$01
	.db $80,$01,$80,$01,$80,$01,$A0,$01,$E0,$01,$80,$01,$80,$01,$80,$01
	.db $80,$01,$80,$01,$80,$01,$80,$01,$80,$01,$80,$01,$80,$01,$80,$01
	.db $80,$01,$80,$01,$80,$01,$80,$01,$FF,$FF
	
Wall1Level2:
	.db $08,$20,$08,$20,$08,$20,$F8,$20,$47,$C0,$20,$30,$10,$08,$1F,$8F
	.db $70,$72,$88,$04,$18,$04,$16,$08,$12,$08,$12,$38,$61,$44,$59,$82
	.db $87,$01,$81,$C1,$C6,$31,$38,$2E,$08,$C8,$0B,$08,$0C,$10,$16,$10
	.db $21,$91,$40,$62,$40,$24,$B0,$4C,$0F,$D4,$08,$E4,$08,$C4,$09,$44
	.db	$09,$24,$0A,$34,$1F,$08,$21,$90,$21,$5C,$41,$23,$41,$20,$A0,$90
	.db $10,$FC,$08,$42,$04,$21,$18,$20,$20,$10
Wall2Level2:
	.db $80,$20,$40,$50,$20,$88,$11,$04,$0A,$02,$04,$01,$FF,$FF,$00,$00
	.db $F0,$00,$0F,$00,$00,$F0,$00,$0F,$F0,$00,$0F,$00,$00,$F0,$00,$0F
	.db $F0,$00,$0F,$00,$00,$F0,$00,$0F,$F0,$00,$0F,$00,$00,$F0,$00,$0F
	.db $F0,$00,$0F,$00,$00,$F0,$00,$0F,$F0,$00,$0F,$00,$00,$F0,$00,$0F
	.db $00,$00,$FF,$FF,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	.db $10,$10,$10,$10,$10,$10,$10,$10,$FF,$FF
Wall3Level2:
	.db $04,$01,$0A,$02,$11,$04,$20,$88,$40,$50,$80,$20,$FF,$FF,$00,$00
	.db $00,$0F,$00,$F0,$0F,$00,$F0,$00,$00,$0F,$00,$F0,$0F,$00,$F0,$00
	.db $00,$0F,$00,$F0,$0F,$00,$F0,$00,$00,$0F,$00,$F0,$0F,$00,$F0,$00
	.db $00,$0F,$00,$F0,$0F,$00,$F0,$00,$00,$0F,$00,$F0,$0F,$00,$F0,$00
	.db $00,$00,$FF,$FF,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	.db $10,$10,$10,$10,$10,$10,$10,$10,$FF,$FF
	
Wall1Level3:
	.db $FF,$FF,$88,$88,$FF,$FF,$22,$22,$FF,$FF,$11,$11,$FF,$FF,$44,$44
	.db $FF,$FF,$11,$11,$FF,$FF,$88,$88,$FF,$FF,$22,$22,$FF,$FF,$44,$44
	.db $FF,$FF,$11,$11,$FF,$FF,$88,$88,$FF,$FF,$22,$22,$FF,$FF,$88,$88
	.db $FF,$FF,$22,$22,$FF,$FF,$00,$00,$15,$00,$7F,$C0,$55,$40,$55,$40
	.db $55,$40,$55,$40,$55,$40,$55,$40,$55,$40,$55,$40,$55,$40,$7F,$C0
	.db $15,$00,$0E,$EE,$04,$4E,$04,$EA,$00,$00
Wall2Level3:
	.db $FF,$FF,$88,$88,$FF,$FF,$44,$44,$FF,$FF,$88,$88,$FF,$FF,$22,$24
	.db $FF,$FF,$00,$00,$00,$00,$00,$00,$70,$F0,$48,$80,$44,$80,$44,$81
	.db $44,$E1,$44,$81,$44,$81,$48,$82,$70,$F2,$00,$00,$00,$00,$01,$00
	.db $02,$A2,$02,$AA,$03,$AA,$02,$94,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$FF,$FF,$88,$88,$FF,$FF,$44,$44
	.db $FF,$FF,$88,$88,$FF,$FF,$22,$24,$00,$00
Wall3Level3:
	.db $FF,$FF,$88,$88,$FF,$FF,$44,$44,$FF,$FF,$88,$88,$FF,$FF,$22,$24
	.db $FF,$FF,$00,$00,$00,$00,$00,$00,$47,$D1,$A1,$11,$A1,$11,$11,$11
	.db $11,$1F,$F1,$11,$11,$11,$09,$11,$09,$11,$00,$00,$00,$00,$0A,$00
	.db $63,$60,$AA,$40,$AA,$20,$69,$60,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$FF,$FF,$88,$88,$FF,$FF,$44,$44
	.db $FF,$FF,$88,$88,$FF,$FF,$22,$24,$00,$00
	
Wall1Level4:
	.db $00,$06,$00,$06,$FF,$FF,$87,$E1,$87,$E1,$87,$E1,$87,$E1,$87,$E1
	.db $FC,$3F,$FC,$3F,$FC,$3F,$FC,$3F,$FC,$3F,$87,$E1,$87,$E1,$87,$E1
	.db $87,$E1,$87,$E1,$FC,$3F,$FC,$3F,$FC,$3F,$FC,$3F,$FC,$3F,$87,$E1
	.db $87,$E1,$87,$E1,$87,$E1,$87,$E1,$FC,$3F,$FC,$3F,$FC,$3F,$FC,$3F
	.db $FC,$3F,$87,$E1,$87,$E1,$87,$E1,$86,$61,$84,$21,$FC,$3F,$FC,$3F
	.db $FC,$3F,$FC,$7F,$FC,$3F,$FC,$3F,$FF,$FF
Wall2Level4:
	.db $00,$00,$00,$00,$3B,$94,$11,$1D,$11,$1D,$11,$15,$13,$95,$00,$00
	.db $00,$00,$00,$00,$E0,$01,$49,$54,$55,$99,$59,$11,$4D,$11,$00,$00
	.db $00,$00,$00,$00,$04,$39,$04,$22,$04,$22,$04,$33,$04,$22,$07,$BA
	.db $00,$00,$00,$00,$00,$00,$00,$1C,$00,$22,$00,$22,$00,$22,$00,$22
	.db $00,$22,$00,$1C,$00,$00,$00,$00,$00,$E3,$00,$91,$00,$91,$00,$91
	.db $00,$91,$00,$91,$00,$E3,$00,$00,$00,$00
Wall3Level4:
	.db $00,$00,$00,$00,$9D,$C8,$50,$94,$58,$94,$D0,$9C,$51,$D4,$00,$00
	.db $00,$00,$00,$00,$00,$00,$44,$A0,$6A,$CA,$4A,$8A,$24,$84,$00,$08
	.db $00,$00,$00,$00,$2B,$80,$AA,$00,$AA,$00,$AB,$00,$AA,$00,$93,$80
	.db $00,$00,$00,$00,$00,$00,$70,$00,$48,$00,$48,$00,$70,$00,$48,$00
	.db $48,$00,$48,$00,$00,$00,$00,$00,$9E,$00,$10,$00,$10,$00,$1C,$00
	.db $10,$00,$10,$00,$9E,$00,$00,$00,$00,$00

Wall1Level5:
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$80,$01,$40,$02
	.db $20,$04,$18,$18,$07,$E0,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$11,$A9,$BF,$6E,$36,$35,$EE,$F7,$BB,$FD,$6F,$52,$BA,$BF
	.db $D7,$B7,$56,$EA,$FF,$FF,$00,$00,$00,$00
Wall2Level5:
	.db $00,$00,$00,$00,$7F,$FF,$80,$01,$83,$B8,$81,$10,$81,$39,$80,$00
	.db $80,$00,$BF,$F0,$A0,$10,$A0,$10,$A7,$10,$A8,$90,$AD,$90,$A8,$90
	.db $A7,$10,$A8,$90,$B8,$D0,$BF,$F0,$90,$40,$90,$40,$80,$00,$80,$00
	.db $80,$00,$DB,$6D,$A4,$92,$FF,$FF,$80,$00,$80,$FF,$80,$83,$80,$83
	.db $80,$83,$80,$83,$80,$83,$80,$83,$80,$8B,$80,$8F,$80,$83,$80,$83
	.db $80,$83,$80,$83,$80,$83,$80,$FF,$00,$00
Wall3Level5:
	.db $00,$00,$00,$00,$FF,$FE,$C2,$81,$98,$81,$AA,$81,$BA,$81,$00,$01
	.db $00,$01,$7F,$E1,$40,$21,$40,$21,$4E,$21,$51,$21,$53,$21,$51,$21
	.db $4E,$21,$51,$61,$51,$A1,$7F,$E1,$00,$01,$00,$01,$00,$01,$00,$01
	.db $00,$01,$B6,$DB,$49,$25,$FF,$FF,$00,$01,$FC,$01,$04,$01,$04,$01
	.db $04,$01,$04,$01,$04,$01,$04,$01,$44,$01,$C4,$01,$04,$01,$04,$01
	.db $04,$01,$04,$01,$04,$01,$FC,$01,$00,$00
	
Wall1Level6:
	.db $03,$DF,$01,$5F,$02,$7F,$03,$FF,$02,$A7,$03,$7B,$03,$DF,$01,$F7
	.db $00,$B7,$00,$22,$00,$02,$00,$02,$01,$42,$0F,$E2,$3F,$FB,$7F,$FF
	.db $1F,$FF,$DF,$FF,$7F,$FF,$7F,$FF,$3F,$FE,$1F,$FF,$53,$FF,$3F,$FF
	.db $1F,$AE,$0D,$DF,$01,$9E,$02,$FB,$00,$8A,$00,$8B,$30,$BB,$78,$BB
	.db $FC,$BA,$FC,$8A,$FE,$8A,$FE,$8A,$FF,$8A,$30,$8A,$30,$8A,$30,$8A
	.db $78,$8A,$FC,$8A,$FF,$FF,$00,$00,$00,$00
Wall2Level6:
	.db $00,$07,$11,$08,$20,$0B,$08,$49,$89,$07,$8D,$D0,$DF,$64,$FF,$DA
	.db $FF,$FC,$FF,$E5,$EF,$E9,$FF,$FF,$FF,$6C,$EF,$F0,$FF,$E0,$FE,$A0
	.db $EF,$A0,$A7,$80,$23,$52,$22,$55,$22,$75,$22,$52,$22,$00,$22,$00
	.db $22,$01,$22,$03,$22,$03,$2E,$07,$2E,$07,$26,$0F,$22,$0F,$22,$1F
	.db $22,$1F,$22,$3F,$22,$3F,$22,$7F,$22,$7F,$22,$01,$22,$01,$22,$01
	.db $22,$01,$22,$03,$FF,$FF,$00,$00,$00,$00
Wall3Level6:
	.db $30,$00,$48,$00,$48,$00,$48,$1E,$31,$D6,$03,$B7,$00,$AD,$25,$9D
	.db $6B,$FF,$1F,$FF,$E7,$FD,$CF,$FF,$47,$FF,$35,$FF,$39,$DF,$20,$CF
	.db $00,$4F,$00,$47,$02,$45,$55,$44,$76,$44,$53,$74,$00,$74,$00,$74
	.db $80,$44,$C0,$44,$C0,$44,$E0,$44,$E0,$44,$F0,$44,$F0,$44,$F8,$44
	.db $F8,$44,$FC,$44,$FC,$44,$FE,$44,$FE,$44,$80,$44,$80,$44,$80,$44
	.db $80,$44,$C0,$44,$FF,$FF,$00,$00,$00,$00	

Wall1Level7:
	.db $E0,$07,$D0,$0B,$C8,$13,$C7,$E3,$E0,$07,$D0,$0B,$C8,$13,$C7,$E3
	.db $C0,$03,$C0,$03,$C0,$03,$C0,$03,$C0,$03,$C0,$03,$C0,$03,$FF,$FF
	.db $80,$01,$80,$01,$FF,$FF,$00,$00,$03,$C0,$1D,$38,$21,$04,$21,$04
	.db $41,$02,$81,$01,$83,$81,$84,$41,$86,$C1,$84,$41,$83,$81,$84,$41
	.db $8C,$61,$8C,$61,$8C,$61,$8B,$A1,$84,$41,$84,$41,$84,$41,$84,$41
	.db $80,$01,$80,$01,$80,$01,$00,$00,$00,$00
Wall2Level7:
	.db $F0,$00,$CC,$00,$C3,$00,$C0,$C0,$C0,$3F,$F0,$00,$CC,$00,$C3,$00
	.db $C0,$C0,$C0,$3F,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$C0,$00,$FF,$FF
	.db $80,$00,$80,$00,$FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1F
	.db $01,$E0,$0E,$00,$30,$00,$50,$00,$90,$00,$BF,$FF,$A0,$00,$BC,$00
	.db $A8,$00,$AA,$B6,$AA,$A5,$AB,$A5,$A0,$00,$BF,$FF,$88,$08,$88,$08
	.db $9C,$1C,$A2,$22,$B6,$36,$A2,$22,$1C,$1C
Wall3Level7:
	.db $00,$0F,$00,$33,$00,$C3,$03,$03,$FC,$03,$00,$0F,$00,$33,$00,$C3
	.db $03,$03,$FC,$03,$00,$03,$00,$03,$00,$03,$00,$03,$00,$03,$FF,$FF
	.db $00,$01,$00,$01,$FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$F8,$00
	.db $07,$80,$00,$70,$00,$0C,$00,$0A,$00,$09,$FF,$FD,$00,$05,$60,$05
	.db $50,$15,$66,$DD,$5A,$95,$6E,$DD,$00,$05,$FF,$FD,$08,$11,$08,$11
	.db $1C,$39,$22,$45,$36,$6D,$22,$45,$1C,$38
	
Wall1Level8:
	.db $55,$55,$AA,$AA,$55,$55,$AA,$AA,$55,$55,$AA,$AA,$FF,$FF,$00,$00
	.db $00,$00,$00,$00,$00,$00,$8F,$FF,$88,$00,$88,$00,$88,$00,$88,$00
	.db $88,$00,$88,$00,$88,$00,$88,$00,$88,$00,$88,$00,$88,$00,$88,$00
	.db $88,$00,$88,$00,$88,$00,$88,$00,$88,$00,$8F,$FF,$88,$00,$88,$00
	.db $8F,$FF,$8D,$55,$8D,$55,$8F,$FF,$88,$00,$88,$00,$8F,$FF,$88,$00
	.db $88,$00,$88,$00,$F8,$00,$00,$00,$00,$00
Wall2Level8:
	.db $55,$55,$AA,$AA,$55,$55,$AA,$AA,$55,$55,$AA,$AA,$FF,$FF,$01,$08
	.db $01,$15,$01,$19,$01,$CC,$FF,$F0,$00,$12,$00,$15,$00,$15,$00,$15
	.db $1C,$12,$64,$10,$44,$10,$44,$10,$44,$1E,$44,$19,$44,$19,$78,$19
	.db $00,$1A,$00,$1C,$00,$10,$00,$10,$00,$10,$FF,$F1,$00,$12,$00,$12
	.db $FF,$F4,$55,$54,$55,$50,$FF,$F0,$00,$10,$00,$10,$FF,$F0,$00,$10
	.db $00,$10,$1E,$10,$3F,$1F,$1E,$00,$00,$00
Wall3Level8:
	.db $55,$55,$AA,$AA,$55,$55,$AA,$AA,$55,$55,$AA,$AA,$FF,$FF,$94,$80
	.db $55,$40,$55,$80,$C8,$C0,$01,$FF,$21,$00,$51,$00,$61,$00,$51,$00
	.db $51,$00,$01,$10,$01,$10,$01,$08,$01,$08,$41,$08,$09,$08,$55,$04
	.db $59,$04,$4D,$00,$01,$00,$01,$00,$81,$00,$01,$FF,$01,$00,$01,$00
	.db $01,$FF,$01,$55,$09,$55,$25,$FF,$93,$00,$4B,$00,$29,$FF,$21,$00
	.db $01,$00,$01,$00,$FF,$00,$00,$00,$00,$00

Wall1Level9:
	.db $06,$00,$39,$E0,$C0,$10,$84,$4C,$88,$22,$80,$0A,$78,$92,$07,$6C
	.db $00,$00,$00,$00,$0C,$0C,$1A,$1E,$16,$16,$1A,$DE,$17,$FA,$5A,$BE
	.db $F7,$F7,$BA,$BF,$F7,$FB,$BA,$BF,$F7,$F7,$BB,$FF,$FE,$1B,$E0,$07
	.db $00,$03,$00,$00,$FF,$FF,$21,$08,$21,$08,$21,$08,$21,$08,$21,$08
	.db $21,$08,$FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $F0,$F0,$00,$00,$00,$00,$00,$00,$00,$00	
Wall2Level9:
	.db $06,$00,$39,$E0,$C0,$13,$84,$0E,$88,$42,$80,$23,$78,$81,$07,$7E
	.db $00,$02,$00,$07,$00,$07,$00,$05,$00,$05,$5E,$05,$F6,$07,$DF,$FD
	.db $7B,$6D,$B7,$FD,$FF,$D5,$BB,$FF,$DB,$E0,$BE,$00,$E0,$00,$00,$00
	.db $00,$00,$00,$00,$FF,$FF,$42,$10,$42,$10,$42,$10,$42,$10,$42,$10
	.db $42,$10,$FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $F0,$F0,$00,$00,$00,$00,$00,$00,$00,$00
Wall3Level9:
	.db $18,$00,$E7,$80,$00,$40,$10,$30,$20,$88,$00,$08,$E0,$88,$1F,$70
	.db $00,$00,$00,$00,$00,$00,$F8,$00,$68,$1C,$D8,$6C,$B8,$54,$4F,$EF
	.db $AD,$F5,$DB,$DF,$6E,$EE,$FF,$D7,$07,$ED,$00,$7F,$00,$07,$00,$00
	.db $00,$00,$00,$00,$FF,$FF,$84,$21,$84,$21,$84,$21,$84,$21,$84,$21
	.db $84,$21,$FF,$FF,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $F0,$F0,$00,$00,$00,$00,$00,$00,$00,$00

Wall1Level10:
	.db $21,$08,$10,$84,$08,$42,$84,$21,$42,$10,$FF,$FF,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$74,$00
	.db $20,$00,$24,$00,$24,$00,$00,$00,$A0,$D0,$E6,$83,$AA,$D5,$AE,$97
	.db $00,$00,$00,$00,$00,$00,$24,$70,$24,$88,$3C,$88,$24,$88,$24,$78
	.db $00,$04,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00
Wall2Level10:
	.db $42,$10,$21,$08,$10,$84,$08,$42,$84,$21,$FF,$FF,$64,$4C,$55,$54
	.db $65,$54,$42,$94,$0F,$FC,$17,$FA,$14,$0A,$17,$AA,$15,$0A,$15,$2A
	.db $14,$0A,$13,$F2,$15,$56,$10,$12,$15,$AA,$15,$92,$10,$02,$15,$56
	.db $10,$02,$15,$56,$10,$02,$15,$56,$10,$02,$15,$56,$10,$02,$14,$06
	.db $11,$52,$0F,$FC,$00,$00,$A4,$C0,$92,$22,$A4,$42,$92,$82,$A4,$82
	.db $00,$01,$32,$02,$45,$55,$46,$76,$33,$53
Wall3Level10:
	.db $84,$20,$42,$10,$21,$08,$10,$84,$08,$42,$FF,$FF,$08,$1C,$15,$50
	.db $14,$9C,$15,$44,$08,$1C,$70,$00,$20,$00,$2A,$CC,$2A,$94,$2E,$94
	.db $00,$00,$00,$00,$60,$00,$50,$08,$63,$6A,$55,$4C,$67,$6A,$00,$00
	.db $00,$00,$48,$22,$69,$22,$5A,$AA,$49,$36,$00,$00,$7F,$FE,$00,$00
	.db $7F,$FE,$00,$00,$7F,$FE,$00,$00,$B3,$B0,$AA,$28,$B3,$30,$AA,$28
	.db $33,$A8,$22,$08,$75,$68,$26,$4E,$23,$6A
	
	
	
Levels:
	.dw Level1
	.dw Level2
	.dw Level3
	.dw Level4
	.dw Level5
	.dw Level6
	.dw Level7
	.dw Level8
	.dw Level9
	.dw Level10
	
Level1:
	.dw Wall1Level1
	.dw Wall1Level1
	.dw Wall2Level1
	.dw Wall3Level1
	.dw Wall1Level1
	.dw Wall1Level1
	.dw Wall2Level1
	.dw Wall3Level1
	.dw Wall1Level1
	.dw Wall1Level1
	.dw Wall1Level1
	.dw Wall1Level1
	.dw Wall2Level1
	.dw Wall3Level1
	.dw Wall1Level1
		
Level2:
	.dw Wall2Level2
	.dw Wall3Level2
	.dw Wall2Level2
	.dw Wall3Level2
	.dw Wall1Level2
	.dw Wall1Level2
	.dw Wall1Level2
	.dw Wall1Level2
	.dw Wall3Level2
	.dw Wall2Level2
	.dw Wall3Level2
	.dw Wall1Level2
	.dw Wall1Level2
	.dw Wall2Level2
	.dw Wall3Level2
	
Level3:
	.dw Wall1Level3
	.dw Wall2Level3
	.dw Wall3Level3
	.dw Wall1Level3
	.dw Wall1Level3
	.dw Wall2Level3
	.dw wall3Level3
	.dw Wall1Level3
	.dw Wall1Level3
	.dw Wall1Level3
	.dw Wall2Level3
	.dw Wall3Level3	
	.dw Wall1Level3
	.dw Wall2Level3
	.dw Wall3Level3
	
Level4:
	.dw Wall1Level4
	.dw Wall1Level4
	.dw Wall2Level4
	.dw Wall3Level4
	.dw Wall1Level4
	.dw Wall1Level4
	.dw Wall1Level4
	.dw Wall2Level4
	.dw Wall3Level4
	.dw Wall1Level4
	.dw Wall1Level4
	.dw Wall1Level4
	.dw Wall2Level4
	.dw Wall3Level4
	.dw Wall1Level4
	
Level5:
	.dw Wall2Level5
	.dw Wall3Level5
	.dw Wall1Level5
	.dw Wall1Level5
	.dw Wall2Level5
	.dw Wall3Level5
	.dw Wall1Level5
	.dw Wall2Level5
	.dw Wall3Level5
	.dw Wall1Level5
	.dw Wall1Level5
	.dw Wall2Level5
	.dw Wall3Level5
	.dw Wall1Level5
	.dw Wall1Level5
	
Level6:
	.dw Wall1Level6
	.dw Wall1Level6
	.dw Wall2Level6
	.dw Wall3Level6
	.dw Wall1Level6
	.dw Wall1Level6
	.dw Wall1Level6
	.dw Wall2Level6
	.dw Wall3Level6
	.dw Wall1Level6
	.dw Wall2Level6
	.dw Wall3Level6
	.dw Wall2Level6
	.dw Wall3Level6
	.dw Wall1Level6
	
Level7:
	.dw Wall1Level7
	.dw Wall1Level7
	.dw Wall2Level7
	.dw Wall3Level7
	.dw Wall1Level7
	.dw Wall1Level7
	.dw Wall1Level7
	.dw Wall1Level7
	.dw Wall2Level7
	.dw Wall3Level7
	.dw Wall1Level7
	.dw Wall2Level7
	.dw wall3Level7
	.dw Wall1Level7
	.dw Wall1Level7
	
Level8:
	.dw Wall1Level8
	.dw Wall2Level8
	.dw Wall3Level8
	.dw Wall1Level8
	.dw Wall1Level8
	.dw Wall1Level8
	.dw Wall2Level8
	.dw Wall3Level8
	.dw Wall1Level8
	.dw Wall2Level8
	.dw Wall3Level8
	.dw Wall1Level8
	.dw Wall2Level8
	.dw Wall3Level8
	.dw Wall1Level8
	
Level9:
	.dw Wall1Level9
	.dw Wall1Level9
	.dw Wall2Level9
	.dw Wall3Level9
	.dw Wall1Level9
	.dw Wall1Level9
	.dw Wall2Level9
	.dw Wall3Level9
	.dw Wall1Level9
	.dw Wall1Level9
	.dw Wall2Level9
	.dw Wall3Level9
	.dw Wall2Level9
	.dw Wall3Level9
	.dw Wall1Level9
	
Level10:
	.dw Wall1Level10
	.dw Wall1Level10
	.dw Wall2Level10
	.dw Wall3Level10
	.dw Wall1Level10
	.dw Wall1Level10
	.dw Wall2Level10
	.dw Wall3Level10
	.dw Wall1Level10
	.dw Wall1Level10
	.dw Wall1Level10
	.dw Wall2Level10
	.dw Wall3Level10
	.dw Wall1Level10
	.dw Wall1Level10
	
	
	
ObjLevels:
;0 = nothing
;box
;pipe
;ax
	.dw ObjLevel1
	.dw ObjLevel2
	.dw ObjLevel3
	.dw ObjLevel4
	.dw ObjLevel5
	.dw ObjLevel6
	.dw ObjLevel7
	.dw ObjLevel8
	.dw ObjLevel9
	.dw ObjLevel10
	
ObjLevel1:
	.dw 0
	.dw 0
	.dw box
	.dw 0
	.dw 0
	.dw 0
	.dw box
	.dw 0
	.dw 0
	.dw 0
	.dw 0
	.dw box
	.dw 0
	.dw 0
	.dw 0
ObjLevel2:
	.dw 0
	.dw 0
	.dw box
	.dw 0
	.dw 0
	.dw 0
	.dw box
	.dw 0
	.dw 0
	.dw box
	.dw 0
	.dw 0
	.dw 0
	.dw 0
	.dw 0
ObjLevel3:
	.dw 0
	.dw 0
	.dw pipe
	.dw 0
	.dw 0
	.dw 0
	.dw box
	.dw 0
	.dw box
	.dw 0
	.dw box
	.dw 0
	.dw 0
	.dw 0
	.dw 0
ObjLevel4:
	.dw 0
	.dw 0
	.dw 0
	.dw 0
	.dw 0
	.dw 0
	.dw box
	.dw 0
	.dw box
	.dw 0
	.dw pipe
	.dw 0
	.dw 0
	.dw 0
	.dw 0
ObjLevel5:
	.dw 0
	.dw box
	.dw 0
	.dw 0
	.dw pipe
	.dw 0
	.dw ax
	.dw 0
	.dw 0
	.dw pipe
	.dw 0
	.dw box
	.dw 0
	.dw 0
	.dw 0
ObjLevel6:
	.dw 0
	.dw 0
	.dw pipe
	.dw 0
	.dw box
	.dw 0
	.dw ax
	.dw box
	.dw 0
	.dw 0
	.dw 0
	.dw box
	.dw pipe
	.dw ax
	.dw 0
ObjLevel7:
	.dw 0
	.dw ax
	.dw 0
	.dw 0
	.dw pipe
	.dw 0
	.dw ax
	.dw pipe
	.dw box
	.dw 0
	.dw 0
	.dw box
	.dw 0
	.dw 0
	.dw 0	
ObjLevel8:
	.dw 0
	.dw ax
	.dw 0
	.dw box
	.dw pipe
	.dw 0
	.dw ax
	.dw 0
	.dw box
	.dw 0
	.dw ax
	.dw box
	.dw 0
	.dw 0
	.dw 0
ObjLevel9:
	.dw 0
	.dw ax
	.dw 0
	.dw box
	.dw pipe
	.dw 0
	.dw ax
	.dw 0
	.dw pipe
	.dw 0
	.dw ax
	.dw box
	.dw ax
	.dw box
	.dw 0
ObjLevel10:
	.dw 0
	.dw box
	.dw 0
	.dw 0
	.dw 0
	.dw 0
	.dw 0
	.dw 0
	.dw 0
	.dw box
	.dw 0
	.dw 0
	.dw 0
	.dw 0
	.dw 0
	
	
	
StatStuff:
	
Score:
	.db $00, $80, $00, $00, $00, $00, $00, $00, $00  ;starts at 0 duh!
	
LifeSprite:
	.db $DB,$7E,$81,$A5,$81,$81,$A5,$99,$42,$24		;10 pixels tall
	
	
EnemyTable:
BossLeft:
	.db $3E,$7F,$5D,$7F,$6F,$7F,$3E,$1C,$14,$22,$63,$63,$63,$63,$63,$63		;25 pixels tall
	.db $63,$22,$22,$3E,$36,$36,$36,$36,$7E
BossRight:
	.db $7C,$FE,$BA,$FE,$F6,$FE,$7C,$38,$28,$44,$C6,$C6,$C6,$C6,$C6,$C6
	.db $C6,$44,$44,$7C,$6C,$6C,$6C,$6C,$7E
GirlLeft:
	.db $3E,$43,$63,$43,$25,$23,$E2,$22,$2E,$22,$22,$1C,$22,$22,$22			;15 pixels tall
GirlRight:
	.db $7C,$C2,$C6,$C2,$A4,$C4,$47,$44,$74,$44,$44,$38,$44,$44,$44
GuyLeft:
	.db $1E,$3F,$23,$33,$21,$22,$1D,$11,$71,$17,$11,$0E,$11,$11,$11
GuyRight:
	.db $78,$FC,$C4,$CC,$84,$44,$B8,$88,$8E,$E8,$88,$70,$88,$88,$88
	
	
GuyPunchKickTable:
GuyKickLeft1:
	.db $1E,$3F,$23,$33,$21,$22,$1D,$11,$71,$17,$11,$0E,$11,$21,$41
GuyKickLeft2:
	.db $1E,$3F,$23,$33,$21,$22,$1D,$11,$71,$17,$11,$8E,$F1,$01,$01
GuyPunchLeft1:
	.db $1E,$3F,$23,$33,$21,$22,$1D,$11,$31,$13,$3D,$0E,$11,$11,$11
GuyPunchLeft2:
	.db $1E,$3F,$23,$33,$21,$22,$1D,$31,$11,$FF,$11,$0E,$11,$11,$11
GuyKickRight1:
	.db $78,$FC,$C4,$CC,$84,$44,$B8,$88,$8E,$E8,$88,$70,$88,$84,$82
GuyKickRight2:
	.db $78,$FC,$C4,$CC,$84,$44,$B8,$88,$8E,$E8,$88,$71,$8F,$80,$80
GuyPunchRight1:
	.db $78,$FC,$C4,$CC,$84,$44,$B8,$88,$8C,$C8,$BC,$70,$88,$88,$88
GuyPunchRight2:
	.db $78,$FC,$C4,$CC,$84,$44,$B8,$8C,$88,$FF,$88,$70,$88,$88,$88

	
GirlPunchKickTable:
GirlKickLeft1:
	.db $3E,$43,$63,$43,$25,$23,$E2,$22,$2E,$22,$22,$1C,$22,$42,$82
GirlKickLeft2:
	.db $3E,$43,$63,$43,$25,$23,$E2,$22,$2E,$22,$22,$9C,$E2,$02,$02
GirlPunchLeft1:
	.db $3E,$43,$63,$43,$25,$23,$62,$22,$26,$7A,$1C,$22,$22,$22,$22
GirlPunchLeft2:
	.db $3E,$43,$63,$43,$25,$23,$22,$22,$FE,$22,$1C,$22,$22,$22,$22
GirlKickRight1:
	.db $7C,$C2,$C6,$C2,$A4,$C4,$47,$44,$74,$44,$44,$38,$44,$42,$41
GirlKickRight2:
	.db $7C,$C2,$C6,$C2,$A4,$C4,$47,$44,$74,$44,$44,$39,$47,$40,$40
GirlPunchRight1:
	.db $7C,$C2,$C6,$C2,$A4,$C4,$46,$44,$64,$5E,$44,$38,$44,$44,$44
GirlPunchRight2:
	.db $7C,$C2,$C6,$C2,$A4,$C4,$44,$44,$7F,$44,$44,$38,$44,$44,$44
	
	
BossPunchKickTable:
BossKickLeft1:
	.db $3E,$7F,$5D,$7F,$6F,$7F,$3E,$1C,$14,$22,$63,$63,$63,$63,$63,$63
	.db $63,$22,$22,$3E,$36,$66,$66,$C6,$CE
BossKickLeft2:
	.db $3E,$7F,$5D,$7F,$6F,$7F,$3E,$1C,$14,$22,$63,$63,$63,$63,$63,$63
	.db $63,$22,$22,$3E,$B6,$F6,$F6,$06,$0E
BossPunchLeft1:
	.db $3E,$7F,$5D,$7F,$6F,$7F,$3E,$1C,$14,$22,$63,$63,$63,$63,$26,$7A
	.db $22,$22,$22,$3E,$36,$36,$36,$36,$7E
BossPunchLeft2:
	.db $3E,$7F,$5D,$7F,$6F,$7F,$3E,$1C,$14,$22,$63,$63,$63,$23,$FF,$22
	.db $22,$22,$22,$3E,$36,$36,$36,$36,$7E
BossKickRight1:
	.db $7C,$FE,$BA,$FE,$F6,$FE,$7C,$38,$28,$44,$C6,$C6,$C6,$C6,$C6,$C6
	.db $C6,$44,$44,$7C,$6C,$66,$66,$63,$73	
BossKickRight2:
	.db $7C,$FE,$BA,$FE,$F6,$FE,$7C,$38,$28,$44,$C6,$C6,$C6,$C6,$C6,$C6
	.db $C6,$44,$44,$7C,$6D,$6F,$6F,$60,$70
BossPunchRight1:
	.db $7C,$FE,$BA,$FE,$F6,$FE,$7C,$38,$28,$44,$C6,$C6,$C6,$C6,$64,$5E
	.db $44,$44,$44,$7C,$6C,$6C,$6C,$6C,$7E
BossPunchRight2:
	.db $7C,$FE,$BA,$FE,$F6,$FE,$7C,$38,$28,$44,$C6,$C6,$C6,$C4,$FF,$44
	.db $44,$44,$44,$7C,$6C,$6C,$6C,$6C,$7E


	
EnemyLevels:
;Enemies are triggered either right as you get to the square, or when it is about to go off screen
;can't move map when fighting enemies
;first byte: 0 = nothing, 1 = as you get to the square, 2 = when it is about to go off screen
;second byte:  0 = nothing, 1 = Guy, 2 = Girl, 3 = Boss
	.dw EnemyLevel1
	.dw EnemyLevel2
	.dw EnemyLevel3
	.dw EnemyLevel4
	.dw EnemyLevel5
	.dw EnemyLevel6
	.dw EnemyLevel7
	.dw EnemyLevel8
	.dw EnemyLevel9
	.dw EnemyLevel10
	
EnemyLevel1:
	.db 0,0				;1
	.db 2,3				;2
	.db 0,0				;3
	.db 0,0				;4
	.db 0,0				;5
	.db 1,2				;6
	.db 1,2				;7
	.db 2,1				;8
	.db 0,0				;9    ;no as it's about to go off screen's beyond this point
	.db 1,1				;10
	.db 1,1				;11
	.db 0,0				;12
	.db 1,1				;13
	.db 1,3				;14
	.db 0,0				;15	;can't put anything here
	
EnemyLevel2:
	.db 2,2				;1
	.db 0,0				;2
	.db 0,0				;3
	.db 2,1				;4
	.db 0,0				;5
	.db 1,2				;6
	.db 1,1				;7
	.db 2,2				;8
	.db 1,1				;9    ;no as it's about to go off screen's beyond this point
	.db 1,1				;10
	.db 0,0				;11
	.db 0,0				;12
	.db 1,1				;13
	.db 1,3				;14
	.db 0,0				;15	;can't put anything here
	
EnemyLevel3:
	.db 2,1				;1
	.db 0,0				;2
	.db 0,0				;3
	.db 2,1				;4
	.db 0,0				;5
	.db 1,2				;6
	.db 1,1				;7
	.db 2,2				;8
	.db 1,1				;9    ;no as it's about to go off screen's beyond this point
	.db 1,1				;10
	.db 0,0				;11
	.db 1,1				;12
	.db 0,0				;13
	.db 1,3				;14
	.db 0,0				;15	;can't put anything here
	
EnemyLevel4:
	.db 2,2				;1
	.db 2,1				;2
	.db 0,0				;3
	.db 2,1				;4
	.db 0,0				;5
	.db 1,2				;6
	.db 1,1				;7
	.db 2,2				;8
	.db 1,1				;9    ;no as it's about to go off screen's beyond this point
	.db 1,1				;10
	.db 0,0				;11
	.db 0,0				;12
	.db 1,1				;13
	.db 1,3				;14
	.db 0,0				;15	;can't put anything here
	
EnemyLevel5:
	.db 2,2				;1
	.db 2,1				;2
	.db 0,0				;3
	.db 2,1				;4
	.db 0,0				;5
	.db 1,2				;6
	.db 1,1				;7
	.db 0,0				;8
	.db 1,1				;9    ;no as it's about to go off screen's beyond this point
	.db 1,1				;10
	.db 0,0				;11
	.db 0,0				;12
	.db 1,3				;13
	.db 1,3				;14
	.db 0,0				;15	;can't put anything here
	
EnemyLevel6:
	.db 2,1				;1
	.db 2,1				;2
	.db 0,0				;3
	.db 2,2				;4
	.db 0,0				;5
	.db 1,1				;6
	.db 1,1				;7
	.db 0,0				;8
	.db 2,1				;9    ;no as it's about to go off screen's beyond this point
	.db 1,3				;10
	.db 0,0				;11
	.db 0,0				;12
	.db 1,1				;13
	.db 1,3				;14
	.db 0,0				;15	;can't put anything here
	
EnemyLevel7:
	.db 0,0				;1
	.db 2,1				;2
	.db 2,1				;3
	.db 2,1				;4
	.db 0,0				;5
	.db 1,2				;6
	.db 1,2				;7
	.db 0,0				;8
	.db 2,1				;9    ;no as it's about to go off screen's beyond this point
	.db 1,3				;10
	.db 0,0				;11
	.db 1,1				;12
	.db 1,3				;13
	.db 1,3				;14
	.db 0,0				;15	;can't put anything here
	
EnemyLevel8:
	.db 0,0				;1
	.db 2,1				;2
	.db 2,1				;3
	.db 2,3				;4
	.db 0,0				;5
	.db 1,2				;6
	.db 1,1				;7
	.db 2,3				;8
	.db 1,1				;9    ;no as it's about to go off screen's beyond this point
	.db 1,3				;10
	.db 0,0				;11
	.db 1,1				;12
	.db 1,1				;13
	.db 1,3				;14
	.db 0,0				;15	;can't put anything here
	
EnemyLevel9:
	.db 0,0				;1
	.db 2,1				;2
	.db 2,3				;3
	.db 2,3				;4
	.db 0,0				;5
	.db 1,2				;6
	.db 1,1				;7
	.db 1,3				;8
	.db 1,1				;9    ;no as it's about to go off screen's beyond this point
	.db 1,3				;10
	.db 0,0				;11
	.db 1,1				;12
	.db 1,1				;13
	.db 1,3				;14
	.db 0,0				;15	;can't put anything here
	
EnemyLevel10:
	.db 0,0				;1
	.db 2,3				;2
	.db 2,3				;3
	.db 2,1				;4
	.db 2,2				;5
	.db 1,3				;6
	.db 1,3				;7
	.db 2,3				;8
	.db 1,3				;9    ;no as it's about to go off screen's beyond this point
	.db 1,3				;10
	.db 1,1				;11
	.db 1,3				;12
	.db 1,3				;13
	.db 1,3				;14
	.db 0,0				;15	;can't put anything here
	
	
	
	
	
PlayerDamageTable:
;	Hit Points
;	Points
;	Stamina Points
PunchDamage:
	.db 5
	.dw 50
	.db 3
KickDamage:
	.db 6
	.dw 60
	.db 4
JumpDamage:
	.db 10
	.dw 100
	.db 12
BoxDamage:
	.db 20
	.dw 500
	.db 12
PipeDamage:
	.db 20
	.dw 400
	.db 12
AxDamage:
	.db 20
	.dw 750
	.db 6
	
PlayerHealthTable:
;Hit Points
;Stamina Points
	.db 46
	.db 12
	
	
	
EnemyDamageTable:
;Hit Points
;Stamina Points
GuyGirlDamagePunchKick:
	.db 1
	.db 3
BossDamagePunchKick:
	.db 5
	.db 6
	
EnemyHealthTable:
;Hit Points
;Stamina Points
;Hit Points increase by 10 per level
GuyHealth:
	.db 35
	.db 12
GirlHealth:
	.db 25
	.db 12
BossHealth:
	.db 150
	.db 24
	

BackUpEnemyDamageTable:
	.db 1
	.db 3
	.db 5
	.db 6
	.db 35
	.db 12
	.db 25
	.db 12
	.db 150
	.db 24
	
PlayerFallTable:
PlayerFallLeft:
	.db $01,$00,$01,$1C,$FF,$EA,$20,$02,$2C,$02,$58,$22,$8F,$DC			;14 bytes, 7 bytes tall, 2 bytes wide
PlayerFallRight:
	.db $01,$00,$71,$00,$AF,$FE,$80,$08,$80,$68,$88,$34,$77,$E2
	
EnemyFallTable:
EnemyGuyFall:
	.db $02,$00,$02,$7C,$EF,$96,$10,$86,$14,$86,$14,$5E,$EF,$BC
EnemyGirlFall:
	.db $00,$9C,$EF,$EA,$10,$02,$12,$02,$12,$22,$EF,$DE,$00,$7C
EnemyBossFall:
	.db $83,$8E,$FF,$DD,$F0,$37,$90,$3F,$F0,$3F,$FF,$DD,$03,$8E
	
	
ThumbsUpLayer1:
.db $00,$00,$01,$80,$02,$40,$02,$40,$04,$40,$08,$80,$10,$80,$60,$E0		;32 bytes, 16 bites tall, 16 bits wide
.db $C0,$10,$80,$10,$80,$F0,$80,$10,$C0,$E0,$20,$20,$1F,$C0,$00,$00

ThumbsUpLayer2:
.db $00,$00,$01,$80,$03,$C0,$03,$C0,$07,$C0,$0F,$80,$1F,$80,$7F,$E0
.db $FF,$F0,$FF,$F0,$FF,$F0,$FF,$F0,$FF,$E0,$3F,$E0,$1F,$C0,$00,$00

msgLevel:
	.db "Level:",0
	
	
msgPause:
	.db ":::Pause Menu:::"
	.db "                "
	.db "1. Continue     "
	.db "2. Quit and Save"
	.db "3. Quit Without "
	.db "   Saving",0
	
	
	
	
Menupic:
	.db $FF,$FF,$FF,$FF,$FF,$FF,$FC,$FF,$FC,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	.db $FF,$3C,$FC,$FF,$FC,$FF,$FF,$FF,$FF,$80,$FF,$FF,$FF,$3C,$FC,$87
	.db $FC,$FF,$FF,$FF,$FF,$80,$7F,$F0,$FF,$3C,$FC,$01,$F9,$FF,$FF,$FF
	.db $FF,$80,$1F,$E0,$7F,$3C,$FC,$31,$F9,$FF,$FF,$FF,$FF,$9F,$0F,$CF
	.db $3F,$3C,$FC,$79,$F9,$FE,$0F,$FF,$FF,$9F,$8F,$CF,$3F,$3C,$FC,$79
	.db $F9,$FC,$07,$FF,$FF,$9F,$8F,$CF,$3F,$3C,$FC,$79,$F9,$F8,$E7,$FF
	.db $FF,$9F,$8F,$CF,$3F,$38,$FC,$31,$F9,$F8,$E7,$FF,$FF,$9F,$8F,$CF
	.db $3F,$00,$7C,$03,$F1,$F8,$07,$FF,$FF,$9F,$8F,$E0,$7F,$80,$7C,$87
	.db $F3,$F9,$FF,$FF,$FF,$9F,$0F,$F0,$FF,$FF,$FF,$FF,$F3,$F9,$FF,$FF
	.db $FF,$80,$1F,$FF,$FF,$FF,$FF,$FF,$F3,$F8,$FF,$FF,$FF,$80,$30,$3F
	.db $FF,$FF,$FF,$FF,$FF,$FC,$0F,$FF,$FF,$80,$70,$1F,$FF,$FF,$FF,$FF
	.db $FF,$FE,$0F,$FF,$FF,$FF,$F3,$CF,$8F,$87,$E3,$F8,$FC,$0F,$FF,$FF
	.db $FF,$FF,$F3,$E7,$87,$07,$C1,$F0,$38,$0F,$FF,$FF,$FF,$FF,$F3,$E7
	.db $9F,$E7,$99,$E7,$39,$CF,$FF,$FF,$FF,$FF,$F3,$E7,$9F,$87,$99,$E7
	.db $39,$CF,$FF,$FF,$FF,$FF,$F3,$E7,$9F,$07,$99,$E7,$39,$CF,$FF,$FF
	.db $FF,$FF,$F3,$CF,$9F,$27,$C1,$F0,$79,$CF,$FF,$FF,$FF,$FF,$F0,$1F
	.db $9F,$07,$F9,$F8,$F9,$CF,$FF,$FF,$FF,$FF,$F0,$3F,$FF,$FF,$99,$FF
	.db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$83,$FF,$FF,$FF,$FF,$FF
	.db $FF,$FD,$FF,$FD,$D0,$5D,$C6,$38,$DD,$07,$FF,$FF,$FF,$F9,$FF,$FD
	.db $D7,$DD,$FD,$D7,$49,$7F,$FF,$FF,$FF,$FD,$FF,$FC,$D7,$DD,$FD,$F7
	.db $55,$7F,$FF,$FF,$FF,$FD,$FF,$FD,$50,$D5,$FD,$10,$5D,$0F,$FF,$FF
	.db $FF,$FD,$FF,$FD,$97,$D5,$FD,$D7,$5D,$7F,$FF,$FF,$FF,$FD,$E7,$FD
	.db $D7,$D5,$FD,$D7,$5D,$7F,$FF,$FF,$FF,$F0,$E7,$FD,$D0,$6B,$FE,$17
	.db $5D,$07,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	.db $FF,$F8,$FF,$FE,$38,$DD,$06,$37,$5D,$07,$FF,$FF,$FF,$FF,$7F,$FD
	.db $D7,$5D,$DF,$77,$5D,$7F,$FF,$FF,$FF,$FF,$7F,$FD,$F7,$4D,$DF,$73
	.db $5D,$7F,$FF,$FF,$FF,$FE,$FF,$FD,$F7,$55,$DF,$75,$5D,$0F,$FF,$FF
	.db $FF,$FD,$FF,$FD,$F7,$59,$DF,$76,$5D,$7F,$FF,$FF,$FF,$FB,$E7,$FD
	.db $D7,$5D,$DF,$77,$5D,$7F,$FF,$FF,$FF,$F8,$67,$FE,$38,$DD,$DE,$37
	.db $63,$07,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	.db $FF,$F0,$7F,$FD,$D8,$E3,$76,$18,$E3,$0C,$18,$7F,$FF,$FE,$FF,$FD
	.db $DD,$DD,$75,$F7,$5D,$75,$F7,$FF,$FF,$FD,$FF,$FD,$DD,$DF,$75,$F7
	.db $DD,$75,$F7,$FF,$FF,$FE,$FF,$FC,$1D,$D1,$06,$37,$DD,$0C,$18,$FF
	.db $FF,$FF,$7F,$FD,$DD,$DD,$77,$D7,$DD,$5D,$FF,$7F,$FF,$FF,$67,$FD
	.db $DD,$DD,$77,$D7,$5D,$6D,$FF,$7F,$FF,$F0,$E7,$FD,$D8,$E1,$74,$38
	.db $E3,$74,$10,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	.db $FF,$FE,$FF,$FE,$38,$DD,$04,$38,$DF,$87,$FF,$FF,$FF,$FC,$FF,$FD
	.db $D7,$5D,$DD,$D7,$5F,$7F,$FF,$FF,$FF,$FA,$FF,$FD,$F7,$4D,$DD,$D7
	.db $5F,$7F,$FF,$FF,$FF,$F6,$FF,$FD,$F7,$55,$DC,$37,$5F,$8F,$FF,$FF
	.db $FF,$F0,$7F,$FD,$F7,$59,$DD,$77,$5F,$F7,$FF,$FF,$FF,$FE,$E7,$FD
	.db $D7,$5D,$DD,$B7,$5F,$F7,$FF,$FF,$FF,$FE,$E7,$FE,$38,$DD,$DD,$D8
	.db $C1,$0F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	.db $FF,$F0,$7F,$FE,$37,$63,$07,$FF,$FF,$FF,$FF,$FF,$FF,$F7,$FF,$FD
	.db $D7,$77,$DF,$FF,$FF,$FF,$FF,$FF,$FF,$F0,$FF,$FD,$D7,$77,$DF,$FF
	.db $FF,$FF,$FF,$FF,$FF,$FF,$7F,$FD,$D7,$77,$DF,$FF,$FF,$FF,$FF,$FF
	.db $FF,$FF,$7F,$FD,$57,$77,$DF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$67,$FD
	.db $B7,$77,$DF,$FF,$FF,$FF,$FF,$FF,$FF,$F0,$E7,$FE,$58,$E3,$DF,$FF
	.db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	
	
	
MenuVectorTable:
	.dw NewGame
	.dw ContinueGame
	.dw HighScores
	.dw Controls
	.dw Quit
	
	
	
OpeningPicLayer1:
	.db $FF,$FF,$DF,$FF,$FF,$FF,$FF,$FF,$FF,$F3,$FF,$FF,$FF,$EF,$CE,$30
	.db $7F,$FF,$FF,$FF,$87,$F3,$FF,$FF,$FF,$CF,$00,$00,$1F,$FF,$FF,$F0
	.db $00,$01,$F7,$FF,$FF,$CC,$00,$00,$03,$FF,$FF,$E0,$00,$00,$23,$FF
	.db $FF,$C0,$18,$80,$01,$FF,$FF,$80,$00,$08,$33,$FF,$FF,$C6,$38,$C1
	.db $00,$7F,$FE,$00,$00,$0D,$73,$FF,$FF,$8E,$3E,$FF,$C0,$3F,$FE,$03
	.db $FF,$DC,$F9,$FF,$FF,$1E,$19,$FF,$80,$1F,$F8,$C3,$FF,$F8,$78,$FF
	.db $FF,$08,$1F,$FF,$B6,$DF,$F3,$FF,$FF,$F8,$00,$F7,$E4,$00,$1F,$FF
	.db $FE,$DF,$F0,$7F,$FF,$F8,$00,$37,$C0,$01,$1F,$FF,$FF,$DF,$F7,$6F
	.db $FF,$F8,$00,$03,$C0,$00,$3F,$FF,$FF,$FF,$FF,$FF,$FF,$FC,$00,$C3
	.db $E0,$00,$7F,$F0,$38,$01,$80,$18,$7F,$FE,$00,$07,$E0,$18,$F0,$E0
	.db $08,$01,$80,$00,$7E,$0F,$98,$07,$F0,$11,$E0,$40,$08,$01,$80,$00
	.db $7E,$03,$8C,$07,$F0,$71,$00,$43,$00,$01,$82,$00,$7F,$00,$0C,$0F
	.db $F8,$60,$00,$43,$00,$01,$80,$00,$7F,$00,$04,$1F,$FE,$60,$00,$43
	.db $00,$01,$80,$00,$7F,$00,$07,$7F,$FF,$F6,$08,$41,$00,$01,$80,$00
	.db $7F,$08,$77,$FF,$FF,$FE,$08,$40,$00,$01,$80,$00,$1F,$0C,$7F,$FF
	.db $FF,$FE,$18,$00,$00,$01,$80,$00,$0F,$0F,$FF,$FF,$FF,$FE,$18,$00
	.db $00,$01,$80,$00,$00,$0F,$FF,$FF,$FF,$FE,$08,$00,$00,$01,$80,$00
	.db $40,$03,$FF,$FF,$FF,$FE,$00,$00,$00,$01,$82,$00,$60,$01,$FF,$FF
	.db $FF,$FE,$00,$00,$00,$21,$82,$00,$42,$01,$FF,$FF,$FF,$FE,$00,$00
	.db $00,$01,$80,$00,$02,$03,$FF,$FF,$FF,$FE,$00,$40,$00,$01,$80,$00
	.db $00,$0A,$FF,$FF,$FF,$FC,$00,$40,$1C,$03,$00,$00,$01,$02,$3F,$FF
	.db $FF,$F8,$00,$82,$FE,$3F,$FE,$36,$00,$00,$1F,$FF,$FF,$F0,$01,$00
	.db $08,$FF,$FE,$1A,$80,$00,$0F,$FF,$FF,$E0,$00,$1C,$0C,$3F,$FC,$00
	.db $04,$00,$07,$FF,$FF,$E0,$00,$00,$08,$1F,$E0,$00,$00,$00,$07,$FF
	.db $FF,$C0,$00,$00,$1C,$0F,$C0,$00,$00,$00,$03,$FF,$FF,$E0,$00,$00
	.db $7C,$0F,$82,$18,$00,$00,$03,$FF,$FF,$C0,$00,$00,$78,$0F,$87,$18
	.db $00,$02,$01,$FF,$FF,$C0,$00,$00,$78,$07,$07,$D8,$00,$00,$01,$FF
	.db $FF,$80,$00,$00,$78,$07,$0F,$F8,$00,$00,$01,$FF,$FF,$80,$0C,$00
	.db $18,$43,$05,$F8,$00,$00,$00,$FF,$FF,$00,$0C,$00,$00,$43,$00,$E0
	.db $00,$00,$00,$FF,$FF,$00,$04,$00,$00,$03,$08,$00,$00,$00,$00,$FF
	.db $FE,$00,$00,$00,$C0,$03,$00,$00,$00,$00,$00,$7F,$FE,$00,$00,$00
	.db $E0,$01,$00,$00,$70,$80,$00,$7F,$FE,$00,$00,$00,$60,$01,$00,$00
	.db $70,$80,$00,$7F,$FE,$03,$00,$10,$60,$41,$80,$08,$70,$80,$00,$7F
	.db $FC,$03,$04,$10,$00,$E0,$80,$08,$30,$80,$00,$3F,$FC,$43,$0C,$38
	.db $00,$C0,$40,$08,$00,$80,$06,$3E,$F8,$C3,$0C,$38,$01,$C0,$70,$D0
	.db $00,$80,$07,$1E,$00,$C2,$0C,$38,$0F,$E1,$DB,$F2,$01,$80,$07,$00
	.db $80,$C0,$18,$38,$0F,$FF,$FF,$D3,$83,$80,$07,$81,$C1,$C0,$18,$FC
	.db $03,$FF,$FF,$FF,$FF,$86,$07,$C3,$FF,$C0,$3D,$FE,$01,$FF,$FF,$FF
	.db $FF,$82,$07,$FF,$FF,$C0,$51,$9D,$FF,$FF,$FF,$FF,$FF,$00,$07,$FF
	.db $FF,$C0,$3F,$FF,$FF,$FF,$FF,$FF,$FF,$FC,$07,$FF,$FF,$C1,$FF,$FF
	.db $FF,$FF,$FF,$FF,$FF,$FE,$00,$7F,$FF,$80,$7F,$FF,$FF,$FF,$FF,$FF
	.db $FF,$FE,$00,$7F,$7F,$FF,$FF,$FF,$FF,$F9,$FF,$DF,$FB,$8E,$00,$FF
	.db $17,$1E,$FD,$FF,$FF,$77,$9C,$8D,$91,$BF,$C1,$E4,$BF,$75,$65,$5D
	.db $9A,$B7,$6A,$DA,$BB,$9C,$8A,$AE,$B5,$2C,$D4,$D5,$56,$77,$6A,$D9
	.db $DB,$BA,$D6,$75,$B7,$6E,$65,$6B,$97,$39,$9A,$DC,$9B,$8A,$D7,$65
	.db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FE,$FF,$FF,$FF,$FF,$FF
	.db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	.db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	.db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

OpeningPicLayer2:
	.db $00,$00,$20,$00,$00,$00,$00,$00,$00,$0C,$00,$00,$00,$10,$31,$CF
	.db $80,$00,$00,$00,$78,$0C,$00,$00,$00,$30,$FF,$FF,$E0,$00,$00,$0F
	.db $FF,$FE,$08,$00,$00,$33,$FF,$FF,$FC,$00,$00,$1F,$FF,$FF,$DC,$00
	.db $00,$3F,$E7,$7F,$FE,$00,$00,$7F,$FF,$F7,$CC,$00,$00,$39,$C7,$3E
	.db $FF,$80,$01,$FF,$FF,$F2,$8C,$00,$00,$71,$C1,$00,$3F,$C0,$01,$FC
	.db $00,$23,$06,$00,$00,$E1,$E6,$00,$7F,$E0,$07,$3C,$00,$07,$87,$00
	.db $00,$F7,$E0,$00,$49,$20,$0C,$00,$00,$07,$FF,$08,$1B,$FF,$E0,$00
	.db $01,$20,$0F,$80,$00,$07,$FF,$C8,$3F,$FE,$E0,$00,$00,$20,$08,$90
	.db $00,$07,$FF,$FC,$3F,$FF,$C0,$00,$00,$00,$00,$00,$00,$03,$FF,$3C
	.db $1F,$FF,$80,$0F,$C7,$FE,$7F,$E7,$80,$01,$FF,$F8,$1F,$E7,$0F,$10
	.db $36,$72,$42,$3C,$81,$F0,$67,$F8,$0F,$EE,$18,$A3,$16,$72,$47,$1C
	.db $81,$0C,$73,$F8,$0F,$8E,$E0,$A0,$9E,$72,$45,$9C,$80,$03,$F3,$F0
	.db $07,$9F,$80,$A4,$9E,$72,$47,$1C,$80,$00,$FB,$E0,$01,$9F,$1C,$A4
	.db $9E,$72,$4F,$3C,$80,$18,$F8,$80,$00,$09,$14,$A6,$9E,$72,$46,$7C
	.db $80,$36,$88,$00,$00,$01,$14,$A7,$9E,$72,$40,$FC,$E0,$93,$80,$00
	.db $00,$01,$04,$E7,$9E,$72,$40,$FC,$F0,$90,$00,$00,$00,$01,$04,$E7
	.db $9E,$72,$46,$7C,$FF,$90,$00,$00,$00,$01,$94,$E7,$9E,$72,$47,$3C
	.db $BF,$9C,$00,$00,$00,$01,$9C,$E7,$9E,$72,$45,$1C,$9F,$82,$00,$00
	.db $00,$01,$9C,$E7,$9E,$52,$4D,$9C,$BD,$82,$00,$00,$00,$01,$1C,$E3
	.db $1E,$72,$47,$18,$FD,$9C,$00,$00,$00,$01,$9D,$B0,$3E,$02,$40,$3C
	.db $07,$15,$00,$00,$00,$03,$19,$BF,$E3,$FC,$FF,$FF,$02,$1D,$C0,$00
	.db $00,$07,$03,$7D,$01,$C0,$01,$C9,$E7,$1F,$E0,$00,$00,$0F,$06,$FF
	.db $F7,$00,$01,$E5,$7F,$1F,$F0,$00,$00,$1F,$1F,$E3,$F3,$C0,$03,$1F
	.db $FB,$00,$F8,$00,$00,$1F,$BF,$FF,$F6,$20,$18,$1F,$FF,$E0,$F8,$00
	.db $00,$3F,$FF,$81,$E2,$10,$23,$1F,$0F,$FC,$FC,$00,$00,$1F,$FC,$00
	.db $82,$10,$4D,$E6,$03,$FF,$FC,$00,$00,$3F,$FE,$3C,$86,$00,$48,$E6
	.db $63,$FD,$FE,$00,$00,$3F,$1E,$7C,$84,$C8,$98,$26,$79,$C7,$FE,$00
	.db $00,$7C,$1E,$79,$84,$C8,$90,$04,$79,$C7,$CE,$00,$00,$71,$92,$73
	.db $E5,$AC,$9A,$04,$F9,$C7,$CF,$00,$00,$E3,$92,$67,$F9,$A4,$9F,$1C
	.db $79,$E3,$CF,$00,$00,$E7,$9A,$07,$F9,$E4,$94,$7C,$79,$E3,$CF,$00
	.db $01,$E7,$9E,$03,$38,$04,$9F,$1C,$79,$E1,$CF,$80,$01,$E7,$9E,$71
	.db $19,$E6,$9F,$1C,$09,$61,$CF,$80,$01,$E7,$9E,$79,$93,$F2,$CF,$9C
	.db $09,$60,$CF,$80,$01,$E4,$9E,$68,$93,$B2,$47,$14,$09,$64,$CF,$80
	.db $03,$E4,$9A,$6C,$F3,$11,$60,$16,$49,$66,$4F,$C0,$03,$A4,$92,$44
	.db $F3,$3B,$B8,$F6,$79,$66,$09,$C1,$07,$24,$92,$44,$7E,$3F,$8F,$2F
	.db $21,$67,$08,$E1,$FF,$25,$92,$44,$70,$1E,$24,$0D,$82,$67,$08,$FF
	.db $7F,$27,$27,$C6,$30,$00,$00,$2C,$7C,$47,$88,$7E,$3E,$20,$27,$03
	.db $1C,$00,$00,$00,$00,$41,$88,$3C,$00,$20,$42,$01,$CE,$00,$00,$00
	.db $00,$65,$88,$00,$00,$20,$AE,$62,$00,$00,$00,$00,$00,$FF,$88,$00
	.db $00,$23,$C0,$00,$00,$00,$00,$00,$00,$03,$88,$00,$00,$2E,$00,$00
	.db $00,$00,$00,$00,$00,$01,$CF,$80,$00,$7F,$80,$00,$00,$00,$00,$00
	.db $00,$01,$C7,$80,$80,$00,$00,$00,$00,$00,$00,$00,$00,$01,$E3,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$1E,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	
	
	
msgControls:
	.db "Left/Right = Move",$D6
	.db "Up = Jump",$D6
	.db "Down = Crouch",$D6
	.db "2nd = Punch",$D6
	.db "Alpha = Kick",$D6
	.db "Link = Pickup/Drop Object",$D6
	.db "Enter = Pause",$D6
	.db "Clear = Pause Menu",$D6
	.db "Sto = Teacher Key",0
	
	
CloseUp:
	.db $3F,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$00,$00,$00
	.db $3F,$FF,$FF,$FF,$F0,$00,$00,$00,$00,$00,$00,$00,$C0,$00,$00,$00
	.db $0C,$00,$00,$00,$00,$00,$00,$00,$C0,$00,$00,$00,$0C,$00,$00,$00
	.db $00,$00,$00,$00,$C0,$00,$00,$00,$0C,$00,$00,$00,$00,$00,$00,$00
	.db $C0,$00,$00,$00,$0C,$00,$00,$00,$00,$00,$00,$00,$C0,$00,$00,$00
	.db $0C,$00,$00,$00,$00,$00,$00,$00,$C0,$00,$00,$00,$0C,$00,$00,$00
	.db $00,$00,$00,$00,$C0,$00,$00,$00,$FC,$00,$00,$00,$00,$00,$00,$00
	.db $C0,$00,$00,$01,$7C,$00,$00,$00,$00,$00,$00,$00,$C0,$00,$00,$01
	.db $FC,$00,$00,$00,$00,$00,$00,$00,$C0,$00,$00,$01,$FC,$00,$00,$00
	.db $00,$00,$00,$00,$C0,$00,$00,$01,$FC,$00,$00,$00,$00,$00,$00,$00
	.db $C0,$00,$00,$01,$FC,$00,$00,$00,$00,$00,$00,$00,$C0,$00,$00,$00
	.db $0C,$00,$00,$00,$00,$00,$00,$00,$C0,$00,$00,$00,$0C,$00,$00,$00
	.db $00,$00,$00,$00,$C0,$00,$00,$00,$0C,$00,$00,$00,$00,$00,$00,$00
	.db $C0,$00,$00,$00,$0C,$00,$00,$00,$00,$00,$00,$00,$C0,$00,$00,$00
	.db $0C,$00,$00,$00,$00,$00,$00,$00,$C0,$00,$00,$00,$0C,$00,$00,$00
	.db $00,$00,$00,$00,$C0,$00,$00,$00,$0C,$00,$00,$00,$00,$00,$00,$00
	.db $C0,$00,$00,$00,$0C,$00,$00,$00,$00,$00,$00,$00,$C0,$00,$00,$00
	.db $0C,$00,$00,$00,$00,$00,$00,$00,$C0,$00,$00,$00,$0C,$00,$00,$00
	.db $00,$00,$00,$00,$C0,$00,$00,$00,$0C,$00,$00,$00,$00,$00,$00,$00
	.db $C0,$00,$00,$00,$FC,$00,$00,$00,$00,$00,$00,$00,$C0,$00,$00,$00
	.db $4C,$00,$00,$00,$00,$00,$00,$00,$C0,$00,$00,$00,$2C,$00,$00,$00
	.db $00,$00,$00,$00,$C0,$00,$00,$00,$1C,$00,$00,$00,$00,$00,$00,$00
	.db $C0,$00,$00,$00,$0C,$00,$00,$00,$00,$00,$00,$00,$C0,$00,$00,$00
	.db $0C,$00,$00,$00,$00,$00,$00,$00,$C0,$00,$00,$00,$0C,$00,$00,$00
	.db $00,$00,$00,$00,$C0,$00,$00,$00,$0C,$00,$0C,$00,$00,$00,$00,$00
	.db $C0,$00,$00,$00,$0C,$00,$1C,$00,$00,$00,$00,$00,$C0,$00,$00,$00
	.db $0C,$00,$3C,$00,$00,$00,$00,$00,$C0,$00,$00,$00,$0C,$00,$7C,$00
	.db $00,$00,$00,$00,$3F,$FF,$FF,$FF,$F0,$00,$FC,$00,$00,$00,$00,$00
	.db $3F,$FF,$FF,$FF,$F0,$01,$F8,$00,$00,$00,$00,$00,$00,$C0,$00,$0C
	.db $00,$03,$F0,$00,$00,$00,$00,$00,$00,$C0,$00,$0C,$00,$07,$E0,$00
	.db $00,$00,$00,$00,$00,$C0,$00,$0C,$00,$0F,$C0,$00,$00,$00,$00,$00
	.db $00,$C0,$00,$0C,$00,$1F,$80,$00,$00,$00,$00,$00,$00,$C0,$00,$0C
	.db $00,$3F,$00,$00,$00,$00,$00,$00,$03,$C0,$00,$0F,$00,$7E,$00,$00
	.db $00,$00,$00,$00,$03,$00,$00,$03,$00,$FC,$00,$00,$00,$00,$00,$00
	.db $03,$00,$00,$03,$81,$F8,$00,$00,$00,$00,$00,$00,$03,$00,$00,$03
	.db $83,$F0,$00,$00,$00,$00,$00,$00,$03,$00,$00,$03,$87,$E0,$00,$00
	.db $00,$00,$00,$00,$03,$00,$00,$03,$FF,$C0,$00,$00,$00,$00,$00,$00
	.db $03,$00,$00,$03,$FF,$80,$00,$00,$00,$00,$00,$00,$03,$00,$00,$03
	.db $FF,$00,$00,$00,$00,$00,$00,$00
	
	
msgIntro1:
	.db "One day you were walking",$D6
	.db "along with your girlfriend.",0
msgIntro2:
	.db "When out of no where, the",$D6
	.db "TI Mafia, jumped out and ",$D6
	.db "captured your girlfriend.",0
msgIntro3:
	.db "Hours later, you awake in",$D6
	.db "a haze.  You vow to fight",0
msgIntro4:
	.db "the TI Mafia, and save",$D6
	.db "her from certain death",0
msgIntro5:
	.db "CURSE YOU",0
msgIntro6:
	.db "TI MAFIA!",0
	
msgGameover:
	.db "Game Over",0
	
msgYouWon:
	.db "You have saved your",$D6
	.db "Girlfriend and defeated",$D6
	.db "the TI Mafia.",$D6,$D6
	.db "Congratulations!",0
	
msgDifficulty:
	.db "Difficulty",$D6
	.db "1. Easy",$D6
	.db "2. Medium",$D6
	.db "3. Hard",0
	
	
HighScore:
	.db $00, $80, $00, $00, $00, $00, $00, $00, $00  ;starts at 0 duh!
	
Alphabet:
	.db "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	.db "abcdefghijklmnopqrstuvwxyz"
	.db "1234567890!@#$%^&*()-+*/ "
HighScoreName:
	.db "Pat Stetter",0 ;(20 char max)
	
MsgInputName:
	.db "Input Name:"
	
.end
end