for /f %%v in (gpunode0block1.txt) do (nvcompress -bc1 %%v)
ECHO NODE0 finished at %Time% >> timer.txt
exit