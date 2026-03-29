# dev-team — Agent Teams 開発プロジェクトチーム

Claude Code の Agent Teams として動作する、開発プロジェクトチームのスキルセットです。

---

## エージェント起動パターン（トークン節約）

状況に応じて使い分けることでトークン消費を最適化できます。

| パターン | ファイル | エージェント数 | トークン | 推奨場面 |
|---------|---------|-------------|--------|---------|
| P1 フルチーム | [PATTERN_P1_フルチーム.md](PATTERN_P1_フルチーム.md) | 8 | ★★★★★ | 大型リリース・新規プロダクト |
| P2 リリース前チェック | [PATTERN_P2_リリース前チェック.md](PATTERN_P2_リリース前チェック.md) | 6 | ★★★★☆ | 通常スプリントリリース |
| P3 開発レビュー | [PATTERN_P3_開発レビュー.md](PATTERN_P3_開発レビュー.md) | 4 | ★★★☆☆ | 機能開発中のPRマージ |
| P4 コアレビュー | [PATTERN_P4_コアレビュー.md](PATTERN_P4_コアレビュー.md) | 2 | ★★☆☆☆ | バグ修正・リファクタリング |
| P5 クイックチェック | [PATTERN_P5_クイックチェック.md](PATTERN_P5_クイックチェック.md) | 1 | ★☆☆☆☆ | Hotfix・設定変更・タイポ |

---

## チーム構成

```
dev-team/
│
│  ── オーケストレーター（司令塔）────────────────────────────────
├── オーケストレーター/     # /orchestrator      — 汎用タスク振り分け
├── PRレビュー/             # /pr-review         — PRレビュー自動実行
├── リリースゲート/         # /release-gate      — リリース承認ゲート
├── 機能計画/               # /feature-planning  — 新機能計画
├── インシデント対応/       # /incident-response — 障害緊急対応
│
│  ── 役割エージェント（サブエージェント）────────────────────────
├── セキュリティ責任者/
├── 技術責任者/
├── 法務責任者/
├── 経理責任者/
├── プロジェクト責任者/
├── QA責任者/
├── DevOps責任者/
└── UIデザイナー/
```

---

## Agent Teams の仕組み

```
ユーザー
  │
  ▼
オーケストレーター（/pr-review, /release-gate 等）
  │
  ├──▶ セキュリティ責任者エージェント（context: fork）
  ├──▶ 技術責任者エージェント（context: fork）
  ├──▶ QA責任者エージェント（context: fork）
  ├──▶ 法務責任者エージェント（context: fork）
  ├──▶ 経理責任者エージェント（context: fork）
  ├──▶ プロジェクト責任者エージェント（context: fork）
  ├──▶ DevOps責任者（context: fork）
  └──▶ UIデザイナー（context: fork）
            │（並列実行 / 独立コンテキスト）
            ▼
         統合レポート → 最終判定
```

- 各役割スキルは `context: fork` で**独立したコンテキスト**で実行される
- オーケストレーターが**並列起動**し全員の結果を統合する
- 役割間の独立性が保たれ、バイアスのないレビューが可能

---

## 使い方

### パターン1: オーケストレーターに任せる（汎用）
```
/orchestrator [タスクの内容を自由に記述]
```
→ タスクを自動分析して適切な役割に委譲します

### パターン2: シナリオ別に直接実行

| シナリオ | コマンド |
|---------|---------|
| PRをレビューしてほしい | `/pr-review PR#123` |
| リリースしてよいか確認 | `/release-gate v1.2.0` |
| 新機能の計画・見積もり | `/feature-planning ユーザー認証機能を追加したい` |
| 本番障害が発生した | `/incident-response ログイン画面が500エラー` |

### パターン3: 役割を直接指定

| コマンド | 役割 | 概要 |
|---------|------|------|
| `/security-audit` | セキュリティ責任者 | コードベース全体のセキュリティ監査 |
| `/vulnerability-check` | セキュリティ責任者 | 脆弱性チェックとリスク評価 |
| `/code-review-security` | セキュリティ責任者 | セキュリティ観点のコードレビュー |
| `/security-incident` | セキュリティ責任者 | インシデント対応手順の実行 |
| `/architecture-review` | 技術責任者 | アーキテクチャ設計の評価 |
| `/tech-debt-review` | 技術責任者 | 技術的負債の棚卸しと返済計画 |
| `/code-review-tech` | 技術責任者 | 技術品質のコードレビュー |
| `/performance-review` | 技術責任者 | パフォーマンスボトルネックの分析 |
| `/license-check` | 法務責任者 | OSSライセンスの適法性確認 |
| `/compliance-review` | 法務責任者 | 法規制コンプライアンスの評価 |
| `/privacy-review` | 法務責任者 | プライバシー・個人情報の評価 |
| `/contract-review` | 法務責任者 | 利用規約・契約書のレビュー |
| `/cost-estimate` | 経理責任者 | 開発・運用コストの見積もり |
| `/budget-review` | 経理責任者 | 予算執行状況のレビュー |
| `/resource-cost` | 経理責任者 | クラウドリソースのコスト最適化 |
| `/roi-analysis` | 経理責任者 | 投資対効果の分析 |
| `/project-status` | プロジェクト責任者 | プロジェクト進捗レポート作成 |
| `/sprint-planning` | プロジェクト責任者 | スプリント計画の策定 |
| `/risk-assessment` | プロジェクト責任者 | プロジェクトリスクの評価 |
| `/milestone-review` | プロジェクト責任者 | マイルストーン達成評価・進行可否判断 |
| `/test-plan` | QA責任者 | テスト計画の策定 |
| `/qa-review` | QA責任者 | 品質観点のコードレビュー |
| `/bug-triage` | QA責任者 | バグの重大度・優先度評価 |
| `/deploy-check` | DevOps責任者 | デプロイ前最終チェック |
| `/infra-review` | DevOps責任者 | インフラ構成・IaCのレビュー |
| `/monitoring-setup` | DevOps責任者 | 監視・アラート設定の評価・設計 |
| `/ui-review` | UIデザイナー | UI/UX品質のレビュー |
| `/accessibility-check` | UIデザイナー | WCAG 2.1 アクセシビリティ準拠確認 |
| `/design-system-review` | UIデザイナー | デザインシステム一貫性の確認 |
| `/prototype-review` | UIデザイナー | プロトタイプ・ワイヤーフレームの評価 |

---

## プロジェクトへの導入方法

```bash
# プロジェクトの .claude/skills/ にコピー
cp -r /path/to/skills_hinagata/dev-team .claude/skills/

# または シンボリックリンクで共有
ln -s /path/to/skills_hinagata/dev-team .claude/skills/dev-team
```

---

## 開発ルール
[DEVELOPMENT_RULES.md](DEVELOPMENT_RULES.md) を参照してください。
