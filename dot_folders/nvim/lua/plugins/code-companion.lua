return {
  "olimorris/codecompanion.nvim",
  opts = {},
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/codecompanion-history.nvim",
  },
  config = function()
    require("codecompanion").setup({
      adapters = {
        acp = {
          opencode = function()
            return require("codecompanion.adapters").extend("opencode", {
              command = "opencode",
              args = { "acp" },
            })
          end,
        },
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

    -- キーバインド設定
    vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<C-c>", ":CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
    vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>ch", "<cmd>CodeCompanionHistory<cr>", { desc = "CodeCompanion 履歴一覧", noremap = true, silent = true })
  end,
}
