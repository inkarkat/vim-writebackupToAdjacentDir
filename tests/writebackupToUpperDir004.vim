" Test making a backup in another upper-level directory, with created subdir.

runtime plugin/writebackup.vim
runtime plugin/writebackupToAdjacentDir.vim

cd $TEMP/WriteBackupTest
call mkdir('more/stuff')
edit more/stuff/new.txt
call setline(1, 'first thoughts')
WriteBackup
%s/first/next/
write

call ListFiles()
call vimtest#Quit()
