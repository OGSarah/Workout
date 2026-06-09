//
//  TimeWindowTests.swift
//  WorkoutTests
//

import Foundation
import Testing
@testable import Workout

struct TimeWindowTests {

    private let exercise = Exercise.sample(id: "e1", name: "Squat")
    private let now = TestSupport.date(2026, 2, 15)
    private var calendar: Calendar { TestSupport.utcCalendar }

    @Test func monthFilterKeepsOnlySameMonth() {
        let summaries = [
            TestSupport.setSummary(on: TestSupport.date(2026, 2, 3), exercise: exercise),  // same month
            TestSupport.setSummary(on: TestSupport.date(2026, 1, 28), exercise: exercise), // previous month
            TestSupport.setSummary(on: TestSupport.date(2026, 2, 27), exercise: exercise)  // same month
        ]

        let result = TimeWindow.filter(summaries, in: .month, now: now, calendar: calendar)
        #expect(result.count == 2)
    }

    @Test func yearFilterUsesRollingTwelveMonths() {
        let summaries = [
            TestSupport.setSummary(on: TestSupport.date(2025, 6, 1), exercise: exercise),  // within last year
            TestSupport.setSummary(on: TestSupport.date(2024, 12, 1), exercise: exercise), // older than a year
            TestSupport.setSummary(on: now, exercise: exercise)                            // today
        ]

        let result = TimeWindow.filter(summaries, in: .year, now: now, calendar: calendar)
        #expect(result.count == 2)
    }

    @Test func weekFilterExcludesDistantDates() {
        let summaries = [
            TestSupport.setSummary(on: now, exercise: exercise),                            // this week
            TestSupport.setSummary(on: TestSupport.date(2025, 12, 1), exercise: exercise)   // months ago
        ]

        let result = TimeWindow.filter(summaries, in: .week, now: now, calendar: calendar)
        #expect(result.count == 1)
    }

    @Test func axisDatesForYearReturnsTwelveMonthStartsOldestFirst() {
        let dates = TimeWindow.axisDates(for: .year, now: now, calendar: calendar)
        #expect(dates.count == 12)
        #expect(dates == dates.sorted())
    }

    @Test func axisDatesForSixMonthsReturnsSixMonthStarts() {
        let dates = TimeWindow.axisDates(for: .sixMonths, now: now, calendar: calendar)
        #expect(dates.count == 6)
        #expect(dates == dates.sorted())
    }
}
