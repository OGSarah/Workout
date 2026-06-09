//
//  ExerciseListViewModelTests.swift
//  WorkoutTests
//

import Foundation
import Testing
@testable import Workout

@MainActor
struct ExerciseListViewModelTests {

    private let exercises = [
        Exercise.sample(id: "1", name: "Bench Press"),
        Exercise.sample(id: "2", name: "Squat"),
        Exercise.sample(id: "3", name: "Deadlift")
    ]

    @Test func emptySearchReturnsAllExercises() {
        let viewModel = ExerciseListViewModel(exercises: exercises)
        #expect(viewModel.filteredExercises.count == exercises.count)
    }

    @Test func searchFiltersByName() {
        let viewModel = ExerciseListViewModel(exercises: exercises)
        viewModel.searchText = "Squat"
        #expect(viewModel.filteredExercises.map(\.name) == ["Squat"])
    }

    @Test func searchIsCaseInsensitive() {
        let viewModel = ExerciseListViewModel(exercises: exercises)
        viewModel.searchText = "squat"
        #expect(viewModel.filteredExercises.map(\.name) == ["Squat"])
    }

    @Test func searchMatchesSubstrings() {
        let viewModel = ExerciseListViewModel(exercises: exercises)
        viewModel.searchText = "ea"
        #expect(viewModel.filteredExercises.map(\.name) == ["Deadlift"])
    }

    @Test func searchWithNoMatchesReturnsEmpty() {
        let viewModel = ExerciseListViewModel(exercises: exercises)
        viewModel.searchText = "rowing"
        #expect(viewModel.filteredExercises.isEmpty)
    }
}
