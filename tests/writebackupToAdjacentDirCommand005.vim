" Test :WriteBackupMakeAdjacentDir . argument is the same as omitting it.

cd $TEMP/WriteBackupTest

edit first\ level/second\ level/someplace\ else.txt
%s/song/bird/
WriteBackupMakeAdjacentDir .
WriteBackup
%s/bird/fun/
write

call ListFiles()
call vimtest#Quit()
