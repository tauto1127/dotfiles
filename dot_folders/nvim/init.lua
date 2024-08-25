---@diagnostic disable: param-type-mismatch
local nocode = vim.g.vscode == nil

require("vim_pluginmanager")

local plugins = {
	"nvim-lua/plenary.nvim",
	{
		"kylechui/nvim-surround",

		config = function()
			require("nvim-surround").setup()
		end,
	},
}

if nocode then
	table.insert(plugins, require("plugins/nvim-treesitter_plugin"))
	table.insert(plugins, "stevearc/dressing.nvim") -- telescopeの検索のui
	table.insert(plugins, "tpope/vim-fugitive")
	table.insert(plugins, "airblade/vim-gitgutter")
	----自動かっこ
	table.insert(plugins, "cohama/lexima.vim")
	table.insert(plugins, require("plugins/copilotchat"))
	table.insert(plugins, require("plugins/trouble_plugin"))
	table.insert(plugins, "kyazdani42/nvim-web-devicons")
	table.insert(plugins, "hrsh7th/nvim-cmp")
	table.insert(plugins, require("theme/tokyonight"))
	table.insert(plugins, {
		"lervag/vimtex",
		lazy = false,
		tag = "v2.15",
		init = function()
			vim.g.vimtex_view_method = "skim"
		end,
	})
	table.insert(plugins, "mfussenegger/nvim-dap")
	table.insert(plugins, require("plugins/telescope_plugin"))
	table.insert(plugins, require("plugins/nvim-tree_nvim"))
	table.insert(plugins, require("plugins/alpha-nvim_plugin"))
	table.insert(plugins, require("plugins/toggleterm_plugin"))
	table.insert(plugins, require("plugins/nvim-lsp-file-operations_plugin"))
	table.insert(plugins, "christoomey/vim-tmux-navigator")
	table.insert(plugins, require("plugins/flutter-tools_plugin"))
	table.insert(plugins, require("plugins/bufferline_plugin"))
	table.insert(plugins, require("plugins/markdown-preview_plugin"))
	----discord presense
	table.insert(plugins, require("plugins/discord_presense"))
	table.insert(plugins, require("plugins/copilot"))
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
	table.insert(plugins, require("plugins/lualine_plugin"))
	table.insert(plugins, require("plugins/obsidian_nvim"))
end

require("lazy").setup(plugins)

if nocode then
	require("linter_formatter")
	require("plugins/lsp-cmp-mason")
	require("vim_commands")
	require("vim_options")
	require("vim_functions")
	require("vim_keymap")
else
end
