" Test configuring the adjacent backup directory naming. 

let g:WriteBackupAdjacentDir_BackupDirTemplate = 'backup of %s'

cd $TEMP/WriteBackupTest

edit first\ level/important.txt
%s/current/fifth/
WriteBackup
%s/fifth/CURRENT/
write

cd $TEMP/WriteBackupTest
call mkdir('first level/backup of second level', 'p')
edit first\ level/second\ level/someplace\ else.txt
%s/song/bird/
WriteBackup
%s/bird/fun/
write

call ListFiles()
call vimtest#Quit() 

