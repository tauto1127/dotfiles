return {
  "olimorris/codecompanion.nvim",
  opts = {},
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        opencode = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            name = "opencode",
            env = {
              url = "http://127.0.0.1:4096",
              api_key = "opencode",
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "opencode",
        },
        inline = {
          adapter = "opencode",
        },
      },
      opts = {
        language = "ja",
      },
    })
    vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<C-c>", ":CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
  end,
}
