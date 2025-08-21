for /f %%v in (gpunode1block1.txt) do (nvcompress -bc1 %%v)
ECHO NODE2 finished at %Time% >> timer.txt
exit