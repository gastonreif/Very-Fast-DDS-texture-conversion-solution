for /f %%v in (cuda0mpp2bL4.txt) do (nvcompress -bc1 %%v)
ECHO CUDA11 finished at %Time% >> timer.txt
exit
