let s:server_lib = get(g:, 'chatting_server_lib', expand('~/sources/Chatting/target/Chatting-1.0-SNAPSHOT.jar'))
let s:server_job_id = 0
let s:client_job_id = 0
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
    else
        echon a:data
    endif
endfunction

function! chat#chatting#login(name, pw) abort
    if s:client_job_id == 0
        let s:client_job_id = jobstart(['java', '-cp', s:server_lib, 'com.wsdjeg.chat.Client', s:server_ip, s:server_port],{
                    \ 'on_stdout' : function('s:client_handler')
                    \ })
    endif
endfunction

let s:name = '__Chatting__'
let s:c_base = '>>>'
let s:c_begin = ''
let s:c_char = ''
let s:c_end = ''
let s:msg_win_opened = 0
function! chat#chatting#OpenMsgWin() abort
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
    call s:echon()
    let s:msg_win_opened = 1
    while get(g:, 'quit_chating_win', 0) == 0
        let nr = getchar()
        if nr == 13
            call jobsend(s:client_job_id, [s:c_begin . s:c_char . s:c_end, ''])
	    let s:c_end = ''
	    let s:c_char = ''
	    let s:c_begin = ''
        elseif nr ==# "\<M-x>"
            let g:quit_chating_win = 1
        else
            let s:c_begin .= nr2char(nr)
        endif
        call s:echon()
    endwhile
    setl nomodifiable
    exe 'bd ' . bufnr(s:name)
    let s:quit_qq_win = 0
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
    endif
    redraw
    call s:echon()
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

function! Test(str) abort
    exe a:str
endfunction
