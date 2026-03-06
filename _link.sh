#!/bin/sh

ROOT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)

# フォルダの作成
if [ ! -e "$HOME/.config" ]; then
	mkdir -p "$HOME/.config"
fi
# シンボリックリンクの作成
DOT_FILES=".zshrc .zprofile .tmux.conf .p10k.zsh .skhdrc .yabairc"
# .configフォルダー
CONFIGDOT_FOLDERS="nvim karabiner iterm2 yabai skhd wezterm"

#~/folder
DOT_FOLDERS=".hammerspoon"

for file in $DOT_FILES
do
    if [ -e "$ROOT_DIR/$file" ]; then
        ln -sf "$ROOT_DIR/$file" "$HOME/"
    fi
done

for folder in $CONFIGDOT_FOLDERS
do
	if [ -e "$ROOT_DIR/dot_folders/$folder" ]; then
		ln -sf "$ROOT_DIR/dot_folders/$folder" "$HOME/.config/"
	fi
done

for folder in $DOT_FOLDERS
do
	if [ -e "$ROOT_DIR/dot_folders/$folder" ]; then
		ln -sf "$ROOT_DIR/dot_folders/$folder" "$HOME/"
	fi
done

#ln -sf `pwd`/"nvim" ~/.config/
