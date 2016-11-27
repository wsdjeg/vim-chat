# vim-chat
chat in neovim and vim8, for vim8 support you need install [job.vim](https://github.com/wsdjeg/job.vim)


# Install
1. Install [mojo-webqq](https://github.com/sjdy521/Mojo-Webqq) and [mojo-weixin](https://github.com/sjdy521/Mojo-Weixin)
2. Install current plugin.
```viml
call dein#add('wsdjeg/vim-chat')
```

# support
- weixin and qq

![qq](https://raw.githubusercontent.com/wsdjeg/DotFiles/master/pic/Vim-QQ.png)

- Chatting

now you can chat with me, just need add this to your vimrc; download [chatting.jar](https://github.com/wsdjeg/Chatting/files/603505/Chatting.zip)

```viml
let g:chatting_server_lib = '/path/to/Chatting-1.0.jar'
let g:chatting_server_ip = 'wsdjeg.oicp.net'
let g:chatting_server_port = 1023
call dein#add('wsdjeg/vim-chat')
```
