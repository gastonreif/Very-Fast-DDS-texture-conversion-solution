@ECHO OFF
texconv.exe -m 13 -timing -nogpu -f BC1_UNORM -flist list.txt
ECHO CPU finished at %Time% >> timer.txt
exit