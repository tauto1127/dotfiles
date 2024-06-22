sudo apt install curl -y
sudo apt install wget -y
sudo apt install snapd -y
# ZSH INSTALL
sudo apt install zsh -y
chsh -s $(which zsh)
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
git clone https://github.com/powerline/fonts
cd fonts
./install.sh
cd ..

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
./_link.sh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-autosuggestions
git clone https://github.com/loiccoyle/zsh-github-copilot ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-github-copilot
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

git clone git://github.com/wting/autojump.git
sh autojump/install.py


# NVIM INSTALL
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage --appimage-extract
./squashfs-root/AppRun --version
sudo mv squashfs-root /
sudo ln -s /squashfs-root/AppRun /usr/bin/nvim

sudo apt install python3 -y

sudo apt install tmux -y

echo "Please run\n"
echo "chsh -s /bin/zsh\n"
echo "and re login"
