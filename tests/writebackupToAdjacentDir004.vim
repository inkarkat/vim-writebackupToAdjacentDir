" Test backups with differing CWDs. 

if exists('+autochdir') | set noautochdir | endif
cd $TEMP/WriteBackupTest

edit first\ level/important.txt
%s/current/fifth/
WriteBackup
cd first\ level
%s/fifth/sixth/
WriteBackup
cd backup
%s/sixth/seventh/
WriteBackup
cd $VIM
%s/seventh/eighth/
WriteBackup
cd /
%s/eighth/ninth/
WriteBackup
%s/ninth/CURRENT/
write

call ListFiles()
call vimtest#Quit() 

