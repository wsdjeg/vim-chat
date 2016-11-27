scriptencoding utf-8
let s:server_lib = get(g:, 'chatting_server_lib', expand('~/sources/Chatting/target/Chatting-1.0-SNAPSHOT.jar'))
let s:server_job_id = 0
let s:client_job_id = 0
let s:debug_log = []
let s:server_ip = get(g:, 'chatting_server_ip', '127.0.0.1')
let s:server_port = get(g:, 'chatting_server_port', 2013)
let s:messages = []

function! s:push_message(msg) abort
    if type(a:msg) == type([])
        for m in a:msg
            if !empty(m)
                call add(s:messages, m)
            endif
        endfor
    else
        if !empty(m)
            call add(s:messages, a:msg)
        endif
    endif
endfunction

function! chat#chatting#start() abort
    if s:server_job_id == 0
        call s:log('startting server, server_lib is ' . s:server_lib . '(' . (empty(glob(s:server_lib)) ? 'no such file' : 'file exists' ). ')')
        let s:server_job_id = jobstart(['java', '-cp', s:server_lib, 'com.wsdjeg.chat.Server'],{
                    \ 'on_stdout' : function('s:server_handler'),
                    \ })
    endif
endfunction

function! s:server_handler(id, data, event) abort
endfunction

function! s:client_handler(id, data, event) abort
    if a:event ==# 'stdout'
        call s:push_message(a:data)
        call s:update_msg_screen()
    elseif a:event ==# 'exit'
        call s:log('client exit with code:' . a:data)
        let s:client_job_id = 0
    endif
endfunction

function! s:start_client() abort
    if s:client_job_id == 0
        let s:client_job_id = jobstart(['java', '-cp', s:server_lib, 'com.wsdjeg.chat.Client', s:server_ip, s:server_port],{
                    \ 'on_stdout' : function('s:client_handler'),
                    \ 'on_exit' : function('s:client_handler')
                    \ })
        call s:log('Client startting with server ip(' . s:server_ip . ') port(' . s:server_port . ')')
    endif
endfunction

let s:name = '__Chatting__'
let s:c_base = '>>>'
let s:c_begin = ''
let s:c_char = ''
let s:c_end = ''
let s:msg_win_opened = 0
function! chat#chatting#OpenMsgWin() abort
    call s:start_client()
    if bufwinnr(s:name) < 0
        if bufnr(s:name) != -1
            exe 'silent! botright split ' . '+b' . bufnr(s:name)
        else
            exe 'silent! botright split ' . s:name
        endif
    else
        exec bufwinnr(s:name) . 'wincmd w'
    endif
    call s:windowsinit()
    setl modifiable
    let s:msg_win_opened = 1
    call s:update_msg_screen()
    call s:echon()
    while get(s:, 'quit_chating_win', 0) == 0
        let nr = getchar()
        if nr == 13
            if s:client_job_id != 0
                call jobsend(s:client_job_id, [s:c_begin . s:c_char . s:c_end, ''])
            endif
        let s:c_end = ''
        let s:c_char = ''
        let s:c_begin = ''
        elseif nr ==# "\<Right>" || nr == 6                                     "<Right> 向右移动光标
            let s:c_begin = s:c_begin . s:c_char
            let s:c_char = matchstr(s:c_end, '^.')
            let s:c_end = substitute(s:c_end, '^.', '', 'g')
        elseif nr ==# "\<Left>"  || nr == 2                                     "<Left> 向左移动光标
            if s:c_begin !=# ''
                let s:c_end = s:c_char . s:c_end
                let s:c_char = matchstr(s:c_begin, '.$')
                let s:c_begin = substitute(s:c_begin, '.$', '', 'g')
            endif
        elseif nr ==# "\<Home>" || nr == 1                                     "<Home> 或 <ctrl> + a 将光标移动到行首
            let s:c_end = substitute(s:c_begin . s:c_char . s:c_end, '^.', '', 'g')
            let s:c_char = matchstr(s:c_begin, '^.')
            let s:c_begin = ''
        elseif nr ==# "\<End>"  || nr == 5                                     "<End> 或 <ctrl> + e 将光标移动到行末
            let s:c_begin = s:c_begin . s:c_char . s:c_end
            let s:c_char = ''
            let s:c_end = ''
        elseif nr ==# "\<M-x>"
            let s:quit_chating_win = 1
        elseif nr == 8 || nr ==# "\<bs>"                                        " ctrl+h or <bs> delete last char
            let s:c_begin = substitute(s:c_begin,'.$','','g')
        else
            let s:c_begin .= nr2char(nr)
        endif
        call s:echon()
    endwhile
    setl nomodifiable
    exe 'bd ' . bufnr(s:name)
    let s:quit_chating_win = 0
    let s:msg_win_opened = 0
    normal! :
endfunction

function! s:update_msg_screen() abort
    if s:msg_win_opened
        normal! ggdG
        for msg in s:messages
            call append(line('$'), msg)
        endfor
        normal! gg
        delete
        normal! G
        redraw
        call s:echon()
    endif
endfunction

function! s:echon() abort
    redraw!
    echohl Comment | echon s:c_base
    echohl None | echon s:c_begin
    echohl Wildmenu | echon s:c_char
    echohl None | echon s:c_end
endfunction

fu! s:windowsinit() abort
    " option
    setl fileformat=unix
    setl fileencoding=utf-8
    setl iskeyword=@,48-57,_
    setl noreadonly
    setl buftype=nofile
    setl bufhidden=wipe
    setl noswapfile
    setl nobuflisted
    setl nolist
    setl nonumber
    setl norelativenumber
    setl wrap
    setl winfixwidth
    setl winfixheight
    setl textwidth=0
    setl nospell
    setl nofoldenable
endf

function! s:log(msg) abort
    let time = strftime('%H:%M:%S')
    let msg = '[' . time . '] ' . string(a:msg)
    call add(s:debug_log, msg)
endfunction

function! s:debug() abort
    tabnew
    for line in s:debug_log
        call append(line('$'), line)
    endfor
    nnoremap <buffer><silent> q :bd!<CR>
endfunction

call chat#debug#defind('chatting', function('s:debug'))

