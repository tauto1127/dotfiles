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
    -- 許可するドライバを広めに指定（em++ / wasi-sdk などのクロスツールチェイン対応）
    "--query-driver=/usr/bin/*,/usr/local/bin/*,**/emsdk/**/em++,**/emsdk/**/emcc,**/wasi-sdk/**/bin/*",
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
  on_new_config = function(new_config, new_root_dir)
    local util = require("lspconfig").util
    local path = util.path
    local function exists(p)
      return p and path.exists(p)
    end

    local function join(...)
      return table.concat({ ... }, "/"):gsub("//+", "/")
    end

    -- 探索順:
    -- 1) <root>/compile_commands.json
    -- 2) <root>/build/compile_commands.json
    -- 3) <root>/build/*/compile_commands.json （colcon/ROS2 など）
    local db_dir = nil
    if exists(join(new_root_dir, "compile_commands.json")) then
      db_dir = new_root_dir
    elseif exists(join(new_root_dir, "build/compile_commands.json")) then
      db_dir = join(new_root_dir, "build")
    else
      local build_dir = join(new_root_dir, "build")
      local handle = vim.loop.fs_scandir(build_dir)
      if handle then
        while true do
          local name, t = vim.loop.fs_scandir_next(handle)
          if not name then break end
          if t == "directory" and exists(join(build_dir, name, "compile_commands.json")) then
            db_dir = join(build_dir, name)
            break
          end
        end
      end
    end

    if db_dir then
      -- 既存のcmdをコピーし、--compile-commands-dir が無ければ追加
      local cmd = vim.deepcopy(new_config.cmd or { "clangd" })
      local has_flag = false
      for _, v in ipairs(cmd) do
        if v:match("^%-%-compile%-commands%-dir=") or v == "--compile-commands-dir" then
          has_flag = true
          break
        end
      end
      if not has_flag then
        table.insert(cmd, "--compile-commands-dir=" .. db_dir)
      end
      new_config.cmd = cmd
    end
  end,
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
