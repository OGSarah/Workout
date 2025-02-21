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

        for summary in workoutSummaries {
            for setSummary in summary.setSummaries {
                if let exerciseSet = setSummary.exerciseSet,
                   let exercise = exerciseSet.exercise {
                    exercises.append(exercise)
                }
            }
        }

        let uniqueExercises = Array(NSOrderedSet(array: exercises.map { $0.id })
            .compactMap { id in exercises.first { $0.id == id as! String } })

        return uniqueExercises
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
