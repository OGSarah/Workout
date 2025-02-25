//
//  DurationProgressChart.swift
//  Workout
//
//  Created by Sarah Clark on 2/22/25.
//

import Charts
import SwiftUI

struct DurationProgressChart: View {
    let exerciseSetSummaries: [ExerciseSetSummary]
    let exerciseName: String
    let timePeriod: TimePeriod

    private var durationData: [(date: Date, value: Double)] {
        let filteredSummaries = filterSummariesByTimePeriod(exerciseSetSummaries, for: timePeriod)
        return filteredSummaries
            .filter { $0.exerciseSet?.exercise?.id == exerciseSetSummaries.first?.exerciseSet?.exercise?.id }
            .compactMap { summary -> (date: Date, value: Double)? in
                guard let date = summary.completedAt ?? summary.startedAt else { return nil }
                guard let time = summary.timeSpentActive.flatMap({ Double($0) }) else { return nil }
                return (date: date, value: time)
            }
            .sorted { $0.date < $1.date }
    }

    var body: some View {
        if !durationData.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text("Duration Progress (min)")
                    .font(.headline)
                    .padding(.horizontal)

                Chart {
                    ForEach(durationData, id: \.date) { dataPoint in
                        LineMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Duration", dataPoint.value)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(Color.brightLimeGreen)

                        PointMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Duration", dataPoint.value)
                        )
                        .symbol(Circle().strokeBorder(lineWidth: 2))
                        .symbolSize(CGSize(width: 10, height: 10))
                        .foregroundStyle(.green)
                    }
                }
                .chartYScale(domain: 0...maxValue(durationData))
                .chartXAxis {
                    switch timePeriod {
                    case .week:
                        AxisMarks(values: .stride(by: .day)) { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel {
                                if let date = value.as(Date.self) {
                                    Text(date, format: .dateTime.weekday(.abbreviated)) // e.g., "Mon"
                                }
                            }
                        }
                    case .month:
                        AxisMarks(values: weekStartDatesForMonth()) { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel {
                                if let date = value.as(Date.self) {
                                    Text(date, format: .dateTime.day()) // e.g., "3" for first Monday
                                }
                            }
                        }
                    case .sixMonths:
                        AxisMarks(values: monthStartDatesForSixMonths()) { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel {
                                if let date = value.as(Date.self) {
                                    Text(date, format: .dateTime.month(.abbreviated)) // e.g., "Feb"
                                }
                            }
                        }
                    case .year:
                        AxisMarks(values: monthStartDatesForYear()) { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel {
                                if let date = value.as(Date.self) {
                                    let monthName = date.formatted(.dateTime.month(.abbreviated))
                                    Text(monthName.prefix(1)) // e.g., "F" for February
                                }
                            }
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks { AxisGridLine(); AxisTick(); AxisValueLabel() }
                }
                .frame(height: 200)
                .padding()
                .cornerRadius(10)
            }
        }
    }

    private func maxValue(_ data: [(date: Date, value: Double)]) -> Double {
        (data.map { $0.value }.max() ?? 100.0) + 10.0
    }

    private func filterSummariesByTimePeriod(_ summaries: [ExerciseSetSummary], for period: TimePeriod) -> [ExerciseSetSummary] {
        let now = Date()
        return summaries.filter { summary in
            guard let date = summary.completedAt ?? summary.startedAt else { return false }
            switch period {
            case .week:
                return Calendar.current.isDate(date, equalTo: now, toGranularity: .weekOfYear)
            case .month:
                return Calendar.current.isDate(date, equalTo: now, toGranularity: .month)
            case .sixMonths:
                guard let sixMonthsAgo = Calendar.current.date(byAdding: .month, value: -6, to: now) else { return false }
                return date >= sixMonthsAgo && date <= now
            case .year:
                guard let yearAgo = Calendar.current.date(byAdding: .year, value: -1, to: now) else { return false }
                return date >= yearAgo && date <= now
            }
        }
    }

    private func weekStartDatesForMonth() -> [Date] {
        let calendar = Calendar.current
        let now = Date()
        guard let monthRange = calendar.range(of: .day, in: .month, for: now),
              let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) else { return [] }

        var dates: [Date] = []
        for day in monthRange {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart),
               calendar.component(.weekday, from: date) == 2 { // Monday = 2
                dates.append(date)
            }
        }
        return dates
    }

    private func monthStartDatesForSixMonths() -> [Date] {
        let calendar = Calendar.current
        let now = Date()
        var dates: [Date] = []
        for num in 0..<6 {
            if let date = calendar.date(byAdding: .month, value: -num, to: now),
               let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) {
                dates.append(monthStart)
            }
        }
        return dates.reversed()
    }

    private func monthStartDatesForYear() -> [Date] {
        let calendar = Calendar.current
        let now = Date()
        var dates: [Date] = []
        for num in 0..<12 {
            if let date = calendar.date(byAdding: .month, value: -num, to: now),
               let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) {
                dates.append(monthStart)
            }
        }
        return dates.reversed()
    }
}

