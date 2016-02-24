" Test making a backup in a upper-upper-level directory, with differing CWDs.

runtime plugin/writebackup.vim
runtime plugin/writebackupToAdjacentDir.vim

cd $TEMP/WriteBackupTest/first\ level/second\ level/third\ level
edit not\ important.txt
WriteBackup
cd ..
%s/junk/funk/
WriteBackup
cd ..
%s/funk/zong/
WriteBackup
%s/zong/last/
write

call ListFiles()
call vimtest#Quit()
