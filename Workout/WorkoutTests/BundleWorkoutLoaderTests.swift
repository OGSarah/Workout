//
//  BundleWorkoutLoaderTests.swift
//  WorkoutTests
//

import Foundation
import Testing
@testable import Workout

struct BundleWorkoutLoaderTests {

    @Test func loadsBundledSummariesFromHostApp() async throws {
        // The unit-test target is hosted by the app, so `Bundle.main` is the app bundle and contains
        // the shipped workout summaries.
        let loader = BundleWorkoutLoader()
        let summaries = try await loader.loadSummaries()
        #expect(!summaries.isEmpty)
    }

    @Test func throwsNoDataFoundForEmptyBundle() async throws {
        let tempDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempDirectory) }

        let emptyBundle = try #require(Bundle(path: tempDirectory.path))
        let loader = BundleWorkoutLoader(bundle: emptyBundle, subdirectory: "summaries")

        await #expect(throws: WorkoutDataError.self) {
            try await loader.loadSummaries()
        }
    }
}
