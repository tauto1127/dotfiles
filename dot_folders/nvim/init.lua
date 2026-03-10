---@diagnostic disable: param-type-mismatch
if vim.fn.executable("pbcopy") == 0 then
  vim.g.clipboard = "osc52"
end

local nocode = vim.g.vscode == nil
if not nocode then
  vim.g.vscode = true
end

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
  -- no-neck 中央に寄せるやつテキストを
  table.insert(plugins, require("plugins/no-neck-pain"))
  -- remote developemnt
  table.insert(plugins, require("plugins/remote-dev"))
  -- devcontainer
  table.insert(plugins, require("plugins/devcontainer"))
  -- remoteのファイルを編集できるらしい
  -- table.insert(plugins, require("plugins/distant"))
  --
  -- diffview
  table.insert(plugins, require("plugins/diff-view-nvim"))
  -- いい感じのoutline表示するやつ
  table.insert(plugins, require("plugins/aerial"))
  table.insert(plugins, require("plugins/nvim-treesitter_plugin"))
  -- telescopeの検索のui
  table.insert(plugins, "stevearc/dressing.nvim")
  -- buffer manager 最強
  table.insert(plugins, require("plugins/buffer_manager-nvim"))
  -- いい感じにウィンドウ？サイズを変更してくれるやつ
  -- table.insert(plugins, require("plugins/focus-nvim"))
  -- table.insert(plugins, "tpope/vim-fugitive")
  table.insert(plugins, "airblade/vim-gitgutter")
  -- HTMLのタグを自動で閉じてくれるやつ
  table.insert(plugins, require("plugins/nvim-ts-autotag"))
  ----自動かっこ
  table.insert(plugins, "cohama/lexima.vim")
  table.insert(plugins, "akinsho/git-conflict.nvim")
  table.insert(plugins, require("plugins/oil"))
  table.insert(plugins, require("plugins/copilotchat"))
  table.insert(plugins, require("plugins/trouble_plugin"))
  table.insert(plugins, "kyazdani42/nvim-web-devicons")
  table.insert(plugins, "hrsh7th/nvim-cmp")
  table.insert(plugins, require("plugins/copilot-cmp"))
  table.insert(plugins, require("theme/tokyonight"))
  -- table.insert(plugins, require("plugins/avante"))
  table.insert(plugins, require("plugins/code-companion"))

  table.insert(plugins, {
    "lervag/vimtex",
    lazy = false,
    tag = "v2.15",
    init = function()
      vim.g.vimtex_view_method = "skim"
    end,
  })
  -- editor(整理してない)
  table.insert(plugins, {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {},
  })
  table.insert(plugins, require("plugins/hop-nvim"))
  table.insert(plugins, require("plugins/indent-blankline-nvim"))
  table.insert(plugins, require("plugins/nvim-dap"))
  table.insert(plugins, require("plugins/telescope_plugin"))
  table.insert(plugins, require("plugins/nvim-tree_nvim"))
  table.insert(plugins, require("plugins/alpha-nvim_plugin"))
  table.insert(plugins, require("plugins/toggleterm_plugin"))
  table.insert(plugins, require("plugins/nvim-lsp-file-operations_plugin"))
  table.insert(plugins, "christoomey/vim-tmux-navigator")
  table.insert(plugins, require("plugins/flutter-tools_plugin"))
  table.insert(plugins, require("plugins/bufferline_plugin"))
  table.insert(plugins, require("plugins/markdown-preview_plugin"))
  table.insert(plugins, require("plugins/octo-nvim"))
  ----discord presense
  table.insert(plugins, require("plugins/discord_presense"))
  table.insert(plugins, require("plugins/copilot"))
  table.insert(plugins, {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "CFLAGS=-march=native make",
    lazy = true,
  })
  table.insert(plugins, require("plugins/csharp_lsp_plugin"))
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

  -- キーバインディングを教えてくれるプラグイン
  table.insert(plugins, require("plugins/which-key"))
  -- statusばーのプラグイン
  table.insert(plugins, require("plugins/lualine_plugin"))
  -- aibo(codex wrapperぷらぐいん)
  table.insert(plugins, require("plugins/aibo-nvim"))
end

require("lazy").setup(plugins)


if nocode then
  -- copilotでmarkdownを使う
  vim.g.copilot_filetypes = { markdown = true }
  require("linter_formatter")
  require("plugins/lsp-cmp-mason")
  require("vim_commands")
  require("vim_options")
  require("vim_functions")
  require("vim_keymap")
else
end
