//
//  ContentView.swift
//  little-scholar
//
//  Created by Tejesh on 26/05/26.
//

import Foundation
import PhotosUI
import SwiftData
import SwiftUI
import UIKit

@Model
final class ChildProfile {
    var profileID: UUID = UUID()
    var backendChildID: String?
    var parentID: String = ""
    var name: String = ""
    var age: Int = 6
    var grade: String = "Grade 1"
    var avatar: String = KidAvatar.unicorn.rawValue
    var createdAt: Date = Date.now

    init(profileID: UUID = UUID(), backendChildID: String? = nil, parentID: String = "", name: String, age: Int, grade: String, avatar: KidAvatar = .unicorn, createdAt: Date = .now) {
        self.profileID = profileID
        self.backendChildID = backendChildID
        self.parentID = parentID
        self.name = name
        self.age = age
        self.grade = grade
        self.avatar = avatar.rawValue
        self.createdAt = createdAt
    }
}

@Model
final class Exam {
    var examID: UUID = UUID()
    var parentID: String = ""
    var childProfileID: UUID = UUID()
    var childName: String = ""
    var grade: String = "Grade 1"
    var subject: String = Subject.maths.rawValue
    var difficulty: String = Difficulty.easy.rawValue
    var createdAt: Date = Date.now
    var isCompleted: Bool = false
    var questions: [Question] = []

    init(parentID: String = "", childProfileID: UUID, childName: String, grade: String, subject: Subject, difficulty: Difficulty, questions: [Question]) {
        self.parentID = parentID
        self.childProfileID = childProfileID
        self.childName = childName
        self.grade = grade
        self.subject = subject.rawValue
        self.difficulty = difficulty.rawValue
        self.questions = questions
    }
}

@Model
final class ExamResult {
    var parentID: String = ""
    var childProfileID: UUID = UUID()
    var childName: String = ""
    var grade: String = "Grade 1"
    var subject: String = Subject.maths.rawValue
    var difficulty: String = Difficulty.easy.rawValue
    var totalQuestions: Int = 0
    var correctAnswers: Int = 0
    var completedAt: Date = Date.now
    var evaluations: [AnswerEvaluation] = []

    init(parentID: String = "", childProfileID: UUID, childName: String, grade: String, subject: String, difficulty: String, totalQuestions: Int, correctAnswers: Int, evaluations: [AnswerEvaluation]) {
        self.parentID = parentID
        self.childProfileID = childProfileID
        self.childName = childName
        self.grade = grade
        self.subject = subject
        self.difficulty = difficulty
        self.totalQuestions = totalQuestions
        self.correctAnswers = correctAnswers
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
        case 75..<90: "Great work! Review the missed questions and try one harder practice."
        case 50..<75: "Good effort. A little more practice will make these ideas clearer."
        default: "Nice try. Start with an easy practice and ask a grown-up for help."
        }
    }
}

struct Question: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    var backendID: String = ""
    var type: String = "mcq"
    var prompt: String
    var options: [String]
    var correctAnswer: String
    var acceptableAnswers: [String] = []
    var explanation: String
    var topic: String = "General"
    var marks: Int = 1
    var visualElements: [String] = []
    var leftItems: [String] = []
    var rightItems: [String] = []
    var passage: String?
    var categories: [String] = []
    var learningObjective: String = ""
    var difficultyLevel: String = ""

    enum CodingKeys: String, CodingKey {
        case id
        case backendID
        case type
        case prompt
        case options
        case correctAnswer
        case acceptableAnswers
        case explanation
        case topic
        case marks
        case visualElements
        case leftItems
        case rightItems
        case passage
        case categories
        case learningObjective
        case difficultyLevel
    }

    init(
        id: UUID = UUID(),
        backendID: String = "",
        type: String = "mcq",
        prompt: String,
        options: [String],
        correctAnswer: String,
        acceptableAnswers: [String] = [],
        explanation: String,
        topic: String = "General",
        marks: Int = 1,
        visualElements: [String] = [],
        leftItems: [String] = [],
        rightItems: [String] = [],
        passage: String? = nil,
        categories: [String] = [],
        learningObjective: String = "",
        difficultyLevel: String = ""
    ) {
        self.id = id
        self.backendID = backendID
        self.type = type
        self.prompt = prompt
        self.options = options
        self.correctAnswer = correctAnswer
        self.acceptableAnswers = acceptableAnswers
        self.explanation = explanation
        self.topic = topic
        self.marks = marks
        self.visualElements = visualElements
        self.leftItems = leftItems
        self.rightItems = rightItems
        self.passage = passage
        self.categories = categories
        self.learningObjective = learningObjective
        self.difficultyLevel = difficultyLevel
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        backendID = try container.decodeIfPresent(String.self, forKey: .backendID) ?? ""
        type = try container.decodeIfPresent(String.self, forKey: .type) ?? "mcq"
        prompt = try container.decode(String.self, forKey: .prompt)
        options = try container.decodeIfPresent([String].self, forKey: .options) ?? []
        correctAnswer = try container.decode(String.self, forKey: .correctAnswer)
        acceptableAnswers = try container.decodeIfPresent([String].self, forKey: .acceptableAnswers) ?? []
        explanation = try container.decode(String.self, forKey: .explanation)
        topic = try container.decodeIfPresent(String.self, forKey: .topic) ?? "General"
        marks = try container.decodeIfPresent(Int.self, forKey: .marks) ?? 1
        visualElements = try container.decodeIfPresent([String].self, forKey: .visualElements) ?? []
        leftItems = try container.decodeIfPresent([String].self, forKey: .leftItems) ?? []
        rightItems = try container.decodeIfPresent([String].self, forKey: .rightItems) ?? []
        passage = try container.decodeIfPresent(String.self, forKey: .passage)
        categories = try container.decodeIfPresent([String].self, forKey: .categories) ?? []
        learningObjective = try container.decodeIfPresent(String.self, forKey: .learningObjective) ?? ""
        difficultyLevel = try container.decodeIfPresent(String.self, forKey: .difficultyLevel) ?? ""
    }

    func accepts(_ answer: String) -> Bool {
        switch normalizedQuestionType(type) {
        case "simple_match", "match_following":
            guard let answerMap = decodedStringMap(answer), let correctMap = decodedStringMap(correctAnswer) else {
                return normalizedAnswerString(answer) == normalizedAnswerString(correctAnswer)
            }
            return normalizedMap(answerMap) == normalizedMap(correctMap)
        case "sequence_ordering":
            guard let answerArray = decodedStringArray(answer), let correctArray = decodedStringArray(correctAnswer) else {
                return normalizedAnswerString(answer) == normalizedAnswerString(correctAnswer)
            }
            return answerArray.map(normalizedAnswerString) == correctArray.map(normalizedAnswerString)
        case "categorization":
            guard let answerMap = decodedStringArrayMap(answer), let correctMap = decodedStringArrayMap(correctAnswer) else {
                return normalizedAnswerString(answer) == normalizedAnswerString(correctAnswer)
            }
            return normalizedArrayMap(answerMap) == normalizedArrayMap(correctMap)
        default:
            let accepted = ([correctAnswer] + acceptableAnswers).map(normalizedAnswerString)
            return accepted.contains(normalizedAnswerString(answer))
        }
    }
}

struct Answer: Codable, Identifiable, Hashable {
    var id = UUID()
    var questionID: UUID
    var selectedAnswer: String
}

struct AnswerEvaluation: Codable, Identifiable, Hashable {
    var id: UUID
    var question: Question
    var selectedAnswer: String

    var isCorrect: Bool { question.accepts(selectedAnswer) }
}

enum Subject: String, CaseIterable, Identifiable, Codable {
    case english = "English"
    case maths = "Maths"
    case hindi = "Hindi"
    case evs = "EVS"
    case gk = "GK"

    var id: String { rawValue }
}

enum Difficulty: String, CaseIterable, Identifiable, Codable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    var id: String { rawValue }
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

    var color: Color {
        switch self {
        case .unicorn: ScholarTheme.lavender
        case .princess: ScholarTheme.coral
        case .superhero: ScholarTheme.primary
        case .spaceHero: ScholarTheme.sky
        case .shieldHero: ScholarTheme.mint
        }
    }

    static func avatar(for rawValue: String) -> KidAvatar {
        KidAvatar(rawValue: rawValue) ?? .unicorn
    }
}

enum ScholarTheme {
    static let primary = adaptive(light: UIColor(red: 0.325, green: 0.392, blue: 0.220, alpha: 1), dark: UIColor(red: 0.780, green: 0.882, blue: 0.568, alpha: 1))
    static let darkOlive = adaptive(light: UIColor(red: 0.333, green: 0.388, blue: 0.247, alpha: 1), dark: UIColor(red: 0.690, green: 0.800, blue: 0.488, alpha: 1))
    static let primaryContainer = adaptive(light: UIColor(red: 0.420, green: 0.490, blue: 0.310, alpha: 1), dark: UIColor(red: 0.243, green: 0.310, blue: 0.157, alpha: 1))
    static let primarySoft = adaptive(light: UIColor(red: 0.839, green: 0.918, blue: 0.702, alpha: 1), dark: UIColor(red: 0.243, green: 0.310, blue: 0.157, alpha: 1))
    static let background = adaptive(light: UIColor(red: 0.984, green: 0.976, blue: 0.953, alpha: 1), dark: UIColor(red: 0.067, green: 0.074, blue: 0.059, alpha: 1))
    static let surface = adaptive(light: UIColor(red: 0.984, green: 0.976, blue: 0.953, alpha: 1), dark: UIColor(red: 0.094, green: 0.102, blue: 0.082, alpha: 1))
    static let cardBackground = adaptive(light: UIColor(red: 0.988, green: 0.988, blue: 0.980, alpha: 1), dark: UIColor(red: 0.130, green: 0.137, blue: 0.114, alpha: 1))
    static let surfaceContainerLow = adaptive(light: UIColor(red: 0.961, green: 0.957, blue: 0.929, alpha: 1), dark: UIColor(red: 0.116, green: 0.125, blue: 0.102, alpha: 1))
    static let surfaceContainer = adaptive(light: UIColor(red: 0.937, green: 0.933, blue: 0.906, alpha: 1), dark: UIColor(red: 0.153, green: 0.165, blue: 0.133, alpha: 1))
    static let surfaceContainerHigh = adaptive(light: UIColor(red: 0.918, green: 0.910, blue: 0.886, alpha: 1), dark: UIColor(red: 0.188, green: 0.200, blue: 0.165, alpha: 1))
    static let surfaceVariant = adaptive(light: UIColor(red: 0.894, green: 0.886, blue: 0.863, alpha: 1), dark: UIColor(red: 0.224, green: 0.235, blue: 0.200, alpha: 1))
    static let inputSurface = adaptive(light: UIColor(red: 0.914, green: 0.929, blue: 0.894, alpha: 1), dark: UIColor(red: 0.165, green: 0.188, blue: 0.133, alpha: 1))
    static let onSurface = adaptive(light: UIColor(red: 0.106, green: 0.110, blue: 0.094, alpha: 1), dark: UIColor(red: 0.949, green: 0.953, blue: 0.929, alpha: 1))
    static let onSurfaceVariant = adaptive(light: UIColor(red: 0.271, green: 0.282, blue: 0.243, alpha: 1), dark: UIColor(red: 0.773, green: 0.800, blue: 0.714, alpha: 1))
    static let outline = adaptive(light: UIColor(red: 0.459, green: 0.471, blue: 0.427, alpha: 1), dark: UIColor(red: 0.624, green: 0.647, blue: 0.565, alpha: 1))
    static let outlineVariant = adaptive(light: UIColor(red: 0.773, green: 0.784, blue: 0.729, alpha: 1), dark: UIColor(red: 0.318, green: 0.337, blue: 0.278, alpha: 1))
    static let secondaryContainer = adaptive(light: UIColor(red: 0.847, green: 0.914, blue: 0.733, alpha: 1), dark: UIColor(red: 0.204, green: 0.278, blue: 0.122, alpha: 1))
    static let tertiary = adaptive(light: UIColor(red: 0.475, green: 0.322, blue: 0.435, alpha: 1), dark: UIColor(red: 0.875, green: 0.690, blue: 0.835, alpha: 1))
    static let primaryText = onSurface
    static let secondaryText = onSurfaceVariant
    static let success = adaptive(light: UIColor(red: 0.48, green: 0.60, blue: 0.35, alpha: 1), dark: UIColor(red: 0.62, green: 0.78, blue: 0.42, alpha: 1))
    static let warning = adaptive(light: UIColor(red: 0.83, green: 0.66, blue: 0.35, alpha: 1), dark: UIColor(red: 0.96, green: 0.77, blue: 0.42, alpha: 1))
    static let error = adaptive(light: UIColor(red: 0.729, green: 0.102, blue: 0.102, alpha: 1), dark: UIColor(red: 1.000, green: 0.596, blue: 0.596, alpha: 1))
    static let sky = adaptive(light: UIColor(red: 0.55, green: 0.63, blue: 0.70, alpha: 1), dark: UIColor(red: 0.62, green: 0.76, blue: 0.90, alpha: 1))
    static let mint = adaptive(light: UIColor(red: 0.48, green: 0.60, blue: 0.35, alpha: 1), dark: UIColor(red: 0.62, green: 0.78, blue: 0.42, alpha: 1))
    static let coral = adaptive(light: UIColor(red: 0.729, green: 0.102, blue: 0.102, alpha: 1), dark: UIColor(red: 1.000, green: 0.596, blue: 0.596, alpha: 1))
    static let lavender = adaptive(light: UIColor(red: 0.62, green: 0.58, blue: 0.70, alpha: 1), dark: UIColor(red: 0.78, green: 0.72, blue: 0.94, alpha: 1))
    static let honey = adaptive(light: UIColor(red: 0.83, green: 0.66, blue: 0.35, alpha: 1), dark: UIColor(red: 0.96, green: 0.77, blue: 0.42, alpha: 1))
    static let cream = background
    static let mist = surfaceContainerLow
    static let elevatedSurface = adaptive(light: UIColor.white.withAlphaComponent(0.72), dark: UIColor(red: 0.157, green: 0.169, blue: 0.137, alpha: 0.86))
    static let controlSurface = adaptive(light: UIColor(red: 0.937, green: 0.933, blue: 0.906, alpha: 1), dark: UIColor(red: 0.180, green: 0.196, blue: 0.157, alpha: 1))
    static let shadow = adaptive(light: UIColor.black.withAlphaComponent(0.035), dark: UIColor.black.withAlphaComponent(0.32))
    static let ink = onSurface
    static let muted = onSurfaceVariant

    static func hairline(_ opacity: CGFloat = 1) -> Color {
        adaptive(
            light: UIColor.black.withAlphaComponent(0.04 * opacity),
            dark: UIColor.white.withAlphaComponent(0.10 * opacity)
        )
    }

    private static func adaptive(light: UIColor, dark: UIColor) -> Color {
        Color(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark ? dark : light
        })
    }
}

func normalizedQuestionType(_ type: String) -> String {
    type.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
}

func normalizedAnswerString(_ value: String) -> String {
    value.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
}

func encodedStringArray(_ array: [String]) -> String {
    guard let data = try? JSONSerialization.data(withJSONObject: array, options: [.sortedKeys]),
          let string = String(data: data, encoding: .utf8) else {
        return array.joined(separator: ", ")
    }
    return string
}

func encodedStringMap(_ map: [String: String]) -> String {
    guard let data = try? JSONSerialization.data(withJSONObject: map, options: [.sortedKeys]),
          let string = String(data: data, encoding: .utf8) else {
        return map.map { "\($0.key): \($0.value)" }.sorted().joined(separator: ", ")
    }
    return string
}

func encodedStringArrayMap(_ map: [String: [String]]) -> String {
    guard let data = try? JSONSerialization.data(withJSONObject: map, options: [.sortedKeys]),
          let string = String(data: data, encoding: .utf8) else {
        return map.map { "\($0.key): \($0.value.joined(separator: ", "))" }.sorted().joined(separator: "; ")
    }
    return string
}

func decodedStringArray(_ value: String) -> [String]? {
    guard let data = value.data(using: .utf8),
          let array = try? JSONSerialization.jsonObject(with: data) as? [String] else { return nil }
    return array
}

func decodedStringMap(_ value: String) -> [String: String]? {
    guard let data = value.data(using: .utf8),
          let map = try? JSONSerialization.jsonObject(with: data) as? [String: String] else { return nil }
    return map
}

func decodedStringArrayMap(_ value: String) -> [String: [String]]? {
    guard let data = value.data(using: .utf8),
          let map = try? JSONSerialization.jsonObject(with: data) as? [String: [String]] else { return nil }
    return map
}

func normalizedMap(_ map: [String: String]) -> [String: String] {
    Dictionary(uniqueKeysWithValues: map.map { (normalizedAnswerString($0.key), normalizedAnswerString($0.value)) })
}

func normalizedArrayMap(_ map: [String: [String]]) -> [String: [String]] {
    Dictionary(uniqueKeysWithValues: map.map { key, values in
        (normalizedAnswerString(key), values.map(normalizedAnswerString).sorted())
    })
}

func displayStoredAnswer(_ value: String) -> String {
    if let map = decodedStringArrayMap(value) {
        return map.keys.sorted().map { key in
            let values = map[key, default: []].joined(separator: ", ")
            return "\(key): \(values)"
        }.joined(separator: " • ")
    }
    if let map = decodedStringMap(value) {
        return map.keys.sorted().map { "\($0) → \(map[$0] ?? "")" }.joined(separator: " • ")
    }
    if let array = decodedStringArray(value) {
        return array.joined(separator: " → ")
    }
    return value
}

enum AppMode: String, CaseIterable, Identifiable {
    case home = "Home"
    case practice = "Practice"
    case progress = "Progress"
    case insights = "Insights"
    case profile = "Profile"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .home: "house.fill"
        case .practice: "square.and.pencil"
        case .progress: "chart.line.uptrend.xyaxis"
        case .insights: "sparkles"
        case .profile: "person.crop.circle.fill"
        }
    }
}

struct ExamGeneratorService {
    func generateExam(for profile: ChildProfile, subject: Subject, difficulty: Difficulty, numberOfQuestions: Int) -> Exam {
        Exam(
            childProfileID: profile.profileID,
            childName: profile.name,
            grade: profile.grade,
            subject: subject,
            difficulty: difficulty,
            questions: questions(subject: subject, difficulty: difficulty, count: numberOfQuestions)
        )
    }

    private func questions(subject: Subject, difficulty: Difficulty, count: Int) -> [Question] {
        let source: [Question]
        switch subject {
        case .maths:
            source = [
                Question(prompt: "What is 2 + 3?", options: ["4", "5", "6", "7"], correctAnswer: "5", explanation: "Counting 2 more after 3 gives 5."),
                Question(prompt: "What is 8 x 4?", options: ["24", "28", "32", "36"], correctAnswer: "32", explanation: "8 groups of 4 make 32."),
                Question(prompt: "How many tens are in 40?", options: ["2", "3", "4", "5"], correctAnswer: "4", explanation: "40 is 4 groups of ten.")
            ]
        case .english, .hindi:
            source = [
                Question(prompt: "Which word rhymes with cat?", options: ["bat", "dog", "sun", "pen"], correctAnswer: "bat", explanation: "Cat and bat end with the same sound."),
                Question(prompt: "Choose the noun.", options: ["run", "happy", "ball", "blue"], correctAnswer: "ball", explanation: "A noun names a thing. Ball is a thing."),
                Question(prompt: "What is the opposite of cold?", options: ["hot", "wet", "slow", "small"], correctAnswer: "hot", explanation: "Hot is the opposite of cold.")
            ]
        case .evs:
            source = [
                Question(prompt: "What do plants need to grow?", options: ["Sunlight", "Shoes", "Pencils", "Blankets"], correctAnswer: "Sunlight", explanation: "Plants use sunlight to make food."),
                Question(prompt: "What is water when it freezes?", options: ["Steam", "Ice", "Cloud", "Rain"], correctAnswer: "Ice", explanation: "Frozen water becomes ice."),
                Question(prompt: "What force pulls objects toward Earth?", options: ["Sound", "Gravity", "Light", "Heat"], correctAnswer: "Gravity", explanation: "Gravity pulls objects toward Earth.")
            ]
        case .gk:
            source = [
                Question(prompt: "How many days are in a week?", options: ["5", "6", "7", "8"], correctAnswer: "7", explanation: "There are 7 days in one week."),
                Question(prompt: "Which place has many books?", options: ["Library", "Pool", "Garden", "Kitchen"], correctAnswer: "Library", explanation: "A library stores books."),
                Question(prompt: "Which tool tells direction?", options: ["Compass", "Clock", "Ruler", "Thermometer"], correctAnswer: "Compass", explanation: "A compass points toward directions like north.")
            ]
        }

        let repeats = max(1, Int(ceil(Double(count) / Double(source.count))))
        return Array(Array(repeating: source, count: repeats).flatMap { $0 }.prefix(count)).map {
            Question(prompt: $0.prompt, options: $0.options, correctAnswer: $0.correctAnswer, explanation: $0.explanation)
        }
    }
}

