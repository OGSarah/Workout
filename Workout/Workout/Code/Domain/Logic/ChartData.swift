//
//  ChartData.swift
//  Workout
//
//  Created by Sarah Clark on 2/22/25.
//

import Foundation

/// A single plotted point: a value recorded on a date.
struct ChartPoint: Equatable, Identifiable {
    let date: Date
    let value: Double

    var id: Date { date }
}

/// Builds the time-ordered series a chart renders for one exercise and metric.
enum ChartData {

    /// The points for `metric` belonging to `exerciseID`, filtered to `period` and sorted by date.
    ///
    /// Filtering is keyed on the exercise's stable `id` so a chart never mixes in data from a
    /// different exercise that happens to share a name.
    static func series(
        from summaries: [ExerciseSetSummary],
        exerciseID: String,
        metric: ProgressMetric,
        period: TimePeriod,
        now: Date,
        calendar: Calendar = .current
    ) -> [ChartPoint] {
        TimeWindow.filter(summaries, in: period, now: now, calendar: calendar)
            .filter { $0.exerciseSet?.exercise?.id == exerciseID }
            .compactMap { summary -> ChartPoint? in
                guard let date = summary.completedAt ?? summary.startedAt,
                      let value = metric.value(from: summary) else { return nil }
                return ChartPoint(date: date, value: value)
            }
            .sorted { $0.date < $1.date }
    }
}
