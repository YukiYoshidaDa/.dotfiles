# Dotfiles (Modernized with chezmoi)

## 概要
このリポジトリは `chezmoi` を使用して、Mac, WSL, Windows の設定を一元管理しています。
VSCode から Neovim への移行、および Scoop から winget への移行を含む、シンプルでモダンな構成を目指しています。

## 🚀 セットアップ手順

### 1. chezmoi のインストール
各OSのパッケージマネージャーでインストールしてください。

- **macOS / WSL:** `brew install chezmoi`
- **Windows:** `winget install chezmoi`

### 2. 設定の反映
ターミナル (PowerShell または bash) を開き、以下のコマンドを実行します。

```bash
# chezmoi にこのディレクトリをソースとして登録
chezmoi init --source ~/.dotfiles

# 差分を確認 (任意)
chezmoi diff

# 設定を適用 (設定ファイルの配置 + アプリの自動インストール)
chezmoi apply
```

## 🛠️ 主な構成
- **Shell:** Zsh (最小限の構成 + autosuggestions + syntax-highlighting)
- **Prompt:** Minimalist (Starship 未使用、必要に応じて後で追加)
- **Editor:** Neovim (LazyVim ベース)
- **Manager:** chezmoi
- **Package Managers:** Homebrew (Mac/Linux), winget (Windows)

## 📂 ディレクトリ構造
- `/` : chezmoi のソースファイル (`dot_` で始まるファイル)
- `docs/` : 移行プランやタスクリスト
- `legacy/` : 以前の構成（VSCode設定など）のバックアップ