struct AnswerEvaluationService {
    func evaluate(exam: Exam, answers: [UUID: String]) -> ExamResult {
        let evaluations = exam.questions.map { question in
            AnswerEvaluation(id: question.id, question: question, selectedAnswer: answers[question.id] ?? "No answer")
        }
        let totalMarks = exam.questions.reduce(0) { $0 + max($1.marks, 1) }
        let earnedMarks = evaluations.reduce(0) { $0 + ($1.isCorrect ? max($1.question.marks, 1) : 0) }

        return ExamResult(
            childProfileID: exam.childProfileID,
            childName: exam.childName,
            grade: exam.grade,
            subject: exam.subject,
            difficulty: exam.difficulty,
            totalQuestions: max(totalMarks, exam.questions.count),
            correctAnswers: earnedMarks,
            evaluations: evaluations
        )
    }
}

enum APIError: LocalizedError {
    case invalidBaseURL
    case invalidResponse
    case server(String)

    var errorDescription: String? {
        switch self {
        case .invalidBaseURL: "Set a valid backend base URL."
        case .invalidResponse: "The backend returned an invalid response."
        case .server(let message): message
        }
    }
}

enum APIConfiguration {
    static let developmentBaseURL = "http://localhost:3000"
    static let productionBaseURL = "https://little-scholar-server-production.up.railway.app"
    static let placeholderRailwayBaseURL = "https://your-railway-domain.up.railway.app"

    static var defaultBaseURL: String {
        #if DEBUG
        developmentBaseURL
        #else
        productionBaseURL
        #endif
    }
}

struct APIClient {
    let baseURLString: String
    var accessToken: String?

    private var baseURL: URL {
        get throws {
            let trimmedBaseURL = baseURLString.trimmingCharacters(in: .whitespacesAndNewlines)
            guard let url = URL(string: trimmedBaseURL), !trimmedBaseURL.isEmpty else {
                throw APIError.invalidBaseURL
            }
            return url
        }
    }

    func register(name: String, email: String, city: String, password: String) async throws -> AuthPayloadDTO {
        try await post(path: "/api/auth/register", body: RegisterRequestDTO(name: name, email: email, city: city, password: password), authorized: false)
    }

    func login(email: String, password: String) async throws -> AuthPayloadDTO {
        try await post(path: "/api/auth/login", body: LoginRequestDTO(email: email, password: password), authorized: false)
    }

    func createChild(name: String, age: Int, grade: String) async throws -> BackendChildProfileDTO {
        try await post(
            path: "/api/children",
            body: ChildProfileRequestDTO(name: name, age: age, grade: grade, avatarUrl: nil),
            authorized: true
        )
    }

    func listChildren() async throws -> [BackendChildProfileDTO] {
        try await get(path: "/api/children", authorized: true)
    }

    func generateExam(childID: String, grade: String, subject: Subject, difficulty: Difficulty, questionCount: Int) async throws -> BackendExamPaperDTO {
        let path = "/api/children/\(childID)/exams/generate"
        do {
            return try await post(
                path: path,
                body: GenerateExamRequestDTO(subject: subject.rawValue, difficulty: difficulty.rawValue, questionCount: questionCount),
                authorized: true
            )
        } catch APIError.server(let message) where message.localizedCaseInsensitiveContains("validation") {
            return try await post(
                path: path,
                body: GenerateExamWithGradeRequestDTO(grade: grade, subject: subject.rawValue, difficulty: difficulty.rawValue, questionCount: questionCount),
                authorized: true
            )
        }
    }

    private func post<Request: Encodable, Response: Decodable>(path: String, body: Request, authorized: Bool) async throws -> Response {
        let endpoint = try baseURL.appending(path: path)
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if authorized, let accessToken, !accessToken.isEmpty {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse }
        guard (200..<300).contains(httpResponse.statusCode) else {
            let errorResponse = try? JSONDecoder().decode(ErrorResponseDTO.self, from: data)
            throw APIError.server(errorResponse?.error.displayMessage ?? "Request failed with status \(httpResponse.statusCode).")
        }
        let success = try JSONDecoder().decode(APISuccessResponse<Response>.self, from: data)
        return success.data
    }

    private func get<Response: Decodable>(path: String, authorized: Bool) async throws -> Response {
        let endpoint = try baseURL.appending(path: path)
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        if authorized, let accessToken, !accessToken.isEmpty {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse }
        guard (200..<300).contains(httpResponse.statusCode) else {
            let errorResponse = try? JSONDecoder().decode(ErrorResponseDTO.self, from: data)
            throw APIError.server(errorResponse?.error.displayMessage ?? "Request failed with status \(httpResponse.statusCode).")
        }
        let success = try JSONDecoder().decode(APISuccessResponse<Response>.self, from: data)
        return success.data
    }
}

struct APISuccessResponse<DataPayload: Decodable>: Decodable {
    let success: Bool
    let data: DataPayload
}

struct ErrorResponseDTO: Decodable {
    struct APIErrorPayload: Decodable {
        let message: String
        let details: JSONValue?

        var displayMessage: String {
            guard let details else { return message }
            return "\(message): \(details.readableDescription)"
        }
    }
    let success: Bool
    let error: APIErrorPayload
}

enum JSONValue: Decodable {
    case string(String)
    case number(Double)
    case bool(Bool)
    case object([String: JSONValue])
    case array([JSONValue])
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
        } else if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode(Double.self) {
            self = .number(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode([String: JSONValue].self) {
            self = .object(value)
        } else if let value = try? container.decode([JSONValue].self) {
            self = .array(value)
        } else {
            self = .null
        }
    }

    var readableDescription: String {
        switch self {
        case .string(let value):
            return value
        case .number(let value):
            return value.rounded() == value ? String(Int(value)) : String(value)
        case .bool(let value):
            return value ? "true" : "false"
        case .object(let values):
            return values
                .sorted { $0.key < $1.key }
                .map { "\($0.key): \($0.value.readableDescription)" }
                .joined(separator: ", ")
        case .array(let values):
            return values.map(\.readableDescription).joined(separator: ", ")
        case .null:
            return "null"
        }
    }
}

struct RegisterRequestDTO: Encodable {
    let name: String
    let email: String
    let city: String
    let password: String
}

struct LoginRequestDTO: Encodable {
    let email: String
    let password: String
}

struct GenerateExamRequestDTO: Encodable {
    let subject: String
    let difficulty: String
    let questionCount: Int
}

struct GenerateExamWithGradeRequestDTO: Encodable {
    let grade: String
    let subject: String
    let difficulty: String
    let questionCount: Int
}

struct ChildProfileRequestDTO: Encodable {
    let name: String
    let age: Int
    let grade: String
    let avatarUrl: String?
}

struct AuthPayloadDTO: Decodable {
    let user: UserDTO
    let accessToken: String
}

struct UserDTO: Decodable {
    let id: String
    let name: String
    let email: String
    let city: String
}

struct BackendChildProfileDTO: Decodable {
    let id: String
    let userId: String
    let name: String
    let age: Int
    let grade: String
    let avatarUrl: String?
    let createdAt: String
    let updatedAt: String
}

struct BackendExamPaperDTO: Decodable {
    let examId: String
    let grade: String
    let subject: String
    let difficulty: String
    let questionCount: Int
    let questions: [BackendQuestionDTO]

    func makeExam(for profile: ChildProfile, parentID: String) -> Exam {
        let subjectValue = Subject(rawValue: subject) ?? .maths
        let difficultyValue = Difficulty(rawValue: difficulty) ?? .easy
        let exam = Exam(
            parentID: parentID,
            childProfileID: profile.profileID,
            childName: profile.name,
            grade: grade,
            subject: subjectValue,
            difficulty: difficultyValue,
            questions: questions.map(\.modelQuestion)
        )
        if let uuid = UUID(uuidString: examId) {
            exam.examID = uuid
        }
        return exam
    }
}

struct BackendQuestionDTO: Decodable {
    let id: String
    let type: String
    let question: String
    let options: [String]?
    let visualElements: [String]?
    let leftItems: [String]?
    let rightItems: [String]?
    let passage: String?
    let categories: [String]?
    let correctAnswer: FlexibleAnswer
    let acceptableAnswers: [String]?
    let explanation: String
    let topic: String
    let learningObjective: String?
    let difficultyLevel: String?
    let marks: Int

    var questionModelOptions: [String] {
        if let options, !options.isEmpty { return options }
        if ["true_false", "simple_true_false"].contains(normalizedQuestionType(type)) { return ["True", "False"] }
        return []
    }

    var questionModelCorrectAnswer: String {
        correctAnswer.storageValue
    }

    var modelQuestion: Question {
        Question(
            backendID: id,
            type: type,
            prompt: self.question,
            options: questionModelOptions,
            correctAnswer: questionModelCorrectAnswer,
            acceptableAnswers: acceptableAnswers ?? [],
            explanation: explanation,
            topic: topic,
            marks: marks,
            visualElements: visualElements ?? [],
            leftItems: leftItems ?? [],
            rightItems: rightItems ?? [],
            passage: passage,
            categories: categories ?? [],
            learningObjective: learningObjective ?? "",
            difficultyLevel: difficultyLevel ?? ""
        )
    }
}

enum FlexibleAnswer: Decodable {
    case string(String)
    case array([String])
    case object([String: FlexibleAnswerObjectValue])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let array = try? container.decode([String].self) {
            self = .array(array)
        } else if let object = try? container.decode([String: FlexibleAnswerObjectValue].self) {
            self = .object(object)
        } else {
            self = .string("")
        }
    }

    var displayValue: String {
        switch self {
        case .string(let value):
            return value
        case .array(let values):
            return values.joined(separator: ", ")
        case .object(let object):
            return object.values.map(\.displayValue).joined(separator: ", ")
        }
    }

    var storageValue: String {
        switch self {
        case .string(let value):
            return value
        case .array(let values):
            return encodedStringArray(values)
        case .object(let object):
            if object.values.contains(where: \.isArray) {
                return encodedStringArrayMap(object.mapValues(\.arrayStorageValue))
            }
            return encodedStringMap(object.mapValues(\.stringStorageValue))
        }
    }
}

enum FlexibleAnswerObjectValue: Decodable {
    case string(String)
    case array([String])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let array = try? container.decode([String].self) {
            self = .array(array)
        } else {
            self = .string("")
        }
    }

    var isArray: Bool {
        if case .array = self { return true }
        return false
    }

    var displayValue: String {
        switch self {
        case .string(let value):
            return value
        case .array(let values):
            return values.joined(separator: ", ")
        }
    }

    var stringStorageValue: String {
        switch self {
        case .string(let value):
            return value
        case .array(let values):
            return values.joined(separator: ", ")
        }
    }

    var arrayStorageValue: [String] {
        switch self {
        case .string(let value):
            return [value]
        case .array(let values):
            return values
        }
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ChildProfile.createdAt, order: .reverse) private var profiles: [ChildProfile]
    @Query(sort: \Exam.createdAt, order: .reverse) private var exams: [Exam]
    @Query(sort: \ExamResult.completedAt, order: .reverse) private var results: [ExamResult]

    @AppStorage("apiBaseURL") private var apiBaseURL = APIConfiguration.defaultBaseURL
    @AppStorage("parentID") private var parentID = ""
    @AppStorage("parentName") private var parentName = ""
    @AppStorage("parentEmail") private var parentEmail = ""
    @AppStorage("parentCity") private var parentCity = ""
    @AppStorage("parentAccessToken") private var parentAccessToken = ""
    @AppStorage("parentIsRegistered") private var parentIsRegistered = false
    @AppStorage("parentIsLoggedIn") private var parentIsLoggedIn = false

    @State private var selectedMode: AppMode = .home
    @State private var selectedChildID: UUID?
    @State private var latestResult: ExamResult?
    @State private var saveErrorMessage: String?
    @State private var isGeneratingExam = false
    @State private var showingLogin = false
    @State private var showingPremiumPlaceholder = false

    private let answerEvaluation = AnswerEvaluationService()

    private var apiClient: APIClient {
        APIClient(baseURLString: apiBaseURL, accessToken: parentAccessToken)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                LittleScholarBackground()

                if parentIsRegistered && parentIsLoggedIn {
                    mainAppShell
                } else if parentIsRegistered || showingLogin {
                    ParentLoginView(
                        registeredEmail: parentEmail,
                        parentName: parentName.isEmpty ? "Parent" : parentName,
                        onLogin: loginParent,
                        onRegisterAgain: {
                            showingLogin = false
                            resetParentRegistration()
                        }
                    )
                } else {
                    ParentRegistrationView(
                        onRegister: registerParent,
                        onGoToLogin: { showingLogin = true }
                    )
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .alert("Could not save", isPresented: saveErrorBinding) {
                Button("OK", role: .cancel) { saveErrorMessage = nil }
            } message: {
                Text(saveErrorMessage ?? "Please try again.")
            }
            .task {
                migrateBackendURLIfNeeded()
                migrateLegacyRecordsToCurrentParentIfNeeded()
                repairDuplicateProfileIDs()
                removeInvalidPendingExams()
                ensureSelectedChild()
            }
            .onChange(of: currentParentProfiles.map(\.profileID)) { _, _ in
                ensureSelectedChild()
            }
            .sheet(isPresented: $showingPremiumPlaceholder) {
                PremiumComingSoonView()
            }
        }
    }

    private var mainAppShell: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                LSTopAppBar(
                    parentName: parentName
                )
                content
                    .animation(.easeInOut(duration: 0.22), value: selectedMode)
            }

            LSBottomTabBar(selectedMode: $selectedMode)
                .padding(.horizontal, 18)
                .padding(.bottom, 10)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    @ViewBuilder
    private var content: some View {
        switch selectedMode {
        case .home:
            HomeScreen(
                parentName: parentName,
                profiles: currentParentProfiles,
                selectedChildID: $selectedChildID,
                results: currentParentResults,
                onGeneratePractice: { selectedMode = .practice },
                onViewInsights: { selectedMode = .insights },
                onAddLearner: { selectedMode = .profile }
            )
        case .practice:
            PracticeScreen(
                profiles: currentParentProfiles,
                selectedChildID: $selectedChildID,
                exams: displayableExams.filter { !$0.isCompleted },
                isGenerating: isGeneratingExam,
                onGenerateExam: generateExam,
                onSubmit: evaluateExam
            )
        case .progress:
            ProgressScreen(
                profiles: currentParentProfiles,
                selectedChildID: $selectedChildID,
                results: currentParentResults
            )
        case .insights:
            InsightsScreen(
                profiles: currentParentProfiles,
                selectedChildID: $selectedChildID,
                results: currentParentResults
            )
        case .profile:
            ProfileScreen(
                parentName: parentName,
                parentEmail: parentEmail,
                parentCity: parentCity,
                profiles: currentParentProfiles,
                selectedChildID: $selectedChildID,
                results: currentParentResults,
                onSaveProfile: saveProfile,
                onDeleteProfile: deleteProfile,
                onUpdateProfile: updateProfile,
                onUpgrade: { showingPremiumPlaceholder = true },
                onLogout: logoutParent
            )
        }
    }

    private var saveErrorBinding: Binding<Bool> {
        Binding(get: { saveErrorMessage != nil }, set: { if !$0 { saveErrorMessage = nil } })
    }

    private var currentParentProfiles: [ChildProfile] {
        profiles.filter { $0.parentID == parentID }
    }

    private var currentParentExams: [Exam] {
        exams.filter { $0.parentID == parentID }
    }

    private var currentParentResults: [ExamResult] {
        results.filter { $0.parentID == parentID }
    }

    private var displayableExams: [Exam] {
        currentParentExams.filter { !$0.questions.isEmpty }
    }

    private func registerParent(name: String, email: String, city: String, password: String) async -> Bool {
        do {
            let payload = try await apiClient.register(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                city: city.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )
            saveAuthenticatedParent(payload)
            return true
        } catch {
            saveErrorMessage = error.localizedDescription
            return false
        }
    }

    private func loginParent(email: String, password: String) async -> Bool {
        do {
            let payload = try await apiClient.login(
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )
            saveAuthenticatedParent(payload)
            return true
        } catch {
            saveErrorMessage = error.localizedDescription
            return false
        }
    }

    private func saveAuthenticatedParent(_ payload: AuthPayloadDTO) {
        parentID = payload.user.id
        parentName = payload.user.name
        parentEmail = payload.user.email
        parentCity = payload.user.city
        parentAccessToken = payload.accessToken
        latestResult = nil
        selectedMode = .home
        parentIsRegistered = true
        parentIsLoggedIn = true
    }

    private func resetParentRegistration() {
        parentID = ""
        parentName = ""
        parentEmail = ""
        parentCity = ""
        parentAccessToken = ""
        latestResult = nil
        selectedMode = .home
        parentIsRegistered = false
        parentIsLoggedIn = false
    }

    private func logoutParent() {
        parentIsLoggedIn = false
        latestResult = nil
        selectedMode = .home
    }

    private func ensureSelectedChild() {
        if let selectedChildID, currentParentProfiles.contains(where: { $0.profileID == selectedChildID }) {
            return
        }
        selectedChildID = currentParentProfiles.first?.profileID
    }

    private func saveProfile(name: String, age: Int, grade: String, avatar: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }
        do {
            let profile = ChildProfile(parentID: parentID, name: trimmedName, age: age, grade: grade)
            profile.avatar = avatar
            modelContext.insert(profile)
            try modelContext.save()
        } catch {
            saveErrorMessage = error.localizedDescription
        }
    }

    private func deleteProfile(_ profile: ChildProfile) {
        guard profile.parentID == parentID else { return }

        do {
            let profileID = profile.profileID
            for exam in currentParentExams where exam.childProfileID == profileID {
                modelContext.delete(exam)
            }
            for result in currentParentResults where result.childProfileID == profileID {
                modelContext.delete(result)
            }
            if latestResult?.childProfileID == profileID {
                latestResult = nil
            }
            modelContext.delete(profile)
            try modelContext.save()
        } catch {
            saveErrorMessage = error.localizedDescription
        }
    }

    private func updateProfile(_ profile: ChildProfile, name: String, age: Int, grade: String, avatar: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard profile.parentID == parentID, !trimmedName.isEmpty else { return }

        do {
            let profileID = profile.profileID
            profile.name = trimmedName
            profile.age = age
            profile.grade = grade
            profile.avatar = avatar

            for exam in currentParentExams where exam.childProfileID == profileID {
                exam.childName = trimmedName
            }
            for result in currentParentResults where result.childProfileID == profileID {
                result.childName = trimmedName
            }
            try modelContext.save()
        } catch {
            saveErrorMessage = error.localizedDescription
        }
    }

    private func generateExam(profile: ChildProfile, subject: Subject, difficulty: Difficulty, numberOfQuestions: Int) {
        guard !isGeneratingExam else { return }
        isGeneratingExam = true

        Task {
            do {
                let backendChildID = try await ensureBackendChildID(for: profile)
                let backendExam = try await apiClient.generateExam(
                    childID: backendChildID,
                    grade: backendGrade(for: profile.grade),
                    subject: subject,
                    difficulty: difficulty,
                    questionCount: numberOfQuestions
                )
                let exam = backendExam.makeExam(for: profile, parentID: parentID)
                modelContext.insert(exam)
                try modelContext.save()
                isGeneratingExam = false
                selectedMode = .practice
            } catch {
                isGeneratingExam = false
                saveErrorMessage = error.localizedDescription
            }
        }
    }

    private func ensureBackendChildID(for profile: ChildProfile) async throws -> String {
        if let backendChildID = profile.backendChildID, !backendChildID.isEmpty {
            return backendChildID
        }

        let backendAge = backendAge(for: profile.age)
        let backendGrade = backendGrade(for: profile.grade)
        let backendChildren = try await apiClient.listChildren()
        if let matchingChild = backendChildren.first(where: { backendChildMatches($0, profile: profile, backendAge: backendAge, backendGrade: backendGrade) }) ?? backendChildren.first {
            profile.backendChildID = matchingChild.id
            try modelContext.save()
            return matchingChild.id
        }

        let backendChild = try await apiClient.createChild(
            name: profile.name,
            age: backendAge,
            grade: backendGrade
        )
        profile.backendChildID = backendChild.id
        try modelContext.save()
        return backendChild.id
    }

    private func backendChildMatches(_ backendChild: BackendChildProfileDTO, profile: ChildProfile, backendAge: Int, backendGrade: String) -> Bool {
        backendChild.name.trimmingCharacters(in: .whitespacesAndNewlines).caseInsensitiveCompare(profile.name.trimmingCharacters(in: .whitespacesAndNewlines)) == .orderedSame
            && backendChild.age == backendAge
            && backendChild.grade == backendGrade
    }

    private func backendAge(for profileAge: Int) -> Int {
        min(max(profileAge, 2), 10)
    }

    private func backendGrade(for profileGrade: String) -> String {
        switch profileGrade {
        case "Nursery": "Nursery"
        case "UKG": "UKG"
        case "Grade 1": "Grade 1"
        default: "LKG"
        }
    }

    private func evaluateExam(exam: Exam, answers: [UUID: String]) -> ExamResult? {
        let result = answerEvaluation.evaluate(exam: exam, answers: answers)
        result.parentID = parentID
        do {
            exam.isCompleted = true
            modelContext.insert(result)
            try modelContext.save()
            latestResult = result
            return result
        } catch {
            saveErrorMessage = error.localizedDescription
            return nil
        }
    }

    private func migrateBackendURLIfNeeded() {
        let trimmedBaseURL = apiBaseURL.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedBaseURL == APIConfiguration.placeholderRailwayBaseURL || trimmedBaseURL.isEmpty {
            apiBaseURL = APIConfiguration.defaultBaseURL
            return
        }

        #if DEBUG
        if trimmedBaseURL == APIConfiguration.productionBaseURL {
            apiBaseURL = APIConfiguration.developmentBaseURL
        }
        #endif
    }

    private func migrateLegacyRecordsToCurrentParentIfNeeded() {
        guard parentIsLoggedIn, !parentID.isEmpty else { return }

        var didMigrate = false
        for profile in profiles where profile.parentID.isEmpty {
            profile.parentID = parentID
            didMigrate = true
        }
        for exam in exams where exam.parentID.isEmpty {
            exam.parentID = parentID
            didMigrate = true
        }
        for result in results where result.parentID.isEmpty {
            result.parentID = parentID
            didMigrate = true
        }

        if didMigrate {
            do {
                try modelContext.save()
            } catch {
                saveErrorMessage = error.localizedDescription
            }
        }
    }

    private func removeInvalidPendingExams() {
        let invalidExams = currentParentExams.filter { !$0.isCompleted && $0.questions.isEmpty }
        guard !invalidExams.isEmpty else { return }

        for exam in invalidExams {
            modelContext.delete(exam)
        }

        do {
            try modelContext.save()
        } catch {
            saveErrorMessage = error.localizedDescription
        }
    }

    private func repairDuplicateProfileIDs() {
        var seenIDs = Set<UUID>()
        var didRepair = false

        for profile in currentParentProfiles {
            if seenIDs.contains(profile.profileID) {
                profile.profileID = UUID()
                didRepair = true
            }
            seenIDs.insert(profile.profileID)
        }

        if didRepair {
            do {
                try modelContext.save()
            } catch {
                saveErrorMessage = error.localizedDescription
            }
        }
    }
}

