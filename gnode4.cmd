for /f %%v in (gnode2block5.txt) do (nvcompress -bc1 %%v)
ECHO NODE4 finished at %Time% >> timer.txt
exit
