import SwiftData
import SwiftUI

struct NoteEditorView: View {
  let note: Note?

  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var context

  @State private var title = ""
  @State private var text = ""
  @State private var persistenceError: String?

  var body: some View {
    Form {
      TextField("Title", text: $title)
        .font(.title2.bold())

      TextField("Write a note", text: $text, axis: .vertical)
        .lineLimit(12...30)
    }
    .navigationTitle(note == nil ? Text("New Note") : Text("Note"))
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      if note == nil {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel", role: .cancel) {
            dismiss()
          }
        }
      }

      ToolbarItem(placement: .confirmationAction) {
        Button("Save") {
          save()
        }
        .disabled(trimmedTitle.isEmpty)
      }
    }
    .onAppear {
      if let note {
        title = note.title
        text = note.text
      }
    }
    .alert("Save Failed", isPresented: isShowingPersistenceError) {
      Button("OK", role: .cancel) {
        persistenceError = nil
      }
    } message: {
      Text(persistenceError ?? String(localized: "Please try again."))
    }
  }

  private var trimmedTitle: String {
    title.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  private var trimmedText: String {
    text.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  private func save() {
    do {
      try context.performTransactionOrRollback {
        if let note {
          note.title = trimmedTitle
          note.text = trimmedText
          note.updatedAt = .now
        } else {
          context.insert(
            Note(
              title: trimmedTitle,
              text: trimmedText
            )
          )
        }
      }
      dismiss()
    } catch {
      persistenceError = error.localizedDescription
    }
  }

  private var isShowingPersistenceError: Binding<Bool> {
    Binding(
      get: { persistenceError != nil },
      set: { if !$0 { persistenceError = nil } }
    )
  }
}
