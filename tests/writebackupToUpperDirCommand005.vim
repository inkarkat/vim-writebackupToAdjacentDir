" Test the :WriteBackupMakeAdjacentDir command with the parent dir and
" permissions.

cd $TEMP/WriteBackupTest

edit first\ level/second\ level/third\ level/not\ important.txt
%s/junk/funk/
WriteBackupMakeAdjacentDir .. 0700
call vimtest#StartTap()
call vimtap#Plan(3 + (ingo#os#IsWinOrDos() ? 0 : 1))
call vimtap#Ok(isdirectory('first level/second level.backup'), 'Backup directory created')
call vimtap#Ok(! isdirectory('first level/second level.backup/third level'), 'Backup directory does not have subdir yet')
if ! ingo#os#IsWinOrDos()
    call vimtap#Is(getfperm('first level/second level.backup'), 'rwx------', 'permissions resulting from 0700')
endif

WriteBackup
call vimtap#Ok(isdirectory('first level/second level.backup/third level'), 'Backup directory has subdir after :WriteBackup')
%s/funk/zong/
write

call ListFiles()
call vimtest#Quit()
