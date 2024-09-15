return {
  "seblj/roslyn.nvim",
  ft = "cs",
  opts = {},
  config = function()
    require("roslyn").setup({
      config = {},
      exe = {
        "dotnet",
        vim.fs.joinpath(vim.fn.stdpath("data"), "roslyn", "Microsoft.CodeAnalysis.LanguageServer.dll"),
      },
      filewatching = true,
    })
  end,
}
