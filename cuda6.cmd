for /f %%v in (cuda0mpp1bL3.txt) do (nvcompress -bc1 %%v)
ECHO CUDA06 finished at %Time% >> timer.txt
exit
