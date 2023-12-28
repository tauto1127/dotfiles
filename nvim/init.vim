"Ward off unexpected things that your distro might have made, as
" well as sanely reset options when re-sourcing .vimrc
set nocompatible

set shell=/bin/zsh 
set shiftwidth=4
set tabstop=4 
set shell=/bin/zsh
set textwidth=0 
set autoindent 
set sw=4
set hlsearch 
set clipboard=unnamed

syntax on 

" <--- deinInstall 
let $CACHE = expand('~/.cache')
if !($CACHE->isdirectory())
  call mkdir($CACHE, 'p')
endif
if &runtimepath !~# '/dein.vim'
  let s:dir = 'dein.vim'->fnamemodify(':p')
  if !(s:dir->isdirectory())
    let s:dir = $CACHE .. '/dein/repos/github.com/Shougo/dein.vim'
    if !(s:dir->isdirectory())
      execute '!git clone https://github.com/Shougo/dein.vim' s:dir
    endif
  endif
  execute 'set runtimepath^='
        \ .. s:dir->fnamemodify(':p')->substitute('[/\\]$', '', '')
endif


" Set Dein base path (required)
let s:dein_base = '$HOME/.local/share/dein'

" Set Dein source path (required)
let s:dein_src = '$HOME/.local/share/dein/repos/github.com/Shougo/dein.vim'

" Set Dein runtime path (required)
execute 'set runtimepath+=' . s:dein_src

" Call Dein initialization (required)
call dein#begin(s:dein_base)

call dein#add(s:dein_src)

" Your plugins go here:
"call dein#add('Shougo/neosnippet.vim')
"call dein#add('Shougo/neosnippet-snippets')
call dein#add('ntk148v/vim-horizon')
call dein#add('preservim/nerdtree')
call dein#add('tpope/vim-commentary')
call dein#add('neoclide/coc.nvim', { 'merged': 0, 'rev': 'release' })
call dein#add('gko/vim-coloresque')
call dein#add('vim-jp/vimdoc-ja')
call dein#add('machakann/vim-sandwich')
call dein#add('brglng/vim-im-select')
call dein#add('vim-scripts/vim-auto-save')
" vscodeのようなファイル検索を実現する
call dein#add('nvim-lua/plenary.nvim')
call dein#add('nvim-telescope/telescope.nvim')
"call dein#add('kyazdani42/nvim-web-devicons')
"自動ライブラリインポート
call dein#add('relastle/vim-nayvy')
"色つけてくれる
"call dein#add('nvim-treesitter/nvim-treesitter')
"flutter 用 (一番上のはoptionalらしい
call dein#add('stevearc/dressing.nvim')
call dein#add('akinsho/flutter-tools.nvim')

"debugger
call dein#add('mfussenegger/nvim-dap')

call dein#add('dinhhuy258/git.nvim') 
call dein#add('tpope/vim-fugitive')
call dein#add('NeogitOrg/neogit')
" Finish Dein initialization (required)
call dein#end()

"" Uncomment if you want to install not-installed plugins on startup.
if dein#check_install()
 call dein#install()
endif"


" PLUGIN SETTINGS HERE
" if you don't set this option, this color might not correct
"set termguicolors
"colorscheme horizon
" lightline
"let g:lightline = {}
"let g:lightline.colorscheme = 'horizon'

"SHORTCUT KEYS
"shortcut
" terminall fjで抜けれる
tnoremap fj <C-\><C-N>

nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle <CR>
"jjでescにする．
inoremap <silent> jj <ESC>

"autosave
let g:auto_save = 1
" treesitterの設定！？
"lua <<EOF
"require'nvim-treesitter.configs'.setup {
"  highlight = {
"    enable = true,
"    disable = {
"      'lua',
"      'ruby',
"      'toml',
"      'c_sharp',
"      'vue',
"    }
"  }
"}
"EOF

" fluttertoolsの設定
"lua << EOF
"	require("flutter-tools").setup {
"		fvm = true,
"		debugger = {
"			enabled = true,
"			run_via_dap = true,
"		},
"		devtools = {
"			autostart = true,
"			auto_open_browser = true,
"		}
"	}
"EOF
"" neo gitの設定
lua << EOF
	local neogit = require('neogit')
	neogit.setup {}
EOF

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
"" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
"" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
"" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)
" vimocc タブで
" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
"inoremap <silent><expr> <TAB>
"      \ coc#pum#visible() ? coc#pum#next(1) :
"      \ CheckBackspace() ? "\<Tab>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
"" coc.nvimの設定 ~~~~~~
""" <Tab>で候補をナビゲート
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
"" <Tab>で次、<S+Tab>で前
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"" 補完表示時のEnterで改行をしない
inoremap <expr><CR>  pumvisible() ? "<C-y>" : "<CR>"
set completeopt=menuone,noinsert
inoremap <expr><C-n> pumvisible() ? "<Down>" : "<C-n>"
inoremap <expr><C-p> pumvisible() ? "<Up>" : "<C-p>"
" QUICK FIX
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)
"" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
"" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)

"" telescope vscodeのようなファイル
nnoremap <leader>ff <cmd>Telescope find_files hidden=true<cr>

""AUTO START HERE
"" Start NERDTree when Vim is started without file arguments.
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

"" Attempt to determine the type of a file based on its name and possibly its
"" contents. Use this to allow intelligent auto-indenting for each filetype,
"" and for plugins that are filetype specific.
if has('filetype')
  filetype indent plugin on
endif

"" Enable syntax highlighting
if has('syntax')
  syntax on

endif



" cocプラグイン導入
let g:coc_global_extensions = [
	\	'coc-css'
	\,	'coc-html-css-support'
	\,	'coc-tsserver'
	\,	'coc-flutter'
	\,	'coc-json'
	\,	'coc-html'
	\,	'coc-python'
	\,	]
