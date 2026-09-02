import Foundation

/// Generates structured Vault organization suggestions with the best available model.
nonisolated protocol AIClient: Sendable {
  /// Returns the model's current availability.
  var availability: AIAvailability { get async }

  /// Responds to a validated request with editable note metadata.
  func respond(to request: AIRequest) async throws -> NoteOrganizationDraft
}

/// Creates the AI client used by the application.
nonisolated enum AIClientFactory {
  /// Creates an on-device client when Foundation Models is available.
  static func makeDefault() -> any AIClient {
    #if canImport(FoundationModels)
      if #available(iOS 26.0, macOS 26.0, visionOS 26.0, *) {
        return FoundationModelAIClient()
      }
    #endif
    return UnavailableAIClient(reason: .unsupportedOS)
  }
}
