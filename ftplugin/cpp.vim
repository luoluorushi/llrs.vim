
function! Pymake()
    let filepath = expand('%:t:r')
    let pym = 'pym '.filepath
    let output = system(pym)
    echo output
endfunction
nnoremap <Leader>lm   <Esc>:w<CR>:call Pymake()<CR>:!make<CR>
nnoremap <Leader>lr   <Esc>:w<CR>:!make &&./app<CR>
nnoremap <Leader>ly   <Esc>/class<CR>v$%$y<Esc>
