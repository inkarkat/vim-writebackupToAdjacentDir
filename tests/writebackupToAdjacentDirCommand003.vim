" Test :WriteBackupMakeAdjacentDir error conditions. 

source helpers/dir.vim
cd $TEMP/WriteBackupTest
call MakeReadonly('first level')

edit first\ level/second\ level/someplace\ else.txt
%s/song/bird/
echomsg 'Test: Readonly parent of backup dir'
WriteBackupMakeAdjacentDir
WriteBackup
%s/bird/fun/
write

call ListFiles()
call vimtest#Quit() 

