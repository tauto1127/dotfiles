apt install zsh -y
chsh -s $(which zsh)
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
git clone https://github.com/powerline/fonts
cd fonts
./install.sh

zsh
apt install neovim -y
apt install tmux -y
