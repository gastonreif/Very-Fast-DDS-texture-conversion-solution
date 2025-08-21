for /f %%v in (cuda0mpp0bL2.txt) do (nvcompress -bc1 %%v)
ECHO CUDA01 finished at %Time% >> timer.txt
exit
