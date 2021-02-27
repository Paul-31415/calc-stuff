.nolist
#include "ion.inc"

;assembly control:
;#define _DEBUG_

;feature inclusion
#define MACH3D_MOVEFWD
#define MACH3D_VALIDATEXY
#define MACH3D_HBUFFER
#ifdef EVIL
#define MACH3D_DARK_SKY
#endif

;SQUARE_WALLS makes walls 64x64 pixels, otherwise walls are 64x32 pixels
#ifdef EVIL
#define MACH3D_SQUARE_WALLS
#endif
;TEX_STRETCH causes textures to be stretched to fit the wall, not repeated
#define MACH3D_TEX_STRETCH

#ifdef EVIL

#define FOVPIX		87
#define XOFFSET		9
#define FOVANG		FOVPIX
#define AAVAL		$60
#define MIN_WALL_DIST	$60

#else	;EVIL

;Render area is FOVPIX pixels wide (and 64 pixels tall)
#define FOVPIX		96
;Render area starts at this column on the screen
#define XOFFSET		0
;"Straight Ahead" is FOVANG/2 pixels from the left of the render area
#define FOVANG		FOVPIX
;antialiasing "jitteriness" factor, 0-255
#define AAVAL		$90
;Player can come within MIN_WALL_DIST/256 gridlines of a wall.
#define MIN_WALL_DIST	$48

#endif	;EVIL

;pixels per 90 degrees.  Used for clarity; don't change ANG90.
#define ANG90		$0100

;handy macros:

#define ALIGN256  \ .echo ($+$00FF)&$FF00 - $\ .echo " bytes wasted on alignment\n" \$=($+$00FF)&$FF00
#define ALIGN(n)  \ .echo ($+n-1)/n*n - $\ .echo " bytes wasted on alignment\n" \$=($+n-1)/n*n

#define INLINEVAR(name) name = $+1
#define INLINEFP(name) name = $+1\name.LO = $+1\name.HI = $+2
;#define DECLAREFP(name) name:\name.LO: .db 0\name.HI .db 0

#define STARTGLOBALS(addr) .org 0\ .db 0\ .org addr\GlobalsStart:

