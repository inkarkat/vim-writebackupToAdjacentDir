" Test making a backup in a write-protected adjacent directory. 

source helpers/dir.vim
cd $TEMP/WriteBackupTest
call MakeReadonly('more.backup')

edit more/someplace\ else.txt
%s/song/bird/
WriteBackup
%s/bird/fun/
write

call ListFiles()
call vimtest#Quit() 

