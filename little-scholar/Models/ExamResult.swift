import Foundation
import SwiftData

@Model
final class ExamResult {
    var parentID: String = ""
    var childProfileID: UUID = UUID()
    var childName: String = ""
    var grade: String = "Grade 1"
    var subject: String = Subject.math.rawValue
    var difficulty: String = Difficulty.easy.rawValue
    var totalQuestions: Int = 0
    var correctAnswers: Int = 0
    var completedAt: Date = Date.now
    var evaluations: [AnswerEvaluation] = []

    init(
        parentID: String = "",
        childProfileID: UUID,
        childName: String,
        grade: String,
        subject: String,
        difficulty: String,
        totalQuestions: Int,
        correctAnswers: Int,
        completedAt: Date = .now,
        evaluations: [AnswerEvaluation]
    ) {
        self.parentID = parentID
        self.childProfileID = childProfileID
        self.childName = childName
        self.grade = grade
        self.subject = subject
        self.difficulty = difficulty
        self.totalQuestions = totalQuestions
        self.correctAnswers = correctAnswers
        self.completedAt = completedAt
        self.evaluations = evaluations
    }

    var percentage: Int {
        guard totalQuestions > 0 else { return 0 }
        return Int((Double(correctAnswers) / Double(totalQuestions) * 100).rounded())
    }

    var reportGrade: String {
        switch percentage {
        case 90...100: "A+"
        case 80..<90: "A"
        case 70..<80: "B"
        case 60..<70: "C"
        default: "Keep Practicing"
        }
    }

    var feedback: String {
        switch percentage {
        case 90...100: "Fantastic focus! You are ready for a bigger challenge."
        case 75..<90: "Great work! Review the missed questions and try one harder exam."
        case 50..<75: "Good effort. A little more practice will make these ideas clearer."
        default: "Nice try. Practice with an easy exam and ask a grown-up for help."
        }
    }
}
