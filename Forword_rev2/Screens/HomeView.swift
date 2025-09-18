//
//  HomeView.swift
//  Forword
//
//  Created by Ibuki on 11/09/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var entryStore: EntryStore
    @State private var showingWriteSession = false
    @State private var searchText: String = ""
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 16) {
                        header
                        searchField
                        recentEntries
                    }
                }
                .ignoresSafeArea(edges: .top)
                
                floatingWriteButton
                    .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.title2)
                    }
                }
            }
        }
        .sheet(isPresented: $showingWriteSession) {
            WriteView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        
    }
    
    private var header: some View {
        VStack(spacing: 12) {

        HStack(spacing: 32) {
            Text("home.this_month \(thisMonthCount)")
                .font(.footnote)
                .foregroundColor(.white.opacity(0.9))
            Text("home.day_streak \(dayStreak)")
                .font(.footnote)
                .foregroundColor(.white.opacity(0.9))
        }
           /*   
            HStack(spacing: 32) {
                statBlock(number: thisMonthCount, label: "home.this_month")
                statBlock(number: dayStreak, label: "home.day_streak")
            }
            */
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .background(
            LinearGradient(colors: [Color.blue.opacity(0.9), Color.blue], startPoint: .top, endPoint: .bottom)
        )
        .cornerRadius(24)
        .padding(.horizontal)
        .padding(.top, 100)
    }
    
    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("common.search_entries", text: $searchText)
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .padding(.horizontal)
        .padding(.top, 16)
    }
    
    
    
    private var recentEntries: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("home.recent_entries")
                    .font(.title3).bold()
                Spacer()
                if !filteredEntries.isEmpty {
                    NavigationLink("common.view_all") {
                        EntriesListView()
                    }
                }
            }
            
            if filteredEntries.isEmpty {
                emptyState
            } else {
                ForEach(filteredEntries.prefix(3)) { entry in
                    entryCard(entry)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 80)
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "book.closed")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("empty.no_entries")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Text("empty.start_writing_hint")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
    
    private var floatingWriteButton: some View {
        Button {
            showingWriteSession = true
        } label: {
            Image(systemName: "plus")
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Color.blue)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
        .accessibilityLabel("home.start_writing")
    }
    
    private func statBlock(number: Int, label: String) -> some View {
        VStack(spacing: 4) {
            Text("\(number)")
                .font(.title3).bold()
                .foregroundColor(.white)
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.9))
        }
    }
    
    private var filteredEntries: [Entry] {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return entryStore.entries
        }
        return entryStore.entries.filter { $0.text.localizedCaseInsensitiveContains(searchText) }
    }
    
    private var totalWordsWritten: Int {
        entryStore.entries.reduce(0) { $0 + $1.wordCount }
    }
    
    private var thisMonthCount: Int {
        let cal = Calendar.current
        return entryStore.entries.filter { cal.isDate($0.date, equalTo: Date(), toGranularity: .month) }.count
    }
    
    private var dayStreak: Int {
        // Simple placeholder streak based on consecutive days with entries
        let dates = Set(entryStore.entries.map { Calendar.current.startOfDay(for: $0.date) })
        var streak = 0
        var day = Calendar.current.startOfDay(for: Date())
        while dates.contains(day) {
            streak += 1
            day = Calendar.current.date(byAdding: .day, value: -1, to: day) ?? day
        }
        return max(streak, 0)
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

#Preview {
    HomeView()
}
