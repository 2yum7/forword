import Foundation

final class DraftStore: ObservableObject {
    @Published var draftText: String = "" // 後で自動保存を実装

    static let userDefaultsKey = "draft.text"
}
