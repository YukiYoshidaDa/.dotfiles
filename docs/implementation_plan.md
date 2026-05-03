# Dotfiles 再構築・近代化計画 (chezmoi & Neovim & winget)

## 概要
現在の dotfiles 構成を全面的に見直し、`chezmoi` を中心としたマルチOS対応の新しいシステムを構築します。あわせてエディタを Neovim (LazyVim) へ移行し、Windows環境のパッケージ管理を winget へ最適化します。

## ユーザーレビュー必須項目

> [!IMPORTANT]
> **新しいリポジトリの作成**
> 既存のリポジトリを整理するよりも、新しいリポジトリ（例: `dotfiles-v2`）をゼロから作成し、必要な設定だけを順次移行することを推奨します。

> [!WARNING]
> **Neovim 移行の学習コスト**
> VSCodeからの完全移行には数日〜1週間程度の慣れが必要です。最初はVSCodeも残しつつ、徐々にNeovimへシフトする並行期間を設けるプランにします。

## 1. 🛠️ 管理ツールの選定: chezmoi
マルチOS対応をシンプルにするため、`chezmoi` を採用します。

*   **メリット:** 
    *   `.tmpl` ファイルによるOSごとの条件分岐（Mac/WSL/Windows）
    *   パッケージインストール（brew/winget）の自動実行
    *   単一バイナリで動作するため、Windows環境でも導入が容易

## 2. 🖊️ エディタ: Neovim (LazyVim)
「設定に時間をかけすぎず、VSCode並みの機能を最初から使う」ために **LazyVim** をベースにします。

*   **構成案:**
    *   `~/.config/nvim/` を chezmoi で管理。
    *   Mac/WSL の両方で全く同じ操作感を実現。

## 3. 🔤 フォント比較と選定
フォントを更新し、視認性とモチベーションを向上させます。

| フォント | 日本語 | アイコン(NF) | 特徴 | 判定 |
| :--- | :--- | :--- | :--- | :--- |
| **JetBrains Mono NF** | ❌ (要フォールバック) | ✅ あり | リガチャが非常に美しく、世界的に大人気。 | **推し** |
| **UDEV Gothic NF** | ✅ 優秀 | ✅ あり | HackGenの後継的立ち位置。日本語が非常に綺麗。 | **安定** |
| **HackGen NF** (現状) | ✅ 優秀 | ✅ あり | 安定しているが、今回はリフレッシュのため変更。 | **維持** |

**提案:** 
1.  基本は `JetBrains Mono NF` を使い、ターミナルの設定で日本語フォントにフォールバックさせる。
2.  「フォント設定で悩みたくない」場合は `UDEV Gothic NF` を一発入れるのが楽です。

## 4. 🪟 Windows 環境の最適化 (winget)
Scoop から winget への移行を進め、Windows標準の安定性を確保します。

*   **GUIアプリ:** 全て winget で管理（Chrome, Discord, PowerToys等）。
*   **CLIツール:** 基本 winget、存在しないものや最新版が必要なものだけ Scoop を併用。

---

## Proposed Changes (段階的移行)

### Phase 1: 基礎構築
#### [NEW] `~/.local/share/chezmoi/` (ソースディレクトリ)
*   `.chezmoi.toml.tmpl`: OSごとの変数定義。
*   `dot_zshrc.tmpl`: OS条件分岐を含む新しい zsh 設定。
*   `dot_starship.toml`: シンプル化した Starship 設定。

### Phase 2: パッケージ管理の自動化
#### [NEW] `run_onchange_after_install-packages.sh.tmpl` (Mac/WSL用)
*   `brew bundle` を実行して一括インストール。
#### [NEW] `run_onchange_after_install-packages.ps1.tmpl` (Windows用)
*   `winget` コマンドでアプリを一括インストール。

### Phase 3: Neovim 導入
#### [NEW] `dot_config/nvim/`
*   LazyVim のスターターセットアップを配置。

---

## 実行スケジュール（案）

1.  **Step 1:** chezmoi のインストールと初期リポジトリ作成。
2.  **Step 2:** フォントのインストール（JetBrains Mono NF または UDEV Gothic NF）。
3.  **Step 3:** 最小限の zsh + Starship 設定を chezmoi に登録。
4.  **Step 4:** Neovim (LazyVim) の投入と動作確認。
5.  **Step 5:** Windows 側の winget 移行スクリプト作成。

## Verification Plan

### 自動検証
*   `chezmoi doctor`: 構成に問題がないか確認。
*   `chezmoi diff`: 設定が正しく反映されるか、差分を確認。

### 手動検証
*   各OS（Mac, WSL, Windows）で同じエイリアスが通るか確認。
*   Neovim で LSP（補完機能）が動作するか確認。
*   フォントのリガチャが効いているか確認。
