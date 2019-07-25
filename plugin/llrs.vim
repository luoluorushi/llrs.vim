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
    noremap <buffer> q :bd<CR>
endfu

fu! llrs#filterInScratch(filter)
	let lines = getline(1, '$')
    let listlen = len(lines)
    let index = 0
    if listlen == 0
        return
    endif
    call llrs#scratch()
    while index < listlen
        if match(lines[index], a:filter) != -1
            let @8 = lines[index]
            put 8
        endif
        let index += 1
    endwhile
endfu

" ===============================utils end ======================================
" ===============================database begin ======================================

" title:title content
" description:descontent
" url:url
" copy:copy content
" pic:pic path;pic path;pic path;
" file:file path;file path;file path;
" colume:colume name
" tag:tag name
"  ------------------------------------------------------------
" description,copy,colume,tag is option
"
let s:fileline=[]
let s:mapsplitter = ""
let s:dataFilePath = "/Users/luoluorushi/Github/lldb/"
let s:dataFiles=["misc","copy","essence","algorithm","temp"]
let s:dataFileExt = ".db"
let s:dataBufMap = {}
let s:hasCopy = 0

fu! s:dbReadFromFile(file)
    if has_key(s:dataBufMap, a:file)
        return s:dataBufMap[a:file]
    endif
    if index(s:dataFiles, a:file) < 0
        echom "not support db file"
        return []
    endif
    let filepath = s:dataFilePath.a:file.s:dataFileExt
    let filedata = readfile(filepath)
    let s:dataBufMap[a:file] = filedata
    return s:dataBufMap[a:file]
endfu

fu! llrs#showAddScrath()
    call llrs#scratch()
    map <buffer> ;c :call llrs#addFromScratch()<CR>
    let @8 = s:mapsplitter
    put 8
    let @8 = "title:"
    put 8
    let @8 = "description:"
    put 8
    let @8 = s:mapsplitter
    put 8
    let @8 = "url:"
    put 8
    let @8 = "copy:"
    put 8
    let @8 = "pic:"
    put 8
    let @8 = "file:"
    put 8
    let @8 = "colume:"
    put 8
    let @8 = "tag:"
    put 8
    let @8 = "filedb:misc"
    put 8
    
    let index = 0
    let dblen = len(s:dataFiles)
    let tips = "("
    while index < dblen
        let tips =  tips.s:dataFiles[index].' '
        let index += 1
    endwhile
    let tips .= ")"
    let @8 = tips
    put 8
    let @8 = s:mapsplitter
    put 8
    execute "normal gg2jA"
endfu

fu! s:addDbData(filedb, title, content, url, copy, pic,file, colume, tag)
    let file = s:dataFilePath.a:filedb.s:dataFileExt
    let splitter = s:mapsplitter
    let line = splitter
    let line .= "title:"
    let line .= a:title
    let line .= splitter
    let line .= "description:"
    let line .= a:content
    let argcount = a:0
    
    let line .= splitter
    let line .= "url:"
    let line .= a:url
    let line .= splitter
    let line .= "copy:"
    let line .= a:copy
    let line .= splitter
    let line .= "pic::"
    let line .= a:pic
    let line .= splitter
    let line .= "file::"
    let line .= a:file
    let line .= splitter
    let line .= "colume:"
    let line .= a:colume
    let line .= splitter
    let line .= "tag:"
    let line .= a:tag
    let line .= splitter
    let lines = []
    call insert(lines, line)
    call writefile(lines, file, "a")

    let gitcommand = "!cd ".s:dataFilePath." && git add . && git commit -m \"".a:title."\" && git push origin master"
    "execute gitcommand

    if has_key(s:dataBufMap, a:file)
        call add(s:dataBufMap[a:file],line)
    endif
endfu

fu! s:showoneline(index, line, st, sd, cl, tg)
    let maplist = split(a:line, s:mapsplitter)
    let title=""
    let des=""
    let copy=""
    let pic=""
    let file = ""
    let colume=""
    let tag=""
    let url=""
    let listlen = len(maplist)
    let title = string(a:index).". ".strpart(maplist[0], 6, strlen(maplist[0]))
    if match(title, a:st) == -1
        return 0
    endif
    let des = strpart(maplist[1], match(maplist[1], ":")+1, strlen(maplist[1]))
    if match(des, a:sd) == -1
        return 0
    endif
    let url =strpart(maplist[2], match(maplist[2], ":")+1, strlen(maplist[2]))
    let copy = strpart(maplist[3], match(maplist[3], ":")+1, strlen(maplist[3]))
    let pic = strpart(maplist[4], match(maplist[4], ":")+1, strlen(maplist[4]))
    let file = strpart(maplist[5], match(maplist[5], ":")+1, strlen(maplist[5]))
    let colume = strpart(maplist[6], match(maplist[6], ":")+1, strlen(maplist[6]))
    if match(colume, a:cl) == -1
        return 0
    endif
    let tag = strpart(maplist[7], match(maplist[7], ":")+1, strlen(maplist[7]))
    if match(tag, a:tg) == -1
        return 0
    endif

    let @8 = title
    put 8
    let deslines = split(des, '')
    let deslen = len(deslines)
    let desindex = 0
    while desindex < deslen
        let @8 = deslines[desindex]
        put 8
        let desindex += 1
    endwhile
    if strlen(url) > 0
        let url = '[link url]('.url.')'
    endif
    let @8 = url
    put 8
    let piclist = split(pic, ";")
    let filelist = split(file,";")
    let tempindex = 0
    while tempindex < len(piclist)
        let @8 = "![picture".string(tempindex)."](".s:dataFilePath.piclist[tempindex].")"
        put 8
        let tempindex += 1
    endwhile
    let tempindex = 0
    while tempindex < len(filelist)
        let @8 = "[file".string(tempindex)."](file://".s:dataFilePath.filelist[tempindex].")"
        put 8
        let tempindex += 1
    endwhile

    let @8 = '```'
    put 8
    let @8 = copy
    put 8
    let @8 = '```'
    put 8
    let @8 = colume
    put 8
    let @8 = tag
    put 8
    if s:hasCopy == 0 && len(copy) > 0
        let @* = copy
        let s:hasCopy = 1
    endif
    return 1
