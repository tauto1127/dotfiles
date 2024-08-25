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

vim.api.nvim_set_keymap("n", "<leader>lg", "<cmd>lua LazygitToggle()<CR>", { noremap = true, silent = true })
-- terminalモードから抜けるためのキー設定
vim.api.nvim_set_keymap("t", "<C-]>", "<C-\\><C-n>", { noremap = true })

vim.api.nvim_set_keymap("n", "<C-n>", "<cmd>bnext<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-p>", "<cmd>bprevious<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-q>", "<cmd>b#<cr><cmd>bd#<cr>", { noremap = true })

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

vim.api.nvim_set_keymap("n", "<leader>b", "<cmd>BuffergatorToggle<CR>", { noremap = true, silent = true })
