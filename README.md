# vim-chat
chat in neovim and vim8


# Install
2. Install current plugin.
```viml
call dein#add('wsdjeg/vim-chat')
```
now you can chatting with me by `call chat#chatting#OpenMsgWin()`, insert `/help` for help message;

# Other chatting programs

QQ 和微信的支持需要安装额外的包，包括 [mojo-webqq](https://github.com/sjdy521/Mojo-Webqq) 和 [mojo-weixin](https://github.com/sjdy521/Mojo-Weixin)
此外，还需要安装 irssi，这是一个 irc 聊天工具; feh 这是一个浏览图片的工具。首先启动 QQ 服务器 `call chat#qq#start()`, 然后会自动弹出一个二维码，手机扫描下就可以登录了。neovim 默认使用 `Alt + x` 打开/关闭聊天窗口。

![Markdown](http://i2.kiimg.com/1949/c18404d7afdc7f3a.gif)
