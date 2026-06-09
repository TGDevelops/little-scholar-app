//
//  ContentView.swift
//  little-scholar
//
//  Created by Tejesh on 26/05/26.
//

import Foundation
import SwiftUI

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

final class Exam: Identifiable {
    var id: UUID { examID }
    var examID: UUID = UUID()
    var parentID: String = ""
    var childProfileID: UUID = UUID()
    var childBackendID: String = ""
    var childName: String = ""
    var grade: String = "Grade 1"
    var subject: String = Subject.maths.rawValue
    var difficulty: String = Difficulty.easy.rawValue
    var createdAt: Date = Date.now
    var isCompleted: Bool = false
    var questions: [Question] = []

    init(parentID: String = "", childProfileID: UUID, childBackendID: String = "", childName: String, grade: String, subject: Subject, difficulty: Difficulty, questions: [Question]) {
        self.parentID = parentID
        self.childProfileID = childProfileID
        self.childBackendID = childBackendID
        self.childName = childName
        self.grade = grade
        self.subject = subject.rawValue
        self.difficulty = difficulty.rawValue
        self.questions = questions
    }
}

final class AIInsight: Identifiable {
    var id: String = UUID().uuidString
    var parentID: String = ""
    var childLocalId: UUID = UUID()
    var summary: String = ""
    var strengths: [String] = []
    var needsPractice: [String] = []
    var recommendations: [String] = []
    var suggestedDifficulty: String = "Easy"
    var tokensUsed: Int = 0
    var remainingTokens: Int = 0
    var generatedAt: Date = Date.now

    init(
        id: String = UUID().uuidString,
        parentID: String = "",
        childLocalId: UUID,
        summary: String,
        strengths: [String],
        needsPractice: [String],
        recommendations: [String],
        suggestedDifficulty: String,
        tokensUsed: Int,
        remainingTokens: Int,
        generatedAt: Date
    ) {
        self.id = id
        self.parentID = parentID
        self.childLocalId = childLocalId
        self.summary = summary
        self.strengths = strengths
        self.needsPractice = needsPractice
        self.recommendations = recommendations
        self.suggestedDifficulty = suggestedDifficulty
        self.tokensUsed = tokensUsed
        self.remainingTokens = remainingTokens
        self.generatedAt = generatedAt
    }
}

final class ExamResult: Identifiable {
    let id: UUID = UUID()
    var parentID: String = ""
    var childProfileID: UUID = UUID()
    var childBackendID: String = ""
    var childName: String = ""
    var grade: String = "Grade 1"
    var subject: String = Subject.maths.rawValue
    var difficulty: String = Difficulty.easy.rawValue
    var totalQuestions: Int = 0
    var correctAnswers: Int = 0
    var completedAt: Date = Date.now
    var evaluations: [AnswerEvaluation] = []

    init(parentID: String = "", childProfileID: UUID, childBackendID: String = "", childName: String, grade: String, subject: String, difficulty: String, totalQuestions: Int, correctAnswers: Int, evaluations: [AnswerEvaluation]) {
        self.parentID = parentID
        self.childProfileID = childProfileID
        self.childBackendID = childBackendID
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
        case 75..<90: "Great work! Review the missed questions and try one harder exam."
        case 50..<75: "Good effort. A little more practice will make these ideas clearer."
        default: "Nice try. Practice with an easy exam and ask a grown-up for help."
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
        marks: Int = 1
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
    }

    var sanitizedForPersistence: Question {
        let cleanOptions = options
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        let cleanAcceptableAnswers = acceptableAnswers
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        let cleanPrompt = prompt.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanCorrectAnswer = correctAnswer.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanExplanation = explanation.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanTopic = topic.trimmingCharacters(in: .whitespacesAndNewlines)

        return Question(
            id: id,
            backendID: backendID.trimmingCharacters(in: .whitespacesAndNewlines),
            type: type.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "mcq" : type,
            prompt: cleanPrompt.isEmpty ? "Untitled question" : cleanPrompt,
            options: cleanOptions,
            correctAnswer: cleanCorrectAnswer.isEmpty ? cleanAcceptableAnswers.first ?? "" : cleanCorrectAnswer,
            acceptableAnswers: cleanAcceptableAnswers,
            explanation: cleanExplanation.isEmpty ? "Review this concept and try again." : cleanExplanation,
            topic: cleanTopic.isEmpty ? "General" : cleanTopic,
            marks: max(1, marks)
        )
    }

    func accepts(_ answer: String) -> Bool {
        let normalizedAnswer = answer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let accepted = ([correctAnswer] + acceptableAnswers).map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
        return accepted.contains(normalizedAnswer)
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
        case .unicorn: .purple
        case .princess: .pink
        case .superhero: .red
        case .spaceHero: .blue
        case .shieldHero: .indigo
        }
    }

    var backendAvatarURLString: String? {
        "https://little-scholar.app/avatar/\(rawValue.lowercased().replacingOccurrences(of: " ", with: "-"))"
    }

    static func avatar(for rawValue: String) -> KidAvatar {
        KidAvatar(rawValue: rawValue) ?? .unicorn
    }

    static func avatar(forBackendURL avatarURL: String?) -> KidAvatar {
        guard let avatarURL else { return .unicorn }
        let normalizedValue = avatarURL
            .split(separator: "/")
            .last
            .map(String.init)?
            .replacingOccurrences(of: "-", with: " ")
            .lowercased() ?? ""
        return allCases.first { $0.rawValue.lowercased() == normalizedValue } ?? .unicorn
    }
}

enum AppMode: String, CaseIterable, Identifiable {
    case parent = "Parent"
    case exam = "Exam"
    case kid = "Kid"
    case performance = "Performance"
    case aiInsights = "AI Insights"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .parent: "person.2.fill"
        case .exam: "doc.text.fill"
        case .kid: "figure.child.circle.fill"
        case .performance: "chart.bar.doc.horizontal.fill"
        case .aiInsights: "sparkles"
        }
    }
}

