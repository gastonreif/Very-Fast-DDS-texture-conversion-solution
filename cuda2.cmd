for /f %%v in (cuda0mpp0bL3.txt) do (nvcompress -bc1 %%v)
ECHO CUDA02 finished at %Time% >> timer.txt
exit
