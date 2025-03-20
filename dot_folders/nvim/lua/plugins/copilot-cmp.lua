return {
  "zbirenbaum/copilot-cmp",
  filetypes = {
    markdown = true, -- Explicitly enable markdown
  },
  config = function()
    require("copilot_cmp").setup()
  end,
}
