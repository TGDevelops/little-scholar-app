import SwiftUI

struct ExamAttemptView: View {
    let exam: Exam
    let onSubmit: (Exam, [UUID: String]) -> ExamResult?

    @State private var currentIndex = 0
    @State private var answers: [UUID: String] = [:]

    private var currentQuestion: Question {
        exam.questions[currentIndex]
    }

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 6) {
                Text("\(exam.childName)'s \(exam.subject) Exam")
                    .font(.title2.bold())
                Text("Question \(currentIndex + 1) of \(exam.questions.count)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)

            ProgressView(value: Double(currentIndex + 1), total: Double(exam.questions.count))
                .tint(.orange)
                .padding(.horizontal)

            VStack(alignment: .leading, spacing: 18) {
                Text(currentQuestion.prompt)
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)

                ForEach(currentQuestion.options, id: \.self) { option in
                    Button {
                        answers[currentQuestion.id] = option
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: answers[currentQuestion.id] == option ? "checkmark.circle.fill" : "circle")
                                .font(.title2)
                            Text(option)
                                .font(.title3.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                        }
                        .padding()
                        .background(answers[currentQuestion.id] == option ? Color.green.opacity(0.24) : Color.white.opacity(0.82))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(20)
            .background(Color.white.opacity(0.92))
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: .black.opacity(0.08), radius: 12, y: 6)
            .padding(.horizontal)

            HStack(spacing: 12) {
                Button {
                    currentIndex = max(0, currentIndex - 1)
                } label: {
                    Label("Back", systemImage: "arrow.left.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(CheerfulButtonStyle(color: .gray))
                .disabled(currentIndex == 0)

                Button {
                    if currentIndex == exam.questions.count - 1 {
                        onSubmit(exam, answers)
                    } else {
                        currentIndex += 1
                    }
                } label: {
                    Label(currentIndex == exam.questions.count - 1 ? "Submit" : "Next", systemImage: "arrow.right.circle.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(CheerfulButtonStyle(color: .orange))
                .disabled(answers[currentQuestion.id] == nil)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 8)
    }
}

struct KidExamListView: View {
    let profiles: [ChildProfile]
    let exams: [Exam]
    let latestResult: ExamResult?
    let onSubmit: (Exam, [UUID: String]) -> Void
    let onCreateExam: () -> Void

    @State private var selectedProfileID: PersistentIdentifier?
    @State private var selectedExam: Exam?
    @State private var completedResult: ExamResult?

    var body: some View {
        Group {
            if let completedResult {
                ResultView(result: completedResult)
            } else if let selectedExam {
                ExamAttemptView(exam: selectedExam) { exam, answers in
                    if let result = onSubmit(exam, answers) {
                        self.completedResult = result
                        self.selectedExam = nil
                    }
                }
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        if let latestResult {
                            LatestResultBanner(result: latestResult)
                        }

                        profilePicker
                        assignedExams
                    }
                    .padding()
                }
                .onAppear(perform: ensureSelectedProfile)
                .onChange(of: profiles.map(\.profileID)) { _, _ in
                    ensureSelectedProfile()
                }
            }
        }
    }

    private var profilePicker: some View {
        sectionCard(title: "Choose Your Profile", icon: "figure.child.circle.fill") {
            if profiles.isEmpty {
                EmptyStateView(icon: "person.crop.circle.badge.questionmark", title: "No kid profiles", message: "Ask a parent to create a profile first.")
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 140), spacing: 12)], spacing: 12) {
                    ForEach(profiles) { profile in
                        Button {
                            selectedProfileID = profile.persistentModelID
                            selectedExam = nil
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: KidAvatar.avatar(for: profile.avatar).icon)
                                    .font(.system(size: 34))
                                    .foregroundStyle(selectedProfileID == profile.persistentModelID ? .green : .orange)
                                Text(profile.name)
                                    .font(.title3.bold())
                                    .foregroundStyle(.primary)
                                    .lineLimit(1)
                                Text(profile.grade)
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedProfileID == profile.persistentModelID ? Color.green.opacity(0.2) : Color.white.opacity(0.85))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var assignedExams: some View {
        sectionCard(title: "Your Exam Papers", icon: "doc.text.fill") {
            if selectedProfile == nil {
                EmptyStateView(icon: "hand.tap.fill", title: "Tap your profile", message: "Then your exam papers will appear here.")
            } else if examsForSelectedProfile.isEmpty {
                VStack(spacing: 14) {
                    EmptyStateView(icon: "doc.badge.clock", title: "No exam assigned", message: "Ask a parent to generate an exam paper for you.")
                    Button {
                        onCreateExam()
                    } label: {
                        Label("Go to Exam Mode", systemImage: "doc.badge.plus")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(CheerfulButtonStyle(color: .teal))
                }
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(examsForSelectedProfile) { exam in
                        Button {
                            selectedExam = exam
                        } label: {
                            ExamStartRow(exam: exam)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var selectedProfile: ChildProfile? {
        guard let selectedProfileID else { return nil }
        return profiles.first { $0.persistentModelID == selectedProfileID }
    }

    private var examsForSelectedProfile: [Exam] {
        guard let selectedProfile else { return [] }
        return exams.filter { $0.childProfileID == selectedProfile.profileID }
    }

    private func ensureSelectedProfile() {
        if let selectedProfileID, !profiles.contains(where: { $0.persistentModelID == selectedProfileID }) {
            self.selectedProfileID = nil
        }
    }
}

struct ExamStartRow: View {
    let exam: Exam

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label(exam.subject, systemImage: "book.fill")
                    .font(.title3.bold())
                    .foregroundStyle(.primary)
                Spacer()
                Text(exam.difficulty)
                    .font(.headline)
                    .foregroundStyle(.orange)
            }
            Text("\(exam.questions.count) questions • \(exam.createdAt.formatted(date: .abbreviated, time: .shortened))")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
            Text("Start Exam")
                .font(.headline)
                .foregroundStyle(.teal)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
