#!/bin/sh

ROOT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
set -eu

link_path() {
	local source="$1"
	local destination="$2"
	local backup

	if [ -e "$destination" ] && [ ! -L "$destination" ]; then
		backup="${destination}.dotfiles-backup-$(date +%Y%m%d%H%M%S)"
		mv "$destination" "$backup"
		echo "Moved existing $destination to $backup"
	fi

	ln -sfn "$source" "$destination"
}

# フォルダの作成
if [ ! -e "$HOME/.config" ]; then
	mkdir -p "$HOME/.config"
fi
# シンボリックリンクの作成
DOT_FILES=".zshrc .zprofile .tmux.conf .p10k.zsh .skhdrc .yabairc .aerospace.toml"
# .configフォルダー
CONFIGDOT_FOLDERS="nvim karabiner iterm2 yabai skhd wezterm mise lazygit"

#~/folder
DOT_FOLDERS=".hammerspoon"

for file in $DOT_FILES
do
	if [ -e "$ROOT_DIR/$file" ]; then
		link_path "$ROOT_DIR/$file" "$HOME/$file"
    fi
done

for folder in $CONFIGDOT_FOLDERS
do
	if [ -e "$ROOT_DIR/dot_folders/$folder" ]; then
		link_path "$ROOT_DIR/dot_folders/$folder" "$HOME/.config/$folder"
	fi
done

for folder in $DOT_FOLDERS
do
	if [ -e "$ROOT_DIR/dot_folders/$folder" ]; then
		link_path "$ROOT_DIR/dot_folders/$folder" "$HOME/$folder"
	fi
done

#ln -sf `pwd`/"nvim" ~/.config/
