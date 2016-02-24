" Test making a backup in a upper-upper-level directory with forward shellslash.

call vimtest#SkipAndQuitIf(! exists('+shellslash') || &shellslash, "No support for 'shellslash'")
set shellslash

runtime plugin/writebackup.vim
runtime plugin/writebackupToAdjacentDir.vim

cd $TEMP/WriteBackupTest
edit first\ level/second\ level/third\ level/not\ important.txt
WriteBackup
%s/junk/funk/
write

call ListFiles()
call vimtest#Quit()
