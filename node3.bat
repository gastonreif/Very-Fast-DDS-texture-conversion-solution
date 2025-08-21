for /f %%v in (gpunode1block2.txt) do (nvcompress -bc1 %%v)
ECHO NODE3 finished at %Time% >> timer.txt
exit