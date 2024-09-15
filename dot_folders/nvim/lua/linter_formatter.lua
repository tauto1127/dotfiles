local null_ls = require("null-ls")
null_ls.setup({
  diagnostics_format = "[#{m}] #{s} (#{c})",
  sources = {
    --ここでlinterとフォーマッターを設定する
    null_ls.builtins.formatting.stylua,
    --null_ls.builtins.diagnostics.luacheck,
    null_ls.builtins.formatting.clang_format,

    null_ls.builtins.formatting.shfmt,
    --null_ls.builtins.diagnostics.shellcheck,
    --null_ls.builtins.code_actions.shellcheck,
    null_ls.builtins.formatting.dart_format,
    null_ls.builtins.formatting.prettier,
  },
  -- you can reuse a shared lspconfig on_attach callback here
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
          -- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
})
null_ls.builtins.code_actions.gitsigns.with({
  disabled_filetypes = {},
})
