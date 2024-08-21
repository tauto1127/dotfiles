return {
	"nvim-telescope/telescope.nvim",
	config = function()
		require("telescope").setup({
			defaults = {
				file_ignore_patterns = {
					"^.git/",
					"^.cache/",
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})
		require("telescope").load_extension("flutter")
		require("telescope").load_extension("fzf")
	end,
}
