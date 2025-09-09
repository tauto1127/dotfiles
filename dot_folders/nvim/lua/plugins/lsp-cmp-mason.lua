--lspの設定
local cmp = require("cmp")
local lspconfig = require("lspconfig")

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local on_attach = function() end

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
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "copilot" },
  },
})

require("lspconfig").eslint.setup({})
-- require("lspconfig").csharp_ls.setup({ capabilities = capabilities })
require("lspconfig").ts_ls.setup({})
require("lspconfig").docker_compose_language_service.setup({})
require("lspconfig").dockerls.setup({})
require("lspconfig").pylsp.setup({})
require("lspconfig").gopls.setup({})
require("lspconfig").kotlin_language_server.setup({})
require("lspconfig").omnisharp.setup({
  --root_dir = /Users/takuto/.local/share/nvim/mason/bin
  cmd = { "/Users/takuto/.local/share/nvim/mason/bin/omnisharp" },
  settings = {
    RoslynExtensionsOptions = {
      --EnableAnalyzersSupport = true,
      EnableImportCompletion = true,
    },
  },
  --capabilities = capabilities,
  --enable_import_completion = true,
  --enable_roslyn_analyzers = true,
})
require("lspconfig").lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})
-- csharp lsp
--require("roslyn").setup({
--  dotnet_cmd = "dotnet",      -- this is the default
--  on_attach = on_attach,      -- required
--  capabilities = capabilities, -- required
--})
--require("lua.lsp-cmp-mason")

lspconfig.clangd.setup({
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--cross-file-rename",
    "--compile-commands-dir=build", -- ここを使うとプロジェクト直下に symlink を置かなくてOK
  },
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_dir = lspconfig.util.root_pattern(
    "compile_commands.json",
    "compile_flags.txt",
    "CMakePresets.json",
    "CMakeLists.txt",
    ".git"
  ),
})
require("mason").setup()
require("mason-lspconfig").setup({
  automatic_enable = false,
  ensure_installed = {
    "clangd",
  }
})
-- require("mason-lspconfig").setup_handlers({
-- 	function(server_name)   -- default handler (optional)
-- 		require("lspconfig")[server_name].setup({
-- 			on_attach = on_attach, --keyバインドなどの設定を登録
-- 			capabilities = capabilities, --cmpを連携
-- 		})
-- 	end,
-- })
