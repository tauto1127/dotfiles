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
	"mfussenegger/nvim-dap",
	"stevearc/dressing.nvim", -- telescopeの検索のui
	"kyazdani42/nvim-web-devicons", --アイコンたち
	"tpope/vim-fugitive",
	"airblade/vim-gitgutter",
	"cohama/lexima.vim",
	"kylechui/nvim-surround",
	"nvim-telescope/telescope.nvim",
	"hrsh7th/nvim-cmp",
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
	},
}

if nocode then
	--table.insert(plugins, 'neoclide/coc.nvim')
	table.insert(plugins, {
		"lervag/vimtex",
		lazy = false,
		tag = "v2.15",
		init = function()
			vim.g.vimtex_view_method = "skim"
		end,
	})
	table.insert(plugins, "nvim-tree/nvim-tree.lua")
	table.insert(plugins, require("alpha-nvim_plugin"))
	table.insert(plugins, require("toggleterm_plugin"))
	table.insert(plugins, require("nvim-lsp-file-operations_plugin"))
	table.insert(plugins, "christoomey/vim-tmux-navigator")
	table.insert(plugins, require("flutter-tools_plugin"))
	table.insert(plugins, "akinsho/bufferline.nvim")
	table.insert(plugins, {
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	})
	--discord presense
	table.insert(plugins, {
		"andweeb/presence.nvim",
	})
	table.insert(plugins, "github/copilot.vim")
	table.insert(plugins, {
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		opts = {
			debug = true, -- Enable debugging
			-- See Configuration section for rest
		},
		prompts = {
			Explain = {
				prompt = "/COPILOT_EXPLAIN 日本語でカーソル上のコードの説明を段落をつけて書いてください。",
			},
			Tests = {
				prompt = "/COPILOT_TESTS カーソル上のコードの詳細な単体テスト関数を書いてください。",
			},
			Fix = {
				prompt = "/COPILOT_FIX このコードには問題があります。バグを修正したコードに書き換えてください。",
			},
			Optimize = {
				prompt = "/COPILOT_REFACTOR 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。",
			},
			Docs = {
				prompt = "/COPILOT_REFACTOR 選択したコードのドキュメントを書いてください。ドキュメントをコメントとして追加した元のコードを含むコードブロックで回答してください。使用するプログラミング言語に最も適したドキュメントスタイルを使用してください（例：JavaScriptのJSDoc、Pythonのdocstringsなど）",
			},
			--FixDiagnostic = {
			--	prompt = 'ファイル内の次のような診断上の問題を解決してください：',
			--	selection = select.diagnostics,
			--}
		},
		-- See Commands section for default commands if you want to lazy load on them
	})
	table.insert(plugins, {
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	})
	table.insert(plugins, "nvim-treesitter/nvim-treesitter")
	table.insert(plugins, {
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "CFLAGS=-march=native make",
		lazy = true,
	})

	--tab
	--table.insert(plugins, {
	--	"romgrk/barbar.nvim",
	--	dependencies = {
	--		"lewis6991/gitsigns.nvim",
	--		"nvim-tree/nvim-web-devicons",
	--	},
	--	init = function()
	--		vim.g.barbar_auto_setup = false
	--	end,
	--	opts = {},
	--})
	-- buffer
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
	table.insert(plugins, {
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	})
end

require("lazy").setup(plugins)

