//
//  WorkoutRepositoryTests.swift
//  WorkoutTests
//

import Foundation
import Testing
@testable import Workout

@MainActor
struct WorkoutRepositoryTests {

    @Test func initialStateIsIdle() {
        let repository = WorkoutRepository(loader: MockWorkoutDataLoading(summaries: []))
        #expect(repository.state == .idle)
    }

    @Test func loadSuccessExtractsSortedExercises() async throws {
        let summary = try TestSupport.workoutSummary(withExercises: [("e2", "Squat"), ("e1", "Bench")])
        let repository = WorkoutRepository(loader: MockWorkoutDataLoading(summaries: [summary]))

        await repository.load()

        #expect(repository.state == .loaded)
        #expect(repository.exercises.map(\.name) == ["Bench", "Squat"])
        #expect(repository.setSummaries.count == 2)
    }

    @Test func loadFailureSetsFailedState() async {
        let repository = WorkoutRepository(loader: MockWorkoutDataLoading(failure: .loadFailed))

        await repository.load()

        guard case .failed = repository.state else {
            Issue.record("Expected .failed, got \(repository.state)")
            return
        }
    }

    @Test func repeatedLoadAfterSuccessIsIgnored() async throws {
        let summary = try TestSupport.workoutSummary(withExercises: [("e1", "Bench")])
        let loader = MockWorkoutDataLoading(summaries: [summary])
        let repository = WorkoutRepository(loader: loader)

        await repository.load()
        await repository.load()

        #expect(loader.loadCount == 1)
    }

    @Test func retryAfterFailureSucceeds() async throws {
        let summary = try TestSupport.workoutSummary(withExercises: [("e1", "Bench")])
        let loader = MockWorkoutDataLoading([.failure(.loadFailed), .success([summary])])
        let repository = WorkoutRepository(loader: loader)

        await repository.load()
        await repository.load()

        #expect(repository.state == .loaded)
        #expect(loader.loadCount == 2)
    }
}
