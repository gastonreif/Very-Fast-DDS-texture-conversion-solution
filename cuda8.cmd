for /f %%v in (cuda0mpp2bL1.txt) do (nvcompress -bc1 %%v)
ECHO CUDA08 finished at %Time% >> timer.txt
exit
