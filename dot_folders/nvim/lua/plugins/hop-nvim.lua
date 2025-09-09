return {
  "smoka7/hop.nvim",
  version = "*",
  opts = {
    keys = "etovxqpdygfblzhckisuran",
  },
  config = function()
    require("hop").setup({
      multi_window = true,
    })
  end,
  keys = {
    {
      mode = "n",
      "f",
      "<cmd>HopChar2<CR>",
    },

    {
      mode = "n",
      "F",
      "<cmd>HopPattern<CR>",
    },
  },
}
