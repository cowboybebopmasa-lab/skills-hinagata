---
name: バグ管理
description: バグ管理のハブ。バグ報告・解決・一覧・トリアージを一元管理する。引数なしで呼ぶと現在のバグ状況サマリーを表示する。
allowed-tools: Bash(gh issue *), Bash(gh label *)
context: fork
agent: general-purpose
---

# バグ管理ハブ（Bug Management Hub）

あなたはバグ管理の担当者です。
引数が指定された場合はその操作を実行し、引数がない場合は現在のバグ状況を表示してください。

## 操作指示
$ARGUMENTS

## 引数なしの場合: バグ状況サマリー

以下を実行してください:

```bash
# オープンなバグ一覧（ラベル: bug）
gh issue list --label bug --state open

# クローズ済みバグ（直近10件）
gh issue list --label bug --state closed --limit 10
```

結果を以下の形式でサマリーしてください:

```
## バグ管理サマリー
実行日時: [日時]

### オープン中のバグ
| # | タイトル | 重大度 | 担当 | 作成日 |
|---|---------|--------|------|--------|
| ... |

critical: X件 / high: X件 / medium: X件 / low: X件

### 直近クローズ済みバグ（10件）
| # | タイトル | クローズ日 |
|---|---------|-----------|
| ... |

### アクション推奨
- critical/high が残っている場合: 即時対応を促す
- バグが多い領域: 根本原因の調査を推奨
```
