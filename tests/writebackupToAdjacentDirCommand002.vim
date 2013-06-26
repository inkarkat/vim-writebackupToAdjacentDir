" Test :WriteBackupMakeAdjacentDir error conditions. 

cd $TEMP/WriteBackupTest

edit first\ level/important.txt
echomsg 'Test: Already existing backup dir'
WriteBackupMakeAdjacentDir

cd $TEMP/WriteBackupTest
edit first\ level/second\ level.backup
write
cd $TEMP/WriteBackupTest
edit first\ level/second\ level/someplace\ else.txt
%s/song/bird/
echomsg 'Test: Already existing file'
WriteBackupMakeAdjacentDir
WriteBackup
%s/bird/fun/
write

call ListFiles()
call vimtest#Quit() 

