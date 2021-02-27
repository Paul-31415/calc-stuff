
; Play the song pointed to by IX:	
playSong:

	ld a,(ix+0)
	or (ix+1)
	call z,checkCommand

	ld (songLocSave+2),ix
	ld h,(ix+1)
	ld l,(ix+0)
songLoc:
	ld de,0
	add hl,de
	push hl
	pop ix
	call playSection
songLocSave:
	ld ix,0
	inc ix
	inc ix
	jr playSong	

; Play the section pointed to by IX:
playSection:
	ld a,(ix+4)
	or (ix+5)
	ret z
	ld b,(ix+5)
	ld c,(ix+4)
	ld h,(ix+0)
	ld l,(ix+1)
	ld d,(ix+2)
	ld e,(ix+3)
	inc ix
	inc ix
	inc ix
	inc ix
	inc ix
	inc ix
	ld a,(KeyRow_Top)
	out (1),a
	in a,(1)
	cp dKWindow
	jr nz,noFastForwards
	ld bc,5
noFastForwards:
	call playTone
	jr playSection

; Play the tone dur=bc, period = h,l,d,e (4 channel sound - h,l = left speaker, d,e = right speaker)
playTone:
	di
;#ifdef TI83I
	ld a,$D0
;#else
;	xor a
;#endif
	ld (toneMask1+1),a
	ld (toneMask2+1),a
	inc b 
; INIT CHANNEL A

	ld a,h
	ld (toneAPitch+1),a
	or a
	jr z,isRestA
	ld a,1
	jr notRestA
isRestA:
	xor a
notRestA:
	ld (toneAChange+1),a

; INIT CHANNEL B

	ld a,l
	ld (toneBPitch+1),a
	or a
	jr z,isRestB
	ld a,1
	jr notRestB
isRestB:
	xor a
notRestB:
	ld (toneBChange+1),a


; INIT CHANNEL C

	ld a,d
	ld (toneCPitch+1),a
	or a
	jr z,isRestC
	ld a,2
	jr notRestC
isRestC:
	xor a
notRestC:
	ld (toneCChange+1),a

; INIT CHANNEL D

	ld a,e
	ld (toneDPitch+1),a
	or a
	jr z,isRestD
	ld a,2
	jr notRestD
isRestD:
	xor a
notRestD:
	ld (toneDChange+1),a

toneMaskPreserve:
	push bc
toneMask:
	and 1
	jr z,playPart2
	ld a,(toneMask1+1)
	jr playPart1
playPart2:
	ld a,(toneMask2+1)
playPart1:
	out (bPort),a
pitchLoop:


	dec h
	jr nz,noPitchA
toneMask1:
	ld a,0
toneAChange:
	xor 0
	ld (toneMask1+1),a
toneAPitch:
	ld h,0
noPitchA:


	dec l
	jr nz,noPitchB
toneMask2:
	ld a,0
toneBChange:
	xor 0
	ld (toneMask2+1),a
toneBPitch:
	ld l,0
noPitchB:



	dec d
	jr nz,noPitchC
	ld a,(toneMask1+1)
toneCChange:
	xor 0
	ld (toneMask1+1),a
toneCPitch:
	ld d,0
noPitchC:


	dec e
	jr nz,noPitchD
	ld a,(toneMask2+1)
toneDChange:
	xor 0
	ld (toneMask2+1),a
toneDPitch:
	ld e,0
noPitchD:



extendDuration:
	ld a,0
	dec a
	ld (extendDuration+1),a
	jr nz,toneMask

	ld a,KeyRow_Top
	out (1),a
	in a,(1)
	cp dkZoom
	jr nz,notTimeToQuit

	pop hl
	pop hl
	pop hl
	ret


notTimeToQuit:

	pop bc
	dec c
	jp nz,toneMaskPreserve
	dec b
	jp nz,toneMaskPreserve

	ret


; MAGIC SYSTEM COMMANDS:

checkCommand:

	; We've just received a song command:

	ld a,(ix+2)
	cp 254
	jr nz,notValidCommand

	; You see, in an OLD SONG, the end of the song will be:
	; 0,0,NOTE1...
	; NOTE1 CANNOT BE 254 IF USING THE STANDARD TONES!
	; Therefore, use 254 as a command signifier.

	inc ix
	inc ix
	inc ix

	ld a,(ix+0)
		
	cp 0

	jr nz,notValidCommand

; It's a REPEAT INSTRUCTION

	ld a,(repeatCount)
	inc a
	ld (repeatCount),a
	ld b,a

	ld a,(ix+1)
	or a
	jr z,infiniteRepeat

	cp b
	jr z,notValidCommand	; Stop playing the song, we've done all the repeats

infiniteRepeat:

	ld h,(ix+3)
	ld l,(ix+2)
	ld de,(songLoc+1)
	add hl,de

	push hl
	pop ix

	pop af
	jp playSong
	
notValidCommand:
	pop af
	ret	; Stop playing the song!