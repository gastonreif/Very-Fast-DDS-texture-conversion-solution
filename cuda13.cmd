for /f %%v in (cuda0mpp3bL2.txt) do (nvcompress -bc1 %%v)
ECHO CUDA13 finished at %Time% >> timer.txt
exit