if nocode then
	local Terminal = require("toggleterm.terminal").Terminal

	require("bufferline").setup({
		options = {
			mode = "buffers",
			diagnostics = "nvim_lsp",
			always_show_bufferline = true,
			numbers = "buffer_id",
		},
	})
	-- Flutterログ用のtoggletermインスタンスを作成
	local flutter_term = Terminal:new({
		cmd = "",
		hidden = true,
		direction = "horizontal",
		size = 15,
		on_open = function(term)
			vim.cmd("startinsert!")
			vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
		end,
	})

	-- dev_logの設定
	local dev_log = {
		enabled = true,
		open_cmd = "tabedit",
	}

	--	require("flutter-tools").setup({
	--		dev_tools = {
	--			autostart = true,
	--			autoopen = "devtools",
	--			autoopen_browser = true,
	--		},
	--		fvm = true,
	--		lsp = {
	--			settings = {
	--				--//https://dartcode.org/docs/settings/
	--				lineLength = (function()
	--					--- ref: https://github.com/akinsho/flutter-tools.nvim/issues/178
	--					if vim.fn.expand("%:p"):find("^/Users/takuto/Code/Dart/Hakondate/") then
	--						echo("hakondateだあ")
	--						return 140
	--					end
	--					return vim.fn.expand("%:p"):find("^/Users/takuto/Code/Dart/Hakondate/") and 140 or 80
	--				end)(),
	--				widgetGuides = false,
	--				showTodos = true,
	--				completeFunctionCalls = true,
	--				analysisExcludedFolders = {
	--					vim.fn.expand("$HOME/.pub-cache"),
	--					vim.fn.expand("$HOME/fvm"),
	--				},
	--			},
	--		},
	--	})
	require("telescope").load_extension("flutter")
	require("presence").setup({
		debounce_timeout = 5,
		blacklist = {
			"*.md",
			"README.md",
			"main",
		},
	})
	require("telescope").setup({

		defaults = {
			file_ignore_patterns = {
				"^.git/",
				"^.cache/",
			},
		},
		extensions = {
			fzf = {
				fuzzy = true,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "smart_case",
			},
		},
	})
	require("telescope").load_extension("fzf")

	--lspの設定
	local cmp = require("cmp")

	cmp.setup({
		mapping = cmp.mapping.preset.insert({
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-p>"] = cmp.mapping.select_prev_item(),
			["<C-n>"] = cmp.mapping.select_next_item(),
			["<C-y>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ select = true }),
		}),
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		--completion = {
		--	autocomplete = true,
		--},
		experimental = {
			ghost_text = true,
		},
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
		}, {
			{ name = "buffer" },
		}),
	})
	require("mason").setup()
	require("mason-lspconfig").setup({
		ensure_installed = {
			"lua_ls",
		},
	})

	require("lualine").setup()

	require("lspconfig").lua_ls.setup({
		settigns = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
			},
		},
	})
	require("lspconfig").csharp_ls.setup({})
	--require("lspconfig").dartls.setup({
	--	init_options = {
	--		closingLabels = true,
	--		outline = true,
	--		flutterOutline = true,
	--		onlyAnalyzeProjectsWithOpenFiles = false,
	--		completeFunctionCalls = true,
	--		suggestFromUnimportedLibraries = true,
	--	},
	--})

	local null_ls = require("null-ls")
	null_ls.setup({
		diagnostics_format = "[#{m}] #{s} (#{c})",
		sources = {
			--ここでlinterとフォーマッターを設定する
			null_ls.builtins.formatting.stylua,
			--null_ls.builtins.diagnostics.luacheck,
			null_ls.builtins.formatting.clang_format,

			null_ls.builtins.formatting.shfmt,
			--null_ls.builtins.diagnostics.shellcheck,
			--null_ls.builtins.code_actions.shellcheck,
			null_ls.builtins.formatting.prettier,

			null_ls.builtins.formatting.dart_format,
		},
		-- you can reuse a shared lspconfig on_attach callback here
		on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
						-- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
						vim.lsp.buf.format({ bufnr = bufnr })
					end,
				})
			end
		end,
	})
	require("obsidian").setup({
		--Obsidianの設定
		workspaces = {
			{
				name = "main",
				path = "/Users/takuto/Library/Mobile Documents/iCloud~md~obsidian/Documents/main",
			},
		},
		daily_notes = {
			folder = "extend/DairyNote",
			template = "extend/template/DairyNote/DairyNoteTemplate.md",
		},
		completion = {
			nvim_cmp = true,
			min_chars = 2,
		},
		mappings = {
			-- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			-- Toggle check-boxes.
			["<leader>ch"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
			-- Smart action depending on context, either follow link or toggle checkbox.
			["<cr>"] = {
				action = function()
					return require("obsidian").util.smart_action()
				end,
				opts = { buffer = true, expr = true },
			},
		},
		-- Optional, customize how note file names are generated given the ID, target directory, and title.
		---@param spec { id: string, dir: obsidian.Path, title: string|?  }
		---@return string|obsidian.Path The full path to the new note.
		note_path_func = function(spec)
			-- This is equivalent to the default behavior.
			local path = spec.dir / tostring(spec.title)
			return path:with_suffix(".md")
		end,
		new_notes_location = "current_dir",
		-- Optional, alternatively you can customize the frontmatter data.
		---@return table
		note_frontmatter_func = function(note)
			-- Add the title of the note as an alias.
			if note.title then
				note:add_alias(note.title)
			end
			local d = os.date("*t")

			local out = {
				id = note.id,
				aliases = note.aliases,
				tags = note.tags,
				created = d["year"] .. "-" .. d["month"] .. "-" .. d["day"] .. " " .. d["hour"] .. ":" .. d["min"],
			}

			-- `note.metadata` contains any manually added fields in the frontmatter.
			-- So here we just make sure those fields are kept in the frontmatter.
			if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
				for k, v in pairs(note.metadata) do
					out[k] = v
				end
			end

			return out
		end,
		templates = {
			folder = "extend/template",
		},
		picker = {
			name = "telescope.nvim",
			mappings = {
				new = "<C-x>",
				insert_link = "<C-l>",
			},
		},
		sort_by = "modified",
		sort_reversed = true,
		-- Optional, boolean or a function that takes a filename and returns a boolean.
		-- `true` indicates that you don't want obsidian.nvim to manage frontmatter.
		disable_frontmatter = false,
		-- Specify how to handle attachments.
		attachments = {
			-- The default folder to place images in via `:ObsidianPasteImg`.
			-- If this is a relative path it will be interpreted as relative to the vault root.
			-- You can always override this per image by passing a full path to the command instead of just a filenameextend/files.
			img_folder = "extend/files", -- This is the default
			-- A function that determines the text to insert in the note when pasting an image.
			-- It takes two arguments, the `obsidian.Client` and an `obsidian.Path` to the image file.
			-- This is the default implementation.
			---@param client obsidian.Client
			---@param path obsidian.Path the absolute path to the image file
			---@return string
			img_text_func = function(client, path)
				path = client:vault_relative_path(path) or path
				return string.format("![%s](%s)", path.name, path)
			end,
		},
	})

	require("nvim-treesitter.configs").setup({
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
	})

	--require('coc_plugin')
	require("nvim-tree").setup({ -- BEGIN_DEFAULT_OPTS
		on_attach = "default",
		hijack_cursor = false,
		auto_reload_on_write = true,
		disable_netrw = false,
		hijack_netrw = true,
		hijack_unnamed_buffer_when_opening = false,
		root_dirs = {},
		prefer_startup_root = false,
		sync_root_with_cwd = false,
		reload_on_bufenter = false,
		respect_buf_cwd = false,
		select_prompts = false,
		sort = {
			sorter = "name",
			folders_first = true,
			files_first = false,
		},
		view = {
			centralize_selection = false,
			cursorline = true,
			debounce_delay = 15,
			side = "left",
			preserve_window_proportions = false,
			number = false,
			relativenumber = false,
			signcolumn = "yes",
			width = 30,
			float = {
				enable = false,
				quit_on_focus_loss = true,
				open_win_config = {
					relative = "editor",
					border = "rounded",
					width = 30,
					height = 30,
					row = 1,
					col = 1,
				},
			},
		},
		renderer = {
			add_trailing = false,
			group_empty = false,
			full_name = false,
			root_folder_label = ":~:s?$?/..?",
			indent_width = 2,
			special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
			symlink_destination = true,
			highlight_git = true,
			highlight_diagnostics = true,
			highlight_opened_files = "none",
			highlight_modified = "none",
			highlight_bookmarks = "none",
			highlight_clipboard = "name",
			indent_markers = {
				enable = false,
				inline_arrows = true,
				icons = {
					corner = "└",
					edge = "│",
					item = "│",
					bottom = "─",
					none = " ",
				},
			},
			icons = {
				web_devicons = {
					file = {
						enable = true,
						color = true,
					},
					folder = {
						enable = false,
						color = true,
					},
				},
				git_placement = "before",
				modified_placement = "after",
				diagnostics_placement = "signcolumn",
				bookmarks_placement = "signcolumn",
				padding = " ",
				symlink_arrow = " ➛ ",
				show = {
					file = true,
					folder = true,
					folder_arrow = true,
					git = true,
					modified = true,
					diagnostics = true,
					bookmarks = true,
				},
				glyphs = {
					default = "",
					symlink = "",
					bookmark = "󰆤",
					modified = "●",
					folder = {
						arrow_closed = "",
						arrow_open = "",
						default = "",
						open = "",
						empty = "",
						empty_open = "",
						symlink = "",
						symlink_open = "",
					},
					git = {
						unstaged = "✗",
						staged = "✓",
						unmerged = "",
						renamed = "➜",
						untracked = "★",
						deleted = "",
						ignored = "◌",
					},
				},
			},
		},
		hijack_directories = {
			enable = true,
			auto_open = true,
		},
		update_focused_file = {
			enable = false,
			update_root = false,
			ignore_list = {},
		},
		system_open = {
			cmd = "",
			args = {},
		},
		git = {
			enable = true,
			show_on_dirs = true,
			show_on_open_dirs = true,
			disable_for_dirs = {},
			timeout = 400,
			cygwin_support = false,
		},
		diagnostics = {
			enable = true,
			show_on_dirs = true,
			show_on_open_dirs = true,
			debounce_delay = 50,
			severity = {
				min = vim.diagnostic.severity.HINT,
				max = vim.diagnostic.severity.ERROR,
			},
			icons = {
				hint = "",
				info = "",
				warning = "",
				error = "",
			},
		},
		modified = {
			enable = false,
			show_on_dirs = true,
			show_on_open_dirs = true,
		},
		filters = {
			git_ignored = true,
			dotfiles = false,
			git_clean = false,
			no_buffer = false,
			no_bookmark = false,
			custom = {},
			exclude = {},
		},
		live_filter = {
			prefix = "[FILTER]: ",
			always_show_folders = true,
		},
		filesystem_watchers = {
			enable = true,
			debounce_delay = 50,
			ignore_dirs = {},
		},
		actions = {
			use_system_clipboard = true,
			change_dir = {
				enable = true,
				global = false,
				restrict_above_cwd = false,
			},
			expand_all = {
				max_folder_discovery = 300,
				exclude = {},
			},
			file_popup = {
				open_win_config = {
					col = 1,
					row = 1,
					relative = "cursor",
					border = "shadow",
					style = "minimal",
				},
			},
			open_file = {
				quit_on_open = false,
				eject = true,
				resize_window = true,
				window_picker = {
					enable = true,
					picker = "default",
					chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
					exclude = {
						filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
						buftype = { "nofile", "terminal", "help" },
					},
				},
			},
			remove_file = {
				close_window = true,
			},
		},
		trash = {
			cmd = "gio trash",
		},
		tab = {
			sync = {
				open = true, --？？
				close = false,
				ignore = {},
			},
		},
		notify = {
			threshold = vim.log.levels.INFO,
			absolute_path = true,
		},
		help = {
			sort_by = "key",
		},
		ui = {
			confirm = {
				remove = true,
				trash = true,
				default_yes = false,
			},
		},
		experimental = {},
		log = {
			enable = false,
			truncate = false,
			types = {
				all = false,
				config = false,
				copy_paste = false,
				dev = false,
				diagnostics = false,
				git = false,
				profile = false,
				watcher = false,
			},
		},
	}) -- END_DEFAULT_OPTS
else
	require("nvim-surround").setup()
end

if nocode then
	--nvim bufferline

	--vim.nnoremap <C-t> :NvimTreeToggle <CR>
	--crで囲むとコマンドとして認識される
	--silentをオンにすると，エラーなどが表示されなくなる
	vim.api.nvim_set_keymap("n", "<C-t>", "<cmd>NvimTreeToggle<cr>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("t", "fj", "<C-\\><C-n>", { noremap = true, silent = true })
	--telescope vscodeのようなファイル探索
	vim.api.nvim_set_keymap(
		"n",
		"<leader>ff",
		"<cmd>Telescope find_files hidden=true<cr>",
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap(
		"n",
		"<leader>fl",
		"<cmd>Telescope live_grep hidden=true<cr>",
		{ noremap = true, silent = true }
	)
	vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "to", ":ToggleTerm<cr>", { noremap = true, silent = true }) --:TogglTerm<cr>
	--タブを閉じる
	vim.api.nvim_set_keymap("n", "<C-x>", ":tabclose<cr>", { noremap = true, silent = true })
	vim.api.nvim_command(
		'command! -nargs=0 DartFormat lua vim.api.nvim_command("silent !dart format -l 120 " .. vim.fn.expand("%"))'
	)
	vim.api.nvim_command('command! -nargs=0 Today lua vim.cmd("ObsidianToday")')
	vim.api.nvim_command('command! -nargs=0 Yesterday lua vim.cmd("ObsidianYesterday")')
	vim.api.nvim_command("command! -nargs=0 Chat lua chat.open()")
	-- <C-w> 系を Vim Tmux Navigator に移譲する
	vim.api.nvim_set_keymap("n", "<C-w>h", "<cmd>TmuxNavigateLeft<cr>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<C-w>j", "<cmd>TmuxNavigateDown<cr>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<C-w>k", "<cmd>TmuxNavigateUp<cr>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<C-w>l", "<cmd>TmuxNavigateRight<cr>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<C-w>\\", "<cmd>TmuxNavigatePrevious<cr>", { noremap = true, silent = true })

	--タブ切り替え(barbar)
	--bufferNext
	vim.api.nvim_set_keymap("n", "<C-n>", ":BufferNext<cr>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "<C-p>", ":BufferPrevious<cr>", { noremap = true, silent = true })

	-- lspのキー配置
	-- -- 2. build-in LSP function
	-- keyboard shortcut
	vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
	vim.keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.formatting()<CR>")
	vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
	vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
	vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
	vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
	vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
	vim.keymap.set("n", "gn", "<cmd>lua vim.lsp.buf.rename()<CR>")
	vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
	vim.keymap.set("n", "ge", "<cmd>lua vim.diagnostic.open_float()<CR>")
	vim.keymap.set("n", "g]", "<cmd>lua vim.diagnostic.goto_next()<CR>")
	vim.keymap.set("n", "g[", "<cmd>lua vim.diagnostic.goto_prev()<CR>")

	vim.keymap.set("n", "<leader>fc", "<cmd>Telescope flutter commands<CR>")
	vim.keymap.set("n", "<leader>g", "<cmd>Telescope commands<CR>")

	vim.keymap.set("n", "gf", function()
		if require("obsidian").util.cursor_on_markdown_link() then
			return "<cmd>ObsidianFollowLink<CR>"
		else
			return "gf"
		end
	end, { noremap = false, expr = true })
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

	vim.api.nvim_set_keymap("n", "<leader> lg", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })
end
-- バッファの内容全体を使って Copilot とチャットする
function CopilotChatBuffer()
	local input = vim.fn.input("Quick Chat: ")
	if input ~= "" then
		require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
	end
end

vim.api.nvim_set_keymap("n", "ff", "<ESC>", { noremap = true, silent = true })

vim.o.clipboard = vim.o.clipboard .. "unnamedplus"
--インデント
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.smartindent = true

--conceallevel
--obsidian-nvimで指定された
vim.opt.conceallevel = 1

--オートコンプリート系
vim.o.completeopt = "menuone,noinsert"

-- terminalモードから抜けるためのキー設定
vim.api.nvim_set_keymap("t", "<C-]>", "<C-\\><C-n>", { noremap = true })

vim.api.nvim_set_keymap("n", "<C-n>", "<cmd>bnext<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-p>", "<cmd>bprevious<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-q>", "<cmd>b#<cr><cmd>bd#<cr>", { noremap = true })

--vim.api.nvim_create_user_command(
--  'Hello',
--  function(opts)
--    print("Hello, world!")
--  end,
--  {
--	nargs = 0,
--	complete = function(_,_,_)
--		return complete_list
--	end
--}
--)
---- キーマッピング
-- <leader>ccp (Copilot Chat Prompt の略) でアクションプロンプトを表示する
-- copilotのキー
-- telescope を使ってアクションプロンプトを表示する
function ShowCopilotChatActionPrompt()
	local actions = require("CopilotChat.actions")
	require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
end

vim.api.nvim_set_keymap(
	"n",
	"<leader>ccp",
	"<cmd>lua ShowCopilotChatActionPrompt()<cr>",
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap("n", "<leader>ccb", "<cmd>lua copilotChatBuffer()<cr>", { noremap = true, silent = true })
