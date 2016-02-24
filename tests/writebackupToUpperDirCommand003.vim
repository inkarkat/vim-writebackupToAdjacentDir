" Test :WriteBackupMakeAdjacentDir command with parent dir error conditions.

source helpers/dir.vim
cd $TEMP/WriteBackupTest
call MakeReadonly('first level')

edit first\ level/second\ level/third\ level/not\ important.txt
%s/junk/funk/

call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#err#ErrorsLike('^E739: .*: .*[/\\]WriteBackupTest[/\\]first level[/\\]second level\.backup', 'WriteBackupMakeAdjacentDir ..', 'Cannot create directory error shown')

WriteBackup
%s/funk/zong/
write

call ListFiles()
call vimtest#Quit()
