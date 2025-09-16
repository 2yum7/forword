//
//  ForwordApp.swift
//  Forword
//
//  Created by Ibuki on 11/09/2025.
//

import SwiftUI

#if os(iOS)
@main
struct ForwordApp: App {
    @StateObject private var entryStore = EntryStore()
    @StateObject private var draftStore = DraftStore()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(entryStore)
                .environmentObject(draftStore)
                .preferredColorScheme(nil)
        }
    }
}
#endif
