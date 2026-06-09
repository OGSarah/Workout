//
//  WorkoutRepository.swift
//  Workout
//
//  Created by Sarah Clark on 2/19/25.
//

import Foundation
import Observation

/// The app's source of workout data.
///
/// Owns the loaded summaries and the derived exercise list, exposes a simple load lifecycle for the
/// UI to observe, and runs loading asynchronously off the main thread via its ``WorkoutDataLoading``.
@MainActor
@Observable
final class WorkoutRepository {

    /// The lifecycle of the initial data load.
    enum LoadState: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    private(set) var state: LoadState = .idle
    private(set) var exercises: [Exercise] = []
    private(set) var setSummaries: [ExerciseSetSummary] = []

    private let loader: WorkoutDataLoading

    init(loader: WorkoutDataLoading = BundleWorkoutLoader()) {
        self.loader = loader
    }

    /// Loads workout data once. Repeated calls after a successful load are ignored.
    func load() async {
        guard state == .idle || isFailed else { return }
        state = .loading
        do {
            let summaries = try await loader.loadSummaries()
            exercises = ExerciseAggregation.extractExercises(from: summaries)
            setSummaries = summaries.flatMap(\.setSummaries)
            state = .loaded
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    private var isFailed: Bool {
        if case .failed = state { return true }
        return false
    }
}
