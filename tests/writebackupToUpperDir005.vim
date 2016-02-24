" Test choosing the upper-level directory, not the upper-upper-level.

runtime plugin/writebackup.vim
runtime plugin/writebackupToAdjacentDir.vim

cd $TEMP/WriteBackupTest
call mkdir('first level/second level.backup', 'p')
edit first\ level/second\ level/third\ level/not\ important.txt
WriteBackup
%s/junk/funk/
write

call ListFiles()
call vimtest#Quit()