// MARK: - Previews
#Preview("Light Mode - Week") {
    let sampleExercise = Exercise.sample(id: "ex1", name: "Pushups")
    let sampleSummaries = [
        ExerciseSetSummary.sample(
            id: "1",
            exerciseSetID: "set1",
            workoutSummaryID: nil,
            startedAt: Date().addingTimeInterval(-86400 * 2),
            completedAt: Date().addingTimeInterval(-86400 * 2),
            timeSpentActive: 60,
            weight: 20.0,
            repsReported: 10,
            exerciseSet: ExerciseSet.sample(id: "set1", exercise: sampleExercise, weight: 20.0, reps: 10, duration: 60)
        ),
        ExerciseSetSummary.sample(
            id: "2",
            exerciseSetID: "set2",
            workoutSummaryID: nil,
            startedAt: Date().addingTimeInterval(-86400),
            completedAt: Date().addingTimeInterval(-86400),
            timeSpentActive: 60,
            weight: 25.0,
            repsReported: 12,
            exerciseSet: ExerciseSet.sample(id: "set2", exercise: sampleExercise, weight: 25.0, reps: 12, duration: 60)
        ),
        ExerciseSetSummary.sample(
            id: "3",
            exerciseSetID: "set3",
            workoutSummaryID: nil,
            startedAt: Date(),
            completedAt: Date(),
            timeSpentActive: 60,
            weight: 30.0,
            repsReported: 15,
            exerciseSet: ExerciseSet.sample(id: "set3", exercise: sampleExercise, weight: 30.0, reps: 15, duration: 60)
        )
    ]
    return DurationProgressChart(
        exerciseSetSummaries: sampleSummaries,
        exerciseName: "Pushups",
        timePeriod: .week
    )
    .preferredColorScheme(.light)
}

#Preview("Dark Mode - Month") {
    let sampleExercise = Exercise.sample(id: "ex1", name: "Pushups")
    let sampleSummaries = [
        ExerciseSetSummary.sample(
            id: "1",
            exerciseSetID: "set1",
            workoutSummaryID: nil,
            startedAt: Date().addingTimeInterval(-86400 * 20),
            completedAt: Date().addingTimeInterval(-86400 * 20),
            timeSpentActive: 60,
            weight: 20.0,
            repsReported: 10,
            exerciseSet: ExerciseSet.sample(id: "set1", exercise: sampleExercise, weight: 20.0, reps: 10, duration: 60)
        ),
        ExerciseSetSummary.sample(
            id: "2",
            exerciseSetID: "set2",
            workoutSummaryID: nil,
            startedAt: Date().addingTimeInterval(-86400 * 10),
            completedAt: Date().addingTimeInterval(-86400 * 10),
            timeSpentActive: 60,
            weight: 25.0,
            repsReported: 12,
            exerciseSet: ExerciseSet.sample(id: "set2", exercise: sampleExercise, weight: 25.0, reps: 12, duration: 60)
        ),
        ExerciseSetSummary.sample(
            id: "3",
            exerciseSetID: "set3",
            workoutSummaryID: nil,
            startedAt: Date(),
            completedAt: Date(),
            timeSpentActive: 60,
            weight: 30.0,
            repsReported: 15,
            exerciseSet: ExerciseSet.sample(id: "set3", exercise: sampleExercise, weight: 30.0, reps: 15, duration: 60)
        )
    ]
    return DurationProgressChart(
        exerciseSetSummaries: sampleSummaries,
        exerciseName: "Pushups",
        timePeriod: .month
    )
    .preferredColorScheme(.dark)
}
