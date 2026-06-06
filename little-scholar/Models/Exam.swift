import Foundation
import SwiftData

@Model
final class Exam {
    var examID: UUID = UUID()
    var parentID: String = ""
    var childProfileID: UUID = UUID()
    var childName: String = ""
    var grade: String = "Grade 1"
    var subject: String = Subject.math.rawValue
    var difficulty: String = Difficulty.easy.rawValue
    var createdAt: Date = Date.now
    var isCompleted: Bool = false
    var questions: [Question] = []

    init(
        examID: UUID = UUID(),
        parentID: String = "",
        childProfileID: UUID,
        childName: String,
        grade: String,
        subject: Subject,
        difficulty: Difficulty,
        questions: [Question],
        createdAt: Date = .now,
        isCompleted: Bool = false
    ) {
        self.examID = examID
        self.parentID = parentID
        self.childProfileID = childProfileID
        self.childName = childName
        self.grade = grade
        self.subject = subject.rawValue
        self.difficulty = difficulty.rawValue
        self.questions = questions
        self.createdAt = createdAt
        self.isCompleted = isCompleted
    }
}
