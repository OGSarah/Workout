//
//  WorkoutDataLoading.swift
//  Workout
//
//  Created by Sarah Clark on 2/19/25.
//

import Foundation

/// Loads the workout summaries that drive the app.
///
/// Abstracting the source behind a protocol lets the UI run against the bundled JSON in production
/// and against lightweight fixtures in tests and previews.
protocol WorkoutDataLoading {
    func loadSummaries() async throws -> [WorkoutSummary]
}

/// Errors surfaced while loading workout data.
enum WorkoutDataError: LocalizedError {
    case noDataFound

    var errorDescription: String? {
        switch self {
        case .noDataFound:
            return "No workout data could be found."
        }
    }
}
