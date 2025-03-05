# vim-chat

The chatting client for vim and neovim.

![vim-chat](https://img.spacevim.org/166140007-d11d5e92-b32d-414f-b56b-64e28d03fd0e.png)

<!-- vim-markdown-toc GFM -->

* [Installation](#installation)

<!-- vim-markdown-toc -->

## Installation

With [nvim-plug](https://github.com/wsdjeg/nvim-plug)

```lua
require("plug").add({
	{
		"wsdjeg/vim-chat",
		config = function()
			vim.keymap.set("n", "<leader>h", "<cmd>call chat#windows#open()<cr>", { silent = true })
		end,
	},
})
```
