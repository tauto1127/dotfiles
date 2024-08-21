local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local nocode = vim.g.vscode == nil
vim.g.mapleader = " "

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

local plugins = {
	"nvim-lua/plenary.nvim",
	--{
	--	"nvim-treesitter/nvim-treesitter",
	--	dependencies = {
	--		{ "nvim-lua/plenary.nvim" },
	--	}
	--},
	"stevearc/dressing.nvim", -- telescopeの検索のui
	"tpope/vim-fugitive",
	"airblade/vim-gitgutter",
	----自動かっこ
	"cohama/lexima.vim",
	"kylechui/nvim-surround",
}

if nocode then
	--table.insert(plugins, {
	--	"nvim-treesitter/nvim-treesitter",
	--	build = ":TSUpdate",
	--	config = function()
	--		local configs = require("nvim-treesitter.configs")
	--		configs.setup({
	--			ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
	--			sync_install = false,
	--			highlight = { enable = true },
	--			indent = { enable = true },
	--			auto_install = true,
	--			ignore_install = { "javascript" },
	--			highlight = {
	--				enable = true,
	--				disable = function(lang, buf)
	--					local max_filesize = 100 * 1024 -- 100 KB
	--					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
	--					if ok and stats and stats.size > max_filesize then
	--						return true
	--					end
	--				end,
	--			},
	--		})
	--	end,
	--})

	table.insert(plugins, require("copilotchat"))
	table.insert(plugins, "kyazdani42/nvim-web-devicons")
	table.insert(plugins, "hrsh7th/nvim-cmp")
	table.insert(plugins, {
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	})
	table.insert(plugins, {
		"lervag/vimtex",
		lazy = false,
		tag = "v2.15",
		init = function()
			vim.g.vimtex_view_method = "skim"
		end,
	})
	table.insert(plugins, "mfussenegger/nvim-dap")
	table.insert(plugins, require("telescope_plugin"))
	table.insert(plugins, require("nvim-tree_nvim"))
	table.insert(plugins, require("alpha-nvim_plugin"))
	table.insert(plugins, require("toggleterm_plugin"))
	table.insert(plugins, require("nvim-lsp-file-operations_plugin"))
	table.insert(plugins, "christoomey/vim-tmux-navigator")
	table.insert(plugins, require("flutter-tools_plugin"))
	table.insert(plugins, {
		"akinsho/bufferline.nvim",
		config = function()
			options = {
				mode = "buffers",
				diagnostics = "nvim_lsp",
				always_show_bufferline = true,
				numbers = "buffer_id",
			}
		end,
	})
	table.insert(plugins, {
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	})
	----discord presense
	table.insert(plugins, require("discord_presense"))
	table.insert(plugins, "github/copilot.vim")
	table.insert(plugins, {
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "CFLAGS=-march=native make",
		lazy = true,
	})
	table.insert(plugins, "jeetsukumaran/vim-buffergator")
	-- lsp系
	table.insert(plugins, "neovim/nvim-lspconfig")
	table.insert(plugins, "williamboman/mason.nvim")
	table.insert(plugins, "williamboman/mason-lspconfig.nvim")
	table.insert(plugins, "nvimtools/none-ls.nvim")
	table.insert(plugins, "hrsh7th/cmp-nvim-lsp")
	table.insert(plugins, "hrsh7th/cmp-buffer")
	table.insert(plugins, "hrsh7th/cmp-path")
	table.insert(plugins, "hrsh7th/cmp-cmdline")

	-- statusばーのプラグイン
	table.insert(plugins, {
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	})
	table.insert(plugins, require("obsidian_nvim"))
end

require("lazy").setup(plugins)

if nocode then
	require("lualine").setup()

	require("linter_formatter")
	require("lsp-cmp-mason")
else
	require("nvim-surround").setup()
end

if nocode then
	--colorscheme
	vim.cmd([[colorscheme tokyonight]])
	local Terminal = require("toggleterm.terminal").Terminal
	local lazygit = Terminal:new({
		cmd = "lazygit",
		direction = "float",
		hidden = true,
	})

	vim.g.termguicolors = true

	function _lazygit_toggle()
		lazygit:toggle()
	end

	require("vim_options")
	require("functions")
	require("keymap")
end
