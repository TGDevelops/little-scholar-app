import SwiftUI

struct ResultView: View {
    let result: ExamResult

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 12) {
                    Image(systemName: result.percentage >= 70 ? "star.circle.fill" : "heart.circle.fill")
                        .font(.system(size: 64))
                        .foregroundStyle(result.percentage >= 70 ? .yellow : .pink)

                    Text("Great try, \(result.childName)!")
                        .font(.title.bold())
                        .multilineTextAlignment(.center)

                    Text("Score: \(result.correctAnswers)/\(result.totalQuestions)")
                        .font(.largeTitle.bold())

                    Text("\(result.percentage)% • \(result.reportGrade)")
                        .font(.title2.bold())
                        .foregroundStyle(.teal)

                    Text(result.feedback)
                        .font(.title3.weight(.medium))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
                .padding(24)
                .background(Color.white.opacity(0.92))
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: .black.opacity(0.08), radius: 12, y: 6)

                QuestionReviewList(evaluations: result.evaluations)
            }
            .padding()
        }
        .background(LittleScholarBackground())
        .navigationTitle("Exam Result")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LatestResultBanner: View {
    let result: ExamResult

    var body: some View {
        NavigationLink {
            ResultView(result: result)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 42))
                    .foregroundStyle(.yellow)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Latest Result")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text("\(result.subject): \(result.percentage)% • \(result.reportGrade)")
                        .font(.title3.bold())
                        .foregroundStyle(.primary)
                }

                Spacer()
                Image(systemName: "chevron.right")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(Color.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .black.opacity(0.07), radius: 10, y: 5)
            .padding(.horizontal)
        }
        .buttonStyle(.plain)
    }
}

struct QuestionReviewList: View {
    let evaluations: [AnswerEvaluation]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(evaluations) { item in
                VStack(alignment: .leading, spacing: 8) {
                    Label(item.isCorrect ? "Correct" : "Needs Practice", systemImage: item.isCorrect ? "checkmark.seal.fill" : "xmark.seal.fill")
                        .font(.headline)
                        .foregroundStyle(item.isCorrect ? .green : .red)

                    Text(item.question.prompt)
                        .font(.headline)

                    Text("Your answer: \(item.selectedAnswer)")
                        .foregroundStyle(item.isCorrect ? .green : .red)

                    if !item.isCorrect {
                        Text("Correct answer: \(item.question.correctAnswer)")
                            .foregroundStyle(.primary)
                    }

                    Text(item.question.explanation)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.white.opacity(0.88))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
        }
    }
}
