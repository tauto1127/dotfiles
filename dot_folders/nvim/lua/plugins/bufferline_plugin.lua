return {
	"akinsho/bufferline.nvim",
	config = function()
		options = {
			mode = "buffers",
			diagnostics = "nvim_lsp",
			always_show_bufferline = true,
			numbers = "buffer_id",
		}
	end,
}
