" Test making a backup in a wildignored upper-level directory.

runtime plugin/writebackup.vim
runtime plugin/writebackupToAdjacentDir.vim

set wildignore=*.backup
cd $TEMP/WriteBackupTest
call mkdir('first level.backup/second level', 'p')
edit first\ level/second\ level/someplace\ else.txt
WriteBackup
%s/song/bird/
write

call ListFiles()
call vimtest#Quit()
