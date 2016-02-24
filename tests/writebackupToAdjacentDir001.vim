" Test making a backup in an existing adjacent directory. 

cd $TEMP/WriteBackupTest
edit first\ level/important.txt
%s/current/fifth/
WriteBackup
%s/fifth/CURRENT/
write

cd $TEMP/WriteBackupTest
edit more/someplace\ else.txt
%s/song/bird/
WriteBackup
%s/bird/fun/
write

call ListFiles()
call vimtest#Quit() 

