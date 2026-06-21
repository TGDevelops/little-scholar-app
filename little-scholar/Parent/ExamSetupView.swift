import SwiftUI

struct ExamSetupView: View {
    let profiles: [ChildProfile]
    let exams: [Exam]
    let onGenerateExam: (ChildProfile, Subject, Difficulty, Int) -> Void

    @State private var selectedProfileID: UUID?
    @State private var selectedSubject: Subject = .math
    @State private var selectedDifficulty: Difficulty = .easy
    @State private var numberOfQuestions = 5

    var body: some View {
        VStack(spacing: 16) {
            sectionCard(title: "Generate Practice", icon: "doc.badge.plus") {
                if profiles.isEmpty {
                    EmptyStateView(
                        icon: "person.2.slash",
                        title: "Add a kid first",
                        message: "Create a child profile before making practice."
                    )
                } else {
                    VStack(alignment: .leading, spacing: 14) {
                        Picker("Kid", selection: selectedProfileBinding) {
                            ForEach(profiles) { profile in
                                Text("\(profile.name), \(profile.grade)").tag(Optional(profile.profileID))
                            }
                        }
                        .pickerStyle(.menu)

                        Picker("Subject", selection: $selectedSubject) {
                            ForEach(Subject.allCases) { subject in
                                Text(subject.rawValue).tag(subject)
                            }
                        }
                        .pickerStyle(.menu)

                        Picker("Difficulty", selection: $selectedDifficulty) {
                            ForEach(Difficulty.allCases) { difficulty in
                                Text(difficulty.rawValue).tag(difficulty)
                            }
                        }
                        .pickerStyle(.segmented)

                        Stepper("Questions: \(numberOfQuestions)", value: $numberOfQuestions, in: 5...25, step: 5)
                            .font(.title3.bold())

                        Button {
                            guard let selectedProfile else { return }
                            onGenerateExam(selectedProfile, selectedSubject, selectedDifficulty, numberOfQuestions)
                        } label: {
                            Label("Generate Practice", systemImage: "sparkles")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(CheerfulButtonStyle(color: ScholarTheme.primary))
                        .disabled(selectedProfile == nil)
                    }
                }
            }

            ExamPreviewView(exams: exams.filter { !$0.isCompleted })
        }
        .onAppear(perform: ensureSelectedProfile)
        .onChange(of: profiles.map(\.profileID)) { _, _ in
            ensureSelectedProfile()
        }
    }

    private var selectedProfile: ChildProfile? {
        guard let selectedProfileID else { return profiles.first }
        return profiles.first { $0.profileID == selectedProfileID } ?? profiles.first
    }

    private var selectedProfileBinding: Binding<UUID?> {
        Binding(
            get: { selectedProfile?.profileID },
            set: { selectedProfileID = $0 }
        )
    }

    private func ensureSelectedProfile() {
        if selectedProfileID == nil || selectedProfile == nil {
            selectedProfileID = profiles.first?.profileID
        }
    }
}
