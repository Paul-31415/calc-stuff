@echo off
type header.z80 > PONGSRC.z80
type source.z80 >> PONGSRC.z80
echo #define MALLARD > pongmal.z80
type PONGSRC.z80 >> pongmal.z80
tasm -80 -b -i pongmal.z80 pongmal.bin
devpac83 pongmal
del PONGMAL.73p > nul
asm73 PONGMAL.83p
del pongmal.z80 >nul
del pongmal.bin >nul
echo #define ASH > pongash.z80
type PONGSRC.z80 >> pongash.z80
tasm -b -80 -i  -r16 pongash.z80
prgm82 pongash
fix PONGASH.82p
del pongash.OBJ >nul
del pongash.z80 >nul
echo #define TI83 > pongion.z80
type PONGSRC.z80 >> pongion.z80
tasm -80 -b -i pongion.z80 pongion.bin
devpac83 pongion
del pongion.bin >nul
del pongion.z80 >nul
echo #define TI83P > pongionp.z80
type PONGSRC.z80 >> pongionp.z80
tasm -80 -b -i pongionp.z80 pongionp.bin
devpac83 pongionp
move PONGIONP.83p PONGIONP.8xp 
del pongionp.bin >nul
del pongionp.z80 >nul
echo #define TIOS > aipongdt.z80
type PONGSRC.z80 >> aipongdt.z80
tasm -80 -b -i aipongdt.z80 aipongdt.bin
devpac8x aipongdt
del aipongdt.bin >nul
del aipongdt.z80 >nul
echo #define MIRAGE > pongmos.z80
type PONGSRC.z80 >> pongmos.z80
tasm -80 -b -i pongmos.z80 pongmos.bin
devpac8x pongmos
del pongmos.bin >nul
del pongmos.z80 >nul
del PONGSRC.z80 >nul
move PONGMAL.73p ..\MALLARD
move PONGASH.82p ..\ASH
move PONGMOS.8xp ..\MIRAGE
move AIPONGDT.8xp ..\TIOS
move PONGION.83p ..\TI83
move PONGIONP.8xp ..\TI83P
move aipongdt.LST ..\errorfiles
move pongmal.LST ..\errorfiles
move pongion.LST ..\errorfiles
move pongionp.LST ..\errorfiles
move pongmos.LST ..\errorfiles
move pongash.LST ..\errorfiles
echo DONE!