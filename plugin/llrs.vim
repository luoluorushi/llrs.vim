function! s:get_input()
py3 << EOF
import vim
import llrs
input=llrs.get_input_source()
vim.command("let input = '%s'"% input)
EOF
    return input
endfunction

function! s:change_input_source(enter)
if a:enter == 1
    if s:sinput != s:get_input()
py3 << EOF
#import llrs
llrs.change_input_source()
EOF
    endif
else
    if s:get_input() != 'ABC'
py3 << EOF
import llrs
llrs.change_input_source()
EOF
    endif
endif
endfunction

function! s:zoom_window()
py3 << EOF
import llrs
llrs.zoom_window()
EOF
endfunction

function! s:to_head_or_impl()
    if expand('%:e') == 'cpp'
        let command='vi '.expand('%:p:h').'/'.expand('%:r').'.h'
        let path=expand('%:p:h').'/'.expand('%:r').'.h'
        if filereadable(path)
            exec command
        endif
    elseif expand('%:e') == 'h'
        let command='vi '.expand('%:p:h').'/'.expand('%:r').'.cpp'
        let path=expand('%:p:h').'/'.expand('%:r').'.cpp'
        if filereadable(path)
            exec command
        endif
    endif
endfunction

let s:sinput='ABC'
command! -nargs=0 LlrsHead  call s:to_head_or_impl()

noremap <SID>to_head_or_impl :call <SID>to_head_or_impl()<CR>
noremap <unique> <script> <Plug>llrsHead <SID>to_head_or_impl

map <Leader>ln   <Plug>llrsHead
nnoremap <Leader>la   <Esc>:w<CR>:!git add %<CR>
nnoremap <Leader>lc   <Esc>:w<CR>:!git commit -m ""<Left>
nnoremap <Leader>lg   <Esc>:!git push origin master<CR>
nnoremap <Leader>l1   <Esc>:1b<CR>
nnoremap <Leader>ld   <Esc>:packadd termdebug<CR>:Termdebug app<CR><C-W>c<C-w>c<C-w>s<C-w>v:b debugged program<CR><C-w>h:b gdb<CR>
nnoremap <Leader>f   <Esc>:NERDTreeToggle<CR>
nnoremap <Leader>s   <Esc>:CtrlSF<CR>

set shell=/bin/zsh

autocmd InsertLeave * let s:sinput=s:get_input() | call s:change_input_source(0)
autocmd InsertEnter * call s:change_input_source(1)
"autocmd VimEnter * call s:zoom_window()
"autocmd VimLeave * call s:zoom_window()
