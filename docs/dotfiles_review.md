# Dotfiles 構成見直し レビュー

現在の構成を確認した上で、各トピックについて提案・見解をまとめます。

---

## 1. 🖊️ VSCode → Neovim 移行

### 現状の課題
現在 `scripts/link.sh` でVSCodeの設定を Mac と WSL の両方にシンボリックリンクしており、まさに「WSLとホスト両方に設定が必要」という問題が発生しています。

```
vscode/settings.json → ~/Library/Application Support/Code/User/settings.json  (Mac)
vscode/settings.json → ~/.vscode-server/data/Machine/settings.json            (WSL)
```

### Neovim移行の評価: ✅ 強くおすすめ

**メリット:**
- 設定ファイルが `~/.config/nvim/` 一箇所に集約。OS問わず同じ設定が使える
- SSH・WSL・コンテナ内でもターミナルだけで完結。リモート接続の摩擦がゼロ
- `vscode` ディレクトリをまるごと削除してdotfilesがシンプルになる

**デメリット・注意点:**
- 初期セットアップのコストがある（ただし LazyVim や kickstart.nvim を使えば大幅に短縮可能）
- GUIデバッガーは DAP プラグインで対応可能だが、VSCode より設定が重い

### 推奨アーキテクチャ

```
common/
  nvim/           ← 新規追加
    init.lua
    lua/
      plugins/
      config/
```

`link.sh` でのリンク先:
```bash
"common/nvim:$HOME/.config/nvim"
```

> [!TIP]
> **Neovim ディストリビューション候補**
> - **LazyVim** — プリセットが充実。LSP/Copilot連携も楽。ゼロから始めるならこれ
> - **kickstart.nvim** — 単一ファイルで全部見える。学習しながらカスタマイズしたい場合に最適
> - **AstroNvim** — UIが美しく、VSCodeに近い体験。移行ユーザーに人気

---

## 2. 🎨 Zsh プロンプト: Starship

### 現状の評価

すでに `common/starship.toml` が存在し、`.zshrc` でも `starship init zsh` を呼び出しています。**実質的にStarshipはすでに導入済みです。**

```toml
# starship.toml は存在しているが最小構成
[character]
success_symbol = "[➜](bold green)"
...
```

### 提案: ✅ このままStarshipを継続 + 設定を充実させる

「Starship使うか迷っている」とのことですが、すでに設定ファイルがあるので継続が自然です。

**現在の starship.toml への追加提案:**
```toml
# 追加したい設定例

# Git commitの表示
[git_commit]
commit_hash_length = 7
tag_symbol = "🔖 "

# 実行時間表示（長いコマンドのみ）
[cmd_duration]
min_time = 2000   # 2秒以上かかったコマンドのみ表示
format = "took [$duration](bold yellow) "

# OS表示（マルチOS環境なので便利）
[os]
disabled = false

# Neovim移行後はこれを追加
[package]
disabled = true   # node_modules のバージョンを非表示にするなど
```

> [!NOTE]
> oh-my-zsh + テーマ よりも Starship の方が起動が速く、設定が一元管理できるのでマルチOS環境にはベストマッチです。

---

## 3. 🪟 Windows: Scoop → winget 移行

### 現状
`windows/install.ps1` が Scoop を使用。アプリ一覧:
- googlechrome, vivaldi, vscode, antigravity, git, powertoys, 7zip, everything, quicklook, kindle, discord, line, steam, spotify, vlc, HackGen-NF

### Scoop vs winget の比較

| 項目 | Scoop | winget |
|------|-------|--------|
| 安定性 | バケット依存でバラつき | Microsoft公式。比較的安定 |
| パッケージ数 | 多い（特にdev系） | 多い（GUIアプリが特に充実） |
| パスの管理 | 自動でユーザー領域に入れる | インストーラー依存（UAC必要な場合あり） |
| フォントのインストール | nerd-fonts バケットで可 | 対応しているが少ない |
| アンインストール | `scoop uninstall` で綺麗 | アンインストーラー依存 |
| ポータビリティ | `scoop export` で一覧化可能 | `winget export` で可能 |

### 評価: ⚠️ winget 移行は賛成だが注意点あり

**winget が向いているケース:**
- 一般的なGUIアプリ（Chrome, Discord, Spotify, Steam, VLC等）→ winget の方が安定
- Microsoftアプリ（PowerToys, VSCode等）→ winget が公式なので確実

