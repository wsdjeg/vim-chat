let s:server_lib = '/home/wsdjeg/sources/Chatting/target/Chatting-1.0-SNAPSHOT.jar'
let s:server_job_id = 0
let s:client_job_id = 0
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
    endif
endfunction

function! chat#chatting#login(name, pw) abort
    if s:client_job_id == 0
        let s:client_job_id = jobstart(['java', '-cp', s:server_lib, 'com.wsdjeg.chat.Client'],{
                    \ 'on_stdout' : function('s:client_handler')
                    \ })
    endif
endfunction

function! Test(str) abort
    exe a:str
endfunction
