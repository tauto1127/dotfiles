#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

copy_fixture() {
  local destination="$1"
  mkdir -p "$destination"
  (
    cd "$ROOT_DIR"
    tar --exclude='./dot_folders/iterm2/sockets' -cf - .
  ) | (
    cd "$destination"
    tar -xf -
  )

  chmod +x "$destination/tests/installer/mock-bin/"*
  chmod +x "$destination/tests/installer/test-installer.sh"
  cat > "$destination/fonts/install.sh" <<'EOF'
#!/usr/bin/env bash
exit 0
EOF
  chmod +x "$destination/fonts/install.sh"
}

assert_contains() {
  local log_file="$1"
  local expected="$2"
  if ! grep -F "$expected" "$log_file" >/dev/null 2>&1; then
    echo "assertion failed: missing log -> $expected"
    echo "----- log -----"
    cat "$log_file"
    exit 1
  fi
}

assert_not_contains() {
  local log_file="$1"
  local unexpected="$2"
  if grep -F "$unexpected" "$log_file" >/dev/null 2>&1; then
    echo "assertion failed: unexpected log -> $unexpected"
    echo "----- log -----"
    cat "$log_file"
    exit 1
  fi
}

assert_symlink() {
  local path="$1"
  if [[ ! -L "$path" ]]; then
    echo "assertion failed: not symlink -> $path"
    exit 1
  fi
}

run_linux_test() {
  local work_dir="$TMP_DIR/linux-work"
  local home_dir="$TMP_DIR/linux-home"
  local log_file="$TMP_DIR/linux-commands.log"
  local os_release_file="$TMP_DIR/linux-os-release"

  copy_fixture "$work_dir"
  mkdir -p "$home_dir/.config"
  : > "$log_file"
  cat > "$os_release_file" <<'EOF'
ID=ubuntu
EOF

  (
    cd "$work_dir"
    export HOME="$home_dir"
    export TEST_LOG_FILE="$log_file"
    export PATH="$work_dir/tests/installer/mock-bin:$PATH"
    export UNAME_OVERRIDE="Linux"
    export OS_RELEASE_FILE="$os_release_file"
    export NVIM_INSTALL_DIR="$home_dir/.local/opt"
    export NVIM_BIN_DIR="$home_dir/.local/bin"
    unset ZSH ZSH_CUSTOM
    bash ./installer.sh -Y
  )

  assert_contains "$log_file" "sudo apt install zsh wget git autojump curl tmux figlet fzf -y"
  assert_contains "$log_file" "wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
  assert_contains "$log_file" "curl -fLo"
  assert_contains "$log_file" "nvim-linux-"
  assert_contains "$log_file" "sudo apt install gh -y"
  assert_contains "$log_file" "curl -LsSf https://astral.sh/uv/install.sh"
  assert_contains "$log_file" "nvm install --lts"
  assert_contains "$log_file" "figlet WELCOME"

  assert_symlink "$home_dir/.zshrc"
  assert_symlink "$home_dir/.config/nvim"
  assert_symlink "$home_dir/.config/lazygit"
  assert_symlink "$home_dir/.aerospace.toml"
  if [[ ! -x "$home_dir/.local/bin/nvim" ]]; then
    echo "assertion failed: expected installed nvim binary"
    exit 1
  fi
  if [[ -e "$home_dir/.zprofile" || -L "$home_dir/.zprofile" ]]; then
    echo "assertion failed: unexpected .zprofile symlink"
    exit 1
  fi
}

