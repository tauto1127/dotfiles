#!/bin/sh

# フォルダの作成
if [ ! -e $HOME/.config ];then
	mkdir $HOME/.config
fi
# シンボリックリンクの作成
DOT_FILES=".zshrc .zprofile .tmux.conf .p10k.zsh"
for file in $DOT_FILES
do
    ln -sf `pwd`/$file ~
done

ln -sf `pwd`/"nvim" ~/.config/

