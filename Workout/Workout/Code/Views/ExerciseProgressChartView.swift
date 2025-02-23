//
//  ExerciseProgressChartView.swift
//  Workout
//
//  Created by Sarah Clark on 2/21/25.
//

import Charts
import SwiftUI

struct ExerciseProgressChartView: View {
    let exerciseSetSummaries: [ExerciseSetSummary]
    let exerciseName: String

    // Data for Weight over time.
    private var weightData: [(date: Date, value: Double)] {
        exerciseSetSummaries
            .filter { $0.exerciseSet?.exercise?.name == exerciseName }
            .compactMap { summary in
                guard let date = summary.completedAt ?? summary.startedAt else { return nil }
                guard let weight = summary.weightUsed?.doubleValue ?? summary.exerciseSet?.weight?.doubleValue else { return nil }
                return (date: date, value: Double(weight))
            }
            .sorted { $0.date < $1.date } // Sort by date
    }

    // Data for Reps over time.
    private var repsData: [(date: Date, value: Double)] {
        exerciseSetSummaries
            .filter { $0.exerciseSet?.exercise?.name == exerciseName }
            .compactMap { summary in
                guard let date = summary.completedAt ?? summary.startedAt else { return nil }
                // Safely unwrap the optional Int to get an optional Double
                guard let reps = (summary.repsCompleted ?? summary.exerciseSet?.reps).flatMap({ Double($0) }) else { return nil }
                return (date: date, value: reps)
            }
            .sorted { $0.date < $1.date } // Sort by date
    }

    // Data for Time Spent Active over time.
    private var timeSpentActiveData: [(date: Date, value: Double)] {
        exerciseSetSummaries
            .filter { $0.exerciseSet?.exercise?.name == exerciseName }
            .compactMap { summary in
                guard let date = summary.completedAt ?? summary.startedAt else { return nil }
                // Safely unwrap the optional Int to get an optional Double
                guard let time = summary.timeSpentActive.flatMap({ Double($0) }) else { return nil }
                return (date: date, value: time)
            }
            .sorted { $0.date < $1.date } // Sort by date
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if !weightData.isEmpty {
                Text("Weight Progress (lbs)")
                    .font(.headline)
                    .padding(.horizontal)

                Chart {
                    ForEach(weightData, id: \.date) { dataPoint in
                        LineMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Weight", dataPoint.value)
                        )
                        .interpolationMethod(.catmullRom)
                        .symbol(Circle())
                        .symbolSize(30)
                        .foregroundStyle(Gradient(colors: [.red, .red.opacity(0.5)])) // Changed to red for weight

                        AreaMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Weight", dataPoint.value)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(Gradient(colors: [.red.opacity(0.2), .red.opacity(0.05)]))
                    }
                }
                .frame(height: 200)
                .chartYScale(domain: 0...maxValue(weightData)) // Dynamic y-axis based on weight data
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
                                Text("\(Int(doubleValue))") // Show weight as integer
                            }
                        }
                    }
                }
                .padding()
                .cornerRadius(10)
                .shadow(radius: 5)
            }

            if !repsData.isEmpty {
                Text("Reps Progress")
                    .font(.headline)
                    .padding(.horizontal)

                Chart {
                    ForEach(repsData, id: \.date) { dataPoint in
                        LineMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Reps", dataPoint.value)
                        )
                        .interpolationMethod(.catmullRom)
                        .symbol(Circle())
                        .symbolSize(30)
                        .foregroundStyle(Gradient(colors: [.yellow, .yellow.opacity(0.5)])) // Changed to yellow for reps

                        AreaMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Reps", dataPoint.value)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(Gradient(colors: [.yellow.opacity(0.2), .yellow.opacity(0.05)]))
                    }
                }
                .frame(height: 200)
                .chartYScale(domain: 0...maxValue(repsData)) // Dynamic y-axis based on reps data
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
                                Text("\(Int(doubleValue))") // Show reps as integer
                            }
                        }
                    }
                }
                .padding()
                .cornerRadius(10)
                .shadow(radius: 5)
            }

            if !timeSpentActiveData.isEmpty {
                Text("Time Spent Active Progress (min)")
                    .font(.headline)
                    .padding(.horizontal)

                Chart {
                    ForEach(timeSpentActiveData, id: \.date) { dataPoint in
                        LineMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Time", dataPoint.value)
                        )
                        .interpolationMethod(.catmullRom)
                        .symbol(Circle())
                        .symbolSize(30)
                        .foregroundStyle(Gradient(colors: [.green, .green.opacity(0.5)])) // Changed to green for time

                        AreaMark(
                            x: .value("Date", dataPoint.date),
                            y: .value("Time", dataPoint.value)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(Gradient(colors: [.green.opacity(0.2), .green.opacity(0.05)]))
                    }
                }
                .frame(height: 200)
                .chartYScale(domain: 0...maxValue(timeSpentActiveData)) // Dynamic y-axis based on time data
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
                                Text("\(Int(doubleValue))") // Show time as integer
                            }
                        }
                    }
                }
                .padding()
                .cornerRadius(10)
                .shadow(radius: 5)
            }

            if weightData.isEmpty && repsData.isEmpty && timeSpentActiveData.isEmpty {
                Text("No progress data available for \(exerciseName)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding()
            }
        }
    }

    // Helper to determine max y-value for scaling
    private func maxValue(_ data: [(date: Date, value: Double)]) -> Double {
        data.map { $0.value }.max() ?? 100.0 // Default to 100 if no data
    }
}

// MARK: - Extensions for Double Conversion (since weight is Float in ExerciseSetSummary)
extension Float {
    var doubleValue: Double? {
        Double(self)
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
            startedAt: Date().addingTimeInterval(-86400 * 2), // 2 days ago
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
            startedAt: Date().addingTimeInterval(-86400), // 1 day ago
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
            startedAt: Date(), // Today
            completedAt: Date(),
            timeSpentActive: 60,
            weight: 30.0,
            repsReported: 15,
            exerciseSet: ExerciseSet.sample(id: "set3", exercise: sampleExercise)
        )
    ]
    ExerciseProgressChartView(exerciseSetSummaries: sampleSummaries, exerciseName: "Pushups")
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    let sampleExercise = Exercise.sample(id: "ex1", name: "Pushups")
    let sampleSummaries = [
        ExerciseSetSummary.sample(
            id: "1",
            exerciseSetID: "set1",
            workoutSummaryID: nil,
            startedAt: Date().addingTimeInterval(-86400 * 2), // 2 days ago
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
            startedAt: Date().addingTimeInterval(-86400), // 1 day ago
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
            startedAt: Date(), // Today
            completedAt: Date(),
            timeSpentActive: 60,
            weight: 30.0,
            repsReported: 15,
            exerciseSet: ExerciseSet.sample(id: "set3", exercise: sampleExercise)
        )
    ]
    ExerciseProgressChartView(exerciseSetSummaries: sampleSummaries, exerciseName: "Pushups")
        .preferredColorScheme(.dark)
}
