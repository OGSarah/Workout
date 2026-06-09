//
//  WorkoutTests.swift
//  WorkoutTests
//
//  Created by Sarah Clark on 2/19/25.
//

import Foundation
import Testing
@testable import Workout

/// Verifies the hand-written `Codable` conformances decode the bundled workout JSON correctly.
struct ModelDecodingTests {

    @Test func decodesWorkoutSummaryWithNestedSetAndExercise() throws {
        let json = """
        {
            "workout_id": "w1",
            "started_at": "2026-02-15T15:18:43.221Z",
            "average_heart_rate": 117,
            "set_summaries": [
                {
                    "set_id": "s1",
                    "reps_reported": 12,
                    "time_spent_active": 25,
                    "completed_at": "2026-02-15T15:29:47.268Z",
                    "set": {
                        "id": "s1",
                        "weight": 30,
                        "reps": 10,
                        "duration": 25,
                        "exercise": { "id": "e1", "name": "Bicep Curl" }
                    }
                }
            ]
        }
        """
        let summary = try JSONDecoder().decode(WorkoutSummary.self, from: Data(json.utf8))

        #expect(summary.workoutID == "w1")
        #expect(summary.averageHeartRate == 117)
        #expect(summary.startedAt != nil)
        #expect(summary.setSummaries.count == 1)

        let setSummary = try #require(summary.setSummaries.first)
        #expect(setSummary.repsReported == 12)
        #expect(setSummary.completedAt != nil)
        #expect(setSummary.exerciseSet?.weight == 30)
        #expect(setSummary.exerciseSet?.exercise?.name == "Bicep Curl")
        #expect(setSummary.exerciseSet?.exercise?.id == "e1")
    }

    @Test func ignoresPlaceholderDates() throws {
        let json = """
        { "workout_id": "w2", "started_at": "0001-01-01T00:00:00Z", "set_summaries": [] }
        """
        let summary = try JSONDecoder().decode(WorkoutSummary.self, from: Data(json.utf8))
        #expect(summary.startedAt == nil)
    }
}
