import SwiftUI

#if os(iOS)
@main
struct ForwordApp: App {
    @StateObject private var entryStore = EntryStore()
    @StateObject private var draftStore = DraftStore()
    @AppStorage("appTheme") private var themeRaw: Int = AppTheme.system.rawValue

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(entryStore)
                .environmentObject(draftStore)
                .applyAppTheme(AppTheme(rawValue: themeRaw) ?? .system)
        }
    }
}
#endif
