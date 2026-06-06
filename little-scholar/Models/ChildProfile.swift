import Foundation
import SwiftData

@Model
final class ChildProfile {
    var profileID: UUID = UUID()
    var parentID: String = ""
    var name: String = ""
    var age: Int = 6
    var grade: String = "Grade 1"
    var avatar: String = KidAvatar.unicorn.rawValue
    var createdAt: Date = Date.now

    init(profileID: UUID = UUID(), parentID: String = "", name: String, age: Int, grade: String, avatar: KidAvatar = .unicorn, createdAt: Date = .now) {
        self.profileID = profileID
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
