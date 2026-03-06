#!/bin/bash
Y='\033[0;33m'
N='\033[0m'
BY='\033[43m]'

set -e
# apt, brew(mac)
PkgType=''
AUTO_YES=false
OS_RELEASE_FILE="${OS_RELEASE_FILE:-/etc/os-release}"
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_INSTALL_DIR="${NVIM_INSTALL_DIR:-/opt}"
NVIM_BIN_DIR="${NVIM_BIN_DIR:-/usr/local/bin}"

# コマンドライン引数の処理
while getopts "Y" opt; do
  case $opt in
    Y)
      AUTO_YES=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

function current_uname() {
    if [[ -n "${UNAME_OVERRIDE:-}" ]]; then
        echo "$UNAME_OVERRIDE"
    else
        uname -s
    fi
}

function loadNvm() {
    export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

    if [[ "$PkgType" == 'brew' ]] && command -v brew >/dev/null 2>&1; then
        local brew_prefix
        brew_prefix="$(brew --prefix nvm 2>/dev/null || true)"
        if [[ -n "$brew_prefix" && -s "$brew_prefix/nvm.sh" ]]; then
            # shellcheck disable=SC1090
            . "$brew_prefix/nvm.sh"
        fi
    fi

    if ! command -v nvm >/dev/null 2>&1 && [[ -s "$NVM_DIR/nvm.sh" ]]; then
        # shellcheck disable=SC1090
        . "$NVM_DIR/nvm.sh"
    fi

    command -v nvm >/dev/null 2>&1
}

function detectLinuxArch() {
    case "$(uname -m)" in
        x86_64|amd64)
            echo "x86_64"
            ;;
        aarch64|arm64)
            echo "arm64"
            ;;
        *)
            echo "Unsupported architecture: $(uname -m)" >&2
            return 1
            ;;
    esac
}

function installNeovimLinux() {
    local arch
    local archive_base
    local archive_name
    local download_url
    local temp_dir

    arch="$(detectLinuxArch)"
    archive_base="nvim-linux-${arch}"
    archive_name="${archive_base}.tar.gz"
    download_url="https://github.com/neovim/neovim/releases/latest/download/${archive_name}"
    temp_dir="$(mktemp -d)"

    curl -fLo "${temp_dir}/${archive_name}" "$download_url"
    tar -xzf "${temp_dir}/${archive_name}" -C "$temp_dir"

    sudo mkdir -p "$NVIM_INSTALL_DIR" "$NVIM_BIN_DIR"
    sudo rm -rf "${NVIM_INSTALL_DIR:?}/${archive_base}"
    sudo mv "${temp_dir}/${archive_base}" "${NVIM_INSTALL_DIR}/${archive_base}"
    sudo ln -sf "${NVIM_INSTALL_DIR}/${archive_base}/bin/nvim" "${NVIM_BIN_DIR}/nvim"

    rm -rf "$temp_dir"
}

function installShellEssentials() {
    if [[ $PkgType == 'brew' ]]; then
        if ! command -v brew >/dev/null 2>&1; then
            echo "${Y}install brew"
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" --unattended
            # unattendedでインストールすると，確認が出なくなる
        fi
    fi

    echo "${BY}install zsh and wget${N}"
    local packages=(zsh wget git autojump curl tmux figlet)
    if [[ $PkgType == 'brew' ]]; then
        brew install "${packages[@]}"
    elif [[ "$PkgType" == 'apt' ]]; then
        sudo apt install "${packages[@]}" -y
    fi
}

function installZshPlugins() {
    echo "${BY}install zsh plugins${N}"
    local oh_my_zsh_dir="${ZSH:-$HOME/.oh-my-zsh}"
    local zsh_custom="${ZSH_CUSTOM:-$oh_my_zsh_dir/custom}"
    local fonts_install_script="$SCRIPT_DIR/fonts/install.sh"

    if [[ ! -d "$oh_my_zsh_dir" ]]; then
        RUNZSH=no CHSH=no KEEP_ZSHRC=yes ZSH="$oh_my_zsh_dir" \
            sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    mkdir -p "$zsh_custom/plugins" "$zsh_custom/themes"

    if [[ ! -d "$zsh_custom/plugins/zsh-autosuggestions" ]]; then
        git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom/plugins/zsh-autosuggestions"
    fi

    if [[ ! -d "$zsh_custom/plugins/zsh-vi-mode" ]]; then
        git clone --depth=1 https://github.com/jeffreytse/zsh-vi-mode "$zsh_custom/plugins/zsh-vi-mode"
    fi

    if [[ ! -d "$zsh_custom/themes/powerlevel10k" ]]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$zsh_custom/themes/powerlevel10k"
    fi

    if [[ -x "$fonts_install_script" ]]; then
        "$fonts_install_script"
    else
        echo "Missing fonts installer: $fonts_install_script" >&2
        return 1
    fi
}

