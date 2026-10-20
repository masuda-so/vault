import Foundation
import SwiftData

extension Note {
  /// Returns the persistent-store predicate used by Vault's searchable note list.
  static func predicate(searchText: String) -> Predicate<Note> {
    #Predicate<Note> { note in
      searchText.isEmpty
        || note.title.localizedStandardContains(searchText)
        || note.text.localizedStandardContains(searchText)
    }
  }
}
