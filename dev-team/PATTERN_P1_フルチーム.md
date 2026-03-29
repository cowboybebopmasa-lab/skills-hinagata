# P1 — フルチーム（最大構成）

> **エージェント数**: 8 役割すべて
> **トークン消費**: ★★★★★（最大）
> **推奨場面**: 大型リリース・新規プロダクト立ち上げ・重大インシデント後の再発防止レビュー

---

## 起動するエージェント一覧

| # | 役割 | 使用スキル | 目的 |
|---|------|-----------|------|
| 1 | セキュリティ責任者 | `security-audit` / `code-review-security` | セキュリティリスク全般 |
| 2 | 技術責任者 | `architecture-review` / `code-review-tech` | 設計・コード品質 |
| 3 | 法務責任者 | `compliance-review` / `license-check` | 法的リスク・ライセンス |
| 4 | 経理責任者 | `cost-estimate` / `roi-analysis` | コスト・予算妥当性 |
| 5 | プロジェクト責任者 | `risk-assessment` / `milestone-review` | スケジュール・リスク |
| 6 | QA責任者 | `test-plan` / `qa-review` | テスト品質 |
| 7 | DevOps責任者 | `deploy-check` / `infra-review` | インフラ・デプロイ |
| 8 | UIデザイナー | `ui-review` / `accessibility-check` | UI/UX品質 |

---

## 使い方

```
/orchestrator [タスク内容]
```

または以下をオーケストレーターへの指示として使用：

```
以下のタスクについて、全8役割のエージェントを並列起動してレビューしてください。

タスク: [内容]

起動するエージェント:
1. セキュリティ責任者 → security-audit / code-review-security
2. 技術責任者         → architecture-review / code-review-tech
3. 法務責任者         → compliance-review / license-check
4. 経理責任者         → cost-estimate / roi-analysis
5. プロジェクト責任者 → risk-assessment / milestone-review
6. QA責任者           → test-plan / qa-review
7. DevOps責任者       → deploy-check / infra-review
8. UIデザイナー       → ui-review / accessibility-check

全員の結果を統合して最終判定を返してください。
```

---

## 判定ルール
- **全員 ✅** → 承認
- **1人でも ❌** → 却下（ブロッカーを全解消するまで進行不可）
- **⚠️ のみ** → 条件付き承認（期限付き改善計画が必要）

---

## トークン節約ヒント
このパターンはコストが高いため、以下の場合のみ使用を推奨：
- 四半期に1回の大型リリース
- 新規サービス・機能の初回リリース
- セキュリティインシデント後の全体見直し
- 重要な法改正・規制変更への対応
