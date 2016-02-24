" Test making a backup in an adjacent directory with existing backup in same dir.

cd $TEMP/WriteBackupTest

edit first\ level/important.txt
%s/current/fifth/
execute 'write' ingo#compat#fnameescape(expand('%') . '.20081231a')
%s/fifth/sixth/
WriteBackup
%s/sixth/CURRENT/
write

call ListFiles()
call vimtest#Quit()

