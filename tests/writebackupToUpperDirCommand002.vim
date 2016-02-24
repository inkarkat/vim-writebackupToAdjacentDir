" Test :WriteBackupMakeAdjacentDir command with parent dir error conditions.

cd $TEMP/WriteBackupTest

edit first\ level/second\ level/third\ level/not\ important.txt
echomsg 'Test: Already existing backup dir'
WriteBackupMakeAdjacentDir ../..

call ListFiles()
call vimtest#Quit()
