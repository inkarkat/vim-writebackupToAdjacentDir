" Test making a backup in a write-protected subdir of an upper-directory.

source helpers/dir.vim
cd $TEMP/WriteBackupTest
call mkdir('first level.backup/second level', 'p')
call MakeReadonly('first level.backup/second level')

cd $TEMP/WriteBackupTest
edit first\ level/second\ level/third\ level/not\ important.txt
WriteBackup
%s/junk/funk/
write

call vimtest#StartTap()
call vimtap#Plan(1)
try
    WriteBackup
    call vimtap#Fail('expected error')
catch
    call vimtap#err#ThrownLike('Cannot create subdirectory inside backup directory: .*[/\\]WriteBackupTest[/\\]first level\.backup[/\\]second level[/\\]third level$', 'error shown')
endtry

%s/funk/zonk/
write

call ListFiles()
call vimtest#Quit()
