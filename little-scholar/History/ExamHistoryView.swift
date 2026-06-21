import SwiftUI

struct ExamHistoryView: View {
    let results: [ExamResult]

    var body: some View {
        if results.isEmpty {
            EmptyStateView(icon: "clock.badge.questionmark", title: "No completed practice", message: "Completed practice results will appear here.")
                .padding(.top, 24)
        } else {
            LazyVStack(spacing: 14) {
                ForEach(results) { result in
                    NavigationLink {
                        ResultView(result: result)
                    } label: {
                        ResultHistoryRow(result: result)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct ResultHistoryRow: View {
    let result: ExamResult

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(result.childName)
                        .font(.title3.bold())
                        .foregroundStyle(.primary)
                    Text("\(result.subject) • \(result.grade) • \(result.difficulty)")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text("\(result.percentage)%")
                    .font(.title.bold())
                    .foregroundStyle(ScholarTheme.primary)
            }

            Text(result.completedAt.formatted(date: .abbreviated, time: .shortened))
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Text("\(result.correctAnswers) correct, \(result.totalQuestions - result.correctAnswers) wrong")
                .font(.headline)
                .foregroundStyle(ScholarTheme.primary)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.07), radius: 10, y: 5)
    }
}