function installEditors() {
    echo "${BY}install neovim${N}"
    if [[ "$PkgType" == 'brew' ]]; then
        brew install neovim
        brew install lazygit
    elif [[ "$PkgType" == 'apt' ]]; then
        installNeovimLinux

        # install lazygit
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | sed -n 's/.*"tag_name": *"v\([^"]*\)".*/\1/p')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit -D -t /usr/local/bin/
    fi
}

function installFlutterEnvironment() {
    echo "${BY}install flutter${N}"
    if [[ $PkgType == 'brew' ]]; then
        brew tap leoafarias/fvm
        brew install fvm
        brew install cocoapods
    elif [[ "$PkgType" == 'apt' ]]; then
        curl -fsSL https://fvm.app/install.sh | bash
    fi
}

function installNodeJs() {
    export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"

    if [[ "$PkgType" == 'brew' ]]; then
        mkdir -p "$NVM_DIR"
        brew install nvm
    elif [[ "$PkgType" == 'apt' ]]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
    fi

    if ! loadNvm; then
        echo "Failed to load nvm after installation." >&2
        return 1
    fi
    
    nvm install --lts
}

function installUv() {
  # On macOS and Linux.
  curl -LsSf https://astral.sh/uv/install.sh | sh
}

function installMacApps() {
    local macApps=(
        "alt-tab|"
        "raycast|"
        "iterm2|"
        "wezterm|"
        "amethyst|"
        "cursor|"
        "adguard|"
        "obsidian|"
        "rize|"
        "zotero|"
        "nextcloud|"
        "discord|"
        "visual-studio-code|"
        "docker|"
        "tailscale|VPN"
        "postman|API検証に便利なツール"
        "slack|"
        "microsoft-edge|推しブラウザ"
        "omnifocus|"
        "bitwarden|"
        "hammerspoon|グローバルショートカット作るのに使う"
        "zed|"
        "kobo|"
        "spotify|"
    )
    local app
    local description
    local entry

    for entry in "${macApps[@]}"; do
        app="${entry%%|*}"
        description="${entry#*|}"
        if [[ -n "$description" ]]; then
            echo -e "${BY}Installing ${app} - ${description}${N}"
        else
            echo -e "${BY}Installing ${app}${N}"
        fi
        brew install --cask "$app"
    done
}

function promptYesNo() {
    local prompt=$1
    local yn
    if [[ $AUTO_YES == true ]]; then
        return 0  # 自動的にYesを返す
    fi
    
    read -r -n1 -p "$prompt" yn
    echo ""
    if [[ $yn = [yY] ]]; then
        return 0 
    else
        return 1
    fi
}

function init() {
    installShellEssentials
    installZshPlugins

    if [[ $AUTO_YES == true ]] || promptYesNo "開発環境をインストールしますか？ (y/N): "; then
        installEditors
    fi

    if [[ $AUTO_YES == true ]] || promptYesNo "Node.jsをインストールしますか？ (y/N): "; then
        installNodeJs
    fi

    if [[ $AUTO_YES == true ]] || promptYesNo "Pyenvをインストールしますか？ (y/N): "; then
        if [[ "$PkgType" == 'brew' ]]; then
            brew install pyenv
        elif [[ "$PkgType" == 'apt' ]]; then
            curl -fsSL https://pyenv.run | bash
        fi
    fi

    if [[ $AUTO_YES == true ]] || promptYesNo "アプリケーションをインストールしますか？ (y/N): "; then
        if [[ $PkgType == 'brew' ]]; then
            installMacApps
        fi
    fi

    if [[ $AUTO_YES == true ]] || promptYesNo "Ghをインストールしますか？ (y/N): "; then
        if [[ $PkgType == 'brew' ]]; then
            brew install gh
            if [[ $AUTO_YES == false ]]; then
                gh auth login
            fi
        elif [[ "$PkgType" == 'apt' ]]; then
            sudo apt install gh -y
            if [[ $AUTO_YES == false ]]; then
                gh auth login
            fi
        fi
    fi

    if [[ $AUTO_YES == true ]] || promptYesNo "uvをインストールしますか？ (y/N): "; then
        installUv
    fi

    echo "${BY}Link dotfiles${N}"
    bash "$SCRIPT_DIR/_link.sh"

    figlet WELCOME
    echo "Please run ${Y}"
    echo "chsh -s /bin/zsh${N}"
    echo "and re login!"
}

# エントリーポイント
if [[ "$(current_uname)" == "Darwin" ]]; then
    PkgType='brew'
    init
elif [[ "$(current_uname)" == "Linux" ]]; then
    # Linux の場合、さらに /etc/os-release を利用して Ubuntu か Debian かを判定
    if [ -f "$OS_RELEASE_FILE" ]; then
        source "$OS_RELEASE_FILE"
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
