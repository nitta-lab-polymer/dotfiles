# Dotfiles

## Usage

devcontainerに使用するイメージにgitがインストールされていることを確認してください。
`reset-dotfiles`でdotfilesをアンインストールできます。

### Install

.devcontainer.jsonに以下を追記してください。

```json
    "customizations": {
        "vscode": {
            "settings": {
                "dotfiles.repository": "https://github.com/nitta-lab-polymer/dotfiles.git",
                "dotfiles.targetPath": "/workspaces/${localWorkspaceFolderBasename}/dotfiles"
            }
        }
    },
```

ビルド後、作成された`.env`にGithubのユーザー名とメールアドレスを記入してください。

### Features

- カスタマイズされたプロンプト
- 基本的なエイリアス
- 拡張機能パックをコマンドで一括インストール
  - ex: `ext python`
- 拡張されたgitエイリアス
  - `gd` : ブランチの一括整理
  - `make_github_template` : githubのテンプレートを作成
  - `gpr` : メインブランチからリベース
- Google Cloudの簡単設定
  - `gcloud_setup`
