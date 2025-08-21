for /f %%v in (gnode3block7.txt) do (nvcompress -bc1 %%v)
ECHO NODE6 finished at %Time% >> timer.txt
exit
