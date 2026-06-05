import Foundation

struct Question: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var prompt: String
    var options: [String]
    var correctAnswer: String
    var explanation: String
}

enum Subject: String, CaseIterable, Identifiable, Codable {
    case math = "Math"
    case english = "English"
    case science = "Science"
    case generalKnowledge = "General Knowledge"

    var id: String { rawValue }
}

enum Difficulty: String, CaseIterable, Identifiable, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    var id: String { rawValue }
}
