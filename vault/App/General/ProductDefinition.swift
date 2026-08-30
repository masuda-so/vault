import SwiftUI

/// Stable identifiers that must remain compatible with App Store records.
enum ProductIdentity {
  nonisolated static let identifier = "vault"
  nonisolated static let bundleIdentifier = "llc.ether.\(identifier)"
}

/// Product-specific presentation, assistant, and legal configuration.
struct ProductDefinition {
  let identifier: String
  let bundleIdentifier: String
  let name: String
  let tagline: String
  let symbolName: String
  let accent: Color
  let assistantInputTitle: String
  let assistantActionTitle: String
  let assistantProgressTitle: String
  let assistantTitle: String
  let assistantOutputTitle: String
  let assistantInstructions: String
  let assistantPromptPrefix: String
  let settingsPrivacySummary: String
  let privacyPolicyURL: URL
  let termsOfUseURL: URL
  let supportURL: URL

  static let vault = ProductDefinition(
    identifier: ProductIdentity.identifier,
    bundleIdentifier: ProductIdentity.bundleIdentifier,
    name: "Vault",
    tagline: String(localized: "Keep every thought, then find what matters."),
    symbolName: "archivebox.fill",
    accent: .blue,
    assistantInputTitle: String(localized: "A note or idea to organize"),
    assistantActionTitle: String(localized: "Organize"),
    assistantProgressTitle: String(localized: "Organizing your note…"),
    assistantTitle: String(localized: "Organizer"),
    assistantOutputTitle: String(localized: "Organized note"),
    assistantInstructions:
      "Help organize the user's own notes. Do not invent facts, and clearly separate suggestions from source content.",
    assistantPromptPrefix:
      "Suggest a concise title, three useful tags, and a short summary for this note:",
    settingsPrivacySummary: String(
      localized: "Your notes stay on this device."
    ),
    privacyPolicyURL: validatedURL(
      "https://ether-llc.com/apps/vault/privacy/"
    ),
    termsOfUseURL: validatedURL(
      "https://ether-llc.com/apps/vault/terms/"
    ),
    supportURL: validatedURL(
      "https://ether-llc.com/apps/vault/support/"
    )
  )

  func localizedLegalURL(_ url: URL, for locale: Locale) -> URL {
    guard
      locale.language.languageCode?.identifier == "ja",
      url.host == "ether-llc.com",
      !url.path.hasPrefix("/ja/")
    else {
      return url
    }

    guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
      return url
    }
    components.percentEncodedPath = "/ja\(components.percentEncodedPath)"
    return components.url ?? url
  }

  private static func validatedURL(_ value: String) -> URL {
    guard let url = URL(string: value) else {
      preconditionFailure("Invalid static URL: \(value)")
    }
    return url
  }
}
