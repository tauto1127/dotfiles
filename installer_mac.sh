Y='\033[0;33m'
N='\033[0m'
BW='\033[47m'
BW_Y='\033[47;33m'
BY='\033[43m]'

set -e // エラーが起きた場合終了する

if !(type "brew" > /dev/null); then
	echo "${Y}install brew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

echo "${BY}install zsh and wget${N}"
brew install zsh
brew install wget

echo "${BY}install zsh plugins${N}"
set +e
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

brew install autojump

set zsh_custom_path=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-autosuggestions
git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-vi-mode

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/powerline/fonts
set 
cd fonts
./install.sh
cd ..
set -e

brew install neovim

brew install tmux

read -n1 -p "Do you want to install node-js? (y/N): " yn
if [[ $yn = [yY] ]]; then
	brew install nvm
	export NVM_DIR="$HOME/.nvm"
	[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
	nvm install --lts
fi

echo "${BY}install pyenv${N}"
brew install pyenv

echo "${BY}Install MacOS Applications${N}"
brew install --cask alt-tab
brew install --cask raycast
brew install --cask iterm2
brew install --cask wezterm
brew install --cask amethyst
brew install --cask cursor
brew install --cask adguard
brew install --cask obsidian
brew install --cask rize
brew install --cask zotero
brew install --cask nextcloud
brew install --cask discord
brew install --cask visual-studio-code
brew install --cask nextcloud
brew install --cask docker
brew install --cask tailscale
brew install --cask postman
brew install --cask slack
brew install --cask microsoft-edge
brew install --cask omnifocus
brew install --cask bitwarden
brew install --cask hammerspoon

brew install gh
brew install lazygit
brew install fvm
brew tap leoafarias/fvm
brew install fvm
brew install cocoapods

echo '${BY}Link dotfiles${N}'
bash _link.sh

echo "${BY}Authenticate GitHub${N}"
gh auth login

echo "Please run\n"
echo "chsh -s /bin/zsh\n"
echo "and re login"
