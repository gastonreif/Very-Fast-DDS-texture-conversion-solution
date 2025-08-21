for /f %%v in (cuda0mpp1bL1.txt) do (nvcompress -bc1 %%v)
ECHO CUDA04 finished at %Time% >> timer.txt
exit
