fu! utils#scratch()
    exec "enew"
	exec "setlocal buftype=nofile"
	exec "setlocal bufhidden=hide"
	exec "setlocal noswapfile"
	exec "setlocal nobuflisted"
    noremap <buffer> ;q :bd<CR>
endfu

fu! utils#putString(str)
    let @8 = a:str
    put 8
endfu
