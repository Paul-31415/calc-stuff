@echo off

set #=%1%
set length=0
:loop
if defined # (set #=%#:~1%&set /A length += 1&goto loop)


if /I %length% LSS 9 goto nameGood
echo Error!! Name too long
goto eof

:nameGood
copy .\wav\%1.wav .\exe\%1.wav
cd .\exe
truSound %1.wav %1.bin
if errorlevel 1 goto ERROR
to8xk %1.bin %1
rabbitsign -g %1.hex 
del %1.hex
del %1.bin
cd..
move .\exe\%1.8xk .\8xk\%1.8xk
goto DONE
:ERROR
cd..
:DONE
del .\exe\%1.wav
time /T

:eof