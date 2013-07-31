" Test making a backup in the default current directory. 

runtime plugin/writebackup.vim
runtime plugin/writebackupToAdjacentDir.vim

cd $TEMP/WriteBackupTest
edit first\ level/second\ level/someplace\ else.txt
WriteBackup
%s/song/bird/
write

edit first\ level/important.txt
WriteBackup

call ListFiles()
call vimtest#Quit() 

