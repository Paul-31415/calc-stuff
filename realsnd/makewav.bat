@echo off
WaveConv.exe %1
wabbit.exe temp.bin %2
del temp.bin
pause