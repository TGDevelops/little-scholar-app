//
//  little_scholarApp.swift
//  little-scholar
//
//  Created by Tejesh on 26/05/26.
//

import SwiftData
import SwiftUI

@main
struct little_scholarApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [ChildProfile.self, Exam.self, ExamResult.self, AIInsight.self])
    }
}
