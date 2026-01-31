# dotfiles

Windows (Host), WSL (Ubuntu), および macOS の 3 環境を横断して管理するための設定リポジトリです。

## 📁 ディレクトリ構成

```text
.dotfiles/
├── setup.sh               # 全OS共通の一撃セットアップスクリプト
├── common/                # OS共通設定
│   ├── .zshrc             # zshエントリーポイント
│   ├── .gitconfig         # Git共通設定
│   ├── .gitignore_global  # 全OS共通の無視設定
│   └── zsh/               # zsh設定モジュール
│       ├── aliases.zsh    # エイリアス (eza, git, docker等)
│       ├── plugins.zsh    # プラグイン読み込みロジック
│       └── utils.zsh      # OS判別・プロンプト設定
├── vscode/                # VS Code用設定
│   ├── extensions.txt     # 拡張機能リスト（Win/WSL/Mac統合版）
│   ├── settings.json      # エディタ設定
│   └── keybindings.json   # キーバインド設定
├── windows/               # Windows (Host) 専用
│   ├── install_apps.ps1   # Scoopを使ったアプリ一括インストール
│   └── setup.ps1          # Windows統合セットアップスクリプト
├── wsl/                   # WSL (Ubuntu 24.04) 専用
│   └── install_tools.sh   # OSアップデート, Docker, Shellの一括セットアップ
├── mac/                   # macOS 専用
│   └── Brewfile           # Homebrew パッケージリスト
└── scripts/               # 共通ユーティリティ
    └── link.sh            # Mac/WSL用シンボリックリンク作成スクリプト
```

---

## 🚀 セットアップ手順

どの環境でも、以下の手順でセットアップを完了できます。

### 💻 Windows (Host)
PowerShell を管理者権限で開き、以下のコマンドを実行します。
```powershell
cd ~/.dotfiles/windows
./setup.ps1
```

### 🐧 WSL (Ubuntu) & 🍎 macOS
ターミナルを開き、リポジトリルートで共通セットアップスクリプトを実行します。
```bash
cd ~/.dotfiles
bash setup.sh
```
- **Macの場合**: Homebrew (`mac/Brewfile`) のインストール後、各種リンクの設定、VS Code 拡張機能のインストールを行います。
- **WSLの場合**: システムアップデート、Docker、fnm 等のツールインストール後、各種リンクの設定を行います。
    - ※ **VS Code 拡張機能について**: Windows 側で `setup.ps1` を実行済みであれば、Remote - WSL 機能により自動的に連携されるため、WSL 側での個別インストールは通常不要です。

---

## 🛠 各環境の個別セットアップ・検証

共通スクリプトを使わず、特定の処理のみを実行したい場合や検証を行いたい場合は以下を参照してください。

### WSL (検証用自動テスト)
Dockerを使用して、WSL環境でのセットアップ動作を検証できます。
```bash
docker build -t dotfiles-test tests
docker run --rm -v $(pwd):/home/testuser/dotfiles dotfiles-test bash tests/run_tests.sh
```

### 個別スクリプトの実行
- **設定リンク・VS Code拡張のみ**: `bash scripts/link.sh`
- **WSLツール群のインストールのみ**: `bash wsl/install_tools.sh`

---

## 🛠 各コンポーネントの詳細

### 1. 共通設定 (`common/`)

- **[.zshrc](file:///Users/yuki/.dotfiles/common/.zshrc)**: 設定のエントリーポイント。`common/zsh/` 配下のモジュールを読み込みます。
- **[zsh/](file:///Users/yuki/.dotfiles/common/zsh/)**:
    - **aliases.zsh**: `eza` (モダンls) を用いた `lz` コマンドや、Git (`st`, `ga`...), Docker (`d`, `dps`...) の便利なエイリアス集。
    - **plugins.zsh**: `zsh-autosuggestions` (入力補完) や `zsh-syntax-highlighting` (色付け) をOSごとに適切なパスから読み込みます。
    - **utils.zsh**: OS自動判別ロジックやプロンプトのカラーリング設定。
- **[.gitconfig](file:///Users/yuki/.dotfiles/common/.gitconfig)**: Yuki Yoshida 名義の設定と便利なエイリアス、および共通無視設定の参照。
- **[.gitignore_global](file:///Users/yuki/.dotfiles/common/.gitignore_global)**: `.DS_Store`, `node_modules`, `.vscode` など全OS共通のクリーンアップ設定。

### 2. VS Code 設定 (`vscode/`)

- **[extensions.txt](file:///Users/yuki/.dotfiles/vscode/extensions.txt)**: Windows/WSL/Mac で必要な拡張機能を統合したリスト。
- **[settings.json](file:///Users/yuki/.dotfiles/vscode/settings.json)**: 保存時自動整形（Ruff/Prettier）、HackGen-NF フォント指定など。

---

## 💡 Tips
- **バックアップ**: `link.sh` および `setup.ps1` は、既存の設定ファイルを上書きする前に `.bak` 拡張子で自動的にバックアップを作成します。
