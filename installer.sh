#!/bin/bash
Y='\033[0;33m'
N='\033[0m'
BY='\033[43m]'

set -e
# apt, brew(mac)
PkgType=''

function installShellEssentials() {
    set +e
    if [[ $PkgType == 'brew' ]]; then
        if ! (type "brew" >/dev/null); then
            echo "${Y}install brew"
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        fi
    fi

    echo "${BY}install zsh and wget${N}"
    Packages=(zsh wget git autojump curl tmux figlet)
    if [[ $PkgType == 'brew' ]]; then
        brew install "${Packages[@]}"
    elif [[ "$PkgType" == 'apt' || "$PkgType" == 'apt' ]]; then
        sudo apt install "${Packages[@]}" -y
    fi
    set -e
}

function installZshPlugins() {
    set +e

    echo "${BY}install zsh plugins${N}"

    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}"/plugins/zsh-autosuggestions
    git clone --depth=1 https://github.com/jeffreytse/zsh-vi-mode "${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}"/plugins/zsh-vi-mode
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k
    git clone --depth=1 https://github.com/powerline/fonts

    cd fonts
    ./install.sh
    cd ..

    set -e
}

function installEditors() {
    set +e

    echo "${BY}install neovim${N}"
    if [[ "$PkgType" == 'brew' ]]; then
        brew install neovim
        brew install lazygit
    elif [[ $PkgType == 'apt' || $PkgType == 'apt' ]]; then
        apt install neovim -y

        # install lazygit
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit -D -t /usr/local/bin/
    fi
}

function installFlutterEnvironment() {
    set +e

    echo "${BY}install flutter${N}"
    if [[ $PkgType == 'brew' ]]; then
        brew tap leoafarias/fvm
        brew install fvm
        brew install cocoapods
    elif [[ $PkgType == 'apt' || $PkgType == 'apt' ]]; then
        curl -fsSL https://fvm.app/install.sh | bash
    fi
}

function installNodeJs() {
    read -r -n1 -p "Do you want to install node-js? (y/N): " yn
    if [[ $yn = [yY] ]]; then
        if [[ $PkgType == 'brew' ]]; then
            brew install nvm

            nvm install --lts
        elif [[ $PkgType == 'apt' || $PkgType == 'apt' ]]; then
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash

            nvm install --lts
        fi
    fi
}

function installMacApps() {
    declare -A macApps=(
        ["alt-tab"]=""
        ["raycast"]=""
        ["iterm2"]=""
        ["wezterm"]=""
        ["amethyst"]=""
        ["cursor"]=""
        ["adguard"]=""
        ["obsidian"]=""
        ["rize"]=""
        ["zotero"]=""
        ["nextcloud"]=""
        ["discord"]=""
        ["visual-studio-code"]=""
        ["docker"]=""
        ["tailscale"]="VPN"
        ["postman"]="API検証に便利なツール"
        ["slack"]=""
        ["microsoft-edge"]="推しブラウザ"
        ["omnifocus"]=""
        ["bitwarden"]=""
        ["hammerspoon"]="グローバルショートカット作るのに使う"
        ["zed"]=""
        ["kobo"]=""
    )

    for app in "${!macApps[@]}"; do
        echo -e "${BY}Installing ${app} - ${macApps[$app]}${N}"
        brew install --cask "$app"
    done
}

function init() {
    installShellEssentials
    installZshPlugins

    read -n1 -r -p "開発環境をインストールしますか？ (y/N): " yn
    if [[ $yn = [yY] ]]; then
        installEditors
    fi

    read -n1 -r -p "Node.jsをインストールしますか？ (y/N): " yn
    if [[ $yn = [yY] ]]; then
        installNodeJs
    fi

    read -n1 -r -p "Pyenvをインストールしますか？ (y/N): " yn
    if [[ $yn = [yY] ]]; then
        if [[ "$PkgType" == 'brew' ]]; then
            brew install pyenv
        elif [[ $PkgType == 'apt' || $PkgType == 'apt' ]]; then
            curl -fsSL https://pyenv.run | bash
        fi
    fi

    read -n1 -r -p "アプリケーションをインストールしますか？ (y/N): " yn
    if [[ $yn = [yY] ]]; then
        if [[ $PkgType == 'brew' ]]; then
            installMacApps
        fi
    fi

    read -n1 -r -p "Ghをインストールしますか？ (y/N): " yn
    if [[ $yn = [yY] ]]; then
        if [[ $PkgType == 'brew' ]]; then
            brew install gh
            gh auth login
        elif [[ $PkgType == 'apt' || $PkgType == 'apt' ]]; then
            sudo apt install gh -y
            gh auth login
        fi
    fi

    echo "${BY}Link dotfiles${N}"
    bash _link.sh

    figlet WELCOME
    echo "Please run ${Y}"
    echo "chsh -s /bin/zsh${N}"
    echo "and re login!"
}

# エントリーポイント
if [[ "$(uname -s)" == "Darwin" ]]; then
    PkgType='brew'
    init
elif [[ "$(uname -s)" == "Linux" ]]; then
    # Linux の場合、さらに /etc/os-release を利用して Ubuntu か Debian かを判定
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        if [[ "$ID" == "ubuntu" ]]; then
            PkgType='apt'
            init
        elif [[ "$ID" == "debian" ]]; then
            PkgType='apt'
            init
        else
            echo "Unsupported Linux distribution: $ID"
        fi
    else
        echo "ディストリビューションの判定ができませんでした。"
    fi
else
    echo "Unsupported Linux distribution: $ID"
fi
