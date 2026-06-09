//
//  GoalStoreTests.swift
//  WorkoutTests
//

import Foundation
import SwiftData
import Testing
@testable import Workout

@Suite(.serialized)
struct GoalStoreTests {

    @MainActor
    private func makeStore() throws -> GoalStore {
        let container = try ModelContainer(
            for: ExerciseGoal.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        return GoalStore(context: ModelContext(container))
    }

    @Test func goalIsNilBeforeAnythingIsSaved() async throws {
        try await MainActor.run {
            let store = try makeStore()
            #expect(store.goal(forExerciseID: "squat") == nil)
        }
    }

    @Test func upsertThenFetchReturnsStoredValues() async throws {
        try await MainActor.run {
            let store = try makeStore()
            store.upsert(exerciseID: "squat", weight: 225, reps: 5, duration: 0)

            let goal = try #require(store.goal(forExerciseID: "squat"))
            #expect(goal.weight == 225)
            #expect(goal.reps == 5)
            #expect(goal.duration == 0)
        }
    }

    @Test func secondUpsertUpdatesInsteadOfDuplicating() async throws {
        try await MainActor.run {
            let store = try makeStore()
            store.upsert(exerciseID: "squat", weight: 225, reps: 5, duration: 0)
            store.upsert(exerciseID: "squat", weight: 250, reps: 3, duration: 0)

            #expect(store.allGoals().count == 1)
            let goal = try #require(store.goal(forExerciseID: "squat"))
            #expect(goal.weight == 250)
            #expect(goal.reps == 3)
        }
    }

    @Test func goalsForDifferentExercisesAreIndependent() async throws {
        try await MainActor.run {
            let store = try makeStore()
            store.upsert(exerciseID: "squat", weight: 225, reps: 5, duration: 0)
            store.upsert(exerciseID: "bench", weight: 185, reps: 8, duration: 0)

            #expect(store.goal(forExerciseID: "squat")?.weight == 225)
            #expect(store.goal(forExerciseID: "bench")?.weight == 185)
        }
    }
}
