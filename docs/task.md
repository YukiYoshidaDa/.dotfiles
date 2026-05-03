# Dotfiles 再構築タスクリスト

## [x] Phase 1: chezmoi の基礎構築
- [x] chezmoi のインストール
- [x] chezmoi の初期化と基本ディレクトリ構成の作成
- [ ] `.chezmoiignore` の設定

## [/] Phase 2: Zsh & ターミナル環境のリセット
- [x] 最小限の `.zshrc.tmpl` の作成
- [x] エイリアスの整理と移行（`ls` -> `eza`）
- [x] 必須プラグイン（autosuggestions, syntax-highlighting）の設定
- [x] モダンCLIツール（mise, zoxide, fzf）の初期化設定
- [ ] **実際の環境への適用 (apply)**


## [ ] Phase 3: Neovim (LazyVim) の導入
- [ ] Neovim のインストール
- [ ] LazyVim スターター設定の配置 (`~/.config/nvim`)
- [ ] `ripgrep`, `fd` が正常に Neovim から使えているか確認

## [ ] Phase 4: パッケージ管理の自動化
- [ ] Mac 用: `Brewfile` の整理と自動化スクリプト作成
- [ ] Windows 用: `winget` インストールスクリプトの作成（Scoopからの移行）

## [ ] Phase 5: フォント & 仕上げ
- [ ] JetBrains Mono NF または UDEV Gothic NF の導入サポート
- [ ] 全体の動作確認 (Mac / WSL / Windows)
- [ ] 新しい README の作成
