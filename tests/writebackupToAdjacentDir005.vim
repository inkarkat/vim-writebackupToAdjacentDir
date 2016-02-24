" Test backups with 'autochdir'. 

call vimtest#SkipAndQuitIf(! exists('+autochdir'), "Need 'autochdir' option")
set autochdir

cd $TEMP/WriteBackupTest

edit first\ level/important.txt
%s/current/fifth/
WriteBackup
cd $TEMP/WriteBackupTest/first\ level
%s/fifth/sixth/
WriteBackup
cd $TEMP/WriteBackupTest/first\ level/backup
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

