# 禁止コマンド (NG Commands)

## 概要

以下のコマンド・操作は実行しない。
hooks でブロックされるが、ルールとしても遵守する。

## Shell コマンドの制約

### 禁止コマンド

| 禁止                           | 対応                     |
| ------------------------------ | ------------------------ |
| `git push`                     | ユーザーに実行を依頼する |
| `git merge`                    | ユーザーに実行を依頼する |
| `gh pr merge` / `gh repo sync` | ユーザーに実行を依頼する |
| `rm -rf /`                     | 絶対に実行しない         |

### 推奨パターン

- **Git 操作**: `git push` / `git merge` はユーザー確認
- **gh 操作**: `gh pr merge` / `gh repo sync` はユーザー確認
- **危険な削除**: `rm -rf /` は提案しない

## 補足

- `.claude/hooks/validate-shell.sh` が PreToolUse フックで検証する
