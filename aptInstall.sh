sudo apt install zsh -y
chsh -s $(which zsh)
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
git clone https://github.com/powerline/fonts
cd fonts
./install.sh
cd ..

sudo apt install neovim -y
ln -sf `pwd`/nvim ~/.config/
sudo apt install tmux -y
