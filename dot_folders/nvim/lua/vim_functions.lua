-- バッファの内容全体を使って Copilot とチャットする
function CopilotChatBuffer()
  local input = vim.fn.input("Quick Chat: ")
  if input ~= "" then
    require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
  end
end

-- newfileの時にmarkdownにする
vim.api.nvim_create_autocmd({ "BufNewFile" }, {
  pattern = "*",
  command = "set filetype=markdown",
})

function ShowCopilotChatActionPrompt()
  local actions = require("CopilotChat.actions")
  require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
end

-- lazygit設定
local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({
  cmd = "lazygit",
  direction = "float",
  hidden = true,
})

function LazygitToggle()
  lazygit:toggle()
end
