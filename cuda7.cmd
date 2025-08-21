for /f %%v in (cuda0mpp1bL4.txt) do (nvcompress -bc1 %%v)
ECHO CUDA07 finished at %Time% >> timer.txt
exit
