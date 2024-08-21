return {
	"andweeb/presence.nvim",
	config = function()
		require("presence").setup({
			debounce_timeout = 5,
			blacklist = {
				"*.md",
				"README.md",
				"main",
			},
		})
	end,
}
