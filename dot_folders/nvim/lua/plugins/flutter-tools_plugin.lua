return {
  "akinsho/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim", -- optional for vim.ui.select
  },
  config = function()
    -- alternatively you can override the default configs
    require("flutter-tools").setup({
      ui = {
        -- the border type to use for all floating windows, the same options/formats
        -- used for ":h nvim_open_win" e.g. "single" | "shadow" | {<table-of-eight-chars>}
        border = "rounded",
        -- This determines whether notifications are show with `vim.notify` or with the plugin's custom UI
        -- please note that this option is eventually going to be deprecated and users will need to
        -- depend on plugins like `nvim-notify` instead.
        notification_style = "native",
      },
      decorations = {
        statusline = {
          -- set to true to be able use the 'flutter_tools_decorations.app_version' in your statusline
          -- this will show the current version of the flutter app from the pubspec.yaml file
          app_version = true,
          -- set to true to be able use the 'flutter_tools_decorations.device' in your statusline
          -- this will show the currently running device if an application was started with a specific
          -- device
          device = true,
          -- set to true to be able use the 'flutter_tools_decorations.project_config' in your statusline
          -- this will show the currently selected project configuration
          project_config = true,
        },
      },
      debugger = {       -- integrate with nvim dap + install dart code debugger
        -- enabled = true,
        run_via_dap = false, -- use dap instead of a plenary job to run flutter apps
        -- if empty dap will not stop on any exceptions, otherwise it will stop on those specified
        -- see |:help dap.set_exception_breakpoints()| for more info
        register_configurations = function(paths)
          require("dap").adapters.dart = {
            type = "executable",
            command = paths.flutter_sdk,
            args = { "debug-adapter" },
          }

          require("dap").configurations.dart = {
            {},
          }
        end,
      },
      root_patterns = { ".git", "pubspec.yaml" }, -- patterns to find the root of your flutter project
      fvm = true,                              -- takes priority over path, uses <workspace>/.fvm/flutter_sdk if enabled
      widget_guides = {
        enabled = true,
      },
      closing_tags = {
        highlight = "ErrorMsg", -- highlight for the closing tag
        prefix = ">",       -- character to use for close tag e.g. > Widget
        enabled = true,     -- set to false to disable
      },
      dev_log = {
        enabled = true,
        notify_errors = true, -- if there is an error whilst running then notify the user
        open_cmd = "tabedit", -- command to use to open the log buffer
      },
      dev_tools = {
        autostart = true,     -- autostart devtools server if not detected
        auto_open_browser = true, -- Automatically opens devtools in the browser
      },
      lsp = {
        color = { -- show the derived colours for dart variables
          enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
          background = true, -- highlight the background
          background_color = nil, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
          foreground = true, -- highlight the foreground
          virtual_text = true, -- show the highlight using virtual text
          virtual_text_str = "■", -- the virtual text character to highlight
        },
        --on_attach = my_custom_on_attach,
        --capabilities = my_custom_capabilities, -- e.g. lsp_status capabilitie,
        -- see the link below for details on each option:
        -- https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/tool/lsp_spec/README.md#client-workspace-configuration
        settings = {
          showTodos = true,
          --analysisExcludedFolders = { "framework.dart" },
          --renameFilesWithClasses = "prompt", -- "always"
          enableSnippets = true,
          updateImportsOnRename = true, -- Whether to update imports and other directives when files are renamed. Required for `FlutterRename` command.
          lineLength = 140,
          -- lineLength = (function()
          --   --- ref: https://github.com/akinsho/flutter-tools.nvim/issues/178
          --   local currentDir = vim.fn.getcwd()
          --   return 140
          --
          --   --if vim.fn.expand("%:p"):find("^/Users/takuto/Code/Dart/Hakondate/") then
          --   --	echo("hakondateだあ")
          --   --	return 140
          --   --end
          --   --return vim.fn.expand("%:p"):find("^/Users/takuto/Code/Dart/Hakondate/") and 140 or 80
          -- end)(),
          widgetGuides = true,
        },
      },
    })
  end,
}
