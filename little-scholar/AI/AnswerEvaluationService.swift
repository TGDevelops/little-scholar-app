import Foundation

struct AnswerEvaluationService {
    func evaluate(exam: Exam, answers: [UUID: String]) -> ExamResult {
        let evaluations = exam.questions.map { question in
            AnswerEvaluation(
                id: question.id,
                question: question,
                selectedAnswer: answers[question.id] ?? "No answer"
            )
        }

        return ExamResult(
            childProfileID: exam.childProfileID,
            childBackendID: exam.childBackendID,
            childName: exam.childName,
            grade: exam.grade,
            subject: exam.subject,
            difficulty: exam.difficulty,
            totalQuestions: exam.questions.count,
            correctAnswers: evaluations.filter(\.isCorrect).count,
            evaluations: evaluations
        )
    }
}
