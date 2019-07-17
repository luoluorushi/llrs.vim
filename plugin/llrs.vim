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
        let path=expand('%:p')
        let headpath=substitute(path, '.cpp', '.h', "")
        let command='vi '.headpath
        exec command
    elseif expand('%:e') == 'h'
        let ppth=expand('%:p')
        let ppth = ppth.'pp'
        let implpath=substitute(ppth, '.hpp', '.cpp', "")
        let command='vi '.implpath
        if filereadable(implpath)
            exec command
        endif
    endif
endfunction

function! s:compare_file()
    let prepath = expand('%:p')
    let s:path= substitute(prepath, 'TencentVideoPCPlayer', 'cross_platform', '')
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

noremap [{ [[k%%b
noremap ]} 2j]]k%%b

map <C-l>3   <Plug>llrsCompare<Esc>gt<Plug>llrsGoto
map <C-l>2   <Plug>llrsHead
nnoremap <C-l>a   <Esc>:w<CR>:!git add %<CR>
nnoremap <C-l>c   <Esc>:w<CR>:!git commit -m ""<Left>
nnoremap <C-l>g   <Esc>:!git push origin master<CR>
nnoremap <C-l>1   <Esc>:1b<CR>
nnoremap <C-l>d   <Esc>:packadd termdebug<CR>:Termdebug<CR><C-W>c<C-w>c<C-w>s:b arm-linux-androideabi-gdb<CR>set sysroot /Users/luoluorushi/tmp/and/8d946090/system/bin<CR>file ~/app_process<CR>target remote :4000<CR>set solib-search-path /Users/luoluorushi/code/tvkplayer/tvkplayercore/core/obj-full<CR>
"nnoremap <C-l>d   <Esc>:packadd termdebug<CR>:Termdebug<CR><C-W>c<C-w>c<C-w>s<C-w>v:b debugged program<CR><C-w>h:b arm-linux-androideabi-gdb<CR>set sysroot /Users/luoluorushi/tmp/and/8d946090/system/bin<CR>file ~/app_process<CR>target remote :4000<CR>set solib-search-path /Users/luoluorushi/code/tvkplayer/tvkplayercore/core/obj-full<CR>
"nnoremap <C-l>d   <Esc>:packadd termdebug<CR>:Termdebug app<CR><C-W>c<C-w>c<C-w>s<C-w>v:b debugged program<CR><C-w>h:b gdb<CR>


autocmd InsertLeave * silent! let s:sinput=s:get_input() | silent! call s:change_input_source(0)
autocmd InsertEnter * silent! call s:change_input_source(1)
"autocmd VimEnter * call s:zoom_window()
"autocmd VimLeave * call s:zoom_window()
"autocmd GUIEnter * call s:load_proj()

set shell=/bin/zsh

"register
let @a='viw"jp'
let @t='i// "%poo c€kbCreated by luoluorushi on =strftime("%Y/%m/%d.")Copyright u00a9 =stf€kbrftime("%Y¿ "€kb€kb ")luoluorushi. All right reserved.€kb€kb€kb'

" vim tips
" capture a control character by first typing CTRL-v followed by the character you want
