import SwiftUI

struct ExamPreviewView: View {
    let exams: [Exam]

    var body: some View {
        sectionCard(title: "Pending Practice", icon: "tray.full.fill") {
            if exams.isEmpty {
                EmptyStateView(
                    icon: "tray",
                    title: "No pending papers",
                    message: "Generated practice will wait here until your child completes it."
                )
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(exams) { exam in
                        NavigationLink {
                            ExamQuestionPreviewView(exam: exam)
                        } label: {
                            ExamPreviewRow(exam: exam)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

struct ExamQuestionPreviewView: View {
    let exam: Exam

    var body: some View {
        List {
            Section("Practice") {
                LabeledContent("Kid", value: exam.childName)
                LabeledContent("Grade", value: exam.grade)
                LabeledContent("Subject", value: exam.subject)
                LabeledContent("Difficulty", value: exam.difficulty)
            }

            Section("Questions") {
                ForEach(exam.questions) { question in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(question.prompt)
                            .font(.headline)
                        Text("Answer: \(question.correctAnswer)")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(ScholarTheme.primary)
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .navigationTitle("Practice Preview")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ExamPreviewRow: View {
    let exam: Exam

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "doc.text.fill")
                .font(.title)
                .foregroundStyle(ScholarTheme.primary)
                .frame(width: 42)

            VStack(alignment: .leading, spacing: 4) {
                Text("\(exam.childName) • \(exam.subject)")
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text("\(exam.difficulty) • \(exam.questions.count) questions")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
            }

            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.white.opacity(0.82))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
