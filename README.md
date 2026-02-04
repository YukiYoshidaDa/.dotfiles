# dotfiles

Windows (Host), WSL (Ubuntu), および macOS の 3 環境で、**「同じ操作感」「同じツール」** を実現するための設定リポジトリです。
OSごとの差異を吸収しつつ、メンテナンスしやすい「機能別ディレクトリ構成」を採用しています。

## 🎯 コンセプト

*   **Hybrid Package Management**:
    *   **OS基盤**: OS標準のパッケージマネージャ (`apt`, `scoop`, `brew` core) で堅実に管理。
    *   **開発ツール**: 最新機能が必要な CLI ツール (`starship`, `mise`, `bat` 等) は `Homebrew` で一元管理（WSL/Mac共通）。
*   **Symmetrical Architecture**:
    *   Mac/Linux (`.sh`) と Windows (`.ps1`) で、完全に同じ構造・役割分担のスクリプトを提供。

## 📁 ディレクトリ構成

役割ごとにディレクトリを分割しています。

```text
.
├── setup.sh                 # [Mac/WSL] 統合セットアップ（これを実行するだけ）
├── setup.ps1                # [Windows] 統合セットアップ（これを実行するだけ）
├── common/                  # OS共通の設定 (Brewfile, .zshrc, .gitconfig)
├── vscode/                  # VS Code / Antigravity 機能モジュール
│   ├── settings.json        # 共通設定ファイル
│   ├── install_extensions.sh  # [Mac/WSL] 拡張機能インストーラー
│   └── install_extensions.ps1 # [Windows] 拡張機能インストーラー
├── scripts/                 # ヘルパー (リンク作成ロジック等)
│   ├── link.sh              # [Mac/WSL] シンボリックリンク作成
│   └── link.ps1             # [Windows] シンボリックリンク作成
├── windows/                 # [Windows] OS依存インストーラー (Scoop)
├── mac/                     # [Mac] OS依存インストーラー (Homebrew)
└── wsl/                     # [WSL] OS依存インストーラー (Apt/Brew)
```

---

## 🚀 セットアップ手順

どの環境でも、**ルートにある `setup` スクリプトを一回実行するだけ** で完了します。

### 💻 Windows (Host)
PowerShell を「管理者権限」で開き、以下のコマンドを実行します。

```powershell
cd ~/.dotfiles
./setup.ps1
```

### 🐧 WSL (Ubuntu) & 🍎 macOS
ターミナルを開き、以下のコマンドを実行します。

```bash
cd ~/.dotfiles
bash setup.sh
```

### 何が行われるか？
1.  **OS依存ツールのインストール**: `git`, `zsh`, `brew` などを自動インストール。
2.  **共通CLIツールのインストール**: `common/Brewfile` に定義されたツール (`starship`, `eza` 等) を導入。
3.  **設定ファイルのリンク**: `.zshrc`, `.gitconfig` などのシンボリックリンクを作成。
4.  **VS Code 設定**: 設定ファイルの配布と、拡張機能の自動インストール。

---

## 🛠 メンテナンス・カスタマイズ

### ツールを追加したい場合
*   **共通のCLIツール (bat, fzf等)**: `common/Brewfile` に追記してください。
*   **MacのGUIアプリ**: `mac/Brewfile` に追記してください。
*   **Windowsのアプリ**: `windows/install.ps1` のリストを編集してください。

### 設定を更新した場合
設定ファイルを変更したり、`Brewfile` を更新した後は、再度 `setup` スクリプトを実行すれば反映されます（冪等性があります）。

---

## 🛠 各コンポーネントの詳細

### Antigravity / VS Code 対応
本リポジトリは、**Antigravity** に完全対応しています。
VS Code用の設定 (`vscode/`) は、Antigravity (`bin: agy`) に対しても自動的に適用されます。

### シェル (Zsh & Starship)
*   **Zsh**: 全OSで Zsh をデフォルトシェルとして採用。
*   **Starship**: 高速・高機能なプロンプトを導入済み。`common/starship.toml` で設定可能。
*   **Mise**: 言語バージョン管理 (`node`, `python`, `go`) は `mise` で統一管理。

### バックアップ
`setup.sh` / `setup.ps1` は、既存の設定ファイルを上書きする前に、自動的に `.bak` ファイルとしてバックアップを作成します。安心して実行してください。
