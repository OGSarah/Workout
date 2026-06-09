//
//  ExerciseListViewModel.swift
//  Workout
//
//  Created by Sarah Clark on 2/20/25.
//

import Foundation
import Observation

/// Drives the searchable list of exercises.
@MainActor
@Observable
final class ExerciseListViewModel {
    var searchText: String = ""

    private let exercises: [Exercise]

    init(exercises: [Exercise]) {
        self.exercises = exercises
    }

    /// The exercises matching the current search text (all of them when the search is empty).
    var filteredExercises: [Exercise] {
        guard !searchText.isEmpty else { return exercises }
        return exercises.filter { exercise in
            exercise.name?.localizedCaseInsensitiveContains(searchText) ?? false
        }
    }
}
