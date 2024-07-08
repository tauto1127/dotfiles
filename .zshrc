# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#alias tmux="tmux -u2"

## tmuxの自動起動
#count=`ps aux | grep tmux | grep -v grep | wc -l`
#if test $count -eq 0; then
#    echo `tmux`
#elif test $count -eq 1; then
#    echo `tmux a`
#fi

# If you come from bash you might have to change your $PATH.
# macの場合
export PATH=$HOME/bin:/usr/local/bin:/opt/homebrew/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git autojump web-search zsh-autosuggestions tmux zsh-vi-mode)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# 戻す
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export ZSH_TMUX_AUTONAME_SESSION=true
export ZSH_AUTOCONNECT=false
if ! [[ -n $TERM_PROGRAM ]]; then
	export ZSH_TMUX_ITERM2=true
fi

source $ZSH/oh-my-zsh.sh
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# FORMAC SETTING

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases ここがmac用
if uname -a | grep -sq "Darwin"; then
	export PATH="$PATH:/Applications/platform-tools"
	export PATH="/opt/homebrew/bin:$PATH"

  export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
	#export PATH="$PATH:/Users/takuto/Programming/flutter/bin"

	# >>> conda initialize >>>
	# !! Contents within this block are managed by 'conda init' !!
	__conda_setup="$('/Users/takuto/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
	if [ $? -eq 0 ]; then
		eval "$__conda_setup"
	else
		if [ -f "/Users/takuto/opt/anaconda3/etc/profile.d/conda.sh" ]; then
			. "/Users/takuto/opt/anaconda3/etc/profile.d/conda.sh"
		else
			export PATH="/Users/takuto/opt/anaconda3/bin:$PATH"
		fi
	fi
	unset __conda_setup
	# <<< conda initialize <<<

	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completiosn" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

	# tmuxとitemの連携
	test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
	# <===ショートカット系
	function obsidian {
		open -a "Obsidian"
	}
	function pdf {
		zathura $1
	}
	#<--- VSCODEをcodeコマンドで開く
	function code {
		if [[ $# = 0 ]]
			then
			open -a "Visual Studio Code"
		else
			local argPath="$1"
			[[ $1 = /* ]] && argPath="$1" || argPath="$PWD/${1#./}"
			open -a "Visual Studio Code" "$argPath"
		fi
	}
	function lg {
		lazygit
	}
	#<--- Riderをcodeコマンドで開く
	function rider {
		if [[ $# = 0 ]]
			then
			open -a "Rider"
		else
			local argPath="$1"
			[[ $1 = /* ]] && argPath="$1" || argPath="$PWD/${1#./}"
			open -a "Rider" "$argPath"
		fi
	}
	function obs {
		cd "/Users/takuto/Library/Mobile Documents/iCloud~md~obsidian/Documents/main" 
		usleep 100
		vim "inbox/1Index.md"
	}
	function skhdcf {
		echo "show skhd config"
		vi ~/.config/skhd/skhdrc -R
	}
	#firebaseconfig
	export PATH="$PATH":"$HOME/.pub-cache/bin"

	#export CCACHE_SLOPPINESS=clang_index_store,file_stat_matches,include_file_ctime,include_file_mtime,ivfsoverlay,pch_defines,modules,system_headers,time_macros
	#export CCACHE_FILECLONE=true
	#export CCACHE_DEPEND=true
	#export CCACHE_INODECACHE=true
	#
	# エイリアスの設定 
	alias rustbook='open -a "Microsoft Edge" ~/Code/book-rust/book/index.html'
	
fi #MAC終わり

alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"


setopt auto_pushd
setopt pushd_ignore_dups
setopt auto_cd
setopt hist_ignore_dups
setopt inc_append_history


# HISTROY
export HISTFILE=~/.zsh_history # tmuxの自動起動
export HISTSIZE=100000         # alias tmux="tmux -u2"
export SAVEHIST=100000         # count=`ps aux | grep tmux | grep -v grep | wc -l`

# if test $count -eq 0; then
#     echo `tmux`
# elif test $count -eq 1; then
#     echo `tmux a`
# fi



# 一旦消す
#bindkey '^\' zsh_gh_copilot_explain  # bind Ctrl+\ to explain
#bindkey '^[' zsh_gh_copilot_suggest  # bind Alt+\ to suggest

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /Users/takuto/.dart-cli-completion/zsh-config.zsh ]] && . /Users/takuto/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]
export PATH=/Users/takuto/opt/anaconda3/bin:/Users/takuto/.nvm/versions/node/v20.15.0/bin:/opt/homebrew/bin:/Users/takuto/.autojump/bin:/Users/takuto/bin:/usr/local/bin:/opt/homebrew/bin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/Library/TeX/texbin:/usr/local/share/dotnet:~/.dotnet/tools:/usr/local/go/bin:/Users/takuto/.cargo/bin:/Applications/iTerm.app/Contents/Resources/utilities:/Applications/platform-tools:/Users/takuto/.pub-cache/bin:/Users/takuto/.dotnet/tools

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'
