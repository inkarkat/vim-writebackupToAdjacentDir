function! MakeReadonly( filespec )
    if has('win32') || has('win64')
	call vimtest#System('icacls ' . escapings#shellescape(a:filespec) . ' /deny %username%:(WD,AD,DC)' )
    else
	call vimtest#System('chmod -w ' . escapings#shellescape(a:filespec))
    endif
endfunction

