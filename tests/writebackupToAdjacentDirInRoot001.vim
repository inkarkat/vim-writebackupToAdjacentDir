" Test making a backup in the root directory. 

call vimtest#SkipAndQuitIf(! (has('win32') || has('win64')), "Don't want to clobber the single root of a Unix system with test files, probably won't have the permissions anyway. ") 

cd $TEMP/WriteBackupTest
call vimtest#System('subst T: .')
try
    edit T:/more/someplace\ else.txt
    %s/song/bird/
    WriteBackup
    %s/bird/fun/
    write

    edit T:/root.txt
    normal! icontents
    WriteBackup
    %s/contents/new stuff/
    write

    call mkdir('T:/.backup')
    %s/new stuff/brand new/
    WriteBackup
    bdelete!

    call ListFiles()
finally
    call vimtest#System('subst /d T:')
endtry
call vimtest#Quit() 

