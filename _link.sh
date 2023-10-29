#!/bin/sh

# シンボリックリンクの作成
DOT_FILES=".zshrc .zprofile .oh-my-zsh .tmux.conf"
for file in $DOT_FILES
do
    ln -sf `pwd`/$file ~
done

