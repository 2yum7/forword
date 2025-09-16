import SwiftUI

struct EntryDetailView: View {
    let entry: Entry
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header with date and word count
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(dateFormatter.string(from: entry.date))
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text("entry.words_count \(entry.wordCount)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding(.bottom, 8)
                
                // Entry text
                Text(entry.text)
                    .font(.body)
                    .lineSpacing(4)
                    .foregroundColor(.primary)
            }
            .padding()
        }
        .navigationTitle("entry.title")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    shareEntry()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .full
        f.timeStyle = .short
        return f
    }
    
    private func shareEntry() {
        let activityVC = UIActivityViewController(
            activityItems: [entry.text],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
}
