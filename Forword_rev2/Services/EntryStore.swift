import Foundation

// MARK: - Models dependency
// Ensure the Entry model is visible when building as a module
#if canImport(SwiftUI)
import SwiftUI
#endif

final class EntryStore: ObservableObject {
    @Published var entries: [Entry] = [] // 後で保存/読み込みを実装

    func saveToDisk() {
        // TODO: Implement persistence
    }
}
