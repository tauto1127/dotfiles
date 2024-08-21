-- バッファの内容全体を使って Copilot とチャットする
function CopilotChatBuffer()
	local input = vim.fn.input("Quick Chat: ")
	if input ~= "" then
		require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
	end
end

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

local function lazygitToggle()
	lazygit:toggle()
end
