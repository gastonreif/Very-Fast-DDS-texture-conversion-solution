for /f %%v in (gnode1block4.txt) do (nvcompress -bc1 %%v)
ECHO NODE3 finished at %Time% >> timer.txt
exit
