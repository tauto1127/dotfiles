# Installer and configuration policy

## Source of truth

`installer.sh` is the source of truth for software installation. `Brewfile` is
kept only as historical reference and is not used by the installer.

The installer always installs the shell bootstrap tools required to continue:
zsh, wget, git, autojump, curl, tmux, figlet, and fzf.

When Homebrew is installed during bootstrap, the installer evaluates the
Homebrew shell environment immediately so the same process can continue on
both Apple Silicon and Intel Macs.

## macOS software selection

After the bootstrap step, macOS shows two independent `fzf` multi-select menus.

### CLI tools

The CLI menu covers:

- Neovim
- lazygit
- mise
- Node.js through nvm
- pyenv
- GitHub CLI
- uv
- FVM
- CocoaPods

### GUI applications

The GUI menu covers the optional cask applications. AeroSpace is the supported
window manager. Amethyst is intentionally not offered.

In either menu, use the arrow keys to move, TAB to select or clear an item, and
ENTER to install the selected items. Selecting nothing is valid.

`bash installer.sh -Y` selects every CLI and GUI item. This mode is intended for
automated tests and should not be used for a minimal personal installation.

## Configuration links

`_link.sh` links the following configuration into the user's home directory:

- Shell, tmux, and Powerlevel10k files
- Neovim, Karabiner, yabai, skhd, WezTerm, mise, and lazygit directories
- Hammerspoon
- AeroSpace at `~/.aerospace.toml`

The AeroSpace configuration uses the official `config-version = 2` format and
vim-style focus/move bindings. AeroSpace and the legacy yabai/skhd bindings
should not be active at the same time when their shortcuts overlap.

VS Code or Cursor settings are linked separately by `vscode_mac.sh`, because
the user must choose which editor should receive them.

Application logins, tokens, app databases, and other machine state are not
stored in this repository.

If a real configuration file or directory already exists at a link destination,
`_link.sh` moves it to a timestamped `.dotfiles-backup-*` path before creating
the symlink. The old `installer_mac.sh` name is retained only as a compatibility
wrapper around `installer.sh`.

## Verification

`tests/installer/test-installer.sh` exercises both the Linux and macOS branches
with mocked package managers and checks the generated links. The GitHub Actions
workflow runs this test on `macos-latest` for every push and pull request.

The workflow deliberately does not install real cask applications or perform
interactive logins.

For an actual package-manager smoke test, run the manually triggered
`Real macOS installer smoke` workflow. It runs on a fresh GitHub macOS runner,
installs only lazygit and AeroSpace with Homebrew, and verifies the installed
binary, application bundle, and configuration links.
