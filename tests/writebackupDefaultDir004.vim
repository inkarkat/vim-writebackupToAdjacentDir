" Test making a backup in a dynamic default directory. 

function! MyBackupDir(originalFilespec, isQueryOnly)
    return '../backup'
endfunction

let g:WriteBackup_BackupDir = function('MyBackupDir')
runtime plugin/writebackup.vim
runtime plugin/writebackupToAdjacentDir.vim

cd $TEMP/WriteBackupTest
edit first\ level/second\ level/someplace\ else.txt
WriteBackup
%s/song/bird/
write

edit first\ level/important.txt
WriteBackup

call ListFiles()
call vimtest#Quit() 

