for /f %%v in (gnode3block8.txt) do (nvcompress -bc1 %%v)
ECHO NODE7 finished at %Time% >> timer.txt
exit
