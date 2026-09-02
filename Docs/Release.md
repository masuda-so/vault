# Vault release readiness

Status updated: August 30, 2026. This is a release checklist, not a submission
or public-release claim.

## Implemented v1

- iOS 18 iPhone/iPad Swift 6 app and test targets with a shared scheme and
  repository `swift-format` rules.
- Local SwiftData note create/edit/delete/persistence/rollback.
- Persistent-store search across title/body with reverse `updatedAt` ordering and
  no remote index or USGS integration.
- On-device Foundation Models organizer with availability fallback, explicit user
  action, editable title/tags/summary preview, confirmation before applying or
  saving, cancellation, stable error vocabulary, and no remote AI provider.
- StoreKit 2 loading, purchase, restore, verified entitlement/finish, updates,
  refund/revocation filtering, and device-clock expiry.
- Daily Pass `llc.ether.vault.pro.daily`: non-renewing, 24 hours from latest
  verified purchase date, no stacking.
- Auto-renewing `llc.ether.vault.pro.monthly` and
  `llc.ether.vault.pro.yearly`.
- Local StoreKit configuration selected for Debug and excluded from the app bundle.
- Privacy manifest, English/Japanese String Catalogs, fixed production legal
  URLs, current layered `Resources/AppIcon.icon`, and third-party notices.

## Required local re-verification

The working tree has changed since the prior local verification record. Treat
all build, test, Analyze, and Archive results as pending. Use the currently
installed stable Xcode with an Apple-distributed compatible SDK and runtime.

Run and record:

- Static inspection of the project and scheme, Swift formatting, JSON/plist and
  String Catalog parsing, product identifiers, privacy manifest, and app-icon source.
- An unsigned Debug simulator build.
- The non-StoreKit test suite.
- Release app-target Analyze.
- An unsigned generic-iOS Release Archive and bundle audit: identifiers, version,
  minimum OS, privacy manifest, English/Japanese localization, compiled icons,
  and absence of `.storekit` and `.xctest` artifacts.
- StoreKit end-to-end checks separately on a compatible runtime, physical device,
  or TestFlight.

Do not carry forward old manifests or hashes; record fresh evidence against the
final working tree.

## App Store submission gates

- Confirm App Store Connect app/version/build records, Apple Distribution signing,
  and provisioning for `llc.ether.vault`.
- Create/localize all three products; place Monthly/Yearly in one subscription
  group at the same level; submit first-time product types with the app version.
- Confirm production price, availability, tax/category data, and review assets.
- Pass all nine StoreKit E2E cases: product load, verified purchase/finish,
  unfinished processing, restore, Daily boundary, Ask to Buy, refund removal,
  latest-purchase repurchase, and auto-renew cancellation through expiry.
- Publish and anonymously verify:
  - `https://ether-llc.com/apps/vault/privacy/`
  - `https://ether-llc.com/apps/vault/terms/`
  - `https://ether-llc.com/apps/vault/support/`
- Reconcile final Archive/App Privacy Report with privacy, Required Reason API,
  encryption/export, age-rating, and content-rights answers.
- Prepare Vault-specific screenshots/value/review notes for guideline 4.3 and
  verify local search, empty/no-result state, free path, assistant fallback,
  purchase/restore/manage/legal navigation, Dynamic Type, VoiceOver, contrast,
  localization, iPad layout, and failure states.
- Decide whether a historical bundle ID needs migration/export guidance; SwiftData
  notes and purchases do not move automatically to a different app record.
- Complete signed Archive, App Store validation, TestFlight, compatible-device
  purchase/restore/expiry, and final human approval.

## Icon disposition

`vault/Resources/AppIcon.icon` is the current source. Render it with stable
Xcode, inspect Default, Dark, Clear, and Tinted appearances at required sizes,
and confirm that the final Archive contains the compiled icon. App Review makes
the final determination.

## External or human blockers

Only Apple credentials/signing, App Store Connect, a compatible Apple StoreKit
environment, TestFlight/physical-device verification, public legal-page
deployment, and final legal/content/accessibility/UI judgment may remain outside
the local reconstruction. No signing, validation, upload, release, deployment,
publication, or external message is authorized here.
