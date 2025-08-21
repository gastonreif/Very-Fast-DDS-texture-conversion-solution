for /f %%v in (cuda0mpp1bL2.txt) do (nvcompress -bc1 %%v)
ECHO CUDA05 finished at %Time% >> timer.txt
exit
