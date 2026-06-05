import Foundation

struct Answer: Codable, Identifiable, Hashable {
    var id: UUID
    var questionID: UUID
    var selectedAnswer: String

    init(id: UUID = UUID(), questionID: UUID, selectedAnswer: String) {
        self.id = id
        self.questionID = questionID
        self.selectedAnswer = selectedAnswer
    }
}

struct AnswerEvaluation: Codable, Identifiable, Hashable {
    var id: UUID
    var question: Question
    var selectedAnswer: String

    var isCorrect: Bool {
        selectedAnswer == question.correctAnswer
    }
}
