for /f %%v in (gnode0block2.txt) do (nvcompress -bc1 %%v)
ECHO NODE1 finished at %Time% >> timer.txt
exit
