import Foundation

final class ChildProfile: Identifiable {
    var id: UUID { profileID }
    var profileID: UUID = UUID()
    var backendID: String = ""
    var parentID: String = ""
    var name: String = ""
    var age: Int = 6
    var grade: String = "Grade 1"
    var avatar: String = KidAvatar.unicorn.rawValue
    var createdAt: Date = Date.now

    init(profileID: UUID = UUID(), backendID: String = "", parentID: String = "", name: String, age: Int, grade: String, avatar: KidAvatar = .unicorn, createdAt: Date = .now) {
        self.profileID = profileID
        self.backendID = backendID
        self.parentID = parentID
        self.name = name
        self.age = age
        self.grade = grade
        self.avatar = avatar.rawValue
        self.createdAt = createdAt
    }
}

enum KidAvatar: String, CaseIterable, Identifiable, Codable {
    case unicorn = "Unicorn"
    case princess = "Princess"
    case superhero = "Superhero"
    case spaceHero = "Space Hero"
    case shieldHero = "Shield Hero"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .unicorn: "sparkles"
        case .princess: "crown.fill"
        case .superhero: "bolt.fill"
        case .spaceHero: "star.circle.fill"
        case .shieldHero: "shield.fill"
        }
    }

    static func avatar(for rawValue: String) -> KidAvatar {
        KidAvatar(rawValue: rawValue) ?? .unicorn
    }
}
