" Test making a backup in a subdirectory of an existing adjacent directory. 

cd $TEMP/WriteBackupTest

edit first\ level/second\ level/someplace\ else.txt
%s/song/bird/
WriteBackup
%s/bird/fun/
write

call ListFiles()
call vimtest#Quit() 

