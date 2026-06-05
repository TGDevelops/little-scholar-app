import SwiftUI

struct ChildProfileView: View {
    let profiles: [ChildProfile]
    let onSaveProfile: (String, Int, String, KidAvatar) -> Void

    @State private var childName = ""
    @State private var age = 6
    @State private var grade = "Grade 1"
    @State private var avatar: KidAvatar = .unicorn

    private let grades = ["Nursery", "LKG", "UKG", "Kindergarten", "Grade 1", "Grade 2", "Grade 3", "Grade 4", "Grade 5"]

    var body: some View {
        VStack(spacing: 16) {
            sectionCard(title: "Create Kid Profile", icon: "person.crop.circle.badge.plus") {
                VStack(spacing: 14) {
                    TextField("Kid name", text: $childName)
                        .textFieldStyle(.roundedBorder)
                        .font(.title3)

                    Stepper("Age: \(age)", value: $age, in: 3...12)
                        .font(.title3.bold())

                    Picker("Grade", selection: $grade) {
                        ForEach(grades, id: \.self) { grade in
                            Text(grade).tag(grade)
                        }
                    }
                    .pickerStyle(.menu)

                    AvatarPicker(selection: $avatar)

                    Button {
                        onSaveProfile(childName, age, grade, avatar)
                        childName = ""
                    } label: {
                        Label("Add Kid Profile", systemImage: "plus.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(CheerfulButtonStyle(color: .orange))
                    .disabled(childName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }

            sectionCard(title: "Kid Profiles", icon: "person.3.fill") {
                if profiles.isEmpty {
                    EmptyStateView(
                        icon: "person.crop.circle.badge.plus",
                        title: "No profiles yet",
                        message: "Create one or more kid profiles to assign exams."
                    )
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(profiles) { profile in
                            ProfileRow(profile: profile)
                        }
                    }
                }
            }
        }
    }
}

struct ProfileRow: View {
    let profile: ChildProfile

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: KidAvatar.avatar(for: profile.avatar).icon)
                .font(.title)
                .foregroundStyle(.orange)
                .frame(width: 42)

            VStack(alignment: .leading, spacing: 4) {
                Text(profile.name)
                    .font(.title3.bold())
                Text("\(profile.avatar) • Age \(profile.age) • \(profile.grade)")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color.white.opacity(0.82))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
