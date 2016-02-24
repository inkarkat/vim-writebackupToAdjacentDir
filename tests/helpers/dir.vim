function! MakeReadonly( filespec )
    if ingo#os#IsWinOrDos()
	call vimtest#System('icacls ' . ingo#compat#shellescape(a:filespec) . ' /deny ' . ingo#compat#shellescape('%userdomain%\%username%:(WD,AD,DC)'))
    else
	call vimtest#System('chmod -w ' . ingo#compat#shellescape(a:filespec))
	" Linux cannot remove a directory tree if one contained directory is not
	" writable, so we schedule an undo action when Vim is closed.
	execute 'autocmd VimLeavePre * call vimtest#System("chmod +w " . ' . string(ingo#compat#shellescape(fnamemodify(a:filespec, ':p'))) . ', 1)'
    endif
    call vimtest#ErrorAndQuitIf(filewritable(a:filespec) != 0, 'Failed to make directory readonly: ' . a:filespec)
endfunction
