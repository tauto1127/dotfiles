-- dot_folders/nvim/lua/plugins/cmake-tools.lua
return {
  "Civitasv/cmake-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmake_generate_options = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1" },
  config = function()
    require("cmake-tools").setup({
    })
  end,
}
