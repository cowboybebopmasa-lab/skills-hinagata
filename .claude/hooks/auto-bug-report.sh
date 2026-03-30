#!/bin/bash
# ============================================================
# auto-bug-report.sh
# Claude Code PostToolUse フック
# Bash ツールが失敗（exit code != 0）したとき自動でGitHub Issueを作成する
# ============================================================

# --- 標準入力からフックデータを読み込む ---
INPUT=$(cat)

# --- ツール名を確認（Bash以外は無視）---
TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_name',''))" 2>/dev/null)
if [ "$TOOL_NAME" != "Bash" ]; then
  exit 0
fi

# --- 終了コードを取得 ---
EXIT_CODE=$(echo "$INPUT" | python3 -c "
import sys, json
d = json.load(sys.stdin)
output = d.get('tool_response', {})
# exit_code が含まれているか確認
if isinstance(output, dict):
    print(output.get('exit_code', 0))
else:
    print(0)
" 2>/dev/null)

# --- 正常終了は無視 ---
if [ "$EXIT_CODE" = "0" ] || [ -z "$EXIT_CODE" ]; then
  exit 0
fi

# --- エラー内容を取得 ---
COMMAND=$(echo "$INPUT" | python3 -c "
import sys, json
d = json.load(sys.stdin)
inp = d.get('tool_input', {})
print(inp.get('command', 'unknown command')[:200])
" 2>/dev/null)

ERROR_OUTPUT=$(echo "$INPUT" | python3 -c "
import sys, json
d = json.load(sys.stdin)
resp = d.get('tool_response', '')
if isinstance(resp, str):
    print(resp[:500])
elif isinstance(resp, dict):
    print(str(resp.get('stderr', resp.get('output', '')))[:500])
" 2>/dev/null)

# --- 無視するコマンドパターン（意図的な確認コマンド）---
IGNORE_PATTERNS=("git status" "git log" "git diff" "ls " "find " "which " "echo " "cat " "head " "tail " "grep " "gh issue list" "gh label")

for pattern in "${IGNORE_PATTERNS[@]}"; do
  if [[ "$COMMAND" == *"$pattern"* ]]; then
    exit 0
  fi
done

# --- 重大度の自動判定 ---
SEVERITY="medium"
if echo "$ERROR_OUTPUT" | grep -qi "fatal\|panic\|segfault\|out of memory\|permission denied\|access denied"; then
  SEVERITY="critical"
elif echo "$ERROR_OUTPUT" | grep -qi "error\|exception\|failed\|failure"; then
  SEVERITY="high"
elif echo "$ERROR_OUTPUT" | grep -qi "warning\|warn"; then
  SEVERITY="low"
fi

# --- gh コマンドが使えるか確認 ---
if ! command -v gh &> /dev/null; then
  echo "[auto-bug-report] gh CLI が見つかりません。バグ報告をスキップします。" >&2
  exit 0
fi

# --- GitHub にログインしているか確認 ---
if ! gh auth status &> /dev/null; then
  echo "[auto-bug-report] GitHub 未認証のためスキップします。" >&2
  exit 0
fi

# --- ラベルの準備 ---
gh label create "bug"       --color "d73a4a" --description "不具合・バグ"          2>/dev/null || true
gh label create "critical"  --color "b60205" --description "重大: 即時対応必須"     2>/dev/null || true
gh label create "high"      --color "e4e669" --description "高: 今スプリント内に対応" 2>/dev/null || true
gh label create "medium"    --color "0075ca" --description "中: 計画的に対応"       2>/dev/null || true
gh label create "low"       --color "cfd3d7" --description "低: バックログ"         2>/dev/null || true
gh label create "自動検出"  --color "7057ff" --description "フックにより自動検出"   2>/dev/null || true

# --- タイトルを生成 ---
SHORT_CMD=$(echo "$COMMAND" | head -c 60)
TITLE="[BUG][自動検出] コマンド失敗: ${SHORT_CMD}"

# --- 既存の重複Issueを確認（同じタイトルが既にオープンなら作成しない）---
EXISTING=$(gh issue list --label "bug" --state open --search "$SHORT_CMD" --json number --jq 'length' 2>/dev/null || echo "0")
if [ "$EXISTING" -gt "0" ]; then
  echo "[auto-bug-report] 同様のバグIssueが既に存在します。新規作成をスキップします。" >&2
  exit 0
fi

# --- Issue本文を生成 ---
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
GIT_LOG=$(git log --oneline -5 2>/dev/null || echo "git情報取得不可")
GIT_BRANCH=$(git branch --show-current 2>/dev/null || echo "不明")

BODY="## バグ概要
Bashコマンドが失敗しました（exit code: ${EXIT_CODE}）

## 失敗したコマンド
\`\`\`bash
${COMMAND}
\`\`\`

## エラー出力
\`\`\`
${ERROR_OUTPUT}
\`\`\`

## 重大度
${SEVERITY}

## 環境情報
- 発生日時: ${TIMESTAMP}
- ブランチ: ${GIT_BRANCH}
- 報告者: Claude Code 自動検出フック（auto-bug-report.sh）

## 直近のコミット
\`\`\`
${GIT_LOG}
\`\`\`

---
> このIssueは Claude Code の PostToolUse フックにより自動作成されました。
> 誤検知の場合は Issue をクローズしてください。"

# --- Issue を作成 ---
ISSUE_URL=$(gh issue create \
  --title "$TITLE" \
  --label "bug,${SEVERITY},自動検出" \
  --body "$BODY" 2>/dev/null)

if [ $? -eq 0 ] && [ -n "$ISSUE_URL" ]; then
  echo "" >&2
  echo "=======================================" >&2
  echo "[auto-bug-report] バグを自動検出しました" >&2
  echo "重大度: ${SEVERITY}" >&2
  echo "Issue: ${ISSUE_URL}" >&2
  echo "=======================================" >&2
fi

exit 0
