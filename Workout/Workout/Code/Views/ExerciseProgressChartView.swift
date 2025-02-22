//
//  ExerciseProgressChartView.swift
//  Workout
//
//  Created by Sarah Clark on 2/21/25.
//

import Charts
import SwiftUI

struct ExerciseProgressChartView: View {
    let exerciseSetSummaries: [ExerciseSetSummary] // Data source
    let exerciseName: String // Filter by a specific exercise

    // Computed property to filter and prepare data for charting
    private var performanceData: [(date: Date, value: Double)] {
        exerciseSetSummaries
            .filter { $0.exerciseSet?.exercise?.name == exerciseName } // Filter by exercise name
            .compactMap { summary in
                guard let date = summary.completedAt ?? summary.startedAt else { return nil } // Use completion or start date
                let weight = summary.weightUsed ?? 0 // Default to 0 if nil
                let reps = Double(summary.repsCompleted ?? 0) // Convert to Double for chart
                let performanceValue = Double(weight) * reps // Example: weight * reps as performance metric
                return (date: date, value: performanceValue)
            }
            .sorted { $0.date < $1.date } // Sort by date
    }

    var body: some View {
        VStack(alignment: .center) {
            Chart {
                ForEach(performanceData, id: \.date) { dataPoint in
                    LineMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Performance", dataPoint.value)
                    )
                    .interpolationMethod(.catmullRom)
                    .symbol(Circle())
                    .symbolSize(30)
                    .foregroundStyle(Gradient(colors: [.blue, .blue.opacity(0.5)]))

                    AreaMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Performance", dataPoint.value)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(Gradient(colors: [.blue.opacity(0.2), .blue.opacity(0.05)]))
                }
            }
            .frame(height: 300)
            .chartYScale(domain: 0...maxPerformanceValue()) // Dynamic y-axis based on data
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let doubleValue = value.as(Double.self) {
                            Text("\(Int(doubleValue))") // Show performance as integer
                        }
                    }
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) {
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: .dateTime.weekday())
                }
            }
            .padding()
        }
        .cornerRadius(20)
        .shadow(radius: 10)
    }

    // Helper to determine max y-value for scaling
    private func maxPerformanceValue() -> Double {
        performanceData.map { $0.value }.max() ?? 100.0 // Default to 100 if no data
    }
}

/*
#Preview {
    let sampleSummaries = [
        ExerciseSetSummary(
            id: "1",
            exerciseSetID: "set1",
            workoutSummaryID: nil,
            startedAt: Date().addingTimeInterval(-86400 * 2), // 2 days ago
            completedAt: Date().addingTimeInterval(-86400 * 2),
            timeSpentActive: 60,
            weight: 20.0,
            repsReported: 10,
            exerciseSet: ExerciseSet(id: "set1", exercise: Exercise(id: "ex1", name: "Pushups"))
        ),
        ExerciseSetSummary(
            id: "2",
            exerciseSetID: "set2",
            workoutSummaryID: nil,
            startedAt: Date().addingTimeInterval(-86400), // 1 day ago
            completedAt: Date().addingTimeInterval(-86400),
            timeSpentActive: 60,
            weight: 25.0,
            repsReported: 12,
            exerciseSet: ExerciseSet(id: "set2", exercise: Exercise(id: "ex1", name: "Pushups"))
        ),
        ExerciseSetSummary(
            id: "3",
            exerciseSetID: "set3",
            workoutSummaryID: nil,
            startedAt: Date(), // Today
            completedAt: Date(),
            timeSpentActive: 60,
            weight: 30.0,
            repsReported: 15,
            exerciseSet: ExerciseSet(id: "set3", exercise: Exercise(id: "ex1", name: "Pushups"))
        )
    ]
    ExerciseProgressChartView(exerciseSetSummaries: sampleSummaries, exerciseName: "Pushups")
}

*/
