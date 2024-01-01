/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"


brew install zsh

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-autosuggestions

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

git clone https://github.com/powerline/fonts
cd fonts
./install.sh
cd ..


brew install python3
brew install neovim

brew install tmux

: << 'COMMENT'
Write-Output "node-jsをインストールしますか？ (y or n)"
select sel in y n exit
do
	echo "$selが選択されました"
	if["$sel" = "y"]; then
		brew install nodebrew
		nodebrew setup
COMMENT

bash _link.sh

echo "Please run\n"
echo "chsh -s /bin/zsh\n"
echo "and re login"
