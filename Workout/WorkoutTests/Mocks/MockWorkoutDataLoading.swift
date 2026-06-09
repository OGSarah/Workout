//
//  MockWorkoutDataLoading.swift
//  WorkoutTests
//
//  A scriptable ``WorkoutDataLoading`` that returns canned outcomes and records call counts, so the
//  repository's success, failure, idempotency, and retry paths can all be tested without a bundle.
//

import Foundation
@testable import Workout

final class MockWorkoutDataLoading: WorkoutDataLoading, @unchecked Sendable {

    enum MockError: Error, Equatable {
        case loadFailed
    }

    private let outcomes: [Result<[WorkoutSummary], MockError>]
    private(set) var loadCount = 0

    /// Each call to `loadSummaries()` returns the next outcome, repeating the last one once exhausted.
    init(_ outcomes: [Result<[WorkoutSummary], MockError>]) {
        self.outcomes = outcomes.isEmpty ? [.success([])] : outcomes
    }

    convenience init(summaries: [WorkoutSummary]) {
        self.init([.success(summaries)])
    }

    convenience init(failure: MockError = .loadFailed) {
        self.init([.failure(failure)])
    }

    func loadSummaries() async throws -> [WorkoutSummary] {
        defer { loadCount += 1 }
        let index = Swift.min(loadCount, outcomes.count - 1)
        return try outcomes[index].get()
    }
}
