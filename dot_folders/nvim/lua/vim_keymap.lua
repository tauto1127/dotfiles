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
-- oil
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "to", ":ToggleTerm<cr>", { noremap = true, silent = true }) --:TogglTerm<cr>
--タブを閉じる
vim.api.nvim_set_keymap("n", "<C-x>", ":tabclose<cr>", { noremap = true, silent = true })


-- <C-w> 系を Vim Tmux Navigator に移譲する
vim.api.nvim_set_keymap("n", "<C-w>h", "<cmd>TmuxNavigateLeft<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-w>j", "<cmd>TmuxNavigateDown<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-w>k", "<cmd>TmuxNavigateUp<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-w>l", "<cmd>TmuxNavigateRight<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-w>\\", "<cmd>TmuxNavigatePrevious<cr>", { noremap = true, silent = true })

--tab切り替え
vim.api.nvim_set_keymap("n", "<C-n>", ":tabnext<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-p>", ":tabprevious<cr>", { noremap = true, silent = true })

-- lspのキー配置
-- -- 2. build-in LSP function
-- keyboard shortcut
local function normalize_locations(result)
  if not result then
    return {}
  end
  if vim.islist(result) then
    return result
  end
  return { result }
end

local function collect_jumpable_locations(locations)
  local jumpable = {}
  for _, location in ipairs(locations) do
    local uri = location.uri or location.targetUri
    local range = location.range or location.targetSelectionRange or location.targetRange
    if uri and range and range.start then
      table.insert(jumpable, location)
    end
  end
  return jumpable
end

local function get_client_path_mappings(client)
  local mappings = {}
  if not client or not client.config or type(client.config.cmd) ~= "table" then
    return mappings
  end

  for _, arg in ipairs(client.config.cmd) do
    if type(arg) == "string" and vim.startswith(arg, "--path-mappings=") then
      local mapping_value = arg:sub(#"--path-mappings=" + 1)
      for pair in string.gmatch(mapping_value, "([^,]+)") do
        local remote, local_path = pair:match("^(.-)=(.+)$")
        if remote and local_path then
          table.insert(mappings, {
            remote = vim.fs.normalize(remote):gsub("/+$", ""),
            local_path = vim.fs.normalize(local_path):gsub("/+$", ""),
          })
        end
      end
    end
  end

  return mappings
end

local function remap_location_uri(location, client)
  local uri = location.uri or location.targetUri
  if not uri then
    return location
  end

  local ok, path = pcall(vim.uri_to_fname, uri)
  if not ok or path == "" or vim.loop.fs_stat(path) then
    return location
  end

  local normalized_path = vim.fs.normalize(path)
  for _, mapping in ipairs(get_client_path_mappings(client)) do
    if vim.startswith(normalized_path, mapping.remote) then
      local remapped_path = mapping.local_path .. normalized_path:sub(#mapping.remote + 1)
      if vim.loop.fs_stat(remapped_path) then
        local remapped_uri = vim.uri_from_fname(remapped_path)
        local updated = vim.deepcopy(location)
        if updated.uri then
          updated.uri = remapped_uri
        end
        if updated.targetUri then
          updated.targetUri = remapped_uri
        end
        return updated
      end
    end
  end

  return location
end

local function safe_jump(method)
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request_all(0, method, params, function(results)
    local all_locations = {}
    local items = {}
    local jump_location = nil
    local jump_encoding = nil

    for client_id, response in pairs(results) do
      local client = vim.lsp.get_client_by_id(client_id)
      local offset_encoding = client and client.offset_encoding or "utf-16"
      local locations = {}
      for _, location in ipairs(collect_jumpable_locations(normalize_locations(response.result))) do
        table.insert(locations, remap_location_uri(location, client))
      end

      if response.error then
        vim.notify(
          string.format("%s failed: %s", client and client.name or ("client " .. client_id), response.error.message),
          vim.log.levels.WARN
        )
      end

      if #locations > 0 then
        if not jump_location then
          jump_location = locations[1]
          jump_encoding = offset_encoding
        end
        vim.list_extend(all_locations, locations)
        vim.list_extend(items, vim.lsp.util.locations_to_items(locations, offset_encoding))
      end
    end

    if jump_location then
      if #all_locations == 1 then
        local ok, result = pcall(vim.lsp.util.show_document, jump_location, jump_encoding, { focus = true })
        if not ok then
          vim.notify("LSP jump failed: " .. tostring(result), vim.log.levels.WARN)
        elseif result ~= true then
          vim.notify("LSP jump failed: could not open target location", vim.log.levels.WARN)
        end
        return
      end

      vim.fn.setqflist({}, " ", { title = "LSP locations", items = items })
      vim.cmd("copen")
      return
    end

    vim.notify("No valid LSP location found", vim.log.levels.WARN)
  end)
end

vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
vim.keymap.set("n", "gf", "<cmd>lua vim.lsp.buf.formatting()<CR>")
vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
vim.keymap.set("n", "gd", function()
  safe_jump("textDocument/definition")
end)
vim.keymap.set("n", "gD", function()
  safe_jump("textDocument/declaration")
end)
vim.keymap.set("n", "gi", function()
  safe_jump("textDocument/implementation")
end)
-- vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
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

vim.api.nvim_set_keymap("n", "<leader>lg", "<cmd>lua LazygitToggle()<CR>", { noremap = true, silent = true })
-- terminalモードから抜けるためのキー設定
vim.api.nvim_set_keymap("t", "<C-]>", "<C-\\><C-n>", { noremap = true })

---- キーマッピング
-- <leader>ccp (Copilot Chat Prompt の略) でアクションプロンプトを表示する
-- copilotのキー
-- telescope を使ってアクションプロンプトを表示する

vim.api.nvim_set_keymap(
  "n",
  "<leader>ccp",
  "<cmd>lua ShowCopilotChatActionPrompt()<cr>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap("n", "<leader>ccb", "<cmd>lua copilotChatBuffer()<cr>", { noremap = true, silent = true })

vim.keymap.set("i", "<Tab>", function()
  if require("copilot.suggestion").is_visible() then
    require("copilot.suggestion").accept()
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
  end
end, { desc = "Super Tab" })
vim.api.nvim_set_keymap("n", "<leader>b", "<cmd>BuffergatorToggle<CR>", { noremap = true, silent = true })
-- AvanteAsk
vim.api.nvim_set_keymap("n", "<leader>aa", "<cmd>AvanteAsk<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>aa", "<cmd>AvanteAsk<CR>", { noremap = true, silent = true })
-- avanteedit
vim.api.nvim_set_keymap("v", "<leader>ae", "<cmd>AvanteEdit<CR>", { noremap = true, silent = true })
