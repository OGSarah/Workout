//
//  ExerciseListView.swift
//  Workout
//
//  Created by Sarah Clark on 2/20/25.
//

import SwiftUI

struct ExerciseListView: View {
    @State private var exercises: [Exercise] = []
    @State private var searchText: String = ""
    let workoutsController: WorkoutsController
    @Binding var goalWeight: Double
    @Binding var goalReps: Int
    @Binding var goalDuration: Int

    private let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .gray.opacity(0.6), location: 0),
            Gradient.Stop(color: .gray.opacity(0.3), location: 0.256),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    init(
        workoutsController: WorkoutsController,
        goalWeight: Binding<Double>,
        goalReps: Binding<Int>,
        goalDuration: Binding<Int>
    ) {
        self.workoutsController = workoutsController
        self._exercises = .init(initialValue: Self.extractExercises(from: workoutsController.workoutSummaries))
        self._goalWeight = goalWeight
        self._goalReps = goalReps
        self._goalDuration = goalDuration

        // Make the search field a custom color
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
            .backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredExercises) { exercise in
                    NavigationLink {
                        ExerciseDetailView(
                            exercise: exercise,
                            exerciseSetSummaries: workoutsController.workoutSummaries.flatMap { $0.setSummaries },
                            goalWeight: $goalWeight,
                            goalReps: $goalReps,
                            goalDuration: $goalDuration
                        )
                    } label: {
                        Text(exercise.name ?? "no exercise name")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle(Text("Exercises"))
            .searchable(text: $searchText, prompt: "Search")
            .background(backgroundGradient)
            .scrollContentBackground(.hidden)
        }
    }

    private var filteredExercises: [Exercise] {
        if searchText.isEmpty {
            return exercises
        } else {
            return exercises.filter { exercise in
                exercise.name?.localizedCaseInsensitiveContains(searchText) ?? false
            }
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

        // Sort alphabetically by name, with nil names at the end
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
    ExerciseListView(
        workoutsController: workoutsController,
        goalWeight: .constant(100.0),
        goalReps: .constant(20),
        goalDuration: .constant(90)
    )
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let workoutsController = WorkoutsController()
    ExerciseListView(
        workoutsController: workoutsController,
        goalWeight: .constant(100.0),
        goalReps: .constant(20),
        goalDuration: .constant(90)
    )
    .preferredColorScheme(.dark)
}
