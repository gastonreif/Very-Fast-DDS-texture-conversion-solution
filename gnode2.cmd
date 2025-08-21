for /f %%v in (gnode1block3.txt) do (nvcompress -bc1 %%v)
ECHO NODE2 finished at %Time% >> timer.txt
exit
