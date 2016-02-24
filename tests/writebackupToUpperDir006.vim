" Test no upper-level backup directories.

call vimtest#ErrorAndQuitIf(isdirectory($TEMP . '/WriteBackupTest.backup'), 'WriteBackupTest.backup exists')
call vimtest#ErrorAndQuitIf(isdirectory($TEMP . '.backup'), '$TEMP.backup exists')

runtime plugin/writebackup.vim
runtime plugin/writebackupToAdjacentDir.vim

cd $TEMP/WriteBackupTest
call mkdir('added')
edit added/new.txt
call setline(1, 'first thoughts')
WriteBackup
%s/first/next/
write

call ListFiles()
call vimtest#Quit()
