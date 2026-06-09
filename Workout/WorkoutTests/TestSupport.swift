//
//  TestSupport.swift
//  WorkoutTests
//
//  Shared helpers for building deterministic fixtures.
//

import Foundation
@testable import Workout

enum TestSupport {

    /// A fixed UTC Gregorian calendar so date math in tests is deterministic across machines.
    static var utcCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }

    /// Builds a UTC date from its components.
    static func date(_ year: Int, _ month: Int, _ day: Int, hour: Int = 12, minute: Int = 0) -> Date {
        utcCalendar.date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minute))!
    }

    /// A set summary recorded on `date` for the given exercise, decoded from JSON so every metric
    /// source (set weight/reps/duration and the reported values) is populated.
    static func setSummary(
        on date: Date,
        exercise: Exercise,
        weight: Float? = nil,
        reps: Int? = nil,
        duration: Int? = nil
    ) -> ExerciseSetSummary {
        let iso = ISO8601DateFormatter().string(from: date)
        let nameField = exercise.name.map { "\"name\":\"\($0)\"," } ?? ""

        var setFields = "\"id\":\"set-\(exercise.id)\",\"exercise\":{\(nameField)\"id\":\"\(exercise.id)\"}"
        if let weight { setFields += ",\"weight\":\(weight)" }
        if let reps { setFields += ",\"reps\":\(reps)" }
        if let duration { setFields += ",\"duration\":\(duration)" }

        var summaryFields = "\"set_id\":\"set-\(exercise.id)\",\"started_at\":\"\(iso)\",\"completed_at\":\"\(iso)\""
        if let reps { summaryFields += ",\"reps_reported\":\(reps)" }
        if let duration { summaryFields += ",\"time_spent_active\":\(duration)" }

        let json = "{\(summaryFields),\"set\":{\(setFields)}}"
        // Force-try is acceptable in test support: a malformed fixture is a test authoring error.
        // swiftlint:disable:next force_try
        return try! JSONDecoder().decode(ExerciseSetSummary.self, from: Data(json.utf8))
    }

    /// Decodes a `WorkoutSummary` containing one set summary per supplied exercise.
    static func workoutSummary(withExercises exercises: [(id: String, name: String?)]) throws -> WorkoutSummary {
        let sets = exercises.enumerated().map { index, exercise -> String in
            let nameField = exercise.name.map { "\"name\":\"\($0)\"," } ?? ""
            return "{\"set_id\":\"s\(index)\",\"set\":{\"id\":\"s\(index)\",\"exercise\":{\(nameField)\"id\":\"\(exercise.id)\"}}}"
        }
        .joined(separator: ",")
        let json = "{\"workout_id\":\"w\",\"set_summaries\":[\(sets)]}"
        return try JSONDecoder().decode(WorkoutSummary.self, from: Data(json.utf8))
    }
}
