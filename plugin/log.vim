noremap ;f :call log#filterInScratch("")<Left><Left>
noremap ;b :call log#qqliveInfo()<CR>
noremap ;r :call log#removeRepeate(31)<Left><Left>
noremap ;;; :call log#submarineLaunch()<CR>
noremap ;;m :call log#markLog()<CR>
noremap ;;c :call log#clearMarkLog()<CR>
noremap ;;a :call log#markScratch()<CR>
noremap ;;s :call log#showMarkedLog()<CR>

let w:loglines = []

fu! log#markLog()
    let line = getline(".")
    call add(w:loglines, line)
endfu

fu! log#markScratch()
	let lines = getline(1, '$')
    for line in lines
        call add(w:loglines, line)
    endfor
endfu

fu! log#clearMarkLog()
    let w:loglines = []
endfu

fu! log#showMarkedLog()
    call utils#scratch()
    for markline in w:loglines
        let @8 = markline
        put 8
    endfor
    let sortCommand = "%sort u"
    exec sortCommand
endfu

fu! log#submarineLaunch()
	let lines = getline(1, '$')
    let listlen = len(lines)
    if listlen == 0
        return
    endif
    call utils#scratch()
    let index = 0
    let filters = ['main]','pagemodel','AppBrightnessController','activity','pagelogic','end of mmap','begin of mmap']
    let nofilters = ['RAFTTabSDKNotifyExecutor','VBPBService-','tquic_main_thre']
    while index < listlen
        let isIgnore = 0
        for nofilter in nofilters
            if match(lines[index], nofilter) != -1
                let isIgnore = 1
                break
            endif
        endfor
        if isIgnore == 1
            let index += 1
            continue
        endif
        for filter in filters
            if match(lines[index], filter) != -1
                let @8 = lines[index]
                put 8
                break
            endif
        endfor
        let index += 1
    endwhile
endfu

fu! log#qqliveInfo()
    let lines = getline(1, '$')
    let listlen = len(lines)
    let index = 0
    if listlen == 0
        return
    endif
    call utils#scratch()

    "basic info
    call utils#putString('基础信息:')
    let versionFlag = 1
    let cookieFlag = 1
    while index < listlen
        let filter = "QQLiveApplication"
        if versionFlag == 1 && match(lines[index], filter) != -1 && match(lines[index], "versionName =") != -1
            let pat = 'versionName = \(.*\)'
            let matchList = matchlist(lines[index], pat)
            call utils#putString('  版本：'..matchList[1])
            let versionFlag = 0
        endif
        let filter = 'synSysWebCookies cookie'
        if cookieFlag == 1 && match(lines[index], filter) != -1
            let cookieFlag = 0
            let pat = 'video_omgid=\(.\{-}\);'
            let matchList = matchlist(lines[index], pat)
            call utils#putString('  omgid：'..matchList[1])
            let pat = 'guid=\(.\{-}\);'
            let matchList = matchlist(lines[index], pat)
            call utils#putString('  guid：'..matchList[1])
            let pat = 'vuserid=\(.\{-}\);'
            let matchList = matchlist(lines[index], pat)
            call utils#putString('  vuid：'..matchList[1])
            let pat = 'main_login=\(.\{-}\);'
            let matchList = matchlist(lines[index], pat)
            call utils#putString('  main_login：'..matchList[1])
            let pat = 'isDarkMode=\(.\{-}\);'
            let matchList = matchlist(lines[index], pat)
            call utils#putString('  dark_mode：'..matchList[1])
        endif
        if versionFlag == 0 && cookieFlag == 0
            break
        endif
        let index += 1
    endwhile

    "live info
    let index = 0
    while index < listlen
        let index += 1
    endwhile

    "vn info
    let index = 0
    while index < listlen
        let index += 1
    endwhile
    "tvk info
    "登录信息
    "联通免流信息
endfu

fu! log#removeRepeate(start)
	let lines = getline(1, '$')
    let listlen = len(lines)
    let index = 0
    if listlen == 0
        return
    endif
    call utils#scratch()
    let resultList = []
    while index < listlen
        let searchIndex = 0
        let resultLen = len(resultList)
        let targetStr = lines[index]
        let matchStr = strpart(targetStr, a:start)
        while searchIndex < resultLen
            if matchStr == strpart(resultList[searchIndex], a:start)
                break
            endif
            let searchIndex += 1
        endwhile
        if searchIndex == resultLen
            call add(resultList, targetStr)
            let @8 = lines[index]
            put 8
        endif
        let index += 1
    endwhile
endfu

fu! log#filterInScratch(filter)
	let lines = getline(1, '$')
    let listlen = len(lines)
    let index = 0
    if listlen == 0
        return
    endif
    if len(a:filter) == 0
        return
    endif
    let no = 0
    let filter = a:filter
    if a:filter[0] == '!'
        let no = 1
        let filter = strpart(a:filter, 1, strlen(a:filter))
    endif
    call utils#scratch()
    while index < listlen
        if match(lines[index], filter) != -1
            if no != 1
                let @8 = lines[index]
                put 8
            endif
        elseif no == 1
            let @8 = lines[index]
            put 8
        endif
        let index += 1
    endwhile
endfu
