import Foundation

struct Entry: Identifiable, Codable {
    let id: UUID
    let date: Date
    let text: String
    let wordCount: Int
}
