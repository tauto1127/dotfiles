local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	'nvim-lua/plenary.nvim',
	'nvim-telescope/telescope.nvim',
	'mfussenegger/nvim-dap',
	'stevearc/dressing.nvim', -- telescopeの検索のui
	'nvim-treesitter/nvim-treesitter',
	'kyazdani42/nvim-web-devicons', --アイコンたち
	'neoclide/coc.nvim', 
	-- https://github.com/nvim-tree/nvim-tree.lua
	'nvim-tree/nvim-tree.lua',
	'akinsho/flutter-tools.nvim',
	'akinsho/toggleterm.nvim',
	require('alpha-nvim_plugin'),
})

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript" },
  highlight = {
    enable = true,
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,
  },
}

require('coc_plugin')
require("nvim-tree").setup()

--vim.nnoremap <C-t> :NvimTreeToggle <CR>
--crで囲むとコマンドとして認識される
--silentをオンにすると，エラーなどが表示されなくなる
vim.api.nvim_set_keymap('n', '<C-t>', ':NvimTreeToggle<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', 'fj', '<C-\\><C-n>', { noremap = true, silent = true })
--telescope vscodeのようなファイル探索
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files hidden=true<cr>', {noremap = true, silent=true})

vim.o.clipboard = vim.o.clipboard .. 'unnamedplus'

