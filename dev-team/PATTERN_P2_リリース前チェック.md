# P2 — リリース前チェック

> **エージェント数**: 6（経理責任者・UIデザイナーを除外）
> **トークン消費**: ★★★★☆
> **推奨場面**: 通常のスプリントリリース・本番デプロイ前の最終確認

---

## 起動するエージェント一覧

| # | 役割 | 使用スキル | 目的 |
|---|------|-----------|------|
| 1 | セキュリティ責任者 | `vulnerability-check` / `code-review-security` | 脆弱性・セキュリティ確認 |
| 2 | 技術責任者 | `code-review-tech` / `performance-review` | コード品質・性能 |
| 3 | 法務責任者 | `license-check` / `compliance-review` | ライセンス・法規制 |
| 4 | プロジェクト責任者 | `milestone-review` / `risk-assessment` | リリース判定・リスク確認 |
| 5 | QA責任者 | `qa-review` / `test-plan` | テスト完了確認 |
| 6 | DevOps責任者 | `deploy-check` / `monitoring-setup` | デプロイ手順・監視確認 |

## 除外する役割と理由

| 役割 | 除外理由 |
|------|---------|
| 経理責任者 | 予算・コストは計画フェーズで確認済みのため不要 |
| UIデザイナー | デザインレビューは開発中に完了済みのため不要 |

---

## 使い方

```
/release-gate [バージョン/ブランチ名]
```

または以下をオーケストレーターへの指示として使用：

```
以下のリリース対象について、6役割のエージェントを並列起動してリリース可否を判定してください。

リリース対象: [バージョン/ブランチ名]

起動するエージェント:
1. セキュリティ責任者 → vulnerability-check / code-review-security
2. 技術責任者         → code-review-tech / performance-review
3. 法務責任者         → license-check / compliance-review
4. プロジェクト責任者 → milestone-review / risk-assessment
5. QA責任者           → qa-review / test-plan
6. DevOps責任者       → deploy-check / monitoring-setup

全員 GO のときのみリリース承認、1人でも NO-GO のとき理由とブロッカーを明示してください。
```

---

## 判定ルール
- **全員 GO** → リリース承認
- **1人でも NO-GO** → リリース禁止（ブロッカー解消後に再実行）

---

## P1との使い分け
| 状況 | 推奨パターン |
|------|------------|
| 新機能が多い・大型変更 | P1 フルチーム |
| 通常のスプリントリリース | **P2 リリース前チェック** ← |
| バグ修正のみのリリース | P3 開発レビュー |
