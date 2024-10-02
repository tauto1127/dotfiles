vim.o.clipboard = vim.o.clipboard .. "unnamedplus"
--インデント
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- ターミナルのタイトルを設定
--vim.opt.titlestring = [[%f %h%m%r%w %{v:progname} (%{tabpagenr()} of %{tabpagenr('$')})]]
vim.o.title = true
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function()
    vim.o.titlestring = vim.fn.expand("%:t") .. " - NVIM"
  end,
})

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
