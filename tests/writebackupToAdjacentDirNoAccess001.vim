" Test making a backup in a write-protected adjacent directory.

source helpers/dir.vim
cd $TEMP/WriteBackupTest
call MakeReadonly('more.backup')

edit more/someplace\ else.txt
%s/song/bird/

call vimtest#StartTap()
call vimtap#Plan(1)
call vimtap#err#ErrorsLike('^E212: .* (.*[/\\]WriteBackupTest[/\\]more.backup[/\\]someplace else.txt.20\d\{6}a)', 'WriteBackup', 'Can''t open file for writing error shown')

%s/bird/fun/
write

call ListFiles()
call vimtest#Quit()