struct ParentRegistrationView: View {
    let onRegister: (String, String, String, String) async -> Bool
    let onGoToLogin: () -> Void

    @State private var name = ""
    @State private var email = ""
    @State private var city = ""
    @State private var password = ""
    @State private var acceptedDisclaimer = false
    @State private var isSubmitting = false

    private var missingRegistrationRequirement: String? {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return "Enter parent name." }
        if !email.contains("@") { return "Enter a valid email." }
        if city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return "Enter city." }
        if password.count < 8 { return "Password must be at least 8 characters." }
        if !acceptedDisclaimer { return "Accept the disclaimer to continue." }
        return nil
    }

    private var canRegister: Bool {
        missingRegistrationRequirement == nil && !isSubmitting
    }

    var body: some View {
        PremiumScrollView {
            VStack(alignment: .leading, spacing: 22) {
                AuthTitleView(title: "Welcome to Exam Buddy", subtitle: "Create a calm learning space for your child.")

                LSCard {
                    VStack(spacing: 14) {
                        LSSectionHeader(title: "Parent Details", subtitle: "Your private parent account", icon: "person.crop.circle.badge.plus")

                        TextField("Parent Name", text: $name)
                            .textFieldStyle(.roundedBorder)
                            .font(.title3)
                            .textContentType(.name)

                        TextField("Email", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .font(.title3)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .textContentType(.emailAddress)

                        TextField("City", text: $city)
                            .textFieldStyle(.roundedBorder)
                            .font(.title3)
                            .textContentType(.addressCity)

                        SecureField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .font(.title3)
                            .textContentType(.newPassword)

                        Toggle(isOn: $acceptedDisclaimer) {
                            Text("I understand this app is not a replacement for school exams and is not an official exam app.")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.secondary)
                        }
                        .toggleStyle(.switch)

                        if let missingRegistrationRequirement {
                            Label(missingRegistrationRequirement, systemImage: "info.circle.fill")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        Button {
                            Task {
                                isSubmitting = true
                                _ = await onRegister(name, email, city, password)
                                isSubmitting = false
                            }
                        } label: {
                            Label(isSubmitting ? "Registering..." : "Register Parent", systemImage: "checkmark.circle.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(CheerfulButtonStyle(color: ScholarTheme.primary))
                        .disabled(!canRegister)

                        Button(action: onGoToLogin) {
                            Label("Already registered? Login", systemImage: "arrow.right.circle.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(CheerfulButtonStyle(color: ScholarTheme.primary))
                    }
                }
            }
            .adaptiveContentWidth(maxWidth: 620)
        }
    }
}

struct ParentLoginView: View {
    let registeredEmail: String
    let parentName: String
    let onLogin: (String, String) async -> Bool
    let onRegisterAgain: () -> Void

    @State private var email = ""
    @State private var password = ""
    @State private var isSubmitting = false
    @State private var showLoginError = false

    var body: some View {
        PremiumScrollView {
            VStack(alignment: .leading, spacing: 22) {
                AuthTitleView(title: "Welcome back", subtitle: "Continue supporting your child's practice.")

                LSCard {
                    VStack(spacing: 14) {
                        LSSectionHeader(title: "Login", subtitle: "Signed in as \(parentName)", icon: "lock.fill")

                        TextField("Email", text: $email)
                            .textFieldStyle(.roundedBorder)
                            .font(.title3)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .textContentType(.emailAddress)
                            .onAppear { email = registeredEmail }

                        SecureField("Password", text: $password)
                            .textFieldStyle(.roundedBorder)
                            .font(.title3)
                            .textContentType(.password)

                        if showLoginError {
                            Label("Login failed. Check your email and password.", systemImage: "exclamationmark.triangle.fill")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(ScholarTheme.coral)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        Button {
                            Task {
                                isSubmitting = true
                                showLoginError = !(await onLogin(email, password))
                                isSubmitting = false
                            }
                        } label: {
                            Label(isSubmitting ? "Logging in..." : "Login", systemImage: "arrow.right.circle.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(CheerfulButtonStyle(color: ScholarTheme.primary))
                        .disabled(email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || password.isEmpty || isSubmitting)

                        Button("Register a different parent", action: onRegisterAgain)
                            .font(.headline)
                            .foregroundStyle(ScholarTheme.primary)
                    }
                }
            }
            .adaptiveContentWidth(maxWidth: 560)
        }
    }
}

struct AuthTitleView: View {
    let title: String
    let subtitle: String

    var body: some View {
        LSHeroCard {
            VStack(alignment: .leading, spacing: 10) {
            Image(systemName: "graduationcap.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(ScholarTheme.primary)
            Text("Little Scholar")
                .font(.largeTitle.bold())
            Text(title)
                .font(.title2.bold())
            Text(subtitle)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct HomeScreen: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let parentName: String
    let profiles: [ChildProfile]
    @Binding var selectedChildID: UUID?
    let results: [ExamResult]
    let onGeneratePractice: () -> Void
    let onViewInsights: () -> Void
    let onAddLearner: () -> Void

    private var isCompact: Bool { horizontalSizeClass == .compact }
    private var selectedProfile: ChildProfile? { selectedChild(in: profiles, selectedChildID: selectedChildID) }
    private var selectedResults: [ExamResult] { resultsForSelectedChild(results, childID: selectedProfile?.profileID) }
    private var latestResults: [ExamResult] { Array(selectedResults.prefix(3)) }
    private var statsColumn: some View {
        VStack(spacing: 24) {
            LSMetricTile(title: "Avg. Score", value: "\(averageScore(selectedResults))%", detail: selectedResults.isEmpty ? "First session pending" : "+4% this week", icon: "chart.line.uptrend.xyaxis")
            LSMetricTile(title: "Sessions Completed", value: "\(selectedResults.count)", detail: "Last 7 days", icon: "scroll")
            LSMetricTile(title: "Best Score", value: "\(bestScore(selectedResults))%", detail: bestSubjectLabel, icon: "trophy")
        }
    }
    private var activityColumn: some View {
        VStack(spacing: 24) {
            AIRecommendationCard(
                results: selectedResults,
                onViewInsights: onViewInsights
            )

            LSCard {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Recent Activity")
                        .font(.title.bold())
                        .foregroundStyle(ScholarTheme.onSurface)
                    if latestResults.isEmpty {
                        LSEmptyState(icon: "sparkle.magnifyingglass", title: "No completed practice yet", message: "Generated practice sessions will become progress moments after your child submits them.")
                    } else {
                        VStack(spacing: 0) {
                            ForEach(latestResults) { result in
                                PremiumResultRow(result: result)
                            }
                        }
                    }
                }
            }
        }
    }
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: .now)
        let name = parentName.trimmingCharacters(in: .whitespacesAndNewlines)
        let displayName = name.isEmpty ? "" : ", \(name)"
        switch hour {
        case 5..<12: return "Good Morning\(displayName)"
        case 12..<17: return "Good Afternoon\(displayName)"
        case 17..<22: return "Good Evening\(displayName)"
        default: return name.isEmpty ? "Welcome back" : "Welcome back, \(name)"
        }
    }

    var body: some View {
        PremiumScrollView {
            VStack(alignment: .leading, spacing: isCompact ? 38 : 64) {
                if profiles.isEmpty {
                    LSEmptyState(
                        icon: "person.crop.circle.badge.plus",
                        title: "Create your first learner",
                        message: "Add a child profile in Profile to begin practice and progress tracking."
                    )
                } else if let selectedProfile {
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Select Learner")
                            .font(.caption.weight(.semibold))
                            .textCase(.uppercase)
                            .tracking(2.6)
                            .foregroundStyle(ScholarTheme.onSurfaceVariant)

                        LSChildCarousel(
                            profiles: profiles,
                            selectedChildID: $selectedChildID,
                            results: results,
                            includesAddLearner: false,
                            onAddLearner: onAddLearner
                        )
                    }

                    LSTonalPanel {
                        VStack(alignment: .leading, spacing: isCompact ? 28 : 40) {
                            LSActionHeader(
                                title: "\(selectedProfile.name)'s Overview",
                                buttonTitle: "Generate Practice",
                                buttonIcon: "play.fill",
                                action: onGeneratePractice
                            )

                            LSResponsiveColumns(spacing: 24, leadingMinWidth: 280, trailingMinWidth: 420) {
                                statsColumn
                            } trailing: {
                                activityColumn
                            }
                        }
                    }
                }
            }
        }
    }

    private var learningSummary: String {
        guard !selectedResults.isEmpty else {
            return "Learning Summary: Start with a short practice session to build the first progress snapshot."
        }
        if averageScore(selectedResults) >= 80 {
            return "Learning Summary: \(selectedProfile?.name ?? "Your child") is building strong momentum across recent practice."
        }
        return "Learning Summary: Keep sessions short and steady to strengthen confidence this week."
    }

    private var bestSubjectLabel: String {
        guard let best = subjectSummaries(selectedResults).max(by: { $0.average < $1.average }) else {
            return "Build a baseline"
        }
        return "in \(best.subject)"
    }
}

struct PracticeScreen: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let profiles: [ChildProfile]
    @Binding var selectedChildID: UUID?
    let exams: [Exam]
    let isGenerating: Bool
    let onGenerateExam: (ChildProfile, Subject, Difficulty, Int) -> Void
    let onSubmit: (Exam, [UUID: String]) -> ExamResult?

    @State private var selectedSubject: Subject = .maths
    @State private var selectedDifficulty: Difficulty = .easy
    @State private var numberOfQuestions = 5
    @State private var selectedExam: Exam?
    @State private var completedResult: ExamResult?

    private var isCompact: Bool { horizontalSizeClass == .compact }
    private var selectedProfile: ChildProfile? { selectedChild(in: profiles, selectedChildID: selectedChildID) }
    private var practicesForChild: [Exam] {
        guard let selectedProfile else { return [] }
        return exams.filter { $0.childProfileID == selectedProfile.profileID }
    }
    private var labSetupCard: some View {
        LSCard {
            VStack(alignment: .leading, spacing: 30) {
                LSSectionHeader(title: "Lab Setup", subtitle: "Configure parameters for the next practice session.", icon: "flask")

                LSResponsiveColumns(spacing: 18, leadingMinWidth: 190, trailingMinWidth: 190) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Subject").font(.subheadline.weight(.semibold))
                        Picker("Subject", selection: $selectedSubject) {
                            ForEach(Subject.allCases) { Text($0.rawValue).tag($0) }
                        }
                        .pickerStyle(.menu)
                        .tint(ScholarTheme.primary)
                        .frame(maxWidth: .infinity, minHeight: 58, alignment: .leading)
                        .padding(.horizontal, 16)
                        .background(ScholarTheme.inputSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                } trailing: {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Difficulty Curve").font(.subheadline.weight(.semibold))
                        Picker("Difficulty", selection: $selectedDifficulty) {
                            ForEach(Difficulty.allCases) { difficulty in
                                Text(difficultyDisplay(difficulty)).tag(difficulty)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(ScholarTheme.primary)
                        .frame(maxWidth: .infinity, minHeight: 58, alignment: .leading)
                        .padding(.horizontal, 16)
                        .background(ScholarTheme.inputSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Session Length (Questions)")
                        .font(.subheadline.weight(.semibold))
                    HStack(spacing: 14) {
                        ForEach([5, 10, 20], id: \.self) { count in
                            LSQuestionCountButton(count: count, selectedCount: $numberOfQuestions)
                        }
                    }
                }

                Divider().opacity(0.45)

                if isGenerating {
                    LSSkeletonLoadingCard(title: "Creating practice", message: "Building a thoughtful set of questions...")
                } else {
                    LSPrimaryButton(title: "Generate New Practice", icon: "sparkles") {
                        guard let selectedProfile else { return }
                        onGenerateExam(selectedProfile, selectedSubject, selectedDifficulty, numberOfQuestions)
                    }
                }
            }
        }
    }
    private var pendingSessions: some View {
        VStack(alignment: .leading, spacing: 22) {
            HStack {
                Label("Pending Sessions", systemImage: "clipboard.badge.clock")
                    .font(.title.bold())
                    .foregroundStyle(ScholarTheme.onSurface)
                Spacer()
                Text("\(practicesForChild.count) Tasks")
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(ScholarTheme.tertiary.opacity(0.12))
                    .foregroundStyle(ScholarTheme.tertiary)
                    .clipShape(Capsule())
            }

            if practicesForChild.isEmpty {
                LSEmptyState(icon: "doc.badge.clock", title: "No practice assigned", message: "Generate a session and it will wait here until your child starts.")
            } else {
                VStack(spacing: 22) {
                    ForEach(practicesForChild) { exam in
                        PremiumPracticeRow(exam: exam) { selectedExam = exam }
                    }
                }
            }
        }
    }

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
                PremiumScrollView {
                    VStack(alignment: .leading, spacing: isCompact ? 34 : 56) {
                        if profiles.isEmpty {
                            LSEmptyState(icon: "person.2.slash", title: "Add a learner first", message: "Create a child profile in Profile before generating practice.")
                        } else {
                            HStack(alignment: .center, spacing: 18) {
                                LSInitialAvatar(profile: selectedProfile)
                                Text("\(selectedProfile?.name ?? "Learner")'s Practice Labs")
                                    .font(.system(size: isCompact ? 32 : 44, weight: .bold))
                                    .foregroundStyle(ScholarTheme.onSurface)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.72)
                                Spacer(minLength: 0)
                            }

                            LSResponsiveColumns(spacing: 28, leadingMinWidth: 430, trailingMinWidth: 320) {
                                labSetupCard
                            } trailing: {
                                pendingSessions
                            }
                        }
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 0.22), value: selectedExam?.examID)
    }

    private func difficultyDisplay(_ difficulty: Difficulty) -> String {
        switch difficulty {
        case .easy: "Gentle (Easy)"
        case .medium: "Balanced (Medium)"
        case .hard: "Challenging (Hard)"
        }
    }
}

struct ProgressScreen: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let profiles: [ChildProfile]
    @Binding var selectedChildID: UUID?
    let results: [ExamResult]
    @State private var showingPracticeHistory = false

    private var isCompact: Bool { horizontalSizeClass == .compact }

    private var selectedProfile: ChildProfile? { selectedChild(in: profiles, selectedChildID: selectedChildID) }
    private var selectedResults: [ExamResult] { resultsForSelectedChild(results, childID: selectedProfile?.profileID) }
    private var trendCard: some View {
        LSCard {
            VStack(alignment: .leading, spacing: 22) {
                HStack {
                    Text("Performance Trend")
                        .font(.title.bold())
                    Spacer()
                    Label("Last 30 Days", systemImage: "chevron.down")
                        .font(.caption.weight(.semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 9)
                        .background(ScholarTheme.controlSurface)
                        .clipShape(Capsule())
                }
                PerformanceTrendView(results: selectedResults)
            }
        }
    }
    private var subjectCard: some View {
        LSCard {
            VStack(alignment: .leading, spacing: 26) {
                Text("Subject Breakdown")
                    .font(.title.bold())
                SubjectProgressList(results: selectedResults)
            }
        }
    }
    private var recentPracticeCard: some View {
        LSCard {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Recent Practice")
                        .font(.title.bold())
                    Spacer()
                    Button {
                        showingPracticeHistory = true
                    } label: {
                        Text("View All")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(ScholarTheme.primary)
                    }
                    .buttonStyle(.plain)
                    .disabled(selectedResults.isEmpty)
                    .opacity(selectedResults.isEmpty ? 0.45 : 1)
                }
                if selectedResults.isEmpty {
                    LSEmptyState(icon: "clock.badge.questionmark", title: "No completed practice", message: "Completed sessions will appear here.")
                } else {
                    VStack(spacing: 0) {
                        ForEach(selectedResults.prefix(5)) { result in
                            NavigationLink { ResultView(result: result) } label: {
                                LSRecentExamLine(result: result)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingPracticeHistory) {
            NavigationStack {
                ProgressPracticeHistoryView(results: selectedResults)
            }
            .presentationDetents([.large])
        }
    }

    var body: some View {
        PremiumScrollView {
            VStack(alignment: .leading, spacing: isCompact ? 34 : 52) {
                if profiles.isEmpty {
                    LSEmptyState(icon: "person.2.slash", title: "No learners yet", message: "Create a child profile to begin tracking progress.")
                } else {
                    ViewThatFits(in: .horizontal) {
                        HStack(alignment: .bottom) {
                            progressTitle
                            Spacer()
                            onTrackPill
                        }
                        VStack(alignment: .leading, spacing: 18) {
                            progressTitle
                            onTrackPill
                        }
                    }

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 155), spacing: 14)], spacing: 14) {
                        LSMetricTile(title: "Avg Score", value: "\(averageScore(selectedResults))%", detail: selectedResults.isEmpty ? "No sessions yet" : "+2%", icon: "graduationcap")
                        LSMetricTile(title: "Sessions", value: "\(selectedResults.count)", detail: "this week", icon: "clock")
                        LSMetricTile(title: "Best Score", value: "\(bestScore(selectedResults))%", detail: bestSubjectLabel, icon: "trophy")
                    }

                    LSResponsiveColumns(spacing: 24, leadingMinWidth: 520, trailingMinWidth: 280) {
                        trendCard
                    } trailing: {
                        subjectCard
                    }

                    LSResponsiveColumns(spacing: 24, leadingMinWidth: 420, trailingMinWidth: 320) {
                        FocusAreasCard(results: selectedResults)
                    } trailing: {
                        recentPracticeCard
                    }
                }
            }
        }
    }

    private var bestSubjectLabel: String {
        guard let best = subjectSummaries(selectedResults).max(by: { $0.average < $1.average }) else {
            return "Build a baseline"
        }
        return best.subject
    }

    private var progressTitle: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(selectedProfile?.name ?? "Learner")'s Learning Journey")
                .font(.system(size: isCompact ? 32 : 42, weight: .bold))
                .foregroundStyle(ScholarTheme.onSurface)
                .lineLimit(2)
                .minimumScaleFactor(0.72)
            Text("Tracking progress and celebrating milestones.")
                .font(isCompact ? .subheadline : .title3)
                .foregroundStyle(ScholarTheme.onSurfaceVariant)
        }
    }

    private var onTrackPill: some View {
        Label("On Track", systemImage: "seal")
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(ScholarTheme.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(ScholarTheme.secondaryContainer.opacity(0.65))
            .clipShape(Capsule())
    }
}

struct InsightsScreen: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let profiles: [ChildProfile]
    @Binding var selectedChildID: UUID?
    let results: [ExamResult]
    @State private var isGeneratingInsight = false

    private var isCompact: Bool { horizontalSizeClass == .compact }
    private var selectedProfile: ChildProfile? { selectedChild(in: profiles, selectedChildID: selectedChildID) }
    private var selectedResults: [ExamResult] { resultsForSelectedChild(results, childID: selectedProfile?.profileID) }
    private var suggestedPathCard: some View {
        LSCard {
            VStack(alignment: .leading, spacing: 22) {
                Label("Suggested Path", systemImage: "sparkles")
                    .font(.title.bold())
                    .foregroundStyle(ScholarTheme.primary)
                Text(recommendationText)
                    .font(.title3)
                    .lineSpacing(6)
                    .foregroundStyle(ScholarTheme.onSurface)
                Button(action: runInsightAnimation) {
                    Label("View Suggested Practice", systemImage: "arrow.right")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .frame(minHeight: 48)
                        .background(ScholarTheme.primary)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var pacingCard: some View {
        LSCard {
            VStack(alignment: .leading, spacing: 26) {
                Text("Pacing Level")
                    .font(.title.bold())
                Text("Optimal challenge zone to prevent frustration.")
                    .font(.headline)
                    .foregroundStyle(ScholarTheme.onSurfaceVariant)
                LSPacingLevelView(score: averageScore(selectedResults))
            }
        }
    }

    var body: some View {
        PremiumScrollView {
            VStack(alignment: .leading, spacing: isCompact ? 34 : 56) {
                if profiles.isEmpty {
                    LSEmptyState(icon: "sparkles", title: "No learner selected", message: "Create a child profile to unlock learning insights.")
                } else if selectedResults.count < 3 {
                    VStack(alignment: .leading, spacing: 28) {
                        Text("Monthly Learning Report")
                            .font(.system(size: isCompact ? 32 : 44, weight: .bold))
                            .foregroundStyle(ScholarTheme.primary)
                        LSEmptyState(icon: "chart.bar.doc.horizontal", title: "Generate an AI learning report", message: "Generate an AI learning report to discover strengths, areas needing practice, and personalized recommendations.")
                    }
                } else {
                    VStack(alignment: .leading, spacing: 22) {
                        Text("Monthly Learning Report")
                            .font(.system(size: isCompact ? 32 : 44, weight: .bold))
                            .foregroundStyle(ScholarTheme.primary)
                            .lineLimit(2)
                            .minimumScaleFactor(0.72)
                        Text("Generated for \(selectedProfile?.name ?? "Learner") • \(DateFormatter.localizedString(from: .now, dateStyle: .long, timeStyle: .none))")
                            .font(isCompact ? .subheadline : .title3)
                            .foregroundStyle(ScholarTheme.onSurfaceVariant)
                    }

                    VStack(alignment: .leading, spacing: 24) {
                        Text(reportSummary)
                            .font(.title3)
                            .lineSpacing(8)
                            .foregroundStyle(ScholarTheme.onSurface)
                            .frame(maxWidth: 760, alignment: .leading)
                        Text(reportFocus)
                            .font(.title3)
                            .lineSpacing(8)
                            .foregroundStyle(ScholarTheme.onSurface)
                            .frame(maxWidth: 760, alignment: .leading)
                    }

                    LSResponsiveColumns(spacing: 24, leadingMinWidth: 360, trailingMinWidth: 360) {
                        InsightEditorialCard(title: "Key Strengths", icon: "arrow.up.right", tint: ScholarTheme.primary, items: strengthItems)
                    } trailing: {
                        InsightEditorialCard(title: "Areas of Focus", icon: "brain.head.profile", tint: ScholarTheme.tertiary, items: focusItems)
                    }

                    LSResponsiveColumns(spacing: 24, leadingMinWidth: 520, trailingMinWidth: 280) {
                        suggestedPathCard
                    } trailing: {
                        pacingCard
                    }

                    Divider().opacity(0.5)

                    if isGeneratingInsight {
                        LSSkeletonLoadingCard(title: "Refreshing insight", message: "Reviewing recent practice and preparing guidance...")
                    } else {
                        HStack(spacing: 16) {
                            LSSecondaryButton(title: "Refresh Insight", icon: "arrow.clockwise", action: runInsightAnimation)
                            LSSecondaryButton(title: "Download PDF Report", icon: "arrow.down.doc", action: runInsightAnimation)
                        }
                        .frame(maxWidth: 520)
                    }
                }
            }
        }
    }

    private func runInsightAnimation() {
        withAnimation(.easeInOut(duration: 0.2)) { isGeneratingInsight = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation(.easeInOut(duration: 0.2)) { isGeneratingInsight = false }
        }
    }

    private var reportSummary: String {
        "\(selectedProfile?.name ?? "Your child") has shown steady engagement across recent practice, with an average score of \(averageScore(selectedResults))% across \(selectedResults.count) completed sessions."
    }

    private var reportFocus: String {
        "We recommend low-pressure, focused sessions that reinforce the current needs-practice area while continuing to celebrate strong subjects."
    }

    private var strengthItems: [(String, String)] {
        let best = subjectSummaries(selectedResults).max(by: { $0.average < $1.average })
        return [
            (best?.subject ?? "Pattern Recognition", best.map { "Currently the strongest area at \($0.average)%." } ?? "Strengths will become clearer after more practice."),
            ("Practice Confidence", "Completed sessions show growing comfort with structured learning.")
        ]
    }

    private var focusItems: [(String, String)] {
        let weakest = subjectSummaries(selectedResults).min(by: { $0.average < $1.average })
        return [
            (weakest?.subject ?? "Task Completion", weakest.map { _ in "Spend a little extra time here this week." } ?? "Focus areas will become clearer after more practice."),
            ("Sustained Practice", "Keep sessions short, calm, and predictable.")
        ]
    }

    private var recommendationText: String {
        averageScore(selectedResults) >= 80
            ? "We recommend one balanced practice session a day to keep the challenge fresh without increasing pressure."
            : "We recommend dedicating 15 minutes a day to gentle practice in short, manageable bursts."
    }
}

struct ProfileScreen: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let parentName: String
    let parentEmail: String
    let parentCity: String
    let profiles: [ChildProfile]
    @Binding var selectedChildID: UUID?
    let results: [ExamResult]
    let onSaveProfile: (String, Int, String, String) -> Void
    let onDeleteProfile: (ChildProfile) -> Void
    let onUpdateProfile: (ChildProfile, String, Int, String, String) -> Void
    let onUpgrade: () -> Void
    let onLogout: () -> Void

    @State private var showingAddProfile = false
    @State private var showingAppSettings = false
    @State private var editingProfile: ChildProfile?
    @State private var deletingProfile: ChildProfile?

    private var isCompact: Bool { horizontalSizeClass == .compact }
    private var canAddChildProfile: Bool { profiles.count < 5 }

    private var planAndChildrenColumn: some View {
        VStack(spacing: isCompact ? 18 : 28) {
            LSDarkPlanCard(onUpgrade: onUpgrade)

            LSCard {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text("Child Profiles")
                            .font(isCompact ? .headline.bold() : .title.bold())
                        Spacer()
                        Text("\(profiles.count) of 5 Seats Used")
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(ScholarTheme.controlSurface)
                            .clipShape(Capsule())
                    }

                    if profiles.isEmpty {
                        VStack(spacing: 16) {
                            LSEmptyState(icon: "person.crop.circle.badge.plus", title: "No child profiles", message: "Add your first learner to begin practice.")
                            LSPrimaryButton(title: "Add Child Profile", icon: "plus.circle.fill") {
                                guard canAddChildProfile else { return }
                                showingAddProfile = true
                            }
                        }
                    } else {
                        LSProfileAvatarStrip(
                            profiles: profiles,
                            selectedChildID: $selectedChildID,
                            results: results,
                            canAdd: canAddChildProfile,
                            onEdit: { editingProfile = $0 },
                            onDelete: { deletingProfile = $0 },
                            onAdd: {
                                guard canAddChildProfile else { return }
                                showingAddProfile = true
                            }
                        )
                    }
                }
            }
        }
    }
    private var profileMenuColumn: some View {
        VStack(spacing: 0) {
            LSProfileMenuRow(icon: "chart.line.uptrend.xyaxis", title: "Plan & Usage", subtitle: "Billing cycle and history", tint: ScholarTheme.primary) {
                onUpgrade()
            }
            Divider().padding(.leading, isCompact ? 72 : 86)
            LSProfileMenuRow(icon: "gearshape", title: "App Settings", subtitle: "Notifications, audio, display", tint: ScholarTheme.onSurfaceVariant) {
                showingAppSettings = true
            }
            Divider().padding(.leading, isCompact ? 72 : 86)
            LSProfileMenuRow(icon: "questionmark.circle", title: "Support & Help", subtitle: "FAQs and contact", tint: ScholarTheme.onSurfaceVariant) {
                if let supportURL = URL(string: "https://www.tgdevelops.com/support") {
                    openURL(supportURL)
                }
            }
            Divider().padding(.leading, isCompact ? 72 : 86)
            LSProfileMenuRow(icon: "rectangle.portrait.and.arrow.right", title: "Logout", subtitle: "", tint: ScholarTheme.error, isDestructive: true, action: onLogout)
        }
        .background(ScholarTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(ScholarTheme.hairline(), lineWidth: 1)
        }
    }

    var body: some View {
        PremiumScrollView {
            VStack(alignment: .leading, spacing: isCompact ? 34 : 48) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("\(parentName.isEmpty ? "Parent" : parentName)'s Account")
                        .font(.system(size: isCompact ? 32 : 44, weight: .bold))
                        .foregroundStyle(ScholarTheme.onSurface)
                        .lineLimit(2)
                        .minimumScaleFactor(0.72)
                    Text("Manage your family settings and subscription.")
                        .font(isCompact ? .subheadline : .title3)
                        .foregroundStyle(ScholarTheme.onSurfaceVariant)
                }

                LSResponsiveColumns(spacing: 28, leadingMinWidth: 520, trailingMinWidth: 320) {
                    planAndChildrenColumn
                } trailing: {
                    profileMenuColumn
                }
            }
        }
        .sheet(isPresented: $showingAddProfile) {
            AddChildProfileSheet { name, age, grade, avatarValue in
                guard canAddChildProfile else {
                    showingAddProfile = false
                    return
                }
                onSaveProfile(name, age, grade, avatarValue)
                showingAddProfile = false
            }
        }
        .sheet(isPresented: $showingAppSettings) {
            AppSettingsComingSoonView()
        }
        .onChange(of: profiles.count) { _, count in
            if count >= 5 {
                showingAddProfile = false
            }
        }
        .sheet(item: $editingProfile) { profile in
            EditKidProfileView(profile: profile, onSave: onUpdateProfile)
        }
        .confirmationDialog("Delete child profile?", isPresented: Binding(get: { deletingProfile != nil }, set: { if !$0 { deletingProfile = nil } })) {
            Button("Delete Profile and History", role: .destructive) {
                if let deletingProfile {
                    onDeleteProfile(deletingProfile)
                    if selectedChildID == deletingProfile.profileID {
                        selectedChildID = profiles.first { $0.profileID != deletingProfile.profileID }?.profileID
                    }
                }
                deletingProfile = nil
            }
            Button("Cancel", role: .cancel) { deletingProfile = nil }
        }
    }
}

struct AddChildProfileSheet: View {
    let onSave: (String, Int, String, String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var childName = ""
    @State private var age = 6
    @State private var grade = "Grade 1"
    @State private var avatar: KidAvatar = .unicorn
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedPhotoImage: UIImage?
    @State private var selectedPhotoAvatarValue: String?
    @State private var isLoadingPhoto = false

    private let grades = ["Nursery", "LKG", "UKG", "Kindergarten", "Grade 1", "Grade 2", "Grade 3", "Grade 4", "Grade 5"]
    private var trimmedName: String { childName.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var avatarValue: String { selectedPhotoAvatarValue ?? avatar.rawValue }

    var body: some View {
        NavigationStack {
            LSBackground()
                .overlay {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            PremiumHeader(
                                eyebrow: "Child Profile",
                                title: "Add New Learner",
                                subtitle: "Create a profile and choose a photo or illustrated avatar."
                            )

                            LSCard {
                                VStack(alignment: .leading, spacing: 18) {
                                    profilePhotoPreview
                                    PhotosPicker(selection: $selectedPhotoItem, matching: .images, photoLibrary: .shared()) {
                                        Label("Upload Photo from Device", systemImage: "photo.badge.plus")
                                            .font(.headline.weight(.semibold))
                                            .foregroundStyle(ScholarTheme.primary)
                                            .frame(maxWidth: .infinity, minHeight: 52)
                                            .background(ScholarTheme.primarySoft.opacity(0.34))
                                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                    }
                                    .buttonStyle(.plain)

                                    if selectedPhotoAvatarValue != nil {
                                        Button {
                                            selectedPhotoItem = nil
                                            selectedPhotoImage = nil
                                            selectedPhotoAvatarValue = nil
                                        } label: {
                                            Label("Use Illustrated Avatar Instead", systemImage: "person.crop.circle")
                                                .font(.subheadline.weight(.semibold))
                                        }
                                        .buttonStyle(.plain)
                                        .foregroundStyle(ScholarTheme.onSurfaceVariant)
                                    }
                                }
                            }

                            LSCard {
                                VStack(alignment: .leading, spacing: 18) {
                                    TextField("Child name", text: $childName)
                                        .textFieldStyle(.plain)
                                        .font(.title3)
                                        .padding()
                                        .background(ScholarTheme.inputSurface)
                                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                                    ViewThatFits(in: .horizontal) {
                                        HStack(spacing: 14) {
                                            LSAgeSelector(age: $age)
                                                .frame(maxWidth: .infinity)
                                            LSGradeSelector(grade: $grade, grades: grades)
                                                .frame(maxWidth: .infinity)
                                        }

                                        VStack(spacing: 14) {
                                            LSAgeSelector(age: $age)
                                            LSGradeSelector(grade: $grade, grades: grades)
                                        }
                                    }

                                    if selectedPhotoAvatarValue == nil {
                                        AvatarPicker(selection: $avatar)
                                    }
                                }
                            }

                            LSPrimaryButton(title: "Add Child Profile", icon: "plus.circle.fill") {
                                onSave(trimmedName, age, grade, avatarValue)
                            }
                            .disabled(trimmedName.isEmpty || isLoadingPhoto)
                        }
                        .padding(24)
                        .adaptiveContentWidth(maxWidth: 640)
                    }
                }
                .navigationTitle("Add Learner")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                }
                .onChange(of: selectedPhotoItem) { _, item in
                    loadPhoto(from: item)
                }
        }
        .presentationDetents([.large])
    }

    private var profilePhotoPreview: some View {
        HStack(spacing: 18) {
            ZStack {
                if let selectedPhotoImage {
                    Image(uiImage: selectedPhotoImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 96, height: 96)
                        .clipShape(Circle())
                } else {
                    AvatarBadge(avatar: avatar, isSelected: false)
                        .frame(width: 96, height: 96)
                }

                if isLoadingPhoto {
                    ProgressView()
                        .frame(width: 96, height: 96)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(selectedPhotoImage == nil ? "Profile picture" : "Photo selected")
                    .font(.title3.bold())
                    .foregroundStyle(ScholarTheme.onSurface)
                Text("Use a device photo or choose one of the Little Scholar avatars.")
                    .font(.subheadline)
                    .foregroundStyle(ScholarTheme.onSurfaceVariant)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
    }

    private func loadPhoto(from item: PhotosPickerItem?) {
        guard let item else { return }
        isLoadingPhoto = true
        Task {
            defer { isLoadingPhoto = false }
            guard let data = try? await item.loadTransferable(type: Data.self),
                  let encoded = childProfileAvatarValue(from: data),
                  let image = childProfileImage(from: encoded) else {
                return
            }
            selectedPhotoAvatarValue = encoded
            selectedPhotoImage = image
        }
    }
}

struct ChildProfileView: View {
    let profiles: [ChildProfile]
    let onSaveProfile: (String, Int, String, String) -> Void

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var childName = ""
    @State private var age = 6
    @State private var grade = "Grade 1"
    @State private var avatar: KidAvatar = .unicorn

    private let grades = ["Nursery", "LKG", "UKG", "Kindergarten", "Grade 1", "Grade 2", "Grade 3", "Grade 4", "Grade 5"]
    private var usesWideLayout: Bool { horizontalSizeClass == .regular }

    var body: some View {
        Group {
            if usesWideLayout {
                HStack(alignment: .top, spacing: 18) {
                    profileForm.frame(maxWidth: 460)
                    profileList
                }
            } else {
                VStack(spacing: 16) {
                    profileForm
                    profileList
                }
            }
        }
        .adaptiveContentWidth()
    }

    private var profileForm: some View {
        sectionCard(title: "Create Kid Profile", icon: "person.crop.circle.badge.plus") {
            VStack(spacing: 14) {
                TextField("Kid name", text: $childName).textFieldStyle(.roundedBorder).font(.title3)
                Stepper("Age: \(age)", value: $age, in: 3...12).font(.title3.bold())
                Picker("Grade", selection: $grade) { ForEach(grades, id: \.self) { Text($0).tag($0) } }.pickerStyle(.menu)
                AvatarPicker(selection: $avatar)
                Button {
                    onSaveProfile(childName, age, grade, avatar.rawValue)
                    childName = ""
                } label: {
                    Label("Add Kid Profile", systemImage: "plus.circle.fill").frame(maxWidth: .infinity)
                }
                .buttonStyle(CheerfulButtonStyle(color: ScholarTheme.primary))
                .disabled(childName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }

    private var profileList: some View {
        sectionCard(title: "Kid Profiles", icon: "person.3.fill") {
            if profiles.isEmpty {
                EmptyStateView(icon: "person.crop.circle.badge.plus", title: "No profiles yet", message: "Create one or more kid profiles to assign exams.")
            } else {
                LazyVStack(spacing: 12) { ForEach(profiles) { ProfileRow(profile: $0) } }
            }
        }
    }
}

struct ExamSetupView: View {
    let profiles: [ChildProfile]
    let exams: [Exam]
    let isGenerating: Bool
    let onGenerateExam: (ChildProfile, Subject, Difficulty, Int) -> Void

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var selectedProfileID: UUID?
    @State private var selectedSubject: Subject = .maths
    @State private var selectedDifficulty: Difficulty = .easy
    @State private var numberOfQuestions = 5

    private var usesWideLayout: Bool { horizontalSizeClass == .regular }

    var body: some View {
        Group {
            if usesWideLayout {
                HStack(alignment: .top, spacing: 18) {
                    setupForm.frame(maxWidth: 460)
                    ExamPreviewView(exams: exams.filter { !$0.isCompleted })
                }
            } else {
                VStack(spacing: 16) {
                    setupForm
                    ExamPreviewView(exams: exams.filter { !$0.isCompleted })
                }
            }
        }
        .adaptiveContentWidth()
        .onAppear(perform: ensureSelectedProfile)
    }

    private var setupForm: some View {
        sectionCard(title: "Generate Practice", icon: "doc.badge.plus") {
            if profiles.isEmpty {
                EmptyStateView(icon: "person.2.slash", title: "Add a kid first", message: "Go to Parent Mode and create a kid profile before making an exam.")
            } else {
                VStack(alignment: .leading, spacing: 14) {
                    Picker("Kid", selection: selectedProfileBinding) { ForEach(profiles) { Text("\($0.name), \($0.grade)").tag(Optional($0.profileID)) } }.pickerStyle(.menu)
                    Picker("Subject", selection: $selectedSubject) { ForEach(Subject.allCases) { Text($0.rawValue).tag($0) } }.pickerStyle(.menu)
                    Picker("Difficulty", selection: $selectedDifficulty) { ForEach(Difficulty.allCases) { Text($0.rawValue).tag($0) } }.pickerStyle(.segmented)
                    Stepper("Questions: \(numberOfQuestions)", value: $numberOfQuestions, in: 5...25, step: 5).font(.title3.bold())
                    if isGenerating {
                        ExamGeneratingView()
                    } else {
                        Button {
                            guard let selectedProfile else { return }
                            onGenerateExam(selectedProfile, selectedSubject, selectedDifficulty, numberOfQuestions)
                        } label: {
                            Label("Generate Practice", systemImage: "sparkles").frame(maxWidth: .infinity)
                        }
                        .buttonStyle(CheerfulButtonStyle(color: ScholarTheme.primary))
                    }
                }
            }
        }
    }

    private var selectedProfile: ChildProfile? {
        guard let selectedProfileID else { return profiles.first }
        return profiles.first { $0.profileID == selectedProfileID } ?? profiles.first
    }

    private var selectedProfileBinding: Binding<UUID?> {
        Binding(get: { selectedProfile?.profileID }, set: { selectedProfileID = $0 })
    }

    private func ensureSelectedProfile() {
        if selectedProfileID == nil || selectedProfile == nil { selectedProfileID = profiles.first?.profileID }
    }
}

struct ExamGeneratingView: View {
    @State private var bounce = false
    @State private var sparkle = false

    var body: some View {
        VStack(spacing: 14) {
            HStack(spacing: 18) {
                animatedIcon("pencil.and.scribble", color: ScholarTheme.primary, delay: 0)
                animatedIcon("sparkles", color: ScholarTheme.lavender, delay: 0.12)
                animatedIcon("brain.head.profile", color: ScholarTheme.sky, delay: 0.24)
            }
            .padding(.top, 4)

            Text("Creating a smart exam...")
                .font(.title3.bold())
                .multilineTextAlignment(.center)

            Text("Little Scholar is picking fun questions for your kid.")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            ProgressView(value: sparkle ? 0.86 : 0.28)
                .tint(ScholarTheme.primary)
                .animation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true), value: sparkle)
        }
        .frame(maxWidth: .infinity)
        .padding(18)
        .background(ScholarTheme.primarySoft.opacity(0.18))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .onAppear {
            bounce = true
            sparkle = true
        }
    }

    private func animatedIcon(_ systemName: String, color: Color, delay: Double) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 30, weight: .bold))
            .foregroundStyle(color)
            .frame(width: 56, height: 56)
            .background(color.opacity(0.14))
            .clipShape(Circle())
            .scaleEffect(bounce ? 1.12 : 0.92)
            .offset(y: bounce ? -7 : 7)
            .animation(.easeInOut(duration: 0.72).repeatForever(autoreverses: true).delay(delay), value: bounce)
    }
}

struct ExamPreviewView: View {
    let exams: [Exam]
    var body: some View {
        sectionCard(title: "Pending Practice", icon: "tray.full.fill") {
            if exams.isEmpty {
                EmptyStateView(icon: "tray", title: "No pending papers", message: "Generated exams will wait here until the kid completes them.")
            } else {
                LazyVStack(spacing: 12) { ForEach(exams) { ExamPreviewRow(exam: $0) } }
            }
        }
    }
}

struct KidExamListView: View {
    let profiles: [ChildProfile]
    let exams: [Exam]
    let latestResult: ExamResult?
    let onSubmit: (Exam, [UUID: String]) -> ExamResult?
    let onCreateExam: () -> Void
    let onDeleteProfile: (ChildProfile) -> Void
    let onUpdateProfile: (ChildProfile, String, Int, String, String) -> Void

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var selectedProfileID: PersistentIdentifier?
    @State private var selectedExam: Exam?
    @State private var completedResult: ExamResult?
    @State private var profilePendingDeletion: ChildProfile?
    @State private var profileBeingEdited: ChildProfile?
    @State private var showDeleteProfileConfirmation = false
    @State private var showEditProfileSheet = false

    private var usesWideLayout: Bool { horizontalSizeClass == .regular }

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
                        if let latestResult { LatestResultBanner(result: latestResult) }
                        if usesWideLayout {
                            HStack(alignment: .top, spacing: 18) {
                                profilePicker.frame(maxWidth: 520)
                                assignedExams
                            }
                        } else {
                            VStack(spacing: 16) {
                                profilePicker
                                assignedExams
                            }
                        }
                    }
                    .padding()
                    .adaptiveContentWidth()
                }
                .onAppear(perform: ensureSelectedProfile)
            }
        }
        .confirmationDialog(
            "Delete kid profile?",
            isPresented: $showDeleteProfileConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete Profile and History", role: .destructive) {
                confirmProfileDeletion()
            }
            Button("Cancel", role: .cancel) {
                profilePendingDeletion = nil
            }
        } message: {
            Text("This will remove the kid profile, assigned exams, and exam history for that kid.")
        }
        .sheet(isPresented: $showEditProfileSheet) {
            if let profileBeingEdited {
                EditKidProfileView(profile: profileBeingEdited, onSave: onUpdateProfile)
            }
        }
    }

    private var profilePicker: some View {
        sectionCard(title: "Choose Your Profile", icon: "figure.child.circle.fill") {
            if profiles.isEmpty {
                EmptyStateView(icon: "person.crop.circle.badge.questionmark", title: "No kid profiles", message: "Ask a parent to create a profile first.")
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {
                    ForEach(profiles) { profile in
                        let isSelected = selectedProfileID == profile.persistentModelID
                        VStack(spacing: 8) {
                            HStack(spacing: 8) {
                                Spacer()
                                Button {
                                    profileBeingEdited = profile
                                    showEditProfileSheet = true
                                } label: {
                                    Image(systemName: "pencil.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(ScholarTheme.sky)
                                        .frame(width: 36, height: 36)
                                        .background(ScholarTheme.sky.opacity(0.12))
                                        .clipShape(Circle())
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel("Edit \(profile.name) profile")

                                Button {
                                    profilePendingDeletion = profile
                                    showDeleteProfileConfirmation = true
                                } label: {
                                    Image(systemName: "trash.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(ScholarTheme.coral)
                                        .frame(width: 36, height: 36)
                                        .background(ScholarTheme.coral.opacity(0.12))
                                        .clipShape(Circle())
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel("Delete \(profile.name) profile")
                            }

                            Button {
                                selectedProfileID = profile.persistentModelID
                                selectedExam = nil
                                completedResult = nil
                            } label: {
                                VStack(spacing: 8) {
                                    ChildProfilePhotoBadge(avatarValue: profile.avatar, isSelected: isSelected)
                                    Text(profile.name).font(.title3.bold()).foregroundStyle(.primary).lineLimit(1)
                                    Text(profile.grade).font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(12)
                        .background(isSelected ? ScholarTheme.mint.opacity(0.22) : ScholarTheme.controlSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    }
                }
            }
        }
    }

    private var assignedExams: some View {
        sectionCard(title: "Your Practice", icon: "doc.text.fill") {
            if selectedProfile == nil {
                EmptyStateView(icon: "hand.tap.fill", title: "Tap your profile", message: "Then your practice will appear here.")
            } else if examsForSelectedProfile.isEmpty {
                VStack(spacing: 14) {
                    EmptyStateView(icon: "doc.badge.clock", title: "No practice assigned", message: "Ask a parent to generate practice for you.")
                    Button(action: onCreateExam) { Label("Go to Practice", systemImage: "doc.badge.plus").frame(maxWidth: .infinity) }.buttonStyle(CheerfulButtonStyle(color: ScholarTheme.primary))
                }
            } else {
                LazyVStack(spacing: 12) { ForEach(examsForSelectedProfile) { exam in Button { selectedExam = exam } label: { ExamStartRow(exam: exam) }.buttonStyle(.plain) } }
            }
        }
    }

    private var selectedProfile: ChildProfile? {
        guard let selectedProfileID else { return nil }
        return profiles.first { $0.persistentModelID == selectedProfileID }
    }
    private var examsForSelectedProfile: [Exam] { selectedProfile.map { profile in exams.filter { $0.childProfileID == profile.profileID } } ?? [] }
    private func ensureSelectedProfile() {
        if let selectedProfileID, !profiles.contains(where: { $0.persistentModelID == selectedProfileID }) {
            self.selectedProfileID = nil
        }
    }

    private func confirmProfileDeletion() {
        guard let profile = profilePendingDeletion else { return }
        if selectedProfileID == profile.persistentModelID {
            selectedProfileID = nil
            selectedExam = nil
            completedResult = nil
        }
        onDeleteProfile(profile)
        profilePendingDeletion = nil
    }
}

struct EditKidProfileView: View {
    let profile: ChildProfile
    let onSave: (ChildProfile, String, Int, String, String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var age: Int
    @State private var grade: String
    @State private var avatar: KidAvatar

    private let grades = ["Nursery", "LKG", "UKG", "Kindergarten", "Grade 1", "Grade 2", "Grade 3", "Grade 4", "Grade 5"]

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    init(profile: ChildProfile, onSave: @escaping (ChildProfile, String, Int, String, String) -> Void) {
        self.profile = profile
        self.onSave = onSave
        _name = State(initialValue: profile.name)
        _age = State(initialValue: profile.age)
        _grade = State(initialValue: profile.grade)
        _avatar = State(initialValue: KidAvatar.avatar(for: profile.avatar))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    sectionCard(title: "Modify Kid Profile", icon: "pencil.circle.fill") {
                        VStack(spacing: 14) {
                            TextField("Kid name", text: $name)
                                .textFieldStyle(.roundedBorder)
                                .font(.title3)
                            Stepper("Age: \(age)", value: $age, in: 3...12)
                                .font(.title3.bold())
                            Picker("Grade", selection: $grade) {
                                ForEach(grades, id: \.self) { Text($0).tag($0) }
                            }
                            .pickerStyle(.menu)
                            AvatarPicker(selection: $avatar)
                        }
                    }
                }
                .padding()
                .adaptiveContentWidth(maxWidth: 620)
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(profile, name, age, grade, avatar.rawValue)
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
}

struct ExamAttemptView: View {
    let exam: Exam
    let onSubmit: (Exam, [UUID: String]) -> Void

    @State private var currentIndex = 0
    @State private var answers: [UUID: String] = [:]

    private var currentQuestion: Question { exam.questions[currentIndex] }

    private var currentAnswerIsReady: Bool {
        guard let answer = answers[currentQuestion.id] else { return false }
        return !answer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func answerBinding(for questionID: UUID) -> Binding<String> {
        Binding(
            get: { answers[questionID] ?? "" },
            set: { answers[questionID] = $0 }
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("\(exam.childName)'s \(exam.subject) Practice")
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                Text("Question \(currentIndex + 1) of \(exam.questions.count)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                ProgressView(value: Double(currentIndex + 1), total: Double(exam.questions.count))
                    .tint(ScholarTheme.primary)

                VStack(alignment: .leading, spacing: 18) {
                    QuestionRenderer(question: currentQuestion, answer: answerBinding(for: currentQuestion.id))
                }
                .padding(20)
                .background(ScholarTheme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: ScholarTheme.shadow, radius: 12, y: 6)

                HStack(spacing: 12) {
                    Button { currentIndex = max(0, currentIndex - 1) } label: {
                        Label("Back", systemImage: "arrow.left.circle.fill").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(CheerfulButtonStyle(color: .gray))
                    .disabled(currentIndex == 0)

                    Button { currentIndex == exam.questions.count - 1 ? onSubmit(exam, answers) : (currentIndex += 1) } label: {
                        Label(currentIndex == exam.questions.count - 1 ? "Submit" : "Next", systemImage: "arrow.right.circle.fill").frame(maxWidth: .infinity)
                    }
                    .buttonStyle(CheerfulButtonStyle(color: ScholarTheme.primary))
                    .disabled(!currentAnswerIsReady)
                }
            }
            .padding()
            .frame(maxWidth: 860)
            .frame(maxWidth: .infinity)
        }
    }
}

struct QuestionRenderer: View {
    let question: Question
    @Binding var answer: String

    private var type: String { normalizedQuestionType(question.type) }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            if type == "reading_comprehension", let passage = question.passage, !passage.isEmpty {
                PassageBlock(passage: passage)
            }

            Text(question.prompt)
                .font(.title2.bold())
                .foregroundStyle(ScholarTheme.onSurface)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityAddTraits(.isHeader)

            switch type {
            case "picture_identification", "shape_recognition", "color_recognition", "odd_one_out", "compare_objects", "picture_mcq", "pattern_recognition":
                VisualChoiceQuestion(question: question, answer: $answer)
            case "count_and_answer":
                CountAndAnswerQuestion(question: question, answer: $answer)
            case "missing_number":
                ChoiceOrTextQuestion(question: question, answer: $answer, keyboardType: .numberPad)
            case "simple_match", "match_following":
                MatchingQuestion(question: question, answer: $answer)
            case "simple_true_false", "true_false":
                ChoiceGrid(options: ["True", "False"], selection: $answer, visualStyle: false)
            case "fill_blank", "short_answer":
                CompactAnswerField(answer: $answer, placeholder: "Type answer", keyboardType: .default)
            case "reading_comprehension":
                if question.options.isEmpty {
                    CompactAnswerField(answer: $answer, placeholder: "Type answer", keyboardType: .default)
                } else {
                    ChoiceGrid(options: question.options, selection: $answer, visualStyle: false)
                }
            case "sequence_ordering":
                SequenceOrderingQuestion(items: question.options.isEmpty ? question.visualElements : question.options, answer: $answer)
            case "categorization":
                CategorizationQuestion(question: question, answer: $answer)
            case "mcq":
                ChoiceOrTextQuestion(question: question, answer: $answer, keyboardType: .default)
            default:
                FallbackQuestion(question: question, answer: $answer)
            }
        }
    }
}

struct PassageBlock: View {
    let passage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Read first", systemImage: "book.pages.fill")
                .font(.headline)
                .foregroundStyle(ScholarTheme.primary)
            Text(passage)
                .font(.title3)
                .lineSpacing(4)
                .foregroundStyle(ScholarTheme.onSurface)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(ScholarTheme.primarySoft.opacity(0.45))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct FallbackQuestion: View {
    let question: Question
    @Binding var answer: String

    var body: some View {
        if !question.options.isEmpty {
            ChoiceGrid(options: question.options, selection: $answer, visualStyle: false)
        } else if !question.visualElements.isEmpty {
            ChoiceGrid(options: question.visualElements, selection: $answer, visualStyle: true)
        } else {
            CompactAnswerField(answer: $answer, placeholder: "Type answer", keyboardType: .default)
        }
    }
}

struct ChoiceOrTextQuestion: View {
    let question: Question
    @Binding var answer: String
    var keyboardType: UIKeyboardType

    var body: some View {
        if question.options.isEmpty {
            CompactAnswerField(answer: $answer, placeholder: "Type answer", keyboardType: keyboardType)
        } else {
            ChoiceGrid(options: question.options, selection: $answer, visualStyle: false)
        }
    }
}

struct VisualChoiceQuestion: View {
    let question: Question
    @Binding var answer: String

    private var choices: [String] {
        if !question.visualElements.isEmpty { return question.visualElements }
        return question.options
    }

    var body: some View {
        if choices.isEmpty {
            CompactAnswerField(answer: $answer, placeholder: "Type answer", keyboardType: .default)
        } else {
            ChoiceGrid(options: choices, selection: $answer, visualStyle: true)
        }
    }
}

struct CountAndAnswerQuestion: View {
    let question: Question
    @Binding var answer: String

    private var numberOptions: [String] {
        if !question.options.isEmpty { return question.options }
        let maxNumber = normalizedQuestionType(question.type) == "count_and_answer" && question.visualElements.count > 5 ? 10 : 5
        return (1...maxNumber).map(String.init)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !question.visualElements.isEmpty {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 64), spacing: 12)], spacing: 12) {
                    ForEach(Array(question.visualElements.enumerated()), id: \.offset) { _, item in
                        Text(item)
                            .font(.system(size: 46))
                            .frame(minWidth: 64, minHeight: 64)
                            .background(ScholarTheme.controlSurface)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                }
                Text("How many?")
                    .font(.headline)
                    .foregroundStyle(ScholarTheme.onSurfaceVariant)
            }
            ChoiceGrid(options: numberOptions, selection: $answer, visualStyle: false)
        }
    }
}

struct ChoiceGrid: View {
    let options: [String]
    @Binding var selection: String
    var visualStyle: Bool

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: visualStyle ? 96 : 150), spacing: 12)]
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(options, id: \.self) { option in
                QuestionChoiceButton(option: option, isSelected: selection == option, visualStyle: visualStyle) {
                    withAnimation(.spring(response: 0.24, dampingFraction: 0.82)) {
                        selection = option
                    }
                }
            }
        }
    }
}

