function! Helloworld()
     echo "hello,world"
endfunction    

nnoremap <Leader>a   <Esc>:w<CR>:!git add %<CR>
nnoremap <Leader>c   <Esc>:w<CR>:!git commit -m 
nnoremap <Leader><Leader>g   <Esc>:!git push origin master<CR>
nnoremap <Leader>1   <Esc>:1b<CR>
nnoremap <Leader>d   <Esc>:packadd termdebug<CR>:Termdebug app<CR><C-W>c<C-w>c<C-w>s<C-w>v:b debugged program<CR><C-w>h:b gdb<CR>
nnoremap <Leader>f   <Esc>:NERDTreeToggle<CR>
nnoremap <Leader>s   <Esc>:CtrlSF<CR>
