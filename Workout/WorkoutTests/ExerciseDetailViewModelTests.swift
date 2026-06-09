//
//  ExerciseDetailViewModelTests.swift
//  WorkoutTests
//

import Foundation
import Testing
@testable import Workout

@MainActor
struct ExerciseDetailViewModelTests {

    private let exercise = Exercise.sample(id: "ex1", name: "Bicep Curl")
    private let now = TestSupport.date(2026, 3, 15)

    /// Two sets for the exercise: weights 100 then 120, reps 10 then 15, durations 20 then 30.
    private func makeSummaries() -> [ExerciseSetSummary] {
        [
            TestSupport.setSummary(on: TestSupport.date(2026, 3, 14), exercise: exercise, weight: 100, reps: 10, duration: 20),
            TestSupport.setSummary(on: now, exercise: exercise, weight: 120, reps: 15, duration: 30)
        ]
    }

    @Test func hasNoGoalsBeforeConnecting() {
        let viewModel = ExerciseDetailViewModel(exercise: exercise, setSummaries: [], now: now)
        #expect(viewModel.hasGoals == false)
    }

    @Test func connectLoadsStoredGoals() {
        let store = MockGoalStore()
        store.upsert(exerciseID: exercise.id, weight: 200, reps: 20, duration: 60)

        let viewModel = ExerciseDetailViewModel(exercise: exercise, setSummaries: [], now: now)
        viewModel.connect(to: store)

        #expect(viewModel.hasGoals)
        #expect(viewModel.goalWeight == 200)
        #expect(viewModel.goalReps == 20)
        #expect(viewModel.goalDuration == 60)
    }

    @Test func currentMaxValuesComeFromSetSummaries() {
        let viewModel = ExerciseDetailViewModel(exercise: exercise, setSummaries: makeSummaries(), now: now)
        #expect(viewModel.currentMaxWeight == 120)
        #expect(viewModel.currentMaxReps == 15)
        #expect(viewModel.currentMaxDuration == 30)
    }

    @Test func progressPercentagesUseGoalAndCurrentMax() {
        let store = MockGoalStore()
        store.upsert(exerciseID: exercise.id, weight: 200, reps: 30, duration: 60)

        let viewModel = ExerciseDetailViewModel(exercise: exercise, setSummaries: makeSummaries(), now: now)
        viewModel.connect(to: store)

        #expect(viewModel.weightProgress == 60)   // 120 / 200
        #expect(viewModel.repsProgress == 50)     // 15 / 30
        #expect(viewModel.durationProgress == 50) // 30 / 60
    }

    @Test func goalLineIsNilWhenNoGoalSet() {
        let viewModel = ExerciseDetailViewModel(exercise: exercise, setSummaries: [], now: now)
        #expect(viewModel.goalLine(for: .weight) == nil)
    }

    @Test func goalLineReflectsStoredGoal() {
        let store = MockGoalStore()
        store.upsert(exerciseID: exercise.id, weight: 150, reps: 0, duration: 0)
        let viewModel = ExerciseDetailViewModel(exercise: exercise, setSummaries: [], now: now)
        viewModel.connect(to: store)
        #expect(viewModel.goalLine(for: .weight) == 150)
        #expect(viewModel.goalLine(for: .reps) == nil)
    }

    @Test func savingGoalsPersistsDraftViaStore() {
        let store = MockGoalStore()
        let viewModel = ExerciseDetailViewModel(exercise: exercise, setSummaries: [], now: now)
        viewModel.connect(to: store)

        viewModel.startEditingGoals()
        #expect(viewModel.isEditingGoals)
        viewModel.draftWeight = 80
        viewModel.draftReps = 12
        viewModel.draftDuration = 40
        viewModel.saveGoals()

        #expect(viewModel.isEditingGoals == false)
        #expect(viewModel.goalWeight == 80)
        #expect(store.goal(forExerciseID: exercise.id)?.weight == 80)
    }

    @Test func cancelEditingDoesNotPersist() {
        let store = MockGoalStore()
        let viewModel = ExerciseDetailViewModel(exercise: exercise, setSummaries: [], now: now)
        viewModel.connect(to: store)

        viewModel.startEditingGoals()
        viewModel.draftWeight = 999
        viewModel.cancelEditingGoals()

        #expect(viewModel.isEditingGoals == false)
        #expect(viewModel.goalWeight == 0)
        #expect(store.goal(forExerciseID: exercise.id) == nil)
    }

    @Test func seriesContainsPointsWithinPeriod() {
        let viewModel = ExerciseDetailViewModel(exercise: exercise, setSummaries: makeSummaries(), now: now)
        viewModel.timePeriod = .year
        #expect(viewModel.series(for: .weight).count == 2)
    }

    @Test func axisDatesMatchTimeWindow() {
        let viewModel = ExerciseDetailViewModel(exercise: exercise, setSummaries: [], now: now)
        viewModel.timePeriod = .year
        #expect(viewModel.axisDates == TimeWindow.axisDates(for: .year, now: now))
    }
}
