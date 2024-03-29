noremap ;a :call database#showAddScrath()<CR>
noremap ;1 :call database#showdata("misc","","","","")<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
" ===============================database begin ======================================

" title:title content
" description:descontent
" url:url
" copy:copy content
" pic:pic path;pic path;pic path;
" file:file path;file path;file path;
" colume:colume name
" tag:tag name
" reference:ref list
"  ------------------------------------------------------------
" description,copy,colume,tag is option
"

let s:dbcommit=1
let s:fileline=[]
let s:mapsplitter = ""
let s:dataFilePath = "/Users/luoluorushi/Github/lldb/"
let s:dataFiles=["misc","copy","essence","algorithm","temp"]
let s:dataFileExt = ".db"
let s:dataBufMap = {}
let s:hasCopy = 0
let s:oriIndexSplitter = ".........."

fu! s:dbGitCommit(title, prefix)
    if s:dbcommit == 1
        let gitcommand = "!cd ".s:dataFilePath." && git add . && git commit -m \"".a:prefix.a:title."\" && git push origin master"
        execute gitcommand
    endif
endfu

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

fu! database#showAddScrath()
    call utils#scratch()
    map <buffer> ;c :call database#addFromScratch()<CR>
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
    let @8 = s:mapsplitter
    put 8
    let @8 = "pic:"
    put 8
    let @8 = "file:"
    put 8
    let @8 = "colume:"
    put 8
    let @8 = "tag:"
    put 8
    let @8 = "reference:"
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

fu! s:showAddWithLine(db, line)
    let maplist = split(a:line, s:mapsplitter)
    let title=""
    let des=""
    let copy=""
    let pic=""
    let file = ""
    let colume=""
    let tag=""
    let reference=""
    let url=""
    let title = strpart(maplist[0], 6, strlen(maplist[0]))
    let des = strpart(maplist[1], match(maplist[1], ":")+1, strlen(maplist[1]))
    let url =strpart(maplist[2], match(maplist[2], ":")+1, strlen(maplist[2]))
    let copy = strpart(maplist[3], match(maplist[3], ":")+1, strlen(maplist[3]))
    let pic = strpart(maplist[4], match(maplist[4], ":")+1, strlen(maplist[4]))
    let file = strpart(maplist[5], match(maplist[5], ":")+1, strlen(maplist[5]))
    let colume = strpart(maplist[6], match(maplist[6], ":")+1, strlen(maplist[6]))
    let tag = strpart(maplist[7], match(maplist[7], ":")+1, strlen(maplist[7]))
    if len(maplist)> 8
        let reference = strpart(maplist[8], match(maplist[8], ":")+1, strlen(maplist[8]))
    endif

    call utils#scratch()
    map <buffer> ;c :call database#addFromScratch()<CR>
    let @8 = s:mapsplitter
    put 8
    let @8 = "title:".title
    put 8
    let @8 = "description:".des
    put 8
    let @8 = s:mapsplitter
    put 8
    let @8 = "url:".url
    put 8
    let @8 = "copy:".copy
    put 8
    let @8 = s:mapsplitter
    put 8
    let @8 = "pic:".pic
    put 8
    let @8 = "file:".file
    put 8
    let @8 = "colume:".colume
    put 8
    let @8 = "tag:".tag
    put 8
    let @8 = "reference:".reference
    put 8
    let @8 = "filedb:".a:db
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
   
endfu

fu! s:modifyData()
    let filedb = getline(2)
    let oriline = getline(".")
    let index = match(oriline, s:oriIndexSplitter."ori:")
    if index == -1
        echo "not ori line"
        return
    endif
    let index = str2nr(strpart(oriline, match(oriline, "ori:")+4, len(oriline)))
    let lines = s:dbReadFromFile(filedb)
    if len(lines) <= index 
        echo "del index exccede"
        return
    endif
    let file = s:dataFilePath.filedb.s:dataFileExt
    if !filewritable(file)
        echo file." not writable"
        return
    endif
    let line = s:dataBufMap[filedb][index]
    let maplist = split(line, s:mapsplitter)
    let title = strpart(maplist[0], 6, strlen(maplist[0]))
    call remove(s:dataBufMap[filedb], index)
    call writefile(s:dataBufMap[filedb], file)
    let @j=@*
    exec "normal dd"
    let @*=@j
    let @8 = "rm ori:".string(index)." success"
    put 8
    echo @8

    call s:dbGitCommit(title, "delete ")
    call s:showAddWithLine(filedb,line)
endfu

fu! s:delDbData()
    let filedb = getline(2)
    let oriline = getline(".")
    let index = match(oriline, s:oriIndexSplitter."ori:")
    if index == -1
        echo "not ori line"
        return
    endif
    let index = str2nr(strpart(oriline, match(oriline, "ori:")+4, len(oriline)))
    let lines = s:dbReadFromFile(filedb)
    if len(lines) <= index 
        echo "del index exccede"
        return
    endif
    let file = s:dataFilePath.filedb.s:dataFileExt
    if !filewritable(file)
        echo file." not writable"
        return
    endif
    let line = s:dataBufMap[filedb][index]
    let maplist = split(line, s:mapsplitter)
    let title = strpart(maplist[0], 6, strlen(maplist[0]))
    call remove(s:dataBufMap[filedb], index)
    call writefile(s:dataBufMap[filedb], file)
    let @j=@*
    exec "normal dd"
    let @*=@j
    let @8 = "rm ori:".string(index)." success"
    put 8
    echo @8

    call s:dbGitCommit(title, "delete ")

    "exec "vi ".file
    "exec "normal ".string(index+1)."G"
    "exec "normal dd"
    "exec "w"
    "exec "bd"
endfu