struct QuestionChoiceButton: View {
    let option: String
    let isSelected: Bool
    let visualStyle: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                if visualStyle, let color = colorFromAnswer(option) {
                    Circle()
                        .fill(color)
                        .frame(width: 58, height: 58)
                        .overlay(Circle().stroke(ScholarTheme.hairline(2), lineWidth: 1))
                } else {
                    Text(option)
                        .font(visualStyle ? .system(size: 42, weight: .bold) : .title3.bold())
                        .minimumScaleFactor(0.72)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(ScholarTheme.onSurface)
                }

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.headline)
                        .foregroundStyle(ScholarTheme.primary)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: visualStyle ? 96 : 60)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(isSelected ? ScholarTheme.primarySoft.opacity(0.85) : ScholarTheme.controlSurface)
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(isSelected ? ScholarTheme.primary : ScholarTheme.hairline(), lineWidth: isSelected ? 2 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(option)
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}

struct CompactAnswerField: View {
    @Binding var answer: String
    let placeholder: String
    let keyboardType: UIKeyboardType

    var body: some View {
        TextField(placeholder, text: $answer)
            .textFieldStyle(.plain)
            .font(.title3.weight(.semibold))
            .keyboardType(keyboardType)
            .textInputAutocapitalization(.never)
            .padding(16)
            .frame(minHeight: 56)
            .background(ScholarTheme.controlSurface)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(ScholarTheme.hairline(), lineWidth: 1)
            )
    }
}

