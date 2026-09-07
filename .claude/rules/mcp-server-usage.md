# MCP / Plugin Server Usage

## 基本方針

使える MCP / Plugin があれば必ず使う。
手動実装・推測・一般的な回答より、実際のデータ取得を優先する。

Plugin が MCP サーバーを同梱している場合は Plugin を優先し、`.mcp.json` に同じサーバーを重複登録しない。

## 有効化チェック（必須・最優先）

ツールを使う前に、必ず有効化されているか確認する。

1. 利用可能なサーバー・ツールが存在するか確認する（`claude mcp list` / `claude plugin list`）
2. **無効・未認証の場合は作業を中断し、ユーザーに有効化を依頼する**
   - 推測・手動実装・一般的な回答で代用しない
   - 「MCP が無効のため先に有効化してください。有効化後に続行します」と伝えて会話を止める
3. 有効化の確認が取れるまで、MCP が必要なタスクは進めない

リモート MCP は初回に OAuth 認証が必要。`claude mcp list` で `! Needs authentication` と出たら、対話セッションの `/mcp` から認証する。

## Plugin 経由（`claude-plugins-official`）

**このリポジトリにのみ** `-s project` スコープでインストール済み。有効化状態は [.claude/settings.json](../settings.json) の `enabledPlugins` に記録され、git 管理される（他プロジェクト・他マシンには影響しない）。

追加は `claude plugin install <name>@claude-plugins-official -s project`（`-s` を付けないと user スコープ＝全プロジェクト共通になるので注意）。

### 他のメンバーが使う場合

`enabledPlugins` を git にコミットしただけでは自動的には有効化されない（実機で検証済み：マーケットプレイス未登録のマシンでは `claude plugin list` が空のまま）。以下が必要:

1. **`extraKnownMarketplaces`（設定済み）** — `.claude/settings.json` にマーケットプレイスのソースを明記してあるので、このリポジトリを開いた時点で `claude-plugins-official` がそのマシンに未登録でも自動的に登録される
2. **ワークスペースの信頼（trust dialog）** — 初回はそのリポジトリで対話的に `claude` を起動し、信頼ダイアログを承認する必要がある（プロジェクト単位、Claude Code 全般の仕様）
3. **各自の OAuth 認証** — figma / notion / slack / stripe / supabase はリモート MCP なので、`.mcp.json` の credential 同様アカウント認証は個人ごと。`/mcp` から各自ログインする（git では共有されないし、すべきでもない）

つまり「設定は自動で降ってくるが、信頼の承認と自分のアカウント認証は各自1回だけ必要」という状態。

| ジャンル           | Plugin                | いつ使う                                     | 主な用途                                                                          |
| ------------------ | --------------------- | -------------------------------------------- | --------------------------------------------------------------------------------- |
| デザイン           | `figma`               | UI デザインの参照・実装・レビュー            | デザイン仕様の確認、コンポーネント・スタイルの取得、デザインと実装の突合          |
| コラボレーション   | `notion`              | Notion 上のドキュメント・タスク・ナレッジ操作 | ページ検索・作成・更新、データベース操作、仕様書・議事録の参照                    |
| コラボレーション   | `slack`               | Slack 連携・チームコミュニケーション         | チャンネル検索、メッセージ送受信、スレッド・Canvas 操作、ユーザー情報取得         |
| 決済               | `stripe`              | Stripe 実装・API 確認                        | 決済フロー実装、API リファレンス、Skills / commands                               |
| インフラ・クラウド | `supabase`            | DB 操作・認証・ストレージに関する実装・確認  | CRUD、RLS ポリシー、型安全なデータベース操作                                      |
| 開発・デバッグ     | `chrome-devtools-mcp` | フロントエンドの問題調査・パフォーマンス分析 | コンソールログ・ネットワーク、パフォーマンスボトルネック、DOM・ブラウザ固有の問題 |
| インフラ・クラウド | `aws-core`            | AWS リソースの操作・調査・デプロイ           | IaC（CDK / CloudFormation）、Lambda・IAM・DB 選定、コスト最適化                   |
| Git                | `gitkraken`           | 横断的な Git / PR / issue のコンテキスト取得 | commits・branches・PR・issues の参照（GitHub / GitLab / Azure DevOps / Jira）      |

### aws-core の前提

MCP サーバーが `uvx`（uv）を要求する。未インストールなら先に uv を入れる。

### Supabase の注意

Plugin 版の MCP URL は `https://mcp.supabase.com/mcp` のみで、`project_ref` / `read_only` クエリを持たない。
特定プロジェクトに固定したい場合や読み取り専用で運用したい場合は、そのリポジトリの `.mcp.json` に直接設定を書き、Plugin 側の supabase は無効化する。

## MCP 直接設定（Plugin が存在しない）

プロジェクトルートの `.mcp.json` に定義。`.claude/mcp.json` は Claude Code から読まれない。

| ジャンル           | サーバー           | いつ使う                                         | 主な用途                                                                     |
| ------------------ | ------------------ | ------------------------------------------------ | ---------------------------------------------------------------------------- |
| 開発・デバッグ     | `next-devtools`    | Next.js プロジェクトのエラー・実装・デバッグ     | エラー検出・原因調査、ページメタデータ・Server Actions 確認、ライブ状態取得  |
| 調査・ドキュメント | `deepwiki`         | ユーザーが外部 OSS の調査を明示的に依頼したときのみ | サードパーティライブラリ・フレームワークのドキュメント検索                   |

`next-devtools` は最初に必ず `init` tool を呼ぶ。

## 設定ファイル

| ファイル                        | 役割                                                                          |
| ------------------------------- | ------------------------------------------------------------------------------ |
| `.mcp.json`（リポジトリルート） | Plugin が無い MCP サーバーの定義                                              |
| `.claude/settings.json`         | `enabledPlugins` でこのプロジェクト専用の Plugin 有効化状態を保持（git 管理） |
| `.claude/settings.local.json`   | `enabledMcpjsonServers` でプロジェクト MCP の承認を保持（git 管理外）        |
| `~/.claude/plugins/`            | Plugin の実体キャッシュ・マーケットプレイス台帳（マシン共通）                |
