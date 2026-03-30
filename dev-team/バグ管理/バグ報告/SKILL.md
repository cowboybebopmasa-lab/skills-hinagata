---
name: バグ報告
description: バグ・不具合を発見したときに即座にGitHub Issueを作成する。CLAUDE.mdのルールに従い、バグ発見時は自動的にこのスキルが呼ばれる。
allowed-tools: Bash(gh issue *), Bash(gh label *), Bash(git log *), Bash(git diff *), Read, Grep
disable-model-invocation: false
---

# バグ報告（Bug Report）

あなたはバグ管理担当者です。発見されたバグをGitHub Issueとして登録してください。

## バグ情報
$ARGUMENTS

---

## 実行手順

### Step 1: ラベルの準備
以下のラベルが存在しない場合は作成する:

```bash
gh label create "bug" --color "d73a4a" --description "不具合・バグ" 2>/dev/null || true
gh label create "critical" --color "b60205" --description "重大: 即時対応必須" 2>/dev/null || true
gh label create "high" --color "e4e669" --description "高: 今スプリント内に対応" 2>/dev/null || true
gh label create "medium" --color "0075ca" --description "中: 計画的に対応" 2>/dev/null || true
gh label create "low" --color "cfd3d7" --description "低: バックログ" 2>/dev/null || true
gh label create "自動検出" --color "7057ff" --description "フックにより自動検出されたバグ" 2>/dev/null || true
```

### Step 2: 引数を解析する

引数のフォーマット: `[タイトル] | [発生箇所] | [エラー内容] | [重大度]`

引数がパイプ区切りでない場合は、内容から以下を推測して補完する:
- タイトル: バグの概要（50文字以内）
- 発生箇所: ファイルパス・関数名・コマンド名
- エラー内容: エラーメッセージ・スタックトレース
- 重大度: critical / high / medium / low

### Step 3: 直近のgit情報を収集する
```bash
git log --oneline -5
git diff HEAD --name-only
```

### Step 4: GitHub Issue を作成する

```bash
gh issue create \
  --title "[BUG] {タイトル}" \
  --label "bug,{重大度}" \
  --body "{以下のテンプレートを使用}"
```

**Issue本文テンプレート:**
```markdown
## バグ概要
{タイトル}

## 発生箇所
{発生箇所}

## エラー内容
\`\`\`
{エラーメッセージ・スタックトレース}
\`\`\`

## 重大度
{critical / high / medium / low}

## 再現手順
{わかる場合は記載}

## 直近のコミット（参考）
{git log --oneline -5 の出力}

## 変更されたファイル（参考）
{git diff HEAD --name-only の出力}

## 期待される動作
{わかる場合は記載}

## 環境
- 発生日時: {日時}
- 報告者: Claude Code Agent
```

### Step 5: 作成結果を報告する

```
## バグ報告完了

Issue URL: {作成されたIssueのURL}
Issue番号: #{番号}
タイトル: [BUG] {タイトル}
重大度: {重大度}

{重大度が critical または high の場合}
→ ⚠️ 重大なバグです。即時対応してください。
  /バグトリアージ {Issue番号} で詳細な対応方針を確認できます。
```
