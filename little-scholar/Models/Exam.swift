import Foundation

final class Exam: Identifiable {
    var id: UUID { examID }
    var examID: UUID = UUID()
    var backendID: String = ""
    var parentID: String = ""
    var childProfileID: UUID = UUID()
    var childBackendID: String = ""
    var childName: String = ""
    var grade: String = "Grade 1"
    var subject: String = Subject.math.rawValue
    var difficulty: String = Difficulty.easy.rawValue
    var createdAt: Date = Date.now
    var isCompleted: Bool = false
    var questions: [Question] = []

    init(
        examID: UUID = UUID(),
        backendID: String = "",
        parentID: String = "",
        childProfileID: UUID,
        childBackendID: String = "",
        childName: String,
        grade: String,
        subject: Subject,
        difficulty: Difficulty,
        questions: [Question],
        createdAt: Date = .now,
        isCompleted: Bool = false
    ) {
        self.examID = examID
        self.backendID = backendID
        self.parentID = parentID
        self.childProfileID = childProfileID
        self.childBackendID = childBackendID
        self.childName = childName
        self.grade = grade
        self.subject = subject.rawValue
        self.difficulty = difficulty.rawValue
        self.questions = questions
        self.createdAt = createdAt
        self.isCompleted = isCompleted
    }
}
