for /f %%v in (cuda0mpp2bL2.txt) do (nvcompress -bc1 %%v)
ECHO CUDA09 finished at %Time% >> timer.txt
exit
