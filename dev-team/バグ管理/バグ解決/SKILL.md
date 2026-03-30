---
name: バグ解決
description: バグを修正したときにGitHub IssueをクローズしResolvedステータスに更新する。修正内容・根本原因・再発防止策を記録する。
allowed-tools: Bash(gh issue *), Bash(git log *), Bash(git diff *)
disable-model-invocation: false
---

# バグ解決（Bug Resolve）

あなたはバグ管理担当者です。修正されたバグのIssueをクローズし、解決内容を記録してください。

## 対象Issue・解決情報
$ARGUMENTS

フォーマット: `[Issue番号] | [根本原因] | [修正内容] | [再発防止策]`
Issue番号のみの場合は、残りは git log・diff から推測して補完する。

---

## 実行手順

### Step 1: Issue の現在状態を確認する
```bash
gh issue view {Issue番号}
```

### Step 2: 直近のコミット・変更内容を収集する
```bash
git log --oneline -5
git diff HEAD~1 HEAD --stat
```

### Step 3: Issue に解決コメントを追加する
```bash
gh issue comment {Issue番号} --body "{以下のテンプレート}"
```

**解決コメントテンプレート:**
```markdown
## 解決報告

### 根本原因
{根本原因}

### 修正内容
{具体的な修正内容}

### 修正コミット
{git log --oneline -3 の出力}

### 再発防止策
{再発防止策}

### テスト確認
{動作確認方法・テスト結果}

解決日時: {日時}
対応者: Claude Code Agent
```

### Step 4: ラベルを更新してIssueをクローズする
```bash
# resolvedラベルを作成（なければ）
gh label create "resolved" --color "0e8a16" --description "解決済み" 2>/dev/null || true

# resolvedラベルを追加してクローズ
gh issue edit {Issue番号} --add-label "resolved"
gh issue close {Issue番号} --comment "修正完了。詳細は上記コメントを参照。"
```

### Step 5: 完了を報告する

```
## バグ解決完了

Issue: #{番号} — {タイトル}
ステータス: Closed (Resolved)
根本原因: {根本原因}
修正コミット: {コミットハッシュ}

残存するバグを確認: /バグ一覧
```
