vim.api.nvim_command('command! -nargs=0 Today lua vim.cmd("ObsidianToday")')
vim.api.nvim_command("command! -nargs=0 Chat lua chat.open()")
vim.api.nvim_command('command! -nargs=0 Yesterday lua vim.cmd("ObsidianYesterday")')
vim.api.nvim_command(
	'command! -nargs=0 DartFormat lua vim.api.nvim_command("silent !dart format -l 120 " .. vim.fn.expand("%"))'
)
