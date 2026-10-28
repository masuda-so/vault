# Vault

[日本語](README.md) | [English](README.en.md)

## Overview

Vault is a private local notebook for capturing, searching, and organizing
unfinished thoughts.

## Features and limitations

### Main navigation

- Notes
- Assistant
- Pro
- Settings

### Core experience

Notes are stored on device with SwiftData. The app supports creation, editing,
local title/body search, and deletion with visible save and delete failure states.

### Intelligence and commerce

The assistant requires active Pro access and uses Apple Foundation Models on supported devices and languages.
The local StoreKit configuration provides:

- `llc.ether.vault.pro.daily`: non-renewing 24-hour Daily Pass.
- `llc.ether.vault.pro.monthly`: auto-renewable monthly plan.
- `llc.ether.vault.pro.yearly`: auto-renewable yearly plan.

The Pro product list waits for the initial entitlement check. While a Daily Pass is active, that pass is excluded from purchase options and returns after it expires. Purchases can be restored from Pro and Settings even when the assistant is unavailable.

App Store Connect product records, production prices, and review metadata remain
external release tasks.

## Getting started and usage

Open `vault.xcodeproj` in Xcode and select the shared `vault` scheme.
See [repository structure and verification](Docs/Structure.md) for build and test guidance,
and [release gates](Docs/Release.md) for device and release requirements.
The local StoreKit configuration is for purchase testing, not proof of production availability.

## Support and documentation

- [Repository structure and verification](Docs/Structure.md)
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

## Development and contributions

Use the support route above for product help. For repository changes, consult the
implementation references and release gates linked above, and describe the change
and its validation in a pull request. PR descriptions and review comments use Japanese by default; an explicit request for another language takes precedence.

See [AGENTS.md](AGENTS.md) for shared repository instructions.
