for /f %%v in (cuda0mpp2bL3.txt) do (nvcompress -bc1 %%v)
ECHO CUDA10 finished at %Time% >> timer.txt
exit
