" Test :WriteBackupMakeAdjacentDir error conditions.

source helpers/dir.vim
cd $TEMP/WriteBackupTest
call MakeReadonly('first level')

edit first\ level/second\ level/someplace\ else.txt
%s/song/bird/

call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#err#ErrorsLike('E739: Cannot create directory: .*[/\\]WriteBackupTest[/\\]first level[/\\]second level\.backup', 'WriteBackupMakeAdjacentDir', 'error shown')

WriteBackup
%s/bird/fun/
write

call ListFiles()
call vimtest#Quit()
