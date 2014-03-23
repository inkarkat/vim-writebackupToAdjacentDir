" Test making a backup in a write-protected adjacent directory.

source helpers/dir.vim
cd $TEMP/WriteBackupTest
call MakeReadonly('more.backup')

edit more/someplace\ else.txt
%s/song/bird/

call vimtest#StartTap()
call vimtap#Plan(1)
try
    WriteBackup
    call vimtap#Fail('expected error')
catch
    call vimtap#err#ThrownLike('E212: Can''t open file for writing (.*[/\\]WriteBackupTest[/\\]more.backup[/\\]someplace else.txt.20\d\{6}a)', 'error shown')
endtry

%s/bird/fun/
write

call ListFiles()
call vimtest#Quit()
