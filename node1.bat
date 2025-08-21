for /f %%x in (gpunode0block2.txt) do (nvcompress -bc1 %%x)
ECHO NODE1 finished at %Time% >> timer.txt
exit