import Foundation

struct ExamGeneratorService {
    func generateExam(for profile: ChildProfile, subject: Subject, difficulty: Difficulty, numberOfQuestions: Int) -> Exam {
        Exam(
            childProfileID: profile.profileID,
            childName: profile.name,
            grade: profile.grade,
            subject: subject,
            difficulty: difficulty,
            questions: questions(grade: profile.grade, subject: subject, difficulty: difficulty, count: numberOfQuestions)
        )
    }

    private func questions(grade: String, subject: Subject, difficulty: Difficulty, count: Int) -> [Question] {
        let source = bank(for: grade, subject: subject, difficulty: difficulty)
        let repeats = max(1, Int(ceil(Double(count) / Double(source.count))))
        let expanded = Array(repeating: source, count: repeats).flatMap { $0 }
        return Array(expanded.prefix(count)).map { question in
            Question(prompt: question.prompt, options: question.options, correctAnswer: question.correctAnswer, explanation: question.explanation)
        }
    }

    private func bank(for grade: String, subject: Subject, difficulty: Difficulty) -> [Question] {
        switch subject {
        case .math:
            mathQuestions(difficulty: difficulty)
        case .english:
            englishQuestions(difficulty: difficulty)
        case .science:
            scienceQuestions(difficulty: difficulty)
        case .generalKnowledge:
            generalKnowledgeQuestions(difficulty: difficulty)
        }
    }

    private func mathQuestions(difficulty: Difficulty) -> [Question] {
        switch difficulty {
        case .easy:
            [
                Question(prompt: "What is 2 + 3?", options: ["4", "5", "6", "7"], correctAnswer: "5", explanation: "Counting 2 more after 3 gives 5."),
                Question(prompt: "Which shape has 3 sides?", options: ["Circle", "Square", "Triangle", "Rectangle"], correctAnswer: "Triangle", explanation: "A triangle always has 3 sides."),
                Question(prompt: "What number comes after 9?", options: ["8", "10", "11", "12"], correctAnswer: "10", explanation: "The next counting number after 9 is 10.")
            ]
        case .medium:
            [
                Question(prompt: "What is 6 + 7?", options: ["11", "12", "13", "14"], correctAnswer: "13", explanation: "6 + 7 equals 13."),
                Question(prompt: "What is 15 - 6?", options: ["7", "8", "9", "10"], correctAnswer: "9", explanation: "Taking 6 away from 15 leaves 9."),
                Question(prompt: "How many tens are in 40?", options: ["2", "3", "4", "5"], correctAnswer: "4", explanation: "40 is the same as 4 groups of ten.")
            ]
        case .hard:
            [
                Question(prompt: "What is 8 x 4?", options: ["24", "28", "32", "36"], correctAnswer: "32", explanation: "8 groups of 4 make 32."),
                Question(prompt: "What is half of 30?", options: ["10", "15", "20", "25"], correctAnswer: "15", explanation: "Half means two equal parts, and 30 divided by 2 is 15."),
                Question(prompt: "A box has 3 rows of 5 stars. How many stars are there?", options: ["8", "12", "15", "20"], correctAnswer: "15", explanation: "3 rows times 5 stars in each row equals 15.")
            ]
        }
    }

    private func englishQuestions(difficulty: Difficulty) -> [Question] {
        switch difficulty {
        case .easy:
            [
                Question(prompt: "Which word rhymes with cat?", options: ["bat", "dog", "sun", "pen"], correctAnswer: "bat", explanation: "Cat and bat end with the same sound."),
                Question(prompt: "Which letter starts the word apple?", options: ["A", "B", "C", "D"], correctAnswer: "A", explanation: "Apple begins with the letter A."),
                Question(prompt: "Choose the noun.", options: ["run", "happy", "ball", "blue"], correctAnswer: "ball", explanation: "A noun names a person, place, or thing. Ball is a thing.")
            ]
        case .medium:
            [
                Question(prompt: "Choose the correct sentence.", options: ["She run fast.", "She runs fast.", "She running fast.", "She runned fast."], correctAnswer: "She runs fast.", explanation: "She runs fast uses the correct verb form."),
                Question(prompt: "What is the opposite of cold?", options: ["hot", "wet", "slow", "small"], correctAnswer: "hot", explanation: "Hot is the opposite of cold."),
                Question(prompt: "Which word is an adjective?", options: ["jump", "bright", "table", "sing"], correctAnswer: "bright", explanation: "Bright describes a noun, so it is an adjective.")
            ]
        case .hard:
            [
                Question(prompt: "Pick the word with a prefix.", options: ["redo", "table", "green", "paper"], correctAnswer: "redo", explanation: "Re- is a prefix that means to do again."),
                Question(prompt: "Which sentence uses punctuation correctly?", options: ["Where are you going.", "Where are you going?", "Where are you going,", "Where are you going"], correctAnswer: "Where are you going?", explanation: "A question should end with a question mark."),
                Question(prompt: "Choose the synonym for tiny.", options: ["huge", "little", "loud", "quick"], correctAnswer: "little", explanation: "Tiny and little mean almost the same thing.")
            ]
        }
    }

