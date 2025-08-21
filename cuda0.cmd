for /f %%v in (cuda0mpp0bL1.txt) do (nvcompress -bc1 %%v)
ECHO CUDA00 finished at %Time% >> timer.txt
exit
