# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ANTHROPIC_API_KEY=

# If you come from bash you might have to change your $PATH.
export PATH=$PATH:$HOME/bin:/usr/local/bin:/opt/homebrew/bin

if [[ $TERM == xterm ]]; then
  export TERM=xterm-256color
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"

plugins=(git autojump web-search zsh-autosuggestions tmux zsh-vi-mode)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export ZSH_TMUX_AUTONAME_SESSION=true
export ZSH_AUTOCONNECT=false
if ! [[ -n $TERM_PROGRAM ]]; then
	export ZSH_TMUX_ITERM2=true
fi

source $ZSH/oh-my-zsh.sh

# ==============================================================================
# OS別分岐設定
# ==============================================================================
if uname -a | grep -sq "Darwin"; then
	export PATH="$PATH:$HOME/Library/Android/sdk/platform-tools"
	export PATH="$PATH:/opt/homebrew/bin"

	# inkscape
	export PATH="/Applications/Inkscape.app/Contents/MacOS:$PATH"

	# TeXLive
	export PATH="/usr/local/texlive/2025/bin/universal-darwin:$PATH"

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
		cd "$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/main" 
		sleep 0.5
		pwd
		nvim "inbox/1Index.md"
	}
	function skhdcf {
		echo "show skhd config"
		vi ~/.config/skhd/skhdrc -R
	}

	export PATH="$PATH:$HOME/.pub-cache/bin"

	# エイリアスの設定 
	alias rustbook='open -a "Microsoft Edge" ~/Code/book-rust/book/index.html'

	# openjdk用
	export SDKMAN_DIR=$(brew --prefix sdkman-cli 2>/dev/null || true)/libexec
	[[ -n "$SDKMAN_DIR" && -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
	. "$HOME/.local/bin/env" 2>/dev/null || true
	export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
	export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
	export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

	# macOS キーチェーン利用関数
	bws() {
		BWS_ACCESS_TOKEN="$(
			security find-generic-password \
				-a "$USER" \
				-s "bws-access-token" \
				-w
		)" command bws "$@"
	}

	# Dart CLI 補完
	[[ -f "$HOME/.dart-cli-completion/zsh-config.zsh" ]] && . "$HOME/.dart-cli-completion/zsh-config.zsh"

elif uname -a | grep -sq "Linux"; then
	# Linux 用設定があればここに記述
	:
fi 

# ==============================================================================
# mise (開発ツール環境統合マネージャー)
# ==============================================================================
eval "$(mise activate zsh)"

# エイリアス
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

# HISTORY
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000

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

# lego mind storms ev3
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/gcc-arm-none-eabi-5_4-2016q2/bin:$PATH
alias find="gfind"

# Google Cloud SDK
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# Docker CLI completions
fpath=($HOME/.docker/completions $fpath)

# Local bin (Antigravity CLI など)
export PATH="$HOME/.local/bin:$PATH"

# grok installer
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
