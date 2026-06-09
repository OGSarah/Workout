//
//  ProgressMetric.swift
//  Workout
//
//  Created by Sarah Clark on 2/22/25.
//

import Foundation

/// A trackable dimension of an exercise's performance.
///
/// Each metric knows how to read its value from an ``ExerciseSetSummary``, which keeps the
/// extraction logic in one place for both the gauges and the charts.
enum ProgressMetric: CaseIterable, Sendable {
    case weight
    case reps
    case duration

    /// The value for this metric in a single set summary, or `nil` when it isn't recorded.
    func value(from summary: ExerciseSetSummary) -> Double? {
        switch self {
        case .weight:
            return summary.exerciseSet?.weight.map(Double.init)
        case .reps:
            return summary.repsCompleted.map(Double.init)
        case .duration:
            return summary.timeSpentActive.map(Double.init)
        }
    }
}
