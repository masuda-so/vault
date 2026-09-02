import SwiftData
import SwiftUI

struct AssistantView: View {
  @Environment(AppEnvironment.self) private var environment
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \Note.updatedAt, order: .reverse) private var notes: [Note]

  @Binding var selection: AppSection

  @State private var text = ""
  @State private var generationTask: Task<Void, Never>?
  @State private var selectedNoteID: PersistentIdentifier?
  @State private var organizedTitle = ""
  @State private var organizedTags = ""
  @State private var organizedSummary = ""
  @State private var hasOrganizationDraft = false
  @State private var persistenceError: String?
  @State private var isConfirmingSave = false

  var body: some View {
    NavigationStack {
      Group {
        switch environment.aiAvailability {
        case .available:
          if environment.isPremium {
            assistantForm
          } else {
            lockedView
          }
        case .unavailable(.appleIntelligenceDisabled):
          unavailableView(
            message: String(
              localized: "The assistant is unavailable because Apple Intelligence isn’t turned on."
            )
          )
        case .unavailable(.modelNotReady):
          unavailableView(
            message: String(localized: "The assistant isn’t ready yet. Try again later.")
          )
        case .unavailable(let reason):
          unavailableView(message: reason.localizedDescription)
        }
      }
      .navigationTitle(environment.product.assistantTitle)
      .onDisappear {
        generationTask?.cancel()
        generationTask = nil
      }
      .alert("Save Failed", isPresented: isShowingPersistenceError) {
        Button("OK", role: .cancel) {
          persistenceError = nil
        }
      } message: {
        Text(persistenceError ?? String(localized: "Please try again."))
      }
      .confirmationDialog(
        saveConfirmationTitle,
        isPresented: $isConfirmingSave,
        titleVisibility: .visible
      ) {
        Button(saveActionTitle) {
          saveOrganizationDraft()
        }
        Button("Cancel", role: .cancel) {}
      } message: {
        Text("Nothing changes until you confirm this action.")
      }
    }
  }

  private var assistantForm: some View {
    Form {
      Section("Source Note") {
        Picker("Note", selection: $selectedNoteID) {
          Text("New Note").tag(nil as PersistentIdentifier?)
          ForEach(notes) { note in
            Text(note.title).tag(Optional(note.persistentModelID))
          }
        }
        .disabled(environment.isGenerating)
        .onChange(of: selectedNoteID) {
          loadSelectedNote()
        }

        TextEditor(text: $text)
          .frame(minHeight: 130)
          .accessibilityLabel(environment.product.assistantInputTitle)
          .disabled(environment.isGenerating)
          .onChange(of: text) {
            if !environment.isGenerating {
              clearOrganizationDraft()
            }
          }
      }

      Section {
        if environment.isGenerating {
          HStack {
            ProgressView()
            Text(environment.product.assistantProgressTitle)
            Spacer()
            Button("Stop", role: .cancel) {
              generationTask?.cancel()
            }
          }
        } else {
          Button {
            startGeneration()
          } label: {
            Label(environment.product.assistantActionTitle, systemImage: "sparkles")
              .frame(maxWidth: .infinity)
          }
          .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
      } footer: {
        Text(availabilityMessage)
      }

      if let errorMessage = environment.assistantErrorMessage {
        Section("Couldn’t Generate") {
          Text(errorMessage)
            .foregroundStyle(.secondary)
        }
      }

      if hasOrganizationDraft {
        Section {
          TextField("Title", text: $organizedTitle)
          TextField("Tags", text: $organizedTags)
          TextField("Summary", text: $organizedSummary, axis: .vertical)
            .lineLimit(3...8)

          Button(saveActionTitle) {
            isConfirmingSave = true
          }
          .disabled(!canSaveOrganizationDraft)
          .buttonStyle(.borderedProminent)
          .tint(environment.product.accent)

          Button("Discard Suggestion", role: .cancel) {
            clearOrganizationDraft()
          }
        } header: {
          Text(environment.product.assistantOutputTitle)
        } footer: {
          Text(
            "Generated on this device with Apple Foundation Models. AI output may be inaccurate. Review and edit every field before saving. The original note is preserved until you confirm Save or Apply."
          )
        }
      }
    }
  }

  private func startGeneration() {
    let requestText: String
    let requestedNoteID = selectedNoteID
    if let selectedNote {
      requestText = "Current title: \(selectedNote.title)\n\n\(text)"
    } else {
      requestText = text
    }
    clearOrganizationDraft()
    generationTask?.cancel()
    generationTask = Task {
      await environment.requestAssistantResponse(for: requestText)
      guard !Task.isCancelled, requestedNoteID == selectedNoteID else {
        generationTask = nil
        return
      }
      if let draft = environment.assistantResponse {
        organizedTitle = draft.title
        organizedTags = draft.tagsText
        organizedSummary = draft.summary
        hasOrganizationDraft = true
      }
      generationTask = nil
    }
  }

  private var selectedNote: Note? {
    guard let selectedNoteID else { return nil }
    return notes.first { $0.persistentModelID == selectedNoteID }
  }

  private var canSaveOrganizationDraft: Bool {
    !organizedTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
      && !organizedSummary.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  private var saveActionTitle: LocalizedStringKey {
    selectedNote == nil ? "Save as New Note" : "Apply to Note"
  }

  private var saveConfirmationTitle: LocalizedStringKey {
    selectedNote == nil ? "Save Organized Note?" : "Apply Changes to Note?"
  }

  private func loadSelectedNote() {
    text = selectedNote?.text ?? ""
    clearOrganizationDraft()
  }

  private func clearOrganizationDraft() {
    environment.assistantResponse = nil
    organizedTitle = ""
    organizedTags = ""
    organizedSummary = ""
    hasOrganizationDraft = false
  }

  private func saveOrganizationDraft() {
    let title = organizedTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    let sourceText = text.trimmingCharacters(in: .whitespacesAndNewlines)
    let tags = NoteOrganizationDraft.approvedTagsText(from: organizedTags)
    let summary = organizedSummary.trimmingCharacters(in: .whitespacesAndNewlines)

    do {
      try modelContext.performTransactionOrRollback {
        if let selectedNote {
          selectedNote.title = title
          selectedNote.text = sourceText
          selectedNote.tags = tags.isEmpty ? nil : tags
          selectedNote.summary = summary
          selectedNote.updatedAt = .now
        } else {
          modelContext.insert(
            Note(
              title: title,
              text: sourceText,
              tags: tags.isEmpty ? nil : tags,
              summary: summary
            )
          )
        }
      }
      clearOrganizationDraft()
      selection = .notes
    } catch {
      persistenceError = error.localizedDescription
    }
  }

  private var lockedView: some View {
    ContentUnavailableView {
      Label(
        "\(environment.product.assistantTitle) is a Pro feature",
        systemImage: "crown.fill"
      )
    } description: {
      Text(
        "Choose the non-renewing Daily Pass or an auto-renewing plan to use the on-device assistant."
      )
    } actions: {
      Button("View Pro options") {
        selection = .pro
      }
      .buttonStyle(.borderedProminent)
      .tint(environment.product.accent)
    }
  }

  private func unavailableView(message: String) -> some View {
    ContentUnavailableView {
      Label(environment.product.assistantTitle, systemImage: "apple.intelligence")
    } description: {
      Text(message)
    }
  }

  private var availabilityMessage: String {
    switch environment.aiAvailability {
    case .available:
      return String(localized: "Processed on this device with Apple Foundation Models.")
    case .unavailable(let reason):
      return String(
        localized:
          "\(reason.localizedDescription) \(environment.product.name) remains usable without the assistant."
      )
    }
  }

  private var isShowingPersistenceError: Binding<Bool> {
    Binding(
      get: { persistenceError != nil },
      set: { if !$0 { persistenceError = nil } }
    )
  }
}