struct AnswerEvaluationService {
    func evaluate(exam: Exam, answers: [UUID: String]) -> ExamResult {
        let evaluations = exam.questions.map { question in
            AnswerEvaluation(id: question.id, question: question, selectedAnswer: answers[question.id] ?? "No answer")
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

enum APIError: LocalizedError {
    case invalidBaseURL
    case invalidResponse
    case unauthorized
    case tokenLimitExceeded
    case decoding(String)
    case server(String)

    var errorDescription: String? {
        switch self {
        case .invalidBaseURL: "Set a valid backend base URL."
        case .invalidResponse: "The backend returned an invalid response."
        case .unauthorized: "Your session has expired. Please login again."
        case .tokenLimitExceeded: "AI insight limit reached. Please try again later or upgrade when subscriptions are available."
        case .decoding(let message): message
        case .server(let message): message
        }
    }
}

struct APIClient {
    let baseURLString: String
    var accessToken: String?

    private var baseURL: URL {
        get throws {
            guard let url = URL(string: baseURLString.trimmingCharacters(in: .whitespacesAndNewlines)), !baseURLString.isEmpty else {
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

    func generateExam(childId: String, grade: String, subject: Subject, difficulty: Difficulty, questionCount: Int) async throws -> BackendExamPaperDTO {
        try await post(
            path: "/api/exams/generate",
            body: GenerateExamRequestDTO(childId: childId, grade: grade, subject: subject.rawValue, difficulty: difficulty.rawValue, questionCount: questionCount),
            authorized: true
        )
    }

    func generateAnalyticsInsight(request: AIInsightRequestDTO) async throws -> AIInsightResponseDTO {
        try await post(path: "/api/analytics/generate", body: request, authorized: true)
    }

    func listChildren() async throws -> [ChildProfileDTO] {
        try await get(path: "/api/children", authorized: true)
    }

    func createChild(name: String, age: Int, grade: String, avatar: KidAvatar) async throws -> ChildProfileDTO {
        try await post(
            path: "/api/children",
            body: ChildProfileRequestDTO(name: name, age: age, grade: grade, avatarUrl: avatar.backendAvatarURLString),
            authorized: true
        )
    }

    func updateChild(id: String, name: String, age: Int, grade: String, avatar: KidAvatar) async throws -> ChildProfileDTO {
        try await put(
            path: "/api/children/\(id)",
            body: ChildProfileUpdateRequestDTO(name: name, age: age, grade: grade, avatarUrl: avatar.backendAvatarURLString),
            authorized: true
        )
    }

    func deleteChild(id: String) async throws -> DeleteResponseDTO {
        try await delete(path: "/api/children/\(id)", authorized: true)
    }

    func createExamAttempt(_ request: CreateExamAttemptRequestDTO) async throws -> ExamAttemptDTO {
        try await post(path: "/api/exam-attempts", body: request, authorized: true)
    }

    private func get<Response: Decodable>(path: String, authorized: Bool) async throws -> Response {
        let endpoint = try baseURL.appending(path: path)
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        if authorized, let accessToken, !accessToken.isEmpty {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        return try await send(request)
    }

    private func put<Request: Encodable, Response: Decodable>(path: String, body: Request, authorized: Bool) async throws -> Response {
        let endpoint = try baseURL.appending(path: path)
        var request = URLRequest(url: endpoint)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if authorized, let accessToken, !accessToken.isEmpty {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = try JSONEncoder().encode(body)
        return try await send(request)
    }

    private func delete<Response: Decodable>(path: String, authorized: Bool) async throws -> Response {
        let endpoint = try baseURL.appending(path: path)
        var request = URLRequest(url: endpoint)
        request.httpMethod = "DELETE"
        if authorized, let accessToken, !accessToken.isEmpty {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        return try await send(request)
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

        return try await send(request)
    }

    private func send<Response: Decodable>(_ request: URLRequest) async throws -> Response {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else { throw APIError.invalidResponse }
        guard (200..<300).contains(httpResponse.statusCode) else {
            let errorResponse = try? JSONDecoder().decode(ErrorResponseDTO.self, from: data)
            let message = errorResponse?.error.displayMessage ?? "Request failed with status \(httpResponse.statusCode)."
            if httpResponse.statusCode == 401 { throw APIError.unauthorized }
            if httpResponse.statusCode == 429 || message.localizedCaseInsensitiveContains("token") || message.localizedCaseInsensitiveContains("limit") {
                throw APIError.tokenLimitExceeded
            }
            throw APIError.server(message)
        }
        do {
            let success = try JSONDecoder().decode(APISuccessResponse<Response>.self, from: data)
            return success.data
        } catch {
            throw APIError.decoding("Could not read the backend login response. Please try again.")
        }
    }
}

struct APISuccessResponse<DataPayload: Decodable>: Decodable {
    let success: Bool
    let data: DataPayload
}

struct ErrorResponseDTO: Decodable {
    struct APIErrorPayload: Decodable {
        let message: String
        let details: [ValidationDetail]

        enum CodingKeys: String, CodingKey {
            case message
            case details
            case errors
            case issues
        }

        init(from decoder: Decoder) throws {
            if let container = try? decoder.singleValueContainer(), let message = try? container.decode(String.self) {
                self.message = message
                self.details = []
                return
            }

            let container = try decoder.container(keyedBy: CodingKeys.self)
            message = try container.decodeIfPresent(String.self, forKey: .message) ?? "Request failed."
            details = (try? container.decodeIfPresent([ValidationDetail].self, forKey: .details))
                ?? (try? container.decodeIfPresent([ValidationDetail].self, forKey: .errors))
                ?? (try? container.decodeIfPresent([ValidationDetail].self, forKey: .issues))
                ?? (try? container.decodeIfPresent(ValidationDetail.self, forKey: .details)).map { [$0] }
                ?? (try? container.decodeIfPresent(String.self, forKey: .details)).map { [ValidationDetail(message: $0)] }
                ?? []
        }

        var displayMessage: String {
            let detailMessages = details.map(\.displayMessage).filter { !$0.isEmpty }
            guard !detailMessages.isEmpty else { return message }
            return "\(message): \(detailMessages.joined(separator: ", "))"
        }
    }

    struct ValidationDetail: Decodable {
        let field: String?
        let message: String

        init(field: String? = nil, message: String) {
            self.field = field
            self.message = message
        }

        enum CodingKeys: String, CodingKey {
            case field
            case path
            case param
            case message
            case msg
        }

        init(from decoder: Decoder) throws {
            if let container = try? decoder.singleValueContainer(), let message = try? container.decode(String.self) {
                self.field = nil
                self.message = message
                return
            }

            let container = try decoder.container(keyedBy: CodingKeys.self)
            field = (try? container.decodeIfPresent(String.self, forKey: .field))
                ?? (try? container.decodeIfPresent(String.self, forKey: .path))
                ?? (try? container.decodeIfPresent([String].self, forKey: .path))?.joined(separator: ".")
                ?? (try? container.decodeIfPresent(String.self, forKey: .param))
            message = (try? container.decodeIfPresent(String.self, forKey: .message))
                ?? (try? container.decodeIfPresent(String.self, forKey: .msg))
                ?? ""
        }

        var displayMessage: String {
            guard let field, !field.isEmpty else { return message }
            guard !message.isEmpty else { return field }
            return "\(field) \(message)"
        }
    }

    let success: Bool?
    let error: APIErrorPayload
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
    let childId: String
    let grade: String
    let subject: String
    let difficulty: String
    let questionCount: Int
}

struct AIInsightRequestDTO: Encodable {
    let childId: String
    let period: String
}

struct ChildSummaryDTO: Encodable {
    let age: Int
    let grade: String
}

struct LearningSummaryDTO: Encodable {
    let totalExams: Int
    let averageScore: Int
    let bestScore: Int
    let subjects: [SubjectPerformanceDTO]
    let topicPerformance: [TopicCountDTO]
    let recentTrend: [RecentTrendDTO]
}

struct SubjectPerformanceDTO: Encodable {
    let subject: String
    let averageScore: Int
    let totalExams: Int
    let strongTopics: [String]
    let weakTopics: [String]
}

struct TopicCountDTO: Encodable {
    let topic: String
    let correct: Int
    let wrong: Int
}

struct RecentTrendDTO: Encodable {
    let subject: String
    let percentage: Int
    let attemptedAt: String
}

struct ChildProfileRequestDTO: Encodable {
    let name: String
    let age: Int
    let grade: String
    let avatarUrl: String?
}

struct ChildProfileUpdateRequestDTO: Encodable {
    let name: String
    let age: Int
    let grade: String
    let avatarUrl: String?
}

struct ChildProfileDTO: Decodable {
    let id: String
    let userId: String
    let name: String
    let age: Int
    let grade: String
    let avatarUrl: String?
    let createdAt: String
    let updatedAt: String

    var modelID: UUID { UUID(uuidString: id) ?? UUID() }
    var avatar: KidAvatar { KidAvatar.avatar(forBackendURL: avatarUrl) }
}

struct DeleteResponseDTO: Decodable {
    let deleted: Bool
}

struct CreateExamAttemptRequestDTO: Encodable {
    let childId: String
    let examId: String?
    let grade: String
    let subject: String
    let difficulty: String
    let questionCount: Int
    let correctAnswers: Int
    let totalMarks: Int
    let earnedMarks: Int
    let scorePercentage: Double
    let timeSpentSeconds: Int?
    let answers: [AttemptAnswerDTO]?
    let strongTopics: [String]
    let weakTopics: [String]
    let attemptedAt: String
}

struct AttemptAnswerDTO: Encodable {
    let questionId: String
    let selectedAnswer: String
    let isCorrect: Bool
    let topic: String
}

struct ExamAttemptDTO: Decodable {
    let id: String
    let userId: String?
    let childId: String?
    let examId: String?
    let grade: String?
    let subject: String?
    let difficulty: String?
    let questionCount: Int?
    let correctAnswers: Int?
    let totalMarks: Int?
    let earnedMarks: Int?
    let scorePercentage: Double?
    let timeSpentSeconds: Int?
    let strongTopics: [String]?
    let weakTopics: [String]?
    let attemptedAt: String?
    let createdAt: String?
    let updatedAt: String?
}

struct AIInsightResponseDTO: Decodable {
    let id: String
    let userId: String?
    let childId: String?
    let period: String?
    let summary: String
    let strengths: [String]
    let needsPractice: [String]
    let recommendations: [String]
    let suggestedDifficulty: String
    let createdAt: String
    let usage: AIInsightUsageDTO?
}

struct AIInsightUsageDTO: Decodable {
    let tokensUsed: Int
    let remainingTokens: Int
    let monthlyLimit: Int
}

struct AuthPayloadDTO: Decodable {
    let user: UserDTO
    let accessToken: String

    enum CodingKeys: String, CodingKey {
        case user
        case accessToken
        case token
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        user = try container.decode(UserDTO.self, forKey: .user)
        accessToken = try container.decodeIfPresent(String.self, forKey: .accessToken)
            ?? container.decodeIfPresent(String.self, forKey: .token)
            ?? ""
    }
}

struct UserDTO: Decodable {
    let id: String
    let name: String
    let email: String
    let city: String
    let plan: String?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case city
        case plan
        case createdAt
        case updatedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Parent"
        email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        city = try container.decodeIfPresent(String.self, forKey: .city) ?? ""
        plan = try container.decodeIfPresent(String.self, forKey: .plan)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt)
    }
}

struct BackendExamPaperDTO: Decodable {
    let examId: String
    let childId: String?
    let grade: String
    let subject: String
    let difficulty: String
    let questionCount: Int
    let questions: [BackendQuestionDTO]
    let usage: AIInsightUsageDTO?

    func makeExam(for profile: ChildProfile, parentID: String) -> Exam {
        let subjectValue = Subject(rawValue: subject) ?? .maths
        let difficultyValue = Difficulty(rawValue: difficulty) ?? .easy
        let sanitizedQuestions = questions.map(\.modelQuestion).map(\.sanitizedForPersistence)
        let exam = Exam(
            parentID: parentID,
            childProfileID: profile.profileID,
            childBackendID: profile.backendID,
            childName: profile.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Little Scholar" : profile.name,
            grade: profile.grade.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? grade : profile.grade,
            subject: subjectValue,
            difficulty: difficultyValue,
            questions: sanitizedQuestions
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
    let correctAnswer: FlexibleAnswer
    let acceptableAnswers: [String]?
    let explanation: String
    let topic: String
    let marks: Int

    var questionModelOptions: [String] {
        if let options, !options.isEmpty { return options }
        if type == "true_false" { return ["True", "False"] }
        return []
    }

    var questionModelCorrectAnswer: String {
        correctAnswer.displayValue
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
            marks: marks
        )
    }
}

enum FlexibleAnswer: Decodable {
    case string(String)
    case array([String])
    case object([String: String])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let array = try? container.decode([String].self) {
            self = .array(array)
        } else if let object = try? container.decode([String: String].self) {
            self = .object(object)
        } else {
            self = .string("")
        }
    }

    var displayValue: String {
        switch self {
        case .string(let value): value
        case .array(let values): values.joined(separator: ", ")
        case .object(let object): object.values.joined(separator: ", ")
        }
    }
}

struct ContentView: View {
    @State private var profiles: [ChildProfile] = []
    @State private var exams: [Exam] = []
    @State private var results: [ExamResult] = []
    @State private var apiBaseURL = "https://little-scholar-server-production.up.railway.app"
    @State private var parentID = ""
    @State private var parentName = ""
    @State private var parentEmail = ""
    @State private var parentCity = ""
    @State private var parentAccessToken = ""
    @State private var parentIsRegistered = false
    @State private var parentIsLoggedIn = false
    @State private var selectedMode: AppMode = .parent
    @State private var latestResult: ExamResult?
    @State private var saveErrorMessage: String?
    @State private var isGeneratingExam = false
    @State private var showingLogin = false

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
                        errorMessage: saveErrorMessage,
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
            .navigationTitle("Little Scholar")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Could not save", isPresented: saveErrorBinding) {
                Button("OK", role: .cancel) { saveErrorMessage = nil }
            } message: {
                Text(saveErrorMessage ?? "Please try again.")
            }
            .task {
                migrateBackendURLIfNeeded()
                if parentIsLoggedIn {
                    await refreshChildrenFromBackend()
                }
            }
        }
    }

    private var mainAppShell: some View {
        VStack(spacing: 14) {
            HeaderView(parentName: parentName, onLogout: { parentIsLoggedIn = false })
            ModeNavigation(selectedMode: $selectedMode)
            content
        }
        .padding(.top, 8)
    }

    @ViewBuilder
    private var content: some View {
        switch selectedMode {
        case .parent:
            ScrollView { ChildProfileView(profiles: currentParentProfiles, onSaveProfile: saveProfile).padding() }
        case .exam:
            ScrollView { ExamSetupView(profiles: currentParentProfiles, exams: displayableExams, isGenerating: isGeneratingExam, onGenerateExam: generateExam).padding() }
        case .kid:
            KidExamListView(
                profiles: currentParentProfiles,
                exams: currentParentExams.filter { !$0.isCompleted },
                latestResult: latestResult,
                onSubmit: evaluateExam,
                onCreateExam: { selectedMode = .exam },
                onDeleteProfile: deleteProfile,
                onUpdateProfile: updateProfile
            )
        case .performance:
            PerformanceDashboardView(profiles: currentParentProfiles, results: currentParentResults)
        case .aiInsights:
            AIInsightsView(
                profiles: currentParentProfiles,
                results: currentParentResults,
                cachedInsights: [],
                apiClient: apiClient,
                onInsightGenerated: { _, _ in },
                onUnauthorized: handleUnauthorizedSession
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
        saveErrorMessage = nil
        do {
            let payload = try await apiClient.register(
                name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                city: city.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )
            return saveAuthenticatedParent(payload)
        } catch {
            saveErrorMessage = error.localizedDescription
            return false
        }
    }

    private func loginParent(email: String, password: String) async -> Bool {
        saveErrorMessage = nil
        do {
            let payload = try await apiClient.login(
                email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                password: password
            )
            return saveAuthenticatedParent(payload)
        } catch {
            saveErrorMessage = error.localizedDescription
            return false
        }
    }

    @discardableResult
    private func saveAuthenticatedParent(_ payload: AuthPayloadDTO) -> Bool {
        let accessToken = payload.accessToken.trimmingCharacters(in: .whitespacesAndNewlines)
        let userID = payload.user.id.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !accessToken.isEmpty, !userID.isEmpty else {
            saveErrorMessage = "Login response was missing account details. Please try again."
            return false
        }

        parentID = payload.user.id
        parentName = payload.user.name
        parentEmail = payload.user.email
        parentCity = payload.user.city
        parentAccessToken = accessToken
        latestResult = nil
        selectedMode = .parent
        parentIsRegistered = true
        parentIsLoggedIn = true

        let authenticatedClient = APIClient(baseURLString: apiBaseURL, accessToken: accessToken)
        Task { await refreshChildrenFromBackend(using: authenticatedClient) }
        return true
    }

    private func resetParentRegistration() {
        parentID = ""
        parentName = ""
        parentEmail = ""
        parentCity = ""
        parentAccessToken = ""
        latestResult = nil
        selectedMode = .parent
        parentIsRegistered = false
        parentIsLoggedIn = false
    }

    private func saveProfile(name: String, age: Int, grade: String, avatar: KidAvatar) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else { return }

        Task {
            do {
                let child = try await apiClient.createChild(name: trimmedName, age: age, grade: backendGrade(for: grade), avatar: avatar)
                upsertChildProfile(from: child)
            } catch APIError.unauthorized {
                handleUnauthorizedSession()
            } catch {
                saveErrorMessage = error.localizedDescription
            }
        }
    }

    private func deleteProfile(_ profile: ChildProfile) {
        guard profile.parentID == parentID else { return }
        let backendID = backendChildID(for: profile)
        guard !backendID.isEmpty else {
            saveErrorMessage = "This child profile is missing its backend ID. Refresh kids and try again."
            return
        }

        Task {
            do {
                _ = try await apiClient.deleteChild(id: backendID)
                deleteProfileLocally(profile)
            } catch APIError.unauthorized {
                handleUnauthorizedSession()
            } catch {
                saveErrorMessage = error.localizedDescription
            }
        }
    }

    private func updateProfile(_ profile: ChildProfile, name: String, age: Int, grade: String, avatar: KidAvatar) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard profile.parentID == parentID, !trimmedName.isEmpty else { return }
        let backendID = backendChildID(for: profile)
        guard !backendID.isEmpty else {
            saveErrorMessage = "This child profile is missing its backend ID. Refresh kids and try again."
            return
        }

        Task {
            do {
                let child = try await apiClient.updateChild(id: backendID, name: trimmedName, age: age, grade: backendGrade(for: grade), avatar: avatar)
                upsertChildProfile(from: child)
                updateLocalChildReferences(profileID: profile.profileID, name: child.name)
            } catch APIError.unauthorized {
                handleUnauthorizedSession()
            } catch {
                saveErrorMessage = error.localizedDescription
            }
        }
    }

    private func refreshChildrenFromBackend(using client: APIClient? = nil) async {
        do {
            let remoteChildren = try await (client ?? apiClient).listChildren()
            syncChildProfiles(remoteChildren)
        } catch APIError.unauthorized {
            handleUnauthorizedSession()
        } catch {
            saveErrorMessage = error.localizedDescription
        }
    }

    private func syncChildProfiles(_ remoteChildren: [ChildProfileDTO]) {
        for child in remoteChildren {
            upsertChildProfile(from: child)
        }
        removeDuplicateChildProfilesKeepingBackendIDs()
    }

    private func upsertChildProfile(from child: ChildProfileDTO) {
        let modelID = child.modelID
        if let existingProfile = currentParentProfiles.first(where: { $0.backendID == child.id || $0.profileID == modelID }) {
            existingProfile.parentID = parentID
            existingProfile.backendID = child.id
            existingProfile.name = child.name
            existingProfile.age = child.age
            existingProfile.grade = child.grade
            existingProfile.avatar = child.avatar.rawValue
        } else {
            profiles.append(ChildProfile(
                profileID: modelID,
                backendID: child.id,
                parentID: parentID,
                name: child.name,
                age: child.age,
                grade: child.grade,
                avatar: child.avatar
            ))
        }
    }

    private func updateLocalChildReferences(profileID: UUID, name: String) {
        for exam in currentParentExams where exam.childProfileID == profileID {
            exam.childName = name
        }
        for result in currentParentResults where result.childProfileID == profileID {
            result.childName = name
        }
    }

    private func updateLocalChildReferences(profileID: UUID, backendID: String, name: String) {
        for exam in currentParentExams where exam.childProfileID == profileID {
            exam.childBackendID = backendID
            exam.childName = name
        }
        for result in currentParentResults where result.childProfileID == profileID {
            result.childBackendID = backendID
            result.childName = name
        }
        if latestResult?.childProfileID == profileID {
            latestResult?.childBackendID = backendID
            latestResult?.childName = name
        }
    }

    private func replaceLocalChildID(_ oldID: UUID, with newID: UUID, backendID: String, name: String) {
        for profile in profiles where profile.profileID == oldID {
            profile.profileID = newID
            profile.backendID = backendID
            profile.parentID = parentID
            profile.name = name
        }
        for exam in exams where exam.childProfileID == oldID {
            exam.childProfileID = newID
            exam.childBackendID = backendID
            exam.childName = name
        }
        for result in results where result.childProfileID == oldID {
            result.childProfileID = newID
            result.childBackendID = backendID
            result.childName = name
        }
        if latestResult?.childProfileID == oldID {
            latestResult?.childProfileID = newID
            latestResult?.childBackendID = backendID
            latestResult?.childName = name
        }
    }

    private func backendSyncedProfile(for profile: ChildProfile) async throws -> ChildProfile {
        let remoteChildren = try await apiClient.listChildren()
        if let remoteChild = remoteChildren.first(where: { $0.id == profile.backendID || $0.modelID == profile.profileID }) {
            upsertChildProfile(from: remoteChild)
            updateLocalChildReferences(profileID: profile.profileID, backendID: remoteChild.id, name: remoteChild.name)
            return currentParentProfiles.first { $0.backendID == remoteChild.id } ?? profile
        }

        let createdChild = try await apiClient.createChild(
            name: profile.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Little Scholar" : profile.name,
            age: min(10, max(2, profile.age)),
            grade: backendGrade(for: profile.grade),
            avatar: KidAvatar.avatar(for: profile.avatar)
        )
        let oldID = profile.profileID
        let newID = createdChild.modelID
        replaceLocalChildID(oldID, with: newID, backendID: createdChild.id, name: createdChild.name)
        upsertChildProfile(from: createdChild)
        return currentParentProfiles.first { $0.backendID == createdChild.id || $0.profileID == newID } ?? profile
    }

    private func deleteProfileLocally(_ profile: ChildProfile) {
        let profileID = profile.profileID
        exams.removeAll { $0.parentID == parentID && $0.childProfileID == profileID }
        results.removeAll { $0.parentID == parentID && $0.childProfileID == profileID }
        if latestResult?.childProfileID == profileID {
            latestResult = nil
        }
        profiles.removeAll { $0.parentID == parentID && $0.profileID == profileID }
    }

    private func removeDuplicateChildProfilesKeepingBackendIDs() {
        var seenBackendIDs = Set<String>()
        var seenLocalIDs = Set<UUID>()
        profiles.removeAll { profile in
            guard profile.parentID == parentID else { return false }
            let backendID = profile.backendID.trimmingCharacters(in: .whitespacesAndNewlines)
            if !backendID.isEmpty {
                if seenBackendIDs.contains(backendID) { return true }
                seenBackendIDs.insert(backendID)
                return false
            }
            if seenLocalIDs.contains(profile.profileID) {
                return true
            }
            seenLocalIDs.insert(profile.profileID)
            return false
        }
    }

    private func backendChildID(for profile: ChildProfile) -> String {
        profile.backendID.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func handleUnauthorizedSession() {
        parentAccessToken = ""
        parentIsLoggedIn = false
        showingLogin = true
        selectedMode = .parent
    }

    private func generateExam(profile: ChildProfile, subject: Subject, difficulty: Difficulty, numberOfQuestions: Int) {
        guard !isGeneratingExam else { return }
        isGeneratingExam = true

        Task {
            do {
                let syncedProfile = try await backendSyncedProfile(for: profile)
                let childID = backendChildID(for: syncedProfile)
                guard !childID.isEmpty else {
                    throw APIError.server("This child profile is missing its backend ID. Refresh kids and try again.")
                }
                let backendExam = try await apiClient.generateExam(
                    childId: childID,
                    grade: backendGrade(for: syncedProfile.grade),
                    subject: subject,
                    difficulty: difficulty,
                    questionCount: numberOfQuestions
                )
                let exam = backendExam.makeExam(for: syncedProfile, parentID: parentID)
                guard !exam.questions.isEmpty else {
                    throw APIError.server("The backend did not return any questions. Please try generating the exam again.")
                }
                exams.insert(exam, at: 0)
                isGeneratingExam = false
                selectedMode = .kid
            } catch APIError.unauthorized {
                isGeneratingExam = false
                handleUnauthorizedSession()
            } catch {
                isGeneratingExam = false
                saveErrorMessage = error.localizedDescription
            }
        }
    }

    private func backendGrade(for profileGrade: String) -> String {
        switch profileGrade {
        case "Nursery": "Nursery"
        case "LKG": "LKG"
        case "UKG": "UKG"
        case "Grade 1": "Grade 1"
        default: "LKG"
        }
    }

    private func evaluateExam(exam: Exam, answers: [UUID: String], onSaved: @escaping (ExamResult) -> Void) {
        let result = answerEvaluation.evaluate(exam: exam, answers: answers)
        result.parentID = parentID
        Task {
            if await saveExamAttempt(result: result, exam: exam) {
                onSaved(result)
            }
        }
    }

    private func saveExamAttempt(result: ExamResult, exam: Exam) async -> Bool {
        do {
            guard !result.childBackendID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                throw APIError.server("This exam is missing its backend child ID. Refresh kids and generate the exam again.")
            }
            let request = createExamAttemptRequest(result: result, exam: exam)
            _ = try await apiClient.createExamAttempt(request)
            exam.isCompleted = true
            results.insert(result, at: 0)
            latestResult = result
            return true
        } catch APIError.unauthorized {
            handleUnauthorizedSession()
        } catch {
            saveErrorMessage = error.localizedDescription
        }
        return false
    }

    private func createExamAttemptRequest(result: ExamResult, exam: Exam) -> CreateExamAttemptRequestDTO {
        let topicStats = topicStats(for: result.evaluations)
        let strongTopics = topicStats.filter { $0.score >= 70 }.prefix(20).map(\.topic)
        let weakTopics = topicStats.filter { $0.score < 70 }.prefix(20).map(\.topic)
        let totalMarks = result.evaluations.reduce(0) { $0 + max(1, $1.question.marks) }
        let earnedMarks = result.evaluations.reduce(0) { $0 + ($1.isCorrect ? max(1, $1.question.marks) : 0) }
        let answerPayload = result.evaluations.map { evaluation in
            AttemptAnswerDTO(
                questionId: evaluation.question.backendID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? evaluation.question.id.uuidString : evaluation.question.backendID,
                selectedAnswer: evaluation.selectedAnswer.trimmingCharacters(in: .whitespacesAndNewlines),
                isCorrect: evaluation.isCorrect,
                topic: evaluation.question.topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "General" : evaluation.question.topic
            )
        }

        return CreateExamAttemptRequestDTO(
            childId: result.childBackendID.trimmingCharacters(in: .whitespacesAndNewlines),
            examId: exam.examID.uuidString,
            grade: backendGrade(for: result.grade),
            subject: result.subject,
            difficulty: result.difficulty,
            questionCount: result.totalQuestions,
            correctAnswers: result.correctAnswers,
            totalMarks: max(1, totalMarks),
            earnedMarks: earnedMarks,
            scorePercentage: Double(result.percentage),
            timeSpentSeconds: nil,
            answers: answerPayload,
            strongTopics: Array(strongTopics),
            weakTopics: Array(weakTopics),
            attemptedAt: ISO8601DateFormatter().string(from: result.completedAt)
        )
    }

    private func topicStats(for evaluations: [AnswerEvaluation]) -> [TopicPerformance] {
        var totals: [String: (correct: Int, total: Int)] = [:]
        for evaluation in evaluations {
            let topic = evaluation.question.topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "General" : evaluation.question.topic
            let current = totals[topic] ?? (correct: 0, total: 0)
            totals[topic] = (correct: current.correct + (evaluation.isCorrect ? 1 : 0), total: current.total + 1)
        }
        return totals.map { topic, values in
            TopicPerformance(topic: topic, score: values.total == 0 ? 0 : Int((Double(values.correct) / Double(values.total) * 100).rounded()))
        }
        .sorted { lhs, rhs in
            if lhs.score == rhs.score { return lhs.topic < rhs.topic }
            return lhs.score < rhs.score
        }
    }

    private func migrateBackendURLIfNeeded() {
        if apiBaseURL == "https://your-railway-domain.up.railway.app" || apiBaseURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            apiBaseURL = "https://little-scholar-server-production.up.railway.app"
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
        ScrollView {
            VStack(spacing: 18) {
                AuthTitleView(title: "Parent Registration", subtitle: "Create your parent account.")

                sectionCard(title: "Parent Details", icon: "person.crop.circle.badge.plus") {
                    VStack(spacing: 14) {
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
                        .buttonStyle(CheerfulButtonStyle(color: .orange))
                        .disabled(!canRegister)

                        Button(action: onGoToLogin) {
                            Label("Already registered? Login", systemImage: "arrow.right.circle.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(CheerfulButtonStyle(color: .teal))
                    }
                }
            }
            .padding()
            .adaptiveContentWidth(maxWidth: 620)
        }
    }
}

struct ParentLoginView: View {
    let registeredEmail: String
    let parentName: String
    let errorMessage: String?
    let onLogin: (String, String) async -> Bool
    let onRegisterAgain: () -> Void

    @State private var email = ""
    @State private var password = ""
    @State private var isSubmitting = false
    @State private var showLoginError = false

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                AuthTitleView(title: "Parent Login", subtitle: "Welcome back, \(parentName).")

                sectionCard(title: "Login", icon: "lock.fill") {
                    VStack(spacing: 14) {
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
                            Label(errorMessage ?? "Login failed. Check your email and password.", systemImage: "exclamationmark.triangle.fill")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        Button {
                            Task {
                                isSubmitting = true
                                showLoginError = false
                                showLoginError = !(await onLogin(email, password))
                                isSubmitting = false
                            }
                        } label: {
                            Label(isSubmitting ? "Logging in..." : "Login", systemImage: "arrow.right.circle.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(CheerfulButtonStyle(color: .teal))
                        .disabled(email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || password.isEmpty || isSubmitting)

                        Button("Register a different parent", action: onRegisterAgain)
                            .font(.headline)
                            .foregroundStyle(.orange)
                    }
                }
            }
            .padding()
            .adaptiveContentWidth(maxWidth: 560)
        }
    }
}

struct AuthTitleView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "graduationcap.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.orange)
            Text("Little Scholar")
                .font(.largeTitle.bold())
            Text(title)
                .font(.title2.bold())
            Text(subtitle)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ChildProfileView: View {
    let profiles: [ChildProfile]
    let onSaveProfile: (String, Int, String, KidAvatar) -> Void

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var childName = ""
    @State private var age = 6
    @State private var grade = "Grade 1"
    @State private var avatar: KidAvatar = .unicorn

    private let grades = ["Nursery", "LKG", "UKG", "Grade 1"]
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
                Stepper("Age: \(age)", value: $age, in: 2...10).font(.title3.bold())
                Picker("Grade", selection: $grade) { ForEach(grades, id: \.self) { Text($0).tag($0) } }.pickerStyle(.menu)
                AvatarPicker(selection: $avatar)
                Button {
                    onSaveProfile(childName, age, grade, avatar)
                    childName = ""
                } label: {
                    Label("Add Kid Profile", systemImage: "plus.circle.fill").frame(maxWidth: .infinity)
                }
                .buttonStyle(CheerfulButtonStyle(color: .orange))
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
    private var previewExams: [Exam] {
        guard let selectedProfile else { return [] }
        return exams.filter { !$0.isCompleted && $0.childProfileID == selectedProfile.profileID }
    }

    var body: some View {
        Group {
            if usesWideLayout {
                HStack(alignment: .top, spacing: 18) {
                    setupForm.frame(maxWidth: 460)
                    ExamPreviewView(exams: previewExams)
                }
            } else {
                VStack(spacing: 16) {
                    setupForm
                    ExamPreviewView(exams: previewExams)
                }
            }
        }
        .adaptiveContentWidth()
        .onAppear(perform: ensureSelectedProfile)
    }

    private var setupForm: some View {
        sectionCard(title: "Generate Exam Paper", icon: "doc.badge.plus") {
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
                            Label("Generate Exam Paper", systemImage: "sparkles").frame(maxWidth: .infinity)
                        }
                        .buttonStyle(CheerfulButtonStyle(color: .teal))
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
                animatedIcon("pencil.and.scribble", color: .orange, delay: 0)
                animatedIcon("sparkles", color: .purple, delay: 0.12)
                animatedIcon("brain.head.profile", color: .teal, delay: 0.24)
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
                .tint(.orange)
                .animation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true), value: sparkle)
        }
        .frame(maxWidth: .infinity)
        .padding(18)
        .background(Color.yellow.opacity(0.16))
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
        sectionCard(title: "Pending Exam Papers", icon: "tray.full.fill") {
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
    let onSubmit: (Exam, [UUID: String], @escaping (ExamResult) -> Void) -> Void
    let onCreateExam: () -> Void
    let onDeleteProfile: (ChildProfile) -> Void
    let onUpdateProfile: (ChildProfile, String, Int, String, KidAvatar) -> Void

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var selectedProfileID: UUID?
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
                ResultView(result: completedResult, usesKidTheme: true)
            } else if let selectedExam {
                ExamAttemptView(exam: selectedExam) { exam, answers in
                    onSubmit(exam, answers) { result in
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
        .background(KidScholarBackground())
        .sheet(isPresented: $showEditProfileSheet) {
            if let profileBeingEdited {
                EditKidProfileView(profile: profileBeingEdited, onSave: onUpdateProfile)
            }
        }
    }

    private var profilePicker: some View {
        kidSectionCard(title: "Choose Your Profile", icon: "figure.child.circle.fill") {
            if profiles.isEmpty {
                EmptyStateView(icon: "person.crop.circle.badge.questionmark", title: "No kid profiles", message: "Ask a parent to create a profile first.")
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 12)], spacing: 12) {
                    ForEach(profiles) { profile in
                        let isSelected = selectedProfileID == profile.profileID
                        VStack(spacing: 8) {
                            HStack(spacing: 8) {
                                Spacer()
                                Button {
                                    profileBeingEdited = profile
                                    showEditProfileSheet = true
                                } label: {
                                    Image(systemName: "pencil.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(.teal)
                                        .frame(width: 36, height: 36)
                                        .background(Color.teal.opacity(0.12))
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
                                        .foregroundStyle(.red)
                                        .frame(width: 36, height: 36)
                                        .background(Color.red.opacity(0.12))
                                        .clipShape(Circle())
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel("Delete \(profile.name) profile")
                            }

                            Button {
                                selectedProfileID = profile.profileID
                                selectedExam = nil
                                completedResult = nil
                            } label: {
                                VStack(spacing: 8) {
                                    AvatarBadge(avatar: KidAvatar.avatar(for: profile.avatar), isSelected: isSelected)
                                    Text(profile.name).font(.title3.bold()).foregroundStyle(.primary).lineLimit(1)
                                    Text(profile.grade).font(.caption.weight(.semibold)).foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(12)
                        .background(isSelected ? KidScholarTheme.selectedProfileSurface : KidScholarTheme.profileSurface)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    }
                }
            }
        }
    }

    private var assignedExams: some View {
        kidSectionCard(title: "Your Exam Papers", icon: "doc.text.fill") {
            if selectedProfile == nil {
                EmptyStateView(icon: "hand.tap.fill", title: "Tap your profile", message: "Then your exam papers will appear here.")
            } else if examsForSelectedProfile.isEmpty {
                VStack(spacing: 14) {
                    EmptyStateView(icon: "doc.badge.clock", title: "No exam assigned", message: "Ask a parent to generate an exam paper for you.")
                    Button(action: onCreateExam) { Label("Go to Exam Mode", systemImage: "doc.badge.plus").frame(maxWidth: .infinity) }.buttonStyle(CheerfulButtonStyle(color: KidScholarTheme.accent))
                }
            } else {
                LazyVStack(spacing: 12) { ForEach(examsForSelectedProfile) { exam in Button { selectedExam = exam } label: { ExamStartRow(exam: exam) }.buttonStyle(.plain) } }
            }
        }
    }

    private var selectedProfile: ChildProfile? {
        guard let selectedProfileID else { return nil }
        return profiles.first { $0.profileID == selectedProfileID }
    }
    private var examsForSelectedProfile: [Exam] { selectedProfile.map { profile in exams.filter { $0.childProfileID == profile.profileID } } ?? [] }
    private func ensureSelectedProfile() {
        if let selectedProfileID, !profiles.contains(where: { $0.profileID == selectedProfileID }) {
            self.selectedProfileID = nil
        }
    }

    private func confirmProfileDeletion() {
        guard let profile = profilePendingDeletion else { return }
        if selectedProfileID == profile.profileID {
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
    let onSave: (ChildProfile, String, Int, String, KidAvatar) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var age: Int
    @State private var grade: String
    @State private var avatar: KidAvatar

    private let grades = ["Nursery", "LKG", "UKG", "Grade 1"]

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    init(profile: ChildProfile, onSave: @escaping (ChildProfile, String, Int, String, KidAvatar) -> Void) {
        self.profile = profile
        self.onSave = onSave
        _name = State(initialValue: profile.name)
        _age = State(initialValue: min(10, max(2, profile.age)))
        _grade = State(initialValue: Self.backendGrade(for: profile.grade))
        _avatar = State(initialValue: KidAvatar.avatar(for: profile.avatar))
    }

    private static func backendGrade(for grade: String) -> String {
        switch grade {
        case "Nursery": "Nursery"
        case "UKG": "UKG"
        case "Grade 1": "Grade 1"
        default: "LKG"
        }
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
                            Stepper("Age: \(age)", value: $age, in: 2...10)
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
                        onSave(profile, name, age, grade, avatar)
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
                Text("\(exam.childName)'s \(exam.subject) Exam")
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                Text("Question \(currentIndex + 1) of \(exam.questions.count)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                ProgressView(value: Double(currentIndex + 1), total: Double(exam.questions.count))
                    .tint(.orange)

                VStack(alignment: .leading, spacing: 18) {
                    Text(currentQuestion.prompt)
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if currentQuestion.options.isEmpty {
                        TextField("Type your answer", text: answerBinding(for: currentQuestion.id))
                            .textFieldStyle(.roundedBorder)
                            .font(.title3)
                            .textInputAutocapitalization(.never)
                    } else {
                        ForEach(currentQuestion.options, id: \.self) { option in
                            Button { answers[currentQuestion.id] = option } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: answers[currentQuestion.id] == option ? "checkmark.circle.fill" : "circle")
                                        .font(.title2)
                                    Text(option)
                                        .font(.title3.bold())
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .multilineTextAlignment(.leading)
                                }
                                .padding()
                                .background(answers[currentQuestion.id] == option ? KidScholarTheme.actionSurface : KidScholarTheme.profileSurface)
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(20)
                .background(KidScholarTheme.cardSurface)
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
                    .buttonStyle(CheerfulButtonStyle(color: KidScholarTheme.secondaryAccent))
                    .disabled(!currentAnswerIsReady)
                }
            }
            .padding()
            .frame(maxWidth: 860)
            .frame(maxWidth: .infinity)
        }
        .background(KidScholarBackground())
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
        sectionCard(title: "Performance Dashboard", icon: "chart.bar.fill") {
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
        sectionCard(title: "Exam History", icon: "clock.fill") {
            if results.isEmpty {
                EmptyStateView(icon: "clock.badge.questionmark", title: "No completed exams", message: "Completed exam results will appear here.")
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

struct AIInsightsView: View {
    let profiles: [ChildProfile]
    let results: [ExamResult]
    let cachedInsights: [AIInsight]
    let apiClient: APIClient
    let onInsightGenerated: (AIInsightResponseDTO, ChildProfile) -> Void
    let onUnauthorized: () -> Void

    @State private var selectedProfileID: UUID?
    @State private var generatedInsight: AIInsightResponseDTO?
    @State private var isGeneratingInsight = false
    @State private var insightErrorMessage: String?

    private var selectedProfile: ChildProfile? {
        guard let selectedProfileID else { return profiles.first }
        return profiles.first { $0.profileID == selectedProfileID } ?? profiles.first
    }

    private var selectedResults: [ExamResult] {
        guard let profileID = selectedProfile?.profileID else { return [] }
        return results.filter { $0.childProfileID == profileID }
    }

    private var cachedInsight: AIInsight? {
        guard let profileID = selectedProfile?.profileID else { return nil }
        return cachedInsights
            .filter { $0.childLocalId == profileID }
            .sorted { $0.generatedAt > $1.generatedAt }
            .first
    }

    private var hasNewExamAttemptsAfterCachedInsight: Bool {
        guard let cachedInsight else { return false }
        return selectedResults.contains { $0.completedAt > cachedInsight.generatedAt }
    }

    private var displayedInsight: AIInsightDisplayData? {
        if let generatedInsight { return AIInsightDisplayData(response: generatedInsight) }
        if let cachedInsight { return AIInsightDisplayData(insight: cachedInsight) }
        return nil
    }

    private var generateButtonTitle: String {
        if isGeneratingInsight { return "Generating AI Insight..." }
        return cachedInsight == nil ? "Generate AI Insight" : "Refresh Insight"
    }

    private var averageScore: Int {
        selectedResults.isEmpty ? 0 : Int((Double(selectedResults.map(\.percentage).reduce(0, +)) / Double(selectedResults.count)).rounded())
    }

    private var bestScore: Int {
        selectedResults.map(\.percentage).max() ?? 0
    }

    private var recentSubjects: [String] {
        uniqueValues(selectedResults.sorted { $0.completedAt > $1.completedAt }.map(\.subject)).prefix(4).map { $0 }
    }

    private var weakTopics: [String] {
        topicPerformance.filter { $0.score < 70 }.prefix(4).map(\.topic)
    }

    private var strongTopics: [String] {
        topicPerformance.filter { $0.score >= 70 }.prefix(4).map(\.topic)
    }

    private var canGenerateInsight: Bool {
        selectedResults.count >= 3
    }

    private var topicPerformance: [TopicPerformance] {
        topicCounts.map { item in
            let total = item.correct + item.wrong
            return TopicPerformance(topic: item.topic, score: total == 0 ? 0 : Int((Double(item.correct) / Double(total) * 100).rounded()))
        }
        .sorted { lhs, rhs in
            if lhs.score == rhs.score { return lhs.topic < rhs.topic }
            return lhs.score < rhs.score
        }
    }

    private var topicCounts: [TopicCountDTO] {
        topicCounts(for: selectedResults)
    }

    private var subjectPerformance: [SubjectPerformanceDTO] {
        Subject.allCases.compactMap { subject in
            let subjectResults = selectedResults.filter { $0.subject == subject.rawValue }
            guard !subjectResults.isEmpty else { return nil }
            let average = Int((Double(subjectResults.map(\.percentage).reduce(0, +)) / Double(subjectResults.count)).rounded())
            let subjectTopics = topicPerformance(for: subjectResults)
            return SubjectPerformanceDTO(
                subject: subject.rawValue,
                averageScore: average,
                totalExams: subjectResults.count,
                strongTopics: subjectTopics.filter { $0.score >= 70 }.prefix(4).map(\.topic),
                weakTopics: subjectTopics.filter { $0.score < 70 }.prefix(4).map(\.topic)
            )
        }
    }

    private var recentTrend: [RecentTrendDTO] {
        selectedResults
            .sorted { $0.completedAt > $1.completedAt }
            .prefix(8)
            .map { result in
                RecentTrendDTO(
                    subject: result.subject,
                    percentage: result.percentage,
                    attemptedAt: iso8601String(from: result.completedAt)
                )
            }
            .reversed()
    }

    private var insightRequest: AIInsightRequestDTO? {
        guard let selectedProfile else { return nil }
        let childID = selectedProfile.backendID.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !childID.isEmpty else { return nil }
        return AIInsightRequestDTO(childId: childID, period: "all_time")
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                sectionCard(title: "AI Insights", icon: "sparkles") {
                    if profiles.isEmpty {
                        EmptyStateView(icon: "person.2.slash", title: "No kids yet", message: "Create a kid profile before generating AI insights.")
                    } else {
                        VStack(spacing: 14) {
                            Picker("Kid", selection: selectedProfileBinding) {
                                ForEach(profiles) { profile in
                                    Text(profile.name).tag(Optional(profile.profileID))
                                }
                            }
                            .pickerStyle(.menu)

                            insightSummary

                            Label("Learning performance is stored on the backend and used to generate AI insights.", systemImage: "lock.shield.fill")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            if hasNewExamAttemptsAfterCachedInsight {
                                Label("New exam attempts found. Refresh insight for updated analysis.", systemImage: "arrow.clockwise.circle.fill")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.orange)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }

                            if !canGenerateInsight {
                                Label("Complete at least 3 exams to generate meaningful AI insights.", systemImage: "info.circle.fill")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }

                            if let insightErrorMessage {
                                Label(insightErrorMessage, systemImage: "exclamationmark.triangle.fill")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }

                            Button {
                                generateAIInsight()
                            } label: {
                                Label(generateButtonTitle, systemImage: "sparkles")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(CheerfulButtonStyle(color: .orange))
                            .disabled(!canGenerateInsight || isGeneratingInsight)
                        }
                    }
                }

                if let displayedInsight {
                    AIInsightResultView(insight: displayedInsight)
                }
            }
            .padding()
            .adaptiveContentWidth(maxWidth: 920)
        }
        .onAppear(perform: ensureSelectedProfile)
        .onChange(of: selectedProfileID) { _, _ in generatedInsight = nil }
    }

    private var selectedProfileBinding: Binding<UUID?> {
        Binding(
            get: { selectedProfile?.profileID },
            set: { selectedProfileID = $0 }
        )
    }

    private var insightSummary: some View {
        VStack(spacing: 14) {
            HistorySummary(results: selectedResults)
            insightList(title: "Recent Subjects Practiced", values: recentSubjects, emptyText: "No subjects practiced yet.", color: .teal)
            insightList(title: "Weak Topics", values: weakTopics, emptyText: "No weak topics found yet.", color: .orange)
            insightList(title: "Strong Topics", values: strongTopics, emptyText: "No strong topics found yet.", color: .green)
        }
    }

    private func insightList(title: String, values: [String], emptyText: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            if values.isEmpty {
                Text(emptyText)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
            } else {
                FlowTagList(values: values, color: color)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(color.opacity(0.10))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func ensureSelectedProfile() {
        if selectedProfileID == nil || selectedProfile == nil {
            selectedProfileID = profiles.first?.profileID
        }
    }

    private func generateAIInsight() {
        guard let insightRequest, let selectedProfile, canGenerateInsight else { return }
        isGeneratingInsight = true
        insightErrorMessage = nil

        Task {
            do {
                let response = try await apiClient.generateAnalyticsInsight(request: insightRequest)
                generatedInsight = response
                onInsightGenerated(response, selectedProfile)
            } catch APIError.unauthorized {
                onUnauthorized()
            } catch APIError.tokenLimitExceeded {
                insightErrorMessage = APIError.tokenLimitExceeded.localizedDescription
            } catch {
                insightErrorMessage = "Could not generate AI insight right now. Please try again in a little while."
            }
            isGeneratingInsight = false
        }
    }

    private func topicCounts(for results: [ExamResult]) -> [TopicCountDTO] {
        var totals: [String: (correct: Int, wrong: Int)] = [:]
        for result in results {
            for evaluation in result.evaluations {
                let topic = normalizedTopic(evaluation.question.topic)
                let current = totals[topic] ?? (correct: 0, wrong: 0)
                totals[topic] = (
                    correct: current.correct + (evaluation.isCorrect ? 1 : 0),
                    wrong: current.wrong + (evaluation.isCorrect ? 0 : 1)
                )
            }
        }

        return totals.map { topic, values in
            TopicCountDTO(topic: topic, correct: values.correct, wrong: values.wrong)
        }
        .sorted { lhs, rhs in
            let lhsTotal = lhs.correct + lhs.wrong
            let rhsTotal = rhs.correct + rhs.wrong
            if lhsTotal == rhsTotal { return lhs.topic < rhs.topic }
            return lhsTotal > rhsTotal
        }
    }

    private func topicPerformance(for results: [ExamResult]) -> [TopicPerformance] {
        topicCounts(for: results).map { item in
            let total = item.correct + item.wrong
            return TopicPerformance(topic: item.topic, score: total == 0 ? 0 : Int((Double(item.correct) / Double(total) * 100).rounded()))
        }
        .sorted { lhs, rhs in
            if lhs.score == rhs.score { return lhs.topic < rhs.topic }
            return lhs.score < rhs.score
        }
    }

    private func iso8601String(from date: Date) -> String {
        ISO8601DateFormatter().string(from: date)
    }

    private func normalizedTopic(_ topic: String) -> String {
        let trimmedTopic = topic.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedTopic.isEmpty ? "General" : trimmedTopic
    }

    private func uniqueValues(_ values: [String]) -> [String] {
        var seen = Set<String>()
        var output: [String] = []
        for value in values where !seen.contains(value) {
            seen.insert(value)
            output.append(value)
        }
        return output
    }
}

struct AIInsightDisplayData {
    let summary: String
    let strengths: [String]
    let needsPractice: [String]
    let recommendations: [String]
    let suggestedDifficulty: String
    let generatedAt: String
    let tokensUsed: Int
    let remainingTokens: Int

    init(response: AIInsightResponseDTO) {
        summary = response.summary
        strengths = response.strengths
        needsPractice = response.needsPractice
        recommendations = response.recommendations
        suggestedDifficulty = response.suggestedDifficulty
        generatedAt = response.createdAt
        tokensUsed = response.usage?.tokensUsed ?? 0
        remainingTokens = response.usage?.remainingTokens ?? 0
    }

    init(insight: AIInsight) {
        summary = insight.summary
        strengths = insight.strengths
        needsPractice = insight.needsPractice
        recommendations = insight.recommendations
        suggestedDifficulty = insight.suggestedDifficulty
        generatedAt = DateFormatter.localizedString(from: insight.generatedAt, dateStyle: .medium, timeStyle: .short)
        tokensUsed = insight.tokensUsed
        remainingTokens = insight.remainingTokens
    }
}

struct AIInsightResultView: View {
    let insight: AIInsightDisplayData

    var body: some View {
        VStack(spacing: 16) {
            sectionCard(title: "Summary", icon: "lightbulb.fill") {
                Text(insight.summary)
                    .font(.title3.weight(.medium))
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            sectionCard(title: "Strengths", icon: "star.circle.fill") {
                InsightValueList(values: insight.strengths, emptyText: "No strengths returned yet.", color: .green)
            }

            sectionCard(title: "Needs Practice", icon: "target") {
                InsightValueList(values: insight.needsPractice, emptyText: "No practice areas returned yet.", color: .orange)
            }

            sectionCard(title: "Recommendations", icon: "checklist") {
                if insight.recommendations.isEmpty {
                    Text("No recommendations returned yet.")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.secondary)
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(insight.recommendations, id: \.self) { recommendation in
                            Label(recommendation, systemImage: "checkmark.circle.fill")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }

            sectionCard(title: "Next Step", icon: "arrow.up.forward.circle.fill") {
                VStack(alignment: .leading, spacing: 10) {
                    Label("Suggested difficulty: \(insight.suggestedDifficulty)", systemImage: "slider.horizontal.3")
                        .font(.title3.bold())
                        .foregroundStyle(.purple)
                    Text("Generated at: \(insight.generatedAt)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    if insight.tokensUsed > 0 || insight.remainingTokens > 0 {
                        Text("Tokens used: \(insight.tokensUsed) • Remaining: \(insight.remainingTokens)")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct InsightValueList: View {
    let values: [String]
    let emptyText: String
    let color: Color

    var body: some View {
        if values.isEmpty {
            Text(emptyText)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.secondary)
        } else {
            FlowTagList(values: values, color: color)
        }
    }
}

private struct TopicPerformance: Identifiable {
    let topic: String
    let score: Int

    var id: String { topic }
}

struct FlowTagList: View {
    let values: [String]
    let color: Color

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 110), spacing: 8)], alignment: .leading, spacing: 8) {
            ForEach(values, id: \.self) { value in
                Text(value)
                    .font(.caption.bold())
                    .foregroundStyle(color)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .background(color.opacity(0.14))
                    .clipShape(Capsule())
            }
        }
    }
}

struct ResultView: View {
    let result: ExamResult
    var usesKidTheme = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 12) {
                    Image(systemName: result.percentage >= 70 ? "star.circle.fill" : "heart.circle.fill").font(.system(size: 64)).foregroundStyle(result.percentage >= 70 ? .yellow : .pink)
                    Text("Great try, \(result.childName)!").font(.title.bold()).multilineTextAlignment(.center)
                    Text("Score: \(result.correctAnswers)/\(result.totalQuestions)").font(.largeTitle.bold())
                    Text("\(result.percentage)% • \(result.reportGrade)").font(.title2.bold()).foregroundStyle(.teal)
                    Text(result.feedback).font(.title3.weight(.medium)).multilineTextAlignment(.center).foregroundStyle(.secondary)
                }
                .padding(24)
                .background(usesKidTheme ? KidScholarTheme.cardSurface : ScholarTheme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .shadow(color: ScholarTheme.shadow, radius: 12, y: 6)
                QuestionReviewList(evaluations: result.evaluations, usesKidTheme: usesKidTheme)
            }
            .padding()
            .frame(maxWidth: 900)
            .frame(maxWidth: .infinity)
        }
        .background {
            if usesKidTheme {
                KidScholarBackground()
            } else {
                LittleScholarBackground()
            }
        }
        .navigationTitle("Exam Result")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct QuestionReviewList: View {
    let evaluations: [AnswerEvaluation]
    var usesKidTheme = false

    var body: some View {
        VStack(spacing: 12) {
            ForEach(evaluations) { item in
                VStack(alignment: .leading, spacing: 8) {
                    Label(item.isCorrect ? "Correct" : "Needs Practice", systemImage: item.isCorrect ? "checkmark.seal.fill" : "xmark.seal.fill").font(.headline).foregroundStyle(item.isCorrect ? .green : .red)
                    Text(item.question.prompt).font(.headline)
                    Text("Your answer: \(item.selectedAnswer)").foregroundStyle(item.isCorrect ? .green : .red)
                    if !item.isCorrect { Text("Correct answer: \(item.question.correctAnswer)") }
                    Text(item.question.explanation).font(.subheadline).foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(usesKidTheme ? KidScholarTheme.profileSurface : ScholarTheme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
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
                    .foregroundStyle(.orange)

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
                .foregroundStyle(.orange)
                .background(ScholarTheme.controlSurface)
                .clipShape(Circle())
                .accessibilityLabel("Logout")
            }

            Text("Parent setup, exam papers, kid attempts, performance, and AI insights")
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
                    .background(selectedMode == mode ? Color.orange : ScholarTheme.controlSurface)
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
        VStack(spacing: 10) { Image(systemName: icon).font(.system(size: 42)).foregroundStyle(.orange); Text(title).font(.title3.bold()).multilineTextAlignment(.center); Text(message).font(.subheadline.weight(.medium)).foregroundStyle(.secondary).multilineTextAlignment(.center) }.frame(maxWidth: .infinity).padding(.vertical, 18)
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
                    .foregroundStyle(.green)
                    .background(ScholarTheme.controlSurface.clipShape(Circle()))
            }
        }
        .accessibilityLabel(avatar.rawValue)
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
    var body: some View { row(icon: "doc.text.fill", title: "\(exam.childName) • \(exam.subject)", subtitle: "\(exam.difficulty) • \(exam.questions.count) questions", color: .teal) }
}

struct ExamStartRow: View {
    let exam: Exam
    var body: some View { row(icon: "book.fill", title: exam.subject, subtitle: "\(exam.difficulty) • \(exam.questions.count) questions • Start Exam", color: .teal) }
}

struct ResultHistoryRow: View {
    let result: ExamResult
    var body: some View { row(icon: "chart.bar.fill", title: "\(result.childName) • \(result.percentage)%", subtitle: "\(result.subject) • \(result.correctAnswers) correct, \(result.totalQuestions - result.correctAnswers) wrong", color: .orange) }
}

struct LatestResultBanner: View {
    let result: ExamResult
    var body: some View { NavigationLink { ResultView(result: result) } label: { row(icon: "star.circle.fill", title: "Latest Result", subtitle: "\(result.subject): \(result.percentage)% • \(result.reportGrade)", color: .yellow) }.buttonStyle(.plain).padding(.horizontal) }
}

struct HistorySummary: View {
    let results: [ExamResult]
    private var average: Int { results.isEmpty ? 0 : Int((Double(results.map(\.percentage).reduce(0, +)) / Double(results.count)).rounded()) }
    var body: some View { HStack(spacing: 12) { SummaryTile(title: "Exams Taken", value: "\(results.count)", color: .orange); SummaryTile(title: "Average", value: "\(average)%", color: .teal); SummaryTile(title: "Best", value: "\(results.map(\.percentage).max() ?? 0)%", color: .pink) } }
}

struct SummaryTile: View {
    let title: String
    let value: String
    let color: Color
    var body: some View { VStack(spacing: 6) { Text(value).font(.title2.bold()).foregroundStyle(color); Text(title).font(.caption.bold()).foregroundStyle(.secondary) }.frame(maxWidth: .infinity).padding(.vertical, 14).background(color.opacity(0.12)).clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous)) }
}

private extension View {
    func adaptiveContentWidth(maxWidth: CGFloat = 1180) -> some View {
        frame(maxWidth: maxWidth)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentView()
}
