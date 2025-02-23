//
//  ExerciseDetailView.swift
//  Workout
//
//  Created by Sarah Clark on 2/21/25.
//

import SwiftUI

enum TimePeriod {
    case day, week, month, sixMonths, year
}

struct ExerciseDetailView: View {
    @State private var exercise: Exercise
    @State private var exerciseSetSummaries: [ExerciseSetSummary]
    @Environment(\.colorScheme) var colorScheme
    @State private var showEditSheet = false
    @State private var timePeriod: TimePeriod = .week

    private let backgroundGradient = LinearGradient(
        stops: [
            Gradient.Stop(color: .gray.opacity(0.6), location: 0),
            Gradient.Stop(color: .gray.opacity(0.3), location: 0.256),
            Gradient.Stop(color: .clear, location: 0.4)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    init(exercise: Exercise, exerciseSetSummaries: [ExerciseSetSummary]) {
        self.exercise = exercise
        self.exerciseSetSummaries = exerciseSetSummaries
    }

    // MARK: - Main View
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient
                    .ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .center, spacing: 20) {
                        GoalGaugeSection(exercise: $exercise, showEditSheet: $showEditSheet)

                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "clock")
                                    .foregroundStyle(.gray)
                                    .font(.subheadline)
                                    .padding(.trailing, -5)
                                Text("PERFORMANCE OVER TIME")
                                    .foregroundStyle(.gray)
                                    .font(.subheadline)
                            }

                            timePeriodPicker
                                .padding(.horizontal, -15)
                        }

                        WeightProgressChart(
                            exerciseSetSummaries: exerciseSetSummaries,
                            exerciseName: exercise.name ?? "No Exercise Name",
                            timePeriod: timePeriod
                        )
                        .padding(.horizontal, 10)
                        .padding(.top, 20)
                        .background {
                            glassBackground
                                .padding(.top, -10)
                        }

                        RepsProgressChart(
                            exerciseSetSummaries: exerciseSetSummaries,
                            exerciseName: exercise.name ?? "No Exercise Name",
                            timePeriod: timePeriod
                        )
                        .padding(.horizontal, 10)
                        .padding(.top, 20)
                        .background {
                            glassBackground
                        }

                        DurationProgressChart(
                            exerciseSetSummaries: exerciseSetSummaries,
                            exerciseName: exercise.name ?? "No Exercise Name",
                            timePeriod: timePeriod
                        )
                        .padding(.horizontal, 10)
                        .padding(.top, 20)
                        .background {
                            glassBackground
                        }
                    }
                    .padding(.horizontal)
                    .sheet(isPresented: $showEditSheet) {
                        EditExerciseGoalsSheet(exercise: $exercise, showEditSheet: $showEditSheet, onSave: { weight, reps, duration in
                            // Empty closure for preview purposes
                            print("Saved: Weight: \(weight), Reps: \(reps), Duration: \(duration)")
                        })
                    }
                }
            }
            .navigationTitle(exercise.name ?? "Empty Name")
        }
    }

    private var timePeriodPicker: some View {
        Picker("Time Period", selection: $timePeriod) {
            Text("Day").tag(TimePeriod.day)
            Text("Week").tag(TimePeriod.week)
            Text("Month").tag(TimePeriod.month)
            Text("6 Months").tag(TimePeriod.sixMonths)
            Text("Year").tag(TimePeriod.year)
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
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
                                .white.opacity(colorScheme == .dark ? 0.3 : 0.5),
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
    ExerciseDetailView(exercise: sampleExercise, exerciseSetSummaries: sampleSummaries)
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
    ExerciseDetailView(exercise: sampleExercise, exerciseSetSummaries: sampleSummaries)
        .preferredColorScheme(.dark)
}
