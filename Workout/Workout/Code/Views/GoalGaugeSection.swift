//
//  GoalGaugeSection.swift
//  Workout
//
//  Created by Sarah Clark on 2/22/25.
//

import SwiftUI

struct GoalGaugeSection: View {
    @Binding var exercise: Exercise
    @Binding var showEditSheet: Bool
    let weightGradient = Gradient(colors: [.lightPink, .brightCoralRed, .pink])
    let repsGradient = Gradient(colors: [.lightYellow, .yellow, .darkYellow])
    let durationGradient = Gradient(colors: [.lightGreen, .brightLimeGreen, .green])

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "figure.strengthtraining.traditional")
                    .foregroundStyle(.gray)
                    .font(.subheadline)
                    .padding(.trailing, -5)
                Text("PERFORMANCE GOALS")
                    .foregroundStyle(.gray)
                    .font(.subheadline)
                Spacer()
                Button(action: {
                    showEditSheet.toggle()
                }, label: {
                    Text("Edit")
                })
            }
            .padding(.horizontal, 10)
            .padding(.top, 40)

            HStack(spacing: 40) {
                VStack(spacing: 10) {
                    // Weight
                    Gauge(value: 10, in: 0...100) {
                        Image(systemName: "heart.fill")
                    } currentValueLabel: {
                        Text("\(Int(10))%")
                    } minimumValueLabel: {
                        Text("\(Int(0))")
                            .font(.caption2)
                    } maximumValueLabel: {
                        Text("\(Int(100))")
                            .font(.caption2)
                    }
                    .gaugeStyle(.accessoryCircular)
                    .tint(weightGradient)
                    .scaleEffect(1.5)

                        Text("Weight(lbs)")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                            .lineLimit(1)
                }

                // Reps
                VStack(spacing: 10) {
                    Gauge(value: 55, in: 0...100) {
                        Text("Reps")
                    } currentValueLabel: {
                        Text("\(Int(55))%")
                            .font(.headline)
                    } minimumValueLabel: {
                        Text("\(Int(0))")
                            .font(.caption2)
                    } maximumValueLabel: {
                        Text("\(Int(10))")
                            .font(.caption2)
                    }
                    .gaugeStyle(.accessoryCircular)
                    .tint(repsGradient)
                    .scaleEffect(1.5)

                    Text("Reps")
                        .font(.callout)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                }

                // Duration
                VStack(spacing: 10) {
                    Gauge(value: 95, in: 0...100) {
                        Text("Duration(min)")
                    } currentValueLabel: {
                        Text("\(Int(95))%")
                            .font(.headline)
                    } minimumValueLabel: {
                        Text("\(Int(0))")
                            .font(.caption2)
                    } maximumValueLabel: {
                        Text("\(Int(90))")
                            .font(.caption2)
                    }
                    .gaugeStyle(.accessoryCircular)
                    .tint(durationGradient)
                    .scaleEffect(1.5)

                    Text("Duration(min)")
                        .font(.callout)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                        .lineLimit(1)
                        .minimumScaleFactor(0.9)
                }
            }
            .padding(.bottom, 20)
            .padding(.top, 50)
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .background {
                glassBackground
            }
            .padding(.bottom, 10)
            .padding(.top, -10)
        }
    }

    private var glassBackground: some View {
        RoundedRectangle(cornerRadius: 15)
            .fill(.ultraThinMaterial)
            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.5),
                                .white.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            }
            .overlay {
                // Subtle inner shadow
                RoundedRectangle(cornerRadius: 15)
                    .stroke(
                        .black.opacity(0.1),
                        lineWidth: 1
                    )
                    .blur(radius: 1)
                    .mask(RoundedRectangle(cornerRadius: 15).fill(.black))
            }
            .padding(.top, 10)
    }

    /*let maxValues = findMaxExerciseValues(from: summaries)

    print("Max Weight: \(maxValues.maxWeight ?? 0)")
    print("Max Reps: \(maxValues.maxReps ?? 0)")
    print("Max Time: \(maxValues.maxTime ?? 0)")*/

    // MARK: - Private functions

    func findMaxExerciseValues(from summaries: [ExerciseSetSummary]) -> (maxWeight: Float?, maxReps: Int?, maxTime: Int?) {
        // Initialize max values as nil
        var maxWeight: Float?
        var maxReps: Int?
        var maxTime: Int?

        // Iterate through all summaries to find maximum values
        for summary in summaries {
            // Update maxWeight if current weight is higher
            if let currentWeight = summary.weightUsed {
                if let existingMax = maxWeight {
                    maxWeight = max(existingMax, currentWeight)
                } else {
                    maxWeight = currentWeight
                }
            }

            // Update maxReps if current repsReported is higher
            if let currentReps = summary.repsCompleted {
                if let existingMax = maxReps {
                    maxReps = max(existingMax, currentReps)
                } else {
                    maxReps = currentReps
                }
            }

            // Update maxTime if current timeSpentActive is higher
            if let currentTime = summary.timeSpentActive {
                if let existingMax = maxTime {
                    maxTime = max(existingMax, currentTime)
                } else {
                    maxTime = currentTime
                }
            }
        }
        return (maxWeight: maxWeight, maxReps: maxReps, maxTime: maxTime)
    }

}

// MARK: - Preview
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
    GoalGaugeSection(
        exercise: .constant(sampleExercise),
        showEditSheet: .constant(false)
    )
    .preferredColorScheme(.light)
    .frame(width: 400, height: 200)
    .padding()
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
    GoalGaugeSection(
        exercise: .constant(sampleExercise),
        showEditSheet: .constant(false)
    )
    .preferredColorScheme(.dark)
    .frame(width: 400, height: 200)
    .padding()
}