struct MatchingQuestion: View {
    let question: Question
    @Binding var answer: String

    @State private var selectedLeft: String?
    @State private var pairs: [String: String] = [:]

    var body: some View {
        if question.leftItems.isEmpty || question.rightItems.isEmpty {
            UnsupportedQuestionFallback(message: "This matching question is missing one of its columns.")
        } else {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top, spacing: 14) {
                    matchingColumn(title: "Match", items: question.leftItems, isLeft: true)
                    matchingColumn(title: "With", items: question.rightItems, isLeft: false)
                }

                if !pairs.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your matches")
                            .font(.headline)
                            .foregroundStyle(ScholarTheme.onSurfaceVariant)
                        ForEach(question.leftItems.filter { pairs[$0] != nil }, id: \.self) { left in
                            HStack {
                                Text(left)
                                Image(systemName: "arrow.right")
                                    .foregroundStyle(ScholarTheme.primary)
                                Text(pairs[left] ?? "")
                            }
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(ScholarTheme.onSurface)
                        }
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(ScholarTheme.controlSurface)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
            }
            .onAppear { pairs = decodedStringMap(answer) ?? [:] }
        }
    }

    private func matchingColumn(title: String, items: [String], isLeft: Bool) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundStyle(ScholarTheme.onSurfaceVariant)
            ForEach(items, id: \.self) { item in
                Button {
                    handleTap(item, isLeft: isLeft)
                } label: {
                    HStack {
                        Text(item)
                            .font(.headline)
                            .foregroundStyle(ScholarTheme.onSurface)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if isLeft, selectedLeft == item {
                            Image(systemName: "hand.point.up.left.fill")
                                .foregroundStyle(ScholarTheme.primary)
                        } else if isLeft, pairs[item] != nil {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(ScholarTheme.primary)
                        } else if !isLeft, pairs.values.contains(item) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(ScholarTheme.primary)
                        }
                    }
                    .padding(14)
                    .frame(minHeight: 54)
                    .background(itemIsActive(item, isLeft: isLeft) ? ScholarTheme.primarySoft.opacity(0.85) : ScholarTheme.controlSurface)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    private func itemIsActive(_ item: String, isLeft: Bool) -> Bool {
        if isLeft { return selectedLeft == item || pairs[item] != nil }
        return pairs.values.contains(item)
    }

    private func handleTap(_ item: String, isLeft: Bool) {
        withAnimation(.spring(response: 0.24, dampingFraction: 0.86)) {
            if isLeft {
                selectedLeft = item
            } else if let left = selectedLeft {
                pairs[left] = item
                selectedLeft = nil
                answer = encodedStringMap(pairs)
            }
        }
    }
}

struct SequenceOrderingQuestion: View {
    let items: [String]
    @Binding var answer: String

    @State private var orderedItems: [String] = []

    private var remainingItems: [String] {
        items.filter { !orderedItems.contains($0) }
    }

    var body: some View {
        if items.isEmpty {
            UnsupportedQuestionFallback(message: "This ordering question is missing items.")
        } else {
            VStack(alignment: .leading, spacing: 16) {
                Text("Tap each item in the right order.")
                    .font(.headline)
                    .foregroundStyle(ScholarTheme.onSurfaceVariant)
                FlowChips(items: orderedItems, selectedItems: Set(orderedItems), emptyText: "Your order will appear here") { item in
                    withAnimation(.spring(response: 0.24, dampingFraction: 0.86)) {
                        orderedItems.removeAll { $0 == item }
                        answer = encodedStringArray(orderedItems)
                    }
                }
                FlowChips(items: remainingItems, selectedItems: []) { item in
                    withAnimation(.spring(response: 0.24, dampingFraction: 0.86)) {
                        orderedItems.append(item)
                        answer = encodedStringArray(orderedItems)
                    }
                }
            }
            .onAppear { orderedItems = decodedStringArray(answer) ?? [] }
        }
    }
}

struct CategorizationQuestion: View {
    let question: Question
    @Binding var answer: String

    @State private var selectedItem: String?
    @State private var buckets: [String: [String]] = [:]

    private var items: [String] {
        question.visualElements.isEmpty ? question.options : question.visualElements
    }

    private var unassignedItems: [String] {
        let assigned = Set(buckets.values.flatMap { $0 })
        return items.filter { !assigned.contains($0) }
    }

