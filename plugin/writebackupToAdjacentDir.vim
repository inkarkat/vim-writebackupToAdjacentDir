" writebackupToAdjacentDir.vim: writebackup plugin writes to an adjacent
" directory if it exists. 
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher. 
"   - writebackup plugin (vimscript #1828). 

" Copyright: (C) 2010 by Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"	001	01-Jun-2010	file creation

" Avoid installing twice or when in unsupported Vim version. 
if exists('g:loaded_writebackupToAdjacentDir') || (v:version < 700)
    finish
endif
let g:loaded_writebackupToAdjacentDir = 1

let s:save_cpo = &cpo
set cpo&vim

if ! exists('g:WriteBackupAdjacentDir_BackupDirTemplate')
    let g:WriteBackupAdjacentDir_BackupDirTemplate = '%s.backup'
endif

function! writebackupToAdjacentDir#AdjacentBackupDir(originalFilespec, isQueryOnly)
    let l:originalDirname = fnamemodify(a:originalFilespec, ':p:h:t')
    let l:originalParentDirspec = fnamemodify(a:originalFilespec, ':p:h:h')
"****D echomsg '****' l:originalDirname l:originalParentDirspec

    " Use path separator as exemplified by the resolved dirspec. 
    let l:pathSeparator = (l:originalParentDirspec =~# '\' && l:originalParentDirspec !~# '/' ? '\' : '/') 

    let l:adjacentBackupDir =
    \	(l:originalParentDirspec ==# l:pathSeparator ? '' : l:originalParentDirspec) .
    \	l:pathSeparator .
    \	printf(g:WriteBackupAdjacentDir_BackupDirTemplate, l:originalDirname)

    " If there is an adjacent backup directory, use it. 
    return (isdirectory(l:adjacentBackupDir) ? l:adjacentBackupDir : '.')
endfunction

unlet g:WriteBackup_BackupDir
let g:WriteBackup_BackupDir = function('writebackupToAdjacentDir#AdjacentBackupDir')

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
