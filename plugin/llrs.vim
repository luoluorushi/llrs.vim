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

let s:sinput='ABC'
command -nargs=0 Helloo  call s:change_input_source(1)

nnoremap <Leader>a   <Esc>:w<CR>:!git add %<CR>
nnoremap <Leader>c   <Esc>:w<CR>:!git commit -m ""<Left>
nnoremap <Leader><Leader>g   <Esc>:!git push origin master<CR>
nnoremap <Leader>1   <Esc>:1b<CR>
nnoremap <Leader>d   <Esc>:packadd termdebug<CR>:Termdebug app<CR><C-W>c<C-w>c<C-w>s<C-w>v:b debugged program<CR><C-w>h:b gdb<CR>
nnoremap <Leader>f   <Esc>:NERDTreeToggle<CR>
nnoremap <Leader>s   <Esc>:CtrlSF<CR>

set shell=/bin/zsh

autocmd InsertLeave * let s:sinput=s:get_input() | call s:change_input_source(0)
autocmd InsertEnter * call s:change_input_source(1)
"autocmd VimEnter * call s:zoom_window()
"autocmd VimLeave * call s:zoom_window()
