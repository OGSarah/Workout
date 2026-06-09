//
//  TimeWindow.swift
//  Workout
//
//  Created by Sarah Clark on 2/22/25.
//

import Foundation

/// Pure date math for filtering set summaries into a ``TimePeriod`` and generating the matching
/// chart axis tick marks.
///
/// Every function takes `now` and `calendar` explicitly rather than reading `Date()` internally,
/// which keeps the logic deterministic and unit-testable.
enum TimeWindow {

    /// The set summaries whose date falls within `period`, relative to `now`.
    static func filter(
        _ summaries: [ExerciseSetSummary],
        in period: TimePeriod,
        now: Date,
        calendar: Calendar = .current
    ) -> [ExerciseSetSummary] {
        summaries.filter { summary in
            guard let date = summary.completedAt ?? summary.startedAt else { return false }
            switch period {
            case .week:
                return calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear)
            case .month:
                return calendar.isDate(date, equalTo: now, toGranularity: .month)
            case .sixMonths:
                guard let start = calendar.date(byAdding: .month, value: -6, to: now) else { return false }
                return date >= start && date <= now
            case .year:
                guard let start = calendar.date(byAdding: .year, value: -1, to: now) else { return false }
                return date >= start && date <= now
            }
        }
    }

    /// The dates used to place X-axis tick marks for `period`.
    static func axisDates(for period: TimePeriod, now: Date, calendar: Calendar = .current) -> [Date] {
        switch period {
        case .week: return weekDays(now: now, calendar: calendar)
        case .month: return weekStartsInMonth(now: now, calendar: calendar)
        case .sixMonths: return monthStarts(goingBack: 6, now: now, calendar: calendar)
        case .year: return monthStarts(goingBack: 12, now: now, calendar: calendar)
        }
    }

    /// The eight day boundaries spanning the current Monday-anchored week.
    static func weekDays(now: Date, calendar: Calendar = .current) -> [Date] {
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
        components.weekday = 2 // Monday
        guard let mondayStart = calendar.date(from: components) else { return [] }
        return (0...7).compactMap { calendar.date(byAdding: .day, value: $0, to: mondayStart) }
    }

    /// The start of each Monday within the current month.
    static func weekStartsInMonth(now: Date, calendar: Calendar = .current) -> [Date] {
        guard let monthRange = calendar.range(of: .day, in: .month, for: now),
              let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) else {
            return []
        }
        return monthRange.compactMap { day -> Date? in
            guard let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart),
                  calendar.component(.weekday, from: date) == 2 else { return nil }
            return date
        }
    }

    /// The first-of-month dates for the most recent `count` months, oldest first.
    static func monthStarts(goingBack count: Int, now: Date, calendar: Calendar = .current) -> [Date] {
        (0..<count).compactMap { offset -> Date? in
            guard let date = calendar.date(byAdding: .month, value: -offset, to: now) else { return nil }
            return calendar.date(from: calendar.dateComponents([.year, .month], from: date))
        }
        .reversed()
    }
}
