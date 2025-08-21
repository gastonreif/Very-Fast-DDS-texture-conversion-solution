for /f %%v in (gnode2block6.txt) do (nvcompress -bc1 %%v)
ECHO NODE5 finished at %Time% >> timer.txt
exit
