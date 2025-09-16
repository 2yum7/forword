import SwiftUI

struct EntriesListView: View {
    @EnvironmentObject private var entryStore: EntryStore
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Search field
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("common.search_entries", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                
                // Entries list
                if filteredEntries.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredEntries) { entry in
                                NavigationLink(destination: EntryDetailView(entry: entry)) {
                                    entryCard(entry)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("entries.title_all")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var filteredEntries: [Entry] {
        if searchText.isEmpty {
            return entryStore.entries
        } else {
            return entryStore.entries.filter { entry in
                entry.text.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            Text("empty.no_entries")
                .font(.title2)
                .fontWeight(.medium)
            Text("empty.start_writing_list_hint")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func entryCard(_ entry: Entry) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(dateFormatter.string(from: entry.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("entry.words_count \(entry.wordCount)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Text(snippet(from: entry.text))
                .foregroundColor(.primary)
                .lineLimit(2)
            HStack(spacing: 6) {
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
                Text("entry.completed")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }
    
    private func snippet(from text: String) -> String {
        if text.count <= 140 { return text }
        let idx = text.index(text.startIndex, offsetBy: 140)
        return String(text[..<idx]) + "…"
    }
}
