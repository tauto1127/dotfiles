return {
  'esensar/nvim-dev-container',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require("devcontainer").setup {
      container_runtime = "docker",
    }
  end,
}
