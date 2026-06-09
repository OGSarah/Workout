//
//  ContentView.swift
//  Workout
//
//  Created by Sarah Clark on 2/19/25.
//

import SwiftData
import SwiftUI

/// The app's root view. Loads workout data asynchronously and shows the exercise list once ready.
struct ContentView: View {
    @State private var repository = WorkoutRepository()

    var body: some View {
        Group {
            switch repository.state {
            case .idle, .loading:
                ProgressView("Loading workouts…")
                    .accessibilityIdentifier(AccessibilityIdentifiers.Root.loading)
            case .loaded:
                ExerciseListView(exercises: repository.exercises, setSummaries: repository.setSummaries)
            case .failed(let message):
                ContentUnavailableView {
                    Label("Couldn't Load Workouts", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(message)
                }
                .accessibilityIdentifier(AccessibilityIdentifiers.Root.loadFailure)
            }
        }
        .task { await repository.load() }
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    ContentView()
        .modelContainer(for: ExerciseGoal.self, inMemory: true)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ContentView()
        .modelContainer(for: ExerciseGoal.self, inMemory: true)
        .preferredColorScheme(.dark)
}
