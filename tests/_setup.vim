if g:runVimTest !~# 'writebackupDefault\w*\d\+'
    " Do not yet source the plugins for the default tests. 
    runtime plugin/writebackup.vim
    runtime plugin/writebackupToAdjacentDir.vim
endif

set noruler " Otherwise, the captured output may be truncated; we have long filenames. 

" The tests rely on $TEMP. 
if ! exists('$TEMP')
    let $TEMP = '/tmp'
endif

" Add the test directory to $PATH so that the 'setup' and 'listfiles' helper
" scripts can be executed easily. 
let s:pathSeparator = (has('win32') || has('win64') ? ';' : ':')
let $PATH .= s:pathSeparator .  expand('<sfile>:p:h')

" Set up the modifiable test data in the temporary location. 
if ! vimtest#System('setup', 1)
    call vimtest#BailOut('External setup script failed with exit status ' . v:shell_error)
endif

" This evaluation function allows to compare the modified test data with the
" expected result. It is called at the end of each test. 
function! ListFiles()
    new
    0r !listfiles
    call vimtest#SaveOut()
endfunction

