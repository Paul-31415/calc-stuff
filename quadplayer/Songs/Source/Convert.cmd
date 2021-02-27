@echo off
if not exist brass.exe (
	echo Please copy Brass.exe into this folder before running Convert.cmd
) else (
	if not exist %1 (
		echo %1 not found!
	) else (
		set platform=TI83
		brass %1 %1.83p
		set platform=TI8X
		brass %1 %1.8xp
	)
)