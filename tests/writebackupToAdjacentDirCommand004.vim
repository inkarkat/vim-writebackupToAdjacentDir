" Test the :WriteBackupMakeAdjacentDir command with permissions. 

call vimtest#SkipAndQuitIf(has('win32') || has('win64'), "No Unixoid permissions on Windows. ") 

cd $TEMP/WriteBackupTest

edit first\ level/second\ level/someplace\ else.txt
%s/song/bird/
WriteBackupMakeAdjacentDir 0700
WriteBackup
%s/bird/fun/
write
cd $TEMP/WriteBackupTest
echomsg '0700 resulted in' getfperm('first level/second level.backup')

call ListFiles()
call vimtest#Quit() 