run_macos_test() {
  local work_dir="$TMP_DIR/macos-work"
  local home_dir="$TMP_DIR/macos-home"
  local log_file="$TMP_DIR/macos-commands.log"

  copy_fixture "$work_dir"
  mkdir -p "$home_dir/.config"
  : > "$log_file"

  (
    cd "$work_dir"
    export HOME="$home_dir"
    export TEST_LOG_FILE="$log_file"
    export PATH="$work_dir/tests/installer/mock-bin:$PATH"
    export UNAME_OVERRIDE="Darwin"
    unset ZSH ZSH_CUSTOM
    bash ./installer.sh -Y
  )

  assert_contains "$log_file" "brew install zsh wget git autojump curl tmux figlet fzf"
  assert_contains "$log_file" "brew install nvm"
  assert_contains "$log_file" "brew --prefix nvm"
  assert_contains "$log_file" "brew install neovim"
  assert_contains "$log_file" "brew install lazygit"
  assert_contains "$log_file" "brew install mise"
  assert_contains "$log_file" "brew install pyenv"
  assert_contains "$log_file" "brew tap leoafarias/fvm"
  assert_contains "$log_file" "brew install fvm"
  assert_contains "$log_file" "brew install cocoapods"
  assert_contains "$log_file" "brew install --cask aerospace"
  assert_contains "$log_file" "brew install --cask alt-tab"
  assert_contains "$log_file" "brew install --cask spotify"
  assert_contains "$log_file" "brew install gh"
  assert_contains "$log_file" "nvm install --lts"
  assert_not_contains "$log_file" "gh auth login"
  assert_not_contains "$log_file" "brew install --cask amethyst"
}

run_selection_test() {
  local work_dir="$TMP_DIR/selection-work"
  local home_dir="$TMP_DIR/selection-home"
  local log_file="$TMP_DIR/selection-commands.log"

  copy_fixture "$work_dir"
  mkdir -p "$home_dir/.config"
  : > "$log_file"

  (
    cd "$work_dir"
    export HOME="$home_dir"
    export TEST_LOG_FILE="$log_file"
    export PATH="$work_dir/tests/installer/mock-bin:$PATH"
    export FZF_BIN=fzf
    export UNAME_OVERRIDE="Unsupported"
    export ID=unsupported
    export FZF_SELECTION="lazygit,mise"
    source ./installer.sh
    PkgType='brew'
    AUTO_YES=false
    installMacCliSoftware
    export FZF_SELECTION="aerospace"
    installMacGuiSoftware
  )

  assert_contains "$log_file" "brew install lazygit"
  assert_contains "$log_file" "brew install mise"
  assert_contains "$log_file" "brew install --cask aerospace"
  assert_not_contains "$log_file" "brew install neovim"
  assert_not_contains "$log_file" "brew install --cask alt-tab"
}

run_noninteractive_selection_test() {
  local work_dir="$TMP_DIR/noninteractive-work"
  local home_dir="$TMP_DIR/noninteractive-home"
  local log_file="$TMP_DIR/noninteractive-commands.log"

  copy_fixture "$work_dir"
  mkdir -p "$home_dir/.config"
  : > "$log_file"

  (
    cd "$work_dir"
    export HOME="$home_dir"
    export TEST_LOG_FILE="$log_file"
    export PATH="$work_dir/tests/installer/mock-bin:$PATH"
    export UNAME_OVERRIDE="Darwin"
    export DOTFILES_NONINTERACTIVE=true
    export DOTFILES_CLI_SELECTION=lazygit
    export DOTFILES_GUI_SELECTION=aerospace
    bash ./installer.sh
  )

  assert_contains "$log_file" "brew install lazygit"
  assert_contains "$log_file" "brew install --cask aerospace"
  assert_not_contains "$log_file" "brew install neovim"
  assert_not_contains "$log_file" "brew install --cask alt-tab"
}

run_link_backup_test() {
  local work_dir="$TMP_DIR/link-work"
  local home_dir="$TMP_DIR/link-home"

  copy_fixture "$work_dir"
  mkdir -p "$home_dir/.config/lazygit"
  printf '%s\n' 'old config' > "$home_dir/.config/lazygit/config.yml"

  (
    cd "$work_dir"
    export HOME="$home_dir"
    bash ./_link.sh
  )

  assert_symlink "$home_dir/.config/lazygit"
  if ! compgen -G "$home_dir/.config/lazygit.dotfiles-backup-*" >/dev/null; then
    echo "assertion failed: lazygit config backup was not created"
    exit 1
  fi
}

run_selection_test
run_noninteractive_selection_test
run_link_backup_test
run_linux_test
run_macos_test

echo "installer.sh tests passed"