    private func scienceQuestions(difficulty: Difficulty) -> [Question] {
        switch difficulty {
        case .easy:
            [
                Question(prompt: "What do plants need to grow?", options: ["Sunlight", "Shoes", "Pencils", "Blankets"], correctAnswer: "Sunlight", explanation: "Plants use sunlight to make food."),
                Question(prompt: "Which animal can fly?", options: ["Fish", "Bird", "Cow", "Frog"], correctAnswer: "Bird", explanation: "Most birds have wings and can fly."),
                Question(prompt: "What do we breathe in?", options: ["Oxygen", "Sand", "Juice", "Paper"], correctAnswer: "Oxygen", explanation: "People breathe oxygen from the air.")
            ]
        case .medium:
            [
                Question(prompt: "Which sense uses your ears?", options: ["Smell", "Taste", "Hearing", "Touch"], correctAnswer: "Hearing", explanation: "Ears help us hear sounds."),
                Question(prompt: "What is water when it freezes?", options: ["Steam", "Ice", "Cloud", "Rain"], correctAnswer: "Ice", explanation: "Frozen water becomes ice."),
                Question(prompt: "Which part of a plant takes in water?", options: ["Flower", "Leaf", "Root", "Fruit"], correctAnswer: "Root", explanation: "Roots take in water from soil.")
            ]
        case .hard:
            [
                Question(prompt: "Which planet is known as the Red Planet?", options: ["Mars", "Venus", "Jupiter", "Mercury"], correctAnswer: "Mars", explanation: "Mars is called the Red Planet because of its reddish surface."),
                Question(prompt: "What force pulls objects toward Earth?", options: ["Sound", "Gravity", "Light", "Heat"], correctAnswer: "Gravity", explanation: "Gravity pulls objects toward Earth."),
                Question(prompt: "What do bees help flowers do?", options: ["Pollinate", "Freeze", "Melt", "Hide"], correctAnswer: "Pollinate", explanation: "Bees move pollen between flowers, helping them make seeds.")
            ]
        }
    }

    private func generalKnowledgeQuestions(difficulty: Difficulty) -> [Question] {
        switch difficulty {
        case .easy:
            [
                Question(prompt: "How many days are in a week?", options: ["5", "6", "7", "8"], correctAnswer: "7", explanation: "There are 7 days in one week."),
                Question(prompt: "Which color is the sun usually drawn as?", options: ["Yellow", "Purple", "Black", "Green"], correctAnswer: "Yellow", explanation: "The sun is often shown as yellow in drawings."),
                Question(prompt: "What do you use to write on paper?", options: ["Pencil", "Spoon", "Sock", "Plate"], correctAnswer: "Pencil", explanation: "A pencil is used for writing and drawing.")
            ]
        case .medium:
            [
                Question(prompt: "Which meal do many people eat in the morning?", options: ["Dinner", "Breakfast", "Snack", "Dessert"], correctAnswer: "Breakfast", explanation: "Breakfast is the morning meal."),
                Question(prompt: "Which place has many books?", options: ["Library", "Pool", "Garden", "Kitchen"], correctAnswer: "Library", explanation: "A library stores books for reading and borrowing."),
                Question(prompt: "What should you do before crossing a road?", options: ["Run fast", "Look both ways", "Close your eyes", "Drop your bag"], correctAnswer: "Look both ways", explanation: "Looking both ways helps you cross safely.")
            ]
        case .hard:
            [
                Question(prompt: "Which instrument has black and white keys?", options: ["Piano", "Drum", "Flute", "Guitar"], correctAnswer: "Piano", explanation: "A piano has rows of black and white keys."),
                Question(prompt: "Which tool tells direction?", options: ["Compass", "Clock", "Ruler", "Thermometer"], correctAnswer: "Compass", explanation: "A compass points toward directions like north."),
                Question(prompt: "What is a group of stars forming a pattern called?", options: ["Constellation", "Mountain", "Island", "River"], correctAnswer: "Constellation", explanation: "A constellation is a pattern of stars in the sky.")
            ]
        }
    }
}
