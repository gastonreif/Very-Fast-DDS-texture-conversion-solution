for /f %%v in (cuda0mpp3bL4.txt) do (nvcompress -bc1 %%v)
ECHO CUDA15 finished at %Time% >> timer.txt
exit
