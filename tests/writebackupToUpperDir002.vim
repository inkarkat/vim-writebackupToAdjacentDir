" Test making a backup in a upper-level directory, with created subdir.

runtime plugin/writebackup.vim
runtime plugin/writebackupToAdjacentDir.vim

cd $TEMP/WriteBackupTest
edit first\ level/second\ level/someplace\ else.txt
WriteBackup
%s/song/bird/
write

call ListFiles()
call vimtest#Quit()
