" writebackupToAdjacentDir.vim: writebackup plugin writes to an adjacent directory if it exists.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"   - ingo/err.vim autoload script
"   - ingo/fs/path.vim autoload script
"   - ingo/fs/traversal.vim autoload script
"   - ingo/msg.vim autoload script
"   - writebackup plugin (vimscript #1828), version 1.30 or higher

" Copyright: (C) 2010-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   2.00.005	01-Aug-2013	Split off autoload script.
"				ENH: Implement upwards directory hierarchy
"				search for backup directories, and then
"				re-create the path to the current file inside
"				that parallel backup directory hierarchy.
"				ENH: :WriteBackupMakeAdjacentDir now optionally
"				also takes a target directory to better support
"				the new upwards directory hierarchy search.
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

function! s:GetBackupDir( dirname )
    return printf(g:WriteBackupAdjacentDir_BackupDirTemplate, a:dirname)
endfunction
function! s:CombineToBackupDir( parentDirspec, dirname )
    return ingo#fs#path#Combine(
    \   a:parentDirspec,
    \	s:GetBackupDir(a:dirname)
    \)
endfunction
function! s:GetAdjacentBackupDir( originalFilespec )
    let l:originalDirname = fnamemodify(a:originalFilespec, ':p:h:t')
    let l:originalParentDirspec = fnamemodify(a:originalFilespec, ':p:h:h')
"****D echomsg '****' l:originalDirname l:originalParentDirspec
    return s:CombineToBackupDir(l:originalParentDirspec, l:originalDirname)
endfunction

function! writebackupToAdjacentDir#HasBackupDir( dirspec )
    " Make sure that we're actually see the backup directories; the user may
    " have configured Vim to ignore them.
    let l:save_wildignore = &wildignore
    set wildignore=
    try
	let l:backupDirspecs = filter(
	\   split(glob(ingo#fs#path#Combine(a:dirspec, s:GetBackupDir('*'))), '\n'),
	\   'isdirectory(v:val)'
	\)
    finally
	let &wildignore = l:save_wildignore
    endtry
    if empty(l:backupDirspecs)
	return 0
    endif

    " The backup directory name must correspond to the original file's directory
    " name at the same hierarchy level.
    for l:backupDirspec in l:backupDirspecs
	let l:backupDirPaths = split(l:backupDirspec, escape(ingo#fs#path#Separator(), '\'))
"****D echomsg '****' string(l:backupDirPaths) string(s:originalAbsolutePaths)
	if s:GetBackupDir(get(s:originalAbsolutePaths, len(l:backupDirPaths) - 1, '')) ==# l:backupDirPaths[-1]
	    let s:backupDirspec = ingo#fs#path#Combine(l:backupDirspec,
	    \   join(s:originalAbsolutePaths[len(l:backupDirPaths) : ], ingo#fs#path#Separator())
	    \)
	    return 1
	endif
    endfor
    return 0
endfunction
function! s:GetUpwardsBackupDir( originalFilespec )
    let s:backupDirspec = ''
    let l:originalAbsoluteDirspec = fnamemodify(a:originalFilespec, ':p:h')
    let s:originalAbsolutePaths = split(l:originalAbsoluteDirspec, escape(ingo#fs#path#Separator(), '\'))

    " Because we also need the combined backup path, the find function is only
    " invoked for its side effect of driving the iteration; the result is only
    " used to determine success; the actual backup directory is returned via
    " s:backupDirspec.
    if empty(ingo#fs#traversal#FindDirUpwards(function('writebackupToAdjacentDir#HasBackupDir'), l:originalAbsoluteDirspec))
	return ''
    else
	return s:backupDirspec
    endif
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
    " If there is an adjacent backup directory, use it.
    let l:adjacentBackupDir = s:GetAdjacentBackupDir(a:originalFilespec)
    if isdirectory(l:adjacentBackupDir)
	return l:adjacentBackupDir
    endif

    " Else try lookup upwards in the file system.
    if g:WriteBackupAdjacentDir_IsUpwardsBackupDirSearch
	let l:upwardsBackupDir = s:GetUpwardsBackupDir(a:originalFilespec)
	if ! empty(l:upwardsBackupDir)
	    if ! isdirectory(l:upwardsBackupDir) && ! a:isQueryOnly
		try
		    call mkdir(l:upwardsBackupDir, 'p')
		    return l:upwardsBackupDir
		catch /^Vim\%((\a\+)\)\=:E739/	" E739: Cannot create directory
		    throw 'WriteBackup: Cannot create subdirectory inside backup directory: ' . l:upwardsBackupDir
		endtry
	    endif
	    return l:upwardsBackupDir
	endif
    endif

    return s:GetFallbackBackupDir(a:originalFilespec, a:isQueryOnly)
endfunction

function! writebackupToAdjacentDir#MakeDir( arguments )
    if a:arguments =~# '^\d\{1,4}$'
	let [l:dirArgument, l:prot] = ['', a:arguments]
    else
	let [l:dirArgument, l:prot] = matchlist(a:arguments, '^\(.\{-}\)\%(\s\+\(\d\{1,4}\)\)\?$')[1:2]
    endif
    if empty(l:dirArgument)
	let l:backupDir = s:GetAdjacentBackupDir(expand('%'))
    else
	" Environment variables are not automatically expanded, and the
	" whitespace escaping also is still there.
	let l:dir = expand(l:dirArgument)

	if l:dir =~# '^\.'
	    " Determine the backup target directory relative to the current
	    " buffer's dirspec.
	    " Note: On Linux, fnamemodify(..., ':p') only simplifies a ".." at
	    " the end when it ends with a path separator: "../", so make sure it
	    " does.
	    let l:targetDir = fnamemodify(
	    \   ingo#fs#path#Combine(expand('%:p:h'),
	    \       ingo#fs#path#Combine(l:dir, '')
	    \   ),
	    \   ':p'
	    \)
	else
	    " An absolute target has been passed; just canonicalize it.
	    let l:targetDir = fnamemodify(l:dir, ':p')
	endif
	let l:targetDirname = fnamemodify(l:targetDir, ':h:t')
	let l:targetParentDirspec = fnamemodify(l:targetDir, ':h:h')
	let l:backupDir = s:CombineToBackupDir(l:targetParentDirspec, l:targetDirname)
"****D echomsg '****' l:targetDir l:backupDir
    endif

    if isdirectory(l:backupDir)
	call ingo#msg#WarningMsg('Backup directory already exists: ' . fnamemodify(l:backupDir, ':~:.'))
	return 1
    elseif filereadable(l:backupDir)
	call ingo#err#Set('Cannot create backup directory; file exists: ' . fnamemodify(l:backupDir, ':~:.'))
	return 0
    endif

    try
	call call('mkdir', [l:backupDir, 'p'] + (empty(l:prot) ? [] : [l:prot]))
	return 1
    catch /^Vim\%((\a\+)\)\=:E739/	" E739: Cannot create directory
	call ingo#err#SetVimException()
	return 0
    endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
