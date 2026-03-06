--lspの設定
local cmp = require("cmp")
local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local on_attach = function() end
capabilities.general = capabilities.general or {}
capabilities.general.positionEncodings = { "utf-16" }
capabilities.offsetEncoding = { "utf-16" }

local function has_cmd_arg(cmd, prefix)
  for _, arg in ipairs(cmd) do
    if vim.startswith(arg, prefix) then
      return true
    end
  end
  return false
end

local function remove_cmd_args(cmd, prefixes)
  local filtered = {}
  for _, arg in ipairs(cmd) do
    local keep = true
    for _, prefix in ipairs(prefixes) do
      if vim.startswith(arg, prefix) then
        keep = false
        break
      end
    end
    if keep then
      table.insert(filtered, arg)
    end
  end
  return filtered
end

local function find_compile_commands_dir(root_dir)
  local cc_in_root = util.path.join(root_dir, "compile_commands.json")
  if vim.loop.fs_stat(cc_in_root) then
    return nil
  end

  local fixed_dirs = {
    "build",
    "Build",
    ".build",
    "out",
    "cmake-build-debug",
    "cmake-build-release",
    "cmake-build-relwithdebinfo",
    "cmake-build-minsizerel",
  }
  for _, dir in ipairs(fixed_dirs) do
    local cc = util.path.join(root_dir, dir, "compile_commands.json")
    if vim.loop.fs_stat(cc) then
      return util.path.join(root_dir, dir)
    end
  end

  local patterns = {
    "build*/compile_commands.json",
    "cmake-build*/compile_commands.json",
    "out*/compile_commands.json",
  }
  for _, pattern in ipairs(patterns) do
    local matches = vim.fn.glob(util.path.join(root_dir, pattern), false, true)
    if #matches > 0 then
      table.sort(matches)
      return vim.fn.fnamemodify(matches[1], ":h")
    end
  end

  local recursive_patterns = {
    "**/build/compile_commands.json",
    "**/Build/compile_commands.json",
    "**/.build/compile_commands.json",
    "**/cmake-build*/compile_commands.json",
    "**/out*/compile_commands.json",
  }
  for _, pattern in ipairs(recursive_patterns) do
    local matches = vim.fn.globpath(root_dir, pattern, false, true)
    if #matches > 0 then
      table.sort(matches)
      return vim.fn.fnamemodify(matches[1], ":h")
    end
  end

  return nil
end

local function detect_path_mapping(root_dir, compile_commands_dir)
  local cc_path = util.path.join(compile_commands_dir, "compile_commands.json")
  local f = io.open(cc_path, "r")
  if not f then
    return nil
  end
  local content = f:read("*a")
  f:close()

  local ok, compdb = pcall(vim.json.decode, content)
  if (not ok) or type(compdb) ~= "table" then
    return nil
  end

  local normalized_root = vim.fs.normalize(root_dir):gsub("/+$", "")
  local project_name = vim.fs.basename(normalized_root)
  if type(project_name) ~= "string" or project_name == "" then
    return nil
  end

  local marker = "/" .. project_name .. "/"

  for _, item in ipairs(compdb) do
    if type(item) == "table" then
      local sample_path = item.file or item.directory
      if type(sample_path) == "string" then
        if not vim.startswith(sample_path, "/") and type(item.directory) == "string" then
          sample_path = util.path.join(item.directory, sample_path)
        end

        local start_idx = sample_path:find(marker, 1, true)
        if not start_idx and sample_path:sub(- #project_name) == project_name then
          start_idx = #sample_path - #project_name + 1
        end

        if start_idx then
          local remote_root = sample_path:sub(1, start_idx + #project_name):gsub("/+$", "")
          if remote_root ~= normalized_root then
            return remote_root .. "=" .. normalized_root
          end
        end
      end
    end
  end

  return nil
end

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

lspconfig.eslint.setup({})
-- require("lspconfig").csharp_ls.setup({ capabilities = capabilities })
lspconfig.tsserver.setup({})
lspconfig.docker_compose_language_service.setup({})
lspconfig.dockerls.setup({})
lspconfig.pylsp.setup({})
lspconfig.gopls.setup({})
lspconfig.kotlin_language_server.setup({})
lspconfig.clangd.setup({
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--offset-encoding=utf-16",
    "--background-index",
    "--completion-style=detailed",
  },
  root_dir = util.root_pattern(
    "compile_commands.json",
    ".clangd",
    "compile_flags.txt",
    ".git"
  ),
  single_file_support = false,
  on_new_config = function(new_config, root_dir)
    -- lspconfig may reuse cmd tables between restarts in the same nvim session.
    -- Always rebuild dynamic args to avoid keeping stale path mappings.
    local base_cmd = remove_cmd_args(
      vim.deepcopy(new_config.cmd or {}),
      {
        "--compile-commands-dir=",
        "--path-mappings=",
        "--offset-encoding=",
      }
    )
    if #base_cmd == 0 then
      base_cmd = { "clangd", "--background-index" }
    end
    new_config.cmd = vim.deepcopy(base_cmd)
    table.insert(new_config.cmd, 2, "--offset-encoding=utf-16")

    local compile_commands_dir = find_compile_commands_dir(root_dir)
    if compile_commands_dir and (not has_cmd_arg(new_config.cmd, "--compile-commands-dir=")) then
      table.insert(new_config.cmd, "--compile-commands-dir=" .. compile_commands_dir)
    end
    if compile_commands_dir and (not has_cmd_arg(new_config.cmd, "--path-mappings=")) then
      local mapping = detect_path_mapping(root_dir, compile_commands_dir)
      if mapping then
        table.insert(new_config.cmd, "--path-mappings=" .. mapping)
      end
    end
  end,
  on_init = function(client)
    client.offset_encoding = "utf-16"
  end,
})
lspconfig.omnisharp.setup({
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
lspconfig.lua_ls.setup({
  settigns = {
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
require("mason").setup()
require("mason-lspconfig").setup({
  automatic_enable = false
})
-- require("mason-lspconfig").setup_handlers({
-- 	function(server_name)   -- default handler (optional)
-- 		require("lspconfig")[server_name].setup({
-- 			on_attach = on_attach, --keyバインドなどの設定を登録
-- 			capabilities = capabilities, --cmpを連携
-- 		})
-- 	end,
-- })
