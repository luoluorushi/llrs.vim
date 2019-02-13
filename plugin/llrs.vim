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

function! s:compare_file()
    let prepath = expand('%:p')
    let s:path= substitute(prepath, 'MergeMac', 'cross_platform', '')
endfunction

function! s:goto_file()
    echom s:path
    let command='vi '.s:path
    if filereadable(s:path)
        exec command
    endif
endfunction

function! s:load_proj()
    let command='source '.'./proj.vim'
    if filereadable('./proj.vim')
        exec command
    endif
endfunction


let s:sinput='ABC'
command! -nargs=0 LlrsHead  call s:to_head_or_impl()

noremap <SID>to_head_or_impl :call <SID>to_head_or_impl()<CR>
noremap <unique> <script> <Plug>llrsHead <SID>to_head_or_impl

noremap <SID>compare_file :call <SID>compare_file()<CR>
noremap <unique> <script> <Plug>llrsCompare <SID>compare_file
noremap <SID>goto_file :call <SID>goto_file()<CR>
noremap <unique> <script> <Plug>llrsGoto <SID>goto_file<CR>

map <Leader>l3   <Plug>llrsCompare<Esc>gt<Plug>llrsGoto
map <Leader>l2   <Plug>llrsHead
nnoremap <Leader>la   <Esc>:w<CR>:!git add %<CR>
nnoremap <Leader>lc   <Esc>:w<CR>:!git commit -m ""<Left>
nnoremap <Leader>lg   <Esc>:!git push origin master<CR>
nnoremap <Leader>l1   <Esc>:1b<CR>
nnoremap <Leader>ld   <Esc>:packadd termdebug<CR>:Termdebug app<CR><C-W>c<C-w>c<C-w>s<C-w>v:b debugged program<CR><C-w>h:b gdb<CR>


autocmd InsertLeave * silent! let s:sinput=s:get_input() | silent! call s:change_input_source(0)
autocmd InsertEnter * silent! call s:change_input_source(1)
"autocmd VimEnter * call s:zoom_window()
"autocmd VimLeave * call s:zoom_window()
autocmd GUIEnter * call s:load_proj()

set number
set relativenumber
set shell=/bin/zsh
