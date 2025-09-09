return {
  "windwp/nvim-ts-autotag",
  opts = {
    -- New options layout expected by nvim-ts-autotag
    opts = {
      enable_close = true,          -- Auto close tags
      enable_rename = true,         -- Auto rename pairs of tags
      enable_close_on_slash = false -- Auto close on trailing </
    },
    -- Per-filetype overrides live inside the plugin options table
    per_filetype = {
      html = { enable_close = false },
    },
  },
}
