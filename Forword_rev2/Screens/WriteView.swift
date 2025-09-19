import SwiftUI

struct WriteView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var entryStore: EntryStore
    @EnvironmentObject var draftStore: DraftStore

    @State private var text: String = ""
    @State private var previousText: String = ""
    @State private var isPaused: Bool = false
    @State private var showedNoDeleteHint: Bool = false

    @State private var autosaveTimer: Timer? = nil

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Top bar with word count
                HStack {
                    Spacer()
                    Text("\(wordCount)")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .padding(.trailing)
                        .padding(.top, 8)
                }
                
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $text)
                        .padding(.horizontal)
                        .disabled(isPaused)
                        .opacity(isPaused ? 0.5 : 1.0)
                        .onChange(of: text) { _, newValue in
                            handleTextChange(newValue)
                        }

                    if text.isEmpty {
                        Text("write.placeholder")
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

 
                // Bottom bar discard and save button
                HStack {
                    Button("common.discard") {
                        discardAndClose()
                    }
                    Spacer()
                    Button("common.save") {
                        finishAndSave()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .padding()

            }
            .navigationTitle("write.title")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("common.cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            bootstrapDraft()
            startAutosave()
        }
        .onDisappear {
            stopAutosave()
            persistDraft()
        }
    }

    private var wordCount: Int {
        let words = text.split { $0.isWhitespace || $0.isNewline }
        return words.count
    }

    private func handleTextChange(_ newValue: String) {
        // Block deletions: if the new text is shorter, revert.
        if newValue.count < previousText.count && !isPaused {
            // Revert to previous and show one-time hint
            text = previousText
            if !showedNoDeleteHint {
                showedNoDeleteHint = true
            }
            return
        }
        previousText = text
        draftStore.draftText = text
    }

    private func finishAndSave() {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            dismiss()
            return
        }
        let entry = Entry(id: UUID(), date: Date(), text: trimmed, wordCount: wordCount)
        entryStore.entries.insert(entry, at: 0)
        // Clear draft
        text = ""
        previousText = ""
        draftStore.draftText = ""
        UserDefaults.standard.removeObject(forKey: DraftStore.userDefaultsKey)
        dismiss()
    }

    private func discardAndClose() {
        text = ""
        previousText = ""
        draftStore.draftText = ""
        UserDefaults.standard.removeObject(forKey: DraftStore.userDefaultsKey)
        dismiss()
    }

    private func bootstrapDraft() {
        // Load last draft if available
        if let saved = UserDefaults.standard.string(forKey: DraftStore.userDefaultsKey) {
            text = saved
            previousText = saved
            draftStore.draftText = saved
        } else {
            text = draftStore.draftText
            previousText = draftStore.draftText
        }
    }

    private func startAutosave() {
        stopAutosave()
        autosaveTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            persistDraft()
        }
    }

    private func stopAutosave() {
        autosaveTimer?.invalidate()
        autosaveTimer = nil
    }

    private func persistDraft() {
        UserDefaults.standard.set(text, forKey: DraftStore.userDefaultsKey)
    }
}