endfu

fu! s:dbnavigation()
    let line = getline(".")
    echom line
    let index = match(line, "^[.*file://.*)$")
    if index != -1
        let matchindex = match(line, "file://")
        let path = strpart(line, matchindex+7, strlen(line)-matchindex-8)
        return 
    endif

    let index = match(line, "^![.*(.*)$")
    echo index
    if index != -1
        let matchindex = match(line, "(")
        let path = strpart(line, matchindex+1, strlen(line)-matchindex-2)
        echo path
        if filereadable(path)
            exec "!open ".path
        else
            echo "file not readable"
        endif
        return
    endif

    let index = match(line, "^[.*(.*)$")
    echo index
    if index != -1
        let matchindex = match(line, "(")
        let path = strpart(line, matchindex+1, strlen(line)-matchindex-2)
        echo path
        exec "!open ".path
    endif
endfu

fu! llrs#showdata(file, st, sd, cl, tg)
    let lines = s:dbReadFromFile(a:file)
    if len(lines) == 0
        echo "empty file"
        return
    endif
    call llrs#scratch()
    set syntax=markdown
    "map <buffer> <C-o> q
    map <buffer> ;g :call <SID>dbnavigation()<CR>
    let index = 0
    let showindex = 0
    let s:hasCopy = 0
    while index < len(lines)
        let showindex += s:showoneline(showindex, lines[index], a:st, a:sd, a:cl, a:tg)
        let index += 1
    endwhile
    execute "normal gg"
    "exec "set nomodifiable"
endfu


fu! llrs#addFromScratch()
	let lines = getline(1, '$')
    let listlen = len(lines)
    if listlen > 20000
        echo "too much lines"
        return
    endif
    let index = 0
    if listlen == 0
        return
    endif
    let title = ""
    let des = ""
    let url = ""
    let copy = ""
    let piclist = ""
    let filelist = ""
    let colume = ""
    let tag = ""
    let filedb = ""
    while index < listlen
        if match(lines[index], s:mapsplitter) != -1
            let index += 1
            break
        endif
        let index += 1
    endwhile

    while index < listlen
        if match(lines[index], s:mapsplitter) != -1
            break
        endif
        if match(lines[index], "title:") == 0
            if strlen(title) > 0
                echo "title already exist"
                return 
            endif
            let title = strpart(lines[index], match(lines[index], ":")+1, strlen(lines[index]))
        endif
        if match(lines[index], "description:") == 0
            if strlen(des) > 0
                echo "description already exist"
                return 
            endif
            let des = strpart(lines[index], match(lines[index], ":")+1, strlen(lines[index]))
            let index += 1
            while index < listlen
                if match(lines[index], s:mapsplitter) != -1
                    let index += 1
                    break
                endif
                let des = des.''.lines[index]
                let index += 1
            endwhile
        endif
        if match(lines[index], "url:") == 0
            if strlen(url) > 0
                echo "url already exist"
                return 
            endif
            let url = strpart(lines[index], match(lines[index], ":")+1, strlen(lines[index]))
        endif
        if match(lines[index], "copy:") == 0
            if strlen(copy) > 0
                echo "copy already exist"
                return 
            endif
            let copy = strpart(lines[index], match(lines[index], ":")+1, strlen(lines[index]))
        endif
        if match(lines[index], "colume:") == 0
            if strlen(colume) > 0
                echo "colume already exist"
                return 
            endif
            let colume = strpart(lines[index], match(lines[index], ":")+1, strlen(lines[index]))
        endif
        if match(lines[index], "tag:") == 0
            if strlen(tag) > 0
                echo "tag already exist"
                return 
            endif
            let tag = strpart(lines[index], match(lines[index], ":")+1, strlen(lines[index]))
        endif
        if match(lines[index], "filedb:") == 0
            if strlen(filedb) > 0
                echo "filedb already exist"
                return 
            endif
            let filedb = strpart(lines[index], match(lines[index], ":")+1, strlen(lines[index]))
        endif
        if match(lines[index], "pic:") == 0
            let piclist = strpart(lines[index], match(lines[index], ":")+1, strlen(lines[index]))
        endif
        if match(lines[index], "file:") == 0
            let filelist = strpart(lines[index], match(lines[index], ":")+1, strlen(lines[index]))
        endif
        let index += 1
    endwhile

    if strlen(title) == 0 || strlen(des) == 0 || strlen(filedb) == 0
        return
    endif
    if match(s:dataFiles, filedb) == -1
        echo "no such db files"
        return
    endif
    call s:addDbData(filedb, title, des, url, copy, piclist,filelist, colume, tag)
endfu

" ===============================map begin ========================================
noremap ;a :call llrs#showAddScrath()<CR>
noremap ;f :call llrs#filterInScratch("")<Left><Left>
noremap ;1 :call llrs#showdata("misc","","","","")<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
" ===============================map end ========================================
"
" ===============================database end ========================================