    var body: some View {
        if question.categories.isEmpty || items.isEmpty {
            UnsupportedQuestionFallback(message: "This sorting question is missing categories or items.")
        } else {
            VStack(alignment: .leading, spacing: 16) {
                Text("Tap an item, then tap where it belongs.")
                    .font(.headline)
                    .foregroundStyle(ScholarTheme.onSurfaceVariant)

                FlowChips(items: unassignedItems, selectedItems: selectedItem.map { Set([$0]) } ?? []) { item in
                    selectedItem = item
                }

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 180), spacing: 12)], spacing: 12) {
                    ForEach(question.categories, id: \.self) { category in
                        Button {
                            assignSelectedItem(to: category)
                        } label: {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(category)
                                    .font(.headline)
                                    .foregroundStyle(ScholarTheme.primary)
                                let categoryItems = buckets[category, default: []]
                                if categoryItems.isEmpty {
                                    Text("Drop here")
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(ScholarTheme.onSurfaceVariant)
                                } else {
                                    ForEach(categoryItems, id: \.self) { item in
                                        Text(item)
                                            .font(.subheadline.weight(.semibold))
                                            .foregroundStyle(ScholarTheme.onSurface)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 8)
                                            .background(ScholarTheme.primarySoft.opacity(0.7))
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, minHeight: 118, alignment: .topLeading)
                            .padding(14)
                            .background(ScholarTheme.controlSurface)
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .onAppear {
                buckets = decodedStringArrayMap(answer) ?? Dictionary(uniqueKeysWithValues: question.categories.map { ($0, []) })
            }
        }
    }

    private func assignSelectedItem(to category: String) {
        guard let selectedItem else { return }
        withAnimation(.spring(response: 0.24, dampingFraction: 0.86)) {
            for key in buckets.keys {
                buckets[key]?.removeAll { $0 == selectedItem }
            }
            buckets[category, default: []].append(selectedItem)
            self.selectedItem = nil
            answer = encodedStringArrayMap(buckets)
        }
    }
}

struct FlowChips: View {
    let items: [String]
    var selectedItems: Set<String> = []
    var emptyText: String = "No items left"
    let onTap: (String) -> Void

    var body: some View {
        if items.isEmpty {
            Text(emptyText)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(ScholarTheme.onSurfaceVariant)
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(ScholarTheme.controlSurface)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        } else {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 92), spacing: 10)], spacing: 10) {
                ForEach(items, id: \.self) { item in
                    Button { onTap(item) } label: {
                        Text(item)
                            .font(.headline)
                            .foregroundStyle(ScholarTheme.onSurface)
                            .minimumScaleFactor(0.75)
                            .lineLimit(2)
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: 50)
                            .padding(.horizontal, 12)
                            .background(selectedItems.contains(item) ? ScholarTheme.primarySoft.opacity(0.85) : ScholarTheme.controlSurface)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct UnsupportedQuestionFallback: View {
    let message: String

    var body: some View {
        Label(message, systemImage: "questionmark.square.dashed")
            .font(.headline)
            .foregroundStyle(ScholarTheme.onSurfaceVariant)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(ScholarTheme.controlSurface)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

func colorFromAnswer(_ value: String) -> Color? {
    switch normalizedAnswerString(value) {
    case "red": .red
    case "blue": .blue
    case "green": .green
    case "yellow": .yellow
    case "orange": .orange
    case "purple": .purple
    case "pink": .pink
    case "black": .black
    case "white": .white
    case "brown": Color(red: 0.48, green: 0.28, blue: 0.14)
    case "gray", "grey": .gray
    default: nil
    }
}

struct PerformanceDashboardView: View {
    let profiles: [ChildProfile]
    let results: [ExamResult]

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var selectedProfileID: UUID?

    private var filteredResults: [ExamResult] { selectedProfileID.map { id in results.filter { $0.childProfileID == id } } ?? results }
    private var usesWideLayout: Bool { horizontalSizeClass == .regular }

    var body: some View {
        ScrollView {
            Group {
                if usesWideLayout {
                    HStack(alignment: .top, spacing: 18) {
                        dashboardCard.frame(maxWidth: 460)
                        ExamHistoryView(results: filteredResults)
                    }
                } else {
                    VStack(spacing: 16) {
                        dashboardCard
                        ExamHistoryView(results: filteredResults)
                    }
                }
            }
            .padding()
            .adaptiveContentWidth()
        }
    }

    private var dashboardCard: some View {
                sectionCard(title: "Progress", icon: "chart.bar.fill") {
            if profiles.isEmpty {
                EmptyStateView(icon: "person.2.slash", title: "No kids yet", message: "Create kid profiles to view performance history.")
            } else {
                VStack(spacing: 14) {
                    Picker("Kid", selection: $selectedProfileID) {
                        Text("All Kids").tag(Optional<UUID>.none)
                        ForEach(profiles) { Text($0.name).tag(Optional($0.profileID)) }
                    }
                    .pickerStyle(.menu)
                    HistorySummary(results: filteredResults)
                }
            }
        }
    }
}

struct ExamHistoryView: View {
    let results: [ExamResult]

    var body: some View {
        sectionCard(title: "Practice History", icon: "clock.fill") {
            if results.isEmpty {
                EmptyStateView(icon: "clock.badge.questionmark", title: "No completed practice", message: "Completed practice results will appear here.")
            } else {
                LazyVStack(spacing: 14) {
                    ForEach(results) { result in
                        NavigationLink { ResultView(result: result) } label: { ResultHistoryRow(result: result) }
                            .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

struct ResultView: View {
    let result: ExamResult

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 12) {
                    Image(systemName: result.percentage >= 70 ? "star.circle.fill" : "heart.circle.fill").font(.system(size: 64)).foregroundStyle(result.percentage >= 70 ? ScholarTheme.honey : ScholarTheme.coral)
                    Text("Great try, \(result.childName)!").font(.title.bold()).multilineTextAlignment(.center)
                    Text("Score: \(result.correctAnswers)/\(result.totalQuestions)").font(.largeTitle.bold())
                    Text("\(result.percentage)% • \(result.reportGrade)").font(.title2.bold()).foregroundStyle(ScholarTheme.sky)
                    Text(result.feedback).font(.title3.weight(.medium)).multilineTextAlignment(.center).foregroundStyle(.secondary)
                }
                .padding(24)
                .background(ScholarTheme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: ScholarTheme.shadow, radius: 12, y: 6)
                QuestionReviewList(evaluations: result.evaluations)
            }
            .padding()
            .frame(maxWidth: 900)
            .frame(maxWidth: .infinity)
        }
        .background(LittleScholarBackground())
        .navigationTitle("Practice Result")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct QuestionReviewList: View {
    let evaluations: [AnswerEvaluation]
    var body: some View {
        VStack(spacing: 12) {
            ForEach(evaluations) { item in
                VStack(alignment: .leading, spacing: 8) {
                    Label(item.isCorrect ? "Correct" : "Needs Practice", systemImage: item.isCorrect ? "checkmark.seal.fill" : "xmark.seal.fill").font(.headline).foregroundStyle(item.isCorrect ? ScholarTheme.mint : ScholarTheme.coral)
                    Text(item.question.prompt).font(.headline)
                    Text("Your answer: \(displayStoredAnswer(item.selectedAnswer))").foregroundStyle(item.isCorrect ? ScholarTheme.mint : ScholarTheme.coral)
                    if !item.isCorrect { Text("Correct answer: \(displayStoredAnswer(item.question.correctAnswer))") }
                    Text(item.question.explanation).font(.subheadline).foregroundStyle(.secondary)
                }.frame(maxWidth: .infinity, alignment: .leading).padding().background(ScholarTheme.surface).clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
        }
    }
}

struct HeaderView: View {
    let parentName: String
    let onLogout: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: "graduationcap.circle.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(ScholarTheme.primary)

                VStack(alignment: .leading, spacing: 3) {
                    Text("Little Scholar")
                        .font(.largeTitle.bold())
                    Text("Signed in as \(parentName)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button(action: onLogout) {
                    Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                        .labelStyle(.iconOnly)
                        .font(.title3.bold())
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
                .foregroundStyle(ScholarTheme.primary)
                .background(ScholarTheme.controlSurface)
                .clipShape(Circle())
                .accessibilityLabel("Logout")
            }

            Text("Parent setup, practice, child attempts, and progress")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: 900)
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
}

struct ModeNavigation: View {
    @Binding var selectedMode: AppMode
    var body: some View {
        HStack(spacing: 8) {
            ForEach(AppMode.allCases) { mode in
                Button { selectedMode = mode } label: {
                    VStack(spacing: 6) {
                        Image(systemName: mode.icon).font(.headline)
                        Text(mode.rawValue).font(.caption.bold()).lineLimit(1).minimumScaleFactor(0.75)
                    }
                    .frame(maxWidth: .infinity, minHeight: 62)
                    .foregroundStyle(selectedMode == mode ? Color.white : Color.primary)
                    .background(selectedMode == mode ? ScholarTheme.primary : ScholarTheme.controlSurface)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: ScholarTheme.shadow.opacity(selectedMode == mode ? 1 : 0.45), radius: 8, y: 4)
                }.buttonStyle(.plain)
            }
        }
        .frame(maxWidth: 900)
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    var body: some View {
        VStack(spacing: 10) { Image(systemName: icon).font(.system(size: 42)).foregroundStyle(ScholarTheme.primary); Text(title).font(.title3.bold()).multilineTextAlignment(.center); Text(message).font(.subheadline.weight(.medium)).foregroundStyle(.secondary).multilineTextAlignment(.center) }.frame(maxWidth: .infinity).padding(.vertical, 18)
    }
}

struct AvatarPicker: View {
    @Binding var selection: KidAvatar

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Choose Avatar")
                .font(.headline)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 92), spacing: 10)], spacing: 10) {
                ForEach(KidAvatar.allCases) { avatar in
                    Button {
                        selection = avatar
                    } label: {
                        VStack(spacing: 8) {
                            AvatarBadge(avatar: avatar, isSelected: selection == avatar)
                            Text(avatar.rawValue)
                                .font(.caption.bold())
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                                .minimumScaleFactor(0.75)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(selection == avatar ? avatar.color.opacity(0.24) : ScholarTheme.controlSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct AvatarBadge: View {
    let avatar: KidAvatar
    var isSelected = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(systemName: avatar.icon)
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(avatar.color)
                .frame(width: 56, height: 56)
                .background(avatar.color.opacity(0.16))
                .clipShape(Circle())

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(ScholarTheme.mint)
                    .background(ScholarTheme.controlSurface.clipShape(Circle()))
            }
        }
        .accessibilityLabel(avatar.rawValue)
    }
}

struct ChildProfilePhotoBadge: View {
    let avatarValue: String
    var isSelected = false
    var size: CGFloat = 56

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Group {
                if let image = childProfileImage(from: avatarValue) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    let avatar = KidAvatar.avatar(for: avatarValue)
                    Image(systemName: avatar.icon)
                        .font(.system(size: size * 0.54, weight: .bold))
                        .foregroundStyle(avatar.color)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(avatar.color.opacity(0.16))
                }
            }
            .frame(width: size, height: size)
            .clipShape(Circle())

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(size > 60 ? .title2 : .title3)
                    .foregroundStyle(ScholarTheme.mint)
                    .background(ScholarTheme.controlSurface.clipShape(Circle()))
            }
        }
    }
}

struct ProfileRow: View {
    let profile: ChildProfile
    var body: some View {
        row(
            icon: KidAvatar.avatar(for: profile.avatar).icon,
            title: profile.name,
            subtitle: "\(profile.avatar) • Age \(profile.age) • \(profile.grade)",
            color: KidAvatar.avatar(for: profile.avatar).color
        )
    }
}

struct ExamPreviewRow: View {
    let exam: Exam
    var body: some View { row(icon: "doc.text.fill", title: "\(exam.childName) • \(exam.subject)", subtitle: "\(exam.difficulty) • \(exam.questions.count) questions", color: ScholarTheme.sky) }
}

struct ExamStartRow: View {
    let exam: Exam
    var body: some View { row(icon: "book.fill", title: exam.subject, subtitle: "\(exam.difficulty) • \(exam.questions.count) questions • Start Practice", color: ScholarTheme.sky) }
}

struct ResultHistoryRow: View {
    let result: ExamResult
    var body: some View { row(icon: "chart.bar.fill", title: "\(result.childName) • \(result.percentage)%", subtitle: "\(result.subject) • \(result.correctAnswers) correct, \(result.totalQuestions - result.correctAnswers) wrong", color: ScholarTheme.primary) }
}

struct LatestResultBanner: View {
    let result: ExamResult
    var body: some View { NavigationLink { ResultView(result: result) } label: { row(icon: "star.circle.fill", title: "Latest Result", subtitle: "\(result.subject): \(result.percentage)% • \(result.reportGrade)", color: ScholarTheme.honey) }.buttonStyle(.plain).padding(.horizontal) }
}

struct HistorySummary: View {
    let results: [ExamResult]
    private var average: Int { results.isEmpty ? 0 : Int((Double(results.map(\.percentage).reduce(0, +)) / Double(results.count)).rounded()) }
    var body: some View { HStack(spacing: 12) { SummaryTile(title: "Practice", value: "\(results.count)", color: ScholarTheme.primary); SummaryTile(title: "Average", value: "\(average)%", color: ScholarTheme.sky); SummaryTile(title: "Best", value: "\(results.map(\.percentage).max() ?? 0)%", color: ScholarTheme.honey) } }
}

struct SummaryTile: View {
    let title: String
    let value: String
    let color: Color
    var body: some View { VStack(spacing: 6) { Text(value).font(.title2.bold()).foregroundStyle(color); Text(title).font(.caption.bold()).foregroundStyle(.secondary) }.frame(maxWidth: .infinity).padding(.vertical, 14).background(color.opacity(0.12)).clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous)) }
}

struct CheerfulButtonStyle: ButtonStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        CheerfulButton(label: configuration.label, color: color, isPressed: configuration.isPressed)
    }

    private struct CheerfulButton<Label: View>: View {
        @Environment(\.isEnabled) private var isEnabled

        let label: Label
        let color: Color
        let isPressed: Bool

        var body: some View {
            label
                .font(.title3.bold())
                .foregroundStyle(.white)
                .padding(.vertical, 16)
                .padding(.horizontal, 18)
                .background(isEnabled ? color.opacity(isPressed ? 0.72 : 1) : Color.gray.opacity(0.45))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .scaleEffect(isPressed && isEnabled ? 0.97 : 1)
                .opacity(isEnabled ? 1 : 0.62)
        }
    }
}

struct LittleScholarBackground: View {
    var body: some View {
        LSBackground()
    }
}

@ViewBuilder
func sectionCard<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
    VStack(alignment: .leading, spacing: 16) {
        Label(title, systemImage: icon)
            .font(.title2.bold())
            .foregroundStyle(.primary)
        content()
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(20)
    .background(ScholarTheme.surface)
    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    .shadow(color: ScholarTheme.shadow, radius: 12, y: 6)
}

func row(icon: String, title: String, subtitle: String, color: Color) -> some View {
    HStack(spacing: 12) {
        Image(systemName: icon)
            .font(.title)
            .foregroundStyle(color)
            .frame(width: 42)
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)
            Text(subtitle)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
        }
        Spacer()
    }
    .padding()
    .background(ScholarTheme.controlSurface)
    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
}

struct PremiumScrollView<Content: View>: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @ViewBuilder var content: () -> Content
    private var isCompact: Bool { horizontalSizeClass == .compact }

    var body: some View {
        ScrollView {
            content()
                .padding(.horizontal, isCompact ? 16 : 48)
                .padding(.top, isCompact ? 20 : 44)
                .padding(.bottom, isCompact ? 108 : 132)
                .adaptiveContentWidth(maxWidth: 1100)
        }
        .background(LSBackground())
    }
}

struct LSTopAppBar: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    let parentName: String
    private var isCompact: Bool { horizontalSizeClass == .compact }

    var body: some View {
        HStack(spacing: isCompact ? 12 : 28) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Little Scholar")
                    .font(.system(size: isCompact ? 30 : 44, weight: .bold))
                    .foregroundStyle(ScholarTheme.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }

            Spacer(minLength: 18)

            if !isCompact {
                Text(greeting)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(ScholarTheme.onSurface)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
            }

            Image(systemName: "person.crop.circle")
                .font(.system(size: isCompact ? 22 : 28, weight: .semibold))
                .foregroundStyle(ScholarTheme.primary)
                .frame(width: isCompact ? 40 : 44, height: isCompact ? 40 : 44)
                .background(ScholarTheme.controlSurface)
                .clipShape(Circle())
        }
        .padding(.horizontal, isCompact ? 16 : 48)
        .frame(maxWidth: 1100, minHeight: isCompact ? 64 : 88)
        .frame(maxWidth: .infinity)
        .background(ScholarTheme.surface.opacity(0.92))
        .accessibilityElement(children: .combine)
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: .now)
        let name = parentName.trimmingCharacters(in: .whitespacesAndNewlines)
        let displayName = name.isEmpty ? "" : ", \(name)"
        switch hour {
        case 5..<12: return "Good Morning\(displayName)"
        case 12..<17: return "Good Afternoon\(displayName)"
        case 17..<22: return "Good Evening\(displayName)"
        default: return name.isEmpty ? "Welcome back" : "Welcome back, \(name)"
        }
    }
}

struct LSTonalPanel<Content: View>: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @ViewBuilder var content: () -> Content
    private var isCompact: Bool { horizontalSizeClass == .compact }

    var body: some View {
        content()
            .padding(isCompact ? 18 : 48)
            .background(ScholarTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: isCompact ? 22 : 28, style: .continuous))
    }
}

struct LSResponsiveColumns<Leading: View, Trailing: View>: View {
    let spacing: CGFloat
    let leadingMinWidth: CGFloat
    let trailingMinWidth: CGFloat
    @ViewBuilder var leading: () -> Leading
    @ViewBuilder var trailing: () -> Trailing

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .top, spacing: spacing) {
                leading()
                    .frame(minWidth: leadingMinWidth, maxWidth: .infinity, alignment: .topLeading)
                trailing()
                    .frame(minWidth: trailingMinWidth, maxWidth: .infinity, alignment: .topLeading)
            }

            VStack(alignment: .leading, spacing: spacing) {
                leading()
                trailing()
            }
        }
    }
}

struct LSActionHeader: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let title: String
    let buttonTitle: String
    let buttonIcon: String
    let action: () -> Void
    private var isCompact: Bool { horizontalSizeClass == .compact }

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .center) {
                titleText
                Spacer(minLength: 24)
                actionButton
            }

            VStack(alignment: .leading, spacing: 20) {
                titleText
                actionButton
            }
        }
    }

    private var titleText: some View {
        Text(title)
            .font(.system(size: isCompact ? 32 : 44, weight: .bold))
            .foregroundStyle(ScholarTheme.onSurface)
            .minimumScaleFactor(0.72)
            .lineLimit(2)
    }

    private var actionButton: some View {
        Button(action: action) {
            Label(buttonTitle, systemImage: buttonIcon)
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, isCompact ? 22 : 30)
                .frame(minHeight: isCompact ? 50 : 58)
                .background(ScholarTheme.primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct PremiumHeader: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let eyebrow: String
    let title: String
    let subtitle: String
    private var isCompact: Bool { horizontalSizeClass == .compact }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !eyebrow.isEmpty {
                Text(eyebrow)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(ScholarTheme.primary)
                    .textCase(.uppercase)
                    .tracking(0.8)
            }
            Text(title)
                .font((isCompact ? Font.title.bold() : Font.largeTitle.bold()))
                .foregroundStyle(ScholarTheme.primaryText)
                .lineLimit(2)
                .minimumScaleFactor(0.72)
            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(isCompact ? .subheadline.weight(.medium) : .headline)
                    .foregroundStyle(ScholarTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

struct LSBackground: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ScholarTheme.background
            .overlay(alignment: .topLeading) {
                LinearGradient(
                    colors: colorScheme == .dark
                        ? [ScholarTheme.primary.opacity(0.16), Color.clear]
                        : [Color.white.opacity(0.68), ScholarTheme.primarySoft.opacity(0.18), Color.clear],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            }
            .ignoresSafeArea()
    }
}

struct LSCard<Content: View>: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @ViewBuilder var content: () -> Content
    private var isCompact: Bool { horizontalSizeClass == .compact }

    var body: some View {
        content()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(isCompact ? 18 : 26)
            .background(ScholarTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: isCompact ? 20 : 26, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: isCompact ? 20 : 26, style: .continuous)
                    .stroke(ScholarTheme.hairline(0.9), lineWidth: 1)
            }
            .shadow(color: ScholarTheme.shadow, radius: isCompact ? 10 : 16, x: 0, y: isCompact ? 5 : 8)
    }
}

struct LSHeroCard<Content: View>: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @ViewBuilder var content: () -> Content
    private var isCompact: Bool { horizontalSizeClass == .compact }

    var body: some View {
        content()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(isCompact ? 22 : 30)
            .background(ScholarTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: isCompact ? 22 : 30, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: isCompact ? 22 : 30, style: .continuous)
                    .stroke(ScholarTheme.primary.opacity(0.08), lineWidth: 1)
            }
            .shadow(color: ScholarTheme.shadow, radius: isCompact ? 12 : 18, x: 0, y: isCompact ? 6 : 10)
    }
}

