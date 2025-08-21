for /f %%v in (cuda0mpp3bL1.txt) do (nvcompress -bc1 %%v)
ECHO CUDA12 finished at %Time% >> timer.txt
exit
