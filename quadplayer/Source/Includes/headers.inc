; ===============================================================
; Set the variable name for the calculator binary 
; ===============================================================

.variablename [%PROJECT_BINARY%]

; ===============================================================
; Define shell and platform from environment variables
; (passed in by the various build scripts).
; ===============================================================

none		= 0	; No shell
ion		= 1	; Ion
mirageos	= 2	; MirageOS

ti8x		= 1	; TI-83 Plus
ti83		= 2	; TI-83

shell		= [%SHELL%]
platform	= [%PLATFORM%]

; ===============================================================
; Set up the platform-specific settings: origins, include files,
; BCALL macros &c
; ===============================================================

.if platform == ti8x
	; TI-83 Plus
	.include "includes/ti83plus.inc"
	.org $9D93
	.db $BB,$6D
	.define bcall(label) rst 28h \ .dw label
	.define bjump(label) call 50h \ .dw label
	.binarymode TI8X
.elseif platform == ti83
	; TI-83
	.include "includes/ti83asm.inc"
	.include "includes/tokens.inc"
	.org $9327
	.define bcall(label) call label
	.define bjump(label) jp label
	.binarymode TI83
.else
	; Invalid platform
	.echo "Invalid platform selection.\n"
.endif

; ===============================================================
; Program headers for Ion and MirageOS
; ===============================================================

.if shell == ion
	.if platform == ti8x
		.include "includes/ion8x.inc"
	.else
		.include "includes/ion83.inc"
	.endif
	ret
	jr nc, main
.elseif shell == mirageos
	.include "includes/mirage.inc"
	ret
	.db 1
	.incbmp "resources/icon.gif"
.endif

; ===============================================================
; Set up TIOS ASCII-mapping
; ===============================================================

.asciimap '[', $C1

; ===============================================================
; Description field
; ===============================================================

.if shell != none
description
	.asc "[%$PROJECT_NAME$%]", 0
.endif