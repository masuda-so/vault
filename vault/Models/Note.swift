import Foundation
import SwiftData

/// A searchable note persisted by SwiftData.
@Model
final class Note {
  var title: String
  var text: String
  /// Comma-separated organization tags generated or edited by the person.
  var tags: String?
  /// An optional organization summary generated or edited by the person.
  var summary: String?
  var createdAt: Date
  var updatedAt: Date

  init(
    title: String,
    text: String = "",
    tags: String? = nil,
    summary: String? = nil,
    createdAt: Date = .now,
    updatedAt: Date = .now
  ) {
    self.title = title
    self.text = text
    self.tags = tags
    self.summary = summary
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }

  /// Applies a manual content edit and invalidates generated metadata when its source changes.
  func applyManualEdit(
    title: String,
    text: String,
    updatedAt: Date = .now
  ) {
    let contentChanged = self.title != title || self.text != text
    self.title = title
    self.text = text
    if contentChanged {
      tags = nil
      summary = nil
    }
    self.updatedAt = updatedAt
  }
}
