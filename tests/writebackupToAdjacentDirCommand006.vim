" Test :WriteBackupMakeAdjacentDir without a current file. 

cd $TEMP/WriteBackupTest/first\ level/second\ level
WriteBackupMakeAdjacentDir

cd $TEMP/WriteBackupTest/first\ level
echomsg 'Test: Already existing backup dir'
WriteBackupMakeAdjacentDir

call ListFiles()
call vimtest#Quit() 

