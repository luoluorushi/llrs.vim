function! Helloworld()
     echo "hello,world"
endfunction    

nnoremap <Leader>a   <Esc>:w<CR>:!git add %<CR>
nnoremap <Leader>c   <Esc>:w<CR>:!git commit -m 
nnoremap <Leader>g   <Esc>:!git push origin master<CR>
