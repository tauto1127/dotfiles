vim.o.clipboard = vim.o.clipboard .. "unnamedplus"
--インデント
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

--conceallevel
--obsidian-nvimで指定された
vim.opt.conceallevel = 1
-- 自動でウィンドウサイズが変わらないようにする
vim.o.equalalways = false
vim.o.eadirection = "hor"

--オートコンプリート系
vim.o.completeopt = "menuone,noinsert"
vim.cmd([[colorscheme tokyonight]])

--colorscheme
vim.g.termguicolors = true
-- leaderキー設定
vim.g.mapleader = " "
