//
//  GoalStore.swift
//  Workout
//
//  Created by Sarah Clark on 2/22/25.
//

import Foundation
import SwiftData

/// Reads and writes ``ExerciseGoal`` records.
///
/// The single place in the app that touches a `ModelContext`, keeping SwiftData access on the main
/// actor and out of the views and view models' way.
@MainActor
final class GoalStore {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    /// Every stored goal.
    func allGoals() -> [ExerciseGoal] {
        (try? context.fetch(FetchDescriptor<ExerciseGoal>())) ?? []
    }

    /// The stored goal for an exercise, if one exists.
    ///
    /// The goal set is tiny (one record per exercise), so a fetch-and-filter is both fast enough
    /// and simpler than a `#Predicate`-based query.
    func goal(forExerciseID exerciseID: String) -> ExerciseGoal? {
        allGoals().first { $0.exerciseID == exerciseID }
    }

    /// Inserts or updates the goal for an exercise and persists the change.
    @discardableResult
    func upsert(exerciseID: String, weight: Double, reps: Int, duration: Int) -> ExerciseGoal {
        let resolved: ExerciseGoal
        if let existing = goal(forExerciseID: exerciseID) {
            existing.weight = weight
            existing.reps = reps
            existing.duration = duration
            resolved = existing
        } else {
            resolved = ExerciseGoal(exerciseID: exerciseID, weight: weight, reps: reps, duration: duration)
            context.insert(resolved)
        }
        save()
        return resolved
    }

    private func save() {
        do {
            try context.save()
        } catch {
            assertionFailure("Failed to save goal: \(error)")
        }
    }
}
