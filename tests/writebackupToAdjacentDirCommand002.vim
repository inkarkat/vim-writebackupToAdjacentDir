" Test :WriteBackupMakeAdjacentDir error conditions.

cd $TEMP/WriteBackupTest

call vimtest#StartTap()
call vimtap#Plan(1)

edit first\ level/important.txt
echomsg 'Test: Already existing backup dir'
WriteBackupMakeAdjacentDir

cd $TEMP/WriteBackupTest
edit first\ level/second\ level.backup
write
cd $TEMP/WriteBackupTest
edit first\ level/second\ level/someplace\ else.txt
%s/song/bird/
try
    WriteBackupMakeAdjacentDir
    call vimtap#Fail('expected error with already existing file')
catch
    call vimtap#err#ThrownLike("Cannot create backup directory; file exists: \\(.*[/\\\\]WriteBackupTest[/\\\\]\\)\\?first level[/\\\\]second level\.backup", 'error shown')
endtry
WriteBackup
%s/bird/fun/
write

call ListFiles()
call vimtest#Quit()
