# dotfiles

Windows (Host), WSL (Ubuntu), および macOS の 3 環境を横断して管理するための設定リポジトリです。

## 📁 ディレクトリ構成

```text
.dotfiles/
├── common/                # OS共通設定
│   ├── .zshrc             # zsh設定（Mac/WSL分岐ロジック含む）
│   ├── .gitconfig         # Git共通設定（ユーザー情報・エイリアス）
│   └── .gitignore_global  # 全OS共通の無視設定
├── vscode/                # VS Code用設定
│   ├── extensions.txt     # 拡張機能リスト（Win/WSL/Mac統合版）
│   ├── settings.json      # エディタ設定（フォーマッタ・フォント等）
│   └── keybindings.json   # キーバインド設定
├── windows/               # Windows (Host) 専用
│   ├── install_apps.ps1   # Scoopを使ったアプリ一括インストール
│   └── setup.ps1          # Windows統合セットアップスクリプト
├── wsl/                   # WSL (Ubuntu 24.04) 専用
│   └── setup.sh           # OSアップデート, Docker, Shellの一括セットアップ
├── mac/                   # macOS 専用
│   └── Brewfile           # Homebrew パッケージリスト
└── scripts/               # 共通ユーティリティ
    └── link.sh            # Mac/WSL用シンボリックリンク作成スクリプト
```

---

## 🚀 セットアップ手順

環境ごとに以下の手順でセットアップを行ってください。

### 💻 Windows (Host)
1. PowerShell を管理者権限で開き、リポジトリ内の `windows/setup.ps1` を実行します。
   ```powershell
   cd ~/.dotfiles/windows
   ./setup.ps1
   ```
   - **VS Code 設定の自動反映**: `vscode/settings.json` を Windows 側の VS Code 設定ディレクトリ（`$env:APPDATA\Code\User\`）へ自動的にコピー・配置します。
   - **拡張機能の自動導入**: `vscode/extensions.txt` を読み込み、`code --install-extension` コマンドによって全拡張機能を自動で一括インストールします。

### 🐧 WSL (Ubuntu 24.04)

WSL環境では、OSのアップデート、必要なツールのインストール、設定ファイルの反映を以下の手順で行います。

1. **セットアップスクリプトの実行**
   ```bash
   cd ~/.dotfiles
   bash wsl/setup.sh
   ```
   - **内容**: OSアップデート、`curl`, `git`, `zsh` 等のツールインストール、`fnm`(Node.jsマネージャー)、`Docker Engine` のセットアップ、およびデフォルトシェルの `zsh` 変更。

2. **設定の反映**
   ```bash
   bash scripts/link.sh
   ```
   - **内容**: `.zshrc` 等のシンボリックリンク作成、および VS Code 拡張機能のインストール。

3. **VS Code について**
   - Windows 側で `setup.ps1` を実行済みであれば、VS Code の「Remote - WSL」拡張機能を通じて、Windows 側の設定や拡張機能の多くが自動的に WSL 側でも利用可能になります。

#### (検証用) 自動テストの実行
Dockerを使用して、Ubuntu (WSL) 環境でのセットアップスクリプトの動作を検証できます。

```bash
# イメージのビルド
docker build -t dotfiles-test tests

# テストの実行 (リポジリをマウントして実行)
docker run --rm -v $(pwd):/home/testuser/dotfiles dotfiles-test bash tests/run_tests.sh
```
成功すると `=== ALL TESTS PASSED ===` と表示されます。

### 🍎 macOS
1. Homebrew を使用してパッケージをインストールします。
   ```bash
   brew bundle --file mac/Brewfile
   ```
2. 共通リンクスクリプトを実行して、設定の反映と VS Code のセットアップを一括で行います。
   ```bash
   bash scripts/link.sh
   ```
   - **内容**: `.zshrc` 等のリンク作成、VS Code 設定ファイルの配置、拡張機能の自動インストールをすべて行います。

---

## 🛠 各コンポーネントの詳細

### 1. 共通設定 (`common/`)

- **[.zshrc](file:///Users/yuki/.dotfiles/common/.zshrc)**: Mac/WSL 自動判別。`update` や `o` (open) エイリアス、OSごとのプロンプト色分けを搭載。
- **[.gitconfig](file:///Users/yuki/.dotfiles/common/.gitconfig)**: Yuki Yoshida 名義の設定と便利なエイリアス、および共通無視設定の参照。
- **[.gitignore_global](file:///Users/yuki/.dotfiles/common/.gitignore_global)**: `.DS_Store`, `node_modules`, `.vscode` など全OS共通のクリーンアップ設定。

### 2. VS Code 設定 (`vscode/`)

- **[extensions.txt](file:///Users/yuki/.dotfiles/vscode/extensions.txt)**: Windows/WSL/Mac で必要な拡張機能を統合したリスト。
- **[settings.json](file:///Users/yuki/.dotfiles/vscode/settings.json)**: 保存時自動整形（Ruff/Prettier）、HackGen-NF フォント指定など。

---

## 💡 Tips
- **バックアップ**: `link.sh` および `setup.ps1` は、既存の設定ファイルを上書きする前に `.bak` 拡張子で自動的にバックアップを作成します。