struct LSSectionHeader: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let title: String
    let subtitle: String
    let icon: String
    private var isCompact: Bool { horizontalSizeClass == .compact }

    var body: some View {
        HStack(alignment: .top, spacing: isCompact ? 10 : 12) {
            Image(systemName: icon)
                .font((isCompact ? Font.subheadline.weight(.bold) : Font.headline.weight(.bold)))
                .foregroundStyle(ScholarTheme.primary)
                .frame(width: isCompact ? 32 : 36, height: isCompact ? 32 : 36)
                .background(ScholarTheme.primary.opacity(0.09))
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(isCompact ? .headline.bold() : .title2.bold())
                Text(subtitle)
                    .font(isCompact ? .caption.weight(.medium) : .subheadline.weight(.medium))
                    .foregroundStyle(ScholarTheme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
    }
}

struct LSStatCard: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let title: String
    let value: String
    let icon: String
    let color: Color
    private var isCompact: Bool { horizontalSizeClass == .compact }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(isCompact ? .subheadline.weight(.bold) : .headline.weight(.bold))
                .foregroundStyle(color)
                .frame(width: isCompact ? 30 : 34, height: isCompact ? 30 : 34)
                .background(color.opacity(0.09))
                .clipShape(Circle())
            Text(value)
                .font(isCompact ? .title3.bold() : .title.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(title)
                .font(.caption.weight(.bold))
                .foregroundStyle(ScholarTheme.secondaryText)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, minHeight: isCompact ? 98 : 116, alignment: .leading)
        .padding(isCompact ? 14 : 18)
        .background(ScholarTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(ScholarTheme.hairline(), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
    }
}

struct LSMetricTile: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let title: String
    let value: String
    let detail: String
    let icon: String
    private var isCompact: Bool { horizontalSizeClass == .compact }

    var body: some View {
        VStack(alignment: .leading, spacing: isCompact ? 14 : 22) {
            Label(title, systemImage: icon)
                .font(isCompact ? .subheadline.weight(.semibold) : .headline)
                .foregroundStyle(ScholarTheme.onSurface)
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .lastTextBaseline, spacing: 10) {
                    metricValue
                    detailText
                }
                VStack(alignment: .leading, spacing: 6) {
                    metricValue
                    detailText
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: isCompact ? 112 : 138, alignment: .leading)
        .padding(isCompact ? 18 : 24)
        .background(ScholarTheme.cardBackground.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(ScholarTheme.hairline(0.9), lineWidth: 1)
        }
        .shadow(color: ScholarTheme.shadow, radius: 12, y: 4)
        .accessibilityElement(children: .combine)
    }

    private var metricValue: some View {
        Text(value)
            .font(.system(size: isCompact ? 28 : 36, weight: .bold))
            .foregroundStyle(ScholarTheme.onSurface)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
    }

    private var detailText: some View {
        Text(detail)
            .font(isCompact ? .caption.weight(.medium) : .subheadline)
            .foregroundStyle(ScholarTheme.onSurfaceVariant)
            .lineLimit(2)
    }
}

struct LSQuestionCountButton: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let count: Int
    @Binding var selectedCount: Int
    private var isCompact: Bool { horizontalSizeClass == .compact }

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.84)) {
                selectedCount = count
            }
        } label: {
            Text("\(count) Qs")
                .font(isCompact ? .subheadline.weight(.semibold) : .title3.weight(.medium))
                .foregroundStyle(selectedCount == count ? Color.white : ScholarTheme.onSurfaceVariant)
                .frame(maxWidth: .infinity, minHeight: isCompact ? 48 : 62)
                .background(selectedCount == count ? ScholarTheme.primary : ScholarTheme.inputSurface)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(count) questions")
        .accessibilityValue(selectedCount == count ? "Selected" : "")
    }
}

struct LSAgeSelector: View {
    @Binding var age: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Age", systemImage: "birthday.cake")
                .font(.caption.weight(.semibold))
                .foregroundStyle(ScholarTheme.onSurfaceVariant)
                .textCase(.uppercase)
                .tracking(1.4)

            HStack(spacing: 12) {
                ageButton(icon: "minus") {
                    age = max(3, age - 1)
                }

                VStack(spacing: 1) {
                    Text("\(age)")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(ScholarTheme.onSurface)
                        .monospacedDigit()
                    Text("years")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(ScholarTheme.onSurfaceVariant)
                }
                .frame(maxWidth: .infinity, minHeight: 48)

                ageButton(icon: "plus") {
                    age = min(12, age + 1)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 118, alignment: .leading)
        .background(ScholarTheme.inputSurface)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(ScholarTheme.hairline(), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Age")
        .accessibilityValue("\(age) years")
    }

    private func ageButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.headline.weight(.bold))
                .foregroundStyle(ScholarTheme.primary)
                .frame(width: 38, height: 38)
                .background(ScholarTheme.cardBackground)
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .disabled(icon == "minus" ? age <= 3 : age >= 12)
        .opacity((icon == "minus" ? age <= 3 : age >= 12) ? 0.42 : 1)
    }
}

struct LSGradeSelector: View {
    @Binding var grade: String
    let grades: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Grade", systemImage: "graduationcap")
                .font(.caption.weight(.semibold))
                .foregroundStyle(ScholarTheme.onSurfaceVariant)
                .textCase(.uppercase)
                .tracking(1.4)

            Menu {
                ForEach(grades, id: \.self) { gradeOption in
                    Button {
                        grade = gradeOption
                    } label: {
                        Label(gradeOption, systemImage: grade == gradeOption ? "checkmark" : "")
                    }
                }
            } label: {
                HStack(spacing: 12) {
                    Text(grade)
                        .font(.title3.weight(.bold))
                        .foregroundStyle(ScholarTheme.onSurface)
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)
                    Spacer(minLength: 8)
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(ScholarTheme.primary)
                        .frame(width: 34, height: 34)
                        .background(ScholarTheme.cardBackground)
                        .clipShape(Circle())
                }
                .frame(minHeight: 48)
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 118, alignment: .leading)
        .background(ScholarTheme.inputSurface)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(ScholarTheme.hairline(), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Grade")
        .accessibilityValue(grade)
    }
}

struct LSInitialAvatar: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    let profile: ChildProfile?
    private var isCompact: Bool { horizontalSizeClass == .compact }

    var body: some View {
        Text(initial)
            .font(.system(size: isCompact ? 22 : 30, weight: .semibold))
            .foregroundStyle(ScholarTheme.primary)
            .frame(width: isCompact ? 50 : 66, height: isCompact ? 50 : 66)
            .background(ScholarTheme.secondaryContainer)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(ScholarTheme.primary, lineWidth: 2)
            }
    }

    private var initial: String {
        guard let first = profile?.name.first else { return "L" }
        return String(first).uppercased()
    }
}

struct LSPrimaryButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.headline.bold())
                .frame(maxWidth: .infinity, minHeight: 54)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
        .background(ScholarTheme.darkOlive)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: ScholarTheme.primary.opacity(0.18), radius: 12, y: 7)
    }
}

struct LSSecondaryButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .font(.headline.bold())
                .frame(maxWidth: .infinity, minHeight: 52)
        }
        .buttonStyle(.plain)
        .foregroundStyle(ScholarTheme.primary)
        .background(ScholarTheme.primary.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct LSBottomTabBar: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Binding var selectedMode: AppMode
    private var isCompact: Bool { horizontalSizeClass == .compact }

    var body: some View {
        HStack(spacing: isCompact ? 2 : 6) {
            ForEach(AppMode.allCases) { mode in
                Button {
                    withAnimation(.spring(response: 0.34, dampingFraction: 0.82)) {
                        selectedMode = mode
                    }
                } label: {
                    VStack(spacing: 5) {
                        Image(systemName: mode.icon)
                            .font(isCompact ? .subheadline.weight(.bold) : .headline.weight(.bold))
                        Text(mode.rawValue)
                            .font(isCompact ? .caption2.weight(.semibold) : .caption2.bold())
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                        Capsule()
                            .fill(selectedMode == mode ? ScholarTheme.primary : Color.clear)
                            .frame(width: 18, height: 3)
                    }
                    .frame(maxWidth: .infinity, minHeight: isCompact ? 54 : 62)
                    .foregroundStyle(selectedMode == mode ? ScholarTheme.primary : ScholarTheme.secondaryText)
                    .contentShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .buttonStyle(.plain)
                .accessibilityLabel(mode.rawValue)
                .accessibilityValue(selectedMode == mode ? "Selected" : "")
            }
        }
        .padding(.horizontal, isCompact ? 6 : 10)
        .padding(.vertical, isCompact ? 6 : 8)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: isCompact ? 24 : 30, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: isCompact ? 24 : 30, style: .continuous)
                .stroke(ScholarTheme.hairline(1.4), lineWidth: 1)
        }
        .shadow(color: ScholarTheme.shadow, radius: 16, y: 8)
        .frame(maxWidth: 760)
    }
}

struct LSEmptyState: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let icon: String
    let title: String
    let message: String
    private var isCompact: Bool { horizontalSizeClass == .compact }

    var body: some View {
        VStack(spacing: isCompact ? 10 : 14) {
            Image(systemName: icon)
                .font(.system(size: isCompact ? 30 : 42, weight: .semibold))
                .foregroundStyle(ScholarTheme.primary)
                .frame(width: isCompact ? 58 : 76, height: isCompact ? 58 : 76)
                .background(ScholarTheme.primary.opacity(0.08))
                .clipShape(Circle())
            Text(title)
                .font(isCompact ? .headline.bold() : .title2.bold())
                .multilineTextAlignment(.center)
            Text(message)
                .font(isCompact ? .subheadline : .headline)
                .foregroundStyle(ScholarTheme.secondaryText)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(isCompact ? 18 : 26)
        .background(ScholarTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

struct LSSkeletonLoadingCard: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let title: String
    let message: String
    @State private var pulse = false
    private var isCompact: Bool { horizontalSizeClass == .compact }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label(title, systemImage: "sparkles")
                .font(isCompact ? .headline.bold() : .title3.bold())
                .foregroundStyle(ScholarTheme.primary)
            Text(message)
                .font(isCompact ? .subheadline : .headline)
                .foregroundStyle(ScholarTheme.secondaryText)
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(ScholarTheme.primarySoft.opacity(pulse ? 0.46 : 0.18))
                .frame(height: 12)
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(ScholarTheme.primary.opacity(pulse ? 0.16 : 0.06))
                .frame(width: 180, height: 12)
        }
        .padding(isCompact ? 14 : 18)
        .background(ScholarTheme.controlSurface)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .onAppear { pulse = true }
        .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: pulse)
        .accessibilityElement(children: .combine)
    }
}

struct LSChildCarousel: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let profiles: [ChildProfile]
    @Binding var selectedChildID: UUID?
    let results: [ExamResult]
    var includesAddLearner = false
    var onAddLearner: (() -> Void)?
    private var isCompact: Bool { horizontalSizeClass == .compact }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: isCompact ? 20 : 34) {
                ForEach(profiles) { profile in
                    LSLearnerBubble(
                        profile: profile,
                        isSelected: selectedChildID == profile.profileID
                    ) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.86)) {
                            selectedChildID = profile.profileID
                        }
                    }
                }
                if includesAddLearner {
                    Button {
                        onAddLearner?()
                    } label: {
                        VStack(spacing: 12) {
                            Image(systemName: "plus")
                                .font((isCompact ? Font.headline.weight(.medium) : Font.title2.weight(.medium)))
                                .foregroundStyle(ScholarTheme.primary)
                                .frame(width: isCompact ? 52 : 64, height: isCompact ? 52 : 64)
                                .background(ScholarTheme.controlSurface)
                                .clipShape(Circle())
                                .overlay {
                                    Circle()
                                        .stroke(ScholarTheme.outlineVariant, style: StrokeStyle(lineWidth: 1.2, dash: [4, 4]))
                                }
                            Text("Add Learner")
                                .font(isCompact ? .caption.weight(.semibold) : .headline)
                                .foregroundStyle(ScholarTheme.onSurfaceVariant)
                        }
                        .frame(width: isCompact ? 88 : 112)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Add learner")
                }
            }
            .padding(.vertical, 2)
        }
    }
}

struct LSLearnerBubble: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let profile: ChildProfile
    let isSelected: Bool
    let action: () -> Void
    private var isCompact: Bool { horizontalSizeClass == .compact }

    var body: some View {
        Button(action: action) {
            VStack(spacing: isCompact ? 8 : 12) {
                ChildProfilePhotoBadge(avatarValue: profile.avatar, isSelected: isSelected, size: isCompact ? 54 : 68)
                VStack(spacing: 4) {
                    Text(profile.name)
                        .font(isCompact ? .subheadline.weight(.semibold) : .headline)
                        .foregroundStyle(ScholarTheme.onSurface)
                        .lineLimit(1)
                    Text("\(profile.grade) • Age \(profile.age)")
                        .font(isCompact ? .caption2.weight(.medium) : .caption.weight(.medium))
                        .foregroundStyle(ScholarTheme.onSurfaceVariant)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            }
            .frame(width: isCompact ? 94 : 120)
            .opacity(isSelected ? 1 : 0.58)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(profile.name), \(profile.grade), age \(profile.age)")
        .accessibilityValue(isSelected ? "Selected" : "")
    }
}

struct LSChildProfileCard: View {
    let profile: ChildProfile
    let averageScore: Int
    let isSelected: Bool
    var showsAverageScore: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    ChildProfilePhotoBadge(avatarValue: profile.avatar, isSelected: isSelected)
                    Spacer()
                    if showsAverageScore {
                        Text(averageScore == 0 ? "New" : "\(averageScore)%")
                            .font(.headline.bold())
                            .foregroundStyle(ScholarTheme.primary)
                    }
                }
                Text(profile.name)
                    .font(.title3.bold())
                    .foregroundStyle(ScholarTheme.primaryText)
                    .lineLimit(1)
                Text("\(profile.grade) • Age \(profile.age)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(ScholarTheme.secondaryText)
            }
            .frame(maxWidth: .infinity, minHeight: 150, alignment: .leading)
            .padding(18)
            .background(isSelected ? ScholarTheme.primarySoft.opacity(0.35) : ScholarTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .stroke(isSelected ? ScholarTheme.primary.opacity(0.72) : ScholarTheme.hairline(), lineWidth: isSelected ? 1.5 : 1)
            }
            .shadow(color: ScholarTheme.shadow.opacity(isSelected ? 1.2 : 0.65), radius: isSelected ? 16 : 10, y: isSelected ? 8 : 5)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(profile.name), \(profile.grade), age \(profile.age)")
        .accessibilityValue(isSelected ? "Selected" : "")
    }
}

