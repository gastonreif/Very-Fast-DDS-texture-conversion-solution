for /f %%v in (cuda0mpp3bL3.txt) do (nvcompress -bc1 %%v)
ECHO CUDA14 finished at %Time% >> timer.txt
exit
