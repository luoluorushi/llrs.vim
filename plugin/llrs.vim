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
"

" ===============================utils begin ======================================
fu! llrs#scratch()
    exec "enew"
	exec "setlocal buftype=nofile"
	exec "setlocal bufhidden=hide"
	exec "setlocal noswapfile"
	exec "setlocal nobuflisted"
endfu

" ===============================utils end ======================================
" ===============================database begin ======================================

" title:title content
" description:descontent
" copy:copy content
" colume:colume name
" tag:tag name
"  ------------------------------------------------------------
" description,copy,colume,tag is option
"
let s:fileline=[]
let s:mapsplitter = ""

fu! llrs#adddata(title, content, ...)
    let splitter = s:mapsplitter
    let line = splitter
    let line .= "title:"
    let line .= a:title
    let line .= splitter
    let line .= "description:"
    let line .= a:content
    let argcount = a:0
    if argcount > 0 && a:1 != ''
       let line .= splitter
       let line .= "copy:"
       let line .= a:1
    en
    if argcount > 1 && a:2 != ''
       let line .= splitter
       let line .= "colume:"
       let line .= a:2
    en
    if argcount > 2 && a:3 != ''
       let line .= splitter
       let line .= "tag:"
       let line .= a:3
    en
    let line .= splitter
    call add(s:fileline,line)
    call llrs#showdata(s:fileline, "", "heh")
endfu

fu! llrs#showoneline(index, line, st, sd)
    let maplist = split(a:line, s:mapsplitter)
    if len(maplist) > 0
        let @8 = string(a:index).". ".strpart(maplist[0], 6, strlen(maplist[0]))
        if match(@8, a:st) == -1
            return
        endif
    endif
    if len(maplist) > 1
        let @9 = strpart(maplist[1], match(maplist[1], ":")+1, strlen(maplist[1]))
        if match(@9, a:sd) == -1
            return
        endif
        put 8
        put 9
    endif
    let mapindex = 2
    while mapindex < len(maplist)
        let @8 = maplist[mapindex]
        put 8
        let mapindex += 1
    endwhile
endfu

fu! llrs#showdata(lines, st, sd)
    call llrs#scratch()
    let index = 0
    let @8 = ""
    while index < len(a:lines)
        call llrs#showoneline(index, a:lines[index], a:st, a:sd)
        let index += 1
    endwhile
endfu

" ===============================database end ========================================
