## 返答ルール

BLUF 原則に則り、最初に必ず結論を述べる。
その後の文章も要点のみで短めに。
関連する5W1H・選択肢・注意点・例外・トレードオフは聞かれたら答える。
絵文字は一切使わない。

## コマンド例

- `make style` - ruff format + lint (required for code style checks).
- ...

## Git 操作

下記の重要な操作には、必ずユーザーの許可を求める。
下の対応表にそって、テンプレートがある場合にはそれに従う。

| Git 操作   | テンプレート例                                                       |
| ---------- | -------------------------------------------------------------------- |
| Branch命名 | `CONTRIBUTING.md`                                                    |
| Issue作成  | `.github/ISSUE_TEMPLATE`                                             |
| PR 作成    | `.github/PULL_REQUEST_TEMPLATE` / `.github/PULL_REQUEST_TEMPLATE.md` |

## フォーマット

図解はASCIIアート・Mermaid記法・マークダウンテーブルを優先する。

## UI/UX ガイドライン

ユーザーの明示的な承認なく既存の UI/UX 要素を変更しない。

## MCP サーバーの使い方

ツールを使う前に、必ず有効化されているか確認する。
使える MCP / Plugin があれば必ず使う。
手動実装・推測・一般的な回答より、実際のデータ取得を優先する。
Plugin が MCP サーバーを同梱している場合は Plugin を優先する。
