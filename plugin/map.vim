nnoremap <C-j>   <Esc>0yiwj
nnoremap <C-l>a   <Esc>:w<CR>:!git add %<CR>
nnoremap <C-l>c   <Esc>:w<CR>:!git commit -m ""<Left>
nnoremap <C-l>g   <Esc>:!git push origin master<CR>
nnoremap <C-l>1   <Esc>:1b<CR>
"nnoremap <C-l>d   <Esc>:packadd termdebug<CR>:Termdebug<CR><C-W>c<C-w>c<C-w>s:b arm-linux-androideabi-gdb<CR>set sysroot /Users/luoluorushi/tmp/and/8d946090/system/bin<CR>file ~/app_process<CR>target remote :4000<CR>set solib-search-path /Users/luoluorushi/code/tvkplayer/tvkplayercore/core/obj-full<CR>
"nnoremap <C-l>d   <Esc>:packadd termdebug<CR>:Termdebug<CR><C-W>c<C-w>c<C-w>s<C-w>v:b debugged program<CR><C-w>h:b arm-linux-androideabi-gdb<CR>set sysroot /Users/luoluorushi/tmp/and/8d946090/system/bin<CR>file ~/app_process<CR>target remote :4000<CR>set solib-search-path /Users/luoluorushi/code/tvkplayer/tvkplayercore/core/obj-full<CR>
nnoremap <C-l>d   <Esc>:packadd termdebug<CR>:Termdebug hello<CR><C-W>c<C-w>c<C-w>s<C-w>v:b debugged program<CR><C-w>h:b gdb<CR>
noremap [{ [[k%%b:cs find c <C-R>=expand("<cword>")<CR><CR>
noremap ]} 2j]]k%%b

nmap <Leader>1 :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>a :cs find a <C-R>=expand("<cword>")<CR><CR>

nnoremap <Leader>n   <Esc>:NERDTreeToggle<CR>
nnoremap <Leader>m   <Esc>:NERDTreeFind<CR>
nnoremap <Leader>d   <Esc>:YcmCompleter GoToDefinition<CR>
nnoremap <Leader>t   <Esc>:YcmCompleter GoToDeclaration<CR>
nnoremap <Leader>g   <Esc>:YcmCompleter GoToInclude<CR>
nnoremap <Leader>yf   <Esc>:YcmCompleter FixIt<CR>

nnoremap <Leader>z :TagbarToggle<CR><C-w>l
noremap <Leader>r <Esc>:w<CR>:!rm hello<CR>:make<CR>:!./hello<CR>
noremap <Leader>b <Esc>:w<CR>:!rm hello<CR>:silent make\|redraw!\|cc<CR>
nnoremap <Leader>e   <Esc>:PlantumlOpen<CR>

" markdown配色
vmap 'r di<font color="#F4606C">**<Esc>pa**</font><Esc>
vmap 'g di<font color="#19CAAD">**<Esc>pa**</font><Esc>
vmap 'b di<font color="#BEEDC7">**<Esc>pa**</font><Esc>
vmap 'y di<font color="#D1BA74">**<Esc>pa**</font><Esc>

" ctrlp
map <leader>f :CtrlPMRU<CR>
map <leader>fb :CtrlPBuffer<CR>