struct AIRecommendationCard: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let results: [ExamResult]
    let onViewInsights: () -> Void
    private var isCompact: Bool { horizontalSizeClass == .compact }

    var body: some View {
        LSCard {
            ZStack(alignment: .trailing) {
                Image(systemName: "sparkles")
                    .font(.system(size: isCompact ? 68 : 110, weight: .light))
                    .foregroundStyle(ScholarTheme.surfaceVariant.opacity(0.75))
                    .padding(.trailing, 12)
                VStack(alignment: .leading, spacing: isCompact ? 14 : 20) {
                    Label("AI Insight", systemImage: "sparkles")
                        .font(.caption.weight(.semibold))
                        .textCase(.uppercase)
                        .tracking(2)
                        .foregroundStyle(ScholarTheme.primary)
                    Text(recommendation)
                        .font(isCompact ? .body : .title3)
                        .lineSpacing(4)
                        .foregroundStyle(ScholarTheme.onSurface)
                        .fixedSize(horizontal: false, vertical: true)
                    Button(action: onViewInsights) {
                        Label("View Full Insights", systemImage: "arrow.right")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(ScholarTheme.primary)
                    }
                    .buttonStyle(.plain)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var recommendation: String {
        guard !results.isEmpty else { return "Start with a short, easy practice session to create a first progress snapshot." }
        if averageScore(results) >= 80 { return "Subtraction is improving. Continue with easy practice before moving to medium difficulty." }
        return "A short easy session can help rebuild confidence and strengthen the basics."
    }
}

struct PremiumPracticeRow: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let exam: Exam
    let onStart: () -> Void
    private var isCompact: Bool { horizontalSizeClass == .compact }

    var body: some View {
        VStack(alignment: .leading, spacing: isCompact ? 18 : 24) {
            HStack(alignment: .top) {
                Image(systemName: subjectIcon)
                    .font(isCompact ? .headline.weight(.semibold) : .title2.weight(.semibold))
                    .foregroundStyle(ScholarTheme.primary)
                    .frame(width: isCompact ? 44 : 52, height: isCompact ? 44 : 52)
                    .background(ScholarTheme.secondaryContainer.opacity(0.72))
                    .clipShape(Circle())
                Spacer()
                Text(assignedLabel)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(ScholarTheme.onSurfaceVariant)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(ScholarTheme.controlSurface)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            VStack(alignment: .leading, spacing: 8) {
                Text(exam.subject)
                    .font(isCompact ? .headline.bold() : .title2.bold())
                    .foregroundStyle(ScholarTheme.onSurface)
                Text("\(exam.difficulty) • \(exam.questions.count) Questions")
                    .font(isCompact ? .subheadline.weight(.medium) : .headline)
                    .foregroundStyle(ScholarTheme.onSurfaceVariant)
            }
            Button(action: onStart) {
                Label("Start Practice", systemImage: "arrow.right")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(ScholarTheme.onSurface)
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .background(ScholarTheme.surfaceContainerHigh)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            .buttonStyle(.plain)
        }
        .padding(isCompact ? 18 : 24)
        .background(ScholarTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(ScholarTheme.hairline(), lineWidth: 1)
        }
        .shadow(color: ScholarTheme.shadow, radius: 12, y: 4)
        .accessibilityElement(children: .combine)
    }

    private var assignedLabel: String {
        Calendar.current.isDateInToday(exam.createdAt) ? "Assigned Today" : "Assigned \(DateFormatter.localizedString(from: exam.createdAt, dateStyle: .medium, timeStyle: .none))"
    }

    private var subjectIcon: String {
        switch exam.subject {
        case Subject.maths.rawValue: "plus.forwardslash.minus"
        case Subject.english.rawValue: "book"
        case Subject.hindi.rawValue: "character.book.closed"
        case Subject.evs.rawValue: "leaf"
        default: "doc.text"
        }
    }
}

struct PremiumResultRow: View {
    let result: ExamResult

    var body: some View {
        HStack(spacing: 14) {
            VStack(spacing: 6) {
                Circle()
                    .fill(result.percentage >= 70 ? ScholarTheme.success : ScholarTheme.warning)
                    .frame(width: 10, height: 10)
                Rectangle()
                    .fill(ScholarTheme.primary.opacity(0.12))
                    .frame(width: 2, height: 44)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("\(result.subject) Practice")
                    .font(.headline)
                Text(DateFormatter.localizedString(from: result.completedAt, dateStyle: .medium, timeStyle: .none))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(ScholarTheme.secondaryText)
                Text("\(result.percentage)% • \(result.correctAnswers) of \(result.totalQuestions) correct")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(ScholarTheme.secondaryText)
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .accessibilityElement(children: .combine)
    }
}

struct SubjectProgressList: View {
    let results: [ExamResult]

    var body: some View {
        let summaries = subjectSummaries(results)
        if summaries.isEmpty {
            LSEmptyState(icon: "books.vertical", title: "No subject progress yet", message: "Subjects will appear after completed practice.")
        } else {
            VStack(spacing: 22) {
                ForEach(summaries, id: \.subject) { summary in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(summary.subject).font(.headline)
                            Spacer()
                            Text("\(summary.average)%")
                                .font(.headline)
                                .foregroundStyle(ScholarTheme.onSurfaceVariant)
                        }
                        ProgressView(value: Double(summary.average), total: 100)
                            .tint(ScholarTheme.primary)
                    }
                }
            }
        }
    }
}

struct PerformanceTrendView: View {
    let results: [ExamResult]
    private let requiredSessions = 5

    private var recentResults: [ExamResult] {
        Array(results.prefix(8).reversed())
    }

    var body: some View {
        if results.count < requiredSessions {
            LSEmptyState(
                icon: "chart.line.uptrend.xyaxis",
                title: "Keep practicing to unlock trend analysis.",
                message: "You need 5 completed sessions."
            )
        } else {
            GeometryReader { proxy in
                let points = trendPoints(in: proxy.size)
                ZStack(alignment: .bottomLeading) {
                    Path { path in
                        guard let first = points.first else { return }
                        path.move(to: CGPoint(x: first.x, y: proxy.size.height))
                        for point in points {
                            path.addLine(to: point)
                        }
                        if let last = points.last {
                            path.addLine(to: CGPoint(x: last.x, y: proxy.size.height))
                        }
                        path.closeSubpath()
                    }
                    .fill(
                        LinearGradient(
                            colors: [ScholarTheme.onSurface.opacity(0.28), ScholarTheme.onSurface.opacity(0.02)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                    Path { path in
                        guard let first = points.first else { return }
                        path.move(to: first)
                        for point in points.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                    .stroke(ScholarTheme.outline.opacity(0.35), style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))

                    ForEach(Array(points.enumerated()), id: \.offset) { _, point in
                        Circle()
                            .fill(ScholarTheme.onSurface)
                            .frame(width: 8, height: 8)
                            .position(point)
                    }
                }
                .overlay(alignment: .bottomLeading) {
                    HStack {
                        Text("First")
                        Spacer()
                        Text("Latest")
                    }
                    .font(.caption.weight(.medium))
                    .foregroundStyle(ScholarTheme.onSurfaceVariant)
                    .padding(.horizontal, 4)
                }
            }
            .frame(height: 280)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Recent performance trend")
        }
    }

    private func trendPoints(in size: CGSize) -> [CGPoint] {
        guard recentResults.count > 1 else {
            let y = size.height * (1 - CGFloat(recentResults.first?.percentage ?? 0) / 100)
            return [CGPoint(x: size.width * 0.5, y: y)]
        }
        return recentResults.enumerated().map { index, result in
            let x = CGFloat(index) / CGFloat(max(recentResults.count - 1, 1)) * size.width
            let y = max(16, min(size.height - 28, size.height * (1 - CGFloat(result.percentage) / 100)))
            return CGPoint(x: x, y: y)
        }
    }
}

struct FocusAreasCard: View {
    let results: [ExamResult]

    var body: some View {
        LSCard {
            VStack(alignment: .leading, spacing: 24) {
                Text("Focus Areas")
                    .font(.title.bold())

                if results.isEmpty {
                    LSEmptyState(icon: "target", title: "No focus areas yet", message: "Focus areas will appear after completed practice.")
                } else {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 230), spacing: 16)], alignment: .leading, spacing: 16) {
                        FocusAreaColumn(
                            title: "Strong Areas",
                            icon: "star",
                            tint: ScholarTheme.primary,
                            items: strongFocusItems,
                            emptyTitle: "Strengths are emerging"
                        )
                        FocusAreaColumn(
                            title: "Needs Practice",
                            icon: "target",
                            tint: ScholarTheme.tertiary,
                            items: needsPracticeItems,
                            emptyTitle: "No missed topics yet"
                        )
                    }
                }
            }
        }
    }

    private var strongFocusItems: [FocusAreaItem] {
        let topicItems = topicFocusItems(matching: \.isCorrect, tint: ScholarTheme.primary, fallbackIcon: "checkmark.seal")
        if !topicItems.isEmpty { return topicItems }

        let subjectItems = subjectSummaries(results)
            .filter { $0.average >= 70 }
            .sorted { $0.average > $1.average }
            .prefix(2)
            .map { FocusAreaItem(title: "\($0.subject) Confidence", icon: "books.vertical", tint: ScholarTheme.primary) }
        if !subjectItems.isEmpty { return Array(subjectItems) }

        guard let best = subjectSummaries(results).max(by: { $0.average < $1.average }) else { return [] }
        return [FocusAreaItem(title: "\(best.subject) Practice Started", icon: "sparkles", tint: ScholarTheme.primary)]
    }

    private var needsPracticeItems: [FocusAreaItem] {
        let topicItems = topicFocusItems(matching: { !$0.isCorrect }, tint: ScholarTheme.tertiary, fallbackIcon: "pencil")
        if !topicItems.isEmpty { return topicItems }

        return subjectSummaries(results)
            .filter { $0.average < 75 }
            .sorted { $0.average < $1.average }
            .prefix(2)
            .map { FocusAreaItem(title: "\($0.subject) Review", icon: "pencil", tint: ScholarTheme.tertiary) }
    }

    private func topicFocusItems(matching predicate: (AnswerEvaluation) -> Bool, tint: Color, fallbackIcon: String) -> [FocusAreaItem] {
        var counts: [String: Int] = [:]
        for evaluation in results.flatMap(\.evaluations) where predicate(evaluation) {
            let topic = normalizedFocusTopic(evaluation.question.topic)
            guard !topic.isEmpty else { continue }
            counts[topic, default: 0] += 1
        }

        return counts
            .sorted {
                if $0.value == $1.value { return $0.key < $1.key }
                return $0.value > $1.value
            }
            .prefix(2)
            .map { FocusAreaItem(title: $0.key, icon: fallbackIcon, tint: tint) }
    }

    private func normalizedFocusTopic(_ topic: String) -> String {
        let trimmed = topic.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, trimmed.caseInsensitiveCompare("General") != .orderedSame else { return "" }
        return trimmed
    }
}

struct FocusAreaItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let tint: Color
}

struct FocusAreaColumn: View {
    let title: String
    let icon: String
    let tint: Color
    let items: [FocusAreaItem]
    let emptyTitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(.caption.weight(.semibold))
                .textCase(.uppercase)
                .foregroundStyle(tint)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            if items.isEmpty {
                FocusPill(icon: "checkmark.circle", title: emptyTitle, tint: tint)
                    .opacity(0.72)
            } else {
                ForEach(items) { item in
                    FocusPill(icon: item.icon, title: item.title, tint: item.tint)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

struct FocusPill: View {
    let icon: String
    let title: String
    var tint: Color = ScholarTheme.primary

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: icon)
                .font(.headline.weight(.semibold))
                .foregroundStyle(tint)
                .frame(width: 24)
            Text(title)
                .font(.headline.weight(.semibold))
                .foregroundStyle(ScholarTheme.onSurface)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 72, alignment: .leading)
        .background(tint.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(ScholarTheme.outlineVariant.opacity(0.55), lineWidth: 1)
        }
    }
}

struct ProgressPracticeHistoryView: View {
    @Environment(\.dismiss) private var dismiss
    let results: [ExamResult]

    var body: some View {
        PremiumScrollView {
            VStack(alignment: .leading, spacing: 28) {
                HStack(alignment: .top) {
                    PremiumHeader(
                        eyebrow: "Progress",
                        title: "Practice History",
                        subtitle: "\(results.count) completed \(results.count == 1 ? "session" : "sessions")"
                    )
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(ScholarTheme.onSurface)
                            .frame(width: 44, height: 44)
                            .background(ScholarTheme.controlSurface)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Close practice history")
                }

                if results.isEmpty {
                    LSEmptyState(icon: "clock.badge.questionmark", title: "No completed practice", message: "Completed sessions will appear here.")
                } else {
                    LSCard {
                        VStack(spacing: 0) {
                            ForEach(results) { result in
                                NavigationLink { ResultView(result: result) } label: {
                                    LSRecentExamLine(result: result)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

struct LSRecentExamLine: View {
    let result: ExamResult

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(result.subject) Practice")
                    .font(.headline)
                    .foregroundStyle(ScholarTheme.onSurface)
                Text(DateFormatter.localizedString(from: result.completedAt, dateStyle: .medium, timeStyle: .none))
                    .font(.caption)
                    .foregroundStyle(ScholarTheme.onSurfaceVariant)
            }
            Spacer()
            Text("\(result.correctAnswers)/\(result.totalQuestions)")
                .font(.headline.weight(.semibold))
                .foregroundStyle(ScholarTheme.primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(ScholarTheme.controlSurface)
                .clipShape(Capsule())
        }
        .padding(.vertical, 14)
        .overlay(alignment: .bottom) {
            Divider().opacity(0.45)
        }
    }
}

struct StrengthPracticeGrid: View {
    let results: [ExamResult]

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 250), spacing: 14)], spacing: 14) {
            LSCard {
                VStack(alignment: .leading, spacing: 12) {
                    LSSectionHeader(title: "Strong Areas", subtitle: "Celebrate what is working", icon: "star.fill")
                    Text(strongArea)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }
            LSCard {
                VStack(alignment: .leading, spacing: 12) {
                    LSSectionHeader(title: "Needs Practice", subtitle: "A friendly focus area", icon: "target")
                    Text(needsPractice)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var strongArea: String {
        guard let best = subjectSummaries(results).max(by: { $0.average < $1.average }) else { return "Complete practice to discover strong areas." }
        return "\(best.subject) is currently the strongest area at \(best.average)%."
    }

    private var needsPractice: String {
        guard let weakest = subjectSummaries(results).min(by: { $0.average < $1.average }) else { return "Complete practice to identify helpful focus areas." }
        return "\(weakest.subject) could use a little extra attention this week."
    }
}

struct InsightEditorialCard: View {
    let title: String
    let icon: String
    let tint: Color
    let items: [(String, String)]

    var body: some View {
        LSCard {
            VStack(alignment: .leading, spacing: 24) {
                HStack(spacing: 14) {
                    Image(systemName: icon)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(tint)
                        .frame(width: 44, height: 44)
                        .background(tint.opacity(0.18))
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    Text(title)
                        .font(.title.bold())
                }
                VStack(alignment: .leading, spacing: 18) {
                    ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                        HStack(alignment: .top, spacing: 14) {
                            Circle()
                                .stroke(tint, lineWidth: 1.4)
                                .frame(width: 10, height: 10)
                                .padding(.top, 7)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.0)
                                    .font(.headline)
                                Text(item.1)
                                    .font(.body)
                                    .foregroundStyle(ScholarTheme.onSurfaceVariant)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct LSPacingLevelView: View {
    let score: Int

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Easy")
                Spacer()
                Text("Medium")
                    .foregroundStyle(ScholarTheme.primary)
                Spacer()
                Text("Hard")
            }
            .font(.caption.weight(.medium))
            .foregroundStyle(ScholarTheme.onSurfaceVariant)

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(ScholarTheme.surfaceVariant)
                    Capsule()
                        .fill(ScholarTheme.primary)
                        .frame(width: max(44, proxy.size.width * CGFloat(min(max(score, 35), 90)) / 100))
                }
            }
            .frame(height: 8)
        }
    }
}

struct LSDarkPlanCard: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let onUpgrade: () -> Void
    private var isCompact: Bool { horizontalSizeClass == .compact }

    var body: some View {
        VStack(alignment: .leading, spacing: isCompact ? 24 : 34) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Current Plan")
                        .font(.caption.weight(.semibold))
                        .textCase(.uppercase)
                        .tracking(2)
                        .foregroundStyle(.white.opacity(0.72))
                    Text("Little Scholar Plus")
                        .font(.system(size: isCompact ? 26 : 34, weight: .bold))
                        .foregroundStyle(ScholarTheme.cardBackground)
                }
                Spacer()
                Image(systemName: "star.circle.fill")
                    .font(.system(size: isCompact ? 30 : 40))
                    .foregroundStyle(ScholarTheme.primarySoft)
            }

            LazyVGrid(columns: [GridItem(.adaptive(minimum: isCompact ? 135 : 170), spacing: 12)], spacing: isCompact ? 12 : 18) {
                PlanBenefit(title: "Up to 5 Children")
                PlanBenefit(title: "Unlimited Practice")
                PlanBenefit(title: "Daily AI Insights")
                PlanBenefit(title: "Advanced Reports")
            }

            Button(action: onUpgrade) {
                Label("Manage Subscription", systemImage: "arrow.right")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(ScholarTheme.primary)
                    .padding(.horizontal, 26)
                    .frame(minHeight: isCompact ? 48 : 54)
                    .background(ScholarTheme.cardBackground)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
        .padding(isCompact ? 22 : 28)
        .background(
            LinearGradient(
                colors: [ScholarTheme.darkOlive, ScholarTheme.primaryContainer.opacity(0.88)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: ScholarTheme.primary.opacity(0.16), radius: 20, y: 12)
    }
}

struct PlanBenefit: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    let title: String
    private var isCompact: Bool { horizontalSizeClass == .compact }

    var body: some View {
        Label(title, systemImage: "checkmark.circle")
            .font(isCompact ? .subheadline.weight(.semibold) : .headline)
            .foregroundStyle(Color.white.opacity(0.92))
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct LSProfileMenuRow: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let icon: String
    let title: String
    let subtitle: String
    let tint: Color
    var isDestructive = false
    let action: () -> Void
    private var isCompact: Bool { horizontalSizeClass == .compact }

    var body: some View {
        Button(action: action) {
            HStack(spacing: isCompact ? 14 : 18) {
                Image(systemName: icon)
                    .font(isCompact ? .headline.weight(.semibold) : .title3.weight(.semibold))
                    .foregroundStyle(tint)
                    .frame(width: isCompact ? 42 : 50, height: isCompact ? 42 : 50)
                    .background(tint.opacity(0.12))
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(isCompact ? .headline.bold() : .title3.bold())
                        .foregroundStyle(isDestructive ? ScholarTheme.error : ScholarTheme.onSurface)
                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(isCompact ? .caption.weight(.medium) : .subheadline)
                            .foregroundStyle(ScholarTheme.onSurfaceVariant)
                    }
                }
                Spacer()
                if !isDestructive {
                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .foregroundStyle(ScholarTheme.outline)
                }
            }
            .padding(isCompact ? 18 : 24)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct LSProfileAvatarStrip: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    let profiles: [ChildProfile]
    @Binding var selectedChildID: UUID?
    let results: [ExamResult]
    let canAdd: Bool
    let onEdit: (ChildProfile) -> Void
    let onDelete: (ChildProfile) -> Void
    let onAdd: () -> Void
    private var isCompact: Bool { horizontalSizeClass == .compact }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: isCompact ? 18 : 28) {
                ForEach(profiles) { profile in
                    VStack(spacing: isCompact ? 8 : 10) {
                        Button {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.86)) {
                                selectedChildID = profile.profileID
                            }
                        } label: {
                            ChildProfilePhotoBadge(avatarValue: profile.avatar, isSelected: selectedChildID == profile.profileID, size: isCompact ? 58 : 72)
                        }
                        .buttonStyle(.plain)
                        Text(profile.name)
                            .font(isCompact ? .subheadline.weight(.semibold) : .headline)
                            .foregroundStyle(selectedChildID == profile.profileID ? ScholarTheme.primary : ScholarTheme.onSurface)
                            .lineLimit(1)
                            .frame(width: isCompact ? 72 : 86)
                    }
                    .contextMenu {
                        Button("Edit") { onEdit(profile) }
                        Button("Delete", role: .destructive) { onDelete(profile) }
                    }
                }
                if canAdd {
                    Button(action: onAdd) {
                        VStack(spacing: isCompact ? 8 : 10) {
                            Image(systemName: "plus")
                                .font(isCompact ? .title3.weight(.medium) : .title.weight(.medium))
                                .foregroundStyle(ScholarTheme.primary)
                                .frame(width: isCompact ? 58 : 72, height: isCompact ? 58 : 72)
                                .background(ScholarTheme.controlSurface)
                                .clipShape(Circle())
                                .overlay {
                                    Circle().stroke(ScholarTheme.outlineVariant, style: StrokeStyle(lineWidth: 1.4, dash: [5, 5]))
                                }
                            Text("Add New")
                                .font(isCompact ? .subheadline.weight(.semibold) : .headline)
                                .foregroundStyle(ScholarTheme.onSurface)
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Add new child profile")
                }
            }
            .padding(.vertical, 2)
        }
    }
}

struct InsightReport: View {
    let results: [ExamResult]

    var body: some View {
        VStack(spacing: 16) {
            LSCard { insightBlock(title: "Summary", icon: "lightbulb.fill", text: summary) }
            LSCard { insightBlock(title: "Strengths", icon: "star.circle.fill", text: strength) }
            LSCard { insightBlock(title: "Needs Practice", icon: "target", text: focus) }
            LSCard { insightBlock(title: "Recommendations", icon: "checklist", text: recommendation) }
            LSCard { insightBlock(title: "Suggested Difficulty", icon: "slider.horizontal.3", text: suggestedDifficulty) }
        }
    }

    private func insightBlock(title: String, icon: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            LSSectionHeader(title: title, subtitle: "Generated from completed practice", icon: icon)
            Text(text)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
            Text("Updated \(DateFormatter.localizedString(from: .now, dateStyle: .medium, timeStyle: .short))")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
    }

    private var summary: String {
        "Average score is \(averageScore(results))% across \(results.count) completed sessions."
    }

    private var strength: String {
        guard let best = subjectSummaries(results).max(by: { $0.average < $1.average }) else { return "Strengths will appear after more practice." }
        return "\(best.subject) is showing the clearest confidence."
    }

    private var focus: String {
        guard let weakest = subjectSummaries(results).min(by: { $0.average < $1.average }) else { return "Focus areas will appear after more practice." }
        return "Spend a little extra time on \(weakest.subject)."
    }

    private var recommendation: String {
        averageScore(results) >= 80 ? "Try a medium or hard practice session next." : "Use an easy session to reinforce core ideas."
    }

    private var suggestedDifficulty: String {
        averageScore(results) >= 85 ? "Hard" : averageScore(results) >= 65 ? "Medium" : "Easy"
    }
}

struct PremiumComingSoonView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            PremiumScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    PremiumHeader(eyebrow: "Premium", title: "Premium coming soon", subtitle: "A richer learning toolkit is on the way.")
                    LSHeroCard {
                        VStack(alignment: .leading, spacing: 12) {
                            PremiumBenefit(icon: "person.2.fill", title: "Up to 5 children")
                            PremiumBenefit(icon: "infinity.circle.fill", title: "Unlimited question generation")
                            PremiumBenefit(icon: "sparkles", title: "Daily learning insight per child")
                            PremiumBenefit(icon: "chart.bar.doc.horizontal.fill", title: "Advanced learning reports")
                            PremiumBenefit(icon: "doc.richtext.fill", title: "Future PDF reports")
                        }
                    }
                }
            }
            .navigationTitle("Premium")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { dismiss() } } }
        }
    }
}

struct AppSettingsComingSoonView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            PremiumScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    PremiumHeader(
                        eyebrow: "Settings",
                        title: "App Settings",
                        subtitle: "These controls are planned for a future Little Scholar update."
                    )

                    LSCard {
                        VStack(spacing: 0) {
                            DisabledSettingsRow(
                                icon: "bell.badge",
                                title: "Notifications",
                                subtitle: "Practice reminders and progress alerts"
                            )
                            Divider().padding(.leading, 68)
                            DisabledSettingsRow(
                                icon: "speaker.wave.2",
                                title: "Audio",
                                subtitle: "Sound effects and spoken guidance"
                            )
                            Divider().padding(.leading, 68)
                            DisabledSettingsRow(
                                icon: "circle.lefthalf.filled",
                                title: "Display",
                                subtitle: "Theme, text size, and visual preferences"
                            )
                        }
                    }
                }
            }
            .navigationTitle("App Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct DisabledSettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 18) {
            Image(systemName: icon)
                .font(.title3.weight(.semibold))
                .foregroundStyle(ScholarTheme.onSurfaceVariant)
                .frame(width: 50, height: 50)
                .background(ScholarTheme.controlSurface)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.title3.bold())
                    .foregroundStyle(ScholarTheme.onSurface)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(ScholarTheme.onSurfaceVariant)
            }

            Spacer()

            Text("Coming Soon")
                .font(.caption.weight(.semibold))
                .foregroundStyle(ScholarTheme.onSurfaceVariant)
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(ScholarTheme.controlSurface)
                .clipShape(Capsule())
        }
        .padding(.vertical, 16)
        .opacity(0.58)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), coming soon")
    }
}

struct PremiumBenefit: View {
    let icon: String
    let title: String

    var body: some View {
        Label(title, systemImage: icon)
            .font(.headline)
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(ScholarTheme.cardBackground.opacity(0.72))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct SubjectSummary {
    let subject: String
    let average: Int
}

private func selectedChild(in profiles: [ChildProfile], selectedChildID: UUID?) -> ChildProfile? {
    if let selectedChildID, let profile = profiles.first(where: { $0.profileID == selectedChildID }) {
        return profile
    }
    return profiles.first
}

private func resultsForSelectedChild(_ results: [ExamResult], childID: UUID?) -> [ExamResult] {
    guard let childID else { return results }
    return results.filter { $0.childProfileID == childID }
}

private func averageScore(_ results: [ExamResult]) -> Int {
    guard !results.isEmpty else { return 0 }
    return Int((Double(results.map(\.percentage).reduce(0, +)) / Double(results.count)).rounded())
}

private func bestScore(_ results: [ExamResult]) -> Int {
    results.map(\.percentage).max() ?? 0
}

private func subjectSummaries(_ results: [ExamResult]) -> [SubjectSummary] {
    Subject.allCases.compactMap { subject in
        let subjectResults = results.filter { $0.subject == subject.rawValue }
        guard !subjectResults.isEmpty else { return nil }
        return SubjectSummary(subject: subject.rawValue, average: averageScore(subjectResults))
    }
}

private let childProfilePhotoPrefix = "photo:jpeg;base64,"

private func childProfileImage(from avatarValue: String) -> UIImage? {
    guard avatarValue.hasPrefix(childProfilePhotoPrefix) else { return nil }
    let base64 = String(avatarValue.dropFirst(childProfilePhotoPrefix.count))
    guard let data = Data(base64Encoded: base64) else { return nil }
    return UIImage(data: data)
}

private func childProfileAvatarValue(from imageData: Data) -> String? {
    guard let image = UIImage(data: imageData) else { return nil }
    let resized = image.resizedForChildProfile(maxDimension: 520)
    guard let jpegData = resized.jpegData(compressionQuality: 0.78) else { return nil }
    return childProfilePhotoPrefix + jpegData.base64EncodedString()
}

private extension UIImage {
    func resizedForChildProfile(maxDimension: CGFloat) -> UIImage {
        let longestSide = max(size.width, size.height)
        guard longestSide > maxDimension else { return self }

        let scale = maxDimension / longestSide
        let targetSize = CGSize(width: size.width * scale, height: size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}

private extension View {
    func adaptiveContentWidth(maxWidth: CGFloat = 1180) -> some View {
        frame(maxWidth: maxWidth)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [ChildProfile.self, Exam.self, ExamResult.self], inMemory: true)
}
