//
//  ChartDataTests.swift
//  WorkoutTests
//

import Foundation
import Testing
@testable import Workout

struct ChartDataTests {

    private let now = TestSupport.date(2026, 2, 15)
    private var calendar: Calendar { TestSupport.utcCalendar }

    /// Regression test: the duration series previously filtered by the *first* summary's exercise
    /// id rather than the requested exercise, so it could plot the wrong exercise's data.
    @Test func seriesIncludesOnlyTheRequestedExercise() {
        let squat = Exercise.sample(id: "squat", name: "Squat")
        let bench = Exercise.sample(id: "bench", name: "Bench Press")

        let summaries = [
            TestSupport.setSummary(on: now, exercise: squat, duration: 60),
            TestSupport.setSummary(on: now, exercise: bench, duration: 99)
        ]

        let series = ChartData.series(
            from: summaries,
            exerciseID: "bench",
            metric: .duration,
            period: .year,
            now: now,
            calendar: calendar
        )

        #expect(series.count == 1)
        #expect(series.first?.value == 99)
    }

    @Test func seriesIsSortedByDateAscending() {
        let squat = Exercise.sample(id: "squat", name: "Squat")
        let summaries = [
            TestSupport.setSummary(on: TestSupport.date(2026, 2, 14), exercise: squat, reps: 12),
            TestSupport.setSummary(on: TestSupport.date(2026, 2, 10), exercise: squat, reps: 10),
            TestSupport.setSummary(on: TestSupport.date(2026, 2, 12), exercise: squat, reps: 11)
        ]

        let series = ChartData.series(
            from: summaries,
            exerciseID: "squat",
            metric: .reps,
            period: .month,
            now: now,
            calendar: calendar
        )

        #expect(series.map(\.value) == [10, 11, 12])
        #expect(series.map(\.date) == series.map(\.date).sorted())
    }

    @Test func seriesRespectsTimePeriod() {
        let squat = Exercise.sample(id: "squat", name: "Squat")
        let summaries = [
            TestSupport.setSummary(on: now, exercise: squat, weight: 100),
            TestSupport.setSummary(on: TestSupport.date(2025, 1, 1), exercise: squat, weight: 80) // outside the month
        ]

        let series = ChartData.series(
            from: summaries,
            exerciseID: "squat",
            metric: .weight,
            period: .month,
            now: now,
            calendar: calendar
        )

        #expect(series.count == 1)
        #expect(series.first?.value == 100)
    }
}
