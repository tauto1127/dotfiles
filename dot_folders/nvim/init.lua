local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local nocode = vim.g.vscode == nil

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)
local plugins = {
  'nvim-lua/plenary.nvim',
  'nvim-telescope/telescope.nvim',
  'mfussenegger/nvim-dap',
  'stevearc/dressing.nvim', -- telescopeの検索のui
  'nvim-treesitter/nvim-treesitter',
  'kyazdani42/nvim-web-devicons', --アイコンたち
  'tpope/vim-fugitive',
  'airblade/vim-gitgutter',
  'cohama/lexima.vim',
}

if nocode then
  table.insert(plugins, 'neoclide/coc.nvim')
  table.insert(plugins, 'nvim-tree/nvim-tree.lua')
  table.insert(plugins, require('alpha-nvim_plugin'))
  table.insert(plugins, require('toggleterm_plugin'))
  table.insert(plugins, require('nvim-lsp-file-operations_plugin'))
  table.insert(plugins, 'christoomey/vim-tmux-navigator')
end

require("lazy").setup(plugins)

if nocode then
  require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    -- List of parsers to ignore installing (or "all")
    ignore_install = { "javascript" },
    highlight = {
      enable = true,
      -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
      disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
              return true
          end
      end,
    },
  }
  require('coc_plugin')
  require("nvim-tree").setup { -- BEGIN_DEFAULT_OPTS
      on_attach = "default",
      hijack_cursor = false,
      auto_reload_on_write = true,
      disable_netrw = false,
      hijack_netrw = true,
      hijack_unnamed_buffer_when_opening = false,
      root_dirs = {},
      prefer_startup_root = false,
      sync_root_with_cwd = false,
      reload_on_bufenter = false,
      respect_buf_cwd = false,
      select_prompts = false,
      sort = {
        sorter = "name",
        folders_first = true,
        files_first = false,
      },
      view = {
        centralize_selection = false,
        cursorline = true,
        debounce_delay = 15,
        side = "left",
        preserve_window_proportions = false,
        number = false,
        relativenumber = false,
        signcolumn = "yes",
        width = 30,
        float = {
          enable = false,
          quit_on_focus_loss = true,
          open_win_config = {
            relative = "editor",
            border = "rounded",
            width = 30,
            height = 30,
            row = 1,
            col = 1,
          },
        },
      },
      renderer = {
        add_trailing = false,
        group_empty = false,
        full_name = false,
        root_folder_label = ":~:s?$?/..?",
        indent_width = 2,
        special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
        symlink_destination = true,
        highlight_git = true,
        highlight_diagnostics = true,
        highlight_opened_files = "none",
        highlight_modified = "none",
        highlight_bookmarks = "none",
        highlight_clipboard = "name",
        indent_markers = {
          enable = false,
          inline_arrows = true,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            bottom = "─",
            none = " ",
          },
        },
        icons = {
          web_devicons = {
            file = {
              enable = true,
              color = true,
            },
            folder = {
              enable = false,
              color = true,
            },
          },
          git_placement = "before",
          modified_placement = "after",
          diagnostics_placement = "signcolumn",
          bookmarks_placement = "signcolumn",
          padding = " ",
          symlink_arrow = " ➛ ",
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
            modified = true,
            diagnostics = true,
            bookmarks = true,
          },
          glyphs = {
            default = "",
            symlink = "",
            bookmark = "󰆤",
            modified = "●",
            folder = {
              arrow_closed = "",
              arrow_open = "",
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
              symlink_open = "",
            },
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            },
          },
        },
      },
      hijack_directories = {
        enable = true,
        auto_open = true,
      },
      update_focused_file = {
        enable = false,
        update_root = false,
        ignore_list = {},
      },
      system_open = {
        cmd = "",
        args = {},
      },
      git = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        disable_for_dirs = {},
        timeout = 400,
        cygwin_support = false,
      },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        debounce_delay = 50,
        severity = {
          min = vim.diagnostic.severity.HINT,
          max = vim.diagnostic.severity.ERROR,
        },
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        },
      },
      modified = {
        enable = false,
        show_on_dirs = true,
        show_on_open_dirs = true,
      },
      filters = {
        git_ignored = true,
        dotfiles = false,
        git_clean = false,
        no_buffer = false,
        no_bookmark = false,
        custom = {},
        exclude = {},
      },
      live_filter = {
        prefix = "[FILTER]: ",
        always_show_folders = true,
      },
      filesystem_watchers = {
        enable = true,
        debounce_delay = 50,
        ignore_dirs = {},
      },
      actions = {
        use_system_clipboard = true,
        change_dir = {
          enable = true,
          global = false,
          restrict_above_cwd = false,
        },
        expand_all = {
          max_folder_discovery = 300,
          exclude = {},
        },
        file_popup = {
          open_win_config = {
            col = 1,
            row = 1,
            relative = "cursor",
            border = "shadow",
            style = "minimal",
          },
        },
        open_file = {
          quit_on_open = false,
          eject = true,
          resize_window = true,
          window_picker = {
            enable = true,
            picker = "default",
            chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
            exclude = {
              filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
              buftype = { "nofile", "terminal", "help" },
            },
          },
        },
        remove_file = {
          close_window = true,
        },
      },
      trash = {
        cmd = "gio trash",
      },
      tab = {
        sync = {
          open = true, --？？
          close = false,
          ignore = {},
        },
      },
      notify = {
        threshold = vim.log.levels.INFO,
        absolute_path = true,
      },
      help = {
        sort_by = "key",
      },
      ui = {
        confirm = {
          remove = true,
          trash = true,
          default_yes = false,
        },
      },
      experimental = {},
      log = {
        enable = false,
        truncate = false,
        types = {
          all = false,
          config = false,
          copy_paste = false,
          dev = false,
          diagnostics = false,
          git = false,
          profile = false,
          watcher = false,
        },
      },
    } -- END_DEFAULT_OPTS


end

if nocode then
    --vim.nnoremap <C-t> :NvimTreeToggle <CR>
  --crで囲むとコマンドとして認識される
  --silentをオンにすると，エラーなどが表示されなくなる
  vim.api.nvim_set_keymap('n', '<C-t>', ':NvimTreeToggle<cr>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('t', 'fj', '<C-\\><C-n>', { noremap = true, silent = true })
  --telescope vscodeのようなファイル探索
  vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files hidden=true<cr>', {noremap = true, silent=true})
  vim.api.nvim_set_keymap('n', 'to', ':ToggleTerm<cr>', {noremap = true, silent = true})--:TogglTerm<cr>
  --タブを閉じる
  vim.api.nvim_set_keymap('n', '<C-x>', ':tabclose<cr>', { noremap = true, silent = true })
  vim.api.nvim_command('command! -nargs=0 DartFormat lua vim.api.nvim_command("silent !dart format -l 120 " .. vim.fn.expand("%"))')
  -- <C-w> 系を Vim Tmux Navigator に移譲する
  vim.api.nvim_set_keymap('n', '<C-w>h', ':TmuxNavigateLeft', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-w>j', ':TmuxNavigateDown', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-w>k', ':TmuxNavigateUp', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-w>l', ':TmuxNavigateRight', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('n', '<C-w>\\', ':TmuxNavigatePrevious', { noremap = true, silent = true })
end

vim.api.nvim_set_keymap('n', 'ff', '<ESC>', {noremap = true, silent=true})

vim.o.clipboard = vim.o.clipboard .. 'unnamedplus'
--インデント
vim.opt.tabstop = 2
vim.opt.shiftwidth=2

--オートコンプリート系
vim.o.completeopt = "menuone,noinsert"
