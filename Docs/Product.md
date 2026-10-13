# Vault

Vault is a private place to capture, search, and rediscover notes. It includes
SwiftData persistence and ordinary local title/body search ordered by the most
recent update. No ranking or weighted-search algorithm is implemented.

## Initial navigation

- Notes
- Assistant
- Pro
- Settings

## Commerce baseline

- `llc.ether.vault.pro.daily`: non-renewing Daily Pass with 24 hours of access.
- `llc.ether.vault.pro.monthly`: auto-renewable monthly plan.
- `llc.ether.vault.pro.yearly`: auto-renewable yearly plan.

The Daily Pass never renews automatically. App Store Connect products and pricing
must be configured and reviewed before these plans can be sold.
Its 24-hour expiration is calculated locally from StoreKit's verified purchase date
and the device wall clock. This release doesn't use a server-authoritative clock.
The on-device assistant is the initial Pro capability; the core app remains usable
without a purchase. An active Daily Pass cannot be repurchased or stacked.

## Implementation ownership

Vault owns its Foundation Models client and product-specific prompt locally. StoreKit 2
and entitlement handling are also app-local, while Daily, Monthly, and Yearly retain
the common plan shape used across the Ether apps.
