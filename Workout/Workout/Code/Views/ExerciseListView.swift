//
//  ExerciseListView.swift
//  Workout
//
//  Created by Sarah Clark on 2/20/25.
//

import SwiftUI

/// A searchable list of exercises that pushes to a detail screen for each one.
struct ExerciseListView: View {
    @State private var viewModel: ExerciseListViewModel
    private let setSummaries: [ExerciseSetSummary]

    private let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .gray.opacity(0.6), location: 0),
            Gradient.Stop(color: .gray.opacity(0.3), location: 0.256),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    init(exercises: [Exercise], setSummaries: [ExerciseSetSummary]) {
        _viewModel = State(initialValue: ExerciseListViewModel(exercises: exercises))
        self.setSummaries = setSummaries
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack {
            List {
                ForEach(viewModel.filteredExercises) { exercise in
                    NavigationLink {
                        ExerciseDetailView(exercise: exercise, setSummaries: setSummaries)
                    } label: {
                        Text(exercise.name ?? "Unnamed Exercise")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Exercises")
            .searchable(text: $viewModel.searchText, prompt: "Search")
            .background(backgroundGradient)
            .scrollContentBackground(.hidden)
            .accessibilityIdentifier("exerciseList")
        }
    }
}

// MARK: - Previews
#Preview("Light Mode") {
    ExerciseListView(exercises: PreviewData.exercises, setSummaries: PreviewData.setSummaries)
        .modelContainer(for: ExerciseGoal.self, inMemory: true)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ExerciseListView(exercises: PreviewData.exercises, setSummaries: PreviewData.setSummaries)
        .modelContainer(for: ExerciseGoal.self, inMemory: true)
        .preferredColorScheme(.dark)
}
