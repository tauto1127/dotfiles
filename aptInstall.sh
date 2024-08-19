sudo apt install curl -y
sudo apt install wget -y
sudo apt install snapd -y
sudo apt install git -y
# ZSH INSTALL
sudo apt install zsh -y
chsh -s $(which zsh)
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
git clone https://github.com/powerline/fonts
cd fonts
./install.sh
cd ..

echo 'export SHELL=$(which zsh)' >> ~/.zshrc
source ~/.zshrc
export SHELL=$(which zsh)

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm ~/.zshrc
./_link.sh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-autosuggestions
git clone https://github.com/loiccoyle/zsh-github-copilot ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-github-copilot
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_CUSTOM/plugins/zsh-vi-mode

git clone git://github.com/wting/autojump.git
sh autojump/install.py


# NVIM INSTALL
sudo apt install git libtool automake cmake libncurses5-dev g++ gettext -y
git clone https://github.com/neovim/neovim.git
cd neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd ..

sudo apt install python3 -y

sudo apt install tmux -y

echo "Please run\n"
echo "chsh -s /bin/zsh\n"
echo "and re login"