fu! s:addDbData(filedb, title, content, url, copy, pic,file, colume, tag, reference)
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
    let line .= "pic:"
    let line .= a:pic
    let line .= splitter
    let line .= "file:"
    let line .= a:file
    let line .= splitter
    let line .= "colume:"
    let line .= a:colume
    let line .= splitter
    let line .= "tag:"
    let line .= a:tag
    let line .= splitter
    let line .= a:reference
    let line .= splitter
    let lines = []
    call insert(lines, line)
    call writefile(lines, file, "a")

    call s:dbGitCommit(a:title, "add ")

    if has_key(s:dataBufMap, a:filedb)
        call add(s:dataBufMap[a:filedb],line)
    endif
endfu

fu! s:showoneline(index,oriindex, line, st, sd, cl, tg)
    let maplist = split(a:line, s:mapsplitter)
    let title=""
    let des=""
    let copy=""
    let pic=""
    let file = ""
    let colume=""
    let tag=""
    let url=""
    let reference=""
    let listlen = len(maplist)
    let title = "####".string(a:index).". ".strpart(maplist[0], 6, strlen(maplist[0]))
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
    if listlen > 8
        let reference = strpart(maplist[8], match(maplist[8], ":")+1, strlen(maplist[8]))
    endif

    let mdline = "</br>"
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
    let @8 =mdline   
    put 8        
    if strlen(url) > 0
        let url = '[link url]('.url.')'
    endif
    let @8 = url.mdline
    put 8
    let piclist = split(pic, ";")
    let filelist = split(file,";")
    let reflist = split(reference,";")
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
    let tempindex = 0
    while tempindex < len(reflist)
        let @8 = "[ref".string(tempindex)."](".reflist[tempindex].")"
        put 8
        let tempindex += 1
    endwhile

    if len(copy) > 0
        let @8 = '```'
        put 8
        let copylines = split(copy, '')
        let copylen = len(copylines)
        let copyindex = 0
        while copyindex < copylen
            let @8 = copylines[copyindex]
            put 8
            let copyindex += 1
        endwhile
        let @8 = '```'
        put 8
    endif
    let @8 = colume.mdline
    put 8
    let @8 = tag.mdline
    put 8
    let @8 = s:oriIndexSplitter."ori:".a:oriindex.s:oriIndexSplitter.mdline
    put 8
    if s:hasCopy == 0 && len(copy) > 0
        let newcopy=substitute(copy, '', '\n', "g")
        let @* = newcopy
        let s:hasCopy = 1
    endif
    return 1
endfu

fu! s:execOpenFile(path)
    echo a:path
    if filereadable(a:path)
        exec "silent !open \"".a:path."\""
        redraw!
    else
        echo "file not readable"
     endif
endfu

fu! s:execOpenUrl(path)
    echo a:path
    exec "silent !open \"".a:path."\""
    redraw!
endfu

fu! s:dbnavigation()
    let line = getline(".")
    let index = match(line, "^[ref.*(.*)$")
    if index != -1
        let matchindex = match(line, "(")
        let ref = strpart(line, matchindex+1, strlen(line)-matchindex-2)
        echom ref
        call database#showdata("misc",ref,"","","")
        return
    endif
    let index = match(line, "^[.*file://.*)$")
    if index != -1
        let matchindex = match(line, "file://")
        let path = strpart(line, matchindex+7, strlen(line)-matchindex-8)
        call s:execOpenFile(path)
        return 
    endif
    let index = match(line, "^####.\. .*$")
    if index != -1
        let matchindex = match(line, "\.")
        let path = strpart(line, matchindex+7, strlen(line) - matchindex-7)
        call database#showdata("misc",path,"","","")
        return
    endif

    let index = match(line, "^![.*(.*)$")
    if index != -1
        let matchindex = match(line, "(")
        let path = strpart(line, matchindex+1, strlen(line)-matchindex-2)
        call s:execOpenFile(path)
        return
    endif

    let index = match(line, "^[.*(.*)</br>$")
    echo index
    if index != -1
        let matchindex = match(line, "(")
        let path = strpart(line, matchindex+1, strlen(line)-matchindex-7)
        call s:execOpenUrl(path)
    endif

    let index = match(line, "^[.*(.*)$")
    echo index
    if index != -1
        let matchindex = match(line, "(")
        let path = strpart(line, matchindex+1, strlen(line)-matchindex-2)
        call s:execOpenUrl(path)
    endif

endfu

fu! database#showdata(file, st, sd, cl, tg)
    let lines = s:dbReadFromFile(a:file)
    if len(lines) == 0
        echo "empty file"
        return
    endif
    call utils#scratch()
    set syntax=markdown
    "map <buffer> <C-o> q
    map <buffer> ;g :call <SID>dbnavigation()<CR>
    map <buffer> ;d :call <SID>delDbData()<CR>
    map <buffer> ;m :call <SID>modifyData()<CR>

    let index = 0
    let showindex = 0
    let s:hasCopy = 0
    let @8 = a:file
    put 8
    while index < len(lines)
        let showindex += s:showoneline(showindex, index, lines[index], a:st, a:sd, a:cl, a:tg)
        let index += 1
    endwhile
    execute "normal gg"
    "exec "set nomodifiable"
endfu


fu! database#addFromScratch()
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
    let reference = ""
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
            let index += 1
            while index < listlen
                if match(lines[index], s:mapsplitter) != -1
                    let index += 1
                    break
                endif
                let copy = copy.''.lines[index]
                let index += 1
            endwhile
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
        if match(lines[index], "reference:") == 0
            let reference = strpart(lines[index], match(lines[index], ":")+1, strlen(lines[index]))
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
    call s:addDbData(filedb, title, des, url, copy, piclist,filelist, colume, tag,reference)
endfu
