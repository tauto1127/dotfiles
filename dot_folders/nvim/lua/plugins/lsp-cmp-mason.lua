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
require("lspconfig").eslint.setup({})
require("lspconfig").csharp_ls.setup({})
require("lspconfig").tsserver.setup({})
require("lspconfig").lua_ls.setup({
	settigns = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})
--require("lua.lsp-cmp-mason")
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
	},
})
