//
//  WeightProgressChart.swift
//  Workout
//
//  Created by Sarah Clark on 2/22/25.
//

import Charts
import SwiftUI

struct WeightProgressChart: View {
    let exerciseSetSummaries: [ExerciseSetSummary]
    let exerciseName: String
    let timePeriod: TimePeriod

    private var maxValuePlusTen: Double {
        (weightData.map { $0.value }.max() ?? 0) + 10.0
    }

    private var weightData: [(date: Date, value: Double)] {
        let filteredSummaries = filterSummariesByTimePeriod(exerciseSetSummaries, for: timePeriod)
        return filteredSummaries
            .filter { $0.exerciseSet?.exercise?.name == exerciseName }
            .compactMap { summary -> (date: Date, value: Double)? in
                guard let date = summary.completedAt ?? summary.startedAt else { return nil }
                guard let weightFloat = summary.weightUsed ?? summary.exerciseSet?.weight else { return nil }
                // Convert Float to optional Double
                guard let weight = Double(exactly: weightFloat) else { return nil }
                return (date: date, value: weight)
            }
            .sorted { $0.date < $1.date }
    }

    var body: some View {
        if !weightData.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Text("Weight Progress (lbs)")
                    .font(.headline)
                    .padding(.horizontal)

                Chart {
                    ForEach(weightData, id: \.date) { dataPoint in
                        BarMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Weight", dataPoint.value)
                        )
                        .foregroundStyle(Gradient(colors: [.red, .red.opacity(0.5)]))
                    }
                        RuleMark(y: .value("Goal", 35))
                            .foregroundStyle(.teal)
                            .lineStyle(StrokeStyle(lineWidth: 4, dash: [5]))
                }
                .frame(height: 300)
                .chartYScale(domain: 0...maxValuePlusTen)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) {
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel(format: .dateTime.weekday())
                    }
                }
                .chartYAxis {
                    AxisMarks { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel {
                            if let doubleValue = value.as(Double.self) {
                                Text("\(Int(doubleValue))")
                            }
                        }
                    }
                }
                .padding()
                .cornerRadius(10)
            }
        }
    }

    private func maxValue(_ data: [(date: Date, value: Double)]) -> Double {
        data.map { $0.value }.max() ?? 100.0
    }

    private func filterSummariesByTimePeriod(_ summaries: [ExerciseSetSummary], for period: TimePeriod) -> [ExerciseSetSummary] {
        let now = Date()
        return summaries.filter { summary in
            guard let date = summary.completedAt ?? summary.startedAt else { return false }
            switch period {
            case .day:
                return Calendar.current.isDate(date, inSameDayAs: now)
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

}

// MARK: - Previews
#Preview("Light Mode") {
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
            exerciseSet: ExerciseSet.sample(id: "set1", exercise: sampleExercise)
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
    WeightProgressChart(
        exerciseSetSummaries: sampleSummaries,
        exerciseName: "Pushups",
        timePeriod: .week
    )
    .preferredColorScheme(.light)
    .padding(20)
}

#Preview("Dark Mode") {
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
            exerciseSet: ExerciseSet.sample(id: "set1", exercise: sampleExercise)
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
    WeightProgressChart(
        exerciseSetSummaries: sampleSummaries,
        exerciseName: "Pushups",
        timePeriod: .week
    )
    .preferredColorScheme(.dark)
    .padding(20)
}
