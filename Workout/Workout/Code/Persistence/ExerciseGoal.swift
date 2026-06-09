//
//  ExerciseGoal.swift
//  Workout
//
//  Created by Sarah Clark on 2/22/25.
//

import Foundation
import SwiftData

/// A client's performance goals for a single exercise, persisted with SwiftData.
///
/// Keyed by the exercise's stable `id` rather than its name, which can be `nil` or duplicated.
@Model
final class ExerciseGoal {
    @Attribute(.unique) var exerciseID: String
    var weight: Double
    var reps: Int
    var duration: Int

    init(exerciseID: String, weight: Double = 0, reps: Int = 0, duration: Int = 0) {
        self.exerciseID = exerciseID
        self.weight = weight
        self.reps = reps
        self.duration = duration
    }

    /// Whether no meaningful goal has been set yet.
    var isUnset: Bool {
        weight <= 0 && reps <= 0 && duration <= 0
    }
}
