//
//  MockGoalStore.swift
//  WorkoutTests
//
//  An in-memory ``GoalStoreProtocol`` for exercising view models without SwiftData.
//

import Foundation
@testable import Workout

@MainActor
final class MockGoalStore: GoalStoreProtocol {
    private var goals: [String: ExerciseGoal] = [:]
    private(set) var upsertCount = 0

    init(seeded: [ExerciseGoal] = []) {
        for goal in seeded { goals[goal.exerciseID] = goal }
    }

    func allGoals() -> [ExerciseGoal] {
        Array(goals.values)
    }

    func goal(forExerciseID exerciseID: String) -> ExerciseGoal? {
        goals[exerciseID]
    }

    @discardableResult
    func upsert(exerciseID: String, weight: Double, reps: Int, duration: Int) -> ExerciseGoal {
        upsertCount += 1
        if let existing = goals[exerciseID] {
            existing.weight = weight
            existing.reps = reps
            existing.duration = duration
            return existing
        }
        let goal = ExerciseGoal(exerciseID: exerciseID, weight: weight, reps: reps, duration: duration)
        goals[exerciseID] = goal
        return goal
    }
}
