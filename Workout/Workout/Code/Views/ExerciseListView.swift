//
//  ExerciseListView.swift
//  Workout
//
//  Created by Sarah Clark on 2/20/25.
//

import SwiftUI

struct ExerciseListView: View {
    @State private var exercises: [Exercise] = []
    let workoutsController: WorkoutsController

    init(workoutsController: WorkoutsController) {
        self.workoutsController = workoutsController
        _exercises = .init(initialValue: Self.extractExercises(from: workoutsController.workoutSummaries))
    }

    var body: some View {
        ForEach(exercises) { exercise in
            Text(exercise.name ?? "no exercise name")
                .foregroundStyle(.red)
        }
    }

    private static func extractExercises(from workoutSummaries: [WorkoutSummary]) -> [Exercise] {
        var exercises: [Exercise] = []
        var seenNames: Set<String> = []

        // Collect and deduplicate exercises by name
        for summary in workoutSummaries {
            for setSummary in summary.setSummaries {
                if let exerciseSet = setSummary.exerciseSet,
                   let exercise = exerciseSet.exercise,
                   let name = exercise.name { // Only consider exercises with a name
                    if seenNames.insert(name).inserted {
                        exercises.append(exercise)
                    }
                } else if let exerciseSet = setSummary.exerciseSet,
                          let exercise = exerciseSet.exercise {
                    // Include exercises with nil names as unique entries
                    exercises.append(exercise)
                }
            }
        }

        // Sort alphabetically by name, with nil names at the end.
        return exercises.sorted { (lhs, rhs) in
            switch (lhs.name, rhs.name) {
                case let (left?, right?):
                    return left < right // Compare non-nil names alphabetically
                case (nil, _):
                    return false // nil goes to the end
                case (_, nil):
                    return true // non-nil comes before nil
            }
        }
    }

}

// MARK: - Previews
#Preview("Light Mode") {
    let workoutsController = WorkoutsController()
    ExerciseListView(workoutsController: workoutsController)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let workoutsController = WorkoutsController()
    ExerciseListView(workoutsController: workoutsController)
        .preferredColorScheme(.dark)
}
