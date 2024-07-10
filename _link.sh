#!/bin/sh

# フォルダの作成
if [ ! -e $HOME/.config ];then
	mkdir $HOME/.config
fi
# シンボリックリンクの作成
DOT_FILES=".zshrc .zprofile .tmux.conf .p10k.zsh .skhdrc .yabairc"
# .configフォルダー
CONFIGDOT_FOLDERS="nvim karabiner iterm2 yabai skhd wezterm"

#~/folder
DOT_FOLDERS=".hammerspoon"

for file in $DOT_FILES
do
    ln -sf `pwd`/$file ~
done

for folder in $CONFIGDOT_FOLDERS
do
	ln -sf `pwd`/dot_folders/$folder ~/.config/
done

for folder in $DOT_FOLDERS
do
	ln -sf `pwd`/dot_folders/$folder ~
done

#ln -sf `pwd`/"nvim" ~/.config/

