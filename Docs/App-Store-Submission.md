# Vault App Store submission record

Status updated: August 30, 2026. This record defines release gates and does not
assert a submission or public-release date.

## App identity

- Name: Vault
- Bundle ID: `llc.ether.vault`
- Minimum deployment target: iOS 18.0
- Devices: iPhone and iPad
- App record, SKU, version/build, category, age rating, copyright,
  export-compliance, and content-rights answers: human/App Store Connect gate

## In-App Purchases

| Product ID | Type | Local contract |
| --- | --- | --- |
| `llc.ether.vault.pro.daily` | Non-renewing subscription | Pro for 24 hours from latest verified purchase date; no stacking |
| `llc.ether.vault.pro.monthly` | Auto-renewable subscription | Pro while verified entitlement is active |
| `llc.ether.vault.pro.yearly` | Auto-renewable subscription | Pro while verified entitlement is active |

Monthly and Yearly must share one subscription group at the same level. Confirm
product types, localization, pricing, availability, tax/category data, review
screenshots, and first-product submission in App Store Connect. Signed App Store
records control price/period; the local StoreKit file is excluded test data.

## Fixed public URLs

- Privacy Policy: `https://ether-llc.com/apps/vault/privacy/`
- Terms of Use: `https://ether-llc.com/apps/vault/terms/`
- Support: `https://ether-llc.com/apps/vault/support/`

Settings links all three production URLs, and the purchase surface links Privacy
and Terms. Before submission, verify anonymous mobile access outside the local
network and compare the published pages with the final binary. Publication
remains an external gate.

## Privacy and platform declarations

- Notes and search remain in local SwiftData; Foundation Models requests run on
  device. No account, analytics/advertising SDK, remote AI provider, remote search
  index, cloud sync, USGS feed, or payment-card collection is implemented.
- `PrivacyInfo.xcprivacy` declares no tracking or collected data.
- Recheck the final source, dependencies, Archive, and App Privacy Report before
  confirming that `NSPrivacyAccessedAPITypes` may remain empty.
- App Store privacy, age rating, encryption/export-compliance, content rights,
  and regional legal answers require human comparison with the final Archive.

## Review notes to prepare

- Demonstrate free local note capture and title/body search before Pro.
- Explain that Pro's organizer is explicitly invoked and on-device, and show the
  usable non-AI path for unsupported device/language/model states.
- Explain Daily Pass purchase-date + 24-hour device-clock semantics and no stacking.
- Show Pro, Restore Purchases, Manage Subscription, Privacy, Terms, and Support
  navigation.
- Use distinct screenshots/copy centered on private capture and rediscovery, not a
  generic Ether family shell, for guideline 4.3 review.
- State that Vault has no account or review login.

## Icon record

Submit the current layered `vault/Resources/AppIcon.icon`. Rebuild it with stable
Xcode and inspect the built icon at required sizes in Default, Dark, Clear, and
Tinted appearances. Apple Developer Support case `20000121467132` is retained
only as historical correspondence; App Review makes the final determination.

## Technical gate

- [ ] Static, privacy, localization, search, and resource checks pass on the final
      working tree with stable Xcode.
- [ ] Stable-Xcode Debug and Release builds pass against an Apple-distributed SDK.
- [ ] Non-StoreKit tests pass on a compatible Apple Simulator runtime.
- [ ] Release Analyze passes for the submitted app target.
- [ ] An unsigned generic-iOS Archive succeeds and its contents are audited.
- [ ] Nine StoreKit E2E scenarios pass without skips on a compatible Apple
      runtime/device or TestFlight.
- [ ] Distribution-signed Archive validates; TestFlight/device checks pass.
- [ ] Legal URLs, metadata, screenshots, review notes, privacy/IAP answers, and
      human UI/accessibility/legal review are complete.

Signing, validation, upload, TestFlight distribution, publication, and external
messages are intentionally not performed without separate authorization.

Record fresh commands, environment, results, and final Archive evidence in the
release process; do not reuse earlier working-tree evidence. The remaining gates
are summarized in [Release.md](Release.md).
