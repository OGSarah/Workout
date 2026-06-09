//
//  BundleWorkoutLoader.swift
//  Workout
//
//  Created by Sarah Clark on 2/19/25.
//

import Foundation

/// Loads workout summaries from JSON resources bundled with the app.
///
/// Resource discovery happens on the caller's executor (it is cheap), while the file reads and JSON
/// decoding are moved off the main thread so the UI never blocks while data loads.
struct BundleWorkoutLoader: WorkoutDataLoading {
    private let bundle: Bundle
    private let subdirectory: String?

    init(bundle: Bundle = .main, subdirectory: String? = "summaries") {
        self.bundle = bundle
        self.subdirectory = subdirectory
    }

    func loadSummaries() async throws -> [WorkoutSummary] {
        let urls = resourceURLs()
        guard !urls.isEmpty else { throw WorkoutDataError.noDataFound }

        return try await Task.detached(priority: .userInitiated) {
            try Self.decodeSummaries(at: urls)
        }.value
    }

    /// All bundled `.json` resources, preferring the `summaries` subdirectory but falling back to
    /// the bundle root in case the resources are copied flat.
    ///
    /// The subdirectory probe can return an empty (non-nil) array when the folder doesn't exist, so
    /// we fall back on emptiness rather than only on `nil`.
    private func resourceURLs() -> [URL] {
        if let subdirectory,
           let urls = bundle.urls(forResourcesWithExtension: "json", subdirectory: subdirectory),
           !urls.isEmpty {
            return urls
        }
        return bundle.urls(forResourcesWithExtension: "json", subdirectory: nil) ?? []
    }

    /// Reads and decodes each URL. File-read failures propagate; a file that simply isn't a workout
    /// summary is skipped so unrelated JSON can't break loading.
    ///
    /// `nonisolated` so the heavy file reads and decoding run off the main actor inside `Task.detached`.
    private nonisolated static func decodeSummaries(at urls: [URL]) throws -> [WorkoutSummary] {
        let decoder = JSONDecoder()
        return try urls.compactMap { url in
            let data = try Data(contentsOf: url)
            return try? decoder.decode(WorkoutSummary.self, from: data)
        }
    }
}
