# dotfiles

## macOS

```bash
git clone https://github.com/tauto1127/dotfiles.git ~/Code/dotfiles
cd ~/Code/dotfiles
git submodule update --init fonts
bash installer.sh
```

`installer.sh` installs the shell essentials and shows separate `fzf`
multi-select menus for CLI tools and GUI applications. Use TAB to select or
clear an item and ENTER to confirm. `lazygit` is in the CLI menu and
`aerospace` is the supported window manager in the GUI menu.
`bash installer.sh -Y` selects every item for automated test runs.

After installing VS Code or Cursor, run `vscode_mac.sh` to select which editor
should receive the tracked settings and keybindings.

See [docs/installer.md](docs/installer.md) for the installation and
configuration policy.

The `Real macOS installer smoke` workflow can be started manually to verify
actual Homebrew installation of lazygit and AeroSpace on a fresh macOS runner.

## Debian / Ubuntu

- `aptInstall.sh`を実行
- nodejs手動
- 参考：https://tech.smartcamp.co.jp/entry/setup-by-dotfiles

# docker
https://hub.docker.com/repository/docker/takuto1127/dotfiles/general

linux/arm64,linux/amd64


# neovim
## alpha-nvim
https://github.com/goolord/alpha-nvim/discussions/16
アスキーアート https://github.com/goolord/alpha-nvim/discussions/16#discussioncomment-5501375
