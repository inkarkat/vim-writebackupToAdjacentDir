" Test the :WriteBackupMakeAdjacentDir command with absolute parent dir.

cd $TEMP/WriteBackupTest

edit first\ level/second\ level/third\ level/not\ important.txt
%s/junk/funk/
WriteBackupMakeAdjacentDir $TEMP/WriteBackupTest/first\ level/second\ level
call vimtest#StartTap()
call vimtap#Plan(3)
call vimtap#Ok(isdirectory('first level/second level.backup'), 'Backup directory created')
call vimtap#Ok(! isdirectory('first level/second level.backup/third level'), 'Backup directory does not have subdir yet')

WriteBackup
call vimtap#Ok(isdirectory('first level/second level.backup/third level'), 'Backup directory has subdir after :WriteBackup')
%s/funk/zong/
write

call ListFiles()
call vimtest#Quit()
