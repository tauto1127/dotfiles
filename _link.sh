#!/bin/sh

# フォルダの作成
if [ ! -e $HOME/.config ];then
	mkdir $HOME/.config
fi
# シンボリックリンクの作成
DOT_FILES=".zshrc .zprofile .tmux.conf .p10k.zsh .skhdrc .yabairc"
# フォルダー
DOT_FOLDERS="nvim karabiner iterm2 yabai skhd"

for file in $DOT_FILES
do
    ln -sf `pwd`/$file ~
done

for folder in $DOT_FOLDERS
do
	ln -sf `pwd`/dot_folders/$folder ~/.config/
done

#ln -sf `pwd`/"nvim" ~/.config/

