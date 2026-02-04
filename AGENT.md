# AGENT.md - Project Rules & Architecture

このファイルは、この dotfiles プロジェクトを扱うすべての AI エージェントおよび開発者のためのガイドラインです。

## 1. プロジェクトの目的
*   **全OSで統一された操作感**: Mac/Linux (`.sh`) と Windows (`.ps1`) で対等な構造を持つ。
*   **機能別集約**: アプリ固有の設定は、アプリごとのディレクトリにまとめる。

## 2. ディレクトリ構成 (Categorized Structure)
「役割（Role）」ごとに明確にディレクトリを分けています。

```text
.
├── setup.sh / setup.ps1       # エントリーポイント (Orchestrator)
├── scripts/                   # ヘルパー (Linker等)
├── vscode/                    # アプリモジュール (設定 + インストーラー)
│   ├── install_extensions.sh
│   └── install_extensions.ps1
├── common/                    # 共通設定 (Brewfile, zshrc)
├── windows/                   # OSブートストラップ (Scoop)
├── mac/                       # OSブートストラップ (Brew)
└── wsl/                       # OSブートストラップ (Apt/Brew)
```

## 3. スクリプトの役割分担

| 役割 | 場所 | 内容 |
| :--- | :--- | :--- |
| **Setup (親)** | `root` | 全体を統括し、順番に各スクリプトを呼ぶだけ。 |
| **Install** | `OS dir` | OS固有のパッケージ管理 (Brew/Apt/Scoop) を行う。 |
| **Link** | `scripts/` | シンボリックリンクを貼る。OS差異を吸収するロジックを含む。 |
| **Extensions** | `App dir` | アプリ固有の拡張機能などを入れる (`vscode/install_extensions.sh` 等)。 |

## 4. 変更時の注意点
*   **対称性の維持**: `.sh` を修正したら、対応する `.ps1` も必ず確認・修正する。
*   **責務の分離**: 「リンク処理」の中に「インストール処理」を混ぜない。
*   **命名**: 何をするスクリプトかわかりやすい名前をつける (`install_extensions.sh` 等)。

## 5. 言語設定
*   ドキュメント、コミットメッセージ、エージェントとの対話は **日本語** を使用する。
