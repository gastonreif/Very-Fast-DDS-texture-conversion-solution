for /f %%v in (cuda0mpp0bL4.txt) do (nvcompress -bc1 %%v)
ECHO CUDA03 finished at %Time% >> timer.txt
exit
