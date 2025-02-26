//
//  RepsProgressChart.swift
//  Workout
//
//  Created by Sarah Clark on 2/22/25.
//

import Charts
import SwiftUI

struct RepsProgressChart: View {
    let exerciseSetSummaries: [ExerciseSetSummary]
    let exerciseName: String
    let timePeriod: TimePeriod

    @AppStorage("exerciseGoals") private var exerciseGoalsData: Data = Data()

    private var repsData: [(date: Date, value: Double)] {
        let filteredSummaries = filterSummariesByTimePeriod(exerciseSetSummaries, for: timePeriod)
        return filteredSummaries
            .filter { $0.exerciseSet?.exercise?.name == exerciseName }
            .compactMap { summary -> (date: Date, value: Double)? in
                guard let date = summary.completedAt ?? summary.startedAt else { return nil }
                guard let reps = (summary.repsCompleted ?? summary.exerciseSet?.reps).flatMap({ Double($0) }) else { return nil }
                return (date: date, value: reps)
            }
            .sorted { $0.date < $1.date }
    }

    private var maxValuePlusTen: Double {
        if goalReps > 0 {
            return Double(goalReps) + 10.0
        } else {
            return Double(repsData.map { $0.value }.max() ?? 0) + 10.0
        }
    }

    private var goalReps: Int {
        if let data = try? JSONDecoder().decode([String: ExerciseGoals].self, from: exerciseGoalsData),
           let goals = data[exerciseName] {
            return Int(goals.reps)
        }
        return 0
    }

    // MARK: - Main View
    var body: some View {
        if !repsData.isEmpty && repsData.contains(where: { $0.value != 0 }) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Reps Progress")
                    .font(.headline)
                    .padding(.horizontal)

                Chart {
                    ForEach(repsData, id: \.date) { dataPoint in
                        BarMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Reps", dataPoint.value)
                        )
                        .foregroundStyle(.yellow)
                        RuleMark(y: .value("Goal", goalReps))
                            .foregroundStyle(.teal)
                            .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
                            .annotation(position: .top, alignment: .trailing) {
                                Text("Goal: \(goalReps)")
                                    .font(.caption)
                                    .foregroundColor(.teal)
                                    .padding(2)
                                    .background(Color.teal.opacity(0.1))
                                    .cornerRadius(4)
                            }
                    }
                }
                .frame(height: 200)
                .chartYScale(domain: 0...maxValuePlusTen)
                .chartXAxis {
                    switch timePeriod {
                    case .week:
                        AxisMarks(values: allWeekDays()) { value in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel {
                                if let date = value.as(Date.self) {
                                    Text(date, format: .dateTime.weekday(.abbreviated))
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
                .padding()
                .cornerRadius(10)
            }
        } else {
            ContentUnavailableView("No reps data for this time period.",
                                   systemImage: "chart.bar.xaxis",
                                   description: Text("Try another time period."))
        }
    }

    // MARK: - Private Functions
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

    private func allWeekDays() -> [Date] {
        let calendar = Calendar.current
        let now = Date()
        // Get the start of the week (Monday) by finding the previous Sunday and adding 1 day
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
        components.weekday = 2 // Monday (Sunday = 1, Monday = 2, etc.)
        guard let mondayStart = calendar.date(from: components) else { return [] }
        return (0...7).compactMap { calendar.date(byAdding: .day, value: $0, to: mondayStart) }
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
#Preview("Light Mode") {
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
            exerciseSet: ExerciseSet.sample(id: "set1", exercise: sampleExercise)
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
            exerciseSet: ExerciseSet.sample(id: "set2", exercise: sampleExercise)
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
            exerciseSet: ExerciseSet.sample(id: "set3", exercise: sampleExercise)
        )
    ]
    return RepsProgressChart(
        exerciseSetSummaries: sampleSummaries,
        exerciseName: "Pushups",
        timePeriod: .month
    )
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
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
            exerciseSet: ExerciseSet.sample(id: "set1", exercise: sampleExercise)
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
            exerciseSet: ExerciseSet.sample(id: "set2", exercise: sampleExercise)
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
            exerciseSet: ExerciseSet.sample(id: "set3", exercise: sampleExercise)
        )
    ]
    return RepsProgressChart(
        exerciseSetSummaries: sampleSummaries,
        exerciseName: "Pushups",
        timePeriod: .month
    )
    .preferredColorScheme(.dark)
}
