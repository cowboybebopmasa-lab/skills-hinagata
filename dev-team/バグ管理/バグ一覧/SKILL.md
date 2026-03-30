---
name: バグ一覧
description: GitHub Issueのバグ一覧を重大度・ステータス別に表示する。対応すべきバグの優先順位を確認するために使う。
allowed-tools: Bash(gh issue *)
---

# バグ一覧（Bug List）

あなたはバグ管理担当者です。現在のバグ状況を一覧で表示してください。

## フィルター条件
$ARGUMENTS

フォーマット例:
- `open` → オープン中のみ表示（デフォルト）
- `closed` → クローズ済みのみ表示
- `critical` → critical ラベルのみ
- `all` → 全件表示

---

## 実行手順

```bash
# オープン中のバグ（重大度順）
gh issue list --label "bug" --state open --json number,title,labels,createdAt,assignees \
  --jq '.[] | {number, title, labels: [.labels[].name], createdAt, assignees: [.assignees[].login]}'

# 引数が closed の場合
gh issue list --label "bug" --state closed --limit 20

# 引数が特定ラベルの場合
gh issue list --label "bug,$ARGUMENTS" --state open
```

## 出力形式

```
## バグ一覧レポート
更新日時: {日時}

### [critical] 即時対応必須
| # | タイトル | 作成日 | 担当 |
|---|---------|--------|------|
| #XX | ... | ... | ... |

### [high] 今スプリント内に対応
| # | タイトル | 作成日 | 担当 |
...

### [medium] 計画的に対応
...

### [low] バックログ
...

---
合計: {total}件（critical: X / high: X / medium: X / low: X）

### 推奨アクション
- critical が X件あります → 即時対応してください
- high が X件あります → スプリント計画に含めてください
```