**winget で注意が必要なケース:**
- フォント → winget でのフォントインストールは対応パッケージが限られる。後述のNoto含め要確認
- 開発系CLIツール → Scoop の方が最新版が早い場合あり（git等）

**折衷案（推奨）:**
- GUIアプリ → winget
- 開発系CLI（git, nvim等）→ winget または Scoop を残す
- フォント → winget で対応可能なものはwinget。なければ手動

### winget での新しい install.ps1 イメージ

```powershell
# winget でのインストール例
winget install --id Google.Chrome -e
winget install --id Vivaldi.Vivaldi -e
winget install --id Microsoft.VisualStudioCode -e
winget install --id Microsoft.PowerToys -e
winget install --id Git.Git -e
winget install --id 7zip.7zip -e
winget install --id voidtools.Everything -e
winget install --id Discord.Discord -e
winget install --id Spotify.Spotify -e
winget install --id VideoLAN.VLC -e
winget install --id Valve.Steam -e
```

---

## 4. 🔤 フォント: HackGen → Noto

### 現状
- Mac: `cask "font-hackgen-nerd"` (Brewfile)
- Windows: `scoop install HackGen-NF`

### HackGen vs Noto の比較

| 項目 | HackGen (HackGen35 Nerd) | Noto |
|------|--------------------------|------|
| 日本語対応 | ✅ 非常に優秀（源柔ゴシックベース） | ✅ 優秀（Googleのユニバーサルフォント） |
| Nerd Fonts | ✅ HackGen Nerd で対応 | ❌ Noto自体はNerd Fonts非対応 |
| 等幅・プログラミング用 | ✅ 専用設計 | ⚠️ Noto Mono があるが機能が少ない |
| ターミナル表示 | ✅ 非常に向いている | ⚠️ Nerd Fonts対応版がない点が課題 |
| ライセンス | OFL | OFL |

### 評価: ⚠️ 用途によっては再考を推奨

> [!WARNING]
> **Nerd Fonts対応の問題**
> `starship.toml` や Neovim の設定で Nerd Fonts のアイコン（ , , 等）を使用している場合、**Noto にはNerd Fonts版がないため、アイコンが豆腐（□）になる可能性があります。**

**推奨代替案:**
- **ターミナル用:** `Noto Sans Mono` + フォールバックとして Nerd Fonts（例: Symbols Nerd Font Mono を追加）
- **より良い選択肢:** `JetBrains Mono Nerd Font` または `Monaspace Neon Nerd` — モダンでNerd Fonts対応、日本語は別フォントでフォールバック
- **日本語環境でのベスト:** HackGen Nerd のまま継続 or `UDEV Gothic NF`（HackGenの後継的存在）

**もし本当にNotoに移行したい場合:**
1. `font-noto-sans-cjk` (日本語テキスト用)
2. `font-symbols-only-nerd-font` (アイコン用フォールバック)
の2種類を組み合わせる必要があります。

---

## 📋 まとめ・優先度

| 変更 | 推奨度 | 理由 |
|------|--------|------|
| VSCode → Neovim | ✅ 強くおすすめ | dotfiles の大幅な単純化につながる |
| Starship 継続 | ✅ そのまま使用 | すでに設定済み。設定を充実させるだけ |
| Scoop → winget | ✅ おすすめ（GUIアプリのみ） | 安定性UP。devツールは要検討 |
| HackGen → Noto | ⚠️ 再考推奨 | Nerd Fonts非対応の問題あり。UDEV Gothic NF も検討を |

---

## 🗂️ 変更後のディレクトリ構成（案）

```
.dotfiles/
├── common/
│   ├── .zshrc
│   ├── .gitconfig
│   ├── .gitignore_global
│   ├── starship.toml
│   ├── Brewfile
│   ├── nvim/           ← 新規（VSCode置き換え）
│   │   ├── init.lua
│   │   └── lua/
│   └── zsh/
│       ├── aliases.zsh
│       ├── plugins.zsh
│       └── utils.zsh
├── mac/
│   ├── Brewfile        ← font-hackgen-nerd → font-noto-* or UDEV Gothic
│   └── install.sh
├── windows/
│   └── install.ps1     ← Scoop → winget
├── wsl/
│   └── install.sh
├── vscode/             ← Neovim移行後に削除
├── scripts/
│   ├── link.sh         ← nvim のリンク追加、vscode削除
│   └── link.ps1
├── setup.sh
└── setup.ps1
```
