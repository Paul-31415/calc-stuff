;Basic ION compatibility for the TI 83+
#ifdef	TI83P

;;;Macros

#define IONHEAD(desc) \ .ORG PROGSTART-2\ .DB $BB,$6D\ RET\ JR NC,_IONPROGRAMSTART\ .DB desc,0\_IONPROGRAMSTART:
;TASM custom instruction instead of the usual macro
 .ADDINSTR BCAL *       EF     3 NOP 1
;#define bcall(xxxx)	rst 28h \ .dw xxxx

;;;RAM starting locations

progstart	=9D95h
cmdshad		=966Eh
plotsscreen	=9340h
gbuf		=plotsscreen

;;;ION functions
lVectors	=cmdshad+80
ionVersion	=lVectors
ionRandom	=lVectors+3
ionPutSprite	=lVectors+6
ionLargeSprite	=lVectors+9
ionGetPixel	=lVectors+12
ionFastCopy	=lVectors+15
ionDetect	=lVectors+18
ionDecompress	=lVectors+21

;;;System Variables
currow		=844Bh
curcol		=844Ch
pencol		=86D7h
penrow		=86D8h

;;;System Functions
ti_clrlcdf	=4540h
ti_clrscrf	=4546h
ti_homeup	=4558h
ti_newline	=452Eh
ti_clrscr	=4543h
ti_vputs	=4561h
ti_puts		=450Ah
ti_putc		=4504h
ti_getkey	=4972h
ti_getk		=4744h

#endif

;;;This section copied from Dan Englender's ion.inc

trigflags       .EQU       0           ; IY OFFSET VALUE
trigdeg         .EQU       2
;
plotflags       .EQU       2           ; IY OFFSET VALUE
plotloc         .EQU       1
plotdisp        .EQU       2
;
grfmodeflags    .EQU       2           ; IY OFFSET VALUE
grffuncm        .EQU       4
grfpolarm       .EQU       5
grfparamm       .EQU       6
grfrecurm       .EQU       7
;
graphflags      .EQU       3           ; IY OFFSET VALUE
graphdraw       .EQU       0
graphcursor     .EQU       2
;
grfdbflags      .EQU       4           ; IY OFFSET VALUE
grfdot          .EQU       0
grfsimul        .EQU       1
grfgrid         .EQU       2
grfpolar        .EQU       3
grfnocoord      .EQU       4
grfnoaxis       .EQU       5
grflabel        .EQU       6
;
textflags       .EQU       5           ; IY OFFSET VALUE
textEraseBelow  .EQU       1
textScrolled    .EQU       2
textInverse     .EQU       3
;
onflags         .EQU       9           ; IY OFFSET VALUE
onRunning       .EQU       3
onInterrupt     .EQU       4
;
statflags       .EQU       9           ; IY OFFSET VALUE
statsvalid      .EQU       6
;
fmtflags        .EQU       10          ; IY OFFSET VALUE
fmtExponent     .EQU       0
fmtEng          .EQU       1
;
nummode         .EQU       10          ; IY OFFSET VALUE
FMTREAL         .EQU       5
FMTRECT         .EQU       6
FMTPOLAR        .EQU       7
;
curflags        .EQU       12          ; IY OFFSET VALUE
curAble         .EQU       2
curOn           .EQU       3
curLock         .EQU       4
;
appflags        .EQU       13          ; IY OFFSET VALUE
appTextSave     .EQU       1
appAutoScroll   .EQU       2
;
PLOTFLAG2       .EQU       17          ; IY OFFSET VALUE
EXPR_PARAM      .EQU       3
EXPR_WRITING    .EQU       4
;
indicflags      .EQU       18          ; IY OFFSET VALUE
indicRun        .EQU       0
indicOnly       .EQU       2
;
shiftflags      .EQU       18          ; IY OFFSET VALUE
shift2nd        .EQU       3
shiftAlpha      .EQU       4
shiftALock      .EQU       6
;
tblflags        .EQU       19          ; IY OFFSET VALUE
AutoFill        .EQU       4
AutoCalc        .EQU       5
;
sgrflags        .EQU       20          ; IY OFFSET VALUE
grfSplit        .EQU       0
VertSplit       .EQU       1
WRITE_ON_GRAPH  .EQU       4
textwrite       .EQU       7
;
