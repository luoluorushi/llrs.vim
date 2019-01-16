
function! Pymake()
    let filepath = expand('%:t:r')
    let pym = 'pym '.filepath
    let output = system(pym)
    echo output
endfunction
nnoremap <Leader>m   <Esc>:w<CR>:call Pymake()<CR>:!make<CR>
nnoremap <Leader>r   <Esc>:w<CR>:!make &&./app<CR>
nnoremap <Leader>y   <Esc>/class<CR>v$%$y<Esc>
