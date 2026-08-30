import SwiftData
import SwiftUI

struct NotesView: View {
  @State private var searchText = ""

  var body: some View {
    NavigationStack {
      NoteList(searchText: searchText)
        .navigationTitle("Notes")
        .searchable(text: $searchText, prompt: "Search Notes")
    }
  }
}

private struct NoteList: View {
  @Environment(\.modelContext) private var context
  @Query private var notes: [Note]

  @State private var isEditorPresented = false
  @State private var deletionError: String?

  let searchText: String

  init(searchText: String = "") {
    self.searchText = searchText
    _notes = Query(
      filter: Note.predicate(searchText: searchText),
      sort: \Note.updatedAt,
      order: .reverse
    )
  }

  var body: some View {
    Group {
      if notes.isEmpty {
        ContentUnavailableView(
          searchText.isEmpty ? "No Notes Yet" : "No Results",
          systemImage: searchText.isEmpty
            ? "note.text.badge.plus"
            : "magnifyingglass",
          description: Text(
            searchText.isEmpty
              ? "Capture a thought to begin your vault."
              : "Try a different search."
          )
        )
      } else {
        List {
          ForEach(notes) { note in
            NavigationLink {
              NoteEditorView(note: note)
            } label: {
              VStack(alignment: .leading, spacing: 6) {
                Text(note.title)
                  .font(.headline)
                  .lineLimit(1)

                if !note.text.isEmpty {
                  Text(note.text)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                }

                Text(
                  note.updatedAt,
                  format: .dateTime.month().day().hour().minute()
                )
                .font(.caption)
                .foregroundStyle(.tertiary)
              }
            }
          }
          .onDelete(perform: deleteNotes(indexes:))
        }
      }
    }
    .toolbar {
      ToolbarItem {
        Button("New Note", systemImage: "plus", action: addNote)
      }
      ToolbarItem(placement: .topBarTrailing) {
        EditButton()
      }
    }
    .sheet(isPresented: $isEditorPresented) {
      NavigationStack {
        NoteEditorView(note: nil)
      }
      .interactiveDismissDisabled()
    }
    .alert("Delete Failed", isPresented: isShowingDeletionError) {
      Button("OK", role: .cancel) {
        deletionError = nil
      }
    } message: {
      Text(deletionError ?? String(localized: "Please try again."))
    }
  }

  private func addNote() {
    isEditorPresented = true
  }

  private func deleteNotes(indexes: IndexSet) {
    do {
      try context.performTransactionOrRollback {
        for index in indexes {
          context.delete(notes[index])
        }
      }
    } catch {
      deletionError = error.localizedDescription
    }
  }

  private var isShowingDeletionError: Binding<Bool> {
    Binding(
      get: { deletionError != nil },
      set: { if !$0 { deletionError = nil } }
    )
  }
}

#Preview {
  NotesView()
    .sampleDataContainer()
}
