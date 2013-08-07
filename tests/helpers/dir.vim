function! MakeReadonly( filespec )
    if has('win32') || has('win64')
	call vimtest#System('icacls ' . escapings#shellescape(a:filespec) . ' /deny ' . escapings#shellescape('%userdomain%\%username%:(WD,AD,DC)'))
    else
	call vimtest#System('chmod -w ' . escapings#shellescape(a:filespec))
	" Linux cannot remove a directory tree if one contained directory is not
	" writable, so we schedule an undo action when Vim is closed.
	execute 'autocmd VimLeavePre * call vimtest#System("chmod +w " . ' . string(escapings#shellescape(fnamemodify(a:filespec, ':p'))) . ', 1)'
    endif
    call vimtest#ErrorAndQuitIf(filewritable(a:filespec) != 0, 'Failed to make directory readonly: ' . a:filespec)
endfunction
