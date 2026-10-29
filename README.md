# Vault

[日本語](README.md) | [English](README.en.md)

## 概要

Vaultは、まだまとまっていない考えを記録・検索・整理する、プライベートなローカルノートです。

## 主な機能と制約

### 主な画面

- Notes
- Assistant
- Pro
- Settings

### 主な機能

ノートはSwiftDataで端末内に保存します。作成、編集、タイトル・本文のローカル検索、削除に対応し、保存や削除の失敗を画面に表示します。

### アシスタントと購入

アシスタントには有効なProの利用権が必要です。対応する端末と言語でApple Foundation Modelsを使用します。

ローカルのStoreKit設定には、次の商品を定義しています。

- `llc.ether.vault.pro.daily`：自動更新しない24時間のDaily Pass。
- `llc.ether.vault.pro.monthly`：自動更新の月額プラン。
- `llc.ether.vault.pro.yearly`：自動更新の年額プラン。

App Store Connectの商品登録、本番価格、審査用情報の準備は、別途必要なリリース作業です。

## 導入と使い方

Xcodeで`vault.xcodeproj`を開き、共有スキーム`vault`を選択します。
ビルドとテストの手順は[構成と検証](Docs/Structure.md)、端末要件とリリース条件は[リリース条件](Docs/Release.md)を参照してください。
ローカルStoreKit設定は購入テスト用で、本番販売が可能であることの証明ではありません。

## サポートと関連資料

- [リポジトリ構成と検証](Docs/Structure.md)
- [製品の範囲](Docs/Product.md)
- [プライバシーポリシー](Docs/Privacy.md)
- [利用規約](Docs/Terms.md)
- [実装の参照元](Docs/References.md)
- [リリース条件](Docs/Release.md)
- [App Store提出記録](Docs/App-Store-Submission.md)
- [第三者の権利表記](THIRD_PARTY_NOTICES.md)

公開サイトのパス：

- `https://ether-llc.com/apps/vault/privacy/`
- `https://ether-llc.com/apps/vault/terms/`
- `https://ether-llc.com/apps/vault/support/`

署名、検証、アップロード、公開、リリースには、リポジトリ外での作業も必要です。

## 開発と貢献

GitHub Actionsでは通常CIに加え、StoreKit専用CIで購入関連の9件を検証します。同じ取引IDの完了処理を確認し、対象1件の単独実行と全9件の実行を比較します。実行環境・残る警告・検証範囲は[構成と検証](Docs/Structure.md#continuous-integration)を参照してください。CIでの成功は、実機や本番ストアでの動作を保証するものではありません。

製品の問い合わせ先は上記のサポートURLです。リポジトリを変更する場合は、上記の実装の参照元とリリース条件を確認し、変更内容と検証結果をPRに記載してください。PRの説明とレビューコメントは日本語を基本とします。利用者が別の言語を指定した場合は、その指定を優先します。

作業時の共通方針は[AGENTS.md](AGENTS.md)を参照してください。
