" writebackupToAdjacentDir.vim: writebackup plugin writes to an adjacent directory if it exists.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"   - ingo/err.vim autoload script
"   - ingo/msg.vim autoload script
"   - writebackup plugin (vimscript #1828), version 1.30 or higher

" Copyright: (C) 2010-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   2.00.005	01-Aug-2013	Split off autoload script.
"   1.11.004	27-Jun-2013	Implement abort on error for
"				:WriteBackupMakeAdjacentDir.
"   1.10.003	17-Feb-2012	ENH: Save configured g:WriteBackup_BackupDir and
"				use that as a fallback instead of always
"				defaulting to '.', thereby allowing absolute and
"				dynamic backup directories as a fallback.
"				Suggested by Geoffrey Nimal.
"   1.00.002	02-Jun-2010	Finished, polished and added
"				:WriteBackupMakeAdjacentDir command.
"	001	01-Jun-2010	file creation
let s:save_cpo = &cpo
set cpo&vim

function! s:GetAdjacentBackupDir(originalFilespec)
    let l:originalDirname = fnamemodify(a:originalFilespec, ':p:h:t')
    let l:originalParentDirspec = fnamemodify(a:originalFilespec, ':p:h:h')
"****D echomsg '****' l:originalDirname l:originalParentDirspec

    " Use path separator as exemplified by the resolved dirspec.
    let l:pathSeparator = (l:originalParentDirspec =~# '\' && l:originalParentDirspec !~# '/' ? '\' : '/')

    let l:adjacentBackupDir =
    \	(l:originalParentDirspec ==# l:pathSeparator ? '' : l:originalParentDirspec) .
    \	l:pathSeparator .
    \	printf(g:WriteBackupAdjacentDir_BackupDirTemplate, l:originalDirname)

    return l:adjacentBackupDir
endfunction

function! s:GetFallbackBackupDir( originalFilespec, isQueryOnly )
    let l:BackupDir = g:WriteBackupAdjacentDir_BackupDir
    if type(l:BackupDir) == type('')
	return l:BackupDir
    else
	return call(l:BackupDir, [a:originalFilespec, a:isQueryOnly])
    endif
endfunction
function! writebackupToAdjacentDir#AdjacentBackupDir( originalFilespec, isQueryOnly )
    let l:adjacentBackupDir = s:GetAdjacentBackupDir(a:originalFilespec)

    " If there is an adjacent backup directory, use it.
    return (isdirectory(l:adjacentBackupDir) ? l:adjacentBackupDir : s:GetFallbackBackupDir(a:originalFilespec, a:isQueryOnly))
endfunction

function! writebackupToAdjacentDir#MakeAdjacentDir( ... )
    let l:adjacentBackupDir = s:GetAdjacentBackupDir(expand('%'))

    if isdirectory(l:adjacentBackupDir)
	call ingo#msg#WarningMsg('Backup directory already exists: ' . fnamemodify(l:adjacentBackupDir, ':~:.'))
	return 1
    elseif filereadable(l:adjacentBackupDir)
	call ingo#err#Set('Cannot create backup directory; file exists: ' . fnamemodify(l:adjacentBackupDir, ':~:.'))
	return 0
    endif

    try
	call call('mkdir', [l:adjacentBackupDir, ''] + a:000)
	return 1
    catch /^Vim\%((\a\+)\)\=:E739/	" E739: Cannot create directory
	call ingo#err#SetVimException()
	return 0
    endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
