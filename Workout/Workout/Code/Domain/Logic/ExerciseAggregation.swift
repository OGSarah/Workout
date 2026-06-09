//
//  ExerciseAggregation.swift
//  Workout
//
//  Created by Sarah Clark on 2/22/25.
//

import Foundation

/// Derives exercise-level information from the raw workout summaries.
enum ExerciseAggregation {

    /// The unique exercises found across `summaries`, de-duplicated by name and sorted
    /// alphabetically. Exercises without a name are kept and sorted last.
    static func extractExercises(from summaries: [WorkoutSummary]) -> [Exercise] {
        var exercises: [Exercise] = []
        var seenNames: Set<String> = []

        for summary in summaries {
            for setSummary in summary.setSummaries {
                guard let exercise = setSummary.exerciseSet?.exercise else { continue }
                if let name = exercise.name {
                    if seenNames.insert(name).inserted {
                        exercises.append(exercise)
                    }
                } else {
                    exercises.append(exercise)
                }
            }
        }

        return exercises.sorted(by: isOrderedByName)
    }

    /// The greatest recorded value of `metric` for the given exercise across `summaries`.
    static func maxValue(
        of metric: ProgressMetric,
        forExerciseID exerciseID: String,
        in summaries: [ExerciseSetSummary]
    ) -> Double? {
        summaries
            .filter { $0.exerciseSet?.exercise?.id == exerciseID }
            .compactMap { metric.value(from: $0) }
            .max()
    }

    /// Alphabetical ordering that places unnamed exercises last.
    private static func isOrderedByName(_ lhs: Exercise, _ rhs: Exercise) -> Bool {
        switch (lhs.name, rhs.name) {
        case let (left?, right?): return left < right
        case (nil, _): return false
        case (_, nil): return true
        }
    }
}
