# Vault

Vault is a private local notebook for capturing, searching, and organizing
unfinished thoughts.

## Main navigation

- Notes
- Assistant
- Pro
- Settings

## Core experience

Notes are stored on device with SwiftData. The app supports creation, editing,
local title/body search, and deletion with visible save and delete failure states.

## Intelligence and commerce

The assistant uses Apple Foundation Models on supported devices and languages.
It can organize an existing or newly entered note into an editable title, tags,
and summary preview; no note changes until the person confirms Apply or Save.
The local StoreKit configuration provides:

- `llc.ether.vault.pro.daily`: non-renewing 24-hour Daily Pass.
- `llc.ether.vault.pro.monthly`: auto-renewable monthly plan.
- `llc.ether.vault.pro.yearly`: auto-renewable yearly plan.

App Store Connect product records, production prices, and review metadata remain
external release tasks.

## Documentation

- [Product scope](Docs/Product.md)
- [Privacy](Docs/Privacy.md) and [Terms](Docs/Terms.md)
- [Implementation references](Docs/References.md)
- [Release readiness](Docs/Release.md)
- [App Store submission record](Docs/App-Store-Submission.md)
- [Third-party notices](THIRD_PARTY_NOTICES.md)

Published public routes:

- `https://ether-llc.com/apps/vault/privacy/`
- `https://ether-llc.com/apps/vault/terms/`
- `https://ether-llc.com/apps/vault/support/`

Deployment, signing, upload, and release are not repository-local steps.
