//
//  ExerciseDetailView.swift
//  Workout
//
//  Created by Sarah Clark on 2/21/25.
//

import SwiftUI

struct ExerciseDetailView: View {
    private let exercise: Exercise

    init(exercise: Exercise) {
        self.exercise = exercise
    }

    var body: some View {
        Text(exercise.name ?? "No Exercise Name")
            .navigationTitle(exercise.name ?? "Details")
    }
}

// Helper to create an Exercise from JSON data for preview
extension Exercise {
    static func sample(id: String, name: String) -> Exercise {
        let json = """
        {
            "id": "\(id)",
            "name": "\(name)"
        }
        """
        let data = json.data(using: .utf8)!
        return try! JSONDecoder().decode(Exercise.self, from: data)
    }
}

#Preview("Light Mode") {
    let exercise = Exercise.sample(id: UUID().uuidString, name: "Pushups") // Use memberwise initializer
    ExerciseDetailView(exercise: exercise)
        .navigationTitle(exercise.name ?? "Details")
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let exercise = Exercise.sample(id: UUID().uuidString, name: "Pushups") // Use memberwise initializer
    ExerciseDetailView(exercise: exercise)
        .navigationTitle(exercise.name ?? "Details")
        .preferredColorScheme(.dark)
}
