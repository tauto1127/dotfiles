apt install zsh -y
chsh -s $(which zsh)
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
git clone https://github.com/powerline/fonts
cd fonts
./install.sh
cd ..

apt install neovim -y
ln -sf `pwd`/nvim ~/.config/
apt install tmux -y
