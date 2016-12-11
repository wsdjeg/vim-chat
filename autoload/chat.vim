function! chat#startServer(name) abort

endfunction

function! chat#openWin(...) abort
    if a:0 == 0
        call  chat#chatting#OpenMsgWin()   
    elseif a:1 ==# 'qq'
    elseif a:1 ==# 'weixin'
    endif
endfunction
